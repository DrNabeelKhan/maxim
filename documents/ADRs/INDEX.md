# Maxim — Public ADR Index

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

Seven Architecture Decision Records are published as public governance narrative — pricing contracts, moat doctrine, confidence rubric, community-pack policy, and payment-processor choice. Four additional ADRs covering internal system architecture (dispatch baseline, Worker license issuance, IP-protection layering, external-content boundary) remain confidential and are maintained in the operator's private ledger.

Every public ADR declares a commitment Maxim makes to its users — a contract that the pre-commit hook and the session-end bundle read as live state, not as history.

---

## Published ADRs (v1.0.0)

| ADR | Title | Status | Date |
|---|---|---|---|
| [ADR-002](ADR-002-documents-as-executable-contracts.md) | Documents as Executable Contracts | accepted | 2026-04-21 |
| [ADR-004](ADR-004-free-tier-executable-contract.md) | Free tier specification as Executable Contract | accepted | 2026-04-21 |
| [ADR-007](ADR-007-behavioral-moat-framing-doctrine.md) | Behavioral Moat Framing Doctrine for SKILL.md files | accepted | 2026-04-21 |
| [ADR-008](ADR-008-community-pack-system.md) | Community Pack System | accepted | 2026-04-21 |
| [ADR-009](ADR-009-pack-architecture-l1-l2-l3.md) | Pack Architecture: 6 L1 + 4 L2 + 4 L3 | accepted | 2026-04-21 |
| [ADR-010](ADR-010-confidence-tag-technical-educator-rubric.md) | Confidence Tag Technical Educator Rubric | accepted | 2026-04-21 |
| [ADR-011](ADR-011-stripe-primary-payment-processor.md) | Stripe-primary payment processor | accepted | 2026-04-21 |

**Published:** 7 · **Accepted:** 7 · **Superseded:** 0 · **Rejected:** 0

---

## Confidential ADRs

Four ADRs describe Maxim's internal architecture and are not published. They cover:

- **ADR-001** — agent dispatch baseline + the 7-office / 88-agent topology
- **ADR-003** — license-issuance infrastructure (Cloudflare Worker + KV schema)
- **ADR-005** — the five-layer IP protection architecture (encryption, JWT binding, machine fingerprinting, obfuscation stack)
- **ADR-006** — external-content boundary rule (how Maxim composes with community packs without leaking them into Maxim-authored output)

These decisions inform the product but expose internal security and dispatch design; they remain private to iSystematic Inc. If you have a legitimate need to review one (compliance audit, enterprise security review), reach out via the contact page on https://maxim.isystematic.com.

---

## How these ADRs are used

- **By the product:** the pre-commit hook reads ADR-002 to decide when a commit must also touch CHANGELOG, MOAT_TRACKER, or AGENT_SKILL_INVENTORY. SKILL.md authors consult ADR-007. Community pack authors read ADR-008. Every confidence-tag rubric emitted by Maxim cites ADR-010.
- **By the landing page:** the `/why-maxim` page pulls its moat narrative from ADR-007. The `/pricing` rationale cites ADR-004 and ADR-009. The `/docs/confidence-tags` explainer uses ADR-010 as its canonical source.
- **By auditors and buyers:** ADR-004 is the Executable Contract that governs the free-tier promise. ADR-011 is the payment-processor choice rationale. Both are public so the commitments are verifiable from outside.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
