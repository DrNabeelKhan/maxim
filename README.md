# Maxim — the behavioral intelligence layer for Claude

> The structural moat behind every Claude output. 91 specialist agents · 78 peer-reviewed behavioral frameworks · 14 compliance frameworks · 9 MCPs · 95 tools. Framework citation enforced on every output. Drift detected before you ship. Voice locked across every surface.

![Version](https://img.shields.io/badge/version-1.3.8.1-blue)
![Agents](https://img.shields.io/badge/agents-91-green)
![Frameworks](https://img.shields.io/badge/frameworks-78-orange)
![Skills](https://img.shields.io/badge/skill_domains-37-purple)
![Commands](https://img.shields.io/badge/commands-48-yellow)
![MCP](https://img.shields.io/badge/MCP_servers-9-teal)
![Tools](https://img.shields.io/badge/MCP_tools-95-teal)
![Hooks](https://img.shields.io/badge/hooks-16-gray)
![Drift_Classes](https://img.shields.io/badge/drift_classes-13-red)
![License](https://img.shields.io/badge/license-BSL_1.1-lightgrey)

---

## Install · then see the moat work in 30 seconds

```bash
/plugin marketplace add DrNabeelKhan/maxim
/plugin install maxim@maxim-packs
```

Then activate your tier (default: **90-day Trial of all 14 packs · no card · cancel anytime**):

```bash
bash bootstrap/install-tier-packs.sh        # Mac · Linux · WSL · Git Bash
pwsh -File bootstrap/install-tier-packs.ps1 # Windows · or PS7 cross-platform
```

The wizard pre-selects Trial because **a moat is hard to evaluate when you can't see it**. Run your real work through Maxim for three months. Then decide what's worth keeping.

> Per ADR-019 (Multi-Tenant Readiness): every operator starts with the same first-run experience. Pre-existing operators (like Maxim's maintainer running `nk-writer`) keep their advanced configurations untouched.

---

## What Maxim actually IS

Most "AI plugins" give you templates. Some give you a chat wrapper. Maxim gives you a **governed multi-agent operating system** with structural enforcement of:

1. **Framework citation on every output** — every Maxim emission names the behavioral science framework that justifies it (Fogg · Cialdini · Prospect Theory · OWASP · NIST · 70 more). Outputs without citation get rejected pre-emit by `behavioral-overlay-orchestrator` (ADR-007). The "looks good" generic LLM output is structurally impossible to ship through Maxim.
2. **Confidence tag on every output** — every emission carries 🟢 HIGH / 🟡 MEDIUM / 🔴 LOW per ADR-010's Technical Educator rubric. You see grounding depth, not just an answer.
3. **Compliance overlay that cannot be bypassed silently** — 14 jurisdictional frameworks (GDPR · PIPEDA · UAE-PDPL · HIPAA · PCI-DSS · SOC2 · ISO 27001/13485/14971 · NIST CSF · EU AI Act · CASL · FINTRAC · WCAG 2.1) fire automatically on every regulated-data signal. CSO auto-loop is structural — even super-user mode doesn't disable it for compliance work.
4. **Voice routing as a property of agent invocation** — your voice loads when a writing agent dispatches, not when you remember to invoke `/mxm-brand-voice` first. Per ADR-016. Per operator via the v1.3.0 template pattern (ADR-019).
5. **Proactive Watch drift detection** — 13 universal drift classes scan every session start. Stale docs · broken refs · secret leaks · surface-claims drift · behavioral-moat drift. AI-coded projects rot fast; Watch is the rot detector.
6. **Documents as Executable Contracts (ADR-002)** — CHANGELOG · MOAT_TRACKER · BUG_TRACKER · AGENT_SKILL_INVENTORY are read by the pre-commit hook as live state. Drift between claim and reality blocks the commit.

**None of the external sources** (alirezarezvani · ui-ux-pro-max · superpowers · VoltAgent · planning-with-files) do any of this structurally. Maxim is the only layer that does. The community-pack system (ADR-008) composes Maxim's behavioral layer on top of their craft.

---

## See the moat work · 6 concrete use cases

### Use Case 1 · Founder evaluating regulatory exposure

```
You: "We're adding stablecoin payments to our pricing flow. What jurisdictions
      need DPAs and what's the controller/processor split?"
```

**What fires:** `executive-router` → `cso-office` → `compliance-orchestrator` + `gdpr-counsel` + `hipaa-counsel` + `dpia-specialist`. MCPs invoked: `mxm-compliance.check_compliance` scans 14 frameworks · `mxm-compliance.generate_ropa_entry` stubs the ROPA · `mxm-compliance.get_jurisdiction_requirements` per region.

**What you get:** jurisdictional map, cited per region, with DPA requirements, controller/processor split, and a flagged ROPA entry. 🟢 HIGH tag attached only if every jurisdiction in your `compliance.frameworks` returned PASS.

**Without Maxim:** 2-3 days research, $5K+ in consultant fees, no audit trail.

---

### Use Case 2 · Engineer building a RAG pipeline with TDD discipline

```
You: "/mxm-build a RAG pipeline for our customer support docs"
```

**What fires:** `cto-office` → `implementer` (lead) + `rag-specialist` (embodied via mxm-catalog) + `tester` + `reviewer`. MCPs invoked: `mxm-context.get_architecture_docs` surfaces existing ADRs · `mxm-behavioral.recommend_frameworks` applies TDD + BDD + C4 + arc42 · `mxm-behavioral.apply_framework Fogg-B-MAP` scope-checks before code touches.

**What you get:** architecture with ADR-rated decisions, TDD scaffolding (tests first per Coverage Matrix), framework citations on every design choice. PII detected in the doc corpus auto-loops `cso-office.compliance-orchestrator`.

**Without Maxim:** no framework citation, no scope check, security review post-PR (or never).

---

### Use Case 3 · PM writing a PRD with Fogg B=MAP + JTBD

```
You: "/mxm-pm prd new operator onboarding flow"
```

**What fires:** `cpo-office` → `product-manager` + `onboarding-designer`. MCPs invoked: `mxm-behavioral.apply_framework Fogg-B-MAP` returns motivation/ability/prompt analysis · `mxm-behavioral.apply_framework JTBD` returns job statements via Ulwick's Jobs Atlas · `mxm-catalog.get_handoff_chain` returns cross-office collaboration map for the rollout.

**What you get:** PRD with Fogg B=MAP scope check, JTBD job statements (functional + emotional + social), RICE prioritization, and explicit collaboration handoffs to CMO (announcement) + CTO (implementation) + CSO (data-handling).

**Without Maxim:** PRD template with no framework grounding, scope creeps mid-sprint, RICE done by gut.

---

### Use Case 4 · Marketer creating a research-backed launch podcast in operator voice

```
You: "Create a podcast about our v1.3 launch using these customer interviews
      and product docs" + [drop URLs/PDFs]
```

**What fires:** `executive-router` → `cmo-office` → `notebooklm-content-production` (ADR-018 routing) → `{your-operator-id}-writer` for the intro/outro. MCPs invoked: `mxm-notebooklm.notebook_create` → `source_add_url` × N → `source_wait` → `generate_audio_overview format=deep-dive` → `artifact_wait` → `artifact_download`. Operator voice loaded via `.brand-foundation/personal.local/` (ADR-019 template pattern).

**What you get:** 20-min podcast in YOUR voice, with intro/outro in operator-voice (the same voice as your blog posts), citations from your source material, audit trail showing every framework that fired (Diátaxis explanation mode · Diffusion of Innovations multi-format generation).

**Without Maxim:** hand-write script, generic TTS, voice drift across artifacts.

---

### Use Case 5 · Session-end ritual you forgot you need

```
You: "/mxm-session-end"
```

**What fires:** `coo-office` → `planner` orchestrates the 9-document closure bundle. MCPs invoked: `mxm-portfolio.sync_portfolio` syncs project metrics · `mxm-memory.archive_session_memory` persists session to MemPalace · `mxm-context.watch_run` runs LIGHT drift scan across 13 classes.

**What you get:** SESSION_CONTINUITY.md updated · session-YYYY-MM-DD.md appended · CHANGELOG entry if user-facing change · MOAT_TRACKER row if positioning changed · AGENT_SKILL_INVENTORY refreshed if capabilities touched · project-manifest `last_activity` bumped · skill-gaps log appended. Per CLAUDE.md "Session without memory writes = session wasted."

**Without Maxim:** session memory lost, next session starts cold, drift accumulates.

---

### Use Case 6 · Auto-loop you didn't ask for (and saved you from a breach)

```
You: "Add user authentication to our app"
```

**What fires:** `cto-office` → `backend-architect` (primary) **automatically loops** → `cso-office` → `appsec-engineer` + `secure-code-reviewer` + `owasp-specialist`. MCPs invoked: `mxm-compliance.check_compliance` fires on the regulated-data signal (auth = PII) · `ethics-orchestrator` validates · OWASP Top 10 + LLM Top 10 frameworks cited inline.

**What you get:** auth implementation AND a parallel security review in the same conversation. Framework citations (OWASP Top 10 § A07:2021 Identification and Authentication Failures · NIST CSF PR.AC). 🔴 LOW tag and BLOCK if a known anti-pattern detected (plain-text password storage, missing rate-limiting, JWT without expiry).

**Without Maxim:** security review happens at PR time (best case) or never (typical case).

---

## The 9 MCPs at a glance · 95 tools you can call directly

| MCP | Tools | What it does |
|---|---:|---|
| **mxm-portfolio** | 9 | Project state, sync across 21+ projects, portfolio metrics |
| **mxm-context** | 15 | Architecture docs · design refs · 13-class drift detection |
| **mxm-catalog** | 9 | Agent + office + skill + command catalog, L2 specialist descent (route_task) |
| **mxm-compliance** | 5 | 14 jurisdictional frameworks · ROPA entries · per-jurisdiction requirements |
| **mxm-behavioral** | 7 | 78 behavioral frameworks · recommend · apply · score moat coverage |
| **mxm-memory** | 6 | Session history · decision log · cross-project memory |
| **mxm-voice** | 4 | Voice-driven office routing (wraps mbailey/voicemode for STT+TTS) |
| **mxm-commands** | 2 | All 49 slash commands as MCP tools (cross-surface command parity) |
| **mxm-notebooklm** | 38 | NotebookLM research synthesis (wraps teng-lin/notebooklm-py MIT · v1.2.1.0+) |

> v1.3.2 surface-claims-drift correction: prior README declared 87 tools by undercounting 4 MCPs (behavioral · context · memory · portfolio) by 2 each. Caught by pre-release-audit ground-truth grep against `server.tool(` declarations. Source-of-truth: `documents/ledgers/AGENT_SKILL_INVENTORY.md`.

**Cross-surface:** all 9 MCPs work on Claude Code · Desktop · Cowork. Claude.ai Web reaches them via MCP-over-API.

---

## The trial · why we default to it

You can't evaluate a moat you can't see. The 90-day trial unlocks all 6 L1 packs (the structural moats) plus L2 vertical bundles plus L3 industry packs. Run your real work through Maxim for three months:

- **Week 1-2:** install runs, you trigger your first auto-loops
- **Week 3-5:** drift detection catches something you didn't know was broken (Class 11 surface-claims-drift is the typical first surprise)
- **Week 6-9:** behavioral framework citations start changing your decisions — you see WHICH framework Maxim applied to which output, you understand why
- **Week 10-12:** you have data — which packs you actually used, which fired auto-loops on your real work, which compliance gates blocked work that would have been broken

By day 90 you know exactly which tier matches your work. Convert or downgrade without guessing.

---

## Tier roadmap

| Tier | Includes | Best for |
|---|---|---|
| **Solo** | Core (free forever) | Solo operators starting out · evaluating Maxim |
| **Pro** | Core + 6 L1 packs | Serious operators on 1-2 projects |
| **Team** | Core + L1 + 4 L2 verticals | Teams across founder · growth · pro · agency |
| **Enterprise** | All 14 packs (incl. L3 healthcare · legal · fintech · govtech) | Regulated industries · multi-team orgs |
| **Trial** | All 14 packs · 90 days · no card | Anyone evaluating |

Pricing at [maxim.isystematic.com/pricing](https://maxim.isystematic.com/pricing) — you decide after the trial, not before.

---

## For specific roles · use the persona dispatchers

Maxim ships 5 TIER 3 persona dispatchers that speak your vocabulary:

```
/mxm-legal     jurisdictional-map · privacy-impact · contract-review · vendor-dpa · regulatory-map
/mxm-arch      capability-map · wardley-map · tech-radar · c4-diagram · adr · vendor-eval
/mxm-secure    threat-model · owasp · sbom · incident · compliance-posture · ai-risk
/mxm-founder   pitch-deck · gtm-plan · runway-model · pricing · business-model-canvas · competitive-moat
/mxm-pm        prd · user-story · okr · prioritize · jtbd
```

Each persona routes to the right specialist within Maxim's 91-agent roster automatically. Legal pros think "DPIA," not "CSO compliance skill." Architects think "Wardley map," not "CEO enterprise-architect office." TIER 3 commands speak the persona's language and route invisibly.

---

## Multi-surface deployment

Maxim runs everywhere Claude does:

| Surface | Fidelity | What works |
|---|---|---|
| **Claude Code** | 100% | All 49 commands · 9 MCPs (95 tools) · 24 dispatchable subagents · all behavioral overlays |
| **Claude Desktop** | ~95% | 9 MCPs (95 tools) · paste `maxim-project-instructions.md` for behavioral layer |
| **Claude.ai Web** | ~85% | Project instructions · MCP-over-API when available |
| **Claude.ai Cowork** | ~85% | Plugin bundles MCPs natively |

Desktop one-command setup: `bash bootstrap/mxm-desktop-config.sh` or `pwsh -File bootstrap/mxm-desktop-config.ps1`.

---

## Architecture decisions · 21 ADRs (17 public · 4 confidential)

Maxim ratifies every architectural choice via ADRs. The 17 public ones describe Maxim's commitments to operators:

- [ADR-002](documents/ADRs/ADR-002-documents-as-executable-contracts.md) Documents as Executable Contracts (the structural rule)
- [ADR-004](documents/ADRs/ADR-004-free-tier-executable-contract.md) Free tier specification
- [ADR-007](documents/ADRs/ADR-007-behavioral-moat-framing-doctrine.md) Behavioral Moat Framing Doctrine
- [ADR-008](documents/ADRs/ADR-008-community-pack-system.md) Community Pack System
- [ADR-009](documents/ADRs/ADR-009-pack-architecture-l1-l2-l3.md) Pack Architecture (6 L1 + 4 L2 + 4 L3)
- [ADR-010](documents/ADRs/ADR-010-confidence-tag-technical-educator-rubric.md) Confidence Tag rubric
- [ADR-016](documents/ADRs/ADR-016-voice-writing-agent-architecture.md) Voice Writing Agent Architecture
- [ADR-017](documents/ADRs/ADR-017-office-as-dispatch-boundary.md) Office-as-Dispatch-Boundary
- [ADR-018](documents/ADRs/ADR-018-external-tool-integration-pattern.md) External Tool Integration Pattern
- [ADR-019](documents/ADRs/ADR-019-multi-tenant-readiness.md) Multi-Tenant Readiness (v1.3.0)
- [ADR-021](documents/ADRs/ADR-021-maxim-default-on-router.md) **Maxim Default-On — always-on intent router (v1.3.5)**
- plus ADR-011 · ADR-012 · ADR-013 · ADR-014 · ADR-015 (see [INDEX.md](documents/ADRs/INDEX.md))

Four additional ADRs cover internal architecture (dispatch baseline · IP protection · Worker license issuance · external content boundary) and remain in the operator's private ledger.

---

## License · community · support

**License:** BSL-1.1 — converts to Apache 2.0 after 4 years per ADR-005. Permissive enough to build on, structured enough to fund development.

**Issues:** [github.com/DrNabeelKhan/maxim/issues](https://github.com/DrNabeelKhan/maxim/issues)
**Pricing:** [maxim.isystematic.com/pricing](https://maxim.isystematic.com/pricing) (decide after the trial)
**Docs:** [HELP.md](documents/guides/HELP.md) for the full command catalog · [GETTING_STARTED.md](documents/guides/GETTING_STARTED.md) for onboarding · [INSTALL.md](documents/INSTALL.md) for multi-surface deployment

---
_Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc. Licensed under Business Source License 1.1._