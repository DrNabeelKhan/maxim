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

## Sprint plan (8 weeks, ~17 dev-days)

| Week | Focus | Key output |
|---|---|---|
| 1 | Fork + clean build + AGPL compliance audit | Local build running, LICENSE.md clear |
| 2 | Rebrand chrome | Maxim logo, splash, color palette, window title |
| 3–4 | Executive Dispatch + Agent Roster sidebar | 7-office map, 90-agent list with DNA grades |
| 5 | Pack Catalog + License Bar | Dynamic pack tiles, tier indicator, Upgrade CTA |
| 6 | Proactive Watch + MemPalace search | 11-class tiles, memory search via MCP |
| 7 | Voice Config + confidence tag overlay | Engine picker, persona routing, 🟢🟡🔴 badges |
| 8 | MOAT Tracker + Framework Library + Studio tab | Positioning feed, 64-framework browser, cinematic |
| 8 | QA + release pipeline + v0.1.0 tag | GitHub Release, update maxim.isystematic.com/studio |

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
