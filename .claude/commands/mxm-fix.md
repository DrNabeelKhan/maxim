---
description: TIER 1 verb-first — fix a bug, failing test, or broken behavior. Routes to CTO implementer + tester + reviewer with Systematic Debugging framework and root-cause discipline.
---

# /mxm-fix

## Usage
- Claude Code: `/mxm-fix <what to fix>`
- Claude CLI: `claude "/mxm-fix <what to fix>"`
- Claude Desktop: type `/mxm-fix <what to fix>` in chat

User-facing verb-first command (TIER 1 surface added v1.2.0). Default flow when a bug, failing test, or regression is in front of the operator.

**Triggers:** "fix", "debug", "broken", "not working", "failing test", "regression", "bug", "error", "crash", "hangs", "wrong output"
**Primary Office:** CTO → `implementer` (lead) + tester + reviewer in coordinated parallel
**Auto-loops:**
- CSO `security-analyst` — auto-loops if the bug is in auth, payment, credential, or PII-handling code (vulnerability suspected until ruled out)
- COO `sre-analyst` — auto-loops if the bug is a production incident or SLO breach
- CMO `documentation-writer` — auto-loops if the bug stems from documented behavior mismatch (doc said X, code did Y)

**Reads:** `BUG_TRACKER.md` · `documents/ledgers/DEBUGGING_PLAYBOOK.md` · the failing test output or stack trace · `.claude/skills/testing/` · `.claude/skills/engineering/`
**Writes:** new entry in `BUG_TRACKER.md` (with full repro · root cause · fix · regression guard); appends §N entry to `DEBUGGING_PLAYBOOK.md` if a new failure pattern was resolved

## Behavioral Overlay

- **Systematic Debugging (community-packs/superpowers/ framework):** Bisect, reproduce, isolate, hypothesize, test, fix, regression-guard. No fix lands without reproduction first. The fastest debugging is the kind that does not skip the reproduction step.
- **Root-cause discipline:** Surface symptoms get a 🔴 LOW tag. Root-cause fixes get a 🟢 HIGH tag. A patch that masks the symptom without explaining the cause is rejected by the reviewer.
- **Confidence tag rubric (per ADR-010):** 🟢 HIGH = reproduction + root cause + regression guard + reviewer pass. 🟡 MEDIUM = fix verified but root cause stays partial-hypothesis. 🔴 LOW = symptom suppression only.

## Behavior

1. **Reproduce first** — if no reproduction in hand, build one before touching code. Failing test, curl command, terminal session, screenshot — whatever proves the bug exists.
2. Read `BUG_TRACKER.md` for prior entries; check Recurring-Pattern Registry for matches (saves time if this is PATTERN-NN we have seen before)
3. Read `documents/ledgers/DEBUGGING_PLAYBOOK.md` for any §N section matching the failure mode
4. **Signal scan** — auto-loop CSO if auth/payment/credential/PII; auto-loop COO sre-analyst if production incident
5. Activate CTO `implementer` lead; lead routes to specialist per signal (backend-implementer for server bugs, frontend-implementer for UI bugs, data-pipeline-engineer for ETL bugs, etc.)
6. Apply Systematic Debugging: bisect → reproduce → isolate → hypothesize → test → fix → regression-guard
7. **Root-cause check** — articulate WHY the bug existed (off-by-one? race condition? missing null check? wrong env var resolution? upstream API change?). No root cause = no 🟢 tag.
8. Write fix + regression guard (test or assertion that catches the bug class going forward)
9. Append BUG-NNN entry to `BUG_TRACKER.md` with: ID · date · scope · repro · root cause · fix · regression guard · pattern tag
10. If a new failure pattern was resolved, append §N entry to `DEBUGGING_PLAYBOOK.md` (methodology + transferable lesson)
11. Hand off to `/mxm-review` (or run reviewer inline) — reviewer rejects symptom-masking fixes
12. Tag output per the confidence rubric above

## Anti-patterns (rejected by reviewer)

- Fix without reproduction
- Fix without root cause statement
- Fix without regression guard
- Comment-out / disable a failing test instead of fixing the bug
- Silent retry / catch-all-and-ignore as the "fix"
- Hardcoding around the bug instead of fixing the cause

## TIER 1 surface note

Thin router-frontend. Power users can use `/mxm-cto debug` for the same flow without the auto-loops. `/mxm-fix` is the plain-English entry point with the Systematic Debugging gate enforced.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 1 surface added v1.2.0 per AGENT_ROSTER_v1.2_PROPOSAL.md._
