# Maxim — Agent & Skill Inventory

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Version:** v1.0.0 · **Last verified:** 2026-04-21

Single source of truth for Maxim's capability counts. On every commit that touches a tracked section, this file updates — otherwise the pre-commit hook flags a drift.

---

## Section 1 — Specialist Agents (88)

| Office | Lead | Count | Path |
|---|---|---:|---|
| CEO — strategy, finance, partnerships | `enterprise-architect` | 14 | `agents/MXM/ceo/` |
| CTO — engineering, infrastructure, AI | `implementer` | 17 | `agents/MXM/cto/` |
| CMO — marketing, brand, SEO, content | `content-strategist` | 11 | `agents/MXM/cmo/` |
| CSO — security, compliance, ethics | `security-analyst` | 9 | `agents/MXM/cso/` |
| CPO — product, UX, research | `product-strategist` | 12 | `agents/MXM/cpo/` |
| COO — delivery, sprints, operations | `planner` | 10 | `agents/MXM/coo/` |
| CINO — R&D, horizon scanning | `innovation-researcher` | 6 | `agents/MXM/cino/` |
| Orchestrators (executive-router, wiki, watch, voice) | `executive-router` | 9 | `agents/MXM/` |

**Total agents: 88.** Registry: `config/agent-registry.json`.

---

## Section 2 — Domain Skills (34)

Skills live under `.claude/skills/<domain>/SKILL.md`. Domain list authoritative in `documents/reference/SKILLS_MAP.md` and `CLAUDE.d/dispatch.md`.

Categories: AI media, banner design, behavioral science, brand, CEO automation, compliance, content, design (dispatcher + sub-domains), design resources, design system, engineering, enterprise architecture, junction guard, marketing, memory-palace, operator profile, proactive watch, product, product development research, project management, search visibility, security, session memory, slides, studio operations, testing, UI styling, UI/UX Pro Max, usage-aware scheduler, voice, wiki (ingest/query/lint/explore).

**Total domain skills: 34.**

---

## Section 3 — Slash Commands (38)

All commands live under `.claude/commands/mxm-*.md`. Command map: `documents/reference/MXM_COMMAND_MAP.md`.

Executive office shortcuts (10): `/mxm-ceo`, `/mxm-cto`, `/mxm-cmo`, `/mxm-cso`, `/mxm-cpo`, `/mxm-coo`, `/mxm-cino`, `/mxm-ceo-morning`, `/mxm-ceo-overnight`, `/mxm-ceo-setup`.

Domain and workflow (27): `/mxm-behavior`, `/mxm-brand-voice`, `/mxm-compliance`, `/mxm-context`, `/mxm-design`, `/mxm-health`, `/mxm-help`, `/mxm-implement`, `/mxm-new-project`, `/mxm-organize`, `/mxm-plan`, `/mxm-portfolio`, `/mxm-recall`, `/mxm-release`, `/mxm-remember`, `/mxm-review`, `/mxm-route`, `/mxm-security`, `/mxm-seo`, `/mxm-session-end`, `/mxm-status`, `/mxm-superpowers`, `/mxm-tasks`, `/mxm-test`, `/mxm-update`, `/mxm-voice`, `/mxm-watch`, `/mxm-wiki`.

**Total commands: 38.**

---

## Section 4 — MCP Servers (7 servers, 47 tools)

| Server | Path | Tools |
|---|---|---:|
| `mxm-behavioral` | `mcp/mxm-behavioral/` | 7 |
| `mxm-compliance` | `mcp/mxm-compliance/` | 5 |
| `mxm-context` | `mcp/mxm-context/` | 15 |
| `mxm-memory` | `mcp/mxm-memory/` | 6 |
| `mxm-portfolio` | `mcp/mxm-portfolio/` | 9 |
| `mxm-catalog` | `mcp/mxm-catalog/` | 3 |
| `mxm-voice` | `mcp/mxm-voice/` | 2 |

**Total MCP servers: 7.** **Total MCP tools: 47.** Registry: `.mcp.json`.

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

## Section 6 — Behavioral Frameworks (64)

Cataloged in `documents/reference/FRAMEWORKS_MASTER.md`. Core families include Fogg Behavior Model, COM-B, EAST, SCARF, Cialdini Persuasion, Prospect Theory, Cognitive Load Theory, Self-Determination Theory, Transtheoretical Model, Behavioral Moat Framing Doctrine (ADR-007), Technical Educator Rubric (ADR-010), and the 64th addition Proactive Watch (ADR-002).

**Total frameworks: 64.**

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

## Section 9 — Architecture Decision Records (11)

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

**Total ADRs: 11.**

---

## Drift Check

The pre-commit hook verifies these counts against filesystem reality. A mismatch fails the commit with a list of divergences. If a count is intentionally updated, this file must move first.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
