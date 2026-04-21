# Maxim Surface Guide — Three-Tier Deployment

> **Maxim runs on five Claude surfaces with varying fidelity.**
> This guide maps what works where + how to install on each surface.

**Introduced:** v1.0.0 · **Source:** [maxim repo](https://github.com/yourorg/maxim) · **Governed by:** ADR-002 (Executable Contracts)

---

## TL;DR

| Surface | Fidelity | Install Artifact | Capability Gap |
|---|---|---|---|
| **Claude Code CLI** | 🟢 100% | Clone repo + follow `documents/reference/MXM_INSTALL.md` | None |
| **Claude Code IDE** (VS Code, JetBrains) | 🟢 100% | Clone repo + IDE extension | None |
| **Claude.ai Cowork** | 🟡 85% | `maxim.plugin` (see `packaging/cowork/`) | No hooks, no local file auto-read |
| **Claude Desktop** (Projects feature) | 🟠 60% | `documents/cross-surface/maxim-project-instructions.md` pasted into Project Instructions | No slash commands, no hooks, no MCP |
| **Claude.ai Web** (Projects feature) | 🟠 60% | Same as Desktop | Same as Desktop |

Fidelity measures how much of Maxim's behavioral layer + technical scaffolding transfers. **All surfaces preserve the moat (behavioral layer + office routing + confidence tagging + CSO auto-loop).** What varies is the automation around it.

---

## Capability Matrix

Green = native, Yellow = degraded, Red = absent.

| Capability | Code CLI | Code IDE | Cowork | Desktop | Web |
|---|---|---|---|---|---|
| **Behavioral layer** (Fogg, COM-B, EAST, Cialdini) | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 |
| **Office routing** (7 executive mental models) | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 |
| **Confidence tagging** (🟢🟡🔴🔵🔐) | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 |
| **CSO auto-loop** | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 |
| **Brand Foundation loading** | 🟢 auto | 🟢 auto | 🟡 manual upload | 🟡 manual upload | 🟡 manual upload |
| **Slash commands** (`/mxm-cmo`, `/mxm-watch`, etc.) | 🟢 | 🟢 | 🟡 some via plugin | 🔴 | 🔴 |
| **MCP servers** (behavioral, compliance, context, etc.) | 🟢 | 🟢 | 🟢 connectors | 🔴 | 🔴 |
| **Executable hooks** (SessionStart, PreCommit, Git Hygiene) | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| **Proactive Watch** (drift detection) | 🟢 | 🟢 | 🟡 manual trigger | 🔴 | 🔴 |
| **Auto file reads** (CLAUDE.md on session open) | 🟢 | 🟢 | 🟡 | 🔴 | 🔴 |
| **Session memory persistence** | 🟢 full | 🟢 full | 🟡 project-scoped | 🟡 conversation-scoped | 🟡 conversation-scoped |
| **Portfolio sync** across projects | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| **ADR enforcement** (contract-drift) | 🟢 via hooks | 🟢 via hooks | 🟡 via prompt | 🟡 via prompt | 🟡 via prompt |

---

## Tier 1 — Claude Code (CLI + IDE)

**Fidelity: 100%** — everything Maxim ships works here.

### What's native
- All executable hooks run (`.claude/hooks/`)
- All slash commands registered (`.claude/commands/`)
- All MCP servers auto-discovered (`.mcp.json`)
- All skills activated by triggers (`.claude/skills/`)
- CLAUDE.md + CLAUDE.d/ modules auto-loaded
- Session memory persists across conversations (`.claude-sessions-memory/`)
- Git Hygiene Gate hooks available
- Proactive Watch LIGHT runs at SessionStart

### Install

```bash
git clone https://github.com/yourorg/maxim
cd maxim

# Follow documents/reference/MXM_INSTALL.md — the canonical install path
# Optionally bootstrap a new Maxim-adopting project:
./bootstrap/new-project-setup.sh  # Linux/Mac
# or
.\bootstrap\link-local-project.ps1  # Windows
```

For existing projects adopting Maxim:
1. Copy `config/project-manifest.TEMPLATE.json` → your project's `config/project-manifest.json`
2. Fill in `project.id`, `compliance.frameworks`, `tech_stack`
3. Copy `documents/templates/CLAUDE.project.TEMPLATE.md` → your project's `CLAUDE.project.md`
4. Start a new session — Maxim activates

### When to use
- Daily development work
- Release shipping (`/mxm-release`, Git Hygiene Gate)
- Multi-project portfolio management
- Security-sensitive work (full CSO tooling)
- Long-running sessions with drift detection

---

## Tier 2 — Claude.ai Cowork

**Fidelity: 85%** — everything except hooks and auto-file-reading.

### What's native
- Plugin mechanism supports custom skills + connectors
- MCP servers (as connectors) are supported
- Slash commands partially supported (depends on plugin spec version)
- Project files uploaded manually can be read
- Conversations have project-scoped persistence

### What's degraded
- **No hooks.** SessionStart drift detection + PreCommit secret scanning don't run. You must manually run `/mxm-watch` equivalents.
- **No automatic file auto-loading** at session start (plugin can approximate this via skill activation logic).
- **Git Hygiene Gate** is advisory only (Cowork isn't doing git operations deterministically).

### Install

```
1. Download packaging/cowork/maxim.plugin from the maxim repo
2. Open Claude.ai Cowork → Settings → Plugins → Install from file
3. Select maxim.plugin
4. Restart Cowork session
5. Maxim skills now activate automatically on relevant triggers
```

For assembly instructions (how the .plugin file is built from source):
See `packaging/cowork/ASSEMBLY.md` in the maxim repo.

### When to use
- Team-based collaboration (multiple users sharing an Maxim-enabled workspace)
- Remote work where repo cloning isn't available
- Light development or doc-heavy projects
- Projects where hooks aren't business-critical

---

## Tier 3 — Claude Desktop + Claude.ai Web (Projects feature)

**Fidelity: 60%** — the behavioral moat transfers; the automation doesn't.

### What's native
- Project Instructions (custom system prompt) fully honored
- Uploaded files are readable as conversation context
- Conversation persistence (per conversation, not per project)
- .brand-foundation files can be uploaded and referenced

### What's absent
- **No slash commands.** No `/mxm-cmo`, `/mxm-watch`, `/mxm-session-end` — use plain prose instead
- **No hooks.** Nothing runs automatically at session start / end / commit
- **No MCP servers.** No tool calls to `check_compliance`, `route_task`, etc.
- **No portfolio sync.** Each conversation is isolated
- **No live watch.** Drift accumulates until you manually review

### Install

```
1. Open Claude.ai (Web) or Claude Desktop
2. Create / open a Project
3. Go to Settings → Custom Instructions (or "Project Instructions")
4. Paste the full contents of documents/cross-surface/maxim-project-instructions.md
5. Save
6. Start a new conversation in that Project
```

Optionally, **upload key files** to give Maxim more context:
- `CLAUDE.md` and / or `CLAUDE.project.md`
- `config/project-manifest.json`
- `documents/ledgers/AGENT_SKILL_INVENTORY.md`
- `.brand-foundation/` files
- Any relevant ADRs

Maxim will treat uploaded files as authoritative and defer to them over the Project Instructions file.

### When to use
- Quick ideation on mobile / browser
- Non-developers interacting with Maxim (marketing, design, exec)
- Projects where code isn't the primary artifact (strategy docs, brand work)
- Air-gapped contexts (no Claude Code install available)

---

## Choosing Your Deployment

| If you want… | Deploy on |
|---|---|
| Maximum automation + hooks + portfolio rollup | Code CLI / IDE |
| Team workspace + plugin-based skills | Cowork |
| Mobile / quick access + behavioral layer | Web / Desktop |
| A mix (dev machine + team + mobile) | All three — they interoperate via repo files |

**Hybrid is common and recommended:**
- Dev machine runs Code CLI (source of truth)
- Team uses Cowork plugin for collaboration sessions
- Stakeholders use Web/Desktop Projects for quick access
- .brand-foundation / Project-Instructions files stay in git repo → all three pull from same source

---

## Cross-Surface Sync

### The repo is the source of truth
All surfaces read from the same `maxim` repo:
- Code CLI: clones directly
- Cowork: the plugin is built from the repo
- Web/Desktop: the project-instructions file is exported from the repo

When Maxim ships a new release, all three artifacts update — users regenerate their plugin install / project-instructions paste.

### Per-surface upgrades
- **Code CLI:** `git pull` + restart sessions
- **Cowork:** re-install `.plugin` (user action)
- **Web/Desktop:** re-paste `documents/cross-surface/maxim-project-instructions.md` into Project Instructions (user action)

### Version drift across surfaces
The `cross-doc-drift` checker in Proactive Watch flags when the three artifacts lag behind the repo's version. Keeping all three in sync is a release-checklist item (automated in `/mxm-release` v1.0.0+).

---

## What Moves Between Surfaces

User work in any surface is portable via:
1. **Repo files** (decisions committed to git flow to all surfaces)
2. **Uploaded Brand Foundation files** (same files, different surfaces)
3. **Session summaries** (paste from one surface → use as context in another)

What **doesn't** move automatically:
- Session memory files (`.claude-sessions-memory/`) — Code CLI only
- Watch reports (`.mxm-skills/watch-report.jsonl`) — Code CLI only
- MCP tool invocations — different runtime environments

---

## Packaging Artifacts

| Artifact | Location | Target Surface |
|---|---|---|
| Full repo | `github.com/yourorg/maxim` | Code CLI / IDE |
| `maxim.plugin` | `packaging/cowork/` | Cowork |
| `documents/cross-surface/maxim-project-instructions.md` | repo root | Web / Desktop Projects |
| This guide | `documents/cross-surface/maxim-surface-guide.md` (repo root) | Documentation |

See individual artifact READMEs for install + assembly details.

---

## Versioning

All three artifacts version-lock to the maxim repo tag:

| Artifact | v1.0.0 |
|---|---|
| Repo tag | `v1.0.0` |
| `maxim.plugin` | `6.4.1` |
| `documents/cross-surface/maxim-project-instructions.md` | header says `v1.0.0` |
| This surface guide | header says `v1.0.0` |

When any of these falls behind the repo tag, the `cross-doc-drift` checker surfaces it.

---

## Related

- `documents/cross-surface/maxim-project-instructions.md` — Web/Desktop install artifact
- `packaging/cowork/README.md` — Cowork plugin details
- `packaging/cowork/ASSEMBLY.md` — how to build the `.plugin` file
- `documents/reference/MXM_INSTALL.md` — Code CLI install path
- `documents/guides/GETTING_STARTED.md` — first-time Maxim adopter guide
- ADR-002 — Executable Contracts (why cross-surface drift is enforced)
