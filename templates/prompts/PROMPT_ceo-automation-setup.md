# CEO Automation Setup

> **Usage:** Paste this into Claude Code when setting up CEO automation for a project.
> Replace `[PROJECT_PATH]` and `[PROJECT_NAME]`.
> Choose template size: FULL (30 files, for primary startups) or MINIMAL (8 files, for active projects).
>
> **Prerequisites:** Project must be Maxim-bootstrapped (config/project-manifest.json exists).

---

## Prompt

Set up CEO automation for **[PROJECT_NAME]** at `[PROJECT_PATH]`.

### Step 1 — Verify prerequisites

1. Check `[PROJECT_PATH]/config/project-manifest.json` exists — if not, run `/mxm-new-project` first
2. Check `[PROJECT_PATH]/.mxm-executive-summary/` — if it already exists, read CONTEXT.md and report current state instead of overwriting

### Step 2 — Choose template

**FULL template** (for primary startups — mxm-simplification, FixIt, DrivingTutors):
Creates `.mxm-executive-summary/` with 30 files including CONTEXT.md, OKRs.md, METRICS.md, TEAM.md, CRM-notes.md, RUNWAY.md, PRODUCT.md, COMPETITORS.md, BRAND-VOICE.md, SPRINT.md, BACKLOG.md, BLOCKERS.md, VALUES.md, LAUNCH-PLAN.md, USER-FEEDBACK.md, and more.

**MINIMAL template** (for active projects that need basic CEO visibility):
Creates `.mxm-executive-summary/` with 8 files: CONTEXT.md, METRICS.md, SPRINT.md, BACKLOG.md, CRM-notes.md, OKRs.md, WINS.md, BRAND-VOICE.md.

### Step 3 — Create directory structure

Read templates from `E:\Projects\Maxim\maxim\templates\ceo-automation\`.

```
[PROJECT_PATH]/.mxm-executive-summary/
├── CONTEXT.md              ← project context (MUST be filled in by user)
├── OKRs.md                 ← objectives and key results
├── METRICS.md              ← key numbers dashboard
├── SPRINT.md               ← current sprint state
├── BACKLOG.md              ← prioritized backlog
├── CRM-notes.md            ← customer/deal pipeline
├── WINS.md                 ← achievements log
├── BRAND-VOICE.md          ← brand voice guidelines
├── [FULL only] TEAM.md, RUNWAY.md, PRODUCT.md, COMPETITORS.md, etc.
├── .research/              ← background research files
├── sessions/
│   ├── tasks.md            ← queued CEO tasks
│   └── progress.md         ← session progress tracking
└── logs/
    ├── morning-YYYY-MM-DD.md   ← morning cycle outputs
    └── overnight-YYYY-MM-DD.md ← overnight cycle outputs
```

### Step 4 — Seed templates with project data

Read `config/project-manifest.json` and substitute:
- `[PROJECT_NAME]` → project.name from manifest
- `[DATE]` → today's date
- `[COMPLIANCE]` → compliance.frameworks from manifest
- `[VERTICAL]` → project.vertical from manifest

### Step 5 — Set up scheduled tasks (optional)

Ask: "Do you want to schedule morning and overnight CEO cycles?"

If yes:
- **Morning cycle** (6:00 AM weekdays): reads METRICS, RUNWAY, TEAM, CRM → produces 5-bullet daily digest
- **Overnight cycle** (2:00 AM weekdays): reads OKRs, COMPETITORS, BACKLOG → produces strategy check + weekly plan

Create scheduled tasks:
```
Task ID: ceo-morning-[PROJECT_ID]
Cron: 0 6 * * 1-5
Prompt: Read [PROJECT_PATH]/.mxm-executive-summary/CONTEXT.md and run /mxm-ceo-morning cycle.
         Save output to [PROJECT_PATH]/.mxm-executive-summary/logs/morning-YYYY-MM-DD.md.
         Then call mxm-portfolio.sync_portfolio to update global context.

Task ID: ceo-overnight-[PROJECT_ID]
Cron: 0 2 * * 1-5
Prompt: Read [PROJECT_PATH]/.mxm-executive-summary/CONTEXT.md and run /mxm-ceo-overnight cycle.
         Save output to [PROJECT_PATH]/.mxm-executive-summary/logs/overnight-YYYY-MM-DD.md.
         Then call mxm-portfolio.sync_portfolio to update global context.
```

### Step 6 — Update global context

Call `mxm-portfolio.sync_portfolio` to ensure the project appears in `.mxm-global/PORTFOLIO-METRICS.md`.

### Step 7 — Report

```
CEO AUTOMATION SETUP: [PROJECT_NAME]
  Template: [FULL/MINIMAL]
  Files created: [count]
  Scheduled tasks: [morning + overnight / none]
  CONTEXT.md: REQUIRES USER INPUT — fill in startup context, metrics, team info
  Next: Fill in CONTEXT.md, then run /mxm-ceo-morning to test the first cycle
```

### Important Notes
- CEO automation READS local project files and UPDATES global context (one-way: project → global)
- CONTEXT.md is the single most important file — it must be filled in by the user with real data
- Morning/overnight cycles produce logs in `.mxm-executive-summary/logs/` — these are the CEO's daily intelligence
- The review queue (Task 0 in morning cycle) surfaces synthesized skills and gap fixes for sprint triage
