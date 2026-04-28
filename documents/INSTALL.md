# Installing Maxim

> **Maxim** is the behavioral intelligence layer for Claude Code — 90 specialist agents across 7 executive offices, 64 behavioral frameworks, 14 compliance frameworks, and drift detection on every session.
>
> This guide covers: install, choose packs, verify, upgrade, uninstall, troubleshoot.

---

## Prerequisites

| Requirement | Why |
|---|---|
| **Claude Code** ([install](https://claude.com/claude-code)) | Maxim is a Claude Code plugin |
| **Node.js 18+** ([download](https://nodejs.org)) | Maxim's 7 MCP servers run on Node |
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
- 90 specialist agents · 64 frameworks · 14 compliance frameworks

Choose **"Install for you (user scope)"** when prompted.

### Restart Claude Code once

The first session after install will auto-install the 7 MCP servers' Node dependencies (~30 seconds, runs once). After the restart you'll see all 7 MCPs `✓ Connected`.

### What you get free (Starter tier, forever)

- All 90 agents
- All 38 slash commands
- All 64 frameworks (advisory mode)
- Full executive routing
- Local MemPalace memory
- 4 Proactive Watch drift classes

### What auto-activates on first call (Pro Trial, 90 days)

Maxim auto-issues a 90-day Pro Trial JWT on your first MCP call. No payment, no signup. After 90 days, you fall back to Starter — same governance substrate, paid features gated.

Pro Trial unlocks:
- Behavioral audit (50/month)
- Semantic MemPalace (cross-project graph search)
- 11-class Proactive Watch
- 3 compliance frameworks
- Voice mode (10 min/day)
- Brand overlays (20/month)

---

## 2. Install community packs (optional)

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
/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs  # 64 behavioral frameworks live
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

**Most common cause:** the spawn-with-deps wrapper hasn't run yet. Just restart Claude Code one more time — the first restart triggers `npm install` for the 7 MCP servers (~30 seconds), the second restart loads them connected.

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
