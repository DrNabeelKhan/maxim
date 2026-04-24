---
description: Scheduled task runner — usage-aware scheduler that respects Claude usage limits and pauses work when thresholds are exceeded.
---

# /mxm-tasks

## Usage
- Claude Code: `/mxm-tasks`
- Claude CLI: `claude "/mxm-tasks"`
- Claude Desktop: type `/mxm-tasks` in chat

Manages the global task list across all projects. Reads `.mxm-global/TASKS.md` and project manifests to suggest, schedule, and execute tasks.

## Behavior

### Mode 1 — View tasks (default: `/mxm-tasks`)
1. Read `.mxm-global/TASKS.md`
2. Display active tasks grouped by priority (P1 first)
3. For each task: project name, due date, recommended Claude tool
4. Suggest next task based on: priority x due date x project health

### Mode 2 — Add task (`/mxm-tasks add "description" --project PROJECT_ID`)
1. Parse task description and project ID
2. Auto-detect priority from keywords (urgent=P1, soon=P2, backlog=P3)
3. Suggest due date based on task type
4. Append to `.mxm-global/TASKS.md`
5. Ask: "Schedule this? (Claude Scheduled Tasks / Dispatch / skip)"

### Mode 3 — Next task (`/mxm-tasks next`)
1. Read `.mxm-global/TASKS.md`
2. Read each project's `.mxm-executive-summary/CONTEXT.md` (if exists)
3. Read each project's `config/project-manifest.json` for health signals
4. Recommend the single highest-impact task to do right now
5. Output: task, project, why now, which Claude tool, estimated time

### Mode 4 — Schedule (`/mxm-tasks schedule TASK_NUMBER`)
1. Read task #TASK_NUMBER from `.mxm-global/TASKS.md`
2. Determine scheduling method based on task type:

   **For recurring tasks (e.g., "Weekly investor update"):**
   ```
   Use mcp__scheduled-tasks__create_scheduled_task with:
     taskId: "mxm-task-{TASK_NUMBER}"
     cronExpression: [derived from task frequency — "0 9 * * 1" for weekly Monday]
     prompt: [full task prompt including project context files to read]
     description: [task description from TASKS.md]
   ```

   **For one-time tasks with a due date:**
   ```
   Use mcp__scheduled-tasks__create_scheduled_task with:
     taskId: "mxm-task-{TASK_NUMBER}"
     fireAt: [ISO 8601 timestamp from due date, default 9am local]
     prompt: [full task prompt including project context files to read]
     description: [task description from TASKS.md]
   ```

   **For background/delegated tasks:**
   Generate a Dispatch-ready prompt:
   ```
   Read .mxm-global/GLOBAL-CONTEXT.md and .mxm-global/TASKS.md
   Read {project_path}/.mxm-executive-summary/CONTEXT.md
   Read {project_path}/config/project-manifest.json
   Execute: [task description]
   Save outputs to {project_path}/.mxm-executive-summary/logs/
   ```

3. Update `.mxm-global/TASKS.md` status to "scheduled"
4. Output confirmation:
   ```
   Task #{TASK_NUMBER} scheduled
     Method : Scheduled Task / Dispatch
     TaskID : mxm-task-{TASK_NUMBER}
     Schedule: [cron expression or fire-at time]
     Project : [project name]
   ```

### Mode 5 — Dispatch (`/mxm-tasks dispatch TASK_NUMBER`)
1. Read task #TASK_NUMBER from `.mxm-global/TASKS.md`
2. Generate a complete Dispatch-ready prompt that:
   - Reads all required context files (.mxm-global/, project manifest, executive summary)
   - Executes the task with full Maxim behavioral layer
   - Saves outputs to the project's `.mxm-executive-summary/logs/`
3. Output the prompt in a copyable code block for pasting into Claude Dispatch

### Mode 6 — List scheduled (`/mxm-tasks scheduled`)
1. Call `mcp__scheduled-tasks__list_scheduled_tasks`
2. Cross-reference with `.mxm-global/TASKS.md` entries
3. Show: task ID, description, schedule, next run, last run, enabled status

### Mode 7 — Usage check (`/mxm-tasks usage`) — v1.0.0+
1. Activate `usage-aware-scheduler` skill
2. Fetch current Anthropic OAuth usage:
   - 5-hour utilization + `resets_at`
   - 7-day utilization + `resets_at`
   - 7-day Opus utilization
3. Compare against thresholds in `config/scheduler-thresholds.json`
4. Output:
   ```
   Maxim Usage Snapshot — [ISO timestamp]
     5-hour:        [X]%   [🟢 OK | 🟡 NEAR | 🔴 PAUSED] — resets [resets_at]
     7-day:         [Y]%   [🟢 OK | 🟡 NEAR | 🔴 PAUSED] — resets [resets_at]
     7-day Opus:    [Z]%   [🟢 OK | 🟡 NEAR | 🔴 PAUSED]
   Active thresholds: 5h={N}%, 7d={N}%, 7d-Opus={N}%
   Scheduler status: PROCEED | PAUSE_5H | PAUSE_7D | PAUSE_OPUS
   Next safe execution window: [ISO timestamp]
   ```

### Mode 8 — Run cycle (`/mxm-tasks run-cycle`) — v1.0.0+
Manual one-shot execution of the usage-aware scheduler loop.

1. Activate `usage-aware-scheduler` skill
2. Run one full cycle:
   - Fetch usage → check thresholds → sleep if needed → load queue → run next due task → log to `.mxm-skills/scheduler-events.jsonl`
3. Report cycle outcome (SUCCESS / SLEPT / NO_TASKS / FAILURE)
4. Useful for debugging; production scheduling uses `mcp__scheduled-tasks` for autonomous loops

### Mode 9 — Configure thresholds (`/mxm-tasks config-thresholds`) — v1.0.0+
1. Read current `config/scheduler-thresholds.json`
2. Display active thresholds + available presets (`pro`, `max_5x`, `max_20x`, `tighten_for_long_tasks`)
3. Offer choices:
   - Apply preset by name
   - Edit individual values
   - View event log summary
4. On confirm: write back to `config/scheduler-thresholds.json` and echo new state

### Mode 10 — Schedule with usage awareness (`/mxm-tasks schedule TASK_NUMBER --usage-aware`) — v1.0.0+
Same as Mode 4 but the scheduled task wraps execution with `usage-aware-scheduler`:

```yaml
prompt_wrapper: |
  Activate usage-aware-scheduler skill.
  If thresholds clear: execute the original prompt below.
  If any threshold exceeded: log to scheduler-events.jsonl and reschedule for resets_at.

  ---ORIGINAL TASK---
  [original task prompt]
```

This is the **recommended mode** for any nightly/weekly recurring task that could otherwise burn quota mid-run.

### Tag output: 🟢 HIGH

## Usage-Aware Scheduling (v1.0.0+)

**Maxim is the only multi-agent framework that prevents hitting Anthropic limits during overnight automation.**

The `usage-aware-scheduler` skill checks `https://api.anthropic.com/api/oauth/usage` before firing any scheduled task. If 5-hour / 7-day / 7-day-Opus utilization exceeds the threshold, the scheduler sleeps until `resets_at` rather than slamming into a quota error mid-batch.

**Defaults (from `config/scheduler-thresholds.json`):**
- 5-hour pause at: **80%**
- 7-day pause at: **85%**
- 7-day Opus pause at: **80%**

Switch to a plan-specific preset (`pro`, `max_5x`, `max_20x`) via `/mxm-tasks config-thresholds`.

**Why this matters:** A single overnight RAG ingest cycle across 21 projects could otherwise burn through quota for an entire 5-hour window mid-batch, corrupting state. Usage-aware scheduling treats limits as a first-class constraint.

See `.claude/skills/usage-aware-scheduler/SKILL.md` for full workflow detail and event log format.
