# Installing Maxim (v1.3.0)

> **Maxim** is the behavioral intelligence layer for Claude Code — 91 specialist agents across 7 executive offices, 86 behavioral frameworks, 14 compliance frameworks, drift detection on every session, and a 90-day Trial of all 14 packs that activates by default.
>
> This guide covers: Core install → tier wizard (Trial default) → multi-surface deployment → verify → troubleshoot.

---

## TL;DR · install in 30 seconds, see the moat work in 90 days

```bash
# Step 1 — install Core (everything free-tier ships with)
/plugin marketplace add DrNabeelKhan/maxim
/plugin install maxim@maxim-packs

# Step 2 — activate your tier (Trial pre-selected · no card required)
bash bootstrap/install-tier-packs.sh        # Mac · Linux · WSL · Git Bash
pwsh -File bootstrap/install-tier-packs.ps1 # Windows · or PS7 cross-platform
```

The wizard pre-selects **90-day Trial of all 14 packs** because a moat is hard to evaluate when you can't see it. Run your real work through Maxim for three months. Then decide what's worth keeping.

For Desktop / Web cross-surface setup, see [Cross-surface section](#multi-surface-deployment) below.

---

## Prerequisites

| Requirement | Why |
|---|---|
| **Claude Code** ([install](https://claude.com/claude-code)) | Maxim is a Claude Code plugin |
| **Node.js 18+** ([download](https://nodejs.org)) | Maxim's 9 MCP servers run on Node |
| **Git** | Used by the plugin marketplace cache |
| **Internet on first install** | License JWT issuance (90-day Pro Trial auto-activates; falls back to Starter forever after) |

Verify prerequisites:

```bash
claude --version    # any version 2.0+
node --version      # v18 or later
git --version       # any modern version
```

---

## 1. Install the base plugin

In Claude Code's chat (the TUI), run these two slash commands:

```
/plugin marketplace add DrNabeelKhan/maxim
/plugin install maxim@maxim-packs
```

The first registers the marketplace; the second installs the base plugin.

Confirm the install dialog shows:
- **Version:** v1.1.0 or later
- **By:** Dr. Nabeel Khan
- 91 specialist agents · 86 behavioral frameworks · 14 compliance frameworks · 9 MCPs (95 tools)

Choose **"Install for you (user scope)"** when prompted.

### Restart Claude Code once

The first session after install will auto-install the 9 MCP servers' Node dependencies (~30 seconds, runs once). After the restart you'll see all 7 MCPs `✓ Connected`.

### What you get free (Core tier, forever)

- All 91 agents (24 dispatchable + 67 specialist catalog via mxm-catalog MCP)
- All 50 slash commands
- All 86 frameworks (advisory mode)
- Full executive routing
- Local MemPalace memory
- 13 Proactive Watch drift classes (4 free severity, 9 gated severity-block at Pro+)
- 9 MCPs · 95 tools

### What auto-activates on first call (Pro Trial, 90 days)

Maxim auto-issues a 90-day Pro Trial JWT on your first MCP call. No payment, no signup. After 90 days, you fall back to Starter — same governance substrate, paid features gated.

Pro Trial unlocks:
- Behavioral audit (50/month)
- Semantic MemPalace (cross-project graph search)
- 11-class Proactive Watch
- 14 compliance frameworks
- Voice mode (10 min/day)
- Brand overlays (20/month)

---

## 2. (Optional) Enable Maxim in Claude Desktop

Claude Code installs Maxim automatically. **For Claude Desktop, MCPs need a one-time config step** because Desktop doesn't have Claude Code's plugin system.

### Auto-config (recommended) — one command

```bash
# macOS / Linux / WSL / Git Bash
bash bootstrap/mxm-desktop-config.sh

# Windows PowerShell
pwsh -File bootstrap/mxm-desktop-config.ps1
```

This script:
1. Auto-detects your OS and locates `claude_desktop_config.json`
2. Backs up your existing config (timestamped `.bak`)
3. Adds all 8 Maxim MCP entries (`mxm-portfolio`, `mxm-context`, `mxm-catalog`, `mxm-compliance`, `mxm-behavioral`, `mxm-memory`, `mxm-voice`, `mxm-commands`)
4. Preserves any existing MCP entries (e.g., other tools you have configured)
5. Validates the JSON

Then **quit Claude Desktop completely** (Cmd-Q on Mac, fully exit from system tray on Windows/Linux) and reopen. All 8 Maxim MCPs spawn — the new `mxm-commands` MCP runs a one-time `npm install` (~10 sec) on first launch.

### Manual config (if the script can't run)

Locate your `claude_desktop_config.json`:

| OS | Path |
|---|---|
| **macOS** | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| **Linux** | `~/.config/Claude/claude_desktop_config.json` |
| **Windows** | `%APPDATA%\Claude\claude_desktop_config.json` |

Add these 8 entries to the `mcpServers` object (replace `<HOME>` with your actual home path — `/Users/you` on Mac, `C:/Users/you` on Windows):

```json
{
  "mcpServers": {
    "mxm-portfolio":  { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-portfolio/server.js"],  "env": {} },
    "mxm-context":    { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-context/server.js"],    "env": {} },
    "mxm-catalog":    { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-catalog/server.js"],    "env": {} },
    "mxm-compliance": { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-compliance/server.js"], "env": {} },
    "mxm-behavioral": { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-behavioral/server.js"], "env": {} },
    "mxm-memory":     { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-memory/server.js"],     "env": {} },
    "mxm-voice":      { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-voice/server.js"],      "env": {} },
    "mxm-commands":   { "command": "node", "args": ["<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/_shared/spawn-with-deps.mjs", "<HOME>/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/mxm-commands/server.js"],   "env": {} }
  }
}
```

The `mxm-commands` MCP (added v1.2.0.1) is what gives Desktop **command parity** — it exposes all 50 `/mxm-*` slash commands as MCP tools, since Desktop doesn't have a native slash-command processor. After restart you can ask Claude Desktop *"use mxm-commands.mxm_command for build hello-world"* and it routes the same way Claude Code's `/mxm-build hello-world` does.

### Activate behavioral layer in Claude Desktop Projects (optional, recommended)

For each Claude Desktop Project where you want Maxim's behavioral overlay (framework citation, confidence tagging, CSO auto-loop) active:

1. Open the Project → Settings → **Custom Instructions** (or "Project Instructions")
2. Paste the contents of [`documents/cross-surface/maxim-project-instructions.md`](cross-surface/maxim-project-instructions.md)
3. Save

This activates ~85% of Maxim's Claude Code fidelity in that Desktop Project — including the slash-command alias section so typing `/mxm-build` in chat works as a routing directive.

### Claude.ai Web (Projects feature)

Same as Desktop's Project Instructions step — paste `documents/cross-surface/maxim-project-instructions.md` into Project Instructions. **No MCPs available in pure Web** (Anthropic doesn't expose MCP to Web Projects yet), so fidelity caps at ~85% (slash-command aliasing + behavioral layer, no MCP tool calls).

### Surface fidelity reference

| Surface | Slash commands | MCPs | Behavioral layer | Fidelity |
|---|---|---|---|---|
| Claude Code (CLI / IDE) | ✅ all 48 native | ✅ 8 (49 tools) | ✅ auto (CLAUDE.md) | **100%** |
| Claude Desktop | ❌ (use mxm-commands MCP or project instructions) | ✅ 8 (49 tools) | 🟡 paste project instructions | **~95%** |
| Claude.ai Web (Projects) | ❌ (use project instructions) | ❌ no MCP in Web | 🟡 paste project instructions | **~85%** |
| Claude.ai Cowork | ✅ (via plugin) | ✅ 8 | bundled in plugin | **~85%** |

---

## 3. Install community packs (optional)

The base plugin is everything most users need. Packs add **extra specialist depth** for specific moats.

### Choose ONE strategy — don't mix

**Strategy A — L1 individual packs (recommended for most)**

Pick the L1 packs that match your work. Each is independent.

```
/plugin install mxm-pack-l1-1-ai-governance@maxim-packs       # AI Act + ISO 42001 + audit trail
/plugin install mxm-pack-l1-2-mempalace-pro@maxim-packs       # Cross-session memory upgrade
/plugin install mxm-pack-l1-3-proactive-watch@maxim-packs     # Full 11-class drift detection
/plugin install mxm-pack-l1-4-compliance-shield@maxim-packs   # 14 regulated-industry frameworks
/plugin install mxm-pack-l1-5-brand-design-pro@maxim-packs    # 15 cinematic brand styles
/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs  # 86 behavioral frameworks live
```

**Strategy B — L2 persona bundles (one bundle = several L1s combined)**

```
/plugin install mxm-pack-l2-1-founder-os@maxim-packs       # AI Gov + MemPalace + Compliance + more
/plugin install mxm-pack-l2-2-growth-stack@maxim-packs     # Marketing + brand + behavioral
/plugin install mxm-pack-l2-3-professional-os@maxim-packs  # Full L1 suite (consultants/boutiques)
/plugin install mxm-pack-l2-4-agency-all-in@maxim-packs    # Full L1 suite + agency tier features
```

> ⚠️ **Don't install both L1 individuals AND an L2 bundle** that subsumes them — you'll get duplicate skills/agents.

**Strategy C — L3 vertical overlays (additive on top of L1 or L2)**

Vertical-specific compliance + workflows. Stack on top of any base.

```
/plugin install mxm-pack-l3-1-healthcare@maxim-packs   # HIPAA + ISO 13485/14971 + FHIR
/plugin install mxm-pack-l3-2-legal@maxim-packs        # Privileged comm + DPA generation
/plugin install mxm-pack-l3-3-fintech@maxim-packs      # PCI-DSS + SOC 2 + FINTRAC
/plugin install mxm-pack-l3-4-govtech@maxim-packs      # NIST CSF + FedRAMP + records retention
```

---

## 3. Verify the install

In your terminal (not the Claude Code TUI), run:

```bash
claude mcp list
```

Expected output — all 7 should show `✓ Connected`:

```
plugin:maxim:mxm-portfolio   ... ✓ Connected
plugin:maxim:mxm-context     ... ✓ Connected
plugin:maxim:mxm-catalog     ... ✓ Connected
plugin:maxim:mxm-compliance  ... ✓ Connected
plugin:maxim:mxm-behavioral  ... ✓ Connected
plugin:maxim:mxm-memory      ... ✓ Connected
plugin:maxim:mxm-voice       ... ✓ Connected
```

If any show `✗ Failed to connect`, see [Troubleshooting](#troubleshooting) below.

In Claude Code's chat, run:

```
/mxm-help
```

You should see the v1.1.0+ command reference card with the LICENSING section at the top.

---

## 4. Upgrade

Maxim ships frequent patches (`v1.1.0.4` etc.) on the same minor version. Two paths:

### Fast path (recommended) — `/mxm-self-update`

```
/mxm-self-update
```

This pulls the latest commit from the marketplace, syncs into the install cache, preserves `node_modules/` so MCPs don't re-install, then asks you to restart Claude Code once. ~5 seconds plus restart.

Use this for any patch version (`v1.1.0.X`). Available from v1.1.1+.

### Full path — uninstall + reinstall

For major version bumps (e.g. `v1.1` → `v1.2`) or when troubleshooting:

```
/plugin uninstall maxim@maxim-packs
/plugin install maxim@maxim-packs
```

After install, restart Claude Code. The first session triggers the spawn-with-deps wrapper which re-installs `node_modules` (~30 seconds), then a second session restart loads the new code. Slower but gives a fresh slate.

---

## 5. Uninstall

### Remove a single pack

```
/plugin uninstall mxm-pack-l1-1-ai-governance@maxim-packs
```

If you see *"not installed in project scope"*, add the scope flag:

```
/plugin uninstall mxm-pack-l1-1-ai-governance@maxim-packs --scope user
```

Repeat for each pack you want to remove.

### Remove the base plugin (and everything)

```
/plugin uninstall maxim@maxim-packs --scope user
/plugin marketplace remove maxim-packs
```

This removes the plugin from Claude Code, clears the install cache, and unregisters the marketplace.

### Cleanup leftovers (optional)

After uninstall, you can manually clean these if desired (none of them affect Claude Code's operation):

```bash
# License JWT cache + owner key (if you ever set one up)
rm -rf ~/.mxm-packs

# Per-project Maxim state (in each project that ran Maxim)
rm -rf <project>/.mxm-skills
rm -rf <project>/.mxm-operator-profile
rm -rf <project>/.claude-sessions-memory
```

---

## Troubleshooting

### MCP servers fail to connect after install

```
plugin:maxim:mxm-portfolio  ✗ Failed to connect
```

**Most common cause:** the spawn-with-deps wrapper hasn't run yet. Just restart Claude Code one more time — the first restart triggers `npm install` for the 9 MCP servers (~30 seconds), the second restart loads them connected.

**If that doesn't fix it:** manually install MCP deps:

```bash
cd ~/.claude/plugins/cache/maxim-packs/maxim/$(ls ~/.claude/plugins/cache/maxim-packs/maxim/ | head -1)
bash bootstrap/mxm-mcp-install.sh --force
```

(Or `pwsh -File bootstrap\mxm-mcp-install.ps1 -Force` on Windows.)

### `/plugin install` says "not found in any marketplace"

Marketplace registration was lost (typically after `/plugin marketplace remove`). Re-add it:

```
/plugin marketplace add DrNabeelKhan/maxim
```

Then retry the install.

### `/mxm-help` shows old content after upgrade

Claude Code caches command output. Restart Claude Code once after `/mxm-self-update` (or after a fresh `/plugin install`).

### Pro Trial didn't auto-activate

Verify your machine has internet on first call. The Pro Trial JWT is fetched from the production Worker. If your network is restricted, you'll fall back to anonymous Starter (still functional, fewer features).

To check your tier:

```
/mxm-status
```

### Owner key (advanced)

If you're a Maxim contributor, you can place your owner key at `~/.mxm-packs/owner.key` to bypass all license checks. See `bootstrap/mxm-owner-keygen-bootstrap.sh` to generate one.

---

## Support

| Channel | When to use |
|---|---|
| **Issues** | https://github.com/DrNabeelKhan/maxim/issues — bug reports, feature requests |
| **Discussions** | https://github.com/DrNabeelKhan/maxim/discussions — questions, share workflows |
| **Email** | https://maxim.isystematic.com/contact — commercial / licensing |

---

## License

Maxim is **Business Source License 1.1** (BSL-1.1) — free for personal, internal, and non-production use. Production deployments require a paid license. Source code is fully visible (no obfuscation); license enforcement happens at the runtime MCP layer. Auto-converts to Apache 2.0 four years after each release per ADR-005.

See [LICENSE](../LICENSE) for full terms.

---

<sub>Maxim v1.1.0+ · Copyright (c) 2026 iSystematic Inc. · Last updated 2026-04-28</sub>