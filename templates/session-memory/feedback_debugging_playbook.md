---
name: Debugging Playbook
description: Append-only log of every error, retry, and workaround encountered across all sessions — never delete entries
type: feedback
---

# Debugging Playbook

> Project: [PROJECT NAME]
> Managed by: Maxim session-memory skill
> Rule: APPEND ONLY. Never edit or delete past entries. Add new entries at the bottom.

This file captures every error, unexpected behavior, retry, and workaround encountered during development. It is the institutional memory for debugging. Before attempting any fix, scan this file for matching patterns — the solution may already be documented.

---

## How to Use This File

**Before debugging:** Search for the error type or keyword. If a matching entry exists with status RESOLVED, follow the documented fix first.

**After debugging:** Append a new entry following the format below. Mark status OPEN if unresolved at session end, RESOLVED once fixed.

**Format per entry:**

```markdown
### [YYYY-MM-DD] — [Error Type / Short Descriptive Label]

**Status:** OPEN | RESOLVED
**Context:** [What was being attempted when the error occurred]
**Error:** [Exact error message, stack trace excerpt, or behavior description]
**Root Cause:** [Diagnosed reason — be precise]
**Fix:** [Exact steps that resolved it — or PENDING if unresolved]
**Prevention:** [How to avoid this class of error in future sessions]
**Session:** [YYYY-MM-DD]
**Related Files:** [files involved, if relevant]
```

---

## Playbook Entries

---

### 2026-04-11 — Template Initialization Entry (Example)

**Status:** RESOLVED
**Context:** First session memory setup — verifying template structure renders correctly
**Error:** No real error — this entry demonstrates the required format for all future entries
**Root Cause:** N/A — example entry
**Fix:** N/A
**Prevention:** Always copy this template to `.claude-sessions-memory/` before starting a new project session. Initialize MEMORY.md first so the load order is correct.
**Session:** 2026-04-11
**Related Files:** `.claude-sessions-memory/MEMORY.md`, `templates/session-memory/`

---

<!-- Append new entries below this line. Most recent entry goes at the bottom. -->
