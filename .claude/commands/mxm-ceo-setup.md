# /mxm-ceo-setup

## Usage
- Claude Code: `/mxm-ceo-setup`
- Claude CLI: `claude "/mxm-ceo-setup"`
- Claude Desktop: type `/mxm-ceo-setup` in chat

Sets up the CEO Automation intelligence layer for a startup project. Creates `.mxm-executive-summary/` with 30 template files, session continuity, and optional cross-portfolio folder.

**Prerequisite:** Project must already have Maxim bootstrapped (`config/project-manifest.json` exists). If not, suggest running `/mxm-new-project` or `link-local-project.ps1` first.

**Template source:** `templates/ceo-automation/` in the Maxim repo root. Locate via:
- Global install: resolve `%USERPROFILE%\.claude\CLAUDE.md` symlink target → parent is Maxim repo root
- Legacy install: `.mxm-skills/templates/ceo-automation/`
- Direct: read from the maxim clone path

## Behavior

### Step 1 — Gather inputs (ask user, do NOT assume)

1. **Target project path** — Ask: "Which project folder?" Default: current working directory.
2. **Verify Maxim bootstrapped** — Check `config/project-manifest.json` exists at target path. If missing, STOP and say: "This project is not bootstrapped with Maxim yet. Run `/mxm-new-project` or `link-local-project.ps1` first."
3. **Read project identity** — Read `config/project-manifest.json` for:
   - `project.name` → used to replace `[PROJECT_NAME]` in all templates
   - `project.id` → used for compliance lookup
   - `project.vertical` → displayed in summary
   - `project.stage` → substituted into CONTEXT.md
   - `project.description` → substituted into CONTEXT.md one-line description
   - `project.owner` → substituted into TEAM.md
   - `compliance.per_project[project.id]` → populates compliance sections in RUNWAY.md, CRM-notes.md, METRICS.md, SRD.md
4. **Template set** — Ask: "Full (30 files) or Minimal (8 core files)?"
   - **Minimal (8):** CONTEXT, ICP, PRODUCT, METRICS, CRM-notes, WINS, BRAND-VOICE, OKRs
   - **Full (30):** All files including research, sessions, analytics, social stats
5. **Cross-portfolio** — Ask: "Is this the first startup in your portfolio? (Creates `.mxm-global/` at parent directory)"
6. **Scheduled tasks** — Ask: "Set up automated CEO cycles? (morning/overnight/both/skip)"

### Step 2 — Confirm before creating

Display a summary:
```
CEO Automation Setup
  Project:    [project.name]
  ID:         [project.id]
  Vertical:   [project.vertical]
  Compliance: [frameworks from manifest]
  Path:       [target path]
  Template:   Full (30 files) / Minimal (8 files)
  Global:     Yes / No
  Schedules:  morning + overnight / skip

Proceed? (y/n)
```

### Step 3 — Create folder structure

```
.mxm-executive-summary/
├── .research/
│   ├── market-research/
│   ├── business-model/
│   ├── customer-research/
│   │   ├── contracts/
│   │   └── interviews/
│   └── system-design/
│       └── ADRs/
├── sessions/
└── logs/
```

### Step 4 — Seed template files

**Source:** Read each template from `templates/ceo-automation/` in the Maxim repo.

**Substitutions (apply to EVERY template file):**
- `[PROJECT_NAME]` → `project.name` from manifest
- `[DATE]` → today's date (YYYY-MM-DD)
- `[TBD]` → leave as-is (user fills in later)

**Pre-fill from manifest (where data exists):**
- `CONTEXT.md` → `## One-Line Description` from `project.description`
- `CONTEXT.md` → `## Stage` from `project.stage`
- `TEAM.md` → first row: `project.owner` as founder
- `sessions/CLAUDE.md` → compliance section auto-populated from `compliance.per_project`

**Compliance-aware files** (read `compliance.per_project[project.id]` from manifest):
- If project has GDPR/PIPEDA → add comment in CRM-notes.md: `<!-- COMPLIANCE: GDPR/PIPEDA — PII handling rules apply to all customer data -->`
- If project has PCI-DSS → add comment in METRICS.md: `<!-- COMPLIANCE: PCI-DSS — payment metrics subject to PCI scope -->`
- If project has HIPAA → add comment in USER-FEEDBACK.md: `<!-- COMPLIANCE: HIPAA — PHI must be de-identified in feedback logs -->`

**Example of a properly filled CONTEXT.md** (show this to user as a guide):
```
# CONTEXT — Maxim Platform Master Summary

## One-Line Description
Multi-tenant Agentic RAG Intelligence Architecture — a conversational
commerce intelligence platform for SMBs and mid-market businesses.

## Stage
phase-0

## Founded
2026-03-01

## Mission
Every customer conversation is intelligence waiting to be captured.

## Current Status
- MRR: $0 (pre-revenue)
- Users: 0 (pre-launch)
- Team size: 1
- Runway: 12 months
- Last milestone: Architecture v7 complete

## Top 3 Priorities
1. Complete Phase 0 foundation (schema, auth, Docker, RLS)
2. Build 12-step intelligence pipeline
3. Ship MVP to first 3 beta customers
```

### Step 5 — Create `.mxm-global/` if first startup

At the PARENT directory of the project path, create:
```
.mxm-global/
├── GLOBAL-CONTEXT.md      ← from templates/ceo-automation/global/
├── INVESTOR-PROFILE.md    ← from templates/ceo-automation/global/
├── PORTFOLIO-METRICS.md   ← from templates/ceo-automation/global/
└── logs/
```
Substitute `[PROJECT_NAME]` with the founder/portfolio name.

### Step 6 — Update .gitignore

Append to the project's `.gitignore` (check if already present before appending):
```
# CEO Automation — session data (not committed)
.mxm-executive-summary/logs/
.mxm-executive-summary/sessions/progress.md
.mxm-executive-summary/sessions/tasks.md
```

### Step 7 — Create scheduled tasks (if requested)

Use Claude's scheduled task system to create:
- **Morning cycle** (weekdays 6 AM): metrics digest, burn rate alert, pipeline digest, customer health scan
  - Task ID: `ceo-morning-{project.id}`
  - Cron: `0 6 * * 1-5`
- **Overnight cycle** (weekdays 2 AM): strategy check, competitive audit, growth report, content drafts
  - Task ID: `ceo-overnight-{project.id}`
  - Cron: `0 2 * * 1-5`

### Step 8 — MemPalace mining (optional)

Ask: "Mine this project into MemPalace for semantic memory? (y/n)"

If YES and MemPalace MCP is connected:
1. Run `mempalace init --yes {project_path}`
2. Run `mempalace mine {project_path}`
3. Report: "MemPalace: [N] files mined, [N] embeddings created"

If YES but MemPalace not installed:
- Say: "MemPalace not installed. See `.claude/skills/memory-palace/SKILL.md` for setup instructions."

If NO: skip silently.

**Important:** Never mine automatically. Mining is resource-intensive and the user should confirm their project folder is clean and organized before mining.

### Step 9 — Output completion

```
CEO Automation Setup Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project:     [project.name]
  Files:       [count] created in .mxm-executive-summary/
  Global:      [yes/no — path if yes]
  Schedules:   [created/skipped]
  Compliance:  [frameworks auto-populated in templates]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:
  1. Fill in .mxm-executive-summary/CONTEXT.md
     (most important — every prompt reads it first)
  2. Fill in BRAND-VOICE.md and ICP.md
     (unlocks 80% of all 160+ prompts)
  3. Run /ceo-morning for your first automated cycle
  4. Run /ceo to access the full CEO office with startup intelligence

Minimum viable set (fill these 8 to unlock 80% of prompts):
  CONTEXT.md · ICP.md · PRODUCT.md · METRICS.md
  CRM-notes.md · WINS.md · BRAND-VOICE.md · OKRs.md

Full prompt library: ceo-automation-prompts.md (2,441 lines, 160+ prompts)
Skill reference: .claude/skills/ceo-automation/Maxim-WRAPPER.md
```

### Tag output: `HIGH`
