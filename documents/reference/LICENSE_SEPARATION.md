# Maxim License Separation Architecture

> Copyright (c) 2026 iSystematic Inc. Maxim product.
> This document is the authoritative statement of how Maxim's three-layer
> commercial architecture maintains license separation between the AGPL-3.0
> Studio shell, the BSL-1.1 plugin, and the proprietary Cloudflare Worker.

| Version | Date | Status |
|---|---|---|
| 1.0 | 2026-05-13 | ACCEPTED — ratified alongside ADR-014 |

---

## The three independent works

### Work 1 — Maxim Studio (AGPL-3.0)

**What it is:** A desktop GUI shell forked from opcode (winfunc/opcode, AGPL-3.0).
Tauri 2 + React 18 + TypeScript. A thin client that reads local plugin state and
renders it visually.

**License:** GNU Affero General Public License v3.0

**Source available at:** `github.com/DrNabeelKhan/maxim-studio` (public)

**Contains:**
- UI components, application shell, SQLite session database
- Maxim branding (trademark used by permission; fair use for attribution)
- **First-run installer wizard** that orchestrates: Claude Code detection → plugin
  marketplace registration → plugin install (`claude plugin install maxim@maxim-packs`)
  → MCP node_modules pre-installation → verification. The wizard runs `claude` CLI
  commands as child processes; it does NOT bundle the plugin source code.
- Logic to read `~/.claude/plugins/installed_plugins.json`
- HTTP client calling the Cloudflare Worker `/validate` endpoint
- `window.open()` calls to `maxim.isystematic.com/pricing` (browser handoff)

**Does NOT contain:**
- Any Maxim agent DNA (`.md` files from `agents/MXM/**`)
- Any framework SKILL.md content
- Any pack SKILL.md content
- Any license-gate logic (`license-gate.mjs` or derivatives)
- Any JWT signing/verification keys
- Any Stripe API keys or webhook secrets
- Any pack encryption keys (Phase B, future)

**AGPL obligations fulfilled:** Studio source is publicly available on GitHub. Any
modifications to the Studio shell distributed to users must be source-available under
AGPL. iSystematic Inc. fulfills this by publishing the full Studio source on GitHub
and accepting AGPL-compliant contributions.

**AGPL network-use clause:** AGPL's network-use provision applies when software is
run as a network service accessible to users. Maxim Studio is a local desktop
application installed and run on the user's own machine. Users are not accessing Studio
over a network — they are running it locally. The network-use clause does not trigger
for local desktop software. iSystematic Inc. does not operate Studio as a hosted
service; it distributes a binary that users run locally. Accordingly, AGPL's
network-use extension creates no disclosure obligation beyond the public GitHub source.

---

### Work 2 — Maxim Plugin (BSL-1.1)

**What it is:** A Claude Code plugin installed via `claude plugin install`. 91 agents,
78 frameworks, 14 compliance frameworks, 9 MCP servers (95 tools), 48 slash commands.

**License:** Business Source License 1.1

**Source available at:** `github.com/DrNabeelKhan/maxim` (public)

**Converts to:** Apache 2.0, four years after each release date (ADR-005)

**Contains:**
- All agent DNA (`agents/MXM/**`)
- All framework SKILL.md files (`composable-skills/frameworks/**`)
- All pack SKILL.md content (`packs/**`)
- MCP server implementations (`mcp/**`)
- License-gate middleware (`mcp/_shared/license-gate.mjs`)
- Bootstrap scripts, hooks, skills, commands

**Does NOT contain:**
- JWT signing keys (live in Cloudflare Worker secrets)
- Stripe API keys (live in Cloudflare Worker secrets)
- Pack encryption keys (Phase B, live in Cloudflare KMS, future)

**BSL-1.1 terms:** Free for personal, internal, and non-production use. Production
deployments and commercial use require a paid license. Source is fully visible; value
is gated at runtime by the MCP license middleware, not by code obfuscation.
Automatically converts to Apache 2.0 four years after each release date.

---

### Work 3 — Cloudflare Worker (Proprietary)

**What it is:** The serverless license issuance and validation API.
Live at `https://maxim-license-api.isystematic.workers.dev`.

**License:** All Rights Reserved. Proprietary. iSystematic Inc.

**Source:** NOT published. Deployed as a Cloudflare Workers binary from private
source at `cloudflare-worker/` (source-available to iSystematic Inc. only).

**Contains:**
- JWT RS256 signing key (Cloudflare Worker secret)
- Stripe API key and webhook secret (Cloudflare Worker secrets)
- License issuance logic, tier → grant mapping
- KV namespaces: LICENSES, RATE_LIMIT, CONTACT_SUBMISSIONS
- Business logic for tier selection, Pro Trial enforcement, revocation

---

## Why these are separable works (AGPL + BSL coexistence)

AGPL-3.0's copyleft extends to derivative works and to software accessed over a
network. It does NOT extend to independent programs that communicate via a protocol
boundary. The AGPL FAQ (gnu.org/licenses/agpl-gpl-v3-comparison.html) confirms:
programs that interact at arm's length via standard protocols are not combined works.

**Maxim Studio ↔ Maxim Plugin interaction:**

```
Studio process  —stdio/IPC—►  Plugin's MCP servers (spawned as child processes)
```

This is identical to how Claude Code communicates with the MCP servers. Claude Code
is not AGPL; the MCP servers are not AGPL. The communication is over a named protocol
(Model Context Protocol, a standard HTTPS/stdio interface). These are independent
programs communicating at arm's length, not a combined work.

**Maxim Studio ↔ Cloudflare Worker interaction:**

```
Studio process  —HTTPS—►  Cloudflare Worker (maxim-license-api.isystematic.workers.dev)
```

A web API call over HTTPS is the canonical "arm's length" interaction. The Worker is
a separate program deployed on a separate server (Cloudflare's infrastructure). AGPL
does not propagate through HTTPS API calls.

**Conclusion:** Maxim Studio (AGPL-3.0), the Maxim plugin (BSL-1.1), and the
Cloudflare Worker (proprietary) are three independent works with protocol-boundary
interactions. AGPL copyleft does not propagate from Studio to the plugin or Worker.
BSL-1.1 does not extend to the Studio or Worker. The proprietary Worker license does
not affect the Studio or plugin.

---

## Revenue protection

Maxim's revenue flows exclusively through the Cloudflare Worker:

```
User decides to upgrade
  → opens browser to maxim.isystematic.com/pricing (Stripe-hosted checkout)
  → Stripe processes payment, fires webhook to Worker
  → Worker issues paid-tier JWT, stores in LICENSES KV
  → Plugin's license-gate.mjs validates JWT on every MCP tool call
  → Paid features unlock at the MCP layer
  → Studio reflects tier change on next /validate heartbeat
```

**The Studio has no payment path of its own.** It opens a browser URL. The browser
handles all payment interaction. The Studio never sees card data, Stripe tokens, or
webhook payloads. PCI-DSS scope for Maxim Studio = zero.

The JWT validation chain (`license-gate.mjs` → Worker `/validate`) runs inside the
BSL-1.1 plugin, not the AGPL Studio. Even if someone modified the Studio binary, they
could not bypass license validation — the gate is in the plugin, not the Studio.

---

## Moat protection

Maxim's moat (agent DNA, behavioral frameworks, compliance logic) lives in the BSL-1.1
plugin. The Studio reads it from disk; it does not own it.

| Moat asset | Location | License | Studio access |
|---|---|---|---|
| 90 agent .md files | `~/.claude/plugins/cache/maxim-packs/maxim/<v>/agents/` | BSL-1.1 | Read-only from disk |
| 64 framework SKILL.md files | `~/.claude/plugins/cache/maxim-packs/maxim/<v>/composable-skills/` | BSL-1.1 | Read-only from disk |
| 14 compliance frameworks | `mxm-compliance` MCP server | BSL-1.1 | Via MCP tool call |
| MOAT_TRACKER.md | `<project>/documents/ledgers/MOAT_TRACKER.md` | Operator-owned per project | Read-only from disk |
| License-gate logic | `mcp/_shared/license-gate.mjs` | BSL-1.1 | NOT accessible to Studio |
| JWT signing key | Cloudflare Worker secret | Proprietary | NEVER exposed |
| Pack SKILL.md | `~/.claude/plugins/cache/maxim-packs/<pack>/<v>/` | Proprietary | Read-only from disk |

Even under AGPL, a Studio contributor who receives the Studio source code receives
ONLY the AGPL shell — not the BSL plugin content, not the Worker, not the JWT keys.
The moat remains intact.

---

## Copyright in the Studio binary

Maxim Studio is a fork of opcode (Copyright 2025 winfunc and contributors).
The Studio binary carries two copyright notices:

```
Maxim Studio
Portions copyright (c) 2025 winfunc and contributors (AGPL-3.0)
Modifications copyright (c) 2026 iSystematic Inc. (AGPL-3.0)
```

The Maxim trademark, logo, and brand assets used in the Studio are the property of
iSystematic Inc. and are used under the trademark owner's permission. Trademark rights
are independent of copyright license. A Studio fork (permitted under AGPL) may not
use the Maxim name, logo, or brand assets without iSystematic Inc.'s written permission.

---

## Recommended notice in Studio's About dialog

> Maxim Studio v{version}
>
> Copyright (c) 2026 iSystematic Inc.
> Portions copyright (c) 2025 winfunc and contributors.
>
> Maxim Studio is open source software licensed under the GNU Affero General Public
> License v3.0. Source: github.com/DrNabeelKhan/maxim-studio
>
> The Maxim plugin (BSL-1.1) and Cloudflare license API (proprietary) are separate
> works. Moat, revenue, and IP protections are described at:
> maxim.isystematic.com/studio/license

---

<sub>Copyright (c) 2026 iSystematic Inc. This document is part of the Maxim product's
governance architecture. It is source-available under BSL-1.1 (converts to Apache 2.0
four years after publication). It does not constitute legal advice. iSystematic Inc.
recommends external counsel review before the Studio's first public release.</sub>
