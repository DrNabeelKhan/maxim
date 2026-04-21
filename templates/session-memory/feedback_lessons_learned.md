---
name: Lessons Learned
description: Append-only log of insights, pattern corrections, and process improvements discovered across all sessions
type: feedback
---

# Lessons Learned

> Project: [PROJECT NAME]
> Managed by: Maxim session-memory skill
> Rule: APPEND ONLY. Never edit or delete past entries. Add new entries at the bottom.

This file captures non-error learnings: process improvements, pattern corrections, better approaches discovered mid-session, and architectural insights. It complements the debugging playbook (which focuses on errors) by capturing the broader "what we learned" across all dimensions.

---

## How to Use This File

**Before starting a new task type:** Scan this file for lessons in the same domain. Past sessions may have already solved the approach problem.

**At session end:** Add one or more entries for any meaningful insight, even if no errors occurred. Small lessons compound into major efficiency gains over time.

**Format per entry:**

```markdown
### [YYYY-MM-DD] — [Lesson Title]

**Category:** Process | Architecture | Tooling | Testing | Security | Performance | Communication | Other
**Context:** [What situation surfaced this lesson]
**What Happened:** [Brief description of the event or observation]
**Root Cause:** [Why this happened — system, process, or assumption gap]
**Fix / Better Approach:** [What to do instead going forward]
**Prevention:** [Process or checklist change that prevents recurrence]
**Impact:** HIGH | MEDIUM | LOW [how significant is this lesson]
**Session:** [YYYY-MM-DD]
**Applies To:** [domains, task types, or agents this lesson is relevant to]
```

---

## Lessons

---

### 2026-04-11 — Always Initialize Session Memory Before First Code Write

**Category:** Process
**Context:** Template creation session for Maxim session-memory skill
**What Happened:** Projects that skip session memory initialization accumulate undocumented decisions and debug history, causing significant rework in later sessions when context is lost.
**Root Cause:** No enforced protocol for memory initialization at project start.
**Fix / Better Approach:** The first action on any new project must be copying `templates/session-memory/` to `.claude-sessions-memory/` and completing the MEMORY.md index. This takes under 5 minutes and saves hours of context reconstruction later.
**Prevention:** Add session memory initialization as step 1 of every project bootstrap checklist. Maxim session-memory skill enforces this at session start.
**Impact:** HIGH
**Session:** 2026-04-11
**Applies To:** All projects, all agents, session start protocol

---

<!-- Append new entries below this line. Most recent entry goes at the bottom. -->
