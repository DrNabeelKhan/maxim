---
description: Fast in-place Maxim plugin update — pulls latest from marketplace, preserves node_modules. One restart, no TUI uninstall/reinstall cycle.
---

# /mxm-self-update

Updates the locally-installed Maxim plugin to the latest commit on `origin/main`
without requiring a `/plugin uninstall` + `/plugin install` cycle. Preserves
`node_modules/` so MCP servers don't need to re-install dependencies.

## Usage

- Claude Code: `/mxm-self-update`
- Direct: `bash ${CLAUDE_PLUGIN_ROOT}/bootstrap/mxm-self-update.sh`
- PowerShell: `pwsh -File ${env:CLAUDE_PLUGIN_ROOT}/bootstrap/mxm-self-update.ps1`

## What it does

1. **Pulls** latest commits in `~/.claude/plugins/marketplaces/maxim-packs/`
   (the marketplace cache, which is a git clone of `DrNabeelKhan/maxim`).
2. **Syncs** marketplace content into the install cache at
   `~/.claude/plugins/cache/maxim-packs/maxim/<version>/`, preserving:
   - `node_modules/` (so MCPs don't need to re-install)
   - `.mcp-deps-installed` sentinel
   - `.mcp-install-lock` (if mid-install)
3. **Updates** `installed_plugins.json` with the new `gitCommitSha` +
   `lastUpdated` timestamp.

## After running

Restart Claude Code ONCE. New content (slash commands, skills, agents, hooks,
MCP server code) loads on next session start. The spawn-with-deps wrapper sees
its sentinel and skips re-install — total restart time is the same as a normal
session start.

## Behavior

Detect the operating system, then execute the appropriate bootstrap script:

```bash
# bash / Git-Bash / Mac / Linux
bash "${CLAUDE_PLUGIN_ROOT}/bootstrap/mxm-self-update.sh"

# PowerShell (Windows native)
pwsh -NoProfile -File "${env:CLAUDE_PLUGIN_ROOT}/bootstrap/mxm-self-update.ps1"
```

Capture stdout + stderr from the script. Report:
1. The old commit SHA → new commit SHA (or "Already up to date")
2. Reminder to restart Claude Code

If the script exits non-zero, surface the error message verbatim and recommend
the fallback flow:
```
/plugin uninstall maxim@maxim-packs
/plugin marketplace remove maxim-packs
/plugin marketplace add DrNabeelKhan/maxim
/plugin install maxim@maxim-packs
```

### Tag output: 🟢 HIGH if updated cleanly · 🟡 MEDIUM if no-op (already up to date) · 🔴 LOW if error
