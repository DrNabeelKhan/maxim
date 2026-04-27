# ADR-004 — Free tier specification as Executable Contract

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** ADR-002 (Executable Contracts), ADR-009 (pack architecture)

---

## Context

A free tier is not a marketing promise; it is an API contract. Users who install Maxim expecting the Starter tier to remain fully functional forever need the scope of "fully functional" to be declared, testable, and version-locked. A drifting free tier — features silently removed, quotas tightened — burns trust faster than any bug.

---

## Decision

The Starter free tier is defined as an Executable Contract in `documents/guides/PACKS.md` § Starter. The contract names:

- The 90 agents, 34 domains, 37 commands, 4 Proactive Watch classes, CEO Automation, 10 framework stubs, MemPalace local file mode, and basic compliance advisory as in-scope and permanent.
- Everything else (full watch classes, behavioral_audit beyond first 50/mo, MemPalace semantic, multi-framework compliance, brand overlays, unlimited voice) as out-of-scope and requiring a paid tier.

The pack-engine tier resolver (`pack-engine tier`) returns `"starter"` when no valid license is present; no code path may promote a Starter user to a paid feature without a valid JWT or active trial.

Regression test fixture at `pack-engine/internal/tier/free_tier_contract_test.go` verifies the Starter feature set matches documents/guides/PACKS.md on every build.

---

## Rationale

A free-forever tier is a commercial commitment with reputational consequences. Treating it as a test fixture rather than marketing copy means the build fails when the free-tier scope narrows — a much stronger guarantee than prose.

The alternative — "we reserve the right to change the free tier" — is standard industry boilerplate that free-tier users correctly interpret as "we will eventually take features away."

---

## Consequences

**Easier:** users trusting Starter as permanent (it is, by test). Auditors and buyers verifying the commitment. Marketing copy writing itself from the contract.

**Harder:** Starter cannot silently absorb a behavior that a paid tier would normally gate; scope changes require a visible ADR amendment and a test update.

**Locks us into:** the current Starter scope for the BSL lifetime of v1.0.0 (4 years). Expansion of Starter is always allowed; contraction requires a new ADR.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
