---
name: Session Memory Index
description: Master index of all memory files for this project — read this first on every session start
type: reference
---

# Session Memory — Master Index

> Project: [PROJECT NAME]
> Last Updated: [YYYY-MM-DD]
> Managed by: Maxim session-memory skill (.claude/skills/session-memory/)

Read this file first on every session start. It maps every memory file so context loads in the correct order.

---

## Load Order (Session Start)

Load files in this sequence for correct context reconstruction:

1. This file (MEMORY.md) — orientation
2. `project_current_state.md` — current phase and active tasks
3. `handoff.md` — last session open items and exact next step
4. `feedback_debugging_playbook.md` — known issues (scan OPEN entries only)
5. `reference_key_files.md` — file locations for the work session
6. `feedback_lessons_learned.md` — optional, load if working in a known problem area

---

## File Registry

| File | Type | Description | Last Updated |
|---|---|---|---|
| MEMORY.md | reference | This file — master index | [YYYY-MM-DD] |
| project_current_state.md | project | Current phase, active tasks, risks, next step | [YYYY-MM-DD] |
| handoff.md | project | Last session summary, open items, carry-forward | [YYYY-MM-DD] |
| progress.md | project | Running task completion log | [YYYY-MM-DD] |
| task_plan.md | project | Active task plan with priorities | [YYYY-MM-DD] |
| findings.md | project | Research and analysis findings | [YYYY-MM-DD] |
| decision-log.md | project | Append-only architecture and product decisions | [YYYY-MM-DD] |
| feedback_debugging_playbook.md | feedback | Error patterns, root causes, fixes — append-only | [YYYY-MM-DD] |
| feedback_lessons_learned.md | feedback | Session lessons — append-only | [YYYY-MM-DD] |
| reference_key_files.md | reference | Fast lookup table for important project files | [YYYY-MM-DD] |
| session-[YYYY-MM-DD].md | project | Per-session summaries — one file per date | ongoing |

---

## Project Identity

```
Project     : [PROJECT NAME]
Repository  : [REPO URL or LOCAL PATH]
Stack       : [PRIMARY TECH STACK]
Owner       : [TEAM / PERSON]
Environment : [dev | staging | prod]
```

---

## Quick Status

```
Current Phase   : [e.g., Implementation — Sprint 2]
Blocking Issues : [count or NONE]
Open Tasks      : [count]
Last Session    : [YYYY-MM-DD]
Next Step       : [one sentence — what to do first next session]
```

---

## Append-Only Files (never edit past entries)

The following files are append-only. Add new entries at the bottom. Never modify or delete existing entries.

- `feedback_debugging_playbook.md`
- `feedback_lessons_learned.md`
- `decision-log.md`

---

## Deduplication Notice

All memory files live exclusively in `.claude-sessions-memory/`. If you encounter duplicates at root, `.mxm-skills/`, or `planning/`, merge them here and backup the originals to `.mxm-backup/`.
