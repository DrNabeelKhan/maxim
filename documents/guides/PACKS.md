# Maxim Packs — the commercial catalog

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
> v1.3.2 rewrite per ADR-019 (Multi-Tenant Readiness). Capability counts source-of-truth: `documents/ledgers/AGENT_SKILL_INVENTORY.md` v1.3.1.

---

## Situation · Complication · Question · Answer

**Situation.** Maxim ships a behavioral-intelligence operating system: 91 specialist agents, 36 skill domains, 48 slash commands, 9 MCPs / 95 tools, 74 peer-reviewed frameworks, 14 compliance frameworks, 13 drift classes. The Core is free forever (Apache 2.0 in four years per ADR-005). The structural moats — audit trail, drift detection, voice lock, compliance enforcement — ship as gated packs.

**Complication.** Most plugins publish a flat capability list. A buyer can't tell what they'd *use* versus what they'd *own and ignore*. Picking a tier without seeing the moat work on real work is a Prospect Theory bet against loss aversion: every operator overweights the risk of paying for something they won't use.

**Question.** Which install path matches your work — and how do you know before you commit?

**Answer.** Default to the 90-day Trial. Run every paid pack against your real work for three months. By day 80 you have data, not guesses. The wizard takes one keypress; you walk away knowing exactly which tier fits.

---

## Maxim Core · free forever

Maxim Core is the complete governance substrate. It is **not crippleware** — per ADR-004 Free Tier Executable Contract, what ships in Core stays in Core.

| Capability | What you get at $0 |
|---|---|
| Specialist agents | 91 agents across 7 executive offices (CEO · CTO · CMO · CSO · CPO · COO · CINO) |
| Skill domains | 36 dispatcher + sub-skill domains |
| Slash commands | 48 `/mxm-*` commands · 7 verb-first (TIER 1) · 10 office shortcuts (TIER 2) · 5 persona dispatchers (TIER 3) |
| Behavioral frameworks | 74 frameworks cited on every output (Fogg · COM-B · EAST · Cialdini · Prospect Theory · 69 more) |
| MCP servers | 9 servers · 95 tools across portfolio / context / catalog / compliance / behavioral / memory / voice / commands / notebooklm |
| Compliance advisory | 14 frameworks surface relevant requirements (paid tier enforces; Core advises) |
| Hooks | 14 executable hooks across session lifecycle · git hygiene · pre-commit secret scan |
| Drift classes | All 13 Proactive Watch classes scan on session start (paid tier adds severity gating) |
| ADRs | 19 ADRs · 15 public describing Maxim's commitments to operators |

License: Business Source License 1.1. Use it internally, with clients, fork it, ship it inside your own product. The only restriction (per ADR-005) is you cannot resell a competing commercial pack catalog. Apache 2.0 conversion in four years regardless.

---

## The 90-day Trial · why we default to it

The wizard pre-selects Trial because **a moat is hard to evaluate when you can't see it.** Per ADR-019, three behavioral mechanisms compound during the 90-day window:

1. **Default Effect (Thaler & Sunstein 2008)** — pre-selected paths frame as the recommended choice. Pressing Enter starts the trial. No card, no decision tree.
2. **Endowment Effect (Kahneman & Knetsch 1991)** — by day 30, the packs are *yours*. Giving them up triggers loss aversion, not "should I buy this." Conversion strengthens on capability-experienced, not capability-promised.
3. **Loss Aversion (Kahneman & Tversky 1979)** — operators who try then cancel have **confirmed** what they're losing. Their cancel is informed; their convert is informed. Either way the decision is real, not speculative.

**90 days, not 14, not 60.** The landing page (`maxim.isystematic.com`) has advertised a 90-day Pro Trial since v1.1.0.1. v1.3.1 unified the wizard's default to match. Two trial concepts in parallel would confuse operators.

**Suggested arc through the 90 days:**

| Window | What you'll likely see |
|---|---|
| Week 1-2 | Install runs · first auto-loops fire (CSO on regulated work · reviewer on PRs) |
| Week 3-5 | Drift detection catches something you didn't know was broken (Class 11 surface-claims-drift is the typical first surprise — same class that caught the v1.3.2 MCP undercount you're reading about here) |
| Week 6-9 | Framework citations start changing your decisions · you see WHICH framework Maxim applied and why |
| Week 10-12 | You have data — which packs fired on your real work · which compliance gates blocked broken-on-arrival work · which tier matches |

By day 90, the upgrade or downgrade decision is anchored on capability experienced, not capability listed.

---

## The 6 install paths

Per ADR-019, the wizard surfaces six paths in deliberate order. Each is framed by **what it unlocks** (Anchoring works against capability framing if cost surfaces first, per Tversky 1974). Prices live at `maxim.isystematic.com/pricing` — visible after capability evaluation, not before.

### 1 · Trial · default · pre-selected

All 14 packs unlocked. 90 days. No card. Cancel anytime.

> *Why we recommend it:* you can't pick a tier from a feature matrix. You can pick a tier from three months of using the moat on your real work.

**What's unlocked:** every L1 capability pack · every L2 vertical bundle · every L3 industry pack. Full 95-tool MCP surface. Full 13-class drift detection with severity gating. Full 14-framework compliance enforcement. Voice lock across all writing surfaces.

**Install:** `bash bootstrap/install-tier-packs.sh` (or `.ps1`) — wizard pre-selects Trial.

---

### 2 · Solo · Core only · upgrade anytime

Best for: solo operators evaluating Maxim. Hobbyists. Learners.

**What you keep (Core, free forever):** 91 agents · 36 skills · 48 commands · 9 MCPs / 95 tools · 74 frameworks · advisory-mode compliance · 13-class drift detection without severity gating.

**What stays gated until upgrade:**
- Audit trail on every AI decision (L1.1 AI Governance · Prospect Theory loss-framing)
- Cross-session memory continuity beyond local files (L1.2 MemPalace Pro · Cognitive Load Theory)
- Drift severity gating + auto-block (L1.3 Proactive Watch · Signal Detection Theory)
- 14-framework compliance enforcement at MCP layer (L1.4 Compliance Shield · COM-B)
- Voice lock across all outputs (L1.5 Brand & Design Pro · Dual Process Theory)
- 74-framework behavioral dispatch with enforcement registry (L1.6 Behavioral Intelligence · Fogg B=MAP)

---

### 3 · Pro · Core + 6 L1 capability packs

Best for: serious operators on 1-2 projects. Founders running both sides. Senior individual contributors.

**What you unlock:**

| Pack | Primary framework | Mechanism |
|---|---|---|
| L1.1 AI Governance | Prospect Theory (Kahneman & Tversky 1979) | Audit trail on every AI decision with loss-framed risk weighting (MOAT-01) |
| L1.2 MemPalace Pro | Cognitive Load Theory (Sweller 1988) + Miller's Law | Cross-session memory loading ~4 chunks relevant to active task (MOAT-02) |
| L1.3 Proactive Watch | Signal Detection Theory (Green & Swets 1966) | 13 drift classes with severity 1-5 scoring · auto-block on P1 drift (MOAT-03) |
| L1.4 Compliance Shield | COM-B (Michie et al. 2011) | 14 frameworks enforced at MCP layer · regulated outputs blocked at generation (MOAT-04) |
| L1.5 Brand & Design Pro | Dual Process Theory (Kahneman 2011) | Three-layer voice overlay locks System 1 brand recognition (MOAT-05) |
| L1.6 Behavioral Intelligence | Fogg Behavior Model B=MAP (Fogg 2009) | 74-framework dispatch with enforcement audit hook (MOAT-06) |

**Loss-frame language at the gate** (per MOAT-08 · runtime tier enforcement): when a Solo operator triggers a paid capability, the error names what they're missing in terms of their work, not abstract feature absence. "Compliance-14 grant not present in your Core tier — your output touched PII / regulated data."

---

### 4 · Team · Core + L1 + 4 L2 vertical bundle packs

Best for: teams running multiple verticals. Founders with marketing + ops + delivery. Agency operators serving multi-vertical clients.

**Adds on top of Pro:**

| L2 vertical bundle | Audience | Composes |
|---|---|---|
| **L2.1 Founder OS** | Pre-seed → Series A founders | L1.1 + L1.2 + L1.6 + pitch-deck specialists + GTM + competitive-moat scoring |
| **L2.2 Growth Stack** | Marketers · growth operators · creators | L1.5 + L1.6 + SEO/AEO + behavioral persuasion + conversion optimization |
| **L2.3 Professional OS** | Senior ICs · architects · technical writers | L1.1 + L1.3 + L1.5 + decision-architect + documentation specialists |
| **L2.4 Agency All-In** | Multi-client agencies · consultancies | All L1 + per-client brand layers + audit trails across client portfolios |

---

### 5 · Enterprise · all 14 packs (L1 + L2 + L3)

Best for: regulated industries · multi-team organizations · operators where compliance authorship (not just awareness) is the work.

**Adds on top of Team — the 4 L3 industry packs:**

| L3 industry pack | Regulatory scope | Anchor framework |
|---|---|---|
| **L3.1 Healthcare** | HIPAA · ISO 13485 · ISO 14971 · FHIR/HL7 | Social Learning Theory (Bandura 1977) — regulator-genre modeling for FDA/MDR submissions |
| **L3.2 Legal** | Attorney-client privilege · ethics walls · multi-jurisdictional citation discipline | Constitutional AI alignment for audit-trail durability (roadmap v1.3) |
| **L3.3 Fintech** | PCI-DSS deep · FINTRAC · SOX · FDX | Prospect Theory loss-framing on transaction risk vocabulary |
| **L3.4 GovTech** | FedRAMP · NIST 800-53 · Section 508 | COM-B compliance-behavior reinforcement |

Per MOAT-07: regulator-facing documents follow strict genre conventions that L3 specialist agents replicate by modeling observed regulator-approved submissions — not by generating from compliance-rule abstractions.

---

### 6 · Individual · per-pack install

Power-user escape hatch for operators who know exactly which packs they need and want to skip the wizard.

```bash
/plugin install mxm-pack-l1-1-ai-governance@maxim-packs
/plugin install mxm-pack-l1-2-mempalace-pro@maxim-packs
# ...etc per pack
```

Full list in the wizard script: `bootstrap/install-tier-packs.sh option 6`.

---

## How operators commonly land on a tier (Jobs-to-be-Done)

Per Diátaxis (Procopiou 2017) — these are how-to entries, not reference. Each persona is a real Job operators bring to Maxim.

### Solo regulated founder
- **Job:** "I'm building in healthcare / fintech / legal and I can't hire a compliance officer yet."
- **Lands on:** Trial → Enterprise after 60 days.
- **Tells the story:** "L3 Healthcare caught a HIPAA leak my CTO would have caught at PR time. That's the cost of one consult."

### Multi-client agency operator
- **Job:** "I serve 10+ clients across verticals and brand drift between client projects is killing me."
- **Lands on:** Trial → Team (L2 Agency All-In is the lock-in mechanism).
- **Tells the story:** "Every client has their own .brand-foundation/startups/ overlay. Voice locked per client. No drift between Tuesday's Slack DM and Friday's pitch deck."

### Senior IC / architect
- **Job:** "I run RFCs, ADRs, and design reviews. I need framework citation discipline I can show a tech lead."
- **Lands on:** Trial → Pro (L1.1 AI Governance + L1.3 Proactive Watch + L1.6 Behavioral Intelligence carry the workload).
- **Tells the story:** "Every ADR I draft cites the right framework. My team trusts my output more because the audit trail is structural, not vibes-based."

### Pre-seed → Series A founder
- **Job:** "I'm doing 8 jobs. I need each to surface its own framework when I'm tired."
- **Lands on:** Trial → Team (L2 Founder OS is the bundle).
- **Tells the story:** "Pitch deck got Duarte Sparkline + Minto Pyramid. Pricing got Van Westendorp. Competitive moat got the MOAT_TRACKER schema. No way I'd remember all that solo."

### Developer evaluating AI tooling
- **Job:** "I want to know if this is real before I commit my workflow."
- **Lands on:** Solo (Core forever) → Pro after multi-project adoption.
- **Tells the story:** "Three months in, drift detection caught two regressions I'd have shipped. The audit trail on my last deploy was the thing that sold me Pro."

---

## Pricing · placed after capability

Per ADR-019, prices live at `maxim.isystematic.com/pricing`. The wizard intentionally surfaces them only after capability framing. Here is the current ladder:

| Tier | Monthly | Annual (2 months free) | Composes |
|---|---:|---:|---|
| Core (Solo) | **$0** | $0 | 91 agents · 36 skills · 48 commands · 9 MCPs · 95 tools · 74 frameworks · advisory compliance · 13-class drift |
| Pro | **$19.99/mo** | $200/yr | Core + 6 L1 capability packs |
| Pro + Compliance | **$39/mo** | $390/yr | Pro + L1.4 Compliance Shield with full 14-framework enforcement at MCP layer |
| Professional | **$99/mo** | $990/yr | Pro + L1.5 Brand & Design Pro unlimited + unlimited voice + priority support |
| Team | **$249/mo** (5 seats) | $2,490/yr | Professional × 5 + shared MemPalace KG + team audit trails + cross-seat handoff |

**L3 industry overlays (one-time, stackable on any paid tier):**

| Overlay | One-time |
|---|---:|
| L3.1 Healthcare | **$249** |
| L3.2 Legal | **$199** |
| L3.3 Fintech | **$199** |
| L3.4 GovTech | **$149** |

**Bundle discount:** any 2 overlays 20% off, any 3+ overlays 35% off (applied at checkout).

Overlays are perpetually licensed for the version released at purchase. Updates within a major version are free. A major version upgrade is an operator decision, not an automatic charge.

---

## Deferred to v1.5+

- **Agency tier** — $599/mo, 20 seats, multi-tenant, priority support, overlay discount.
- **Enterprise tier** — custom pricing, SSO, SLA, on-prem option.

> Note: The wizard's "Enterprise" option (path 5 above) installs all 14 packs but is **not** the Enterprise SLA tier — it's the all-packs install path. The contractual Enterprise tier with SSO and on-prem ships in v1.5+. Teams between v1.0 and v1.5 engage via `https://maxim.isystematic.com/contact` for manual contracts. ADR-009 amendment (v1.3.3 candidate) will clarify this nomenclature.

---

## How to activate

After installing a paid tier path (Trial / Pro / Team / Enterprise), the wizard delegates JWT issuance to the existing license-gate Cloudflare Worker (ADR-003 confidential). Trial issues a 90-day-expiry JWT automatically. Paid tiers issue a JWT after Stripe checkout; the email arrives within 60 seconds.

```bash
# Wizard handles this automatically for Trial:
mxm-pack-engine activate --trial 90

# For paid tiers after checkout email:
mxm-pack-engine activate --license <JWT-from-email>
```

The Core keeps running regardless of pack tier. Packs extend the substrate. The substrate stays free forever per ADR-004.

---

## Honest counts (v1.3.2 surface-claims-drift correction)

Through v1.3.1, public-facing capability counts drifted from the source-of-truth across multiple surfaces (README, one-pager, landing page). v1.3.2's pre-release-audit caught and corrected:

- MCP tools: **87 → 95** (4 MCPs were undercounted by 2 each since v1.2.0)
- ADRs: **18 → 19** (ADR-017 / ADR-018 / ADR-019 ratified in Session 21, inventory header lagged)
- ADR-009 vs ADR-019 L2 nomenclature: pending amendment in v1.3.3

This footnote belongs here because PACKS.md is downstream of `documents/ledgers/AGENT_SKILL_INVENTORY.md` — Class 11 Proactive Watch (surface-claims-drift). Cited per ADR-007 Behavioral Moat Framing Doctrine: the framework is named, the drift is acknowledged, the correction is shipped.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
