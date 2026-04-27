# Maxim: The Operating System for AI-Assisted Work

> 90+ governed agents. 34 skill domains. 7 MCP servers (55 tools). 79 behavioral science frameworks. 14 executable hooks. 10 ADRs ratified. Documents as Executable Contracts.
> One `/plugin install maxim@anthropic-official` powers every project you build.

---

## What Maxim Actually Is

Maxim is not a prompt library. It is not a chatbot wrapper. It is not a collection of clever instructions you paste into Claude.

Maxim is a **governed, multi-agent operating system** that runs across every Claude surface: Code, Desktop, CLI, Dispatch, Cowork. It transforms a general-purpose AI into a full C-suite of specialists that know your projects, remember your decisions, learn your preferences, and enforce compliance without being asked.

When you type `/mxm-cto build me a RAG pipeline`, Maxim activates the **implementer** agent, loads the **engineering** skill domain, reads your `project-manifest.json` for compliance scope, checks the **CSO auto-loop** for security implications, applies **SOLID** and **12-Factor App** frameworks, writes code one subtask per commit, then hands off to the **reviewer** for QA. All of that is automatic. Every output is confidence-tagged. Every decision is logged. Every session is remembered.

No other public AI agent framework does this.

---

## The Competitive Landscape: And Why Nothing Else Comes Close

We studied every significant public agent framework as of April 2026. Here is what exists and what each one lacks.

### What Others Built

**coreyhaines31/marketingskills** (21K+ stars) built 40+ marketing skills with a brilliant hub-and-spoke architecture. Every skill reads a foundation context file first. Clean, modular, well-documented. But it covers marketing only. No governance. No compliance. No inter-agent handoff. No session memory. No multi-office routing.

**NousResearch/hermes-agent** built a self-improving agent that generates new skills from task trajectories, searches its own memory with FTS5, builds a deepening model of who you are across sessions, and connects to Telegram, Slack, Discord, and WhatsApp. Technically impressive. But it is a single agent, not an organization. No office structure. No compliance gates. No behavioral science. No governed handoff chain.

**VoltAgent/awesome-design-md** created the DESIGN.md standard: a 9-section markdown format that lets any AI build pixel-perfect UIs from plain text. Elegant and portable. But it is a resource library, not an agent system. No dispatch. No memory. No governance.

**OSideMedia/higgsfield-ai-prompt-skill** built a dispatcher pattern: one root SKILL.md that orchestrates 18 sub-skills with shared resources. Smart architecture. But single-domain (video generation). No cross-domain routing. No compliance.

**AKCodez/higgsfield-claude-skills** combined Playwright automation with prompt engineering skills. Dual-layer design. But no governance, no memory, no multi-project awareness.

### What Maxim Built: By Absorbing All of Them

Maxim didn't compete with these repos. It consumed their best ideas and elevated them into an enterprise-grade system:

| Capability | marketingskills | hermes-agent | awesome-design-md | Maxim |
|---|---|---|---|---|
| Specialist agents | 0 | 1 (self) | 0 | **90+ (100% Grade A DNA)** |
| Skill domains | 1 (marketing) | 26 (categories) | 1 (design) | **34** |
| Behavioral science frameworks | 0 | 0 | 0 | **79** |
| Compliance enforcement | None | None | None | **GDPR, PIPEDA, SOC2, PCI-DSS, HIPAA, UAE-PDPL, FINTRAC, 14 frameworks total** |
| Inter-agent handoff | None | None | None | **Structured handoff chain with BLOCK/PARTIAL/READY status + bilateral Collaboration Matrix on every agent** |
| Session memory | None | FTS5 search | None | **3-tier file memory + MemPalace + claude-mem** |
| Operator profiling | None | Honcho | None | **Honcho-inspired profile with preference signals, rejected patterns** |
| Skill auto-generation | None | Yes | None | **skill-synthesizer agent with human approval gate** |
| Hub-and-spoke context | Yes | No | No | **Yes (MARKETING-CONTEXT.md + per-domain)** |
| Design resource library | No | No | Yes (66 examples) | **Yes (59 brand DESIGN.md templates + DESIGN.md standard)** |
| Cross-project awareness | No | No | No | **Yes (.mxm-global/ portfolio with 22 projects)** |
| CI/CD validation | No | No | No | **Yes (mxm-validate.yml on every PR)** |
| Drift detection | No | No | No | **Yes (Proactive Watch — 10 universal drift classes)** |
| Governance trail | No | No | No | **Yes (ADR ledger — PROPOSED → ACCEPTED → SUPERSEDED lifecycle)** |
| Version sync | No | No | No | **Yes (sync-version.ps1/.sh — zero drift)** |
| Multi-surface support | Claude Code only | Multi-platform gateway | Claude Code only | **Claude Code + Desktop + CLI + Dispatch + Cowork + Web Projects** |

---

## The Maxim Moat: Why This Can't Be Copied Quickly

### 1. Governance Architecture (12 months of work)

Every Maxim output passes through a governance chain that no other framework has:

- **CSO Auto-Loop:** Any task touching security, PII, payments, or regulated data automatically notifies the security-analyst agent. You cannot bypass this. The agent reviews, flags, and either clears or blocks.
- **Ethics Gates:** Output statuses are BLOCK / COMPLIANT / REMEDIATE. Not advisory. Structural.
- **Compliance Pre-Enforcement:** Before any agent writes code for a GDPR project, it reads `project-manifest.json`, identifies the compliance frameworks, and applies jurisdiction-specific rules. RoPA audit trails. Data flow mapping. Consent mechanism review. Automatic.
- **Confidence Tagging:** Every output is tagged: HIGH (Maxim skill matched), MEDIUM (partial match), LOW (unenhanced). You always know how much to trust the output.

This is not a feature you bolt on. It is architecture. Replicating it requires understanding multi-jurisdiction regulatory compliance AND building it into the dispatch sequence at every layer.

### 2. Behavioral Science Depth (79 frameworks, structurally applied)

Most AI systems treat behavioral science as a prompt add-on: "use persuasion principles." Maxim makes it structural.

Every skill domain declares which behavioral frameworks apply. The `behavioral-designer` agent reads the operator profile and applies personalization. The `nudge-architect` designs choice architecture. The `habit-formation-coach` applies the Hook Model. The `persuasion-specialist` uses Cialdini's 6 Principles with ethical gates.

These are not suggestions. They are the dispatch logic. When you run `/mxm-cmo write a launch campaign`, Maxim doesn't just write copy. It applies AIDA structure, COM-B analysis (does the audience have Capability, Opportunity, and Motivation?), EAST framework (is it Easy, Attractive, Social, and Timely?), and Fogg Behavior Model triggers.

79 frameworks. Applied automatically. Not on request. Drift detection runs at every session start via the `proactive-watch` framework.

### 3. The 5-Layer Dispatch Sequence (deterministic, not hallucinated)

```
Layer 1: .claude/skills/           ← Maxim domain skills (supreme authority)
Layer 2: community-packs/          ← community pack ecosystem (vendored, read-only)
Layer 3: composable-skills/        ← workflow engine (TDD, debugging, planning)
Layer 4: agents/Maxim/{office}/     ← 90+ specialist agents across 7 offices (100% Grade A DNA)
Layer 5: behavioral layer          ← CLAUDE.md universal rules + frameworks
```

Every task goes through this sequence. Layer 1 always wins on conflict. There is no hallucinated routing. The dispatch table maps task signals to specific agents with deterministic rules.

### 4. Session Memory That Actually Works

Maxim's memory system is three layers deep:

- **File-based** (always active). `.claude-sessions-memory/` with handoff, decision log, skill gaps, file inventory, compact seeds. Works on every Claude surface. Zero dependencies.
- **MemPalace** (when installed). Semantic search across 7 office wings. Query by meaning, not filename. Temporal knowledge graph with validity windows.
- **claude-mem** (when installed). Persistent cross-session memory with code-aware exploration.

Maxim detects which tools are available and uses all of them. If none are installed, file memory works perfectly. This is graceful degradation, not feature gating.

### 5. Operator Profile: It Learns You

Inspired by Hermes-agent's Honcho architecture, Maxim builds a deepening model of who you are:

- **OPERATOR.md:** Your identity, expertise, goals
- **preferences.md:** Output format, tool preferences, code style
- **rejected-patterns.md:** Approaches you've corrected (append-only, never deleted)
- **communication-style.md:** How you phrase requests, preferred verbosity

Every session reads the profile silently. Every session updates it based on preference signals detected during work. After 10 sessions, Maxim knows your style. After 50, it anticipates your needs.

### 6. Zero Duplication Architecture

Maxim is installed once. Every project links to it:

```
~/.claude/CLAUDE.md  → maxim/CLAUDE.md       (one file, all projects)
~/.claude/commands/  → maxim/.claude/commands/ (37 commands, all projects)
~/.claude/skills/    → maxim/.claude/skills/   (34 domains, all projects)
~/.claude/agents/    → maxim/agents/           (90 agents, all projects)
```

`git pull` in maxim updates every project instantly. No per-project copies. No version drift. No maintenance burden.

Per-project, only identity files are created: `project-manifest.json`, `CLAUDE.project.md`, runtime state, session memory, and architecture docs. The framework is shared. The data is per-project.

---

## What You Get: The Full Inventory

### 7 Executive Offices
| Office | Lead Agent | Specialists | Domain |
|---|---|---|---|
| **CEO** | enterprise-architect | 9 agents | Strategy, finance, governance, partnerships |
| **CTO** | implementer | 25 agents | Engineering, AI, APIs, DevOps, data |
| **CMO** | content-strategist | 15 agents | Marketing, brand, SEO, content, growth |
| **CSO** | security-analyst | 9 agents | Security, compliance, privacy, ethics |
| **CPO** | product-strategist | 12 agents | Product, UX/UI, research, pricing |
| **COO** | planner | 10 agents | Operations, delivery, sprints, support |
| **CINO** | innovation-researcher | 4 agents | R&D, emerging tech, horizon scanning |

Plus 5 cross-office orchestrators + 1 executive-router = **90 agents total**. All 90 carry Grade A DNA (Triggers + bilateral Collaboration Matrix).

### 34 Skill Domains (100% with root dispatchers)
Every domain has a SKILL.md (orchestrator), Maxim-WRAPPER.md (behavioral layer), and sub-skills that route to specialist agents. Marketing alone has a hub-and-spoke architecture with dedicated sub-skills. The `wiki` family (ingest, query, lint, explore), `voice`, `junction-guard`, `usage-aware-scheduler`, and `proactive-watch` domains complete the 34-domain inventory.

### 37 Slash Commands
All prefixed with `/mxm-` for uniform discovery. Product cycle chain: `/mxm-plan` → `/mxm-implement` → `/mxm-review` → `/mxm-test` → `/mxm-release`. `/mxm-watch` runs drift detection. `/mxm-session-end` runs the 9-document closure bundle. `/mxm-brand-voice` manages the 3-layer .brand-foundation load.

### 7 MCP Servers (55 tools)
55 tools across 7 consolidated servers. Covers behavioral science, compliance, context and watch, design, dispatch and catalog, memory, and portfolio. Usable from Claude Desktop, Cowork, CLI, Dispatch, and claude.ai.

### Cross-Project Portfolio Management
`.mxm-global/` at `E:\Projects\` level with GLOBAL-CONTEXT.md, TASKS.md, PORTFOLIO-METRICS.md, INVESTOR-PROFILE.md, and project registry. `/mxm-tasks` and `/mxm-portfolio` manage work across 22 NK-universe projects.

### Bootstrap + Migration Scripts
- `install-global.ps1`. one-time global install (4 symlinks)
- `link-local-project.ps1`. per-project scaffold (19 files, 7 folders)
- `new-project-setup.sh`. bash equivalent for Mac/Linux/CI
- `update-maxim.ps1`. migration from any prior version with intelligence scan
- `sync-version.ps1`. zero version drift (propagates to 7 files in one command)
- `mxm-validate.yml`. CI/CD validation on every PR

---

## Who This Is For

Maxim is not for casual prompt users. It is for:

- **Solo founders running multiple startups** who need every project to have consistent governance, compliance awareness, and cross-project intelligence. without hiring a team
- **Enterprise architects** who need AI-assisted work to follow TOGAF, Zachman, C4 Model, and pass SOC2/GDPR/HIPAA audits
- **Agency operators** managing 10+ client projects who need brand voice consistency, compliance pre-enforcement, and repeatable delivery
- **AI engineers** building production systems who need governed agent chains with structured handoff, not ad-hoc prompting

If you are managing one small project and just need Claude to write code, you don't need Maxim. Use Claude directly.

If you are managing a portfolio of projects across multiple verticals with compliance requirements, multi-agent coordination needs, and the ambition to compound your AI's intelligence over time. Maxim is the only system that does this.

---

## The Business Case

### Without Maxim
- Every Claude session starts cold. no memory of past decisions
- Compliance is manual. you remember to check, or you don't
- No behavioral science. outputs are competent but not psychologically optimized
- Every project is independent. no cross-project intelligence
- Agent capabilities are generic. no specialist depth
- Version drift across projects. manual updates, stale configs

### With Maxim
- Every session resumes with full context. decisions, preferences, skill gaps, operator profile
- Compliance is automatic. CSO auto-loop, jurisdiction-specific pre-enforcement
- 79 behavioral frameworks applied structurally, not on request
- Portfolio-wide awareness across tasks, metrics, and synergies for 22 projects
- 90+ specialist agents (100% Grade A DNA) with governed handoff chains and bilateral Collaboration Matrix
- One `git pull` updates everything. zero drift, zero maintenance (Proactive Watch catches drift at session start)

### The Math
A human chief of staff costs $150K-250K/year. A compliance officer costs $120K-180K/year. A behavioral scientist costs $130K-200K/year. A marketing team of 15 specialists costs $1.5M+/year.

Maxim gives you all of them. governed, tireless, and improving with every session. for the cost of a Claude subscription.

---

## Getting Started

```
/plugin install maxim@anthropic-official
```

One command installs the full framework. 90+ agents, 34 skill domains, 37 slash commands, 7 MCP servers, 55 tools, 14 executable hooks, 79 behavioral frameworks. Free tier fully functional on install.

```
/plugin marketplace add https://github.com/DrNabeelKhan/maxim
/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs
mxm-pack-engine activate --license <JWT-from-purchase-email>
```

Commercial packs (L1 capabilities, L2 persona bundles, L3 verticals) install from the private marketplace after LemonSqueezy purchase. Pricing at https://maxim.isystematic.com.

For source-level integration or non-Claude-Code IDE work, see [documents/guides/GETTING_STARTED.md](documents/guides/GETTING_STARTED.md) for the manual install path.

---

**Maxim v1.0.0:** 

90+ agents (100% Grade A DNA). 34 skill domains. 37 commands. 7 MCP servers (55 tools). 79 frameworks. 14 executable hooks. 10 ADRs ratified. 5 canonical ledgers. Voice-driven. RAG-backed. Usage-aware. Drift-aware. Plugin-distributed.

**License:** BSL 1.1 core with 4-year Apache 2.0 conversion per ADR-005. Commercial packs licensed separately via LemonSqueezy.

The most architecturally sophisticated public AI agent framework in production.

[github.com/DrNabeelKhan/maxim](https://github.com/DrNabeelKhan/maxim)
