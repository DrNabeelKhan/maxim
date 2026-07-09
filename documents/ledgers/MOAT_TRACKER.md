# Maxim — Moat Tracker

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 15 rows (MOAT-01…15; latest: **MOAT-14 Autonomous Workflow Standard** + **MOAT-15 default-on router**, added 2026-06-26 / v1.3.8). New rows land as L2 bundles, L3 verticals, and community packs ship, each pairing a pack's SKILL.md with the behavioral framework it applies per ADR-007.

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

Every row cites a framework from `documents/reference/FRAMEWORKS_MASTER.md` by name. The mechanism column states what the framework does when applied correctly; the anti-pattern column describes what a generic LLM produces without the framework applied.

### MOAT-01 · AI Governance anchor

| Field | Value |
|---|---|
| **Positioning claim** | Every AI decision your operator produces carries an audit trail with loss-framed risk weighting, not confident prose. |
| **Mechanism** | Prospect Theory — losses weighted ~2× gains, so outputs flag downside risk explicitly (failed audit, wrong framework, compliance drift) rather than presenting upside only. See `FRAMEWORKS_MASTER.md` → Cognitive Biases · Prospect Theory. |
| **Anti-pattern** | Generic LLM produces confident recommendations with no loss framing. Operator reads, ships, discovers the cost of the loss after it's realized. |
| **Pack(s)** | L1.1 AI Governance |
| **Primary framework** | Prospect Theory (Kahneman & Tversky, 1979) |
| **Proof** | [`packs/pack-l1-1-ai-governance/skills/ai-governance/SKILL.md`](../../packs/pack-l1-1-ai-governance/skills/ai-governance/SKILL.md) |

### MOAT-02 · MemPalace Pro anchor

| Field | Value |
|---|---|
| **Positioning claim** | Cross-session memory that resumes your project where you left it, applying a graph structure tuned to working-memory limits rather than re-flooding context on every session. |
| **Mechanism** | Cognitive Load Theory — intrinsic / extraneous / germane load budgeting. MemPalace loads only the ~4 chunks relevant to the active task, not the whole project history, matching Miller's Law and Sweller's chunking research. |
| **Anti-pattern** | Generic LLM re-reads every doc on every session, overwhelming context window, dropping mid-session memory, answering recent questions without historical context. |
| **Pack(s)** | L1.2 MemPalace Pro |
| **Primary framework** | Cognitive Load Theory (Sweller, 1988) + Miller's Law (Miller, 1956) |
| **Proof** | [`packs/pack-l1-2-mempalace-pro/skills/mempalace-pro/SKILL.md`](../../packs/pack-l1-2-mempalace-pro/skills/mempalace-pro/SKILL.md) |

### MOAT-03 · Proactive Watch anchor

| Field | Value |
|---|---|
| **Positioning claim** | 13 drift classes scan on every session start — docs vs code, counts vs filesystem, moat claims vs this ledger, compliance trail integrity. Silent regressions surface before ship, not after. |
| **Mechanism** | Signal Detection Theory — explicit threshold tuning per drift class, with severity 1–5 scoring so high-severity drift blocks session continuation and low-severity drift logs to review queue. |
| **Anti-pattern** | Generic LLM has no drift awareness across sessions. Docs lie about what code does, counts in README don't match reality, nobody catches it until a customer or auditor does. |
| **Pack(s)** | L1.3 Proactive Watch |
| **Primary framework** | Signal Detection Theory (Green & Swets, 1966) |
| **Proof** | [`packs/pack-l1-3-proactive-watch/skills/proactive-watch/SKILL.md`](../../packs/pack-l1-3-proactive-watch/skills/proactive-watch/SKILL.md) · [`composable-skills/frameworks/proactive-watch.md`](../../composable-skills/frameworks/proactive-watch.md) |

### MOAT-04 · Compliance Shield anchor

| Field | Value |
|---|---|
| **Positioning claim** | 14 compliance frameworks enforced at the MCP layer — GDPR, HIPAA, PCI-DSS, SOC 2, PIPEDA, UAE-PDPL, CASL, FINTRAC, EU AI Act, ISO 27001, ISO 13485, ISO 14971, NIST CSF, WCAG 2.1. Outputs that touch regulated data are blocked at generation, not flagged after. |
| **Mechanism** | COM-B applied to compliance behavior — operator Capability (know the rule), Opportunity (frameworks loaded into context automatically), Motivation (compliance gate blocks bad output) must all fire for a Behavior change. Removes "I forgot which framework applies" from the equation. |
| **Anti-pattern** | Generic LLM mentions compliance when asked, skips it when not asked. Post-hoc review finds violations. Operator rewrites. Cost compounds. |
| **Pack(s)** | L1.4 Compliance Shield · L3.1 Healthcare · L3.2 Legal · L3.3 Fintech · L3.4 GovTech |
| **Primary framework** | COM-B (Michie, van Stralen & West, 2011) · see `FRAMEWORKS_MASTER.md` → COM-B Model |
| **Proof** | [`packs/pack-l1-4-compliance-shield/skills/compliance-shield/SKILL.md`](../../packs/pack-l1-4-compliance-shield/skills/compliance-shield/SKILL.md) · `mcp/mxm-compliance/` |

### MOAT-05 · Brand & Design Pro anchor

| Field | Value |
|---|---|
| **Positioning claim** | Your brand voice locked across every AI output. System 1 recognition cues (visual hierarchy, tone signature, micro-typography) applied deliberately, so readers *feel* the brand without cognitive effort. |
| **Mechanism** | Dual Process Theory — System 1 fast recognition tuned by consistent voice overlay, System 2 reflection reserved for evaluating substance. Brand drift breaks System 1 recognition; Maxim's three-layer voice overlay prevents drift on every session. |
| **Anti-pattern** | Generic LLM produces on-brand copy on Monday, off-brand copy on Friday. Each session starts blind to prior voice decisions. Your Twitter thread and your pricing page read like two different companies. |
| **Pack(s)** | L1.5 Brand & Design Pro |
| **Primary framework** | Dual Process Theory (Kahneman, 2011) · see `FRAMEWORKS_MASTER.md` → Dual Process Theory |
| **Proof** | [`packs/pack-l1-5-brand-design-pro/skills/brand-design-pro/SKILL.md`](../../packs/pack-l1-5-brand-design-pro/skills/brand-design-pro/SKILL.md) · [`.brand-foundation/personal/voice-profile.md`](../../.brand-foundation/personal/voice-profile.md) |

### MOAT-06 · Behavioral Intelligence flagship

| Field | Value |
|---|---|
| **Positioning claim** | 86 peer-reviewed frameworks (behavioral science at the core, extended with security · compliance · enterprise-architecture · engineering) applied to every Maxim output. Mechanism named, anti-pattern registered, citation provided. The replication barrier is not the framework count — it is the registry that makes each framework enforceable. |
| **Mechanism** | Fogg Behavior Model B=MAP as the composition root — every output must have Motivation lever (why the reader acts), protected Ability lever (no friction), and timed Prompt lever (placed at the trigger moment). Every other framework plugs into one of the three levers. |
| **Anti-pattern** | Generic LLM lists frameworks when asked, applies none when not asked. Competitors can also list 86 frameworks; they cannot replicate the enforcement, because enforcement lives in the process discipline — ADR-007 framework-citation at output time, the commit-time SKILL.md structure check (`behavioral-moat-drift`, CLI hook), and the pre-release-audit gate — not in a marketing claim. |
| **Pack(s)** | L1.6 Behavioral Intelligence (flagship) · plus every other L1 cites this pack's framework registry |
| **Primary framework** | Fogg Behavior Model / B=MAP (Fogg, 2009) · see `FRAMEWORKS_MASTER.md` → Fogg Behavior Model (FBM). Supporting: Cialdini's 6 Principles, Hook Model, EAST, Nudge Theory, TTM, SDT. |
| **Proof** | [`packs/pack-l1-6-behavioral-intelligence/skills/behavioral-intelligence/SKILL.md`](../../packs/pack-l1-6-behavioral-intelligence/skills/behavioral-intelligence/SKILL.md) · [`documents/reference/FRAMEWORKS_MASTER.md`](../reference/FRAMEWORKS_MASTER.md) |

---

### MOAT-07 · Operator agents behind vertical compliance overlays

| Field | Value |
|---|---|
| **Positioning claim** | Maxim ships the only Claude-native operator roster that goes beyond compliance *awareness* to compliance *authorship* — FDA submissions, MDR technical files, CAPA workflows, PCI-grade payment flows written by specialist agents who cite the exact clause. |
| **Mechanism** | Social Learning Theory — regulator-facing documents follow strict genre conventions (tone, evidence format, citation discipline) that specialist agents replicate by modeling observed regulator-approved submissions, not by generating from compliance-rule abstractions. See `FRAMEWORKS_MASTER.md` → Social Learning Theory (Bandura) — roadmap v1.2. Supporting: Prospect Theory for risk-weighted language; Constitutional AI for audit-trail alignment (roadmap v1.3). |
| **Anti-pattern** | Generic LLM knows what HIPAA / MDR / PCI-DSS *require* but produces text that reads like a summary, not a submission. Regulator rejects; operator rewrites; Maxim's value didn't reach the artifact. |
| **Pack(s)** | L3 Healthcare overlay · L3 Fintech overlay · L3 Legal overlay · L3 GovTech overlay — all four get operator rosters starting v1.4 |
| **Primary framework** | Social Learning Theory (Bandura, 1977) · roadmap v1.2 |
| **Proof** | [`documents/reference/FRAMEWORK_ROADMAP.md`](../reference/FRAMEWORK_ROADMAP.md) — CRO operator roster + Fintech specialist domain scheduled v1.4. |

### MOAT-08 · Runtime tier enforcement (license middleware) · v1.1.0 SHIPPED

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude-native plugin where paid features are enforced at the MCP layer, not on the honor system — every tool call hits a tier gate locally (cache-file fast path, no network on hot path), with grant verification, JWT signature check, daily heartbeat for revocation propagation, and a Worker-issued JWT that ties tier to the machine fingerprint. Open-source code; gated runtime. |
| **Mechanism** | Operant Conditioning + Loss Aversion — paid tiers receive features that are demonstrably absent on Starter (not "limited" — *absent*, with `GRANTS_INSUFFICIENT` errors that name the tier upgrade path). Loss-frame language at the gate ("compliance-14 grant not present in your starter tier") drives upgrade conversion harder than gain-framed marketing copy. See `FRAMEWORKS_MASTER.md` → Prospect Theory + Operant Conditioning — both shipped v1.0.0. |
| **Anti-pattern** | Open-source plugins that gate paid features by trust ("please upgrade to use this") — easily bypassed; doesn't scale; no audit trail. Or commercial plugins that gate by code obfuscation — public-source contradiction. Maxim's pattern: public source, runtime gate, transparent grant catalog (`cloudflare-worker/grants.json`). |
| **Pack(s)** | All paid tiers (Solo $19.99 / Pro $39 / Professional $99 / Team $249) + 4 vertical overlays (Healthcare $249 / Legal $199 / Fintech $199 / GovTech $149). Tier-specific grants documented in `cloudflare-worker/grants.json` (54-grant catalog). |
| **Primary framework** | Prospect Theory (Kahneman & Tversky 1979) — loss-frame at the gate. Supporting: Operant Conditioning for tier-progression behavior shaping. |
| **Proof** | v1.1.0 SHIPPED 2026-04-27. `mcp/_shared/license-gate.mjs` (419 lines) + `cloudflare-worker/src/v11a-license.ts` (361 lines) + 9/9 E2E tests passing in `mcp/_shared/license-gate.test.mjs`. All 7 MCP servers gated. CHANGELOG.md v1.1.0 entry. Locked design captured at `~/.claude/projects/E--Projects-Maxim/memory/project_v1.1.A_locked_design.md` (G1–G7). ADR-013 pending in v1.1.1 sprint. |

---

### MOAT-10 · Voice-faithful writing agents — operator + per-startup · ADR-016 SHIPPED v1.2.0

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude Code plugin that ships dedicated writing agents that route every writing task through a content-type-aware voice routing authority (`myVoiceDNA/VOICE_SELECTION.md` for operators; `.brand-foundation/startups/{name}/` for customer-facing brand). The agent classifies one of 22 content types, picks the right variant, loads the correct files (≤15K tokens), applies the right crossover budget, and validates against a quality checklist before emission. Other AI tools produce content in the model's default voice; Maxim produces content in the operator's voice by structural enforcement, not by prompting hope. |
| **Mechanism** | Operant Conditioning (Skinner, 1938) — reinforcement schedule for voice consistency. Every Maxim output reads native to the operator because the routing authority is consulted at task receipt, not after the output is drafted. The operator's voice becomes the default behavior, not a thing they ask for. Once enabled, voice drift is structurally impossible (the agent reads VOICE_SELECTION.md fresh per task; if the file changes, behavior changes immediately). Supporting: Self-Determination Theory — operators experience competence (their writing sounds like them) and autonomy (they own the voice files). |
| **Anti-pattern** | AI tools that produce content "in your voice" by prompt-engineering ("write like X") — fragile, drifts within a single conversation, requires re-priming each session. Or systems that hardcode a voice spec into the model — locks voice to model weights, can't update without retraining. Maxim's pattern: voice files are operator-owned, agent reads them at task time, routing table is the canonical authority. |
| **Pack(s)** | Voice agents ship in the base plugin v1.2.0. Per-startup brand writers (template-instantiated) are part of the L1.6 Behavioral Intelligence pack value (operator-customized writers powered by behavioral framework stack). |
| **Primary framework** | Operant Conditioning (Skinner, 1938) + Self-Determination Theory (Deci & Ryan, 1985). ADR-016 ratified 2026-05-15. |
| **Proof** | SHIPPED v1.2.0. ADR-016 at `documents/ADRs/ADR-016-voice-writing-agent-architecture.md`. Source-of-truth file: `E:/Projects/nabeelkhan/myVoiceDNA/VOICE_SELECTION.md` (v1.0, 22 content types, last_updated 2026-05-19). Components: `nk-writer` agent (CMO, `agents/MXM/cmo/nk-writer.md`), `voice-routing` skill, `_template-brand-writer.md` template. |

---

### MOAT-09 · Maxim Studio — AGPL-3.0 desktop GUI face · ADR-014 PLANNED v0.1.0

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude Code plugin with a dedicated open-source desktop GUI (AGPL-3.0). Studio renders the 91-agent roster, 86-framework library, 13 Proactive Watch drift classes, and license tier in a visual chrome that non-developers can evaluate without reading documentation. Pack catalog updates dynamically when new packs ship — zero Studio code change required. |
| **Mechanism** | Endowment Effect (Kahneman & Knetsch, 1991) — a visual face the user can see and touch increases perceived ownership before purchase. The Studio makes Maxim's moat tangible: operators who open the Executive Dispatch sidebar and see 91 agents mapped across 7 offices experience the product differently than those who read about it in a TUI banner. Tangible = higher willingness to upgrade. Supporting: Cialdini Social Proof (21.8k-star opcode upstream = credibility transfer). |
| **Anti-pattern** | CLI-only plugins that assume all users are developers who read documentation. Maxim's moat is invisible to non-developers without a visual surface. Studio removes that barrier. |
| **Pack(s)** | Studio is free (AGPL-3.0). Revenue flows through the BSL plugin + Cloudflare Worker. Studio is the acquisition gateway for all paid packs, not a revenue source itself. |
| **Primary framework** | Endowment Effect (Kahneman & Knetsch, 1991). ADR-014 ratified 2026-05-13. |
| **Proof** | PLANNED. ADR-014 at `documents/ADRs/ADR-014-maxim-studio-agpl-shell.md`. Architecture at `documents/reference/MAXIM_STUDIO_ARCHITECTURE.md`. Sprint bootstrap at `documents/architecture/maxim-studio/sprint-bootstrap.md`. Fork: `github.com/DrNabeelKhan/maxim-studio` (AGPL-3.0, target v0.1.0 ~8 weeks from sprint start). |

---

### MOAT-11 · Two-layer dispatch with cross-surface parity · ADR-017 SHIPPED v1.2.0.4

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude plugin with 91 reachable agents that ships a **structurally enforced two-layer dispatch**: 24 office-routing subagents at the dispatch tier + 91-agent specialist catalog reached programmatically via `mxm-catalog` MCP. Cross-surface parity by construction — same specialist tier on Claude Code AND Claude Desktop AND Claude.ai Web (via MCP). |
| **Mechanism** | Office-as-Dispatch-Boundary architecture (ADR-017). Each office agent is a thin internal router that calls `mxm-catalog.route_task()` + `get_agent_dna()` to embody the right specialist for a given task. Specialist tier is MCP-native, not subagent-native — so the same routing path works on every Claude surface that has the MCP. The 91-agent claim becomes structurally true rather than aspirational. |
| **Anti-pattern** | Other plugins with 100+ agents either (a) promote them all to the subagent registry — registry bloat + 5–6-hop dispatch chains, OR (b) ship them as filesystem documents only — unreachable from the dispatch surface (the v1.2.0.3 KFAS WhatsApp failure mode). Neither pattern scales cross-surface; both force operators to discover which agents are "real" and which are aspirational. |
| **Pack(s)** | Free tier (architecture-level moat). Every paid pack benefits — Pack 6 Behavioral Intelligence in particular, because specialist routing is what makes the 86 frameworks dispatchable per task. |
| **Primary framework** | Hierarchical Dispatch + Programmatic Catalog (pattern documented in ADR-017). Cites the same architectural lineage as Anthropic's `claude-skills-library` (~536 SKILL.md, handful plugin-discoverable). Maxim's contribution: pairing it with a structured MCP catalog instead of filesystem-only. |
| **Proof** | [ADR-017](../ADRs/ADR-017-office-as-dispatch-boundary.md). v1.2.0.4 commit. 7 office agents + 5 governance orchestrators net-new in `.claude/agents/`. 91-agent catalog routed via `mxm-catalog` MCP (8 tools). Same routing surface on Desktop via MCP. Telemetry path opens via `mxm-catalog.get_agent_dna` call logging. |

---

### MOAT-12 · Research synthesis via NotebookLM with multi-office routing · ADR-018 SHIPPED v1.2.1.0

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude plugin that ships **NotebookLM integration as a first-class capability** with multi-office routing (CINO research synthesis · CMO content production · CPO learning artifacts · CSO compliance gate). 38 MCP tools cover the complete upstream feature surface. Cross-surface by construction — works on Claude Code · Desktop · Web · Cowork via MCP. |
| **Mechanism** | Three-layer integration pattern (ADR-018): community-pack copy of upstream MIT skill + Maxim-flavored skill with behavioral framing (Diátaxis + Diffusion of Innovations + Dual Coding Theory) + 38-tool MCP server wrapping the notebooklm CLI. The mcp-catalog `SPECIALISTS` routing classifies tasks into the right office's notebooklm-specialist (research / content production / learning artifacts). Source uploads trigger CSO `compliance-orchestrator` auto-loop for PII/regulated-data scanning before Google ingestion. |
| **Anti-pattern** | A competing plugin that wraps NotebookLM ships a flat CLI passthrough — no office routing, no ethics gate on source upload, no behavioral framing on artifact selection, no audit trail tying the artifact back to compliance posture. Operator gets the tool but loses the governance layer that makes the tool safe and consistent across regulated workflows. |
| **Pack(s)** | Free tier (per ADR-018 free-tier-default for external tool wrappers). Benefits Pack 6 Behavioral Intelligence indirectly — artifact-selection framing cites Pack 6 frameworks. |
| **Primary framework** | Diátaxis (Procopiou) — distinct artifact types serve distinct learning modes (tutorials · how-to · reference · explanation). Diffusion of Innovations (Rogers) — multi-format artifacts let each adopter category consume in their preferred mode. ADR-018 ratified 2026-05-20. |
| **Proof** | [ADR-018](../ADRs/ADR-018-external-tool-integration-pattern.md). v1.2.1.0 commits. `.claude/skills/notebooklm-py/SKILL.md` (Maxim-flavored). `community-packs/notebooklm-py/` (upstream MIT verbatim). `mcp/mxm-notebooklm/server.js` (38 tools across notebook/source/chat/research/generate/artifact/auth/profile domains). Office routing wired in `mcp/mxm-catalog/server.js` SPECIALISTS map for CINO · CMO · CPO. CSO source-upload ethics gate documented in `.claude/agents/cso-office.md`. |

---

### MOAT-13 · Multi-tenant readiness with behavioral-persuasion install wizard · ADR-019 SHIPPED v1.3.0

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude plugin that ships a **tier-aware install wizard with behavioral persuasion framings** (loss aversion + default effect + endowment effect) AND a **per-operator voice-writer template pattern** so every operator's voice locks across every output. 90-day Trial of all 14 packs defaults at install — operators see the moat work on their real work before deciding which tier to keep. |
| **Mechanism** | Two coordinated changes per ADR-019: (a) `bootstrap/install-tier-packs.{sh,ps1}` reduces 14 install commands to 1 decision · Trial pre-selected per Default Effect (Thaler) · Endowment Effect setup over 90-day trial period · No prices in wizard (Anchoring works against capability framing if cost surfaces first). (b) `_template-operator-writer.md` instantiated per-operator via `/mxm-brand-voice calibrate` · `cmo-office.md` operator-id lookup routing · nk-writer preserved as canonical example of advanced voiceDNA. |
| **Anti-pattern** | A competing plugin ships 14 install commands operators run sequentially (or doesn't ship paid packs at all). Voice routing hardcoded to maintainer's machine path. Public docs read like API reference with no behavioral framing or use cases. Operators have to figure out "what does this DO for me" from a capability list. |
| **Pack(s)** | Free tier (the wizard + template ship in Core). The wizard enables tier selection that activates paid packs L1.1 through L3.4 via JWT. |
| **Primary framework** | Prospect Theory (Kahneman & Tversky 1979) — loss aversion ~2× over gain. Default Effect (Thaler & Sunstein 2008) — defaults frame as recommended path. Endowment Effect (Kahneman & Knetsch 1991) — possession increases valuation. ADR-019 ratified 2026-05-20. |
| **Proof** | [ADR-019](../ADRs/ADR-019-multi-tenant-readiness.md). v1.3.0 commits. `bootstrap/install-tier-packs.{sh,ps1}` (358 lines). `agents/MXM/cmo/_template-operator-writer.md` (template, 170 lines). `cmo-office.md` operator-id lookup logic. Public docs rewrites in README · MXM_RUNDOWN · ABOUT · INSTALL · GETTING_STARTED. |

---

### MOAT-14 · Autonomous Workflow Standard — autonomy that cannot run away · ADR-022 SHIPPED v1.3.8

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude-native plugin that ships an **Autonomous Workflow Standard**: unattended multi-step workflows where a **budget guard hard-kills** on token / tool-call / runtime / cost breach, a **verification gate runs separately from generation**, every run is **idempotent**, and **dry-run is ON by default**. Autonomy you can actually let run, because it is structurally incapable of running away. |
| **Mechanism** | Bounded Agent Loop (Explicit Stopping Conditions) + Independent Verification (Generation–Approval Separation) — the two loop-derived frameworks codified in v1.3.3. The `mxm-orchestrator` separates the agent that *does* the work from the gate that *approves* it, and every workflow declares its budget ceiling before the first step runs. See `FRAMEWORKS_MASTER.md` loop-derived frameworks. |
| **Anti-pattern** | Generic agent loops run until they finish or exhaust the budget — no hard ceiling, no separate verifier, no idempotency marker, no dry-run gate. A runaway loop spends real money and ships unverified output. Maxim's orchestrator cannot exceed its declared budget and will not go live without a passing verification gate. |
| **Pack(s)** | Free tier (architecture-level moat). Every paid pack benefits — autonomous workflows can dispatch any office's specialist under the same budget + verification contract. |
| **Primary framework** | Bounded Agent Loop / Explicit Stopping Conditions + Independent Verification / Generation–Approval Separation (v1.3.3 loop-derived). ADR-022 ratified 2026-06-26. |
| **Proof** | [ADR-022](../ADRs/ADR-022-autonomous-workflow-standard.md). v1.3.8 commits. `orchestrator/engine.mjs` (BudgetGuard hard-kill · StateStore + idempotency · unified RunLog · dead-letter · dry-run default). Acceptance test 29/29 in `orchestrator/acceptance-test.mjs`. `/mxm-workflow` command + `orchestrator` skill + 2 reference workflows under `orchestrator/workflows/`. |

---

### MOAT-15 · Default-on governance — the behavioral layer fires whether or not you ask · ADR-021 SHIPPED v1.3.5

| Field | Value |
|---|---|
| **Positioning claim** | Maxim is the only Claude plugin that **routes every prompt to the right executive office automatically** — you never have to remember which command to type. A prompt-submit hook classifies intent, names the skills + frameworks to apply, and shows the routing token cost up front. Governance is the *default path*, not an opt-in the operator forgets after the demo. |
| **Mechanism** | EAST (Easy · Attractive · Social · Timely) — removing the "which command do I use?" friction makes the governed path the *default* path. The router fires at prompt submit, before the model answers, so the correct office + frameworks load without the operator choosing. Friction is the enemy of a behavioral layer; the router removes it. |
| **Anti-pattern** | Plugins where you must remember the right slash command or the governance layer never engages — friction means it gets used in the demo and forgotten in daily work. Maxim's router makes the behavioral layer engage on every prompt, asked for or not. |
| **Pack(s)** | Free tier. Claude Code CLI surface (hooks are CLI-native; Desktop/Web reach the same offices via the `mxm-commands` + `mxm-catalog` MCP). |
| **Primary framework** | EAST (Behavioural Insights Team, 2014) · see `FRAMEWORKS_MASTER.md`. ADR-021 ratified 2026-06-19. |
| **Proof** | [ADR-021](../ADRs/ADR-021-maxim-default-on-router.md). v1.3.5 commits. `.claude/hooks/user-prompt-router.{sh,ps1}` + `config/routing-table.json` (word-boundary matching + weak-keyword gate, hardened v1.3.8). Routing token-cost banner + opt-out. |

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
