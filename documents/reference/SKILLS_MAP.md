# Maxim Skills Map

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.


> **Purpose:** Cross-reference of all 26 `.claude/skills/`
> domain folders — what each contains, which Maxim agents
> consume it, which executive office owns it, and how it
> relates to the 5-layer dispatch sequence.

**Dispatch rule (Layer 1 — Supreme Authority):**
Maxim agents check `.claude/skills/` first, before any
other source. If a skill file exists here, it wins over
`community-packs/` and `composable-skills/`.

**5-layer dispatch sequence:**
```
Layer 1: .claude/skills/           ← check here first
Layer 2: community-packs/claude-skills-library/   ← alirezarezvani deep knowledge
Layer 3: composable-skills/        ← workflow + superpowers
Layer 4: agents/MXM/{office}/     ← agent .md files (office structure)
Layer 5: behavioral layer          ← CLAUDE.md universal rules
```

**Entry point:** `executive-router.md` classifies all
incoming tasks and routes to the correct office lead
before any skill is activated.

**Last updated:** 2026-04-12
**Source of truth:** `config/agent-registry.json` v6.2.0

---

## Section 1 — Executive Office → Skill Domain Map

| Office | Lead Agent | Primary Skill Domains |
|---|---|---|
| CEO | `enterprise-architect` | `enterprise-architecture` · `ceo-automation` |
| CTO | `implementer` | `engineering` · `product-development-research` (data) · `ai-media-generation` |
| CMO | `content-strategist` | `content-creation` · `marketing` · `search-visibility` · `behavior-science-persuasion` · `brand` · `ai-media-generation` |
| CSO | `security-analyst` | `security` · `compliance` |
| CPO | `product-strategist` | `product` · `product-development-research` · `design` · `ui-ux-pro-max` · `design-system` · `ui-styling` · `slides` · `banner-design` |
| COO | `planner` | `project-management` · `studio-operations` · `testing` |
| CINO | `innovation-researcher` | `product-development-research` (innovation) |
| Orchestrators | `executive-router` | all domains (routing only) |

---

## Section 2 — Skill Folder Index

| # | Folder | Domain | Executive Office | Primary Agents |
|---|---|---|---|---|
| 1 | [`banner-design`](#banner-design) | Visual / Creative | CPO | `ui-ux-designer` |
| 2 | [`behavior-science-persuasion`](#behavior-science-persuasion) | Behavioral Science | CMO | `behavioral-designer` · `conversion-optimizer` · `decision-architect` · `habit-formation-coach` · `nudge-architect` · `persuasion-specialist` · `influence-strategist` · `negotiation-specialist` |
| 3 | [`brand`](#brand) | Brand Identity | CMO | `brand-guardian` · `ui-ux-designer` |
| 4 | [`compliance`](#compliance) | Regulatory / Legal | CSO | `ai-ethics-reviewer` · `compliance-officer` · `data-privacy-officer` · `legal-compliance-checker` |
| 5 | [`content-creation`](#content-creation) | Content / Writing | CMO | `content-strategist` · `documentation-writer` · `email-campaign-writer` · `investor-pitch-writer` · `knowledge-base-curator` · `changelog-writer` |
| 6 | [`design`](#design) | UX / Interaction | CPO | `ui-designer` · `ux-researcher` · `onboarding-designer` · `accessibility-auditor` |
| 7 | [`design-system`](#design-system) | Design Tokens / Components | CPO | `ui-ux-designer` · `ui-designer` |
| 8 | [`engineering`](#engineering) | Software Engineering | CTO | `backend-architect` · `frontend-developer` · `ai-engineer` · `mobile-app-builder` · `devops-automator` · `api-integrator` · `rag-specialist` · `rapid-prototyper` (8 of 19 shown) |
| 9 | [`enterprise-architecture`](#enterprise-architecture) | Systems Architecture | CEO | `enterprise-architect` · `solution-architect` · `technology-architect` · `business-architect` · `data-architect` · `governance-specialist` |
| 10 | [`marketing`](#marketing) | Growth / Campaigns | CMO | `growth-hacker` · `email-campaign-writer` · `landing-page-optimizer` · `gtm-strategist` · `localization-specialist` · `seo-specialist` |
| 11 | [`product`](#product) | Product Strategy | CPO | `feedback-synthesizer` · `pricing-strategist` · `trend-researcher` · `sprint-prioritizer` |
| 12 | [`product-development-research`](#product-development-research) | Research / Validation | CPO + CINO | `product-strategist` · `competitive-analyst` · `market-analyst` · `data-scientist` · `innovation-researcher` · `rd-coordinator` |
| 13 | [`project-management`](#project-management) | Planning / Delivery | COO | `project-shipper` · `experiment-tracker` · `sprint-prioritizer` · `workflow-optimizer` · `knowledge-base-curator` · `changelog-writer` · `tool-evaluator` |
| 14 | [`search-visibility`](#search-visibility) | SEO / AEO / GEO | CMO | `seo-specialist` (absorbs 5 modes) |
| 15 | [`security`](#security) | Security / Threat | CSO | `security-analyst` · `threat-modeler` · `penetration-tester` · `incident-responder` · `compliance-officer` · `data-privacy-officer` · `ai-ethics-reviewer` · `security-architect` |
| 16 | [`slides`](#slides) | Presentations | CPO | `ui-ux-designer` · `investor-pitch-writer` |
| 17 | [`studio-operations`](#studio-operations) | Business Ops | COO | `analytics-reporter` · `customer-success-manager` · `financial-modeler` · `infrastructure-maintainer` · `legal-compliance-checker` · `partnership-manager` · `support-responder` |
| 18 | [`testing`](#testing) | QA / Validation | COO | `api-tester` · `load-tester` · `test-data-generator` · `workflow-optimizer` · `tool-evaluator` · `experiment-tracker` |
| 19 | [`ui-styling`](#ui-styling) | CSS / Tokens / Theming | CPO | `ui-ux-designer` · `ui-designer` · `accessibility-auditor` · `frontend-developer` |
| 20 | [`ui-ux-pro-max`](#ui-ux-pro-max) | Full-Spectrum UI/UX | CPO | `ui-ux-designer` (orchestrator) |
| 21 | [`ceo-automation`](#ceo-automation) | Startup CEO Automation | CEO | `enterprise-architect` · `financial-modeler` · `investor-pitch-writer` · `business-architect` · `content-strategist` · `seo-specialist` · `product-strategist` |
| 22 | [`session-memory`](#session-memory) | Session Memory / Context Persistence | All Offices | All agents (always active) |
| 23 | [`ai-media-generation`](#ai-media-generation) | AI Video / Image Generation | CMO + CTO | `content-strategist` · `brand-guardian` · `video-script-writer` · `ui-designer` |
| 24 | [`memory-palace`](#memory-palace) | MemPalace Knowledge Graph | All Offices | All agents (via MCP) |
| 25 | [`operator-profile`](#operator-profile) | Operator Personalization | All Offices | All agents (always active) |
| 26 | [`design-resources`](#design-resources) | Design Reference Library | CPO | `ui-ux-designer` · `ui-designer` · `product-strategist` |

---

## Section 3 — Design Folder Disambiguation

Two pairs of folders are closely related. This is the authoritative distinction.

### `design` vs `design-system`

| Folder | Scope | Contains | Who Routes Here |
|---|---|---|---|
| `design` | UX thinking, interaction design, user journeys, accessibility, visual design | User flow files, UX patterns, accessibility audits, onboarding design | `ui-designer` · `ux-researcher` · `onboarding-designer` · `accessibility-auditor` |
| `design-system` | Component libraries, design tokens, spacing/colour scales, component specs | Token files, component specs, design system rules | `ui-ux-designer` (orchestrator) · `ui-designer` (component-level work only) |

**Rule:** If the task is about how a user *thinks or flows* through an interface → `design`. If the task is about tokens, components, or a design system → `design-system`.

### `product` vs `product-development-research`

| Folder | Scope | Contains | Who Routes Here |
|---|---|---|---|
| `product` | Strategic product decisions, pricing, sprint prioritisation, trend signals | Product strategy files, pricing models, backlog frameworks | `feedback-synthesizer` · `pricing-strategist` · `sprint-prioritizer` · `trend-researcher` |
| `product-development-research` | Discovery, validation, competitive intelligence, user research | Research briefs, competitive analyses, market scans, R&D logs | `product-strategist` · `competitive-analyst` · `market-analyst` · `data-scientist` · `innovation-researcher` · `rd-coordinator` |

**Rule:** If the task is about *deciding what to build* → `product`. If the task is about *discovering or validating* what to build → `product-development-research`.

---

## Section 4 — Folder Details

### banner-design
**Domain:** Digital banner creation, ad creative, social media banners, hero sections, display advertising, promotional graphics.
**Executive Office:** CPO
**Routed by:** `ui-ux-designer` (orchestrator)
**Maxim-WRAPPER.md:** ✅ Present
**Skill Modes:** social · display · hero · email · audit
**Ethics gate:** None
**Note:** Distinct from `design` (UX) and `ui-styling` (CSS). `banner-design` produces exported creative assets for campaigns. Always loops `brand` and `behavior-science-persuasion` for compliance and psychology validation.

---

### behavior-science-persuasion
**Domain:** Behavioral economics, cognitive bias application, decision architecture, ethical persuasion frameworks.
**Executive Office:** CMO (persuasion agents) + CEO (influence/negotiation agents)
**Routed by:** `behavioral-designer` · `conversion-optimizer` · `decision-architect` · `habit-formation-coach` · `nudge-architect` · `persuasion-specialist` · `influence-strategist` · `negotiation-specialist`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist (no root mode list)
**Ethics gate:** All 8 agents have `ethics_required: true` — ethical guidelines enforced on every output
**Note:** This skill is the behavioral science backbone. Every other Maxim skill proactively loops here for psychological validation.

---

### brand
**Domain:** Brand identity, voice architecture, visual identity systems, messaging frameworks, brand consistency enforcement.
**Executive Office:** CMO
**Routed by:** `brand-guardian` · `ui-ux-designer`
**Maxim-WRAPPER.md:** ✅ Present
**Skill Modes:** create · update · audit · voice · assets
**Ethics gate:** None
**Note:** `brand-guardian` is the primary agent. `ui-ux-designer` routes here when brand-consistent design execution is needed. Always loops `design-system` when tokens are created or updated.

---

### compliance
**Domain:** GDPR, PIPEDA, CASL, EU AI Act, ISO 27001, ISO 14971, ISO 13485, SOC 2, HIPAA, WCAG 2.1, Bill 96 regulatory compliance.
**Executive Office:** CSO
**Routed by:** `ai-ethics-reviewer` · `compliance-officer` · `data-privacy-officer` · `legal-compliance-checker`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** COMPLIANT · REMEDIATE · BLOCK output statuses
**Ethics gate:** `ethics_required: true` — BLOCK-status features require human review before deployment
**Note:** Activates automatically (no explicit request needed) whenever output touches PII, regulated data, AI ethics, or localization law. External `ra-qm-team/` fully absorbed. CSO auto-loop triggers on every task with security, compliance, or PII signal.
**Absorbed into this skill:** gdpr-dsgvo-expert · iso27001 · isms-audit · capa · risk-management · regulatory-affairs-head · fda-consultant · qms-iso13485

---

### content-creation
**Domain:** All written content — articles, whitepapers, newsletters, documentation, changelogs, video scripts, investor content.
**Executive Office:** CMO
**Routed by:** `content-strategist` · `documentation-writer` · `email-campaign-writer` · `investor-pitch-writer` · `knowledge-base-curator` · `changelog-writer`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Article · Newsletter · Video Script · Technology Book · Whitepaper · Social Media (all via Op-C Skill DNA)
**Ethics gate:** None
**Note:** 6 agents demoted to Skill DNA modes via Op-C (see Section 5). `social-media-strategist` demoted here — it is a content format, not a campaign channel. `investor-pitch-writer` is CEO office but routes here for written content execution.

---

### design
**Domain:** UX design, interaction design, user journeys, accessibility auditing, onboarding flows, visual design execution.
**Executive Office:** CPO
**Routed by:** `ui-designer` · `ux-researcher` · `onboarding-designer` · `accessibility-auditor`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** None
**Note:** See disambiguation above. `ux-researcher` absorbs `user-researcher` and `usability-tester` via Op-D (see Section 5). `ui-designer` absorbs `visual-storyteller` via Op-D. `whimsy-injector` demoted to Skill DNA mode via Op-C.

---

### design-system
**Domain:** Token architecture (primitive→semantic→component), component library governance, CSS variable systems, Tailwind integration, design-to-code handoff.
**Executive Office:** CPO
**Routed by:** `ui-ux-designer` · `ui-designer`
**Maxim-WRAPPER.md:** ✅ Present
**Skill Modes:** create · tokens · audit · component · slides · tailwind
**Ethics gate:** None
**Note:** Three-layer enforcement: Primitive → Semantic → Component (never skip layers). Always loops `brand` (tokens derive from brand primitives) and `ui-styling` (tokens map to Tailwind/shadcn config).

---

### engineering
**Domain:** Software engineering across backend, frontend, AI/ML, mobile, DevOps, infrastructure, databases, APIs, and cloud.
**Executive Office:** CTO
**Routed by:** `backend-architect` · `frontend-developer` · `ai-engineer` · `mobile-app-builder` · `devops-automator` · `api-integrator` · `rag-specialist` · `rapid-prototyper` · `prompt-engineer` · `database-optimizer` · `dependency-auditor` · `training-data-curator` · `support-agent-builder` · `performance-engineer` · `cloud-cost-optimizer` · `security-architect` · `solution-architect` · `api-tester` · `load-tester`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** `security-architect` ethics gate active for auth/payment/PII code paths
**Note:** `ai-engineer` skill lives here — not in a separate ai-engineering/ domain. `performance-engineer` absorbs `performance-benchmarker` via Op-D.

---

### enterprise-architecture
**Domain:** Enterprise systems design, business architecture, solution architecture, data architecture, governance, technology strategy.
**Executive Office:** CEO
**Routed by:** `enterprise-architect` · `solution-architect` · `technology-architect` · `business-architect` · `data-architect` · `governance-specialist`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** None
**Note:** CEO office lead (`enterprise-architect`) resolves strategic conflicts between offices. `governance-specialist` maintains RoPA and audit trails per compliance skill.

---

### marketing
**Domain:** Growth marketing, campaign execution, GTM strategy, localization marketing, conversion optimization.
**Executive Office:** CMO
**Routed by:** `growth-hacker` · `email-campaign-writer` · `landing-page-optimizer` · `gtm-strategist` · `localization-specialist` · `seo-specialist`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Instagram · TikTok · Twitter/X · Reddit (all via Op-C Skill DNA)
**Ethics gate:** None
**Note:** 4 channel-specific agents demoted to Skill DNA modes via Op-C (see Section 5). `app-store-optimizer` deprecated (not absorbed). `seo-specialist` also routes here for campaign-aligned search strategy.

---

### product
**Domain:** Strategic product decisions, pricing strategy, backlog prioritisation, trend intelligence.
**Executive Office:** CPO
**Routed by:** `feedback-synthesizer` · `pricing-strategist` · `trend-researcher` · `sprint-prioritizer`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** None
**Note:** See disambiguation above. `sprint-prioritizer` is COO office but routes here for product backlog work. `product-manager` (CPO) also reads this domain.

---

### product-development-research
**Domain:** Discovery research, competitive intelligence, market analysis, innovation scouting, R&D coordination, data science validation.
**Executive Office:** CPO + CINO
**Routed by:** `product-strategist` · `competitive-analyst` · `market-analyst` · `data-scientist` · `innovation-researcher` · `rd-coordinator`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** None
**Note:** Dual-office domain. CPO leads product validation. CINO leads emerging technology and R&D horizon scanning. `data-scientist` is CTO office but routes here for research validation.

---

### project-management
**Domain:** Sprint planning, delivery tracking, experiment management, knowledge management, changelog governance.
**Executive Office:** COO
**Routed by:** `project-shipper` · `experiment-tracker` · `sprint-prioritizer` · `workflow-optimizer` · `knowledge-base-curator` · `changelog-writer` · `tool-evaluator`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** None
**Note:** Orchestrators (`planner` · `implementer` · `reviewer` · `tester` · `release-manager`) use this domain for workflow coordination. `studio-producer` (CEO) routes here for agency project delivery.

---

### search-visibility
**Domain:** SEO, AEO (Answer Engine Optimization), GEO (Generative Engine Optimization), technical search auditing, keyword intelligence, authority building.
**Executive Office:** CMO
**Routed by:** `seo-specialist` (sole active agent — absorbs 5 modes via Op-D)
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** AEO · GEO · Technical · Keyword · Authority (absorbed from deprecated specialists)
**Ethics gate:** None
**Note:** `seo-specialist` is the only active agent in this domain. It now contains the full capability of the 5 absorbed agents. Invoke with mode signal to activate specific capability.
**Absorbed into `seo-specialist`:** `aeo-strategist` → Mode: AEO | `geo-optimizer` → Mode: GEO | `technical-seo-auditor` → Mode: Technical | `keyword-intent-researcher` → Mode: Keyword | `authority-builder` → Mode: Authority

---

### security
**Domain:** Security analysis, threat modeling, penetration testing, incident response, compliance enforcement, data privacy, AI ethics.
**Executive Office:** CSO
**Routed by:** `security-analyst` · `threat-modeler` · `penetration-tester` · `incident-responder` · `compliance-officer` · `data-privacy-officer` · `ai-ethics-reviewer` · `incident-post-mortem-writer` · `security-architect`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** `ethics_required: true` for `penetration-tester` and `ai-ethics-reviewer`
**Note:** CSO auto-loop: any task with security, compliance, PII, or regulated industry signals triggers `security-analyst` automatically. `security-analyst` absorbs `security-auditor` and `vulnerability-scanner` via Op-D. `threat-modeler` absorbs `threat-analyst`. `penetration-tester` absorbs `ethical-hacker`. `security-architect` is CTO office but routes here for security architecture tasks.

---

### slides
**Domain:** Pitch decks, investor presentations, executive briefings, product demos, conference talks, narrative-driven visual storytelling.
**Executive Office:** CPO
**Routed by:** `ui-ux-designer` · `investor-pitch-writer`
**Maxim-WRAPPER.md:** ✅ Present
**Skill Modes:** pitch · exec · demo · conference · data
**Ethics gate:** None
**Note:** `investor-pitch-writer` is CEO office but routes here for visual deck production. Always loops `design-system` (token compliance) and `brand` (voice/visual identity). Applies Minto Pyramid, Duarte Sparkline, McKinsey Slide Logic, and Dual Coding Theory to every deck.

---

### studio-operations
**Domain:** Business operations, analytics, financial modeling, infrastructure maintenance, legal compliance, partnership management, customer success.
**Executive Office:** COO
**Routed by:** `analytics-reporter` · `customer-success-manager` · `financial-modeler` · `infrastructure-maintainer` · `legal-compliance-checker` · `partnership-manager` · `support-responder`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Sub-skill SKILL.md files per specialist
**Ethics gate:** `legal-compliance-checker` ethics gate active for contract and regulatory review
**Note:** Multi-office domain. `analytics-reporter` and `infrastructure-maintainer` are CTO office. `financial-modeler` and `partnership-manager` are CEO office. `legal-compliance-checker` is CSO office. `finance-tracker` deprecated — absorbed into `financial-modeler` via Op-D.

---

### testing
**Domain:** API testing, load testing, test data generation, workflow optimization, tool evaluation, QA validation.
**Executive Office:** COO
**Routed by:** `api-tester` · `load-tester` · `test-data-generator` · `workflow-optimizer` · `tool-evaluator` · `experiment-tracker`
**Maxim-WRAPPER.md:** ❌ Missing
**Skill Modes:** Results Analysis (via Op-C Skill DNA from `test-results-analyzer`)
**Ethics gate:** None
**Note:** Orchestrator `tester` uses this domain for cross-cutting QA workflows. `test-results-analyzer` demoted to Skill DNA mode via Op-C. `performance-benchmarker` absorbed into `performance-engineer` via Op-D (engineering domain).

---

### ui-styling
**Domain:** shadcn/ui components, Tailwind CSS, CSS architecture, responsive design, dark mode, WCAG 2.1 AA accessibility, animation and motion design, theming systems.
**Executive Office:** CPO
**Routed by:** `ui-ux-designer` · `ui-designer` · `accessibility-auditor` · `frontend-developer`
**Maxim-WRAPPER.md:** ✅ Present
**Skill Modes:** component · layout · theme · dark-mode · animate · audit
**Ethics gate:** None
**Note:** Always loops `design-system` to confirm token-Tailwind parity. `accessibility-auditor` is CPO office. `frontend-developer` is CTO office but routes here for styling implementation.

---

### ui-ux-pro-max
**Domain:** Full-spectrum UI/UX orchestration — product design strategy, interaction design, information architecture, usability heuristics, design critique, cross-platform consistency, design leadership.
**Executive Office:** CPO
**Routed by:** `ui-ux-designer` (master orchestrator)
**Maxim-WRAPPER.md:** ✅ Present
**Skill Modes:** audit · design · critique · strategy · system
**Ethics gate:** None
**Note:** The master design conductor. Activates all 6 design sub-domains in parallel when a task spans multiple design domains: `brand/` · `design-system/` · `ui-styling/` · `slides/` · `banner-design/` · `design/`. Always loops `behavior-science-persuasion` as the behavioral foundation of all design decisions.

### ceo-automation
**Domain:** Cross-functional startup automation — strategy, metrics, pipeline, marketing, sales, launch, social media. Operates on `.mxm-executive-summary/` knowledge base per project.
**Executive Office:** CEO
**Routed by:** `enterprise-architect` (CEO Office lead)
**Maxim-WRAPPER.md:** ✅ Present (with full MOAT enforcement)
**Sub-Skills:** 5 — `ceo-tasks/` · `marketing/` · `sales/` · `launch-product/` · `social-media/`
**Prompt Count:** 160+ (indexed in sub-skill SKILL.md files; full text in `ceo-automation-prompts.md`)
**Behavioral Frameworks:** Fogg · COM-B · EAST · Hook Model · Loss Aversion · SPIN Selling · Challenger Sale · MEDDIC · AIDA · PAS · StoryBrand · RICE · Kano · Cialdini · Pattern Interruption
**Agent Auto-Loops:** `financial-modeler` (RUNWAY/METRICS) · `content-strategist` (marketing/social) · `investor-pitch-writer` (fundraising) · `security-analyst` (regulated project data) · `product-strategist` (roadmap) · `seo-specialist` (content/SEO)
**Commands:** `/mxm-ceo-setup` · `/mxm-ceo-morning` · `/mxm-ceo-overnight`
**Knowledge Base:** 30 template files per project in `.mxm-executive-summary/` + 3 global files in `.mxm-global/`
**Ethics gate:** CSO auto-loop on regulated project financial data
**Note:** Auto-activates when `.mxm-executive-summary/` detected in project root. The `/mxm-ceo` command reads CONTEXT.md from this folder when present. Templates in `templates/ceo-automation/`. Schedulable via Claude Scheduled Tasks for 5-hour daily cycles.

---

### session-memory
**Domain:** Persistent cross-session memory — progress tracking, debugging playbooks, lessons learned, decision logs, session handoff. Always active on every session.
**Executive Office:** All (cross-office, cannot be disabled)
**Routed by:** Always active — no routing needed
**Maxim-WRAPPER.md:** ✅ Present
**Sub-Skills:** None (enforcement rules only)
**Templates:** 7 in templates/session-memory/ (MEMORY.md, project_current_state, debugging_playbook, lessons_learned, reference_key_files)
**Ethics gate:** None
**Note:** This skill CANNOT be disabled, even in Super User mode. Every session must read memory on start and write memory on end. Uses the claude-memory 3-tier architecture (project/reference/feedback) with YAML frontmatter metadata.

---

### ai-media-generation
**Domain:** AI video and image generation prompt engineering — 15 creative/commercial styles, 20 technical sub-skills (camera, motion, audio, pipeline, model selection), platform-specific optimization (TikTok, YouTube, Instagram, LinkedIn).
**Executive Office:** CMO + CTO (joint — content strategy + technical generation)
**Routed by:** `content-strategist` (CMO) for creative direction; `implementer` (CTO) for pipeline/automation
**Maxim-WRAPPER.md:** ✅ Present
**Sub-Skills:** 19 style skills + 20 technical sub-skills (from external)
**References:** `references/style-guide.md`, `references/camera-vocabulary.md`, `references/platform-specs.md`, `references/prompt-formula.md`
**External Sources:** `community-packs/higgsfield-ai-prompts/` (19 skills) + `community-packs/higgsfield-ai-prompts/` (20 sub-skills)
**Ethics gate:** Loop `compliance` for ad/commercial content (FTC/ASA disclosures)
**Note:** This is a process skill — activated by triggers within CMO/CTO workflows, not a standalone user command. Uses MCSLA formula (Model + Camera + Subject + Look + Action) and 2-Second Hook Framework for all video prompts.

---

### memory-palace
**Domain:** MemPalace MCP integration — semantic search, knowledge graph, diary, wing/room/drawer taxonomy.
**Executive Office:** All (cross-office memory layer)
**Routed by:** Always available — `/mxm-remember` and `/mxm-recall` commands
**Maxim-WRAPPER.md:** ✅ Present
**Sub-Skills:** None (MCP tools provide functionality)
**Ethics gate:** None
**Note:** Requires MemPalace MCP server running. Mining via `/mxm-ceo-setup` only.

---

### operator-profile
**Domain:** Honcho-inspired operator personalization — identity, preferences, rejected patterns, communication style.
**Executive Office:** All (cross-office personalization)
**Routed by:** Always active at session start — reads `.mxm-operator-profile/`
**Maxim-WRAPPER.md:** ✅ Present
**Sub-Skills:** None (enforcement rules only)
**Templates:** 4 in templates/operator-profile/ (OPERATOR, preferences, rejected-patterns, communication-style)
**Ethics gate:** None
**Note:** Read at session start, updated at session end. Corrections to agent behavior are stored in rejected-patterns.md.

---

### design-resources
**Domain:** Curated design reference library — DESIGN.md 9-section standard, typography, color theory, components, animation, accessibility, 59 brand templates.
**Executive Office:** CPO
**Routed by:** `product-strategist` or `ui-ux-designer`
**Maxim-WRAPPER.md:** ✅ Present
**Sub-Skills:** None (reference library)
**References:** 6 files in references/ + brand-library.md (59 brands)
**Ethics gate:** None
**Note:** Brand templates from `community-packs/design-templates/`. Also exposed via `maxim-design` MCP server.

---

## Section 5 — Agent Absorption Map

Documents all Op-C demotions and Op-D absorptions from registry v3.2.1.

### Op-C Demotions — Agent → Skill DNA

| Agent | Demoted Into | Skill Mode |
|---|---|---|
| `article-writer` | `content-creation/SKILL.md` | Mode: Article |
| `newsletter-writer` | `content-creation/SKILL.md` | Mode: Newsletter |
| `video-script-writer` | `content-creation/SKILL.md` | Mode: Video Script |
| `technology-book-writer` | `content-creation/SKILL.md` | Mode: Technology Book |
| `whitepaper-writer` | `content-creation/SKILL.md` | Mode: Whitepaper |
| `social-media-strategist` | `content-creation/SKILL.md` | Mode: Social Media |
| `instagram-curator` | `marketing/SKILL.md` | Mode: Instagram |
| `tiktok-strategist` | `marketing/SKILL.md` | Mode: TikTok |
| `twitter-engager` | `marketing/SKILL.md` | Mode: Twitter/X |
| `reddit-community-builder` | `marketing/SKILL.md` | Mode: Reddit |
| `whimsy-injector` | `design/SKILL.md` | Mode: Whimsy Layer |
| `test-results-analyzer` | `testing/SKILL.md` | Mode: Results Analysis |

### Op-D Absorptions — Agent → Survivor Mode

| Survivor | Absorbed Agents | Modes Added |
|---|---|---|
| `seo-specialist` | `aeo-strategist` · `geo-optimizer` · `technical-seo-auditor` · `keyword-intent-researcher` · `authority-builder` | AEO · GEO · Technical · Keyword · Authority |
| `security-analyst` | `security-auditor` · `vulnerability-scanner` | Audit · Scan |
| `threat-modeler` | `threat-analyst` | Analysis · Modeling |
| `penetration-tester` | `ethical-hacker` | Standard · Ethics-Framed |
| `ux-researcher` | `user-researcher` · `usability-tester` | Generative · Evaluative · Synthesis |
| `ui-designer` | `visual-storyteller` | Visual Storytelling |
| `content-strategist` | `content-creator` | Strategy · Execution |
| `performance-engineer` | `performance-benchmarker` | Benchmark · Load Test |
| `financial-modeler` | `finance-tracker` | Modeling · Tracking |

### Additional Deprecation

| Agent | Status | Reason |
|---|---|---|
| `app-store-optimizer` | Deprecated v3.1.1 | ASO capability absorbed into `gtm-strategist` and `growth-hacker` |

---

## Section 6 — ui-ux-designer Dispatch Map

`ui-ux-designer` is the CPO master design orchestrator. It activates sub-domain skills as follows:

| Task Component | Sub-Skill Activated | Lead Agent Within Skill |
|---|---|---|
| Brand + visual identity | `.claude/skills/brand/` | `brand-guardian` |
| Component + token system | `.claude/skills/design-system/` | `token-architect` · `component-architect` |
| Component implementation | `.claude/skills/ui-styling/` | `component-builder` · `theme-engineer` |
| Presentation / pitch | `.claude/skills/slides/` | `narrative-architect` · `slide-production-engineer` |
| Ad / banner creative | `.claude/skills/banner-design/` | `attention-architect` · `conversion-copywriter` |
| UX research + flows | `.claude/skills/design/` | `ux-researcher` |
| UI design + visual | `.claude/skills/design/` | `ui-designer` |
| Behavioral triggers | `.claude/skills/behavior-science-persuasion/` | `behavioral-designer` |

---

## Section 7 — Skills Catalog Cross-Reference

External skills consumed by active Maxim agents (deprecated IDs removed per registry v3.2.1):

| External Skill | Active Consumers |
|---|---|
| `senior-architect` | `enterprise-architect` · `solution-architect` · `technology-architect` · `backend-architect` · `business-architect` · `data-architect` · `governance-specialist` |
| `senior-ml-engineer` | `ai-engineer` · `data-scientist` · `rag-specialist` · `training-data-curator` |
| `senior-prompt-engineer` | `ai-engineer` · `prompt-engineer` |
| `senior-data-scientist` | `data-scientist` · `analytics-reporter` · `experiment-tracker` |
| `senior-computer-vision` | `ai-engineer` |
| `senior-security` | `security-architect` · `threat-modeler` · `compliance-officer` · `data-privacy-officer` |
| `senior-secops` | `incident-responder` · `security-analyst` · `incident-post-mortem-writer` |
| `incident-commander` | `incident-responder` · `infrastructure-maintainer` |
| `aws-solution-architect` | `solution-architect` · `devops-automator` · `infrastructure-maintainer` · `cloud-cost-optimizer` |
| `marketing-skill` | `seo-specialist` · `growth-hacker` · `email-campaign-writer` · `landing-page-optimizer` · `content-strategist` |
| `self-improving-agent` | `ai-engineer` |

---

## Section 8 — Frameworks Reference

Behavioral science and domain frameworks from `documents/reference/FRAMEWORKS_MASTER.md` organized by skill domain. Only frameworks applied by active agents are listed.

| Framework | Skill Domain | Applied By |
|---|---|---|
| Fogg Behavior Model (FBM) | behavior-science-persuasion | `behavioral-designer` · `nudge-architect` |
| COM-B Model | behavior-science-persuasion | `behavioral-designer` · `ux-researcher` · `decision-architect` |
| EAST Framework | behavior-science-persuasion | `behavioral-designer` · `decision-architect` |
| Cialdini's 6 Principles | behavior-science-persuasion | `persuasion-specialist` · `influence-strategist` · `negotiation-specialist` · `conversion-optimizer` |
| Nudge Theory | behavior-science-persuasion | `nudge-architect` |
| Hook Model | behavior-science-persuasion | `habit-formation-coach` |
| Elaboration Likelihood Model (ELM) | behavior-science-persuasion | `conversion-optimizer` · `persuasion-specialist` |
| Cognitive Biases | behavior-science-persuasion | `decision-architect` |
| E-E-A-T | search-visibility | `seo-specialist` |
| Core Web Vitals | search-visibility | `seo-specialist` |
| Schema.org | search-visibility | `seo-specialist` |
| SEO | search-visibility | `seo-specialist` |
| AEO | search-visibility | `seo-specialist` |
| GEO | search-visibility | `seo-specialist` |
| OWASP Top 10 | security | `penetration-tester` · `security-architect` |
| NIST Cybersecurity Framework | security | `security-analyst` · `security-architect` |
| ISO 27001 | security · compliance | `compliance-officer` · `security-analyst` |
| SOC 2 | security · compliance | `compliance-officer` |
| GDPR | compliance | `data-privacy-officer` · `compliance-officer` |
| HIPAA | compliance | `data-privacy-officer` · `compliance-officer` |
| MITRE ATT&CK | security | `threat-modeler` · `incident-responder` |
| Zero Trust Architecture | security | `security-architect` |
| PCI-DSS | security · compliance | `compliance-officer` · `security-architect` |
| TOGAF | enterprise-architecture | `enterprise-architect` · `solution-architect` |
| DMBOK | enterprise-architecture | `data-architect` |
| Zachman Framework | enterprise-architecture | `enterprise-architect` · `business-architect` |
| COBIT | enterprise-architecture | `governance-specialist` |
| ITIL | enterprise-architecture | `infrastructure-maintainer` · `governance-specialist` |
| BIZBOK | enterprise-architecture | `business-architect` |
| Design Thinking | product-development-research | `ux-researcher` · `product-strategist` |
| Lean Startup | product-development-research | `innovation-researcher` · `rd-coordinator` |
| OKRs | product · project-management | `product-strategist` · `sprint-prioritizer` |
| TAM/SAM/SOM | product-development-research | `market-analyst` · `competitive-analyst` |
| Porter's Five Forces | product-development-research | `competitive-analyst` |
| SWOT Analysis | product-development-research | `competitive-analyst` · `market-analyst` |
| Jobs-to-Be-Done (JTBD) | product | `product-strategist` · `ux-researcher` |
| AIDA | content-creation · marketing | `content-strategist` · `email-campaign-writer` |
| Growth Hacking | marketing | `growth-hacker` · `gtm-strategist` |
| Brand Guidelines | brand | `brand-guardian` |
| Platform-Specific Writing | content-creation | `content-strategist` · `documentation-writer` |
| CI/CD | engineering | `devops-automator` |
| Infrastructure as Code | engineering | `devops-automator` · `infrastructure-maintainer` |
| Microservices Architecture | engineering · enterprise-architecture | `backend-architect` · `solution-architect` |
| API Design (REST/GraphQL) | engineering | `backend-architect` · `api-integrator` |
| Design Systems | design-system | `ui-ux-designer` · `ui-designer` |
| Nielsen Heuristics | design | `ux-researcher` · `ui-designer` |
| User Journey Mapping | design | `ux-researcher` · `onboarding-designer` |
| Accessibility (WCAG) | design · ui-styling | `accessibility-auditor` · `ui-designer` |
| SUS (System Usability Scale) | design | `ux-researcher` |
| Atomic Design | design-system | `ui-ux-designer` · `ui-designer` |
| Kanban | project-management | `workflow-optimizer` · `sprint-prioritizer` |
| Stage-Gate | project-management | `project-shipper` · `release-manager` |
| A/B Testing | project-management | `experiment-tracker` |
| RACI Matrix | project-management | `planner` · `project-shipper` |

---

**Source of truth:** `config/agent-registry.json` v6.2.0
  + `.claude/skills/` (skill files)
**Maintained by:** DrNabeelKhan | iSimplification.io
**Last updated:** 2026-04-11
**Active agents:** 87 | **Deprecated:** 28
