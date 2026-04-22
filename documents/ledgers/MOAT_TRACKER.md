# Maxim — Moat Tracker

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 7 rows at v1.0.0 (6 L1 pack moats + MOAT-07 vertical-operator moat, added 2026-04-21 post community-pack audit). New rows land as L2 bundles, L3 verticals, and community packs ship, each pairing a pack's SKILL.md with the behavioral framework it applies per ADR-007.

---

## Executable Contract

This file is **not marketing copy**. It is the live registry of defensibility claims Maxim makes, paired with the mechanism citation and the anti-pattern that reveals a non-Maxim output. Every SKILL.md that ships as a paid pack MUST cite a MOAT row by ID. If no row exists, no moat claim is allowed — the skill ships without defensibility language until a row lands.

Each row MUST include:

| Field | Required | Purpose |
|---|---|---|
| `MOAT-NN` | ✅ | Stable ID — cited from SKILL.md and landing copy. |
| Positioning claim | ✅ | One sentence. No hedging. |
| Mechanism | ✅ | Named behavioral science framework from `documents/reference/FRAMEWORKS_MASTER.md`, applied deliberately. |
| Anti-pattern | ✅ | What a generic LLM output looks like — so the reader can tell them apart. |
| Pack(s) | ✅ | Which paid pack(s) deliver this moat. |
| Primary framework | ✅ | Academic citation with author/year. |
| Proof asset | on claim | Link to SKILL.md, demo, test fixture, or published artifact that demonstrates the claim. |

---

## Moat Rows

Every row cites a framework from `documents/reference/FRAMEWORKS_MASTER.md` by section number. The mechanism column states what the framework does when applied correctly; the anti-pattern column describes what a generic LLM produces without the framework applied.

### MOAT-01 · AI Governance anchor

| Field | Value |
|---|---|
| **Positioning claim** | Every AI decision your operator produces carries an audit trail with loss-framed risk weighting, not confident prose. |
| **Mechanism** | Prospect Theory — losses weighted ~2× gains, so outputs flag downside risk explicitly (failed audit, wrong framework, compliance drift) rather than presenting upside only. See `FRAMEWORKS_MASTER.md` §56 Cognitive Biases · Prospect Theory. |
| **Anti-pattern** | Generic LLM produces confident recommendations with no loss framing. Operator reads, ships, discovers the cost of the loss after it's realized. |
| **Pack(s)** | L1.1 AI Governance |
| **Primary framework** | Prospect Theory (Kahneman & Tversky, 1979) |
| **Proof** | [`packs/pack-l1-1-ai-governance/SKILL.md`](../../packs/pack-l1-1-ai-governance/SKILL.md) |

### MOAT-02 · MemPalace Pro anchor

| Field | Value |
|---|---|
| **Positioning claim** | Cross-session memory that resumes your project where you left it, applying a graph structure tuned to working-memory limits rather than re-flooding context on every session. |
| **Mechanism** | Cognitive Load Theory — intrinsic / extraneous / germane load budgeting. MemPalace loads only the ~4 chunks relevant to the active task, not the whole project history, matching Miller's Law and Sweller's chunking research. |
| **Anti-pattern** | Generic LLM re-reads every doc on every session, overwhelming context window, dropping mid-session memory, answering recent questions without historical context. |
| **Pack(s)** | L1.2 MemPalace Pro |
| **Primary framework** | Cognitive Load Theory (Sweller, 1988) + Miller's Law (Miller, 1956) |
| **Proof** | [`packs/pack-l1-2-mempalace-pro/SKILL.md`](../../packs/pack-l1-2-mempalace-pro/SKILL.md) |

### MOAT-03 · Proactive Watch anchor

| Field | Value |
|---|---|
| **Positioning claim** | Ten drift classes scan on every session start — docs vs code, counts vs filesystem, moat claims vs this ledger, compliance trail integrity. Silent regressions surface before ship, not after. |
| **Mechanism** | Signal Detection Theory — explicit threshold tuning per drift class, with severity 1–5 scoring so high-severity drift blocks session continuation and low-severity drift logs to review queue. |
| **Anti-pattern** | Generic LLM has no drift awareness across sessions. Docs lie about what code does, counts in README don't match reality, nobody catches it until a customer or auditor does. |
| **Pack(s)** | L1.3 Proactive Watch |
| **Primary framework** | Signal Detection Theory (Green & Swets, 1966) |
| **Proof** | [`packs/pack-l1-3-proactive-watch/SKILL.md`](../../packs/pack-l1-3-proactive-watch/SKILL.md) · [`composable-skills/frameworks/proactive-watch.md`](../../composable-skills/frameworks/proactive-watch.md) |

### MOAT-04 · Compliance Shield anchor

| Field | Value |
|---|---|
| **Positioning claim** | 14 compliance frameworks enforced at the MCP layer — GDPR, HIPAA, PCI-DSS, SOC 2, PIPEDA, UAE-PDPL, CASL, FINTRAC, EU AI Act, ISO 27001, ISO 13485, ISO 14971, NIST CSF, WCAG 2.1. Outputs that touch regulated data are blocked at generation, not flagged after. |
| **Mechanism** | COM-B applied to compliance behavior — operator Capability (know the rule), Opportunity (frameworks loaded into context automatically), Motivation (compliance gate blocks bad output) must all fire for a Behavior change. Removes "I forgot which framework applies" from the equation. |
| **Anti-pattern** | Generic LLM mentions compliance when asked, skips it when not asked. Post-hoc review finds violations. Operator rewrites. Cost compounds. |
| **Pack(s)** | L1.4 Compliance Shield · L3.1 Healthcare · L3.2 Legal · L3.3 Fintech · L3.4 GovTech |
| **Primary framework** | COM-B (Michie, van Stralen & West, 2011) · see `FRAMEWORKS_MASTER.md` §54 |
| **Proof** | [`packs/pack-l1-4-compliance-shield/SKILL.md`](../../packs/pack-l1-4-compliance-shield/SKILL.md) · `mcp/mxm-compliance/` |

### MOAT-05 · Brand & Design Pro anchor

| Field | Value |
|---|---|
| **Positioning claim** | Your brand voice locked across every AI output. System 1 recognition cues (visual hierarchy, tone signature, micro-typography) applied deliberately, so readers *feel* the brand without cognitive effort. |
| **Mechanism** | Dual Process Theory — System 1 fast recognition tuned by consistent voice overlay, System 2 reflection reserved for evaluating substance. Brand drift breaks System 1 recognition; Maxim's three-layer voice overlay prevents drift on every session. |
| **Anti-pattern** | Generic LLM produces on-brand copy on Monday, off-brand copy on Friday. Each session starts blind to prior voice decisions. Your Twitter thread and your pricing page read like two different companies. |
| **Pack(s)** | L1.5 Brand & Design Pro |
| **Primary framework** | Dual Process Theory (Kahneman, 2011) · see `FRAMEWORKS_MASTER.md` §61 |
| **Proof** | [`packs/pack-l1-5-brand-design-pro/SKILL.md`](../../packs/pack-l1-5-brand-design-pro/SKILL.md) · [`.brand-foundation/personal/voice-profile.md`](../../.brand-foundation/personal/voice-profile.md) |

### MOAT-06 · Behavioral Intelligence flagship

| Field | Value |
|---|---|
| **Positioning claim** | 64 peer-reviewed behavioral frameworks applied to every Maxim output. Mechanism named, anti-pattern registered, citation provided. The replication barrier is not the framework count — it is the registry that makes each framework enforceable. |
| **Mechanism** | Fogg Behavior Model B=MAP as the composition root — every output must have Motivation lever (why the reader acts), protected Ability lever (no friction), and timed Prompt lever (placed at the trigger moment). Every other framework plugs into one of the three levers. |
| **Anti-pattern** | Generic LLM lists frameworks when asked, applies none when not asked. Competitors can also list 64 frameworks; they cannot replicate the enforcement, because enforcement lives in the pack-engine audit hook that scans every external-facing paragraph. |
| **Pack(s)** | L1.6 Behavioral Intelligence (flagship) · plus every other L1 cites this pack's framework registry |
| **Primary framework** | Fogg Behavior Model / B=MAP (Fogg, 2009) · see `FRAMEWORKS_MASTER.md` §51. Supporting: Cialdini §50, Hook Model §53, EAST §55, Nudge Theory §52, TTM §59, SDT §60. |
| **Proof** | [`packs/pack-l1-6-behavioral-intelligence/SKILL.md`](../../packs/pack-l1-6-behavioral-intelligence/SKILL.md) · [`documents/reference/FRAMEWORKS_MASTER.md`](../reference/FRAMEWORKS_MASTER.md) |

---

### MOAT-07 · Operator agents behind vertical compliance overlays

| Field | Value |
|---|---|
| **Positioning claim** | Maxim ships the only Claude-native operator roster that goes beyond compliance *awareness* to compliance *authorship* — FDA submissions, MDR technical files, CAPA workflows, PCI-grade payment flows written by specialist agents who cite the exact clause. |
| **Mechanism** | Social Learning Theory — regulator-facing documents follow strict genre conventions (tone, evidence format, citation discipline) that specialist agents replicate by modeling observed regulator-approved submissions, not by generating from compliance-rule abstractions. See `FRAMEWORKS_MASTER.md` §64 Social Learning Theory (Bandura) — roadmap v1.2. Supporting: Prospect Theory §56 for risk-weighted language; Constitutional AI for audit-trail alignment (roadmap v1.3). |
| **Anti-pattern** | Generic LLM knows what HIPAA / MDR / PCI-DSS *require* but produces text that reads like a summary, not a submission. Regulator rejects; operator rewrites; Maxim's value didn't reach the artifact. |
| **Pack(s)** | L3 Healthcare overlay · L3 Fintech overlay · L3 Legal overlay · L3 GovTech overlay — all four get operator rosters starting v1.4 |
| **Primary framework** | Social Learning Theory (Bandura, 1977) · roadmap v1.2 §64 |
| **Proof** | [`documents/reference/FRAMEWORK_ROADMAP.md`](../reference/FRAMEWORK_ROADMAP.md) — CRO operator roster + Fintech specialist domain scheduled v1.4. |

---

## Decommissioned Claims

_(None — this row appears when a moat claim is retired.)_

---

## Notes

- Landing page, investor deck, and documents/guides/PACKS.md copy pull claims from this file. Drift between MOAT_TRACKER and marketing copy is a Proactive Watch P1.
- New moat rows land during Phase 3 of a sprint, before the SKILL.md ships, not after.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
