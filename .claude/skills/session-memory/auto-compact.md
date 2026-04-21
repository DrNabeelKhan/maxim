# Auto-Compact — Post-Sprint Context Management

## Trigger
When ANY of these conditions are met:
- User says "sprint complete", "phase complete", "milestone done"
- /mxm-release completes successfully
- task_plan.md shows all phases checked [x]
- User says "next sprint", "next phase", "move to phase X"

## Step 1 — Write everything to files BEFORE compact
1. Write full session summary to `.claude-sessions-memory/session-[YYYY-MM-DD].md`
2. Update `.claude-sessions-memory/project_current_state.md` with completed sprint, files modified, decisions, test results
3. Update `.claude-sessions-memory/progress.md` with completion status
4. Append to `.claude-sessions-memory/feedback_debugging_playbook.md` (if errors occurred)
5. Append to `.claude-sessions-memory/feedback_lessons_learned.md` (if lessons learned)
6. Update `.claude-sessions-memory/handoff.md` with next sprint context
7. Update `.mxm-skills/agents-handoff.md` if inter-agent handoff active

## Step 2 — Generate compact session summary (under 2000 tokens)

Write a compact summary that becomes the "seed" for the next context. This summary MUST be under 2000 tokens and capture everything needed to continue work without reading prior sprint files.

Output format:
```
SPRINT COMPACT SUMMARY — [sprint/phase name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Built (files created/modified)
- [path] — [one-line description]
- [path] — [one-line description]
[max 15 files — group if more]

## Decisions
1. [decision] — [rationale in 10 words]
2. [decision] — [rationale in 10 words]
[number each, max 10]

## Open Items
- [ ] [item] — [assigned to: agent/human] — [priority P1/P2/P3]
- [ ] [item] — [assigned to: agent/human] — [priority P1/P2/P3]

## Errors + Fixes
- [error] → [fix applied]
[omit section if no errors]

## Next Sprint Entry Point
[exact instruction: what to do first, which files to read, what the goal is]

## Metrics
Files saved: [count] | Decisions: [count] | Errors: [count] | Duration: [estimate]

Ready for context compact. All state preserved in .claude-sessions-memory/.
```

Also write this summary to `.claude-sessions-memory/compact-seed-[YYYY-MM-DD].md` so it survives compaction.

## Step 3 — MemPalace sync (if available)
If MemPalace MCP is connected:
1. Store key decisions in the relevant office wings
2. Store project state checkpoint in `maxim/project-state` room
3. Confirm: "MemPalace: [N] memories stored"

## Step 4 — Check global tasks
Check `.mxm-global/TASKS.md` for next task in same project or cross-project.
Output: "Next up: [task] — [project] (P[priority]). Start? (y/n/different task)"

## Step 5 — Load only essentials for next sprint
After compact, on next prompt:
1. Read `.claude-sessions-memory/compact-seed-[latest].md` (compact summary — fastest path)
2. Read `.claude-sessions-memory/MEMORY.md` (master index)
3. Read `.claude-sessions-memory/project_current_state.md` (latest checkpoint)
4. Read `.claude-sessions-memory/handoff.md` (what to do next)
5. Read `config/project-manifest.json` (project identity)
6. Query MemPalace for recent context (if available)
7. Do NOT re-read completed sprint files unless user asks

This prevents "Compacting conversation..." from losing critical state — the compact seed file contains everything needed to resume.
