# /mxm-health

## Usage
- Claude Code: `/mxm-health`
- Claude CLI: `claude "/mxm-health"`
- Claude Desktop: type `/mxm-health` in chat

Full 8-layer system health check across all Maxim infrastructure. Tests MCP servers, memory layers, Claude Desktop, portfolio, scheduled tasks, and offers to FIX any issues found.

**Triggers:** "maxim health", "health check", "system diagnostic", "check everything", "verify setup"

**For project-only quick status:** use `/mxm-status` instead.

## Behavior

Run all 8 layers in sequence. For each layer, report OK or issue. After all layers complete, offer to autofix any issues found.

### Layer 1 — Global Installation

1. **Detect install mode:**
   - `CLAUDE.md` at `%USERPROFILE%\.claude\CLAUDE.md` but NOT at project root → `GLOBAL`
   - `CLAUDE.md` at project root AND `.claude/` at project root → `LEGACY-LOCAL`
   - Both exist → `MIXED`
2. Check `~/.claude/commands/` — count `mxm-*.md` files. Expected: 32 (31 original + mxm-health).
3. Check `~/.claude/skills/` — count subdirectories (exclude `deprecated`). Expected: 26.
4. If any missing:
   ```
   AUTOFIX: Run .\bootstrap\install-global.ps1 (Windows) or bash bootstrap/new-project-setup.sh (Mac/Linux)
   ```

### Layer 2 — MCP Servers

Test each MCP server with a real tool call:

| Server | Test Tool | Expected |
|---|---|---|
| mxm-portfolio | `get_portfolio_overview` | Returns founder/company |
| mxm-context | `get_skill_gaps` (current project path) | Returns content or "no gaps" |
| mxm-compliance | `get_jurisdiction_requirements("GDPR")` | Returns 8 requirements |
| mxm-behavioral | `get_framework_details("Fogg Behavior Model")` | Returns components |
| maxim-dispatch | `list_offices` | Returns 7 offices |
| maxim-skills | `list_skills` | Returns 26 domains |
| maxim-design | `list_brands` | Returns brand list |
| mxm-memory | `search_memory("test", current_project)` | Returns results or "no matches" |

For each: call the tool. Report `OK` or `FAIL: [error]`.

Also check non-Maxim servers:
- `mempalace` — call `mempalace_status` if available
- `claude-mem` — call `search` if available

If any Maxim server missing:
```
AUTOFIX: claude mcp add maxim-{name} -s user -e MXM_ROOT=E:/Projects/Maxim/maxim -- node E:/Projects/Maxim/maxim/mcp/maxim-{name}/server.js
```

### Layer 3 — Claude Desktop

Read Claude Desktop config:
- Windows: `%APPDATA%/Claude/claude_desktop_config.json`
- Mac: `~/Library/Application Support/Claude/claude_desktop_config.json`

Check `mcpServers` section exists with all 8 Maxim servers. If missing or incomplete:
```
AUTOFIX: I can write the mcpServers block to claude_desktop_config.json.
         You will need to restart Claude Desktop after.
         Apply fix? (yes/no)
```

If user says yes: read the current config, add the missing `mcpServers` entries, write it back.

### Layer 4 — Memory Layers

Test all 3:
1. **Session memory:** Check `.claude-sessions-memory/` exists in current project and has files.
2. **MemPalace:** Call `mempalace_status` — report drawer count or "not connected".
3. **claude-mem:** Call `search` — report OK or error (e.g., onnxruntime missing).

If session memory missing:
```
AUTOFIX: mkdir .claude-sessions-memory && touch .claude-sessions-memory/handoff.md .claude-sessions-memory/decision-log.md
         Apply fix? (yes/no)
```

### Layer 5 — Current Project

1. `config/project-manifest.json` — exists? Version matches latest?
2. `CLAUDE.project.md` — exists?
3. `.mxm-skills/` — exists with handoff, gaps log, review-queue?
4. `.mxm-operator-profile/` — exists with 4 files?
5. `.claude.local/settings.local.json` — exists with Read + Edit + Write permissions?
6. `.mxm-skills/review-queue.md` — PENDING item count

For any missing file:
```
AUTOFIX: I can create the missing files from templates.
         Apply fix? (yes/no)
```

If permissions missing Edit/Write:
```
AUTOFIX: I can update settings.local.json to add Edit() and Write() permissions.
         Apply fix? (yes/no)
```

### Layer 6 — Portfolio

If `.mxm-global/` accessible:
1. Call `mxm-portfolio.sync_portfolio` — report project count, versions, stale projects
2. Call `mxm-portfolio.get_tasks` with priority P1 — report top tasks
3. Check `portfolio-registry/STRUCTURE.md` exists (organizational structure)

If `.mxm-global/` not accessible:
```
Portfolio layer not configured. This is optional.
To enable: run /mxm-ceo-setup on your primary project.
```

### Layer 7 — Scheduled Tasks

1. List all scheduled tasks
2. Check for `mxm-global-sync` (daily portfolio sync)
3. Check for `ceo-morning-*` / `ceo-overnight-*` tasks

If no sync task:
```
AUTOFIX: I can create the mxm-global-sync scheduled task (daily 5:27 AM).
         Apply fix? (yes/no)
```

### Layer 8 — Cowork Plugin

1. Check `plugins/mxm-cowork/plugin.json` in Maxim source repo
2. Report version — flag if behind current Maxim version

---

### Output Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Maxim HEALTH  ·  v[version]  ·  [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Layer 1 — Global Install:    [OK/ISSUE] · [mode] · [N] commands · [N] skills
Layer 2 — MCP Servers:       [N]/10 connected
Layer 3 — Claude Desktop:    [N]/8 configured
Layer 4 — Memory:            [N]/3 layers active
Layer 5 — Current Project:   [OK/N issues]
Layer 6 — Portfolio:         [N projects / not configured]
Layer 7 — Scheduled Tasks:   [N active]
Layer 8 — Cowork Plugin:     v[version]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ISSUES FOUND: [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. [issue description] → AUTOFIX available
  2. [issue description] → AUTOFIX available
  3. [issue description] → Manual action required
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Apply all autofixes? (yes / pick numbers / no)
```

If user says "yes": apply all autofixes in sequence, then re-run the failing layers to confirm.
If user picks numbers (e.g., "1, 3"): apply only those fixes.

### Post-fix verification

After applying any autofix, re-run ONLY the affected layer to confirm the fix worked. Report:
```
Fix #1: [applied] → re-check: [OK/STILL FAILING]
Fix #2: [applied] → re-check: [OK/STILL FAILING]
```

Tag output: HIGH
