---
name: Project Current State
description: Latest status checkpoint — updated at the end of every session
type: project
---

# Project Current State

> Project: [PROJECT NAME]
> Last Updated: [YYYY-MM-DD]
> Updated By: [agent or user]

This file is the single source of truth for the project's current state. It is overwritten (not appended) at the end of every session with the latest information.

---

## Current Phase

**Phase:** [e.g., Discovery | Design | Implementation | Testing | Release | Maintenance]
**Sprint / Iteration:** [e.g., Sprint 3 — Week 2]
**Phase Started:** [YYYY-MM-DD]
**Phase Target:** [YYYY-MM-DD or milestone]

---

## Completed Work

Summary of all work completed to date. Add new items at the top (most recent first).

- [YYYY-MM-DD] [What was completed — be specific enough to not redo it]
- [YYYY-MM-DD] [What was completed]
- [YYYY-MM-DD] [What was completed]

---

## Active Tasks

Tasks currently in progress. Move to Completed when done. Mark BLOCKED if waiting on something.

| Priority | Task | Owner | Status | Notes |
|---|---|---|---|---|
| P0 | [Task name] | [agent/user] | IN PROGRESS | [any context] |
| P1 | [Task name] | [agent/user] | NOT STARTED | [any context] |
| P1 | [Task name] | [agent/user] | BLOCKED | [blocker description] |
| P2 | [Task name] | [agent/user] | NOT STARTED | [any context] |

---

## Critical Risks

Active risks that could derail delivery. Remove when resolved.

| Risk | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|
| [Risk description] | HIGH / MED / LOW | HIGH / MED / LOW | [mitigation action] | [owner] |

---

## Next Logical Step

> The single most important action to take at the start of the next session.

**[Exact instruction — precise enough that any agent can pick this up and start immediately without re-reading everything]**

Context needed:
- [File or piece of context needed to execute this step]
- [File or piece of context needed to execute this step]

---

## Locked Decisions

Decisions that are final and must not be revisited without explicit user instruction. Do not re-debate these.

| Decision | Rationale | Date Locked |
|---|---|---|
| [Decision statement] | [Why it was locked] | [YYYY-MM-DD] |
| [Decision statement] | [Why it was locked] | [YYYY-MM-DD] |

Full decision history is in `decision-log.md`.

---

## Environment Snapshot

```
Branch       : [current git branch]
Last Commit  : [short SHA and message]
DB State     : [migration version or schema hash]
Config       : [env file or config version]
Infra        : [deployed version or local]
```

---

## Notes for Next Session

Any context that doesn't fit the above but is important for continuity:

[Free-form notes — will be cleared when no longer relevant]
