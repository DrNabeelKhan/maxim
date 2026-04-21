# /mxm-new-project

## Usage
- Claude Code: `/mxm-new-project`
- Claude CLI: `claude "/mxm-new-project"`
- Claude Desktop: type `/mxm-new-project` in chat

Interactive project scaffold. Creates a new project folder with all Maxim per-project
files, placeholder templates, and `.claude-sessions-memory/` session storage.
Works from Claude Code Desktop chat or CLI — no PowerShell required.

**Triggers:** "new project", "create project", "scaffold project", "maxim new project",
              "set up new project", "bootstrap project"
**Requires:** Maxim globally installed (`%USERPROFILE%\.claude\CLAUDE.md` exists)

---

## Behavior

### Step 1 — Gather inputs (ask the user, do NOT assume)

Ask these questions **one at a time** in sequence. Wait for each answer before asking the next:

1. **Project folder name**
   ```
   What should the project folder be named?
   (e.g. fixit-leads, drivingtutors-ca, gulflaw-ai)
   ```

2. **Parent location**
   ```
   Where should the folder be created?
   (e.g. E:\Projects  or  ~/projects  — press Enter for current directory)
   ```

3. **Project display name**
   ```
   What is the full project name?
   (e.g. FixIt Leads Platform)
   ```

4. **Vertical**
   ```
   What vertical is this project?
   SaaS | AI | FinTech | HealthTech | LegalTech | EdTech | Other
   ```

5. **Compliance markets**
   ```
   Which markets does this project target? (select all that apply)
   CA (PIPEDA)  |  US (TCPA)  |  EU (GDPR)  |  UAE/Gulf (UAE-PDPL)
   Payments (PCI-DSS)  |  Health (HIPAA)  |  Enterprise (SOC2)  |  None yet
   ```

6. **Stage**
   ```
   What stage is this project?
   idea | early-stage | active | scaling | mature
   ```

---

### Step 2 — Confirm before creating

Output a summary and ask for confirmation:

```
┌─────────────────────────────────────────────────────┐
│  Maxim New Project — Confirm                         │
├─────────────────────────────────────────────────────┤
│  Folder     : {parent}/{folder-name}/               │
│  Name       : {display-name}                        │
│  Vertical   : {vertical}                            │
│  Compliance : {frameworks}                          │
│  Stage      : {stage}                               │
│                                                     │
│  Will create 19 files + 7 folders.                  │
│  Proceed? (yes / no)                                │
└─────────────────────────────────────────────────────┘
```

---

### Step 3 — Create folder structure

Create the following directories inside `{parent}/{folder-name}/`:

```
{folder-name}/
├── config/
├── documents/
│   ├── ADRs/                      ← Architecture Decision Records (gitignored, private ledger)
│   │   ├── INDEX.md               ← auto-created: empty ADR index
│   │   └── TEMPLATE.md            ← auto-created: ADR template
│   ├── architecture/              ← PRD, FRD, SRD, ARCHITECTURE.md (gitignored)
│   │   └── .secrets/              ← build intakes, API keys, credentials (gitignored)
│   └── business/                  ← investor narrative, financial models (gitignored)
├── prototypes/                    ← v0 demos, POCs, throwaway builds
├── .mxm-skills/
├── .mxm-operator-profile/
└── .claude-sessions-memory/
```

**`documents/ADRs/` is the canonical location Maxim uses for every new project's ADR ledger.** The folder is created on bootstrap, seeded with a placeholder `INDEX.md` and `TEMPLATE.md`, and is gitignored by default — ADRs are an operator-local private ledger until explicitly published.

Seed `documents/architecture/` with templates from `templates/project-scaffold/documents/architecture/` (ARCHITECTURE.md, PRD.md, FRD.md, SRD.md, README.md).

---

### Step 4 — Seed all 15 files

Create each file with the content specified. Substitute user inputs where shown.

#### 4a — `config/project-manifest.json`
Copy content from Maxim source `config/project-manifest.TEMPLATE.json` and replace:
- `"your-project-id"` → `"{folder-name}"`
- `"Your Project Name"` → `"{display-name}"`
- `"your-github-username"` → read from `config/project-manifest.json` at Maxim root if available, else leave placeholder
- `"vertical"` → `"{vertical}"`
- `"stage"` → `"{stage}"`
- `compliance.frameworks[]` → array of selected framework strings
- `"YYYY-MM-DD"` (last_updated) → today's date

#### 4b — `config/agent-registry.json`
Copy from Maxim source `config/agent-registry.json` unchanged.

#### 4c — `CLAUDE.project.md`
Copy content from Maxim source `documents/templates/CLAUDE.project.TEMPLATE.md` and replace:
- `<!-- REQUIRED: Your project name -->` → `{display-name}`
- `your-project-id` → `{folder-name}`
- `Your Project Name` → `{display-name}`
- `SaaS | AI | FinTech...` → `{vertical}`
- `PIPEDA | GDPR...` → selected compliance frameworks (comma-separated)
- `<!-- REQUIRED: YYYY-MM-DD -->` → today's date

#### 4d — `.claude.local/settings.local.json`
```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(node -e \":*)",
      "Bash(python3 -c \":*)",
      "Read({full-project-path}/**)"
    ]
  }
}
```
Replace `{full-project-path}` with the resolved absolute path using forward slashes.

#### 4e — `.mxm-skills/agents-skill-gaps.log`
```
# Maxim Skill Gaps Log — {display-name}
# Format: [ISO-TIMESTAMP] [SKILL-GAP|Maxim-UNENHANCED] domain: message
# Review after every session. Entries here drive skill priority.
```

#### 4f — `.mxm-skills/agents-background.log`
```
# Maxim Background Agent Log — {display-name}
# Format: [ISO-TIMESTAMP] [BACKGROUND-AGENT|BACKGROUND-FAIL] message
```

#### 4g — `.mxm-skills/agents-handoff.md`
```
# Maxim Agent Handoff — {display-name}
# Written by orchestrators during multi-agent task chains.
# This file is runtime-only — do not commit.
```

#### 4h — `.claude-sessions-memory/handoff.md`
```
# Session Handoff — {display-name}
# Last updated: {today}
# Use this file to resume context across Claude Code sessions.

## Last Session Summary
<!-- Claude Code writes here automatically at session end -->

## Open Tasks
<!-- Incomplete items from last session -->

## Key Decisions Made
<!-- Architecture or product decisions logged here -->

## Next Session Start Point
<!-- What to load and run first next session -->
```

#### 4i — `.claude-sessions-memory/decision-log.md`
```
# Decision Log — {display-name}
# Format: [DATE] [DECISION] rationale
# Append entries. Never delete.
```

#### 4j — `.claude-sessions-memory/skill-gaps.log`
```
# Session Skill Gaps — {display-name}
# Format: [ISO-TIMESTAMP] [SKILL-GAP|Maxim-UNENHANCED] domain: message
```

#### 4k — `.gitignore`
```
# ── Maxim Session Memory (not for version control) ──────────────────────────
.claude-sessions-memory/

# ── Maxim Operator Profile (personal, never commit) ─────────────────────────
.mxm-operator-profile/

# ── Maxim Runtime State ────────────────────────────────────────────────────
.mxm-skills/agents-handoff.md
.mxm-skills/agents-skill-gaps.log
.mxm-skills/agents-background.log

# ── Maxim Local Config ────────────────────────────────────────────────────
.claude.local/
config/project-manifest.local.json

# ── Architecture & secrets (project-specific, never commit) ──────────────
documents/architecture/

# ── MemPalace (local data, never commit) ─────────────────────────────────
config/mempalace.yaml
.mempalace/

# ── Generated ────────────────────────────────────────────────────────────
GEMINI.md
documents/reference/AGENTS.md
.github/copilot-instructions.md

# ── Common ───────────────────────────────────────────────────────────────
.env
.env.local
node_modules/
__pycache__/
*.pyc
.DS_Store
Thumbs.db
```

#### 4l — `.mxm-operator-profile/OPERATOR.md`
```
# Operator Profile
# Updated automatically at session end by Maxim behavioral-designer agent.
# Manual edits welcome — Maxim will preserve and build on them.

## Identity
<!-- Name, role, organization -->

## Working Style
<!-- How you prefer to work -->

## Output Preferences
<!-- Preferred response format -->

## Technical Context
<!-- Primary languages, frameworks, tools -->
```

#### 4m — `.mxm-operator-profile/preferences.md`
```
# Operator Preferences
# Append-only. Maxim adds entries as it learns your preferences.
```

#### 4n — `.mxm-operator-profile/rejected-patterns.md`
```
# Rejected Patterns
# Patterns you have corrected or rejected. Maxim will avoid these.
# NEVER delete entries — only add.
```

#### 4o — `.mxm-operator-profile/communication-style.md`
```
# Communication Style
# How you phrase requests, preferred response format, verbosity level.
```

---

### Step 5 — Output completion banner

```
✅  Maxim Project Created
────────────────────────────────────────────────────────
  Folder   : {full-project-path}/
  Files    : 15 files created
  Memory   : .claude-sessions-memory/ (session storage)
  Registry : config/agent-registry.json ✅
  Manifest : config/project-manifest.json ✅  ← fill in REQUIRED fields
  Project  : CLAUDE.project.md ✅             ← fill in brand voice + rules
  Gitignore: .gitignore ✅ (.claude-sessions-memory/ excluded)
────────────────────────────────────────────────────────
Next steps:
  1. Open {full-project-path}/ in Claude Code
  2. Run: /mxm-status
  3. Fill in CLAUDE.project.md brand voice section
  4. Fill in config/project-manifest.json REQUIRED fields
────────────────────────────────────────────────────────
```

---

### Step 6 — Validate

After creation, verify all 15 files exist. Report any missing as `❌ MISSING` with
a one-line fix command. If all present, output `🟢 HIGH — project scaffold complete`.
