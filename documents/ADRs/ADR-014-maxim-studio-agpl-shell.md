# ADR-014 — Maxim Studio: AGPL-3.0 GUI Shell on top of BSL-1.1 Plugin

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-13
- **Deciders:** DrNabeelKhan
- **Related:** ADR-005 (IP protection), ADR-009 (pack architecture), ADR-011 (Stripe), ADR-013 (topology)

---

## Context

Maxim v1.1.1 ships entirely as a Claude Code plugin (CLI-first). The operator-facing
surface is the TUI of Claude Code itself: slash commands, agent outputs in the chat,
session-start banners. There is no visual dashboard, no pack catalog UI, no live license
indicator, and no point-and-click access to the 90-agent roster, 64 frameworks, or
Proactive Watch drift classes.

This creates two acquisition barriers:

1. **Discovery barrier.** Non-developers evaluating Maxim see a CLI plugin. The moat —
   90 agents, 64 behavioral frameworks, 14 compliance frameworks, 11 drift classes —
   is invisible until the operator reads documentation. Most don't.

2. **Sales barrier.** Pack purchases (`/giveaway`, L1/L2/L3 upgrades) require the
   operator to leave Claude Code, navigate a browser, complete Stripe checkout, then
   return. The friction is 4–6 steps after the purchase decision is already made.

A desktop GUI shell addresses both barriers without changing the plugin or the
Cloudflare Worker. The GUI is a thin client: it reads local plugin state, talks to the
Worker for license validation, and opens a browser for Stripe checkout. No Maxim moat
material lives inside the shell binary.

**opcode** (https://github.com/winfunc/opcode) — 21.8k stars, Tauri 2 + React 18 +
TypeScript + Vite 6 + Tailwind CSS v4 + shadcn/ui + SQLite + Bun, AGPL-3.0, active
development — provides the proven chassis. A fork adds Maxim-specific UI surfaces on
top without rebuilding the session browser, MCP manager, or CLAUDE.md editor.

**License compatibility:** opcode is AGPL-3.0. Maxim plugin is BSL-1.1. These are
separable works. The Studio shell (AGPL-3.0) calls the plugin's MCP tools at runtime
via stdio/IPC — the same channel Claude Code uses. Two separate executables with a
protocol boundary is not a combined work under AGPL. The plugin's BSL-1.1 license,
the Cloudflare Worker's proprietary deployment, and the Stripe integration remain
legally independent of the Studio shell's AGPL-3.0 license. See
`documents/reference/LICENSE_SEPARATION.md` for the full legal architecture statement.

---

## Decision

Fork `winfunc/opcode` into `github.com/DrNabeelKhan/maxim-studio`. Ship the fork as
**Maxim Studio** under AGPL-3.0. Add 11 Maxim-specific UI surfaces on top of the
opcode chassis. Enforce three hard constraints throughout the fork:

### Constraint 0 — Studio is the single install path; plugin bundle is embedded + extracted

**Distribution model: split bundle (corrected 2026-05-13).**

The Studio binary is ~50 MB (pure AGPL shell). The Maxim plugin is distributed as
a separately versioned compressed bundle (~8 MB), embedded in the binary for offline
first-run OR downloaded as a lightweight delta on update checks. This decouples
Studio release cadence (rare, ~50 MB) from plugin release cadence (frequent, ~8 MB).

On first run and on startup update check:
```
1. Studio reads ~/.mxm-studio/current.json → current plugin version
2. Studio checks GitHub releases API for latest plugin version
   → same: skip  →  newer: prompt "v1.1.2 available — update?" [Now] [Later]
3. Extract plugin bundle to ~/.mxm-studio/maxim/<version>/
4. Pre-install node_modules for all 7 MCP servers
5. Write to BOTH MCP registries:
   ~/.mcp.json               ← Claude Code user-level MCP registry
   %APPDATA%\Claude\claude_desktop_config.json  ← Claude Desktop MCP registry
   (macOS: ~/Library/Application Support/Claude/claude_desktop_config.json)
6. Update ~/.mxm-studio/current.json
```

Neither surface (Claude Code CLI nor Claude Desktop) requires `claude plugin install`.
Studio manages the plugin lifecycle entirely. Users who have Claude Code or Claude
Desktop installed get Maxim MCP tools in both surfaces automatically.

### Constraint 0b — Dual-surface support: Claude Code CLI + Claude Desktop

**Maxim Studio ships as a standalone installer. Users never need to separately
install the Maxim plugin.** The Studio's first-run wizard orchestrates the full
dependency chain:

```
User downloads Maxim Studio (.dmg / .msi / .AppImage)
  ↓
Studio first-launch wizard:
  1. Detect Claude Code installation (check for `claude` in PATH)
     → If absent: show download link + wait for user to install + re-check
  2. Register Maxim marketplace:
     run: claude plugin marketplace add DrNabeelKhan/maxim
  3. Install base plugin:
     run: claude plugin install maxim@maxim-packs
  4. Pre-install MCP server node_modules (don't wait for Claude Code session):
     For each mcp/mxm-*/ in plugin cache: npm install
     (Studio shows live progress: "Installing MCP servers... 3/7")
  5. Verify all 7 MCPs are ready (check node_modules presence)
  6. Show "Maxim Studio is ready" screen with quick-start tips
```

The plugin code still lives at `~/.claude/plugins/cache/maxim-packs/maxim/<version>/`
(the standard Claude Code plugin location). Studio triggers the install; Claude Code
owns the plugin registry. Users who already have the plugin installed skip steps 2–4.

This means:
- **Download Maxim Studio = get everything** — Claude Code users need one download
- **No manual plugin install** — no `/plugin marketplace add`, no `/plugin install`,
  no "restart twice for MCPs" — Studio handles all of it with a progress UI
- **MCP deps pre-installed** — first Claude Code session after Studio setup loads all
  7 MCPs immediately (no 30-second first-run npm install on session open)

Both surfaces use the same MCP stdio protocol and the same `mcpServers` JSON key.
Studio detects which surfaces are installed and registers the 7 MCP servers in each.

| Surface | MCP config file | Commands + Agents |
|---|---|---|
| Claude Code CLI | `~/.mcp.json` (user-level) | ✅ `.claude/commands/` + `.claude/agents/` via extracted plugin |
| Claude Desktop | `%APPDATA%\Claude\claude_desktop_config.json` (Windows) · `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) | MCP tools ✅ · Slash commands ❌ (Claude Desktop does not load `.claude/commands/`) |
| Studio itself | Tauri IPC directly to extracted MCP servers | ✅ all surfaces |

Claude Desktop users get all 7 Maxim MCP tools (behavioral audit, compliance checks,
MemPalace search, portfolio sync, voice, catalog, context/watch). They do not get
slash commands — those are Claude Code CLI only. The MCP tools are the primary
value surface and work identically across both.

### Constraint 0c — Mission Control mode: VAZIR HUD incorporated into Studio

Maxim Studio ships with TWO modes switchable from the top bar:

**Studio mode** (default): opcode-derived desktop UI — agent roster, pack catalog,
license bar, Proactive Watch panel, MemPalace search, Executive Dispatch.

**Mission Control mode**: the VAZIR AI Agent HUD ported to Tauri's WebView —
cinematic JARVIS-style interface with live agent activity, voice conversation,
Proactive Watch alerts as priority queue, and the Maxim persona system (VAZIR /
ELARA / RIVA / JARVIS) as the HUD's "cognitive core".

The VAZIR handoff files (`AI Agent HUD.html`, `hud_app.jsx`, `tweaks-panel.jsx`)
are incorporated as the foundation:
- `window.claude.complete()` → replaced with `mxm-catalog.route_task()` MCP call
  (Maxim executive routing instead of raw LLM)
- `PendingTasks` → replaced with live Proactive Watch alerts + `/mxm-tasks` queue
  (P1 = FAIL, P2 = WARN, P3 = INFO, with real countdown from scheduled tasks)
- TTS → the HUD already uses Web Speech API (= Windows native SpeechSynthesis +
  SpeechRecognition) — this IS the platform-native voice path. Zero changes needed
  for the default voice engine. Kokoro/custom voice wired via Voice Config tab.
- `tweaks-panel.jsx` → promoted to Maxim Studio's global settings design system,
  used by Voice Config, Theme, and Proactive Watch configuration tabs in Studio mode
- Focus mode (document/image/video/file) → repurposed for full-screen Maxim outputs:
  agent response, MOAT_TRACKER briefing, compliance report, MemPalace document

The operator's personal VAZIR personas (bm_daniel / bf_emma / af_kore / bm_george)
are pre-configured in Mission Control's persona routing. The HUD's "cognitive core"
animation pulses to Maxim's TTS output — identical to the existing VAZIR production
behavior.

### Constraint 1 — No Maxim IP in the Studio binary

The Studio binary contains:
- ✅ UI components (React, shadcn/ui, Tailwind) — generic
- ✅ Tauri application shell — generic
- ✅ SQLite session database — generic
- ✅ opcode's existing features (session browser, MCP manager, CLAUDE.md editor) — from AGPL upstream
- ✅ Maxim trademark (logo, name, color palette) — used by permission under fair use
- ✅ Installer/wizard logic that runs `claude plugin install` — the plugin itself is
  pulled from the public marketplace (GitHub), NOT bundled in the binary
- ❌ NO agent DNA (.md files from `agents/MXM/`)
- ❌ NO framework content (`composable-skills/frameworks/`)
- ❌ NO SKILL.md files (from packs or base plugin)
- ❌ NO license-gate.mjs logic
- ❌ NO JWT signing keys
- ❌ NO Stripe keys or checkout secrets

All Maxim IP lives in the BSL-1.1 plugin at
`~/.claude/plugins/cache/maxim-packs/maxim/<version>/`. The Studio orchestrates its
installation and then reads it from disk at runtime. The Studio is an installer +
viewer, not a container of the plugin's source code.

### Constraint 2 — Packs are runtime-dynamic; Studio is pack-agnostic

The Studio never has a compiled-in list of packs. Pack discovery is:

```
1. Read ~/.claude/plugins/installed_plugins.json
   → discover which packs are installed + their version + install path
2. POST https://maxim-license-api.isystematic.workers.dev/validate { jwt }
   → receive { tier, grants, expires_at }
3. Render pack catalog as a function of (installed_plugins + tier + grants)
   → available packs from .claude-plugin/marketplace.json on disk
   → installed = those in installed_plugins.json
   → unlocked = those whose grants are in the validate response
   → purchase = opens browser to maxim.isystematic.com/pricing?ref=studio
```

Installing, removing, or purchasing a pack requires ZERO Studio code changes. A new
pack appears automatically when the marketplace.json on disk references it. A pack
disappears when uninstalled. A purchased pack unlocks without restart when the JWT
is refreshed.

### Constraint 3 — Revenue flows through BSL-layer; Studio is read-only on payment

The Studio's "Upgrade" flow:

```
User clicks "Upgrade"
  → Studio opens browser: https://maxim.isystematic.com/pricing?ref=studio&tier=L1.4
  → User completes Stripe Checkout in browser (Stripe-hosted, no iframe)
  → Stripe → Cloudflare Worker /webhook/stripe → JWT issued → KV updated
  → Studio detects new JWT on next /validate heartbeat (60s poll)
  → UI re-renders unlocked grants without restart
```

The Studio never handles payment tokens, card data, or webhook secrets. PCI-DSS scope
for Maxim Studio = zero (no cardholder data environment in the AGPL binary).

### The 11 Maxim-specific UI surfaces

These are the net-new surfaces added to the opcode chassis. Full detail in
`documents/reference/MAXIM_STUDIO_ARCHITECTURE.md`.

| Surface | What it shows |
|---|---|
| **Executive Dispatch** | 7-office visual map; click to route a task |
| **Agent Roster** | 90 agents grouped by office, searchable, DNA grade visible |
| **Framework Library** | 64 frameworks, searchable, trigger phrases, confidence tags |
| **Pack Catalog** | Dynamic: installed / unlocked / available; Upgrade CTA → browser |
| **License Bar** | Tier · grants · days remaining · JWT health indicator |
| **Proactive Watch** | 11 drift classes as live tiles; severity colors; click-to-fix |
| **MOAT Tracker** | Competitive positioning ledger (read from MOAT_TRACKER.md) |
| **MemPalace** | Cross-session memory search (via mxm-memory MCP) |
| **Confidence Tags** | Per-output 🟢🟡🔴 badge overlay on all agent-generated content |
| **Voice Config** | Engine picker: Native (default) / Whisper+Kokoro / Custom; per-persona routing |
| **Studio** (cinematic) | AI media generation skill surfaced for cinematic style picker |

### Maxim Studio name + branding

- Product name: **Maxim Studio**
- Repo: `github.com/DrNabeelKhan/maxim-studio` (public, AGPL-3.0)
- Distribution: GitHub Releases (macOS .dmg, Windows .msi, Linux .AppImage)
- Versioning: independent of plugin versioning; v0.1.0 at first public release
- License notice in About dialog: "Maxim Studio is AGPL-3.0. The Maxim plugin is BSL-1.1. See maxim.isystematic.com/studio/license."

### Estimated delivery

| Milestone | Effort | Target |
|---|---|---|
| Fork + clean local build + CODEOWNERS | 1 day | Sprint start |
| **Split bundle installer**: extract plugin to `~/.mxm-studio/`, pre-install MCP deps, write to Claude Code + Claude Desktop MCP configs, startup update checker | 3 days | Week 1 |
| Rebrand Studio chrome (logo, splash, color palette, top-bar mode switcher) | 1 day | Week 2 |
| **Mission Control mode**: port VAZIR HUD (hud_app.jsx + tweaks-panel.jsx + AI Agent HUD.html) to Tauri WebView; swap `window.claude.complete()` → `mxm-catalog.route_task()` MCP; wire PendingTasks → live Proactive Watch; promote tweaks-panel.jsx to global settings system | 3 days | Week 2–3 |
| Executive Dispatch + Agent Roster sidebar (Studio mode) | 2 days | Week 3–4 |
| Pack Catalog + License Bar (Studio mode) | 2 days | Week 4 |
| Proactive Watch panel + MemPalace search (Studio mode) | 2 days | Week 5 |
| Voice Config tab + confidence tag overlay; VAZIR HUD TTS already uses Web Speech API → verify native path works; add Kokoro/custom wiring | 1 day | Week 5 |
| MOAT Tracker + Framework Library + Studio (cinematic) tab | 2 days | Week 6 |
| Focus mode repurposing: agent response / compliance report / MOAT briefing full-screen | 1 day | Week 6 |
| QA + Claude Desktop integration test + distribution signing + v0.1.0 tag | 2 days | Week 7–8 |

**Total: ~8 weeks, ~20 dev-days.** The VAZIR HUD reduces Week 2–3 effort significantly — it's already built; it's a port not a build.

---

## Consequences

**Easier:**
- **Single download = complete product.** Users who download Maxim Studio get Claude Code plugin + all 7 MCP servers + Studio GUI in one wizard. Zero manual plugin steps.
- **Zero first-session MCP latency.** Studio pre-installs `node_modules` for all 7 MCP servers during setup. Users never see the "MCP servers installing, please restart" banner.
- Desktop-native distribution (Tauri 2) targets Windows, macOS, Linux from one codebase
- shadcn/ui stack matches landing-page's existing component system — design reuse is free
- 21.8k-star upstream brings market-validated UX patterns without greenfield UX cost
- AGPL-3.0 on Studio binary creates no legal obligation for the BSL-1.1 plugin
- Pack catalog is always current — no Studio release needed when new packs ship
- License indicator gives users real-time visibility into their tier — reduces support tickets

**Harder:**
- Fork maintenance: upstream opcode changes must be periodically merged (common Tauri community pattern; manageable at v0.2 maturity)
- AGPL compliance requires that any modifications to the Studio shell (not the plugin) be source-available — standard open-source practice, no material impact given the plugin is already source-available under BSL
- Two separate release pipelines: plugin (github.com/DrNabeelKhan/maxim) and Studio (github.com/DrNabeelKhan/maxim-studio). Each has its own versioning, CHANGELOG, and CI.

**Locks us into:**
- AGPL-3.0 for the Studio shell. Changing the Studio license (e.g., to a proprietary desktop license) would require either re-licensing from all contributors (infeasible after fork grows) or a clean-room rebuild. This is an acceptable lock-in because the Studio's value is distribution, not code secrecy.
- opcode's Tauri 2 + Bun + React 18 + SQLite stack. Migrating off Tauri (e.g., to Electron or Flutter) would be a near-total rewrite. Tauri 2 is actively maintained and has strong community momentum.

---

## Alternatives Considered

**Alternative 1 — Build a web dashboard (maxim.isystematic.com/dashboard)**

A browser-based dashboard served from Vercel, talking to the MCP servers via a
WebSocket bridge.

Rejected because: MCP servers run over stdio — bridging to a browser requires an
additional local proxy process. opcode already solved this with Tauri's native IPC.
A web dashboard adds a non-trivial backend component (auth, WebSocket relay, session
state) that Tauri eliminates. Web-first also loses the filesystem-access advantage
(reading agent DNA, pack content, session memory from disk without an API layer).

**Alternative 2 — Build Maxim Studio from scratch using Tauri 2**

Clean-room implementation, BSL-1.1 from day one, no AGPL dependency.

Rejected because: opcode's 3,000+ lines of session browser, MCP manager, and
CLAUDE.md editor represent 6–8 weeks of validated engineering. Rebuilding it
clean-room to avoid AGPL costs more than the AGPL license constraint is worth.
The AGPL constraint on a local desktop tool distributed to paying users is
effectively zero-friction: users download and run the binary, AGPL does not require
source disclosure for binary distribution to end-users as long as source is available
on request (and it is, publicly on GitHub).

**Alternative 3 — Ship a VS Code extension**

A VS Code extension that surfaces the Executive Dispatch, pack catalog, and license
indicator in VS Code's sidebar.

Rejected because: VS Code extension APIs do not provide equivalent isolation from
the host editor. The Claude Code TUI and VS Code are different products; users who
use Maxim via Claude Code's CLI won't be in VS Code. opcode's desktop-app approach
matches Claude Code's own distribution model.

**Alternative 4 — Maxim Studio as a paid product (proprietary license)**

Charge separately for Studio; make it proprietary, not AGPL.

Rejected because: Studio's value is distribution and discovery, not IP protection.
Gating the Studio behind payment adds a second purchase decision before the user
can evaluate Maxim's actual moat (which lives in the plugin). The acquisition strategy
is: Studio free → user sees moat → user buys pack. Charging for Studio breaks step 1.
The plugin's BSL-1.1 already protects revenue through runtime gating.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
