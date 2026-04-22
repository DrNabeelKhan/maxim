# 🗺 Framework Library Roadmap

> Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
> SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)

| Version | Last Updated | Owner | Canonical Reference |
|---|---|---|---|
| 1.0 | 2026-04-21 | `planner` (COO) | [FRAMEWORKS_MASTER.md](./FRAMEWORKS_MASTER.md) |

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

---

<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)
See [LICENSE](../../LICENSE) at repo root.</sub>
