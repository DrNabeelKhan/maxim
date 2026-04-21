# ADR-009 — Pack Architecture: L1 capabilities + L2 persona bundles + L3 vertical overlays

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** ADR-004 (free tier), ADR-007 (moat framing), ADR-008 (community packs), ADR-011 (payment)

---

## Context

Maxim's commercial catalog must balance two pressures. Buyers want a single price anchor (how much does Maxim cost?). Operators want differentiated pricing so a power user pays more than a hobbyist. The industry pattern — bundle everything into one price — fails differentiation. The other extreme — charge per agent — fails legibility.

The resolution is a three-layer catalog where each layer answers a different buyer question.

---

## Decision

The commercial catalog at v1.0.0 is **6 L1 capability packs + 4 L2 persona bundles + 4 L3 vertical overlays**.

**L1 — Capability packs (one MOAT row each).** Individually sellable, each anchored on one behavioral framework and one mechanism.
1. AI Governance (Prospect Theory)
2. MemPalace Pro (Cognitive Load Theory)
3. Proactive Watch (attention residue mitigation)
4. Compliance Shield (14-framework enforcement)
5. Brand & Design Pro (brand identity + design system)
6. Behavioral Intelligence (core 64-framework catalog)

**L2 — Persona bundles (subscription tiers, monthly).** Sell L1s as bundles that match how buyers describe themselves.
- Solo — $19.99/mo — 1 L1 (Behavioral Intelligence core). MOAT anchor tier.
- Pro — $39/mo — Solo + Compliance Shield + Proactive Watch + MemPalace Pro.
- Professional — $99/mo — Pro + Brand & Design Pro + unlimited voice.
- Team — $249/mo (5 seats) — Professional × 5 + shared MemPalace KG + team audit trails.

**L3 — Vertical overlays (one-time, stackable).** Sell compliance-heavy verticals as one-time add-ons on any paid tier.
- Healthcare — $249 — HIPAA + ISO 13485 + ISO 14971 + FHIR/HL7.
- Legal — $199 — privilege + ethics walls.
- Fintech — $199 — PCI-DSS + FINTRAC + SOX + FDX.
- GovTech — $149 — FedRAMP + NIST 800-53 + Section 508.

Agency ($599/mo, 20 seats) and Enterprise (custom) are **deferred to v1.5+**. Teams between v1.0 and v1.5 engage via `https://maxim.isystematic.com/contact` for manual contracts.

---

## Rationale

The Solo tier at $19.99 is the legibility anchor — a single price a new buyer can commit to without a decision tree. Pro/Professional/Team scale linearly with how much of the behavioral moat is unlocked. L3 overlays capture the "I have a vertical compliance need" buyer without forcing them into a higher persona tier they wouldn't otherwise want.

The alternative flat pricing ($49/mo everyone) loses the $19.99 anchor and misses the power-user ceiling. The alternative per-agent pricing ($2 per agent per month) is mathematically equivalent at scale but harder to explain at the point of sale.

---

## Consequences

**Easier:** landing page pricing card (6 rows, comprehensible in 30 seconds). Stripe product setup (already complete; see ADR-011). Moat framing (each L1 cites one framework, one mechanism — ADR-007).

**Harder:** L3 overlay stacking math (discount table at checkout: 2 overlays 20% off, 3+ overlays 35% off). Billing-side upgrade/downgrade paths between persona tiers (Stripe handles prorating but the pack-engine must refresh JWTs on tier change).

**Locks us into:** the 6-L1 catalog at v1.0.0. Splitting an L1 post-launch requires a new JWT claim schema migration.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
