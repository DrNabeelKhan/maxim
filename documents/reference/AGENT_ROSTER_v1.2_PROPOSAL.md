# Agent Roster + UX Surface — v1.2 Proposal

> Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
> SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)

| Version | Last Updated | Owner | Status |
|---|---|---|---|
| 1.0 | 2026-04-27 | Dr. Nabeel Khan | LOCKED — pending v1.2 sprint kickoff |

Authoritative reference: [`FRAMEWORK_ROADMAP.md`](./FRAMEWORK_ROADMAP.md) § v1.2.

---

## TL;DR

Maxim's v1.0 user-facing surface buries the moat behind generic abstractions. 38 office-prefixed commands, 90 generic-named agents, catalog-dump help. A first-time user can't find the front door in 10 seconds.

**v1.2 fixes this with three coordinated changes:**

1. **Three-tier command surface** — VERB (intent, NEW) + OFFICE (role, current) + PERSONA (profession, NEW). Plain-English commands route invisibly to the right specialists.
2. **Agent roster expansion** — keep current office leads (improved DNA), add ~25 named specialists per moat. Office lead becomes router; specialist delivers depth.
3. **Comprehensive `/mxm-help` system** — auto-detects persona from `project-manifest.json`, returns persona-specific quick-start. Multi-mode catalog (commands / agents / frameworks / compliance / moat / getting-started).

**Effort: ~22–35 dev-days net new work**, on top of v1.2's already-scheduled 10 behavioral frameworks (~30–40 days). Total v1.2 = ~52–75 dev-days.

---

## Why this lands in v1.2 (not later)

- v1.1 ships license middleware + MOE + 7 compliance frameworks. Enterprise-readiness story.
- **v1.2 ships behavioral expansion + UX accessibility.** Adoption story.
- Without v1.2, every framework Maxim adds in v1.3+ stays buried for non-power-users. The marginal value of more frameworks is gated by surface accessibility.

Bundling decision (locked Session 14): no public-stability concern (only two testing users, both will update plugin before next session). The original v1.1.5-standalone proposal is dissolved; verb-first commands ship inside v1.2.

---

## The diagnosis — what's broken in v1.0

A first-time user opens their terminal, types `/maxim:`, sees 38 commands. Three problems compound:

### Problem 1 — Internal architecture is the user surface

Maxim's office model (CEO, CTO, CMO, CSO, CPO, COO, CINO) is meaningful to a founder building a SaaS. To a backend engineer who just wants to fix a bug, it's baffling. The user-facing command names (`/mxm-cto`, `/mxm-cso`) leak Maxim's internal org chart.

### Problem 2 — Commands describe roles, not intents

A user thinks "I want to build a feature." Not "I want to invoke the CTO office's implementer agent with TDD discipline." The verb-first surface is missing.

### Problem 3 — Discovery is a catalog dump

`/mxm-help` lists everything — 38 commands, 90 agents, 64 frameworks. Nothing curated. Nothing scenario-driven. The 10-second pitch never gets a chance to land.

### Compound effect

The behavioral-science layer, 90 agents, 64 frameworks — all genuinely valuable — never demonstrate value because the user can't find the front door. Maxim's moat is real but invisible.

---

## Three-tier command surface

```
TIER 1 — VERB (intent)         TIER 2 — OFFICE (role)        TIER 3 — PERSONA (profession)
─────────────────────          ──────────────────────         ─────────────────────────────
/mxm-build  <X>                /mxm-cto                       /mxm-legal     <X>
/mxm-fix    <X>                /mxm-cmo                       /mxm-arch      <X>
/mxm-ship   <X>                /mxm-cso                       /mxm-secure    <X>
/mxm-plan   <X>                /mxm-cpo                       /mxm-founder   <X>
/mxm-review <X>                /mxm-coo                       /mxm-pm        <X>
/mxm-explain <X>               /mxm-ceo                       (4 deferred to v1.2.x)
/mxm-help                      /mxm-cino
                               /mxm-route
                               + 24 specialist commands
```

### TIER 1 — Verb-first hero commands (intent matches dev workflow events)

| Command | User intent | Routes to | Behavioral overlay |
|---|---|---|---|
| `/mxm-build <X>` | "Build me a feature / module" | CTO (implementer) + CSO auto-loop on regulated data + CPO (UX) if frontend | Fogg B=MAP scope check; TDD discipline |
| `/mxm-fix <X>` | "Fix this bug / failing test" | CTO + tester + reviewer | Systematic Debugging; root-cause discipline |
| `/mxm-ship <X>` | "Cut a release / publish / deploy" | COO (planner) + CSO + reviewer + CMO (CHANGELOG) | Session-end bundle; SBOM check |
| `/mxm-plan <X>` | "Plan sprint / feature / migration" | COO (planner) + product-strategist + behavioral framework selector | Planning-with-Files; Coverage Matrix |
| `/mxm-review <X>` | "Review this code / PR / doc" | reviewer + CSO (if security-adjacent) + tester (if test code) | Framework citation requirement |
| `/mxm-explain <X>` | "Help me understand this" | smart-explorer + relevant office | Plain-language confidence tag |
| `/mxm-help` | "What can I do here?" | help skill — opinionated, scenario-driven | NOT a catalog dump |

### TIER 2 — Office commands (current, stays as-is)

`/mxm-cto`, `/mxm-cmo`, `/mxm-cso`, `/mxm-cpo`, `/mxm-coo`, `/mxm-ceo`, `/mxm-cino`, `/mxm-route`, plus 24 specialist commands. Power-user route. **No deprecation. Backward-compatible forever.**

### TIER 3 — Persona commands (NEW in v1.2 — the moat showcase)

Each TIER 3 command speaks the persona's vocabulary, surfaces moat moments specific to that profession, and routes to the right specialist agents invisibly.

---

## TIER 3 — Persona detail (5 personas locked for v1.2)

### `/mxm-legal` — In-house counsel, privacy lawyers, contracts, GRC

| Sub-command | What it does | Moat moment |
|---|---|---|
| `/mxm-legal jurisdictional-map <data-flow>` | Maps a data flow against GDPR/PIPEDA/UAE-PDPL/CCPA/LGPD/PIPL/HIPAA/PCI-DSS — declares which apply, where exemptions land | 14 compliance frameworks with jurisdictional logic |
| `/mxm-legal privacy-impact <feature>` | DPIA-style write-up: data categories, lawful basis, retention, transfer mechanism, ROPA entry | DPIA is what privacy lawyers actually need; rare in AI tools |
| `/mxm-legal contract-review <doc>` | Issue-spotting: limitation of liability, IP assignment, indemnification, jurisdiction, DPA | Pairs reviewer + gdpr-counsel agents |
| `/mxm-legal vendor-dpa <vendor>` | Generates a Data Processing Addendum tailored to project's compliance scope | Output an actual artifact |
| `/mxm-legal regulatory-map <product>` | What laws apply: AI Act + ISO 42001 (if AI), SOX (if public co), DORA (if EU fintech), HIPAA (if PHI) | Layered framework reasoning |

### `/mxm-arch` — Enterprise architects (TOGAF / C4 / ArchiMate practitioners)

| Sub-command | What it does | Moat moment |
|---|---|---|
| `/mxm-arch capability-map <domain>` | TOGAF-style capability map with maturity levels, gaps, owners | Architects expect TOGAF artifacts |
| `/mxm-arch wardley-map <strategy>` | Wardley map with components classified Genesis→Custom→Product→Commodity | First AI tool to ship Wardley natively |
| `/mxm-arch tech-radar` | ThoughtWorks-style radar: Adopt / Trial / Assess / Hold | Board-ready artifact |
| `/mxm-arch c4-diagram <system>` | Context / Container / Component / Code level renders | Auto-picks the right level |
| `/mxm-arch adr <decision>` | Lightweight ADR per ADR-001 template | Maxim's ADR system surfaced |
| `/mxm-arch vendor-eval <category>` | Vendor scorecard: cost, lock-in, compliance, performance, support | Wardley + cost-analyst combined |

### `/mxm-secure` — CISOs, AppSec engineers, GRC managers, threat modelers

| Sub-command | What it does | Moat moment |
|---|---|---|
| `/mxm-secure threat-model <system>` | STRIDE / PASTA / LINDDUN-flavored threat model with mitigations | Real artifact, not a checklist |
| `/mxm-secure owasp <code>` | OWASP Top 10 + OWASP LLM Top 10 (v1.3) + OWASP API Top 10 audit | Triple OWASP coverage |
| `/mxm-secure sbom <project>` | SPDX 3.0 / CycloneDX SBOM + AIBOM for ML components | AIBOM is EU AI Act Article 53 requirement |
| `/mxm-secure incident <event>` | NIST CSF / MITRE ATT&CK incident-response playbook | Mature framework citations |
| `/mxm-secure compliance-posture` | Multi-framework dashboard: SOC2 + ISO 27001 + GDPR + PCI-DSS gap report | mxm-compliance MCP + security-analyst |
| `/mxm-secure ai-risk <model>` | NIST AI RMF + MITRE ATLAS adversarial-ML threat matrix | Two AI-specific frameworks competitors lack |

### `/mxm-founder` — Early-stage, technical, product-led founders

| Sub-command | What it does | Moat moment |
|---|---|---|
| `/mxm-founder pitch-deck <thesis>` | Investor deck: problem / solution / market / moat / traction / ask, applying Duarte Sparkline + Minto Pyramid | Deck framework citations show craft |
| `/mxm-founder gtm-plan <product>` | AARRR funnel + first 100 customers playbook | Pirate Metrics is Tier 2 framework |
| `/mxm-founder runway-model <expenses>` | Cash runway: burn rate, cohort LTV, breakeven month, dilution scenarios | Spreadsheet-grade math |
| `/mxm-founder pricing <product>` | Pricing using Prospect Theory + Van Westendorp + tier laddering | Behavioral-science applied to pricing |
| `/mxm-founder business-model-canvas` | BMC + Value Proposition Canvas pair | Strategyzer toolkit native |
| `/mxm-founder competitive-moat` | Moat audit: 7 moat types, current strength, defensibility timeline | MOAT_TRACKER framework surfaced |

### `/mxm-pm` — Product managers (PRD authors, JTBD practitioners)

| Sub-command | What it does | Moat moment |
|---|---|---|
| `/mxm-pm prd <feature>` | PRD with problem / hypothesis / metrics / scope / risks | Standard artifact, opinionated structure |
| `/mxm-pm user-story <task>` | INVEST-validated user stories with acceptance criteria | INVEST framework cited |
| `/mxm-pm okr <quarter>` | OKR draft with leading + lagging indicators | OKR framework Tier 3 roadmap |
| `/mxm-pm prioritize <backlog>` | RICE / ICE prioritization with reasoning | Quantified ranking |
| `/mxm-pm jtbd <user>` | Jobs-to-be-Done analysis: Job statement, Job map, outcome statements | Tony Ulwick's Jobs Atlas Tier 2 |

### Deferred to v1.2.x (full sub-command sketches preserved here)

#### `/mxm-research` — R&D, academic researchers, market researchers

`/mxm-research lit-review <topic>`, `/mxm-research hypothesis <observation>`, `/mxm-research experiment-design <H>`, `/mxm-research patent-search <invention>`, `/mxm-research competitive-intel <competitor>`, `/mxm-research synthesis <findings>`. Pairs MemPalace KG + innovation-researcher agent.

#### `/mxm-devops` — SRE / platform engineers

`/mxm-devops slo <service>`, `/mxm-devops runbook <incident>`, `/mxm-devops post-mortem <event>`, `/mxm-devops capacity <load>`, `/mxm-devops chaos <experiment>`. Pairs sre-analyst (from aria-simplification merge) + new platform specialists.

#### `/mxm-data` — ML / data engineers

`/mxm-data ml-governance <model>`, `/mxm-data experiment <hypothesis>`, `/mxm-data aibom <project>`, `/mxm-data data-contract <pipeline>`, `/mxm-data evals <model>`. Pairs new llm-evaluator + AI Bill of Materials framework.

#### `/mxm-designer` — UI/UX designers

`/mxm-designer usability-audit <ui>`, `/mxm-designer design-system <brand>`, `/mxm-designer accessibility <ui>` (WCAG 2.1), `/mxm-designer cognitive-load <flow>`. Pairs current design-system + ui-styling skills.

---

## Agent roster expansion

### Decision (locked, Q2 corrected)

**Improve current generics + ADD specialists per moat.** Office leads stay (`enterprise-architect`, `implementer`, `reviewer`, `tester`, `planner`, `security-analyst`, `content-strategist`, `product-strategist`, `innovation-researcher`) — they get DEEPER DNA + a specialist roster underneath. Two-tier dispatch within each office: lead routes → specialist delivers.

### Pattern (applies to all 7 offices)

```
Office Lead (improved generic — high-level routing + cross-cutting concerns)
├── Specialist Group A (e.g., "Application Security")
│   ├── specialist-1
│   ├── specialist-2
│   └── specialist-3
├── Specialist Group B
│   └── ...
└── Specialist Group C
    └── ...
```

### Before/After by office

#### CSO Office (largest expansion — security is moat-central)

**Before (v1.0):**

```
CSO Office
└── security-analyst (lead)
```

**After (v1.2):**

```
CSO Office
├── security-analyst (improved lead — routes within office, holds CSO-auto-loop logic)
│
├── Application Security
│   ├── appsec-engineer
│   ├── threat-modeler
│   ├── owasp-specialist
│   └── secure-code-reviewer
│
├── Compliance & GRC
│   ├── soc2-auditor
│   ├── iso27001-lead-auditor
│   ├── gdpr-counsel
│   ├── hipaa-counsel
│   ├── pci-dss-qsa
│   ├── pipeda-counsel
│   └── uae-pdpl-counsel
│
├── AI Security (new in v1.2 alongside v1.3 framework releases)
│   ├── llm-security-specialist (OWASP LLM Top 10)
│   ├── ai-risk-auditor (NIST AI RMF)
│   └── adversarial-ml-analyst (MITRE ATLAS)
│
├── Operations Security
│   ├── incident-responder (NIST CSF)
│   ├── vulnerability-manager
│   ├── sbom-analyst (SPDX 3.0 + AIBOM)
│   └── identity-architect (zero-trust, IAM)
│
└── Privacy
    ├── privacy-engineer
    └── dpia-specialist
```

18 specialists + improved lead = 19 agents. Up from 1.

#### CTO Office

**Before:**

```
CTO Office
└── implementer (lead)
```

**After:**

```
CTO Office
├── implementer (improved lead — routes by stack/platform)
│
├── Backend
│   ├── backend-implementer (Node, Python, Go, Rust, Elixir)
│   ├── postgres-specialist
│   ├── api-architect
│   └── microservices-architect
│
├── Frontend / Mobile
│   ├── frontend-implementer (React, Vue, Svelte)
│   ├── mobile-implementer (iOS native + Android + RN/Flutter)
│   └── design-to-code-specialist
│
├── Infra / DevOps
│   ├── infrastructure-architect
│   ├── kubernetes-specialist
│   ├── ci-cd-architect
│   └── observability-specialist
│
├── Data / ML
│   ├── data-pipeline-engineer
│   ├── ml-platform-engineer
│   ├── prompt-engineer
│   ├── llm-evaluator
│   └── vector-search-specialist
│
└── Specialty
    ├── embedded-systems-engineer
    └── agentic-workflow-architect
```

17 specialists + improved lead = 18 agents.

#### CMO Office

**Before:**

```
CMO Office
└── content-strategist (lead)
```

**After:**

```
CMO Office
├── content-strategist (improved lead)
├── seo-strategist
├── conversion-copywriter
├── technical-content-writer
├── brand-storyteller
├── growth-hacker
├── video-script-writer
├── podcast-producer
├── newsletter-curator
├── moat-row-author (Maxim-specific — authors MOAT_TRACKER entries)
└── nk-writer (NEW per ADR-016 — operator-voice writer routing through VOICE_SELECTION.md)
   └── + _template-brand-writer.md (template for per-startup writers; instances per-operator)
```

11 agents (was 10; added `nk-writer` per ADR-016 voice-writing-agent architecture).
Per-startup brand writer instances (e.g., `aria-brand-writer`, `vazir-brand-writer`) are
instantiated on demand from `_template-brand-writer.md` and don't count toward the base
roster — they're operator-instantiated specializations.

**Companion skill:** `.claude/skills/voice-routing/SKILL.md` (NEW per ADR-016) — wraps
`myVoiceDNA/VOICE_SELECTION.md` as a callable lookup. Any agent can invoke it to get
routing decisions (content type + variant + load list + crossover budget). Brings skill
domain count from 34 → 35.

#### CSO Office shown above (19 agents)

#### CPO Office

```
CPO Office
├── product-strategist (improved lead)
├── prd-author
├── user-researcher
├── jtbd-analyst (Jobs Atlas)
├── growth-pm
├── platform-pm
├── pricing-strategist (Prospect Theory + Van Westendorp)
└── outcome-strategist (OKR architect)
```

8 agents.

#### COO Office

```
COO Office
├── planner (improved lead)
├── sprint-planner
├── runbook-author
├── sla-engineer
├── capacity-planner
├── post-mortem-facilitator
├── sre-analyst (from aria-simplification merge — operational reliability)
└── delivery-orchestrator
```

8 agents.

#### CEO Office

```
CEO Office
├── enterprise-architect (improved lead)
├── business-model-canvas-strategist
├── three-horizons-portfolio-planner
├── wardley-mapper
├── m-and-a-due-diligence-analyst
├── finance-analyst
├── partnerships-broker
├── board-deck-author
└── governance-specialist
```

9 agents.

#### CINO Office

```
CINO Office
├── innovation-researcher (improved lead)
├── tech-radar-author
├── competitive-intel-analyst
├── patent-researcher
├── academic-literature-reviewer
├── futures-analyst
├── cost-analyst (from aria-simplification merge — innovation cost optimization)
└── horizon-scanner
```

8 agents.

### Roster total

| Office | v1.0 leads | v1.2 specialists | v1.2 total |
|---|---|---|---|
| CEO | 1 | 8 | 9 |
| CTO | 1 | 17 | 18 |
| CMO | 1 | 10 | 11 |
| CSO | 1 | 18 | 19 |
| CPO | 1 | 7 | 8 |
| COO | 1 | 7 | 8 |
| CINO | 1 | 7 | 8 |
| Orchestrators (executive-router etc.) | — | — | ~10 |
| **Total** | 7 | 74 | **~91** |

Today's count is 90 (after the cost-analyst + sre-analyst aria-simplification merge landed 2026-04-27). v1.2 net delta is **+1 agent** (`nk-writer` in CMO office per ADR-016) plus a roster reorganization (renames + DNA upgrades, count-neutral). The voice-writing agent is the only net-new agent slot v1.2 adds beyond the rename pass. Per-startup brand-writer instances are operator-instantiated from a template and don't count toward the base roster.

**Skill domain delta:** 34 → 35 (adds `voice-routing` skill per ADR-016).

---

## Comprehensive `/mxm-help` system

`/mxm-help` is no longer a single command. It's a help SYSTEM with multiple modes.

### Modes

| Invocation | Behavior |
|---|---|
| `/mxm-help` (no arg) | Auto-detect persona from `project-manifest.json` → return persona-specific quick-start. Fall back to "what kind of work do you do?" wizard if detection inconclusive. |
| `/mxm-help <persona>` | Persona quick-start. Examples: `/mxm-help legal`, `/mxm-help arch`, `/mxm-help founder`. Returns 5–10 line opinionated intro + 3 hero commands for that persona. |
| `/mxm-help commands` | Full 3-tier command catalog with one-line description per command. Searchable. |
| `/mxm-help agents` | 90-agent roster grouped by office. Drill-down: each agent gets a one-line specialty + frameworks + collaborates_with snippet. |
| `/mxm-help frameworks` | 64+ framework catalog with trigger phrases. Links to FRAMEWORKS_MASTER.md. |
| `/mxm-help compliance` | Compliance map: which laws apply to YOUR project per `compliance.frameworks` in manifest. Shows status: in-scope / near-scope / out-of-scope. |
| `/mxm-help moat` | "What makes Maxim different" — opinionated differentiation pitch with examples. Same content the landing page leads with. |
| `/mxm-help getting-started` | 5-minute onboarding: configure manifest, run first command, interpret output, customize. |
| `/mxm-help frameworks <id>` | Framework deep-dive (Fogg, COM-B, EAST, OWASP LLM Top 10, etc.) |

### Default behavior — the killer onboarding moment

User runs `/mxm-help` with NO argument:

1. Read `config/project-manifest.json`
2. Apply persona-detection rules (see next section)
3. If high-confidence match → return persona quick-start
4. If ambiguous → run wizard: "I see you're working on a Next.js + Supabase project with GDPR + PIPEDA scope. Are you primarily a (1) developer (2) compliance lead (3) founder (4) other?"
5. Cache answer at `.mxm-skills/operator-persona.txt` for future sessions

---

## Auto-detect persona logic

Heuristics on `config/project-manifest.json`:

| Manifest signal | Likely persona |
|---|---|
| `compliance.frameworks` includes HIPAA, GDPR, PIPEDA, SOC2 + project type ≠ "compliance-platform" | Mixed dev + legal — offer both quick-starts |
| `project.type` = "compliance-platform" OR project mentions "DPIA / GRC / audit" | legal |
| `tech_stack.architecture.layers` ≥ 6 OR project has `documents/adr/` | arch |
| `tech_stack.security` has explicit `threat_model_path` OR `compliance.regulated_projects` ≠ empty | secure |
| `project.stage` includes "MVP", "pre-seed", "seed", "Series A" | founder |
| `project.type` includes "saas", "marketplace", "platform" + has `product` block | pm |
| Two or more match | run wizard once; cache result |

Persona cache: `.mxm-skills/operator-persona.txt` (single line: `legal` / `arch` / `secure` / `founder` / `pm`). Operator can edit. Session-end protocol re-checks if manifest changed substantially.

---

## Sequencing — v1.2 sprint plan

```
v1.2 sprint (Q4 2026, ~52–75 dev-days total)
│
├── Workstream 1 — TIER 1 verb-first commands (was v1.1.5)
│   • 7 verb-first commands implemented as router-frontends
│   • Plain-English /mxm-help banner
│   • Effort: ~5–8 days
│
├── Workstream 2 — TIER 3 persona commands (5 personas)
│   • /mxm-legal, /mxm-arch, /mxm-secure, /mxm-founder, /mxm-pm
│   • ~28 sub-commands total
│   • Each routes to specialist agents + frameworks
│   • Effort: ~8–10 days
│
├── Workstream 3 — Agent roster expansion
│   • Improve current 7 office leads (deeper DNA, better triggers)
│   • Add ~25 specialists per moat (CSO +18, CTO +17, etc.)
│   • Update agent-registry.json + AGENT_SKILL_INVENTORY.md
│   • Effort: ~5–8 days (mostly content authoring; structural work small)
│
├── Workstream 4 — Comprehensive /mxm-help system
│   • 9 modes (no-arg / persona / commands / agents / frameworks / compliance / moat / getting-started / framework-deep-dive)
│   • Auto-detect persona logic
│   • Persona cache at .mxm-skills/operator-persona.txt
│   • Effort: ~2–3 days
│
├── Workstream 5 — 10 behavioral frameworks (already scheduled)
│   • TTM, SDT, Dual Process, SCARF, TPB, Social Learning,
│     Operant Conditioning, Prospect Theory, Diffusion, Emotional Design
│   • Effort: ~30–40 days (per FRAMEWORK_ROADMAP)
│
└── Workstream 6 — Proactive Watch class 13 drift (already scheduled)
    • Detects framework non-adherence, tone drift, compliance violations in third-party plugin outputs
    • Extends MOE PostToolUse audit
    • Effort: ~3–5 days
```

**Suggested in-sprint ordering:**

1. Workstream 1 (verb-first commands) FIRST — gives testing customers feedback signal early
2. Workstream 4 (`/mxm-help`) SECOND — onboarding now coherent with new commands
3. Workstreams 2 + 3 (personas + roster) PARALLEL — both touch agent DNA
4. Workstreams 5 + 6 (behavioral frameworks + class 13) PARALLEL — independent of UX work

---

## Out of scope (this proposal)

Explicitly NOT in v1.2 — captured for future versions:

- **4 deferred personas** (researcher, devops, data, designer) → v1.2.x patches with full sub-command sketches preserved above
- **Agent agent-rename to fully break `enterprise-architect` / `implementer` / etc.** — rejected per Q2 correction. Generics stay improved; specialists added below them.
- **Voice mode** for personas — v2.0 candidate, not v1.2
- **Web UI for `/mxm-help`** — terminal-first remains the v1.x target
- **Cross-provider routing** — v2.0
- **Plugin SDK for cooperative integration** — v2.0

---

## Locked decisions (Session 14 close)

| Q | Decision | Rationale |
|---|---|---|
| 1 | Launch v1.2 with 5 personas (legal, arch, secure, founder, pm); 4 deferred to v1.2.x patches (researcher, devops, data, designer) | Smaller surface = faster feedback; defer-with-sketches preserves option value |
| 2 | Improve current generic agents + ADD specialists per moat | Backward-compatible; office leads become routers, specialists deliver depth |
| 3 | Auto-detect persona from `project-manifest.json` + one-time wizard fallback | First-run onboarding becomes the killer moment |
| 4 | BUNDLE v1.1.5 + v1.2 (no public-stability concern; only 2 testing users) | Coherent narrative: v1.1 = enterprise-readiness, v1.2 = adoption story |
| 5 | `/mxm-help agents` shows drill-down by office with specialists named | The roster IS the moat — show it |

---

<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years).
See [LICENSE](../../LICENSE) at repo root.</sub>