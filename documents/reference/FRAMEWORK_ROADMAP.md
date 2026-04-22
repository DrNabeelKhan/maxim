# 🗺 Framework Library Roadmap

> Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
> SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)

| Version | Last Updated | Owner | Canonical Reference |
|---|---|---|---|
| 1.1 | 2026-04-21 | `planner` (COO) | [FRAMEWORKS_MASTER.md](./FRAMEWORKS_MASTER.md) |

---

## What ships in v1.0.0

**64 frameworks** — 63 `SKILL.md` files under `composable-skills/frameworks/*/` + 1 `proactive-watch.md`.

Full catalog: [FRAMEWORKS_MASTER.md](./FRAMEWORKS_MASTER.md). v1.0.0 covers the base set (§1–58) plus 2 new compliance frameworks (CCPA, FedRAMP) and the Maxim-native Proactive Watch meta-framework.

## What's deferred

18 frameworks listed in MASTER with the 🆕 marker are **reference-documented but not yet implemented as dispatchable SKILL.md files**. They are targeted for v1.1 (compliance) and v1.2 (behavioral) per the schedule below.

Deferral does **not** mean the frameworks are unavailable to customers — the knowledge is captured in MASTER and any specialist agent can reason about them. What's deferred is the **automated dispatch integration** (trigger phrases, collaboration matrix, MCP-invokable skill entry).

---

## 🎯 v1.1 — Compliance Expansion (target: Q3 2026)

**Theme:** Fill the regulated-industry surface area. Lands alongside vertical overlay v2 releases.

| § in MASTER | Framework | Category | Reference | Priority |
|---|---|---|---|---|
| §17 | EU AI Act | AI Governance / EU | [artificialintelligenceact.eu](https://artificialintelligenceact.eu/) | 🔴 HIGH — Pro overlay dependency |
| §18 | ISO 42001 | AI Management System (ISO) | [iso.org/standard/81230.html](https://www.iso.org/standard/81230.html) | 🔴 HIGH — ships with Enterprise tier |
| §19 | SOX (Sarbanes-Oxley) | US financial controls | [sec.gov](https://www.sec.gov/about/laws/soa2002.pdf) | 🟠 MED — Fintech overlay stacks cleaner with this |
| §20 | CIS Controls | Security baseline (CIS) | [cisecurity.org/controls](https://www.cisecurity.org/controls) | 🟠 MED |
| §21 | DORA | EU financial operational resilience | [digital-operational-resilience-act.com](https://www.digital-operational-resilience-act.com/) | 🟠 MED — EU fintech readiness |
| §22 | NIST SP 800-53 | US federal controls baseline | [csrc.nist.gov/publications/detail/sp/800-53/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) | 🔴 HIGH — FedRAMP foundation |
| §24 | LGPD (Brazil) | BR data protection | [gov.br/anpd](https://www.gov.br/anpd/pt-br) | 🟡 LOW — reactive to demand |

**7 compliance frameworks.** Expected effort: 2–3 days per framework (template, compliance matrix, MCP integration, test cases).

### 🔒 v1.1 — Runtime Hardening — MCP license middleware

**Theme:** Close the runtime enforcement gap exposed by the v1.0.0 launch audit. Landing alongside the compliance expansion because enterprise/regulated buyers evaluating the new overlays will review runtime controls at the same time.

**Problem.** The v1.0.0 plugin-repo ships seven MCP servers (`mxm-behavioral`, `mxm-compliance`, `mxm-context`, `mxm-memory`, `mxm-portfolio`, `mxm-catalog`, `mxm-voice`) with zero license enforcement. A license JWT is issued by the Worker on checkout-completed, but none of the MCPs validate it before serving tool calls. Code being public is a deliberate choice (standard open-core distribution pattern); runtime being ungated is a bug.

**Shipped capability.**

- New shared module `mcp/_shared/license-gate.ts` — single `requireValidLicense(toolName)` helper that reads `MXM_LICENSE_JWT` env var, calls the Worker `/validate` endpoint, and throws on deny/expired/revoked.
- All 7 MCP servers call the gate at the start of every `@tool`-decorated handler. Starter tier (free) gets a short-TTL anonymous JWT with rate-limited grants; paid tiers get their checkout-issued JWT with tier-specific grant set.
- Worker-side `/validate` endpoint logs (tool, tier, project_id, timestamp) to a KV namespace for usage analytics — feeds the portfolio dashboard and support debugging.
- Tier-grant enforcement: the validate response includes the tier's grant list; tools that require specific grants (e.g., `mempalace_kg_add` requires `mempalace-full`) check locally after the gate clears.

**Ship gates (must all be green before release):**
- [ ] `requireValidLicense` middleware merged into all 7 MCP servers
- [ ] Worker `/validate` endpoint deployed + KV binding live
- [ ] Starter tier anonymous JWT issuer live (rate-limited, no paid grants)
- [ ] End-to-end test: clone public repo without a license → tool calls fail with clear error pointing to install instructions
- [ ] End-to-end test: paid-tier JWT → tool calls succeed + usage logged
- [ ] End-to-end test: expired JWT → tool calls fail with refresh instructions
- [ ] Rate-limit policy per tier documented and verified

**Priority.** Treat as higher-priority than any individual framework addition — the work gates every future paid-tier feature.

**Non-goals for v1.1.**
- Obfuscating MCP source code — the public-source strategy stays. Value is gated by runtime, not code secrecy.
- Moving framework definitions server-side — they stay public as marketing/reference assets.
- Real ML-driven framework scoring — deferred to v2.0.

---

## 🧠 v1.2 — Behavioral Science Expansion (target: Q4 2026)

**Theme:** Double the behavioral-science surface. Strengthens the core moat claim ("behavioral intelligence") with 10 additional dispatchable frameworks spanning motivation, decision-making, social psychology, and emotional design.

| § in MASTER | Framework | Category | Reference | Priority |
|---|---|---|---|---|
| §59 | Transtheoretical Model (TTM / Stages of Change) | Behavior Science — Motivation | [uri.edu/cprc/transtheoretical-model](https://web.uri.edu/cprc/transtheoretical-model/) | 🔴 HIGH — complements Fogg/COM-B |
| §60 | Self-Determination Theory (SDT) | Behavior Science — Motivation | [selfdeterminationtheory.org](https://selfdeterminationtheory.org/) | 🔴 HIGH — intrinsic motivation gap |
| §61 | Dual Process Theory (System 1 & 2) | Behavior Science — Decision-making | [nobelprize.org — Kahneman](https://www.nobelprize.org/prizes/economic-sciences/2002/kahneman/facts/) | 🔴 HIGH |
| §62 | SCARF Model | Behavior Science — Workplace psychology | [neuroleadership.com](https://neuroleadership.com/) | 🟠 MED |
| §63 | Theory of Planned Behavior (TPB) | Behavior Science — Intention/action | [people.umass.edu/aizen/tpb.html](https://people.umass.edu/aizen/tpb.html) | 🟠 MED |
| §64 | Social Learning Theory (Bandura) | Behavior Science — Observation/modeling | [albertbandura.com](https://www.albertbandura.com/) | 🟠 MED |
| §65 | Operant Conditioning / Reinforcement Theory | Behavior Science — Habit formation | Skinner — public domain | 🟠 MED |
| §66 | Prospect Theory | Behavior Science — Loss aversion / risk | Kahneman & Tversky 1979 | 🔴 HIGH — pricing & nudge design |
| §67 | Diffusion of Innovations | Behavior Science — Adoption curves | [diffusionofinnovations.com](https://www.diffusionofinnovations.com/) | 🟠 MED |
| §68 | Emotional Design Model | UX / Behavior Science — Don Norman | [nngroup.com/books/emotional-design](https://www.nngroup.com/books/emotional-design/) | 🟠 MED |

**10 behavioral frameworks.** Expected effort: 3–4 days per framework (template, trigger phrases, collaboration matrix, `behavioral_audit` integration, `apply_framework` MCP wiring, test cases).

---

## 🤖 v1.3 — AI Governance & Security (target: Q1 2027)

**Theme:** Close the AI-specific governance gap. Being a Claude Code plugin that doesn't ship AI-specific frameworks is a credibility hole the moment an enterprise procurement reviewer looks closely. Every framework below is already cited in at least one customer RFP we expect to field in 2027.

| Framework | Category | Why it matters | Maps to |
|---|---|---|---|
| **NIST AI RMF (AI 100-1)** | AI Governance — US | De-facto US AI risk framework. Required by federal AI procurements; widely adopted by regulated industries. | All compliance overlays; CSO auto-loop |
| **OWASP LLM Top 10** | Security — AI/LLM | Direct security framework for LLM-based apps (prompt injection, training data poisoning, model DoS). Speaks to every dev shipping with Claude. | `mxm-behavioral` + security-analyst agent |
| **MITRE ATLAS** | Security — Adversarial ML | The MITRE ATT&CK equivalent for AI systems. Threat matrix for ML supply-chain + inference-time attacks. | security-analyst, fintech overlay |
| **Constitutional AI principles** | AI Governance — Alignment | Anthropic's own framework for AI alignment. Natural fit for a Claude-native plugin; reinforces the brand-aligned distribution story. | All agents (cross-cutting) |
| **AI Bill of Materials (AIBOM / SPDX 3.0)** | AI Governance — Supply chain | Required by EU AI Act Article 53 (GPAI models) + emerging US executive orders. Maps model lineage, training data, weights provenance. | compliance-architect, govtech overlay |

**5 frameworks.** Each ships with threat-model scaffolds, prompt-level checklists, and integration with `mxm-behavioral` for AI-specific audit.

**Dependencies:** v1.1 license middleware must ship first so tier-based gating can route AI governance frameworks to the correct grant set.

---

## 🌐 Domain Expansions — v1.3 / v1.4 / v1.5

Four new skill/operator domains ship alongside the framework releases below. Each pairs with behavioral frameworks from MASTER.

### v1.3 — Revenue Operations domain (Q1 2027)

Pipeline health, churn prevention, form CRO, sales engineering, customer-success playbooks, SaaS metrics, and A/B experimentation as first-class dispatchable skills under the CMO office.

Behavioral framework pairing: Prospect Theory (v1.2 §66) · Diffusion of Innovations (v1.2 §67) · EAST (v1.0 §55).

### v1.4 — Regulated Industries operator roster (Q2 2027)

Operator agents behind the Healthcare / Legal / Fintech / GovTech overlays. Specialists for FDA submissions, MDR technical files, CAPA workflows, ISO 13485/14971 QMS, ISMS 27001 audits, GDPR deep practice. Moves vertical overlays from compliance-awareness to compliance-authorship.

Behavioral framework pairing: Social Learning Theory (v1.2 §64) · Constitutional AI (v1.3).

### v1.4 — Fintech Specialist domain (Q2 2027)

Payment integration, quant analysis, risk modeling, investment advisory, financial modeling. Bridges CTO (payment engineering) and CSO (risk/compliance).

Behavioral framework pairing: Prospect Theory (v1.2 §66) · Cognitive Biases (v1.0 §56).

### v1.5 — Cinematic / Video-AI Production domain (Q3 2027)

Shot language, motion design, moodboard synthesis, and recipe libraries wrapped as a dispatchable Maxim domain. Source material already bundled via the Higgsfield community pack; v1.5 adds the Maxim-native director skill that orchestrates it.

Behavioral framework pairing: Emotional Design (v1.2 §68) · Hook Model (v1.0 §53).

### Cross-cutting requirements (applies to all domain expansions)

- Each new domain gets a moat row in `MOAT_TRACKER.md` (pattern established by MOAT-07)
- Each new skill registered in `config/framework-mapping.yaml` for dispatch triggers
- Each new agent in `config/agent-registry.json`
- Each new domain counted in `AGENT_SKILL_INVENTORY.md`

---

## 📌 Future Considerations (Tier 2–6, unscheduled)

These expansions are on the long-range map but not yet locked to a release. They will be pulled forward when customer demand, regulatory pressure, or internal bandwidth dictates. Listed here so the roadmap reflects depth of intent without overcommitting dates.

### Tier 2 — Sales & GTM methodologies

Strengthens CMO/COO office output to speak operator-language. Most useful for founder/agency tier customers who use Maxim to build revenue playbooks.

| Framework | Why |
|---|---|
| Pirate Metrics (AARRR) | Acquisition / Activation / Retention / Referral / Revenue — universal SaaS funnel |
| HEART (Google) | Happiness / Engagement / Adoption / Retention / Task success — product-analytics gold standard |
| MEDDIC / MEDDPICC | Enterprise sales qualification |
| Jobs Atlas | Tony Ulwick's expanded JTBD method |
| North Star Metric framework | Cross-functional alignment around one number |
| RICE / ICE prioritization | Roadmap scoring methods — pairs with `product-strategist` |

### Tier 3 — Strategy & Org Design

Differentiates Maxim's CEO/COO offices. Wardley Mapping in particular would be a standout positioning move — few AI tools ship it.

| Framework | Why |
|---|---|
| Wardley Mapping | Most underused strategic tool of the decade; pairs with enterprise-architect |
| Business Model Canvas | Universal startup framework |
| Value Proposition Canvas | Companion to BMC |
| Three Horizons | Innovation portfolio framework |
| Team Topologies | Modern org-design framework that actually addresses Conway's Law |
| DORA Metrics (engineering KPIs — *not* the EU regulation already in v1.1) | Lead time, deployment frequency, MTTR, change-failure rate |

### Tier 4 — Behavioral Depth (beyond v1.2)

Diminishing returns after the v1.2 expansion, but valuable for specialist verticals (wellness, fintech nudge design, compliance ethics).

| Framework | Author |
|---|---|
| Tiny Habits | BJ Fogg (newer, more actionable companion to FBM) |
| Implementation Intentions | Peter Gollwitzer — "if-then planning" |
| Goal-Setting Theory | Locke & Latham — OKR foundation |
| Switch Framework | Heath brothers — Rider / Elephant / Path |
| Reactance Theory | Brehm — backlash to persuasion (critical for nudge ethics) |
| BATNA / ZOPA | Harvard negotiation framework |

### Tier 5 — Geographic Compliance

Each is a region-specific data-protection or financial-compliance framework.

| Region | Framework | Unlocks |
|---|---|---|
| Australia | APRA CPS 234 + Privacy Act 1988 amendments | AU fintech/enterprise |
| Singapore | MAS TRM (Monetary Authority cyber framework) | SG fintech |
| South Africa | POPIA | ZA enterprise |
| Canada | Bill C-27 / AIDA (Artificial Intelligence and Data Act) | CA AI governance |
| China | PIPL (Personal Information Protection Law) | CN market readiness |
| India | DPDP Act 2023 | IN enterprise |
| Japan | APPI | JP enterprise |

### Tier 6 — Engineering Documentation & Quality

Strengthens CTO-office outputs; mostly requested by agency-tier customers running multiple client projects.

| Framework | Why |
|---|---|
| C4 Model | Architecture diagramming — Simon Brown; pairs with arc42 |
| arc42 | Architecture documentation template — widely used in EU |
| Diátaxis | Modern docs framework (Tutorial / How-to / Reference / Explanation) |
| TDD / BDD / ATDD | Testing methodologies |
| Conway's Law / Inverse Conway Maneuver | Org-tech alignment principle |

---

## Out of scope (explicitly not planned)

Items occasionally requested but not on the roadmap. These may be reconsidered post-v1.5 based on demand signals.

- PAPA (Privacy-As-Principle-Architecture) — superseded by composite GDPR/PIPEDA/UAE-PDPL coverage
- ITIL v3 — deprecated upstream; ITIL 4 already ships
- Lean Six Sigma — overlaps with existing DMAIC-style skills in the agent roster

---

## How items move from Roadmap → Shipped

1. PR scaffolds the new folder `composable-skills/frameworks/<framework-id>/SKILL.md` matching the standard template (YAML frontmatter + Purpose / Framework & Standards table / Prompt Template / Core Principles / Applications / Reference Materials / Usage Guidelines / Collaboration Protocol / Ethical Guidelines / Success Metrics / Related Skills / Testing Strategy + Maxim copyright footer)
2. Add trigger phrases to `config/framework-mapping.yaml`
3. Register collaboration links in the relevant agents' `collaborates_with:` blocks
4. Wire into `mcp/mxm-behavioral/` `apply_framework` tool (for behavioral) or `mcp/mxm-compliance/` `check_compliance` (for compliance)
5. Remove 🆕 marker from FRAMEWORKS_MASTER.md
6. Update the count in `AGENT_SKILL_INVENTORY.md` Section 6 (Frameworks)
7. Entry in `CHANGELOG.md` under the shipping version
8. Update this file: move the row from "Deferred" to a "Shipped in v1.x" retrospective section

---

## Change log

| Date | Change | By |
|---|---|---|
| 2026-04-21 | Initial roadmap: 18 frameworks deferred from v1.0.0 → v1.1/v1.2 (7 compliance + 10 behavioral + 1 AI governance overlap) | Maxim v1.0.0 launch audit |
| 2026-04-21 | v1.1 add: Runtime Hardening — MCP license middleware across all 7 servers. v1.3 add: AI Governance & Security — 5 frameworks (NIST AI RMF, OWASP LLM Top 10, MITRE ATLAS, Constitutional AI, AIBOM). Future Considerations appendix (Tiers 2–6 unscheduled). | Maxim v1.0.0 launch |
| 2026-04-21 | Domain Expansions scheduled: RevOps (v1.3), Regulated Industries operator roster (v1.4), Fintech Specialist domain (v1.4), Cinematic / Video-AI Production (v1.5). | Maxim v1.0.0 launch |

---

<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)
See [LICENSE](../../LICENSE) at repo root.</sub>
