# Maxim — Debugging Playbook

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** Empty — first entry at v1.0.0 is the first real debugging session.

---

## Executable Contract

Append-only journal. Each entry is numbered `§N`, dated, and formatted for future retrieval. The purpose is pattern memory, not post-mortem theater.

Each `§N` entry MUST include:

```
§N — YYYY-MM-DD — [one-line symptom]

Context: what was being attempted, what broke, signal vs noise.
Hypothesis tree: the branches considered, in order, with what ruled each in or out.
Root cause: the actual mechanism, not the first plausible guess.
Fix: commit SHA + file path + line, or the decision to WONTFIX with reason.
Regression guard: test / CI / Proactive Watch rule that catches it next time.
Cross-links: BUG-NNN, MOAT-NN, ADR-NNN where applicable.
```

Session-end bundle check: if a new failure pattern was resolved during the session, a `§N` entry MUST land before the session closes (ADR-002 bundle rule 5).

---

## Entries

_(§1 lands with the first real debugging pass.)_

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
