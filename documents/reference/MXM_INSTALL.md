# Maxim Install Reference

One-page adopter reference. Global-first architecture — install once, every project benefits.

---

## Architecture Overview

```
GLOBAL LAYER  %USERPROFILE%\.claude\          (set up once via install-global.ps1)
├── CLAUDE.md                 Universal dispatch rules — every session loads this
├── agents\                   All 90 Maxim agents
├── skills\                   All 20 Maxim domain skills
└── commands\                 All slash commands (/mxm-plan, /mxm-status, etc.)

PER-PROJECT LAYER  YourProject\               (run link-local-project.ps1 per project)
├── config\
│   ├── project-manifest.json    ← fill in once — Maxim reads at runtime
│   └── agent-registry.json      ← local copy for /mxm-status
├── CLAUDE.project.md            ← brand voice, compliance rules, agent overrides
├── .claude.local\
│   └── settings.local.json      ← project-scoped Read() permission (auto-generated)
├── .mxm\                       ← runtime state (skill-gaps, handoff, background logs)
├── .claude-sessions-memory\     ← session memory storage (not committed to git)
│   ├── handoff.md               ← resume context across sessions
│   ├── decision-log.md          ← architecture decisions log
│   └── skill-gaps.log           ← session skill tracking
└── .gitignore                   ← auto-generated; excludes .claude-sessions-memory/
```

---

## Install (Windows — Recommended)

### Step 1 — Clone Maxim once

```powershell
cd E:\Projects\
mkdir Maxim && cd Maxim
git clone https://github.com/DrNabeelKhan/maxim.git
cd maxim
```

### Step 2 — Global install (run once as Administrator)

```powershell
.\bootstrap\install-global.ps1
```

Creates four symlinks in `%USERPROFILE%\.claude\` pointing to your local clone.  
Every Claude Code session from any project now loads Maxim automatically.

> ✅ Done once. Never repeat unless you reinstall or change machines.

### Step 3 — Bootstrap each new project (as Administrator)

**Option A — PowerShell (recommended):**
```powershell
.\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\YourProject" -ProjectName "Your Project"
```

**Option B — Claude Code or CLI (no PowerShell required):**
```
/mxm-new-project
```
Maxim asks 6 questions, confirms, and creates all 11 files + `.claude-sessions-memory\` automatically.

### Step 4 — Configure

Open `config\project-manifest.json` — fill in all `REQUIRED` fields.  
Open `CLAUDE.project.md` — fill in brand voice and compliance scope.

### Step 5 — Verify

```
/mxm-status
```

Expected output:
```
Install Mode: GLOBAL
🟢 HIGH · Maxim behavioral layer fully active
```

---

## Per-Project Files Created

| File | Created by | Action needed |
|---|---|---|
| `config/project-manifest.json` | Bootstrap | Fill in ALL REQUIRED fields |
| `config/agent-registry.json` | Bootstrap | None — ready to use |
| `CLAUDE.project.md` | Bootstrap (from TEMPLATE) | Fill in brand voice + rules |
| `.claude.local/settings.local.json` | Bootstrap | None — auto-generated |
| `.mxm-skills/agents-skill-gaps.log` | Bootstrap | Runtime auto-write |
| `.mxm-skills/agents-background.log` | Bootstrap | Runtime auto-write |
| `.mxm-skills/agents-handoff.md` | Bootstrap | Runtime auto-write |
| `.claude-sessions-memory/handoff.md` | Bootstrap | Session auto-write |
| `.claude-sessions-memory/decision-log.md` | Bootstrap | Session auto-write |
| `.claude-sessions-memory/skill-gaps.log` | Bootstrap | Session auto-write |
| `.gitignore` | Bootstrap | None — `.claude-sessions-memory/` excluded |

---

## Updating Maxim

```powershell
cd E:\Projects\Maxim\maxim
git pull
# Done — all projects updated instantly via symlinks
```

Your `config/project-manifest.json` and `CLAUDE.project.md` are **never overwritten** — they live in your project, not in the Maxim clone.

### Per-Project Migration

If your project was bootstrapped with an older Maxim version:

```powershell
# Windows
.\bootstrap\update-maxim.ps1

# Mac/Linux  
bash bootstrap/update-maxim.sh

# From Claude Code
/mxm-update
```

The update tool preserves all existing data and only adds missing fields and files.

---

## Per-IDE Activation

| IDE | Activation | Slash Commands | Sub-Agents |
|---|---|---|---|
| Claude Code | Automatic on folder open | ✅ from `%USERPROFILE%\.claude\commands\` | ✅ from `%USERPROFILE%\.claude\agents\` |
| Cursor | Run bootstrap `--patch-hooks-only` | `.cursorrules` injected | Via rules |
| Gemini | Run bootstrap `--patch-hooks-only` | `GEMINI.md` at root | Via GEMINI.md |
| Copilot | Run bootstrap `--patch-hooks-only` | `copilot-instructions.md` | Via instructions |
| Antigravity | Run bootstrap `--patch-hooks-only` | `.antigravity/` patched | Via config |

To activate non-Claude IDEs:
```bash
bash .mxm-skills/bootstrap/new-project-setup.sh --patch-hooks-only
```

---

## Alternative: Subtree Install (Linux / CI / Non-Windows)

If you cannot use the global install:

```bash
git subtree add --prefix=.mxm-skills \
  https://github.com/DrNabeelKhan/maxim.git main --squash

cp .mxm-skills/CLAUDE.md CLAUDE.md
cp -r .mxm-skills/.claude .claude
cp .mxm-skills/config/project-manifest.TEMPLATE.json config/project-manifest.json
cp .mxm-skills/config/agent-registry.json config/agent-registry.json

bash .mxm-skills/bootstrap/new-project-setup.sh
```

> ⚠️ **SECURITY: Never embed tokens in `.gitmodules` in a public repo.**  
> Use `git subtree` or the Windows global install instead.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Slash commands not appearing | Confirm `%USERPROFILE%\.claude\commands\` exists — re-run `install-global.ps1` |
| Agent outputs wrong project name | Check `project.id` in `config/project-manifest.json` matches your project slug |
| CSO auto-loop not firing | Verify `security-analyst` active in registry — run `/mxm-status` |
| Compliance gate not enforcing | Add project ID to `compliance.regulated_projects[]` in `project-manifest.json` |
| Session context lost between sessions | Check `.claude-sessions-memory/handoff.md` — Maxim writes resume context here |
| IDE session starts with no Maxim context | Re-run `install-global.ps1 -Force` or `new-project-setup.sh --patch-hooks-only` |
| New project has iSimplification.io data | Ensure `link-local-project.ps1` is v2.1.0+ — copies from `documents/templates/CLAUDE.project.TEMPLATE.md` |