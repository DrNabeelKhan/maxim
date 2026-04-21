# /mxm-release

## Usage
- Claude Code: `/mxm-release`
- Claude CLI: `claude "/mxm-release"`
- Claude Desktop: type `/mxm-release` in chat

Activates the `release-manager` orchestrator. Reads full `progress.md` before any decision.

**Triggers:** "release", "deploy", "ship this", "prepare release", "tag version"
**Office:** Orchestrators → `release-manager`
**Reads:** `progress.md` · `findings.md` · `CHANGELOG.md`
**Writes:** `CHANGELOG.md` entry

## Pre-Release Audit (BLOCKING — cannot bypass)

Before any other step, run the full stability + bug-free audit. This is a blocking gate: release does not proceed until all blockers clear. If the audit returns any BLOCKER items, the release aborts with a list and the operator must resolve them before re-running `/mxm-release`.

**Audit scope — all 8 buckets must pass:**

1. **Build integrity** — `go build ./...` in `pack-engine/`; `npx tsc --noEmit` in `cloudflare-worker/`; every `mcp/mxm-*/package.json` "name" matches dir + `main` entrypoint resolves.
2. **Config validity** — every `.json` under `config/`, `.claude-plugin/`, `distributions/`, `mcp/*/package.json`, root `.mcp.json`, `config/entities.json` parses clean. YAML files under `config/`, `templates/`, `.github/workflows/` parse clean. `config/project-manifest.json` MXM_version, last_activity, last_updated all match release tag and date.
3. **Reference integrity** — every `/mxm-*` command referenced in docs resolves to `.claude/commands/{name}.md`. Every MCP `args[0]` in `.mcp.json` resolves. Every SKILL.md referenced in `documents/reference/SKILLS_MAP.md` + `CLAUDE.d/dispatch.md` exists. `documents/ledgers/AGENT_SKILL_INVENTORY.md` counts match filesystem reality (agents, domains, commands, MCP servers, ADRs, hook scripts).
4. **Brand / rename consistency** — zero residual `\bARIA\b` (whole-word) or `\baria-` (prefix) outside the 4 hardcoded WAI-ARIA files (`accessibility.md`, `critique-frameworks.md`, `component-patterns.md`, `design-output.md`). Zero `nk@isystematic.com` / `sales@isystematic.com` / `security@isystematic.com`. Every Maxim-runtime folder (`mxm-skills`, `mxm-global`, `mxm-operator-profile`, `mxm-system`, `mxm-packs`, `mxm-executive-summary`, `claude-sessions-memory`, `brand-foundation`) is dot-prefixed in all docs and scripts.
5. **Executable Contract compliance (ADR-002)** — `BUG_TRACKER`, `MOAT_TRACKER`, `DEBUGGING_PLAYBOOK`, `SPRINT_CLI_INSTRUCTIONS` reflect real state. `CHANGELOG.md` has the new version's entry. `documents/ADRs/INDEX.md` lists every ADR file and each cross-link resolves.
6. **Secret / PII scan** — zero `sk_live_`, `rk_live_`, `pk_live_`, `AKIA`, `BEGIN PRIVATE KEY`, `BEGIN RSA PRIVATE KEY` in tracked files. `.gitignore` covers `documents/planning/`, `documents/architecture/`, `documents/architecture/.secrets/`, `cloudflare-worker/secrets/`, `.brand-foundation/personal.local/`, `.brand-foundation/startups/`, `.env*`, `**/node_modules/`.
7. **Word-mid corruption scan** — zero `[a-zA-Z]Maxim[a-zA-Z]`, `VARIA[a-z]`, `vARIA[a-z]` hits (catches prior find-replace corruption of words like Variable, Variant).
8. **Hook scripts** — every `.sh` has a `.ps1` counterpart. Shebangs parse. No stale `.aria-skills/` refs.

**Audit implementation:** spawn a `general-purpose` Agent with the audit prompt from `.claude/agents/pre-release-audit.md`. Expect "READY TO PUSH" or "BLOCKERS: N" verdict. Block on any N > 0.

## Behavior

1. **Pre-Release Audit (BLOCKING)** — run the 8-bucket audit. Abort if any blocker.
2. Read complete `progress.md` — no release without full plan completion confirmed.
3. Run auto-inventory: update `.claude-sessions-memory/file_inventory.md` (snapshot before release).
4. Activate `release-manager`.
5. CSO auto-loop: notify `security-analyst` for pre-release security check.
6. Write `CHANGELOG.md` entry.
7. Run version sync: `bootstrap/sync-version.ps1 -NewVersion "[version]"` (or `.sh`) — propagates version from agent-registry.json to all version-bearing files; prevents drift across README, HELP, SKILLS_MAP, SESSION_CONTINUITY, marketplace.json, plugin.json, project-manifest, community-pack-registry, etc.
8. Run version drift check: verify all files report the same version.
9. Confirm release checklist with user.
10. Tag output: 🟢 HIGH.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
