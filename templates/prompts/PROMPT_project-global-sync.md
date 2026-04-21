# Project → Global Context Sync

> **Usage:** Paste this into Claude Cowork or Claude Desktop for any project.
> Replace `[PROJECT_PATH]` with the actual project path (e.g., `E:\Projects\FixIt`).
> Replace `[PROJECT_NAME]` with the project display name (e.g., `FixIt`).
>
> **Data flow:** This prompt READS project files and UPDATES global context only.
> It NEVER modifies project-level files. Project files are the source of truth.

---

## Prompt

You are running a global context sync for **[PROJECT_NAME]** at `[PROJECT_PATH]`.

### Rules
- You READ from the project. You WRITE to `.mxm-global/` only.
- NEVER modify any file inside `[PROJECT_PATH]` — those are maintained by project-level sessions.
- `.mxm-global/` is a derived cache for cross-surface sharing, not the source of truth.

### Step 1 — Read project state

Read these files from `[PROJECT_PATH]` (skip any that don't exist):

1. `config/project-manifest.json` — extract: project.id, project.name, project.stage, mxm_version, compliance.frameworks
2. `.claude-sessions-memory/handoff.md` — extract: last session summary, open tasks, blockers
3. `.claude-sessions-memory/progress.md` — extract: current progress state
4. `.claude-sessions-memory/project_current_state.md` — extract: project checkpoint
5. `.claude-sessions-memory/decision-log.md` — extract: last 5 decisions with dates
6. `documents/ledgers/SESSION_CONTINUITY.md` — extract: session count, last session date, key milestones
7. `documents/architecture/` — list files present (PRD, FRD, SRD, etc.)
8. `TASKS.md` or `.mxm-executive-summary/sessions/tasks.md` — extract: active tasks

### Step 2 — Synthesize project summary

From the data collected, produce a structured summary:

```
PROJECT: [PROJECT_NAME]
PATH: [PROJECT_PATH]
Maxim VERSION: [from manifest]
STAGE: [from manifest]
COMPLIANCE: [frameworks list]
LAST SESSION: [date from handoff or session files]
ACTIVE TASKS: [count and top 3 by priority]
BLOCKERS: [any from handoff]
KEY DECISIONS: [last 2-3]
ARCHITECTURE DOCS: [list of files in documents/architecture/]
HEALTH: [GREEN if recent session + no blockers, YELLOW if stale, RED if blockers]
```

### Step 3 — Update global context

Using the MCP tools (if available) or direct file access:

1. **PORTFOLIO-METRICS.md** — update the row for [PROJECT_NAME]:
   - Stage, Maxim version, compliance frameworks, last activity date
   - If the project row doesn't exist, add it

2. **TASKS.md** — check if [PROJECT_NAME] has a high-level task entry:
   - If the project's task status has changed (based on project-level TASKS.md), update the status in the global row
   - Only update the ONE-LINE high-level entry — never add deep/detailed tasks to global
   - If no entry exists and the project has active P1 tasks, add ONE high-level entry

3. **portfolio-registry/project_state.md** — verify the project is listed at the correct version

### Step 4 — Report

Output what was updated:
```
SYNC COMPLETE: [PROJECT_NAME]
  Metrics row: [updated/added/unchanged]
  Tasks entry: [updated/added/unchanged]
  Registry: [verified/updated]
  Health: [GREEN/YELLOW/RED]
  Next recommended action: [based on blockers or stale state]
```

### For NEW projects (no session files exist)

If `.claude-sessions-memory/` is empty or doesn't exist:
1. Read `E:\Projects\.mxm-global\temp\GLOBAL_TODO_v6.md`
2. Search for tasks tagged with `[PROJECT_NAME]` or matching project ID
3. Extract relevant tasks and create a project-level `TASKS.md` at `[PROJECT_PATH]/TASKS.md`
   (This is the ONE exception where we write to the project — only for brand-new bootstraps with no existing state)
4. Update global TASKS.md with ONE high-level entry for the project
