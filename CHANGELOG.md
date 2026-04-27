# Maxim — Changelog

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

All notable changes to Maxim land here. The format follows [Keep a Changelog](https://keepachangelog.com/), and Maxim adheres to [Semantic Versioning](https://semver.org/).

Releases are cut from `main` and tagged `vX.Y.Z`. Pre-release tags (`v1.1.0-rc.1`) are used for public release candidates; nothing pre-release ships to the free-tier marketplace.

---

## v1.0.0 — 2026-04-27 — Launch Bug-Bash (install path verified end-to-end)

Single live macOS install (alsalman's MacBook, accessed via Tailscale SSH) surfaced and resolved five blocker bugs that local Windows structural tests could not catch. **Plugin install is now end-to-end verified working** on a real Mac. Anthropic community marketplace submission still pending operator action.

### Fixed (in order of discovery)

- **BUG-001 · marketplace.json schema** — base `maxim` plugin entry's `source: "../"` was rejected by the marketplace validator. Switched to `git-subdir` form (commit `8a82be1`).
- **BUG-002 · slash commands not registering** — 34 of 38 `mxm-*.md` files lacked YAML frontmatter; Claude Code's loader silently skips command files without a `description:` field. Added frontmatter to all 34 (commit `c4e93f0`).
- **BUG-003 · "permission denied" on bootstrap scripts** — every `.sh` in the repo (60 files: 7 hooks + 6 bootstrap + 8 distribution mirrors + others) was tracked as `100644`. Set exec bit on all (commit `e3d6008`).
- **BUG-004 · MCP server timeout on first install** — MCP servers are Node packages with `node_modules/` gitignored; nothing installs deps automatically. Added `bootstrap/mxm-mcp-install.{sh,ps1}` and wired auto-run into SessionStart hook (commit `82385c9`). README now documents Node.js as a hard prerequisite (commit `4b7fcd2`).
- **BUG-005 · only 1% of plugin files materialized on disk** — `git-subdir` source with `path: "."` triggered Claude Code's plugin loader to apply a `/*` + `!/*/` sparse-checkout filter, excluding every directory. Of 917 tracked files, only 8 root-level files installed. Switched maxim's source to `url` form which performs a full clone (commit `cee9aa6`).

### Added (alongside the fixes)

- **`bootstrap/mxm-mcp-install.{sh,ps1}`** — per-MCP-server `npm install` runner with sentinel-based skip-on-subsequent-sessions
- **Hardened `bootstrap/mxm-community-packs.sh`** — picks best-available JSON parser (`jq` → `python3` → `python` → `node`), fixes subshell counter bug via tempfile, adds `git`-on-PATH check
- **README prerequisites block** — explicit Node.js requirement with verification commands and macOS install instructions
- **`documents/ledgers/BUG_TRACKER.md`** — first 5 entries (BUG-001..BUG-005) with full repro, root cause, fix, regression guard. PATTERN-01 added: cross-platform structural assumptions.
- **`documents/ledgers/DEBUGGING_PLAYBOOK.md`** — §1 entry capturing the meta-pattern: structural tests passing while live install fails. Methodology and transferable lesson documented.

### Adjacent landings (separate from the bug-bash but in the same window)

- **ADR-012 Maxim Overlay Engine** — published. Architectural commitment to apply Maxim's behavioral / compliance / confidence layers to every Claude Code plugin via the four hook interception points. INDEX bumped to 8 published ADRs.
- **MOAT-07** — "Operator agents behind vertical compliance overlays" added to MOAT_TRACKER. Mechanism: Social Learning Theory (Bandura, 1977).
- **`/giveaway` page** — full Early Adopter Program: 300 licenses, $540K value, 13 cohorts, application flow via `/contact`.
- **`/early-adopters` opt-in public wall** — skeleton ships empty; populates as approvals land.
- **Per-page Open Graph images** — root `/opengraph-image` (three-layer moat stack) and `/giveaway/opengraph-image` (terminal session showing Maxim governing a Claude session).
- **Hero CTA flip** — install command + giveaway CTA primary; pricing demoted to tertiary link.
- **Header nav reorder** — Why → Docs → Frameworks → Giveaway (red accent) → Pricing.
- **Worker `/contact`** — accepts two new subjects (`early-adopter-application`, `early-adopter-inquiry`), routes them to a dedicated KV key prefix.
- **Domain expansion roadmap** — `FRAMEWORK_ROADMAP.md` v1.1 expanded with v1.3 (RevOps domain + AI Governance frameworks), v1.4 (Regulated Industries operator roster + Fintech), v1.5 (Cinematic / Video-AI Production).

### Known carry-over

- Anthropic community marketplace submission at `clau.de/plugin-directory-submission` — pending operator action; payload prepared.
- Live `$1` Stripe smoke test — pending operator action.
- Founder bio in `landing-page/components/FounderBlock.tsx` — placeholder text remains.
- Cloudflare API token shared earlier in chat — should be revoked.
- macOS-install CI hardening — v1.1 hardening item; would have caught BUG-003/004/005 before users.

---

## v1.0.0 — 2026-04-21 — First Public Release

**Positioning.** The behavioral intelligence layer for Claude. Every output cites a mechanism. Every session runs drift detection. Every commit enforces Documents as Executable Contracts.

**License.** Business Source License 1.1 (converts to Apache 2.0 exactly 4 years after each release per ADR-005).

### Added

- **88 specialist agents** across 7 executive offices (CEO, CTO, CMO, CSO, CPO, COO, CINO) and orchestrators. Dispatch via `executive-router` or explicit `/mxm-{office}` command. See `documents/ledgers/AGENT_SKILL_INVENTORY.md`.
- **34 domain skills** under `.claude/skills/`. Behavioral intelligence layer merges Maxim frameworks with community-pack skills when both match a domain. See `documents/reference/SKILLS_MAP.md`.
- **38 slash commands** under `.claude/commands/mxm-*.md`. See `documents/reference/MXM_COMMAND_MAP.md`.
- **7 MCP servers (47 tools)** under `mcp/`: `mxm-behavioral`, `mxm-compliance`, `mxm-context`, `mxm-memory`, `mxm-portfolio`, `mxm-catalog`, `mxm-voice`. See `mcp/README.md`.
- **14 hook scripts** (7 hooks × 2 platforms) under `.claude/hooks/` covering session start/end, pre-commit secret scan, behavioral-moat drift, git-hygiene pre/postamble, and junction guard.
- **64 behavioral frameworks** cataloged in `documents/reference/FRAMEWORKS_MASTER.md`, used across every skill.
- **14 compliance frameworks** enforced by the `mxm-compliance` MCP (GDPR, PIPEDA, PCI-DSS, SOC2, HIPAA, UAE-PDPL, CASL, FINTRAC, EU AI Act, ISO 27001, ISO 13485, ISO 14971, NIST CSF, WCAG 2.1).
- **11 Architecture Decision Records** in `documents/ADRs/`. ADR-001 through ADR-011 cover dispatch architecture, Executable Contracts, Worker licensing, free-tier spec, IP protection, External Content Boundary, Behavioral Moat Framing, Community Pack System, pack architecture, Confidence Tag rubric, and Stripe-primary payment processor.
- **Three-tier freemium model** (see ADR-009 and `documents/guides/PACKS.md`):
  - **Starter** — $0 forever, fully functional.
  - **Pro Trial** — 90 days, auto-activated on install.
  - **Paid packs** — Solo $19.99/mo (MOAT anchor) → Pro $39 → Professional $99 → Team $249 (5 seats) + 4 vertical overlays (Healthcare $249, Legal $199, Fintech $199, GovTech $149).
- **Pack engine** (Go binary, `pack-engine/`) — local tier resolver, quota enforcement, machine fingerprint binding for paid JWTs.
- **Cloudflare Worker** (`cloudflare-worker/`) — RS256 JWT issuance, Stripe webhook handler, KV license store. Deployed at `maxim-license-api.isystematic.workers.dev`.
- **Three-layer .brand-foundation** system (`.brand-foundation/`) — Maxim base voice, operator overlay, per-startup overlay. Loading protocol in `CLAUDE.md`.
- **Proactive Watch** — 10 drift classes scanned on every session start. See `composable-skills/frameworks/proactive-watch.md`.
- **Session-end 9-document closure bundle** ratified by ADR-002. See `CLAUDE.d/protocols.md`.

### Repository layout

The v1.0.0 repo root is intentionally minimal. Only load-bearing or
hard-convention files remain at root. All reference documentation is filed
under `documents/` subfolders so the root tells an immediate story:

- **Root (6 docs + 6 ledgers + CLAUDE.d):** `README.md`, `LICENSE`,
  `CHANGELOG.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `CLAUDE.project.md`,
  `BUG_TRACKER.md`, `documents/ledgers/MOAT_TRACKER.md`, `documents/ledgers/DEBUGGING_PLAYBOOK.md`,
  `documents/ledgers/AGENT_SKILL_INVENTORY.md`, `documents/ledgers/SESSION_CONTINUITY.md`,
  `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md`, `CLAUDE.d/`.
- **`documents/guides/`:** `ABOUT.md`, `HELP.md`, `GETTING_STARTED.md`,
  `BSL-FAQ.md`, `PACKS.md`.
- **`documents/reference/`:** `MXM_INSTALL.md`, `MXM_COMMAND_MAP.md`,
  `MXM_HEALTHCHECK.md`, `MXM-SKILL-SPEC.md`, `AGENTS.md`, `SKILLS_MAP.md`,
  `FRAMEWORKS_MASTER.md`, `FRAMEWORK_USES.md`.
- **`documents/governance/`:** `ETHICAL_GUIDELINES.md`.
- **`documents/cross-surface/`:** `maxim-project-instructions.md`,
  `maxim-surface-guide.md`.
- **`documents/templates/`:** `CLAUDE.project.TEMPLATE.md`.
- **`config/`:** `mempalace.yaml`, `entities.json` (config artifacts).

### Engineering Lineage

Maxim is the first public release of work that was developed internally over the 37 days preceding 2026-04-21. The internal codebase and its prior version history are preserved privately and are not imported. Commit history in this repository begins at v1.0.0.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
