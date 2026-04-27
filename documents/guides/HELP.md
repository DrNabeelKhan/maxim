# Maxim: User Guide

**Maxim v1.0.0** | 90+ agents (100% Grade A DNA) · 34 skill domains · 37 commands · 79 frameworks · 7 MCP servers (55 tools) · 14 executable hooks · 10 ADRs ratified

---

## Install (recommended path)

```
/plugin install maxim@anthropic-official
```

That single command installs the full framework into Claude Code. The free tier is fully functional on install. Commercial packs install from the private marketplace after purchase:

```
/plugin marketplace add https://github.com/DrNabeelKhan/maxim
/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs
mxm-pack-engine activate --license <JWT-from-purchase-email>
```

Pricing at https://maxim.isystematic.com. Manual install (git clone + symlinks) remains available for source-level integration; see documents/guides/GETTING_STARTED.md for that path.

**Prerequisites:** Claude Code 2.1+. Windows users install Git for Windows (https://git-scm.com/download/win) for background monitor support.

---

## Quick Reference Card

All Maxim commands at a glance. Copy and paste any command into Claude Code, Claude Desktop, or Claude.ai.

### Office Shortcuts (Route to Executive Offices)

| Command | Route | For | Example |
|---|---|---|---|
| `/mxm-ceo` | CEO Office | Strategy, vision, finance, enterprise architecture | `/mxm-ceo Create a 90-day roadmap` |
| `/mxm-cto` | CTO Office | Engineering, APIs, DevOps, AI, infrastructure | `/mxm-cto Design a microservices architecture` |
| `/mxm-cmo` | CMO Office | Marketing, brand, SEO, content, GTM | `/mxm-cmo Create a launch campaign` |
| `/mxm-cso` | CSO Office | Security, compliance, privacy, risk, ethics | `/mxm-cso Threat model this API` |
| `/mxm-cpo` | CPO Office | Product strategy, UX, UI, user research | `/mxm-cpo Analyze user feedback` |
| `/mxm-coo` | COO Office | Operations, delivery, sprints, experiments | `/mxm-coo Plan a 2-week sprint` |
| `/mxm-cino` | CINO Office | R&D, emerging tech, horizon scanning | `/mxm-cino Evaluate LLM providers` |
| `/mxm-route` | Executive Router | Unknown intent—auto-classify and route | `/mxm-route I need help with [vague task]` |

### Product Cycle (Linear Chain: Plan → Implement → Review → Test → Release)

| Command | Phase | What It Does | Output |
|---|---|---|---|
| `/mxm-plan` | 1. Planning | Analyzes task, creates task_plan.md, progress.md, findings.md | 3 files + task breakdown |
| `/mxm-implement` | 2. Build | Reads task_plan.md, executes, chains to review automatically | Code/docs + auto-review |
| `/mxm-review` | 3. Review | QA + peer review, flags issues, chains to test | Review report + decisions |
| `/mxm-test` | 4. Testing | Runs test suite, coverage report, chains to release | Test report + recommendations |
| `/mxm-release` | 5. Deploy | Final checks, changelog, deployment, session save | Deployed + session archived |

### Specialist Commands (Deep Domain Work)

| Command | Skill Domain | What It Does |
|---|---|---|
| `/mxm-new-project` | Project Setup | Interactive wizard: git repo → bootstrap → manifest → CLAUDE.project.md |
| `/mxm-ceo-setup` | CEO Automation | One-time setup: seeds 30-file `.mxm-executive-summary/` with brand voice |
| `/mxm-ceo-morning` | CEO Daily Cycle | Morning standup: email inbox, CRM updates, OKR progress, decisions |
| `/mxm-ceo-overnight` | CEO Daily Cycle | Overnight: market research, competitive analysis, portfolio updates |
| `/mxm-design` | Design System | All 6 design sub-domains in parallel: brand, UI, banner, slides, design-system, styling |
| `/mxm-seo` | Search Visibility | Full SEO audit: keywords, content gaps, technical SEO, AEO strategy |
| `/mxm-security` | Security Audit | Threat model, vulnerability scan, CSO auto-loop, audit report |
| `/mxm-compliance` | Compliance Check | Framework audit vs. GDPR/HIPAA/SOC2/PCI-DSS/PIPEDA, CAP creation |
| `/mxm-behavior` | Behavioral Science | Behavioral audit: Fogg, COM-B, EAST, Hook Model, persuasion analysis |
| `/mxm-superpowers` | Workflow Automation | Interactive menu: test-driven development, debugging, verification, planning |
| `/mxm-remember` | Memory Palace | Store important context in MemPalace with office routing |
| `/mxm-recall` | Memory Palace | Retrieve context from MemPalace by topic, project, or office |
| `/mxm-status` | System Status | Verify install, project setup, manifest validation, session state |
| `/mxm-brand-voice` | Brand Foundation | Manage the 3-layer brand voice load (Maxim base + operator overlay + startup overlay) |

---

## /mxm-brand-voice: Brand Foundation Management

Maxim ships a three-layer voice system. Every external-facing output loads all three layers in order before composition: Maxim base (non-overridable) + operator overlay (gitignored, personal) + startup overlay (gitignored, per-vertical). The `/mxm-brand-voice` command manages this system with four subcommands.

| Subcommand | What it does |
|---|---|
| `/mxm-brand-voice calibrate` | Interactive wizard to capture your operator identity, signature phrases, and banned phrases. Writes to `.brand-foundation/personal.local/`. Run once per machine. |
| `/mxm-brand-voice update` | Update the operator overlay when your voice drifts or expands. Preserves history via `CHANGELOG-voice.md`. |
| `/mxm-brand-voice scan <file>` | Run the full voice scan (em-dash prohibition, ai-tells ban list, content-rules check, sentence-length target) against any file. Returns PASS or FAIL with specific line numbers. Required before committing external-facing content. |
| `/mxm-brand-voice reset` | Revert the operator overlay to the last calibrated baseline. Destructive; confirms before acting. |

The three layers merge into a unioned ai-tells ban list: a phrase banned in any layer is banned in all outputs for the session. Compliance rules from the startup layer override operator preferences when the content is regulated.

See `.brand-foundation/VOICE-MANAGEMENT.md` for the full protocol.

---

## Maxim Statusline

The plugin ships a two-line Claude Code statusline rendered in Technical Educator voice per ADR-010 (Confidence Tag Technical Educator Rubric). Bash and PowerShell versions ship side by side; the plugin's `settings.json` wires whichever your shell supports.

**Line 1** renders the active project, lifecycle status, and a creative label derived from the most recent activity record. Label examples: Wordsmith (content work), Sentinel (security/compliance), B=MAP Scaffold (behavioral framework application), Archivist (memory operations), Watchtower (drift detection), Dispatcher (office routing).

**Line 2** renders four measured quantities with ANSI tier colors. Context percentage turns yellow at 60% and red at 80%. Five-hour rate turns yellow at 70% and red at 85%. Seven-day rate turns yellow at 75% and red at 80%. Skill-gap count shows open unresolved routing gaps.

Every label and value is an OSC 8 clickable link to `https://maxim.isystematic.com/docs/glossary#<anchor>`. Missing data sources fall back gracefully: no manifest renders "no-manifest", no activity record renders the default "Maxim Ready" label, no skill-gap log renders "gaps 0".

See ADR-010 in `documents/ADRs/` for the full rubric specification.

---

## Installation

Choose your path based on your platform and usage pattern.

### Windows (Recommended): Global Install

**One-time admin setup, then per-project linking:**

1. Open PowerShell as Administrator
2. Clone Maxim (do this once, anywhere):
   ```powershell
   git clone https://github.com/DrNabeelKhan/maxim.git
   cd maxim
   ```

3. Run global installer (once only):
   ```powershell
   .\bootstrap\install-global.ps1
   ```
   What it does: Creates symlinks in `Program Files\Maxim`, registers with Claude Code/Desktop

4. Bootstrap each new project (your project directory):
   ```powershell
   # Option A: From PowerShell
   .\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\MyProject" -ProjectName "My Project"
   
   # Option B: From Claude Code (easier—no PowerShell)
   /mxm-new-project
   ```
   What it does: Seeds `config/project-manifest.json`, `CLAUDE.project.md`, `.mxm-skills/` folder structure

5. Verify setup:
   ```
   /mxm-status
   ```

### Mac/Linux: PowerShell 7 or Bash

**Option A: PowerShell 7 (cross-platform, same as Windows):**
```bash
# Install PowerShell 7 if needed: https://github.com/PowerShell/PowerShell/releases
pwsh
cd maxim
./bootstrap/link-local-project.ps1
```

**Option B: Bash (no PowerShell 7 required):**
```bash
cd maxim
bash bootstrap/new-project-setup.sh
```
What it does: Interactive wizard (10+ questions including compliance frameworks, tech stack, agent overrides)

Then verify:
```
/mxm-status
```

### Subtree Method (CI/CD, Non-Windows Preferred)

**For repos that pull Maxim as a dependency:**

1. Add Maxim as subtree (one-time per repo):
   ```bash
   git subtree add --prefix=.mxm-skills \
     https://github.com/DrNabeelKhan/maxim.git main --squash
   ```

2. Bootstrap:
   ```bash
   bash .mxm-skills/bootstrap/new-project-setup.sh
   ```

3. Future updates:
   ```bash
   git subtree pull --prefix=.mxm-skills \
     https://github.com/DrNabeelKhan/maxim.git main --squash
   ```

---

## New Project Setup (Complete Walkthrough)

Every new project needs three files. Maxim walks you through this.

### Step 1: Run Bootstrap Wizard

**From Claude Code (easiest):**
```
/mxm-new-project
```

**From PowerShell (Windows only):**
```powershell
.\bootstrap\link-local-project.ps1
```

**From Bash (Mac/Linux/CI):**
```bash
bash bootstrap/new-project-setup.sh
```

### Step 2: The Wizard Asks 15 Questions

The wizard prompts for:
- **Project basics:** ID, name, owner, description, stage (idea/early-stage/active/scaling/mature)
- **Compliance frameworks** (select all that apply):
  - PIPEDA (Canada)
  - PCI-DSS (payments)
  - TCPA (US outreach)
  - AU-Privacy-Act-1988 (Australia)
  - GDPR (EU)
  - UAE-PDPL (UAE/Gulf)
  - HIPAA (US health)
  - SOC2 (enterprise)
- **Tech stack:** Default model provider (anthropic/openai/gemini/mistral/local), preferred models
- **Bootstrap template:** saas-marketplace / ai-agent-service / compliance-app / api-backend / none

### Step 3: Verify Generated Files

After wizard completes, three files are created:

**1. `config/project-manifest.json`** (auto-filled, do not edit):
```json
{
  "manifest_version": "1.0.0",
  "MXM_version": "6.4.4",
  "project": {
    "id": "my-project",
    "name": "My Project",
    "owner": "my-github-username",
    "vertical": "SaaS",
    "description": "...",
    "stage": "active",
    "active": true
  },
  "compliance": {
    "frameworks": ["GDPR", "SOC2"],
    "per_project": { "my-project": ["GDPR", "SOC2"] }
  },
  "tech_stack": {
    "default_model_provider": "anthropic",
    "preferred_models": { .. }
  },
  "super_user": { "enabled": false }
}
```

**2. `CLAUDE.project.md`** (optional, edit for customization):
- Add project-specific agent rules (e.g., "All code requires security review")
- Define brand voice (tone, audience, messaging)
- Override default agent behavior

**3. `.mxm-skills/` folder structure** (session state):
- `session-[YYYY-MM-DD].md` ← session memory
- `handoff.md` ← inter-agent state
- `skill-gaps.log` ← unmet capability requests

### Step 4: Verify Installation

```
/mxm-status
```

Expected output:
```
Maxim SESSION START
  Project      : my-project
  Root         : E:\Projects\MyProject
  Install      : GLOBAL | LEGACY-LOCAL | MIXED
  Manifest     : ✅ loaded
  CLAUDE.project.md : ✅ loaded
  Handoff      : [status]
  Open gaps    : [count]
  Active task  : [task_plan.md summary or none]
```

---

## Daily Usage Patterns

### Starting a Task (The /mxm-route Pattern)

When you don't know which office to ask:

```
/mxm-route I need to build a real-time notifications system for my SaaS product
```

Maxim's `executive-router` will:
1. Analyze task intent
2. Detect signals (code → CTO, compliance → CSO, marketing → CMO, etc.)
3. Route to the right office
4. Activate required agents
5. Tag output with confidence level (🟢 HIGH / 🟡 MEDIUM / 🔴 LOW)

### Running the Full Product Cycle

**For any significant feature or release:**

```
/mxm-plan Build an audit log system for HIPAA compliance
→ creates task_plan.md, progress.md, findings.md
→ shows timeline, dependencies, resource needs

/mxm-implement
→ reads task_plan.md
→ generates code/docs
→ automatically chains to /mxm-review

/mxm-review
→ QA + architecture review
→ flags issues, suggests refactors
→ chains to /mxm-test

/mxm-test
→ runs test suite
→ coverage report
→ chains to /mxm-release

/mxm-release
→ final pre-deploy checks
→ changelog generation
→ deployment confirmation
→ saves session state to .mxm-skills/
```

### CEO Daily Automation (Optional)

**One-time setup (fills `.mxm-executive-summary/` with 30 files):**
```
/mxm-ceo-setup
```

Fill in the 8 minimum viable files:
- `CONTEXT.md`. market positioning, company stage, key metrics
- `ICP.md`. ideal customer profile
- `PRODUCT.md`. product roadmap, differentiators, positioning
- `METRICS.md`. key business metrics (MRR, CAC, LTV, etc.)
- `CRM-notes.md`. prospect/customer pipeline status
- `WINS.md`. recent wins, case studies
- `BRAND-VOICE.md`. tone, messaging, audience
- `OKRs.md`. quarterly goals and key results

**Then, every morning:**
```
/mxm-ceo-morning
```
Generates:
- Email inbox summary
- CRM pipeline updates
- OKR progress dashboard
- Decision queue

**Or, overnight (async analysis):**
```
/mxm-ceo-overnight
```
Generates:
- Competitive analysis
- Market research summary
- Portfolio performance review
- Strategic recommendations

---

## Skill Domains (34 Total)

Every domain activates automatically when tasks match. Domains are grouped by executive office.

| Domain | Office | Covers | Key Command |
|---|---|---|---|
| **Behavior Science & Persuasion** | CEO | Fogg Behavior Model, COM-B, EAST, Hook Model, persuasion psychology | `/mxm-behavior` |
| **Enterprise Architecture** | CEO | System design, tech strategy, scalability, cloud architecture | `/mxm-ceo Design architecture` |
| **Business Growth** | CEO | Revenue models, pricing, expansion strategy, unit economics | `/mxm-ceo What's our pricing strategy?` |
| **Content Creation & Copywriting** | CMO | Docs, API reference, blog, emails, landing pages | `/mxm-cmo Write a feature announcement` |
| **Design System & UI/UX** | CPO | Brand, UI components, design tokens, accessibility | `/mxm-design` |
| **Engineering & Backend** | CTO | Microservices, APIs, databases, DevOps, infrastructure | `/mxm-cto Design a microservice` |
| **Frontend Development** | CTO | React, Vue, TypeScript, Tailwind, state management | `/mxm-cto Build a React component` |
| **AI & Machine Learning** | CTO | LLMs, prompt engineering, RAG, fine-tuning, evaluation | `/mxm-cto Evaluate RAG approaches` |
| **Product Strategy** | CPO | Roadmap, positioning, user research, competitive analysis | `/mxm-cpo Create a product roadmap` |
| **Marketing & GTM** | CMO | Campaign strategy, messaging, SEO, conversion optimization | `/mxm-cmo Create a GTM plan` |
| **Search Visibility (SEO/AEO)** | CMO | Keyword research, technical SEO, content gaps, AEO strategy | `/mxm-seo` |
| **Project Management** | COO | Sprints, timelines, task breakdown, delivery tracking | `/mxm-coo Plan a sprint` |
| **Operations & Support** | COO | Customer support, knowledge base, workflows, automation | `/mxm-coo Improve support ticketing` |
| **Security & Threat Modeling** | CSO | Architecture review, pen testing, threat model, CSO auto-loop | `/mxm-security` |
| **Compliance & Regulatory** | CSO | GDPR, HIPAA, SOC2, PCI-DSS, audit, CAPA | `/mxm-compliance` |
| **Privacy & Data Protection** | CSO | PII handling, data mapping, privacy policy, DPA review | `/mxm-cso Review privacy policies` |
| **Testing & QA** | CTO | Unit tests, integration tests, coverage, end-to-end testing | `/mxm-test` |
| **Innovation & R&D** | CINO | Emerging tech evaluation, horizon scanning, proof-of-concepts | `/mxm-cino Evaluate blockchain` |
| **Studio Operations** | COO | Google Workspace, project templating, resource scheduling | `/coo Automate studio ops` |
| **Workflow Automation** | COO | Test-driven dev, debugging, verification, systematic planning | `/mxm-superpowers` |
| **CEO Automation** | CEO | Morning/overnight cycles, CRM sync, OKR tracking, inbox management | `/mxm-ceo-morning` / `/mxm-ceo-overnight` |
| **Memory Palace** | All | MemPalace MCP integration, cross-session semantic memory, office-routed recall | `/mxm-remember` / `/mxm-recall` |

---

## Executive Offices (7 + Router)

### CEO Office

**Lead Agent:** enterprise-architect  
**Scope:** Strategy, vision, finance, business architecture, partnerships  
**When to use:** Long-term planning, revenue models, market positioning, M&A strategy

**Agents in this office:**
- enterprise-architect (lead)
- business-architect
- influence-strategist
- negotiation-specialist
- financial-modeler
- partnership-manager
- governance-specialist
- studio-producer
- investor-pitch-writer

### CTO Office

**Lead Agent:** implementer  
**Scope:** Engineering, infrastructure, AI, APIs, DevOps, cloud, databases  
**When to use:** Architecture decisions, backend design, API contracts, deployment strategy

**Agents in this office:**
- implementer (lead)
- ai-engineer
- backend-architect
- frontend-developer
- devops-automator
- infrastructure-maintainer
- security-architect
- solution-architect
- rag-specialist
- prompt-engineer
- api-integrator
- database-optimizer
- performance-engineer

### CMO Office

**Lead Agent:** content-strategist  
**Scope:** Marketing, brand, content, SEO, GTM, conversion, persuasion  
**When to use:** Campaign planning, content strategy, brand positioning, messaging

**Agents in this office:**
- content-strategist (lead)
- seo-specialist
- brand-guardian
- conversion-optimizer
- persuasion-specialist
- behavioral-designer
- habit-formation-coach
- nudge-architect
- growth-hacker
- gtm-strategist
- landing-page-optimizer

### CSO Office

**Lead Agent:** security-analyst  
**Scope:** Security, compliance, privacy, risk, AI ethics, incidents  
**When to use:** Threat modeling, security audits, compliance checks, privacy reviews, incident response

**Agents in this office:**
- security-analyst (lead)
- threat-modeler
- penetration-tester
- incident-responder
- compliance-officer
- ai-ethics-reviewer
- data-privacy-officer
- legal-compliance-checker

### CPO Office

**Lead Agent:** product-strategist  
**Scope:** Product strategy, UX/UI design, user research, market analysis  
**When to use:** Feature prioritization, UX design, user testing, competitive analysis

**Agents in this office:**
- product-strategist (lead)
- ux-researcher
- ui-designer
- ui-ux-designer
- feedback-synthesizer
- trend-researcher
- competitive-analyst
- market-analyst
- pricing-strategist
- accessibility-auditor
- onboarding-designer

### COO Office

**Lead Agent:** planner  
**Scope:** Operations, delivery, sprints, experiments, support, tools  
**When to use:** Sprint planning, delivery tracking, customer support, workflow optimization

**Agents in this office:**
- planner (lead)
- project-shipper
- support-responder
- customer-success-manager
- workflow-optimizer
- sprint-prioritizer
- experiment-tracker
- knowledge-base-curator
- tool-evaluator
- changelog-writer

### CINO Office

**Lead Agent:** innovation-researcher  
**Scope:** R&D, emerging tech, horizon scanning, proof-of-concepts  
**When to use:** Technology evaluation, innovation strategy, emerging tech assessment

**Agents in this office:**
- innovation-researcher (lead)
- rd-coordinator

### Executive Router

**Lead Agent:** executive-router  
**Scope:** Task classification and routing  
**When to use:** You don't know which office to ask. router classifies intent and routes automatically

---

## Configuration Reference

### config/project-manifest.json

**Purpose:** Project identity, compliance scope, tech stack. REQUIRED for every project.

**Key Fields:**

```json
{
  "project": {
    "id": "my-saas-app",                    // Unique identifier (slugified, no spaces)
    "name": "My SaaS App",                  // Display name
    "owner": "github-username",             // Your GitHub username
    "vertical": "SaaS | AI | FinTech | etc", // Business vertical
    "description": "...",                   // One sentence (include market geography)
    "stage": "idea|early-stage|active|scaling|mature", // Current stage
    "active": true                          // Is this project active?
  },

  "compliance": {
    "frameworks": ["GDPR", "SOC2"],         // All frameworks this project needs
    "per_project": {
      "my-saas-app": ["GDPR", "SOC2"]       // Must match project.id exactly
    },
    "regulated_projects": ["my-saas-app"],  // If regulated
    "payment_projects": [],                 // If handling payments (PCI-DSS)
    "hipaa_projects": []                    // If handling health data
  },

  "tech_stack": {
    "default_model_provider": "anthropic",  // Primary AI provider
    "preferred_models": {
      "reasoning": "claude-sonnet",         // For complex reasoning
      "code": "claude-sonnet",              // For code generation
      "fast": "claude-haiku",               // For quick operations
      "vision": "claude-sonnet"             // For image analysis
    }
  },

  "super_user": {
    "enabled": false,                       // Set true to suppress Maxim governance gates
    "identity": "",                         // Your name if super_user enabled
    "bypass": {
      "cso_auto_loop": false,               // Skip security auto-notification
      "ethics_gate": false,                 // Skip ethics pre-check
      "compliance_pre_check": false,        // Skip compliance enforcement
      "confidence_tagging": false,          // Skip output confidence tags
      "escalation_required": false          // Skip escalation protocol
    }
  }
}
```

### CLAUDE.project.md

**Purpose:** Project-specific overrides, brand voice, agent rules. OPTIONAL but recommended.

**Typical sections:**

1. **Active Projects:** table of all projects in your portfolio
2. **Project Bootstrap Mapping:** which template each project uses
3. **Project-Specific Agent Rules:** e.g., "All code must pass security review"
4. **Brand Voice:** tone, audience, messaging, what to avoid
5. **Session Memory Storage:** where files get written (already set by Maxim)

**Example:**
```markdown
## Brand Voice

- **Tone:** Precise, systems-thinking, never jargon-heavy
- **Audience:** Enterprise CTOs, compliance officers, regulators
- **Core Message:** Maxim is governed, multi-agent intelligence for enterprise
- **Avoid:** Consumer-grade language, vague claims, buzzwords without substance

## Project-Specific Agent Rules

### Regulated Projects (GDPR/HIPAA)
- All data access must be logged (who, what, when)
- Security Analyst review required before any PII handling
- Compliance check mandatory before code handoff

### Payment Projects (PCI-DSS)
- No card data in application layer (payment processor only)
- Security Analyst verifies PCI compliance on every payment task
```

### .mxm-skills/ Folder Structure

**Session and state files. auto-managed by Maxim, but you can inspect them:**

| File | Purpose | Auto-managed? |
|---|---|---|
| `session-[YYYY-MM-DD].md` | Daily session memory (decisions, tasks, skill gaps) | Yes |
| `handoff.md` | Inter-agent state transfer (BLOCKED/PARTIAL/SUCCESS) | Yes |
| `skill-gaps.log` | Log of unmet capability requests | Yes |
| `decision-log.md` | Audit trail of decisions made | Yes |

**Do not edit these files directly.** They're written by Maxim automatically.

### .claude-sessions-memory/ (if using Claude Code)

Same structure as `.mxm-skills/` but visible to your IDE. Contains:
- Handoff state
- Session summaries
- Decision logs
- Skill gap tracking

---

## Troubleshooting

### "Maxim commands not found"

**Problem:** Slash commands like `/mxm-plan` don't appear in Claude Code autocomplete

**Solution by install type:**

| Install Type | Fix |
|---|---|
| **Windows Global** | Did you run `install-global.ps1` as Administrator? Restart Claude Code. |
| **Subtree** | Run `bash .mxm-skills/bootstrap/new-project-setup.sh --patch-hooks-only` |
| **Mac/Linux** | Check that Claude Code has read permission to maxim folder: `ls -la maxim/` |

### "No config/project-manifest.json found"

**Problem:** `/mxm-status` shows missing manifest

**Solution:**

```powershell
# Windows:
.\bootstrap\link-local-project.ps1

# Mac/Linux:
bash bootstrap/new-project-setup.sh
```

Then verify:
```
/mxm-status
```

### Outputs tagged "🔴 Maxim-UNENHANCED"

**Problem:** Output is from external source without Maxim behavioral layer

**Reason:** No matching Maxim skill for your task. It's using raw external knowledge.

**Solution:**

1. Check `.mxm-skills/agents-skill-gaps.log` to see which domain was requested
2. This is a capability gap. you can:
   - Use the external output as-is (it's still valuable)
   - Request the feature in [Maxim GitHub Issues](https://github.com/DrNabeelKhan/maxim/issues)
   - Or file a skill gap report: See "Reporting Issues" below

### Compliance gates blocking my task

**Problem:** CSO auto-loop prevents code handoff for GDPR/HIPAA/SOC2 projects

**Reason:** Maxim's security-analyst is enforcing compliance pre-checks (this is intentional)

**Solution:**

1. **Review compliance requirements:** Check your `config/project-manifest.json` → `compliance.frameworks`
2. **Run compliance check first:** `/mxm-compliance`. identify what's missing
3. **Address gaps:** Usually a data-handling policy or security review
4. **Resubmit:** After gap closure, CSO auto-loop will clear

**If you need to bypass** (for testing/dev only):
```json
// In config/project-manifest.json
"super_user": {
  "enabled": true,
  "identity": "your-name",
  "bypass": { "cso_auto_loop": true, .. }
}
```

**Note:** Super user mode suppresses Maxim governance gates only. Claude's own values layer is not affected.

### Session state lost between sessions

**Problem:** `/mxm-status` shows "Active task: none" but you left a task mid-way

**Reason:** Session memory not saved. Check handoff state.

**Solution:**

```
/mxm-status
```

Look for:
- `.mxm-skills/agents-handoff.md`. should contain your last BLOCKED/PARTIAL/SUCCESS state
- `.mxm-skills/agents-session-[YYYY-MM-DD].md`. should have yesterday's summary
- `task_plan.md`. should have your plan from last session

If missing:
1. Check that you ran `/mxm-release` or task completed properly
2. If using Claude Code: `.claude-sessions-memory/handoff.md` should also exist

---

## Updating Maxim

### Quick Update (Global Symlink Users)

```powershell
cd maxim
git pull
# All projects using global symlinks are now updated automatically
```

Agents, skills, and commands auto-update instantly. no per-project action needed.

### Per-Project Migration

For existing projects bootstrapped with older Maxim versions, run the migration tool:

**Windows (PowerShell):**
```powershell
.\bootstrap\update-maxim.ps1
```

**Mac / Linux:**
```bash
bash bootstrap/update-maxim.sh
```

**From Claude Code:**
```
/mxm-update
```

The migration tool:
- Scans for existing projects (or accepts paths manually)
- Reads ALL existing data before changing anything
- Adds missing manifest fields with `[TBD]` placeholders
- Creates missing files (`.claude-sessions-memory/`, `.mxm-skills/` state files)
- Merges duplicate planning files to canonical locations
- Never overwrites your existing data
- Backs up `project-manifest.json` and `CLAUDE.project.md` before changes

**Version migration notes:**
- **v1.0.0 → v1.0.0:** Adds `super_user`, `tech_stack` depth, expanded domains, `development` settings, documents registry, `.claude-sessions-memory/` folder structure
- **v1.0.0 → v1.0.0:** Adds session-memory skill domain, 2 new commands (`/mxm-help`, `/mxm-context`), mandatory cross-session persistence, Cowork plugin

### Subtree Install

```bash
git subtree pull --prefix=.mxm-skills \
  https://github.com/DrNabeelKhan/maxim.git main --squash

bash .mxm-skills/bootstrap/new-project-setup.sh --patch-hooks-only
```

### Verify After Any Update

```
/mxm-status
```

Expected output:
```
Manifest     : ✅ loaded
CLAUDE.project.md : ✅ loaded
[no errors]
```

---

## Plugins & Memory Junction

### Cowork Plugin

Maxim ships as a Cowork plugin in `plugins/mxm-cowork/`. To use it in Claude Cowork sessions, point Cowork at the plugin directory when starting a session.

### Memory Junction (recommended for all projects)

Claude stores memory in `$HOME/.claude/projects/{key}/memory/`. By default this is a hidden folder you never see. Maxim can create a **junction** so memory lives inside your project at `.claude-sessions-memory/`. visible, version-controllable, portable.

**Set up memory junction per project:**
```powershell
# Windows / Mac / Linux (PowerShell 7+)
pwsh bootstrap/link-memory-junction.ps1 -ProjectPath "E:\Projects\YourProject"
```

**Bulk-convert all existing Claude projects:**
```powershell
pwsh bootstrap/link-memory-junction.ps1 -BulkConvert
```

**What it does:** Creates `.claude-sessions-memory/` in your project → creates junction from Claude's memory dir → Claude reads/writes transparently through the junction.

**Auto-heal:** CLAUDE.md includes a Memory Junction Auto-Heal rule. Claude checks and repairs the junction at every session start, even if you forget to run the script.

### Installing Maxim for Team Members (Private Repo)

1. **Add collaborators:** Go to `github.com/DrNabeelKhan/maxim/settings/access` → Add people → Read access
2. **They clone and install:**
   ```powershell
   git clone https://github.com/DrNabeelKhan/maxim.git
   cd maxim
   .\bootstrap\install-global.ps1          # Windows (Administrator)
   .\bootstrap\link-local-project.ps1      # per project (interactive wizard)
   pwsh bootstrap/link-memory-junction.ps1 -ProjectPath "path"  # memory junction
   ```
3. **Verify:** `/mxm-status` then `/mxm-help`

---

## Getting Help

### Quick Links

| Need | Go To |
|---|---|
| **Full install guide** | [documents/guides/GETTING_STARTED.md](documents/guides/GETTING_STARTED.md) |
| **All slash commands** | [documents/reference/MXM_COMMAND_MAP.md](documents/reference/MXM_COMMAND_MAP.md) |
| **Skill domain details** | [documents/reference/SKILLS_MAP.md](documents/reference/SKILLS_MAP.md) |
| **Behavioral frameworks** | [documents/reference/FRAMEWORKS_MASTER.md](documents/reference/FRAMEWORKS_MASTER.md) |
| **Agent catalog** | [config/agent-registry.json](config/agent-registry.json) |
| **Governance layer** | [documents/governance/ETHICAL_GUIDELINES.md](documents/governance/ETHICAL_GUIDELINES.md) |
| **Universal rules** | [CLAUDE.md](CLAUDE.md) |

### Reporting Issues

Found a bug or want to request a feature?

```
https://github.com/DrNabeelKhan/maxim/issues/new
```

Include:
- What you tried
- What happened vs. what you expected
- Your install type (Windows Global / Subtree / Other)
- Output of `/mxm-status`
- Relevant `.mxm-skills/agents-skill-gaps.log` entries

---

## Footer

**Maxim v1.0.0:** Behavioral Intelligence Architecture for Enterprise AI

- **Agents:** 90+ specialists across 7 executive offices
- **Skills:** 34 domains with 79 behavioral frameworks
- **Commands:** 37 slash commands for every phase of work
- **Governance:** Ethics gates, CSO auto-loop, compliance pre-enforcement, confidence tagging
- **Model Support:** Anthropic, OpenAI, Gemini, Mistral, local models

**Repository:** [github.com/DrNabeelKhan/maxim](https://github.com/DrNabeelKhan/maxim)  
**Maintainer:** [DrNabeelKhan](https://github.com/DrNabeelKhan)  
**License:** BSL 1.1 (4-year Apache 2.0 conversion per ADR-005); commercial packs separately licensed via LemonSqueezy

Last updated: 2026-04-20
