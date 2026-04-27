# Maxim — Full Environment Health Check

> **Usage:** Paste this into Claude Cowork or Claude Desktop to verify your entire Maxim setup.
> Works for any user who installed Maxim — not just the developer.
> Adapts to what's available (MCP servers, plugins, memory layers, projects).

---

## Prompt

Run a comprehensive health check on my Maxim installation. Check every layer and report what's working, what's broken, and what's missing.

### Layer 1 — Global Installation

Check if Maxim is globally installed:
1. Read `~/.claude/CLAUDE.md` (or `%USERPROFILE%\.claude\CLAUDE.md` on Windows) — does it exist and contain "Maxim" dispatch rules?
2. Check `~/.claude/commands/` — count files matching `mxm-*.md`. Expected: 31.
3. Check `~/.claude/skills/` — count subdirectories. Expected: 26 (+ 1 deprecated).
4. Check `~/.claude/agents/` — does the Maxim agent structure exist?

Report: `Global install: [OK — symlinked to {path}] | [MISSING — run install-global.ps1]`

### Layer 2 — MCP Servers

Check all 7 Maxim MCP servers:

| Server | Test Call | Expected |
|---|---|---|
| mxm-portfolio | `get_portfolio_overview` | Returns founder, company, projects |
| mxm-context | `get_manifest` (any project) | Returns project JSON |
| mxm-compliance | `get_jurisdiction_requirements("GDPR")` | Returns 8 requirements |
| mxm-behavioral | `get_framework_details("Fogg Behavior Model")` | Returns components + steps |
| maxim-dispatch | `list_offices` | Returns 7 offices |
| maxim-skills | `list_skills` | Returns 26 domains |
| maxim-design | `list_brands` | Returns brand list |
| mxm-memory | `search_memory("test")` | Returns results or "no matches" |

For each: call the tool. Report OK or ERROR with the error message.

Also check non-Maxim MCP servers:
- `mempalace` — call `mempalace_status`. Report drawer count or error.
- `claude-mem` — call `search` with a test query. Report OK or error.

Report: `MCP servers: [N/10 connected] | Missing: [list]`

### Layer 3 — Claude Desktop

Check `%APPDATA%/Claude/claude_desktop_config.json` (Windows) or `~/Library/Application Support/Claude/claude_desktop_config.json` (Mac):
1. Does `mcpServers` section exist?
2. Are all 8 Maxim servers listed?
3. Are env vars correct (MXM_ROOT, MXM_GLOBAL_PATH)?

Report: `Claude Desktop: [OK — 8 servers configured] | [PARTIAL — N/8] | [NOT CONFIGURED]`

### Layer 4 — Memory Layers

Test all 3 memory layers:
1. **Session memory (file-based):** Write a test entry to `.claude-sessions-memory/decision-log.md`, read it back.
2. **MemPalace (graph):** Call `mempalace_status` — check palace is accessible.
3. **claude-mem (vector):** Call search — check ChromaDB is operational.

Report: `Memory: [3/3 layers active] | Issues: [list]`

### Layer 5 — Project Portfolio

If `.mxm-global/` exists:
1. Call `sync_portfolio` — get project count, versions, stale projects
2. Check TASKS.md — are there P1 tasks?
3. Check PORTFOLIO-METRICS.md — is it recent (within 24 hours)?

If `.mxm-global/` doesn't exist:
- Report: "No portfolio layer — single-project mode. Run /mxm-ceo-setup to enable."

Report: `Portfolio: [N projects at v{version}] | [N stale] | [no portfolio layer]`

### Layer 6 — Current Project

Check the current working directory:
1. `config/project-manifest.json` exists?
2. `CLAUDE.project.md` exists?
3. `.mxm-skills/` exists with runtime files?
4. `.claude-sessions-memory/` exists with session files?
5. `.mxm-operator-profile/` exists?
6. `.claude.local/settings.local.json` exists with Read+Edit+Write permissions?
7. `.mxm-executive-summary/` exists? (CEO automation)

Report: `Current project: [name] | Maxim: v{version} | Bootstrap: [complete/partial — list missing]`

### Layer 7 — Scheduled Tasks

Check for active scheduled tasks:
1. List all scheduled tasks
2. Check for `mxm-global-sync` (daily portfolio sync)
3. Check for `ceo-morning-*` / `ceo-overnight-*` tasks

Report: `Scheduled tasks: [N active] | Sync: [daily/none] | CEO: [configured for N projects/none]`

### Layer 8 — Cowork Plugin

Check if `mxm-cowork` plugin is installed:
1. Does `plugins/mxm-cowork/plugin.json` exist in the Maxim repo?
2. What version?

Report: `Cowork plugin: [v{version} installed] | [not found]`

### Final Health Report

```
=== Maxim AGENTS HEALTH CHECK ===
Timestamp: [now]
Maxim Version: [from agent-registry.json]

Layer 1 — Global Install:    [OK/MISSING]
Layer 2 — MCP Servers:       [N/10 connected]
Layer 3 — Claude Desktop:    [OK/PARTIAL/NOT CONFIGURED]
Layer 4 — Memory:            [N/3 layers active]
Layer 5 — Portfolio:         [N projects / no portfolio]
Layer 6 — Current Project:   [complete/partial]
Layer 7 — Scheduled Tasks:   [N active]
Layer 8 — Cowork Plugin:     [installed/missing]

Overall: [HEALTHY / NEEDS ATTENTION / BROKEN]

Action items:
1. [first thing to fix]
2. [second thing to fix]
...
```