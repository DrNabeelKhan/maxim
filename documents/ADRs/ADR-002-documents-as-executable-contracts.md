# ADR-002 — Documents as Executable Contracts

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** ADR-004 (free tier contract)

---

## Context

The canonical markdown files at the root of a typical LLM-tooling repo (CHANGELOG, BUG_TRACKER, and friends) decay within weeks. They start as write-only logs, stop matching reality, and eventually become cargo cult. The drift is not caught because nothing fails when they lie.

Maxim relies on these files for session-start context, session-end bundles, pack moat claims, and pre-commit verification. A drifting MOAT_TRACKER becomes false marketing copy; a drifting AGENT_SKILL_INVENTORY becomes a lying README badge.

---

## Decision

The following files are declared **Executable Contracts**: they are read and written by the session protocols and the pre-commit hook, not treated as free-form prose.

- `documents/ledgers/AGENT_SKILL_INVENTORY.md` — counts verified against filesystem on every commit.
- `BUG_TRACKER.md` — bugs logged with mandatory fields; Recurring-Pattern Registry has teeth.
- `documents/ledgers/MOAT_TRACKER.md` — no SKILL.md may claim a moat not registered here.
- `documents/ledgers/DEBUGGING_PLAYBOOK.md` — append-only, `§N` numbered; session-end bundle requires a new entry when a failure pattern was resolved.
- `CHANGELOG.md` — one entry per release; user-facing changes MUST land here before the version tag.
- `documents/ledgers/SESSION_CONTINUITY.md` — session-start reads this first.
- `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` — sprint's literal CLI block lives here while the sprint is active.
- ADRs — canonical ledger for decisions; cross-linked from skills, packs, and `CLAUDE.md`.

Session-end runs a **9-document closure bundle** (listed in `CLAUDE.md` § Session End Protocol). If the session was non-trivial, the bundle runs; nothing is optional.

---

## Rationale

Making drift fail a commit is cheaper than auditing drift quarterly. The pre-commit hook already runs the secret/PII scan; adding count verification and moat-claim verification to the same hook is a small increment of CPU for a large increment of trust.

The alternative — rely on operator discipline — is the status quo every project starts with and every project eventually abandons. The files become decoration.

---

## Consequences

**Easier:** session resumption (state is always current), marketing-vs-reality alignment (moat claims verified), release discipline (CHANGELOG can't silently skip versions).

**Harder:** refactoring has to remember to update counts in one extra file; renames that touch multiple Executable Contracts are a single-commit change or a broken build.

**Locks us into:** the pre-commit hook as the enforcement surface. If the hook is bypassed (never with `--no-verify` without operator sign-off), the contract goes unchecked.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
