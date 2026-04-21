# Maxim Skill -- CEO Automation

> Layer 1 -- Supreme Authority | Executive Office: CEO
> Version: 1.0.0 | Created: 2026-04-11

## Domain

Cross-functional startup automation: strategy, metrics, pipeline, marketing, sales, launch, social media. Operates on `.mxm-executive-summary/` knowledge base per project.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If `.mxm-executive-summary/` exists in project root, this skill auto-activates alongside enterprise-architecture.

**Confidence tag:** `HIGH` (Maxim skill matched + behavioral layer applied)

## Lead Agent

`enterprise-architect` -- CEO Office

## Active Agents

| Agent | Office | Role in CEO Automation |
|---|---|---|
| enterprise-architect | CEO | Lead -- strategy, vision, architecture |
| financial-modeler | CEO | Runway, metrics, burn rate, investor modeling |
| investor-pitch-writer | CEO | Fundraising narratives, board updates |
| business-architect | CEO | Business model, market fit, ICP sharpening |
| governance-specialist | CEO | Compliance, regulatory policy |
| influence-strategist | CEO | Stakeholder alignment, partnerships |
| negotiation-specialist | CEO | Deal structuring, contract negotiation |
| partnership-manager | CEO | Strategic partnerships |
| studio-producer | CEO | Content production coordination |
| content-strategist | CMO | Marketing, email, content calendar |
| seo-specialist | CMO | SEO, content gap analysis |
| product-strategist | CPO | Roadmap, feature prioritization |

## Triggers

- ceo automation, startup automation, executive summary
- daily digest, pipeline report, metrics review, burn rate
- marketing automation, sales automation, social content
- investor update, fundraising, board prep, cap table
- weekly plan, OKR review, team capacity, sprint planning
- content calendar, email campaign, social media schedule
- competitor analysis, market research, ICP refinement

## Sub-Skills

| Sub-Skill | Path | Prompt Count | Coverage |
|---|---|---|---|
| CEO Tasks | `ceo-tasks/SKILL.md` | 25+ | Strategy, metrics, team, investors, decisions, comms |
| Marketing | `marketing/SKILL.md` | 20+ | Content, email, SEO, growth, brand, analytics |
| Sales | `sales/SKILL.md` | 25+ | Pipeline, prospecting, closing, proposals, retention |
| Launch/Product | `launch-product/SKILL.md` | 20+ | Launch readiness, roadmap, code quality, docs, feedback |
| Social Media | `social-media/SKILL.md` | 20+ | Facebook, X/Twitter, LinkedIn, cross-platform |

## Cross-Agent Auto-Loops

- `enterprise-architect` -- always active as CEO lead
- `financial-modeler` -- auto-loop on RUNWAY.md, METRICS.md tasks
- `content-strategist` -- auto-loop on marketing, social, email tasks
- `investor-pitch-writer` -- auto-loop on fundraising, board, investor tasks
- `security-analyst` -- CSO auto-loop on regulated project financial data

## Knowledge Base

Each startup project with `.mxm-executive-summary/` contains 30 files:
- 8 minimum viable: CONTEXT, ICP, PRODUCT, METRICS, CRM-notes, WINS, BRAND-VOICE, OKRs
- 15 operational: TEAM, BACKLOG, RUNWAY, COMPETITORS, OBJECTIONS, USER-FEEDBACK, CHANGELOG, LAUNCH-PLAN, MARKET, SPRINT, VALUES, BLOCKERS, published-posts, social-stats, email-stats
- 7 research/sessions: .research/ (PRD, FRD, SRD, ARCHITECTURE), sessions/ (CLAUDE, progress, tasks)

Cross-portfolio intelligence in `.mxm-global/`: GLOBAL-CONTEXT.md, INVESTOR-PROFILE.md, PORTFOLIO-METRICS.md

## Reference Library

Full prompt text: `ceo-automation-prompts.md` at Maxim repo root (2,441 lines, 160+ prompts)

## Maxim Behavioral Layer — MOAT ENFORCEMENT

**Maxim's moat is NOT the tools. It is the behavioral science, persuasion frameworks, decision psychology, and cross-domain agent collaboration baked into every output.**

Every output from this skill domain MUST apply:

### Mandatory Behavioral Science (non-negotiable)
- **Fogg Behavior Model** — every recommendation must address Motivation + Ability + Prompt
- **COM-B** — Capability, Opportunity, Motivation analysis on team/customer actions
- **EAST Framework** — make every recommendation Easy, Attractive, Social, Timely
- **Hook Model** (Nir Eyal) — Trigger > Action > Variable Reward > Investment on product/growth prompts
- **Loss Aversion** — frame risks and burn rate alerts with loss framing (Kahneman)

### Framework Selection (from documents/reference/FRAMEWORKS_MASTER.md)
Each prompt output must select the right framework from documents/reference/FRAMEWORKS_MASTER.md for the task:
- Strategy prompts → Porter's Five Forces, Blue Ocean, Jobs-to-be-Done
- Sales prompts → SPIN Selling, Challenger Sale, MEDDIC
- Marketing prompts → AIDA, PAS, StoryBrand
- Product prompts → RICE, Kano Model, Design Thinking
- Financial prompts → SaaS Unit Economics, Cohort Analysis, Scenario Modeling

### Proactive Agent Collaboration
- Route strategy conflicts → `enterprise-architect` (CEO arbitration)
- Route compliance signals → `security-analyst` (CSO auto-loop)
- Route content tasks → `content-strategist` + `seo-specialist` in parallel
- Route financial tasks → `financial-modeler` for validation
- Flag unenhanced output → 🔴 Maxim-UNENHANCED + log to `.mxm-skills/agents-skill-gaps.log`

### Standard Enforcement
- Confidence tagging: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW on every output
- Compliance awareness (reads project-manifest.json per_project)
- Session continuity (writes to .mxm-executive-summary/sessions/)
- Handoff protocol (writes .mxm-skills/agents-handoff.md on completion)
- Skill gap logging (appends .mxm-skills/agents-skill-gaps.log if data missing)
- Super User mode: if `super_user.enabled = true`, tag outputs 🔵 SUPER USER
