# Maxim — Agent & Skill Inventory

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Version:** v1.3.9 · **Last verified:** 2026-06-27 (v1.3.8.4 continuation handoff prompt — ADR-023, `/mxm-handoff`)

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

## Section 2 — Domain Skills (52)

Skills live under `.claude/skills/<domain>/SKILL.md`. Domain list authoritative in `documents/reference/SKILLS_MAP.md` and `CLAUDE.d/dispatch.md`.

Categories: AI media, banner design, behavioral science, brand, CEO automation, compliance, content, design (dispatcher + sub-domains), design resources, design system, engineering, enterprise architecture, junction guard, marketing, memory-palace, operator profile, proactive watch, product, product development research, project management, search visibility, security, session memory, slides, studio operations, testing, UI styling, UI/UX Pro Max, usage-aware scheduler, voice, **voice-routing**, **loops**, **orchestrator**, wiki (ingest/query/lint/explore), **+ 14 everyday skills** (`quote-engine`, `scope-guard`, `invoice-builder`, `repurpose-engine`, `hook-lab`, `post-analyzer`, `lead-qualifier`, `proposal-writer`, `company-teardown`, `inbox-triage`, `logo-concepts`, `source-checker`, `daily-digest`, `competitor-watch`).

**Total skills: 52** — 37 domain + **14 everyday skills** + **1 orchestrator**. The 14 everyday skills (v1.3.8, `everyday_skill: true`) are benefit-first consumer-surface skills over existing depth — each carries the Maxim behavioral overlay (framework citation per ADR-007 + confidence tag per ADR-010), so they are real triggerable skills, not re-labels: `quote-engine` · `scope-guard` · `invoice-builder` · `repurpose-engine` · `hook-lab` · `post-analyzer` · `lead-qualifier` · `proposal-writer` · `company-teardown` · `inbox-triage` · `logo-concepts` · `source-checker` · `daily-digest` · `competitor-watch`. `inbox-triage`/`daily-digest`/`competitor-watch` CONSUME connectors (Gmail/news/web) per ADR-018 — Maxim governs them, doesn't rebuild them — and ship unattended dry-run workflows under `orchestrator/workflows/`. They map to **24 of the 30 "everyday skills" marketing menu given a dedicated surface; the other 4 on-brand are served by existing surfaces (`/mxm-ship`, `api-integrator`, `changelog-writer`, `/mxm-ceo-morning`); 2 are off-brand (skipped).** `orchestrator` (v1.3.8) is the ADR-022 Autonomous Workflow Standard skill (`mxm-orchestrator` engine + `/mxm-workflow`). Net delta (36 → 37): `loops` added 2026-06-19 (v1.3.3) — bounded agent-loop orchestration skill; the 31-loop catalog mapped to Maxim offices + 10 native gap-loops + the Maxim behavioral overlay (confidence tagging, framework citation, CSO auto-loop, no-fabrication). Prior art loop-library + autonomy-loop, cited per ADR-007. Prior delta from v1.1.1 (34 → 36): `voice-routing` added 2026-05-19 per ADR-016 — callable lookup wrapper around `myVoiceDNA/VOICE_SELECTION.md`; consumed by `nk-writer` agent and per-startup brand-writer instances. `notebooklm-py` added 2026-05-20 per ADR-018 — Maxim-flavored skill wrapping the upstream `teng-lin/notebooklm-py` MIT skill; layered with ADR-007 framework citations (Diátaxis · Diffusion of Innovations · Dual Coding Theory) and CSO compliance-orchestrator auto-loop on source uploads.

---

## Section 3 — Slash Commands (50)

All commands live under `.claude/commands/mxm-*.md`. Command map: `documents/reference/MXM_COMMAND_MAP.md`.

**TIER 1 verb-first commands (7, WS2 + WS4 in v1.2.0):** `/mxm-build`, `/mxm-fix`, `/mxm-ship`, `/mxm-plan`, `/mxm-review`, `/mxm-explain`, `/mxm-help`. Plain-English entry points routing invisibly to office leads + specialists.

**TIER 3 persona dispatchers (5, WS3 in v1.2.0-alpha.4):** `/mxm-legal`, `/mxm-arch`, `/mxm-secure`, `/mxm-founder`, `/mxm-pm`. Profession-aware dispatchers with 28 sub-commands total handled inline (not separate command files per AGENT_ROSTER_v1.2_PROPOSAL.md scope decision Q5).

**TIER 2 — Executive office shortcuts (10):** `/mxm-ceo`, `/mxm-cto`, `/mxm-cmo`, `/mxm-cso`, `/mxm-cpo`, `/mxm-coo`, `/mxm-cino`, `/mxm-ceo-morning`, `/mxm-ceo-overnight`, `/mxm-ceo-setup`.

**Domain and workflow (28):** `/mxm-behavior`, `/mxm-brand-voice`, `/mxm-compliance`, `/mxm-context`, `/mxm-design`, `/mxm-handoff`, `/mxm-health`, `/mxm-implement`, `/mxm-new-project`, `/mxm-organize`, `/mxm-portfolio`, `/mxm-recall`, `/mxm-release`, `/mxm-remember`, `/mxm-route`, `/mxm-security`, `/mxm-self-update`, `/mxm-seo`, `/mxm-session-end`, `/mxm-status`, `/mxm-superpowers`, `/mxm-tasks`, `/mxm-test`, `/mxm-update`, `/mxm-voice`, `/mxm-watch`, `/mxm-wiki`, `/mxm-workflow`.

**Total commands: 50.** Net delta (49 → 50): `/mxm-handoff` added v1.3.8.4 (ADR-023 Continuation Handoff Prompt Standard) — generates a verify-first, paste-into-a-fresh-window continuation prompt; also runs as Phase 4 of `/mxm-session-end`. Prior (48 → 49): `/mxm-workflow` added v1.3.8 — the surface for the `orchestrator` skill (ADR-022 Autonomous Workflow Standard): author/list/run/dry-run/go-live/logs for unattended workflows. Prior net delta from v1.1.1 (39 → 48): 4 NEW in WS2 v1.2.0-alpha.2 (`/mxm-build`, `/mxm-fix`, `/mxm-ship`, `/mxm-explain`) + 5 NEW in WS3 v1.2.0-alpha.4 TIER 3 persona dispatchers (`/mxm-legal`, `/mxm-arch`, `/mxm-secure`, `/mxm-founder`, `/mxm-pm`) = 9 new. Plus 3 existing commands upgraded for surface alignment: `/mxm-plan` and `/mxm-review` (WS2 — Fogg B=MAP, Coverage Matrix, conditional auto-loops, ADR-007 enforcement) and `/mxm-help` (WS4 — 9-mode dispatcher with persona auto-detect from project-manifest, cache at `.mxm-skills/operator-persona.txt`).

---

## Section 4 — MCP Servers (9 servers, 95 tools)

| Server | Path | Tools |
|---|---|---:|
| `mxm-behavioral` | `mcp/mxm-behavioral/` | 7 |
| `mxm-catalog` | `mcp/mxm-catalog/` | 9 |
| `mxm-commands` | `mcp/mxm-commands/` | 2 |
| `mxm-compliance` | `mcp/mxm-compliance/` | 5 |
| `mxm-context` | `mcp/mxm-context/` | 15 |
| `mxm-memory` | `mcp/mxm-memory/` | 6 |
| `mxm-notebooklm` | `mcp/mxm-notebooklm/` | 38 |
| `mxm-portfolio` | `mcp/mxm-portfolio/` | 9 |
| `mxm-voice` | `mcp/mxm-voice/` | 4 |

**Total MCP servers: 9.** **Total MCP tools: 95.** Registry: `.mcp.json`. Source of truth: `server.tool(` declarations grepped per server.js, verified against the deferred-tools surface in `claude mcp list`. Net delta from v1.2.0 (7 servers · 49 tools) → v1.3.1: `mxm-commands` added v1.2.0.1 (+2 tools) — slash-command dispatcher MCP; `mxm-notebooklm` added v1.2.1.0 (+38 tools) per ADR-018 three-layer integration pattern. Plus +6 tools across `mxm-catalog` (3→9 per v1.2.0.5 + v1.2.0.6 L2 specialist descent), `mxm-voice` (2→4 v1.2.0 expansion). v1.3.2 surface-claims-drift correction: README v1.3.1 MCP table previously declared 87 tools by undercounting behavioral / context / memory / portfolio by 2 each — caught by pre-release-audit ground-truth grep against `server.tool(` declarations. Corrected here and in README.md v1.3.2.

---

## Section 5 — Hooks (16 scripts, 8 hooks × 2 platforms)

Under `.claude/hooks/`:

| Hook | Platforms | Purpose |
|---|---|---|
| `session-start.{sh,ps1}` | Linux/Mac/Win | Detect project, verify memory junction, load manifest, report gaps |
| `session-end.{sh,ps1}` | Linux/Mac/Win | Write 9-document closure bundle placeholder + topology rollup + refresh `.mxm-global` portfolio cache (`bootstrap/mxm-sync-portfolio.mjs`, v1.3.8.3) |
| `pre-commit.{sh,ps1}` | Linux/Mac/Win | Secret scan, PII scan, compliance audit → `.mxm-skills/compliance-audit.jsonl` |
| `behavioral-moat-drift.{sh,ps1}` | Linux/Mac/Win | Flag pack SKILL.md claims that drift from MOAT_TRACKER rows (ADR-007) |
| `git-hygiene-preamble.{sh,ps1}` | Linux/Mac/Win | Pre-stage hygiene: staleness banners, junction check |
| `git-hygiene-postamble.{sh,ps1}` | Linux/Mac/Win | Post-commit hygiene: session-end bundle check |
| `mxm-guard.{sh,ps1}` | Linux/Mac/Win | Junction read-only enforcement |
| `user-prompt-router.{sh,ps1}` | Linux/Mac/Win | **UserPromptSubmit** — Default-On intent router (ADR-021): classify prompt → inject office/skills/frameworks → show routing token cost; conservative match + opt-out (`router-off`) |

**Total hook scripts: 16** (8 hooks × 2 platforms). Net delta (14 → 16): `user-prompt-router.{sh,ps1}` added v1.3.5 (ADR-021) — the always-on intent router that makes Maxim default-on instead of opt-in.

**Surface compatibility (verified 2026-06-19 against code.claude.com):** hooks run in **Claude Code CLI only**. They do NOT execute in Claude Desktop / Web / Cowork (hooks are a CLI-exclusive feature; parity request [anthropics/claude-code#45514](https://github.com/anthropics/claude-code/issues/45514)). So all hook-enforced governance — pre-commit secret/PII scan, session-start drift detection, and the ADR-021 default-on router — is **CLI-bound**; on Desktop/Web/Cowork it degrades to advisory/opt-in. Skills, commands, and MCP servers remain cross-surface. (v1.3.6 hardened all 4 hook commands to quote `"${CLAUDE_PLUGIN_ROOT}"` for install paths containing spaces.)

---

## Section 6 — Behavioral Frameworks (86)

Cataloged in `documents/reference/FRAMEWORKS_MASTER.md`. Core families include Fogg Behavior Model, COM-B, EAST, Cialdini Persuasion, Cognitive Load Theory, Behavioral Moat Framing Doctrine (ADR-007), Technical Educator Rubric (ADR-010), and the meta-framework Proactive Watch (ADR-002). v1.2.0 added 10 frameworks across WS6a+WS6b at full ADR-007 7-section depth:

**WS6a (4 HIGH-priority):** `transtheoretical-model` (Prochaska & DiClemente — Stages of Change), `self-determination-theory` (Deci & Ryan — intrinsic motivation via Autonomy/Competence/Relatedness), `dual-process-theory` (Kahneman System 1 / System 2), `prospect-theory` (Kahneman & Tversky — loss aversion + reference dependence + probability weighting).

**WS6b (6 MED-priority):** `scarf` (David Rock — Status/Certainty/Autonomy/Relatedness/Fairness), `theory-of-planned-behavior` (Ajzen — Attitudes + Subjective Norms + Perceived Behavioral Control), `social-learning-theory` (Bandura — modeling + self-efficacy), `operant-conditioning` (Skinner — reinforcement schedules with ethics gating on variable-ratio), `diffusion-of-innovations` (Rogers — 5 adopter categories + Moore's chasm), `emotional-design` (Norman — visceral/behavioral/reflective).

**Total frameworks: 86.** "All-in" count — behavioral + security/compliance + enterprise-architecture + engineering + Maxim-native. Each has a `### N.` entry in `FRAMEWORKS_MASTER.md` (renumbered to a clean 1..86) AND a definition dir under `composable-skills/frameworks/<slug>/SKILL.md` (or a loose `.md`); `ttm-stage-detection.md` is a TTM operational helper and is NOT counted. Net delta (78 → 86): the all-in reconciliation added **5 frameworks that had definition dirs but were missing from the catalog** — ArchiMate, Cloud Architecture, DevSecOps, SANS Incident Response, Proactive Watch (§82–86) — and **backfilled definition dirs for 12 catalogued frameworks that lacked them** (EU AI Act, ISO 42001, SOX, CIS Controls, DORA, NIST SP 800-53, LGPD, Elaboration Likelihood Model, and the 4 loop frameworks §78–81). Also fixed a `FRAMEWORKS_MASTER.md` numbering collision (#16–24 were used twice) via a full 1..86 renumber. SEO/AEO/GEO (§4–6) are defined by the `search-intent-mapping` / `google-search-central` / `llm-visibility` dirs (name aliases, count-neutral). Prior delta (74 → 78): +4 loop-derived (v1.3.3); prior (64 → 74): +4 WS6a + +6 WS6b (v1.2.0).

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

## Section 9 — Architecture Decision Records (22)

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
| 009 | Pack Architecture: 6 L1 + 4 L2 + 4 L3 | accepted (amendment pending v1.3.3 — L2 nomenclature shift to vertical-bundle-packs vs. ADR-019 wizard reality) |
| 010 | Confidence Tag Technical Educator Rubric | accepted |
| 011 | Stripe-primary payment processor | accepted |
| 012 | Maxim Overlay Engine (MOE) — governance layer for every installed Claude Code plugin | accepted |
| 013 | Multi-Project Memory Inheritance — parent/child topology + upward rollup | accepted |
| 014 | Maxim Studio — AGPL-3.0 GUI shell on top of BSL-1.1 plugin | accepted |
| 015 | Maxim Studio v0.2+ surface roadmap — TIER 2/3/4 deferred to v0.2/0.3/0.4+ | accepted |
| 016 | Voice Writing Agent Architecture — nk-writer + voice-routing skill + per-startup template | accepted |
| 017 | Office-as-Dispatch-Boundary + MCP-Catalog Specialist Surface | accepted |
| 018 | External Tool Integration Pattern (three-layer: community pack + Maxim skill + MCP wrapper) | accepted |
| 019 | Multi-Tenant Readiness (tier wizard · operator-writer template · public docs rewrite) | accepted |
| 021 | Maxim Default-On (Always-On Intent Router) | accepted |
| 022 | Autonomous Workflow Standard (unattended Workflow contract + mxm-orchestrator) | accepted |
| 023 | Continuation Handoff Prompt Standard (verify-first, anti-hallucination session pickup) | accepted |

**Total ADRs: 22.** Net delta (21 → 22): +ADR-023 (v1.3.8.4 — Continuation Handoff Prompt Standard; the verify-first paste-into-a-fresh-window prompt that resumes a new window without hallucinating). Prior (20 → 21): +ADR-022 (v1.3.8 — Autonomous Workflow Standard; the unattended Workflow contract + `mxm-orchestrator`). Prior (19 → 20): +ADR-021 (v1.3.5 — the always-on intent router that makes Maxim default-on). Prior (16 → 19): +ADR-017 (v1.2.0.4) +ADR-018 (v1.2.1.0) +ADR-019 (v1.3.0), Session 21. (Count = 18 public + 4 confidential foundational ADRs.)

---

## Drift Check

The pre-commit hook verifies these counts against filesystem reality. A mismatch fails the commit with a list of divergences. If a count is intentionally updated, this file must move first.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
