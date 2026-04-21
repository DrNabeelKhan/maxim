# Maxim — Bug Tracker

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** Empty — first public release (v1.0.0). First bug reported becomes BUG-001.

---

## Executable Contract (v1.0.0+)

This file is not a log. It is a **live registry** of bugs and recurring failure patterns. Anything that can regress silently lives here with a fingerprint, repro, and regression-prevention link.

Each entry MUST include:

| Field | Required | Purpose |
|---|---|---|
| `BUG-NNN` | ✅ | Monotonic ID — never reused. First bug in Maxim v1.0.0+ becomes BUG-001. |
| Title | ✅ | One-line symptom, not guess. |
| Reported | ✅ | ISO date + source (user, CI, self-audit, Proactive Watch). |
| Severity | ✅ | P0 (production down) / P1 (user-blocking) / P2 (degraded) / P3 (minor). |
| Status | ✅ | OPEN / IN-PROGRESS / RESOLVED / WONTFIX (with reason). |
| Root cause | on RESOLVED | One sentence — what actually broke, not what we fixed. |
| Fix | on RESOLVED | Commit SHA + file path + line. |
| Regression guard | on RESOLVED | Test, CI check, or Proactive Watch rule that catches recurrence. No guard → flag in Recurring-Pattern registry. |

---

## Recurring-Pattern Registry

Patterns that have struck more than once earn a permanent entry here with a named mitigation. This is the ledger's teeth — it converts one-off fixes into standing guards.

_(Empty at v1.0.0.)_

---

## Open Bugs

_(None.)_

---

## Resolved Bugs

_(None.)_

---

## WontFix

_(None.)_

---

## Notes

- Bugs found during Proactive Watch runs (LIGHT or FULL) must land here before the session ends.
- Bugs surfaced by the compliance audit hook (`.claude/hooks/pre-commit.sh`) are logged to `.mxm-skills/compliance-audit.jsonl` and cross-linked here when a pattern emerges.
- Reporter agent = `security-analyst` for any PII/secret/regulated-data bug by default.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
