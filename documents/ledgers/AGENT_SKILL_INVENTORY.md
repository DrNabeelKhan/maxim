# Maxim — Agent & Skill Inventory

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Version:** v1.2.1.0 · **Last verified:** 2026-05-20

Single source of truth for Maxim's capability counts. On every commit that touches a tracked section, this file updates — otherwise the pre-commit hook flags a drift.

---

## Section 1 — Specialist Agents (91)

| Office | Lead | Count | Path |
|---|---|---:|---|
| CEO — strategy, finance, partnerships | `enterprise-architect` | 9 | `agents/MXM/ceo/` |
| CTO — engineering, infrastructure, AI | `implementer` | 17 | `agents/MXM/cto/` |
| CMO — marketing, brand, SEO, content | `content-strategist` | 11 | `agents/MXM/cmo/` (excl. `_template-brand-writer.md`) |
| CSO — security, compliance, ethics | `security-analyst` | 19 | `agents/MXM/cso/` |
| CPO — product, UX, research | `product-strategist` | 8 | `agents/MXM/cpo/` |
| COO — delivery, sprints, operations | `planner` | 8 | `agents/MXM/coo/` |
| CINO — R&D, horizon scanning | `innovation-researcher` | 8 | `agents/MXM/cino/` |
| Orchestrators (planner, implementer, reviewer, tester, release-manager + ethics/behavioral-overlay/confidence-tagger/compliance/handoff) | `executive-router` | 10 | `agents/MXM/orchestrators/` |
| Executive Router | `executive-router` | 1 | `agents/MXM/executive-router.md` |

**Total agents: 91.** Registry: `config/agent-registry.json`. Net delta from v1.1.1 (90 → 91): full WS5 roster reorganization executed in Session 20 close per operator directive "No restructuring deferred to v1.2." 19 agents moved to `agents/MXM/deprecated/` (CTO −8, CMO −5, CPO −4, COO −2). 9 net-new agents authored (CINO +4: tech-radar-author · competitive-intel-analyst · patent-researcher · horizon-scanner. Orchestrators +5: ethics-orchestrator · behavioral-overlay-orchestrator · confidence-tagger · compliance-orchestrator · handoff-coordinator). Plus `nk-writer` from WS1 + 10 CSO specialists from WS5. Total per-office churn: 19 deprecations + 19 net-new (10 CSO + 4 CINO + 5 Orch) = 38 file moves/creates. Net +1 by count; substantial restructure by substance.

---

## Section 2 — Domain Skills (36)

Skills live under `.claude/skills/<domain>/SKILL.md`. Domain list authoritative in `documents/reference/SKILLS_MAP.md` and `CLAUDE.d/dispatch.md`.

Categories: AI media, banner design, behavioral science, brand, CEO automation, compliance, content, design (dispatcher + sub-domains), design resources, design system, engineering, enterprise architecture, junction guard, marketing, memory-palace, operator profile, proactive watch, product, product development research, project management, search visibility, security, session memory, slides, studio operations, testing, UI styling, UI/UX Pro Max, usage-aware scheduler, voice, **voice-routing**, wiki (ingest/query/lint/explore).

**Total domain skills: 35.** Net delta from v1.1.1 (34 → 35): `voice-routing` added 2026-05-19 per ADR-016 — callable lookup wrapper around `myVoiceDNA/VOICE_SELECTION.md`; consumed by `nk-writer` agent and per-startup brand-writer instances.

---

## Section 3 — Slash Commands (48)

All commands live under `.claude/commands/mxm-*.md`. Command map: `documents/reference/MXM_COMMAND_MAP.md`.

**TIER 1 verb-first commands (7, WS2 + WS4 in v1.2.0):** `/mxm-build`, `/mxm-fix`, `/mxm-ship`, `/mxm-plan`, `/mxm-review`, `/mxm-explain`, `/mxm-help`. Plain-English entry points routing invisibly to office leads + specialists.

**TIER 3 persona dispatchers (5, WS3 in v1.2.0-alpha.4):** `/mxm-legal`, `/mxm-arch`, `/mxm-secure`, `/mxm-founder`, `/mxm-pm`. Profession-aware dispatchers with 28 sub-commands total handled inline (not separate command files per AGENT_ROSTER_v1.2_PROPOSAL.md scope decision Q5).

**TIER 2 — Executive office shortcuts (10):** `/mxm-ceo`, `/mxm-cto`, `/mxm-cmo`, `/mxm-cso`, `/mxm-cpo`, `/mxm-coo`, `/mxm-cino`, `/mxm-ceo-morning`, `/mxm-ceo-overnight`, `/mxm-ceo-setup`.

**Domain and workflow (26):** `/mxm-behavior`, `/mxm-brand-voice`, `/mxm-compliance`, `/mxm-context`, `/mxm-design`, `/mxm-health`, `/mxm-implement`, `/mxm-new-project`, `/mxm-organize`, `/mxm-portfolio`, `/mxm-recall`, `/mxm-release`, `/mxm-remember`, `/mxm-route`, `/mxm-security`, `/mxm-self-update`, `/mxm-seo`, `/mxm-session-end`, `/mxm-status`, `/mxm-superpowers`, `/mxm-tasks`, `/mxm-test`, `/mxm-update`, `/mxm-voice`, `/mxm-watch`, `/mxm-wiki`.

**Total commands: 48.** Net delta from v1.1.1 (39 → 48): 4 NEW in WS2 v1.2.0-alpha.2 (`/mxm-build`, `/mxm-fix`, `/mxm-ship`, `/mxm-explain`) + 5 NEW in WS3 v1.2.0-alpha.4 TIER 3 persona dispatchers (`/mxm-legal`, `/mxm-arch`, `/mxm-secure`, `/mxm-founder`, `/mxm-pm`) = 9 new. Plus 3 existing commands upgraded for surface alignment: `/mxm-plan` and `/mxm-review` (WS2 — Fogg B=MAP, Coverage Matrix, conditional auto-loops, ADR-007 enforcement) and `/mxm-help` (WS4 — 9-mode dispatcher with persona auto-detect from project-manifest, cache at `.mxm-skills/operator-persona.txt`).

---

## Section 4 — MCP Servers (9 servers, 87 tools)

| Server | Path | Tools |
|---|---|---:|
| `mxm-behavioral` | `mcp/mxm-behavioral/` | 7 |
| `mxm-compliance` | `mcp/mxm-compliance/` | 5 |
| `mxm-context` | `mcp/mxm-context/` | 15 |
| `mxm-memory` | `mcp/mxm-memory/` | 6 |
| `mxm-portfolio` | `mcp/mxm-portfolio/` | 9 |
| `mxm-catalog` | `mcp/mxm-catalog/` | 3 |
| `mxm-voice` | `mcp/mxm-voice/` | 2 |
| `mxm-commands` | `mcp/mxm-commands/` | 2 |

**Total MCP servers: 8.** **Total MCP tools: 49.** Registry: `.mcp.json`. Net delta from v1.2.0 (7 → 8): `mxm-commands` added v1.2.0.1 — slash-command dispatcher MCP that exposes all 48 /mxm-* commands as the `mxm_command` tool + `list_commands` catalog tool. Closes command-parity gap for Claude Desktop / Web / Cowork surfaces that lack native slash-command processors.

---

## Section 5 — Hooks (14 scripts, 7 hooks × 2 platforms)

Under `.claude/hooks/`:

| Hook | Platforms | Purpose |
|---|---|---|
| `session-start.{sh,ps1}` | Linux/Mac/Win | Detect project, verify memory junction, load manifest, report gaps |
| `session-end.{sh,ps1}` | Linux/Mac/Win | Write 9-document closure bundle placeholder |
| `pre-commit.{sh,ps1}` | Linux/Mac/Win | Secret scan, PII scan, compliance audit → `.mxm-skills/compliance-audit.jsonl` |
| `behavioral-moat-drift.{sh,ps1}` | Linux/Mac/Win | Flag pack SKILL.md claims that drift from MOAT_TRACKER rows (ADR-007) |
| `git-hygiene-preamble.{sh,ps1}` | Linux/Mac/Win | Pre-stage hygiene: staleness banners, junction check |
| `git-hygiene-postamble.{sh,ps1}` | Linux/Mac/Win | Post-commit hygiene: session-end bundle check |
| `mxm-guard.{sh,ps1}` | Linux/Mac/Win | Junction read-only enforcement |

**Total hook scripts: 14** (7 hooks × 2 platforms).

---

## Section 6 — Behavioral Frameworks (74)

Cataloged in `documents/reference/FRAMEWORKS_MASTER.md`. Core families include Fogg Behavior Model, COM-B, EAST, Cialdini Persuasion, Cognitive Load Theory, Behavioral Moat Framing Doctrine (ADR-007), Technical Educator Rubric (ADR-010), and the meta-framework Proactive Watch (ADR-002). v1.2.0 added 10 frameworks across WS6a+WS6b at full ADR-007 7-section depth:

**WS6a (4 HIGH-priority):** `transtheoretical-model` (Prochaska & DiClemente — Stages of Change), `self-determination-theory` (Deci & Ryan — intrinsic motivation via Autonomy/Competence/Relatedness), `dual-process-theory` (Kahneman System 1 / System 2), `prospect-theory` (Kahneman & Tversky — loss aversion + reference dependence + probability weighting).

**WS6b (6 MED-priority):** `scarf` (David Rock — Status/Certainty/Autonomy/Relatedness/Fairness), `theory-of-planned-behavior` (Ajzen — Attitudes + Subjective Norms + Perceived Behavioral Control), `social-learning-theory` (Bandura — modeling + self-efficacy), `operant-conditioning` (Skinner — reinforcement schedules with ethics gating on variable-ratio), `diffusion-of-innovations` (Rogers — 5 adopter categories + Moore's chasm), `emotional-design` (Norman — visceral/behavioral/reflective).

**Total frameworks: 74.** Net delta from v1.1.1 (64 → 74): +4 WS6a + +6 WS6b in v1.2.0.

### Proactive Watch drift classes (13)

The Proactive Watch meta-framework now covers 13 universal drift classes (1–11 from v1.0.0+, Class 12 behavioral-moat-drift ratified in v1.2.0 pre-sprint cleanup, Class 13 third-party-plugin-drift codified in v1.2.0 WS7 per ADR-012 MOE). Class 13 has zero runtime data until v1.1.2 ships MOE; the checker is defined now so the contract is durable. Triage for both new classes is locked: Class 12 → CMO, Class 13 → CSO 🔒.

---

## Section 7 — Compliance Frameworks (14)

Enforced by `mxm-compliance` MCP and `.claude/skills/compliance/SKILL.md`:

GDPR, PIPEDA, PCI-DSS, SOC2, HIPAA, UAE-PDPL, CASL, FINTRAC, EU AI Act, ISO 27001, ISO 13485, ISO 14971, NIST CSF, WCAG 2.1.

**Total compliance frameworks: 14.**

---

## Section 8 — Brand Foundation Layers (3)

| Layer | Path | Override scope |
|---|---|---|
| Layer 1 — Maxim base (committed) | `.brand-foundation/personal/` | Non-overridable |
| Layer 2 — Operator overlay (gitignored) | `.brand-foundation/personal.local/` | Additive |
| Layer 3 — Per-startup overlay (gitignored) | `.brand-foundation/startups/{active}/` | Compliance overrides operator |

Voice management: `.brand-foundation/VOICE-MANAGEMENT.md`. Command: `/mxm-brand-voice`.

---

## Section 9 — Architecture Decision Records (18)

All ADRs at `documents/ADRs/ADR-NNN-*.md`. Index: `documents/ADRs/INDEX.md`. Template: `documents/ADRs/TEMPLATE.md`.

| ADR | Title | Status |
|---|---|---|
| 001 | Maxim architecture baseline | accepted |
| 002 | Documents as Executable Contracts | accepted |
| 003 | Cloudflare Worker for JWT license issuance | accepted |
| 004 | Free tier specification as Executable Contract | accepted |
| 005 | IP Protection: 5-layer architecture | accepted |
| 006 | External Content Boundary Rule | accepted |
| 007 | Behavioral Moat Framing Doctrine | accepted |
| 008 | Community Pack System | accepted |
| 009 | Pack Architecture: 6 L1 + 4 L2 + 4 L3 | accepted |
| 010 | Confidence Tag Technical Educator Rubric | accepted |
| 011 | Stripe-primary payment processor | accepted |
| 012 | Maxim Overlay Engine (MOE) — governance layer for every installed Claude Code plugin | accepted |
| 013 | Multi-Project Memory Inheritance — parent/child topology + upward rollup | accepted |
| 014 | Maxim Studio — AGPL-3.0 GUI shell on top of BSL-1.1 plugin | accepted |
| 015 | Maxim Studio v0.2+ surface roadmap — TIER 2/3/4 deferred to v0.2/0.3/0.4+ | accepted |
| 016 | Voice Writing Agent Architecture — nk-writer + voice-routing skill + per-startup template | accepted |

**Total ADRs: 16.**

---

## Drift Check

The pre-commit hook verifies these counts against filesystem reality. A mismatch fails the commit with a list of divergences. If a count is intentionally updated, this file must move first.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
