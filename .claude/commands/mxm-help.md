---
description: TIER 1 verb-first help system — 9 modes. No-arg auto-detects operator persona from project-manifest and returns persona-specific quick-start. Sub-modes for commands/agents/frameworks/compliance/moat/getting-started + framework deep-dive.
---

# /mxm-help

Maxim's help system. Not a static reference card — a **9-mode dispatcher** that adapts to the operator's persona, project, and active scope.

## Usage

| Invocation | Behavior |
|---|---|
| `/mxm-help` | Mode 1 — auto-detect persona from `config/project-manifest.json`, return persona quick-start. Cache the answer to `.mxm-skills/operator-persona.txt`. |
| `/mxm-help <persona>` | Mode 2 — explicit persona quick-start. `<persona>` ∈ {legal, arch, secure, founder, pm}. |
| `/mxm-help commands` | Mode 3 — full 3-tier command catalog (TIER 1 verb-first · TIER 2 office · domain/workflow). |
| `/mxm-help agents` | Mode 4 — 91-agent roster grouped by office, with one-line specialty per agent. |
| `/mxm-help frameworks` | Mode 5 — 64-framework catalog (68 at v1.2.0 GA · 74 at v1.2.1) with trigger phrases. |
| `/mxm-help frameworks <id>` | Mode 6 — deep-dive on a single framework (Fogg, COM-B, EAST, Prospect Theory, etc.). |
| `/mxm-help compliance` | Mode 7 — compliance map for THIS project (reads `config/project-manifest.json → compliance.frameworks`). |
| `/mxm-help moat` | Mode 8 — opinionated differentiation pitch. What makes Maxim different vs. raw Claude / generic plugins. |
| `/mxm-help getting-started` | Mode 9 — 5-minute onboarding for a fresh operator. |

---

## Mode 1 — No-arg auto-detect (the killer first-run moment)

When the operator types `/mxm-help` with no argument:

### Step 1 — Check persona cache

Read `.mxm-skills/operator-persona.txt`. If present and non-empty, jump to Mode 2 with that persona.

### Step 2 — Read project-manifest signals

Read `config/project-manifest.json`. Apply these heuristics in order:

| Manifest signal | Persona |
|---|---|
| `compliance.frameworks` includes HIPAA, GDPR, PIPEDA, or SOC2 AND `project.type` ≠ "compliance-platform" | **mixed dev + legal** — offer both quick-starts side-by-side |
| `project.type` = "compliance-platform" OR description mentions "DPIA / GRC / audit" | **legal** |
| `tech_stack.architecture.layers` ≥ 6 OR `documents/adr/` (or `documents/ADRs/`) exists | **arch** |
| `tech_stack.security.threat_model_path` set OR `compliance.regulated_projects` ≠ empty | **secure** |
| `project.stage` ∈ {MVP, pre-seed, seed, Series A} | **founder** |
| `project.type` ∈ {saas, marketplace, platform} AND `product` block present | **pm** |
| Two or more match | **run wizard once; cache result** |

### Step 3 — Confidence routing

- **High-confidence single match** → render that persona's quick-start (Mode 2) + cache the answer
- **Ambiguous (≥2 match) or no signals** → run the wizard:

```
I see you're working on <project name from manifest>.
Quick check so I can show you the right starting point —

What's your primary role on this project?
  1. Developer / engineer / architect (system design, code, infra)
  2. Compliance lead / privacy / legal counsel
  3. Founder / business owner (strategy, pricing, GTM)
  4. Product manager (PRD, prioritization, user research)
  5. Security / GRC / threat modeling
  6. None of the above — just show me everything

(I'll remember this for next time — written to .mxm-skills/operator-persona.txt)
```

Map answer → persona: 1→arch, 2→legal, 3→founder, 4→pm, 5→secure, 6→render Mode 3 (commands catalog) as the universal fallback.

### Step 4 — Cache

Write the chosen persona (single line, kebab-case) to `.mxm-skills/operator-persona.txt`. Future `/mxm-help` invocations skip the wizard.

### Step 5 — Render

Jump to Mode 2 with the resolved persona.

---

## Mode 2 — Persona quick-starts

Each quick-start is **5–10 lines opinionated intro + 3 hero commands tuned to the persona**. Not a comprehensive catalog — a launching pad.

### Persona: legal (in-house counsel · privacy lawyers · GRC)

```
You're here for compliance, contracts, and risk. Maxim gives you 14 jurisdictional
frameworks (GDPR · PIPEDA · UAE-PDPL · HIPAA · PCI-DSS · SOC2 · ISO 27001/13485/14971
· NIST CSF · EU AI Act · CASL · FINTRAC · WCAG 2.1) + Layer-3 startup compliance
overlays + DPIA-grade output. The CSO auto-loop fires on every regulated-data signal.

Start here:
  /mxm-legal jurisdictional-map <data-flow>   Map a flow against jurisdictional frameworks
  /mxm-legal privacy-impact <feature>          DPIA-style write-up
  /mxm-legal contract-review <doc>             Issue-spotting on contracts + DPAs

(Persona commands ship in v1.2.0 GA per WS3 of the sprint plan.)
```

### Persona: arch (enterprise architect · TOGAF / C4 / ArchiMate)

```
You're here for system design, capability mapping, and architecture documentation.
Maxim ships Wardley Mapping natively (rare in AI tools), C4 model rendering, ADR
authoring, tech-radar generation. The enterprise-architect lead routes to depth
specialists per artifact type.

Start here:
  /mxm-arch capability-map <domain>     TOGAF capability map with maturity + owners
  /mxm-arch wardley-map <strategy>      Wardley map: Genesis → Custom → Product → Commodity
  /mxm-arch adr <decision>              Lightweight ADR per ADR-001 template

(Persona commands ship in v1.2.0 GA per WS3.)
```

### Persona: secure (CISO · AppSec · GRC · threat modelers)

```
You're here for threat modeling, OWASP audits, incident response, AI-risk reviews.
Maxim ships triple-OWASP coverage (Top 10 + LLM Top 10 + API Top 10) + AIBOM (EU AI
Act Article 53) + NIST AI RMF + MITRE ATLAS. The security-analyst lead routes to
19 CSO specialists (largest office in v1.2 because security is moat-central).

Start here:
  /mxm-secure threat-model <system>        STRIDE / PASTA / LINDDUN with mitigations
  /mxm-secure sbom <project>               SPDX 3.0 + CycloneDX + AIBOM
  /mxm-secure compliance-posture           Multi-framework gap report

(Persona commands ship in v1.2.0 GA per WS3.)
```

### Persona: founder (pre-seed → Series A · technical · product-led)

```
You're here for pitch decks, GTM, runway modeling, pricing strategy, competitive moat.
Maxim applies Duarte Sparkline + Minto Pyramid to investor decks · AARRR + first-100
playbook to GTM · Prospect Theory + Van Westendorp to pricing · MOAT_TRACKER for
competitive defensibility. The CEO office leads on partnerships; CMO leads on growth.

Start here:
  /mxm-founder pitch-deck <thesis>         Investor deck with framework citations
  /mxm-founder pricing <product>           Behavioral pricing (Prospect Theory + tiers)
  /mxm-founder competitive-moat            7-moat-type audit + defensibility timeline

(Persona commands ship in v1.2.0 GA per WS3.)
```

### Persona: pm (product manager · JTBD practitioner · OKR architect)

```
You're here for PRDs, user stories, OKRs, RICE prioritization, jobs-to-be-done. Maxim
ships INVEST validation on stories · Tony Ulwick's Jobs Atlas (Tier 2 framework) ·
OKR with leading + lagging indicators · 12 CPO specialists routed by signal.

Start here:
  /mxm-pm prd <feature>          Problem · hypothesis · metrics · scope · risks
  /mxm-pm jtbd <user>            Job statement · Job map · outcome statements
  /mxm-pm prioritize <backlog>   RICE / ICE with quantified ranking

(Persona commands ship in v1.2.0 GA per WS3.)
```

---

## Mode 3 — Commands catalog

Render the 3-tier surface:

```
Maxim Commands — 43 total · 3-tier surface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIER 1 — VERB-FIRST (v1.2.0+) — plain-English entry points
  /mxm-build <X>      Build a feature · CTO + auto-loops · Fogg B=MAP + TDD
  /mxm-fix <X>        Fix bug/test · CTO + tester + reviewer · Systematic Debugging
  /mxm-ship <X>       Cut release · COO + CSO + reviewer + CMO · session-end bundle
  /mxm-plan <X>       Plan sprint/feature · COO planner · Fogg + Coverage Matrix
  /mxm-review <X>     Review code/PR/doc · reviewer + conditional auto-loops
  /mxm-explain <X>    Explain code/concept · smart-explorer + office expert
  /mxm-help [<mode>]  This system — 9 modes

TIER 2 — OFFICE COMMANDS — power users, direct office routing
  /mxm-ceo · /mxm-cto · /mxm-cmo · /mxm-cso · /mxm-cpo · /mxm-coo · /mxm-cino
  /mxm-route — auto-classify if unsure which office
  /mxm-ceo-{morning, overnight, setup} — CEO automation cycles

TIER 3 — PERSONA COMMANDS (v1.2.0 GA — shipping in WS3)
  /mxm-legal · /mxm-arch · /mxm-secure · /mxm-founder · /mxm-pm
  Each with ~5–6 sub-commands per persona vocabulary

DOMAIN & WORKFLOW (26 commands)
  Setup            /mxm-new-project · /mxm-context · /mxm-self-update · /mxm-update
  Memory           /mxm-remember · /mxm-recall · /mxm-wiki
  Health           /mxm-status · /mxm-health · /mxm-watch · /mxm-organize
  Specialists      /mxm-design · /mxm-seo · /mxm-security · /mxm-compliance
                   /mxm-behavior · /mxm-brand-voice · /mxm-superpowers
  Cycle            /mxm-implement · /mxm-test · /mxm-release · /mxm-session-end
  Portfolio        /mxm-portfolio · /mxm-tasks · /mxm-voice

Search this catalog: /mxm-help commands <keyword>
```

### Sub-mode: keyword search

If invoked as `/mxm-help commands <keyword>`, filter the 43-command list to entries matching `<keyword>` (case-insensitive substring on command name OR one-line description). Render the filtered subset only.

---

## Mode 4 — Agents catalog

Render the 91-agent roster grouped by office. Per-agent line format: `agent-name · one-line specialty · top-3 frameworks · top-3 collaborators`.

```
Maxim Agents — 91 total across 9 offices (incl. orchestrators + meta)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CEO Office — 9 agents · lead: enterprise-architect
  Strategy · finance · partnerships · enterprise architecture
  (drill-down: list of 9 with one-liners)

CTO Office — 25 agents · lead: implementer
  Engineering · infrastructure · AI · APIs · data · DevOps
  (drill-down: list of 25 with one-liners)

CMO Office — 16 agents · lead: content-strategist
  Marketing · brand · content · SEO · voice-routed writing (nk-writer)
  (drill-down: list of 16 with one-liners; flag nk-writer as v1.2.0)

CSO Office — 9 agents · lead: security-analyst (expanding to 19 in WS5)
  Security · compliance · privacy · ethics · risk · incidents
  (drill-down: list of 9 with one-liners)

CPO Office — 12 agents · lead: product-strategist
  Product · UX · UI · research · pricing

COO Office — 10 agents · lead: planner
  Delivery · sprints · operations · support

CINO Office — 4 agents · lead: innovation-researcher (expanding to 8 in WS5)
  R&D · horizon scanning · cost-analyst · competitive-intel

Orchestrators — 5 agents
  planner · implementer · reviewer · tester · release-manager

Meta — 1 agent
  executive-router (single entry point for routing)

Drill into any office: /mxm-help agents <office>
e.g. /mxm-help agents cso → full CSO roster with DNA snippets
```

### Sub-mode: office drill-down

If invoked as `/mxm-help agents <office>`, render the full roster for that office. For each agent: read the file at `agents/MXM/<office>/<agent>.md` and surface its Role, top-3 Triggers, top-3 Collaborators (from Collaboration Matrix).

---

## Mode 5 — Frameworks catalog

Read `documents/reference/FRAMEWORKS_MASTER.md` (canonical) and `documents/reference/FRAMEWORK_ROADMAP.md` (status). Render:

```
Maxim Behavioral Frameworks — 64 dispatchable today · +4 HIGH at v1.2.0 GA (68) · +6 MED at v1.2.1 (74)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ACTIVE TODAY (64)
  Motivation              Fogg B=MAP · COM-B · EAST · Prospect Theory · SCARF
  Persuasion              Cialdini's 6 · Hook Model · Anchoring · Reciprocity
  Decision-making         Dual Process · Cognitive Biases · Choice Architecture
  Habit / behavior        Tiny Habits · Operant Conditioning · Implementation Intentions
  Content / comms         Minto Pyramid · Duarte Sparkline · McKinsey Slide Logic · SCQA · STAR
  Brand / voice           E-E-A-T · Topic Clusters · Content Calendar · Search Intent Mapping
  UX / design             Fitts' Law · Hick's Law · Gestalt · Color Psychology · WCAG 2.1
  Strategy                Wardley Mapping · BMC · Value Proposition Canvas · Three Horizons
  Engineering             TDD · BDD · ATDD · C4 Model · arc42 · Diátaxis · DORA Metrics
  Compliance              GDPR · PIPEDA · UAE-PDPL · HIPAA · PCI-DSS · SOC2 · ISO 27001/13485/14971
                          NIST CSF · EU AI Act · CASL · FINTRAC · WCAG 2.1
  Operations              Error Budget · Blameless Post-Mortems · SLO/SLI · Pirate Metrics
  Maxim-native            Behavioral Moat Framing Doctrine (ADR-007) ·
                          Confidence Tag Rubric (ADR-010) · Proactive Watch

UPCOMING v1.2.0 GA (+4 HIGH-priority)
  Transtheoretical Model (TTM) · Self-Determination Theory (SDT) ·
  Dual Process (complete) · Prospect Theory (complete)

UPCOMING v1.2.1 (+6 MED-priority, post v1.1.2 MOE)
  SCARF · Theory of Planned Behavior · Social Learning · Operant Conditioning ·
  Diffusion of Innovations · Emotional Design

Deep-dive on any framework: /mxm-help frameworks <id>
e.g. /mxm-help frameworks fogg-behavior-model
```

---

## Mode 6 — Framework deep-dive (sub-mode of Mode 5)

If invoked as `/mxm-help frameworks <id>`, read `composable-skills/frameworks/<id>/SKILL.md` and surface:

- Purpose
- Framework & Standards table (citations)
- Top 3 prompt triggers
- Top 3 applications
- Top 3 reference materials with citations
- "Pairs with" — related frameworks from FRAMEWORKS_MASTER
- "Activated by" — which agents/commands invoke this framework

If `<id>` doesn't match a framework folder, suggest the closest matches (Levenshtein on framework names) and offer `/mxm-help frameworks` for the full catalog.

---

## Mode 7 — Compliance map (project-specific)

Read `config/project-manifest.json → compliance.frameworks` and `compliance.regulated_projects`. Render:

```
Compliance posture — <project name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IN-SCOPE (declared in project-manifest.json):
  GDPR              EU personal data · ROPA · DPIA · lawful basis
  PIPEDA            Canadian personal info · CASL overlap
  SOC2              service-org controls · annual audit
  (etc. — render only those declared)

NEAR-SCOPE (jurisdictional siblings the operator may need):
  CCPA              California consumer privacy — same DSR shape as GDPR
  UAE-PDPL          UAE personal data — same lawful-basis model as GDPR
  (rendered when the in-scope set suggests neighbors)

OUT-OF-SCOPE (declared NOT applicable):
  HIPAA             not declared in manifest — add if PHI introduced
  PCI-DSS           not declared — add if card data introduced

WHICH FRAMEWORK FIRES WHEN:
  Any data flow touching <in-scope> → CSO auto-loop fires
  Vendor / sub-processor introduced → /mxm-legal vendor-dpa
  New feature handling regulated data → /mxm-legal privacy-impact

Want to map a specific data flow? /mxm-legal jurisdictional-map <flow>
```

If `compliance.frameworks` is empty or missing, prompt the operator: "Your project-manifest doesn't declare any compliance frameworks. Run `/mxm-new-project` to add them, or paste your stack and I'll suggest the right set."

---

## Mode 8 — Moat pitch

Opinionated. Same content as the landing page's differentiation copy. Read `documents/ledgers/MOAT_TRACKER.md` for current moat rows and render:

```
What makes Maxim different
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Maxim isn't a prompt library. It's a behavioral intelligence layer that turns
Claude Code into a multi-office operator team with structural enforcement of:

  1. Framework citation — every output names the framework justifying it
     (Fogg, Cialdini, Prospect Theory, OWASP, NIST...). Anonymous "looks
     good" outputs get rejected. Enforced by ADR-007 + Class 12 drift checker.

  2. Confidence tagging — every output gets 🟢 HIGH / 🟡 MEDIUM / 🔴 LOW per
     ADR-010. The operator sees grounding depth, not just an answer.

  3. Compliance overlay — 14 compliance frameworks fire automatically when
     regulated-data signals appear. CSO auto-loop cannot be bypassed silently.

  4. Voice routing — every writing task routes through myVoiceDNA/VOICE_SELECTION.md.
     The operator's voice loads by agent dispatch, not by remembering to invoke
     a "use my voice" preamble. nk-writer + per-startup brand-writers (ADR-016).

  5. Proactive Watch - 13 drift classes scanned every session start. Catches
     stale docs, broken refs, secret leaks, surface-claims-drift, behavioral-
     moat-drift. AI-coded projects rot fast; Watch is the rot detector.

  6. Documents as Executable Contracts — CHANGELOG, MOAT_TRACKER, BUG_TRACKER,
     AGENT_SKILL_INVENTORY are read by the pre-commit hook as live state.
     Drift between claim and reality blocks the commit. ADR-002.

Current moat rows: (read MOAT_TRACKER.md and list MOAT-01..MOAT-NN with one-liner each)

Maxim is licensed BSL-1.1 (converts to Apache 2.0 after 4 years per ADR-005).
Free Starter tier forever per ADR-004 — full behavioral substrate, gated only
on enterprise features.
```

---

## Mode 9 — Getting started (5-minute onboarding)

For first-time operators who just installed the plugin:

```
Maxim — 5-minute onboarding
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. CONFIRM INSTALL (30 sec)
   Run `claude mcp list` → expect 7 ✓ Connected Maxim MCPs
   If any failed: /mxm-self-update + restart Claude Code

2. INITIALIZE THIS PROJECT (1 min)
   If first time in this directory:
     /mxm-new-project    Walks you through 11-file scaffold + manifest
   If migrating an existing project:
     /mxm-context        Imports current state into Maxim's memory layer

3. PICK YOUR FRONT DOOR (30 sec)
   /mxm-help              → I'll auto-detect your role from the manifest
   /mxm-help <persona>    → Or pick directly: legal · arch · secure · founder · pm
   /mxm-route <task>      → Or just describe what you need in plain English

4. RUN YOUR FIRST COMMAND (2 min)
   Try one of these to see the behavioral layer in action:
     /mxm-explain config/project-manifest.json
       → smart-explorer reads + plain-language confidence-tagged explanation
     /mxm-build a "hello world" health check
       → CTO implementer + Fogg B=MAP scope check + TDD discipline
     /mxm-secure threat-model my-app
       → CSO security-analyst + STRIDE + compliance overlay

5. UNDERSTAND THE OUTPUT (1 min)
   Every output tags itself: 🟢 HIGH / 🟡 MEDIUM / 🔴 LOW (per ADR-010)
   Every output cites the framework it applied (per ADR-007)
   Every output that touched regulated data fired CSO auto-loop (transparent)

Next steps:
  /mxm-help moat            Why Maxim is different
  /mxm-help frameworks      The 78 frameworks you can dispatch
  /mxm-help commands        Full command catalog
  /mxm-status               Session health · skill gaps · drift report
```

---

## Persona cache management

Persona cache lives at `.mxm-skills/operator-persona.txt`. One-line file with kebab-case persona id.

- **Cache hit:** skip wizard, go straight to Mode 2 persona quick-start
- **Cache invalidation:** if `config/project-manifest.json → last_updated` is newer than the cache file's mtime by > 30 days, re-run the heuristic — manifest changed substantially, persona may need re-check
- **Operator override:** `/mxm-help <persona>` always works regardless of cache; useful when wearing a different hat that day
- **Reset:** `/mxm-help reset-persona` deletes the cache file and re-runs the wizard on next no-arg invocation

The cache file is gitignored — it's per-operator-per-machine, not part of the repo.

---

## Behavioral framing

- **Fogg Behavior Model:** Reduces friction (Ability) for first-time users by removing the "which command do I run?" decision. Persona detection IS the prompt that triggers the right behavior.
- **COM-B:** Capability comes from the help system itself; Opportunity is the cached persona; Motivation comes from the operator's existing goal.
- **Confidence tag rubric (per ADR-010):** 🟢 HIGH when persona detected with high-confidence AND quick-start rendered. 🟡 MEDIUM when wizard ran (operator clarified once). 🔴 LOW when no persona detection possible (manifest empty, fall to Mode 3 commands catalog as universal fallback).

## Counts (sync-counts authoritative)

This file references count claims that must match `documents/ledgers/AGENT_SKILL_INVENTORY.md`. The `bootstrap/sync-counts.{sh,ps1}` tool propagates updates here automatically when INVENTORY changes. If you see a count mismatch in this output, run sync-counts.

Current authoritative counts (v1.3.2 · verified against AGENT_SKILL_INVENTORY.md):
- 91 agents (24 dispatchable + 67 specialist catalog via mxm-catalog MCP) · 52 skill domains · 49 slash commands · 9 MCP servers · 95 MCP tools
- 16 hook scripts · 78 frameworks · 14 compliance frameworks · 21 ADRs · 13 drift classes

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. 9-mode rebuild shipped in WS4 of v1.2.0 sprint (2026-05-19) per AGENT_ROSTER_v1.2_PROPOSAL.md § Comprehensive /mxm-help system._