# Getting Started with Maxim

> Add 88+ governed AI agents to your project in under 1 minute.

---

## Fastest Path — Claude Code Plugin (recommended)

```
/plugin install maxim@anthropic-official
```

That installs the full behavioral intelligence layer in a single command. 88+ agents across 7 executive offices, 34+ skill domains, 37+ slash commands, 3 governance hooks, 4 free drift monitors, the `mxm-mode` output style, and the `mxm-pack-engine` binary. Free tier is fully functional out of the box.

**Add commercial packs:**

```
/plugin marketplace add https://github.com/DrNabeelKhan/maxim
/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs
mxm-pack-engine activate --license <JWT-from-purchase-email>
```

Pricing at https://maxim.isystematic.com.

**Prerequisites for plugin install:**
- Claude Code 2.1 or later
- Windows users: install Git for Windows (https://git-scm.com/download/win) for POSIX shell support in background monitors. Mac and Linux have bash natively.

---

## Advanced Path — Manual Install

Use this path when you want to modify Maxim source, run dev versions, or integrate with a non-Claude-Code IDE (Cursor, Gemini, Copilot, Antigravity). The plugin path above is recommended for everything else.

### Prerequisites

| Requirement | Version |
|---|---|
| Git | ≥ 2.30 |
| Claude Code, Cursor, Gemini, Copilot, or Antigravity | Any AI IDE |
| Node.js (optional, for JSON validation) | Any LTS |
| PowerShell as Administrator (Windows) | Windows 10+ |

---

## Global Install vs Per-Project

Maxim uses a two-layer architecture. **Install globally once** — every project benefits automatically.

| Layer | Scope | Location | Managed by |
|---|---|---|---|
| Dispatch rules | All projects | `%USERPROFILE%\.claude\CLAUDE.md` | `install-global.ps1` |
| All 87 agents | All projects | `%USERPROFILE%\.claude\agents\` | `install-global.ps1` |
| All 22 skills | All projects | `%USERPROFILE%\.claude\skills\` | `install-global.ps1` |
| Slash commands | All projects | `%USERPROFILE%\.claude\commands\` | `install-global.ps1` |
| Project identity | Per project | `config\project-manifest.json` | You (fill in once) |
| Project rules | Per project | `CLAUDE.project.md` | You (fill in once) |
| Path permissions | Per project | `.claude.local\settings.local.json` | `link-local-project.ps1` |
| Runtime state | Per project | `.mxm\*` | Auto-created |

**To update Maxim for ALL projects at once:** `cd E:\Projects\Maxim\maxim && git pull`

No re-copy. No re-bootstrap. Symlinks reflect changes instantly.

---

## Step 1 — Clone Maxim Once

```powershell
cd E:\Projects\
mkdir Maxim
cd Maxim
git clone https://github.com/DrNabeelKhan/maxim.git
cd maxim
```

---

## Step 2 — Global Install (Run Once as Administrator)

Open PowerShell as Administrator:

```powershell
cd E:\Projects\Maxim\maxim
.\bootstrap\install-global.ps1
```

This creates four symlinks in `%USERPROFILE%\.claude\` pointing to your local `maxim` clone.
Every Claude Code session from any project folder now loads Maxim automatically.

> ✅ Done once. Never repeat unless you reinstall or change machines.

---

## Step 3 — Bootstrap Each New Project

For every new project (run as Administrator):

```powershell
.\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\YourProject" -ProjectName "Your Project"
```

This creates **only** project-specific files — no duplication of global assets:
- `config\project-manifest.json` ← fill in your project details
- `CLAUDE.project.md` ← fill in brand voice and compliance scope
- `.claude.local\settings.local.json` ← auto-generated with your project path
- `.mxm\` runtime folder + `.gitignore`

---

## Step 4 — Configure Your Project

Open `config\project-manifest.json` and complete **all** fields marked `// REQUIRED`.

### Config Checklist

- [ ] `project.id` — lowercase, hyphen-separated slug, no spaces (e.g. `my-app`)
- [ ] `project.name` — display name
- [ ] `project.vertical` — SaaS / AI / FinTech / HealthTech / LegalTech / EdTech
- [ ] `project.stage` — idea / early-stage / active / scaling / mature
- [ ] `project.description` — one sentence; include geography (CA / US / AU / EU)
- [ ] `compliance.frameworks[]` — declare ALL markets your project targets:
  - Canada → `PIPEDA`
  - United States → `TCPA`
  - Australia → `AU-Privacy-Act-1988`
  - Europe → `GDPR`
  - UAE / Gulf / MENA → `UAE-PDPL`
  - Payments → `PCI-DSS`
  - Health data → `HIPAA`
- [ ] `compliance.per_project` keys **exactly match** `project.id`
- [ ] `payment_projects[]` / `hipaa_projects[]` use the same `project.id`
- [ ] `maintainer` — your GitHub username
- [ ] `last_updated` — today’s date (YYYY-MM-DD)
- [ ] `next_review` — 30 days from today
- [ ] `MXM_version` — must match installed Maxim version (`6.2.0`)

Every agent reads this file at runtime — compliance gates, model provider, and project identity are set once and enforced everywhere.

---

## Step 5 — Verify

Open your project folder in Claude Code and run:

```
/mxm-status
```

Expected output:

```
Install Mode: GLOBAL
🟢 HIGH · Maxim behavioral layer fully active
```

If warnings appear, each one includes an → autofix command.

---

## Updating Maxim

```powershell
cd E:\Projects\Maxim\maxim
git pull
# Done — all projects updated instantly via symlinks
```

---

## Activate Per IDE

| IDE | What’s Needed | What’s Automatic |
|---|---|---|
| **Claude Code** | Global install done | Reads `CLAUDE.md` + agents + skills from `%USERPROFILE%\.claude` |
| **Cursor** | Run bootstrap | Maxim dispatch rules injected into Cursor rules |
| **Gemini** | Run bootstrap | `GEMINI.md` generated at project root |
| **Copilot** | Run bootstrap | `copilot-instructions.md` generated at project root |
| **Antigravity** | Run bootstrap | `.antigravity/` patched with Maxim overlay |

To activate all IDEs:

```bash
bash .mxm-skills/bootstrap/new-project-setup.sh --patch-hooks-only
```

---

## Alternative: Subtree Install (Linux / CI / Non-Windows)

If you cannot use the global install (CI/CD, Linux dev, shared environments):

```bash
# From inside your existing project repo:
git subtree add --prefix=.mxm-skills \
  https://github.com/DrNabeelKhan/maxim.git main --squash

# Copy per-project files to root
cp .mxm-skills/CLAUDE.md CLAUDE.md
cp -r .mxm-skills/.claude .claude
cp .mxm-skills/config/project-manifest.TEMPLATE.json config/project-manifest.json
cp .mxm-skills/config/agent-registry.json config/agent-registry.json

# Run interactive setup wizard
bash .mxm-skills/bootstrap/new-project-setup.sh
```

> ⚠️ **SECURITY: Never use `git submodule` with an embedded token.**
> `maxim` is a public repo — the clean URL requires no token:
> ```
> url = https://github.com/DrNabeelKhan/maxim
> ```
> Tokens embedded in `.gitmodules` in a public repo are immediately exposed.
> Use `git subtree` or the Windows global install instead.

---

## First Command

```
/mxm-route [describe your task]
```

`executive-router` classifies intent and routes to the correct office lead. The agent reads your `project-manifest.json`, applies the right skill domain and compliance scope, and tags the output with a confidence signal.

---

## Next Steps

| Document | Purpose |
|---|---|
| [`documents/reference/MXM_INSTALL.md`](documents/reference/MXM_INSTALL.md) | Full adopter reference — folder map, troubleshooting, update command |
| [`documents/reference/SKILLS_MAP.md`](documents/reference/SKILLS_MAP.md) | 22 skill domains — what each covers |
| [`documents/reference/FRAMEWORKS_MASTER.md`](documents/reference/FRAMEWORKS_MASTER.md) | 63 behavioral frameworks applied automatically |
| [`config/agent-registry.json`](config/agent-registry.json) | Full agent catalog |
| [`documents/governance/ETHICAL_GUIDELINES.md`](documents/governance/ETHICAL_GUIDELINES.md) | Governance layer and super_user mode |

---

## Upgrading from Older Versions

**Already using Maxim v1.0.0 or v1.0.0?** Run the update tool to bring per-project files current.

**Windows (PowerShell 7+):**
```powershell
cd E:\Projects\Maxim\maxim
git pull                              # update Maxim source
.\bootstrap\update-maxim.ps1          # update all projects
```

**Mac / Linux:**
```bash
cd ~/Projects/maxim
git pull
bash bootstrap/update-maxim.sh        # update all projects
```

**From Claude Code:**
```
/mxm-update
```

The update tool:
- Scans for existing projects (or accepts paths manually)
- Reads ALL existing data before changing anything
- Adds missing manifest fields with `[TBD]` placeholders
- Creates missing files (`.claude-sessions-memory/`, `.mxm-skills/` state files)
- Merges duplicate planning files to canonical locations
- Never overwrites your existing data
- Backs up manifest and CLAUDE.project.md before changes

After updating, run `/mxm-status` in each project to verify.

---

**Built by:** Dr. Nabeel Khan · iSimplification.io
**Version:** Maxim v1.0.0 · 87 agents · 22 skill domains
**Repo:** https://github.com/DrNabeelKhan/maxim
