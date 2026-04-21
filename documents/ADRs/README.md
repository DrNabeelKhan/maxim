# Maxim — Architecture Decision Records

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Purpose.** The canonical ledger of architectural decisions. Every non-obvious, non-trivial, or non-reversible choice lands here with its Context, Decision, Rationale, and Consequences. The goal is future-you or a future maintainer able to understand *why* something is the way it is without re-deriving the debate.

---

## Rules

### Numbering

- Monotonic. `ADR-001`, `ADR-002`, `ADR-003`, ... never reused.
- An ADR number is allocated when the file is created, not when the decision is finalized. If a proposed ADR is abandoned, leave a stub with `status: rejected` — do not recycle the number.

### Filenames

Format: `ADR-NNN-short-slug.md` (kebab-case, under 60 chars).

Examples:
- `ADR-001-maxim-architecture-baseline.md`
- `ADR-002-documents-as-executable-contracts.md`

### Lifecycle

| Status | Meaning |
|---|---|
| `proposed` | Drafted but not yet applied. |
| `accepted` | In force. This is the steady state. |
| `superseded by ADR-NNN` | A newer ADR replaces this one. The superseded ADR stays — it is history, not garbage. |
| `deprecated` | No longer in force but nothing supersedes; capability retired. |
| `rejected` | Proposed and declined. Kept as a warning to future-you. |

### When to write one

Write an ADR when:

- A decision has trade-offs worth recording (at least two viable options).
- A decision is hard to reverse (migration path required).
- A decision is surprising from the outside (someone cold-reading the repo would ask "why").
- A decision is load-bearing for other decisions.

Skip an ADR when a follow-the-convention choice is being made and the convention itself is already documented in an ADR or `CLAUDE.d/protocols.md`.

### Structure

Every ADR uses [`TEMPLATE.md`](TEMPLATE.md). Four mandatory sections: **Context**, **Decision**, **Rationale**, **Consequences**. Extra sections (Alternatives, References, Notes) are optional.

### Cross-linking

ADRs cross-link each other explicitly (`ADR-005 supersedes ADR-003`, `ADR-009 depends on ADR-008`). Other documents (`CLAUDE.md`, `documents/guides/PACKS.md`, `documents/ledgers/MOAT_TRACKER.md`, SKILL.md files) cite ADRs by number when claiming a behavior is governed by one.

### INDEX.md

Every ADR has a one-line entry in `INDEX.md` with its current status. If the file diverges, the pre-commit hook flags drift.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
