# Maxim Studio — Architecture Reference

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
> This document covers the design of Maxim Studio (AGPL-3.0 desktop shell).
> The Studio is a separate product from the Maxim plugin (BSL-1.1).

| Version | Date | Status |
|---|---|---|
| 0.1 | 2026-05-13 | PLANNING — pre-fork |

Authoritative decision: `documents/ADRs/ADR-014-maxim-studio-agpl-shell.md`
License architecture: `documents/reference/LICENSE_SEPARATION.md`

---

## Two modes: Studio + Mission Control

Maxim Studio ships with two modes switchable from the top bar:

```
┌── Top Bar ──────────────────────────────────────────────────────────┐
│  Maxim Studio  ·  [Studio ▶]  [Mission Control ▶]  ·  v1.1.2  🟢  │
└─────────────────────────────────────────────────────────────────────┘
```

**Studio mode** (default): opcode-derived desktop UI — agent roster, pack catalog,
license bar, Proactive Watch panel, MemPalace search, Executive Dispatch.

**Mission Control mode**: real-time AI operations interface ported from the VAZIR
AI Agent HUD (`hud_app.jsx` + `tweaks-panel.jsx` + `AI Agent HUD.html`). All VAZIR
HUD functionality preserved; reskinned in Maxim design language (not VAZIR OPS skin).
Persona-driven voice conversation, live Proactive Watch alerts as priority queue,
full-screen focus overlays for agent outputs.

---

## Dual-surface support: Claude Code CLI + Claude Desktop

Both surfaces use identical MCP stdio protocol + `mcpServers` JSON key.
Studio installer writes to both config files during setup.

```
~/.mxm-studio/maxim/<version>/mcp/   ← extracted MCP servers

Writes:
  ~/.mcp.json                                          ← Claude Code CLI
  %APPDATA%\Claude\claude_desktop_config.json          ← Claude Desktop (Win)
  ~/Library/Application Support/Claude/claude_desktop_config.json  ← Claude Desktop (Mac)

MCP tools work in both. Slash commands work in Claude Code CLI only.
```

Confirmed on operator's machine: VAZIR MCP already in Claude Desktop config.
Format: `{ "mcpServers": { "<name>": { "command": "...", "args": [...] } } }`

---

## Distribution model (corrected 2026-05-13)

**Maxim Studio is the single install path.** Users download Studio; Studio
installs everything else. No separate plugin install step.

```
User downloads Maxim Studio
  ─────────────────────────────────────────────────────────────────────
  First-run wizard (Tauri window, React UI):

  Step 1  Detect Claude Code
          ┌ claude binary found in PATH ─── ✅ continue
          └ not found ─────────────────────── show link + poll until installed

  Step 2  Register marketplace
          run: claude plugin marketplace add DrNabeelKhan/maxim
          ┌ already registered ──────────── ✅ skip
          └ registered now ───────────────── ✅ continue

  Step 3  Install base plugin
          run: claude plugin install maxim@maxim-packs
          ┌ already installed ───────────── ✅ skip
          └ installing... (progress bar) ─── ✅ continue

  Step 4  Pre-install MCP node_modules (7 servers)
          For each ~/.claude/plugins/cache/maxim-packs/maxim/<v>/mcp/mxm-*/:
            run: npm install
          Shows: "Installing MCP servers... 3 / 7"
          ┌ node_modules already present ── ✅ skip
          └ installing... ──────────────── ✅ pre-warms (no restart needed)

  Step 5  Verify all 7 MCPs ready
          Check node_modules presence + package.json valid for each server
          ┌ all 7 ready ──────────────────── ✅ show Ready screen
          └ any failed ──────────────────── show error + retry button

  Step 6  Ready screen
          "Maxim Studio is ready."
          [Open a project ▶]   [See what's installed ▶]
  ─────────────────────────────────────────────────────────────────────

  Subsequent launches: wizard is skipped; Studio opens directly to project view.
  Plugin updates: Studio's "Check for updates" runs /mxm-self-update equivalent.
```

---

## System boundary diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Maxim Studio (AGPL-3.0)  —  github.com/DrNabeelKhan/maxim-studio       │
│  Tauri 2 + React 18 + TypeScript + Vite 6 + Tailwind v4 + shadcn/ui     │
│  SQLite session DB  ·  bun runtime                                        │
│                                                                           │
│  READS (local filesystem):                                                │
│    ~/.claude/plugins/installed_plugins.json    (installed packs)          │
│    ~/.claude/plugins/cache/maxim-packs/maxim/  (plugin content)           │
│    ~/.claude/plugins/cache/maxim-packs/*/      (pack content, per pack)   │
│    ~/.claude/projects/*/                        (Claude Code session DBs) │
│    ~/.mxm-packs/owner.key                      (owner bypass key)         │
│    <project>/.claude-sessions-memory/          (session memory)           │
│    <project>/.mxm-skills/                      (skill gaps, handoffs)     │
│    <project>/documents/ledgers/MOAT_TRACKER.md (moat registry)            │
│    <project>/config/project-manifest.json      (topology, compliance)     │
│                                                                           │
│  CALLS (MCP over stdio, same as Claude Code):                             │
│    plugin:maxim:mxm-portfolio   (sync_portfolio, project metrics)         │
│    plugin:maxim:mxm-memory      (MemPalace search, session history)       │
│    plugin:maxim:mxm-catalog     (agent roster, skill/command catalog)     │
│    plugin:maxim:mxm-compliance  (framework check, jurisdiction map)       │
│    plugin:maxim:mxm-behavioral  (behavioral audit, framework dispatch)    │
│    plugin:maxim:mxm-context     (watch_run for Proactive Watch)           │
│    plugin:maxim:mxm-voice       (voice config, persona routing)           │
│                                                                           │
│  CALLS (HTTPS, Worker API):                                               │
│    POST /validate  →  tier + grants + expires_at  (60s heartbeat)        │
│    (no /issue from Studio — JWT managed by plugin, not Studio)            │
│                                                                           │
│  OPENS BROWSER (never inline):                                            │
│    maxim.isystematic.com/pricing?ref=studio  (Stripe checkout)            │
│    github.com/DrNabeelKhan/maxim/issues      (support)                   │
│                                                                           │
│  CONTAINS ZERO:                                                           │
│    ❌ agent DNA (.md files)      ❌ framework SKILL.md content             │
│    ❌ license-gate logic         ❌ JWT signing keys                        │
│    ❌ Stripe keys                ❌ pack encryption keys                    │
└─────────────────────────────────────────────────────────────────────────┘
        │ stdio/IPC                            │ HTTPS
        ▼                                      ▼
┌─ BSL-1.1 Plugin ────┐        ┌─ Cloudflare Worker ──────────┐
│ ~/.claude/plugins/  │        │ maxim-license-api.             │
│  cache/maxim-packs/ │        │   isystematic.workers.dev      │
│                     │        │ /validate → tier + grants      │
│ 90 agents           │        │ /webhook/stripe → JWT issue    │
│ 64 frameworks       │        │ KV: LICENSES, RATE_LIMIT       │
│ 14 compliance       │        │ Secrets: JWT keys, STRIPE_KEY  │
│ 7 MCP servers       │        │ Proprietary (not open-sourced) │
│ Pack SKILL.md       │        └──────────────────────────────┘
│ License gates       │                      │
│ BSL-1.1 licensed    │                      │ Stripe webhook
└─────────────────────┘             ┌─────────────────────┐
                                    │ Stripe (browser-only │
                                    │ from Studio's POV)   │
                                    │ Checkout sessions    │
                                    │ Webhooks → Worker    │
                                    └─────────────────────┘
```

---

## Mission Control mode — VAZIR HUD integration

Source files (from VAZIR handoff, incorporated into Studio repo):

| File | Role in Maxim Studio |
|---|---|
| `AI Agent HUD.html` | Cinematic HUD shell — dark theme, particle network, animated core, gauges, radar, scanlines |
| `hud_app.jsx` | React 18 components: `Conversation`, `PendingTasks`, `FocusOverlay`, `TweaksApp` |
| `tweaks-panel.jsx` | Global settings design system — promoted to Studio-wide (not HUD-only) |

### What changes from VAZIR HUD → Maxim Mission Control

**All VAZIR HUD functionality ships unchanged. Only the visual skin is replaced
with Maxim brand. VAZIR OPS remains the operator's personal interface.**

#### Functional swaps (logic, not design)

```
VAZIR HUD                         →  Maxim Mission Control
─────────────────────────────────────────────────────────────
window.claude.complete({messages}) →  mxm-catalog.route_task({ task, context })
                                       executive router → returns agent + result
                                       routes to right office (CEO/CTO/CMO/CSO/CPO/COO/CINO)

PendingTasks (PENDING_SEED static) →  live data from:
                                       mxm-context.watch_run() → Proactive Watch alerts
                                       mxm-portfolio.get_tasks() → scheduled tasks
                                       Priority: P1=FAIL class, P2=WARN, P3=INFO
                                       Countdown: real ETA from scheduled task timestamps

TTS: Web Speech API (already)      →  NO CHANGE — Web Speech API IS Windows native
                                       SpeechSynthesis = WinRT speech engine (zero install)
                                       SpeechRecognition = Windows Speech Recognition

"VAZIR" HUD persona                →  Maxim persona routing:
                                       VAZIR  → bm_daniel (advisory/decision/risk)
                                       ELARA  → bf_emma  (demo/client/marketing)
                                       RIVA   → af_kore  (product/technical)
                                       JARVIS → bm_george (formal briefing)
                                       Auto-selected from route_task() office response

Focus mode (doc/image/video/file) →  Maxim output focus:
                                       'document' → full-screen agent markdown response
                                       'file'     → full-screen compliance report / ADR
                                       'image'    → full-screen MOAT_TRACKER visualization
```

#### Design skin swap (visual only, all layout/UX preserved)

| VAZIR OPS (personal) | Maxim Mission Control (public) |
|---|---|
| `#040a14` dark navy | Maxim dark `#0a0f1a` (landing-page token) |
| `#6ee7ff` cyan / `#ffb464` amber | Maxim accent palette from `.brand-foundation/personal/` |
| Particle network + rotating core sphere | Maxim orbital: 7-office rings around center node |
| Scanlines + film grain CRT | Clean — purposeful motion only (no CRT effects) |
| Major Mono Display + JetBrains Mono | Space Grotesk + JetBrains Mono (landing-page match) |
| "VAZIR · Cognitive Operations Interface" | "Maxim · Mission Control" |
| "Operator" / "VAZIR · Response" | "You" / "[Agent] · [Office]" |
| Cyan glow alerts | 🟢🟡🔴 confidence tags as primary status language |

3-panel layout, word-by-word TTS highlight, mic waveform, focus overlay,
pending queue, and tweaks panel all unchanged structurally.

### tweaks-panel.jsx — promoted to Studio-wide design system

`tweaks-panel.jsx` is not just the HUD settings — it becomes Maxim Studio's
reusable control library across all tabs:

```
Studio Voice Config tab    → TweakRadio (engine), TweakSlider (rate/pitch), TweakToggle (enabled)
Proactive Watch settings   → TweakToggle (class enable/disable), TweakSlider (polling interval)
Theme settings             → TweakColor (palette), TweakSlider (particle density, if HUD mode)
Pack Catalog filters       → TweakRadio (tier filter: L1/L2/L3), TweakToggle (show locked)
Studio Layout settings     → TweakToggle (show license bar), TweakRadio (default mode)
```

The `useTweaks(defaults)` hook persists settings to `~/.mxm-studio/preferences.json`
(replaces `window.__edit_mode_set_keys` postMessage with Tauri `invoke('save_prefs', edits)`).

---

## Pack catalog — dynamic loading mechanism

Pack state is a pure function of three data sources read at runtime. No compilation step.

```
State = f(installed_plugins, worker_grants, marketplace_json)

installed_plugins:
  Source: ~/.claude/plugins/installed_plugins.json
  Refresh: file-watcher (debounced 500ms)
  Provides: which packs are installed, version, install path

worker_grants:
  Source: POST /validate { jwt } → { tier, grants[] }
  Refresh: 60-second heartbeat; immediate on JWT change
  Provides: which features are unlocked for the current JWT

marketplace_json:
  Source: ~/.claude/plugins/cache/maxim-packs/.claude-plugin/marketplace.json
  Refresh: file-watcher
  Provides: full catalog of available packs (name, version, description, price URL)

Pack card states:
  INSTALLED + UNLOCKED   → green badge, features listed, uninstall CTA
  INSTALLED + LOCKED     → amber badge, feature preview only, Upgrade CTA → browser
  NOT INSTALLED          → ghost card, Install + Upgrade CTA → browser
  NOT IN MARKETPLACE     → hidden (no stale cards for retired packs)
```

**Adding a new pack (e.g., L1.7) requires zero Studio changes.** The pack appears
in marketplace.json at plugin publish time. Studio renders it automatically on next
file-watcher event.

---

## License bar — real-time JWT state

Rendered in the Studio's persistent footer bar. Data source: Worker /validate response.

```
┌── License Bar ─────────────────────────────────────────────────────────────┐
│  Tier: Pro Trial  ·  Grants: 24  ·  Expires: 2026-07-26 (72 days)  ·  🟢  │
│                                                              [Upgrade Pack] │
└────────────────────────────────────────────────────────────────────────────┘

States:
  🟢 Valid JWT, tier known
  🟡 JWT expiring in ≤ 14 days → "Renewing soon" nudge
  🔴 JWT expired or invalid → "License expired" with /validate retry
  ⚪ No JWT (offline, or pre-first-session) → "Starter (offline)"
  🔵 Owner key detected (~/.mxm-packs/owner.key) → "Owner mode"
```

---

## Voice configuration tab (ADR-014 + session 18 operator directive)

Voice engine is user-configurable per ADR-014. Studio surfaces this as a Settings tab.

```
Voice Settings
  Engine: ● Platform Native (recommended)  ○ Whisper + Kokoro  ○ Custom
  
  Platform Native (zero install):
    Windows → Windows Speech Recognition + Windows.Media.SpeechSynthesis (WinRT)
    macOS   → SFSpeechRecognizer + AVSpeechSynthesizer (AVFoundation)
    Linux   → falls back to Whisper + Kokoro (native APIs unavailable)
  
  Whisper + Kokoro (power user):
    STT: faster-whisper (local, model selectable: tiny / base / small / large-v3)
    TTS: kokoro-onnx (local, voice selectable per persona)
  
  Custom:
    Path to VAZIR-voice-setup.md or equivalent config
    Detected automatically at: E:\Projects\nabeelkhan\documents\architecture\VAZIR\VAZIR-voice-setup.md
    (shown only when file exists on local machine)
  
  Persona routing:
    VAZIR  → bm_daniel (British male, calm)
    ELARA  → bf_emma  (British female, warm)
    RIVA   → af_kore  (American female, crisp)
    JARVIS → bm_george (British male, composed)
  
  [Test voice ▶]   [Save]
```

The VAZIR custom voice config is PERSONAL — it shows only when the file exists locally.
It is never bundled into the Studio binary or published to any remote.

---

## Proactive Watch panel — 11 drift classes as live tiles

Data source: `mxm-context.watch_run()` MCP tool call on panel open + 5-minute refresh.

```
┌── Proactive Watch ─────────────────────────────────────────────────────────┐
│  Last run: 2 min ago  ·  Drift: 2  ·  Errors: 0  ·  [Run now]            │
│                                                                             │
│  ✅ Class 1: Inventory          ✅ Class 5: Orphan refs                    │
│  ✅ Class 2: Version            ✅ Class 6: Dependencies                   │
│  🟡 Class 3: Contract  1 drift  ✅ Class 7: Git hygiene                   │
│  ✅ Class 4: Cross-doc          ✅ Class 8: Compliance drift               │
│  ✅ Class 9: Stale handoff      🟡 Class 11: Surface-claims  1 drift       │
│  ✅ Class 10: Junction                                                      │
│                                                                             │
│  Class 3 — [View detail ▶]                                                 │
│  Class 11 — [View detail ▶]  [Run sync-counts ▶]                          │
└────────────────────────────────────────────────────────────────────────────┘
```

Clicking [Run sync-counts ▶] shells out to `bootstrap/sync-counts.{sh,ps1}` in the
detected project root. Result shown inline. No manual terminal needed.

---

## Executive Dispatch sidebar

Visual representation of the 7-office routing model. Click any office to pre-fill
a task prompt and route it through Claude Code's IPC.

```
┌── Executive Dispatch ──────────────────────────────────┐
│                                                         │
│  CEO ──► enterprise-architect                           │
│          9 agents · strategy + finance + EA             │
│                                                         │
│  CTO ──► implementer                           [↗ /mxm-cto] │
│          25 agents · engineering + AI + DevOps          │
│                                                         │
│  CMO ──► content-strategist                    [↗ /mxm-cmo] │
│          15 agents · marketing + brand + SEO            │
│                                                         │
│  CSO ──► security-analyst  ⚠ AUTO-LOOP        [↗ /mxm-cso] │
│          9 agents · security + compliance               │
│                                                         │
│  CPO ──► product-strategist                    [↗ /mxm-cpo] │
│  COO ──► planner                               [↗ /mxm-coo] │
│  CINO──► innovation-researcher                 [↗ /mxm-cino]│
│                                                         │
│  [↗] opens slash command in Claude Code TUI             │
└─────────────────────────────────────────────────────────┘
```

---

## Tech stack (forked from opcode)

| Layer | Technology |
|---|---|
| Application shell | Tauri 2 (Rust core, cross-platform) |
| Frontend framework | React 18 |
| Language | TypeScript |
| Build tool | Vite 6 |
| Styling | Tailwind CSS v4 |
| Component library | shadcn/ui (matches landing-page stack) |
| Local database | SQLite via rusqlite (session history, settings) |
| Package manager | Bun |
| MCP communication | Tauri's sidecar + stdio IPC (same as opcode) |
| Distribution | GitHub Releases: .dmg (macOS) · .msi (Windows) · .AppImage (Linux) |

---

## Sprint plan (8 weeks, ~20 dev-days)

| Week | Focus | Key output |
|---|---|---|
| 1 | Fork + CODEOWNERS + split-bundle installer (plugin extract, dual MCP config write, update checker) | Local build + full install flow working |
| 2 | Rebrand chrome + Mission Control mode (port VAZIR HUD: swap `window.claude.complete` → MCP, wire PendingTasks → Proactive Watch, promote tweaks-panel.jsx) | Studio mode switcher live; HUD functional |
| 3 | Executive Dispatch sidebar + Agent Roster (Studio mode) | 7-office map, 90-agent list |
| 4 | Pack Catalog + License Bar | Dynamic pack tiles, tier + grant indicator |
| 5 | Proactive Watch panel + MemPalace search + Voice Config (HUD TTS verify + Kokoro wiring) | 11-class tiles, memory search, engine picker |
| 6 | MOAT Tracker + Framework Library + Focus mode repurpose (agent output full-screen) | Positioning feed, 64-framework browser |
| 7 | Studio (cinematic) tab + confidence tag overlay | Higgsfield style picker, 🟢🟡🔴 badges |
| 8 | Claude Desktop integration test + distribution code-signing + v0.1.0 tag | .dmg/.msi/.AppImage signed, GitHub Release |

---

## Files NOT in Studio repository

The following must NEVER be committed to `github.com/DrNabeelKhan/maxim-studio`:

```
❌ Any file from agents/MXM/**
❌ Any file from .claude/skills/**
❌ Any file from composable-skills/frameworks/**
❌ Any file from packs/**
❌ mcp/_shared/license-gate.mjs or any derivative
❌ cloudflare-worker/src/** (all Worker source)
❌ cloudflare-worker/grants.json
❌ config/agent-registry.json (plugin-level)
❌ Any file from .brand-foundation/** (personal/operator voice is private)
❌ Any file from documents/ledgers/MOAT_TRACKER.md (read-only from disk, not bundled)
```

If a PR to the Studio repo adds any of the above, it must be rejected.
A CODEOWNERS rule + PR check should enforce this programmatically.

---

<sub>Maxim Studio v0.1 planning document · Copyright (c) 2026 iSystematic Inc. · BSL 1.1 on this doc · AGPL-3.0 on the Studio binary</sub>
