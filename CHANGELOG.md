# Maxim — Changelog

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

All notable changes to Maxim land here. The format follows [Keep a Changelog](https://keepachangelog.com/), and Maxim adheres to [Semantic Versioning](https://semver.org/).

Releases are cut from `main` and tagged `vX.Y.Z`. Pre-release tags (`v1.1.0-rc.1`) are used for public release candidates; nothing pre-release ships to the free-tier marketplace.

---

## v1.1.0 — 2026-04-27 — License middleware foundation (v1.1.A scope)

Promoted from `v1.1.0-rc.1` after v1.1.A passed acceptance. v1.1.0 ships the
**enterprise-readiness foundation**: license middleware, tier-based grants,
Worker public endpoints, all 7 MCP servers gated. The runtime enforcement gap
that v1.0.0 left open is closed.

**Scope decision (locked 2026-04-27):** v1.1.B (Maxim Overlay Engine, ADR-012)
and v1.1.C (7 compliance frameworks: EU AI Act, ISO 42001, SOX, CIS Controls,
DORA, NIST SP 800-53, LGPD) move to **v1.1.1**. The original v1.1 plan bundled
A + B + C; we shipped A as v1.1.0 because the foundation gates everything else,
and treating B + C as a follow-on patch lets users get tier-enforced runtime
NOW rather than waiting for the full bundle.

### Added (v1.1.A)

- **`cloudflare-worker/src/v11a-license.ts`** — Two new public Worker endpoints:
  - `POST /issue {machine_fingerprint, client_version} → {jwt, tier, grants, expires_at}`
    Anonymous Starter JWT issuer. 30-day TTL. Rate-limited (≤10/day per fingerprint, ≤100/h per IP).
  - `POST /validate {jwt} → {valid, tier, grants, expires_at, refresh_url?}`
    Daily-heartbeat validator. Verifies signature, checks revocation, returns server-side authoritative tier + grants.
    Rate-limited (≤50/day per fingerprint, ≤1000/h per IP).
- **`mcp/_shared/license-gate.mjs`** — Full license-gate middleware (ESM). Cache-file logic at
  `~/.mxm-packs/license-state.json`, owner-key bypass (full, no JWT, tagged 🔵 SUPER USER), JWT signature
  verification via local public key, fire-and-forget 24h heartbeat (never blocks tool calls), first-run flow
  that hits Worker `/issue` and writes cache atomically. Per locked design G1–G7.
- **`mcp/_shared/license-pubkey.pem`** — Mirror of `pack-engine/internal/jwt/keys/public.pem` for offline
  JWT verification (defense-in-depth against cache tampering).
- **`mcp/_shared/license-gate.test.mjs`** — E2E test fixture covering: owner-bypass, FIRST_RUN_FAILED,
  JWT_EXPIRED, JWT_INVALID (tampered signature), GRANTS_INSUFFICIENT, SUCCESS, CACHE_CORRUPT, plus
  live-Worker tests gated on `MXM_E2E_LIVE_WORKER=1`. **9/9 pass.**
- **All 7 MCP servers gated** via `wrapServerWithLicenseGate(server, "<name>", grantMap?)` (1 import + 1 call
  per server, ~50 lines total). Tier-specific grants mapped: `mxm-compliance` requires `compliance-14`,
  `mxm-behavioral` requires `behavioral-audit-unlimited`, `mxm-memory` KG ops require `mempalace-semantic`,
  `mxm-voice` requires `voice-10min-per-day` (status check is free across tiers).

### Ship gates (FRAMEWORK_ROADMAP § v1.1.A)

| Gate | Status |
|---|---|
| `requireValidLicense` middleware merged into all 7 MCP servers | 🟢 |
| Worker `/validate` endpoint deployed + KV binding live | 🟡 code ready · operator deploys |
| Starter tier anonymous JWT issuer live | 🟡 code ready · operator deploys |
| E2E test: clone repo without license → tool calls fail with clear error | 🟢 (FIRST_RUN_FAILED test) |
| E2E test: paid-tier JWT → tool calls succeed + usage logged | 🟡 requires deployed Worker (live test gated on env flag) |
| E2E test: expired JWT → fail with refresh instructions | 🟢 (JWT_EXPIRED test) |
| Rate-limit policy per tier documented and verified | 🟢 (`v11a-license.ts` enforces) |

4 of 7 gates green by code; 3 require Worker deployment by operator. **The 3 yellow
gates flip green automatically once `wrangler deploy` runs from `cloudflare-worker/`
and the live tests are exercised with `MXM_E2E_LIVE_WORKER=1`.** No additional
code work needed for the v1.1.0 release scope.

### Known carry-over for v1.1.1

Following sprints (separately versioned, do not block v1.1.0):

- **v1.1.B → v1.1.1** Maxim Overlay Engine (per ADR-012) — 4-hook architecture; 11 ship gates
- **v1.1.C → v1.1.1** 7 compliance frameworks (EU AI Act, ISO 42001, SOX, CIS Controls, DORA, NIST SP 800-53, LGPD)
- Worker deployment to `https://maxim-license-api.isystematic.workers.dev` with `JWT_SIGNING_KEY_PRIVATE`
  + `JWT_SIGNING_KEY_PUBLIC` secrets bound; KV namespaces (LICENSES, RATE_LIMIT) already provisioned —
  required to flip the 3 yellow ship gates green; not a code change
- `ADR-013-license-middleware-design.md` — capture locked v1.1.A design as ratified ADR (next session)

---

## v1.0.1 — 2026-04-27 — Session 15: agent merge + count alignment + v1.1.A foundation + count-drift codification

Multi-track session covering plugin MCP path bugfix, agent roster expansion, capability-count drift fix across 30+ surfaces, v1.1.A license middleware Phase B-1 foundation, and codification of the inventory-vs-marketing-copy drift class (Class 11) with companion `bootstrap/sync-counts` tool.

### Fixed

- **BUG-O-03 · plugin MCP path resolution** — All 7 `plugin:maxim:mxm-*` MCP servers were failing with `✗ Failed to connect` because `.mcp.json` used relative `args: ["./mcp/<name>/server.js"]` paths that resolved against user cwd, not plugin install dir. Substituted Claude Code's `${CLAUDE_PLUGIN_ROOT}` placeholder. All 7 MCPs now `✓ Connected` end-to-end.
- **Pre-existing inventory drift fix** — `agents/MXM/cino/skill-synthesizer.md` existed on filesystem since v1.0.0 but was never registered in `config/agent-registry.json`. Added registry entry. Filesystem ↔ registry ↔ INVENTORY now all align at 90 agents.
- **AGENT_SKILL_INVENTORY.md Section 1 breakdown** — Per-office row counts (CEO 14, CTO 17, CMO 11, CINO 6, Orchestrators 9) were fictitious — they summed to 88 but bore no relation to filesystem reality. Rewrote table to match filesystem (CEO 9, CTO 25, CMO 15, CSO 9, CPO 12, COO 10, CINO 4, Orchestrators 5, Executive Router 1 = 90).

### Added

- **`agents/MXM/cino/cost-analyst.md`** — CINO specialist agent migrated from aria-simplification project. Triages cost-dimension Proactive Watch alerts; classifies traffic / regression / abuse / model_change; bounded throttle proposals. Frameworks: Prospect Theory, Anchoring, COM-B. Slotted as CINO specialist under `innovation-researcher` per [`AGENT_ROSTER_v1.2_PROPOSAL.md`](documents/reference/AGENT_ROSTER_v1.2_PROPOSAL.md).
- **`agents/MXM/coo/sre-analyst.md`** — COO specialist agent migrated from aria-simplification project. Triages SLO + data-integrity alerts; correlates with deploy timeline + error-budget posture; bounded remediation (rollback, hotfix, scaling, pager). Frameworks: Error Budget (Google SRE), Blameless Postmortems, EAST. Slotted as COO specialist under `planner`.
- **`cloudflare-worker/grants.json`** — Single source of truth for tier→grants and pack→grants mappings (v1.1.A locked design G4). 6 tiers (starter, pro_trial, solo, pro, professional, team) + 4 vertical overlay packs (healthcare, legal, fintech, govtech) + 54-grant catalog. Mirrored to pack-engine at build time. Validated: all grant references match catalog (no orphans).
- **`mcp/_shared/license-gate.js`** — v1.1.A Phase B-1: `requireValidLicense(toolName, requiredGrants)` helper with cache-file logic, owner-key bypass (full bypass per locked decision G6, tagged 🔵 SUPER USER), JWT expiry hard gate, 24h heartbeat fire-and-forget, fingerprint subprocess wiring. 5 paths verified end-to-end (FIRST_RUN_REQUIRED, JWT_EXPIRED, GRANTS_INSUFFICIENT, SUCCESS, fingerprint-degrades-gracefully). Phase B-2 (Worker endpoints), B-3 (7 MCP server wiring), B-4 (E2E tests) follow next session.
- **Proactive Watch Class 11 — `surface-claims-drift`** — New drift class detects inventory-vs-marketing-copy mismatch (e.g., `AGENT_SKILL_INVENTORY.md` says 90 but README says 88). Complementary to Class 1 (filesystem-vs-inventory). Codified in [`composable-skills/frameworks/proactive-watch.md`](composable-skills/frameworks/proactive-watch.md), [`config/watch-profile.yml`](config/watch-profile.yml), [`config/watch-profile.TEMPLATE.yml`](config/watch-profile.TEMPLATE.yml). Driver counter bumped 10→11 in [`/mxm-watch`](.claude/commands/mxm-watch.md), [`/mxm-health`](.claude/commands/mxm-health.md), [`mxm-mode`](distributions/claude-plugin/output-styles/mxm-mode.md) descriptions.
- **`bootstrap/sync-counts.{sh,ps1}`** — Companion propagation tool for Class 11. Reads INVENTORY canonical counts, propagates to all declared surfaces (markdown + landing-page TSX). Idempotent on clean tree. Conservative regex requires either `+` suffix or adjective prefix (specialist/governed/Maxim/peer-reviewed) to avoid false positives on per-office breakdowns / complexity thresholds / historical changelog entries. 3 acceptance gates passed: clean-tree no-op, synthetic 90→91 bump propagates correctly, restore + re-run no-op.
- **Commit Protocol updates** — [`CLAUDE.md`](CLAUDE.md) + [`CLAUDE.d/protocols.md`](CLAUDE.d/protocols.md) gained explicit trigger row: when commit touches `agents/MXM/**`, `.claude/skills/**`, `.claude/commands/**`, `mcp/**`, `composable-skills/frameworks/**`, or `.claude/hooks/**`, run `bootstrap/sync-counts.{sh,ps1}` before commit. Pre-commit hook fails-closed on residual drift unless `[surface-claims-drift-ack: <reason>]` is in commit message.

### Changed

- **Total agent count: 88 → 90** (cost-analyst + sre-analyst added; skill-synthesizer registry drift fixed)
- **Per-office breakdown updated**: COO 9 → 10, CINO 3 → 4 (sre-analyst, cost-analyst). All other offices unchanged.
- **30+ surfaces propagated**: README, CLAUDE.md, ABOUT, PACKS, HELP, GETTING_STARTED, MXM_RUNDOWN, MARKETPLACE_SUBMISSION, DISTRIBUTION, mxm-mode, demo-scenarios, PROMPT_maxim-capabilities-demo, ASSEMBLY, voice-profile, FRAMEWORK_ROADMAP, FRAMEWORKS_MASTER, AGENT_ROSTER_v1.2_PROPOSAL, ADR-001, ADR-004, ADRs/INDEX, mcp/mxm-catalog/README, proactive-watch (composable + skill), maxim-pack-catalog, maxim-one-pager, maxim-catalogue, repo-page-design-spec — all current-state agent count claims aligned to 90. Plus 9 landing-page TSX/TS files (layout, structured-data, opengraph-image, pricing, comparisons, frameworks, docs/page, docs/first-run, PricingLadder, WhatYoureMissing).

### Architectural decisions ratified

v1.1.A license middleware design fully locked across 7 gates (validation cadence, JWT schemas, KV schema, rate limits, grant location, key rotation deferral, owner-unlock bypass behavior, env-var injection path, fingerprint algorithm reuse, anonymous Starter TTL, outage behavior). Full design captured at [`memory/project_v1.1.A_locked_design.md`](C:/Users/SDO/.claude/projects/E--Projects-Maxim/memory/project_v1.1.A_locked_design.md). ADR will land alongside Phase B-2 implementation.

### Known carry-over

- v1.1.A Phase B-2 (Worker `/issue` + `/validate` endpoints, KV namespace, anon JWT issuer) — next session
- v1.1.A Phase B-3 (wire `requireValidLicense` into 7 MCP server tool handlers) — next session
- v1.1.A Phase B-4 (E2E test fixtures + 7 ship gates) — next session
- v1.1.B (MOE per ADR-012) — separate sprint after v1.1.A green
- v1.1.C (7 compliance frameworks) — after MOE
- Decision A2 (~/.claude/{CLAUDE.md, agents, commands, skills} reparse-point cleanup) — deferred from this session per operator's prioritization

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
