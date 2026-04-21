---
name: pre-release-audit
description: 8-bucket stability + bug-free audit run before every `/mxm-release`. Returns READY TO PUSH or BLOCKERS:N. Blocks release on any blocker.
office: Orchestrators
activates_on: /mxm-release (pre-release gate, blocking)
---

# Pre-Release Audit

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

You are auditing the Maxim plugin repo before a release push. Research only — do NOT write or edit files. Use Glob, Grep, Read, Bash (read-only).

## Audit scope — 8 buckets. Report findings per bucket.

### 1. Build integrity
- `pack-engine/` → does `go build ./...` succeed? Report stderr lines if not.
- `cloudflare-worker/` → does `npx tsc --noEmit` succeed? Report any type errors.
- Every `mcp/mxm-*/package.json` → `"name"` matches directory name + `"main"` entrypoint file exists.

### 2. Config file validity
- Parse every `.json` under `config/`, `.claude-plugin/`, `distributions/`, `mcp/*/package.json`, root `.mcp.json`, `config/entities.json`. Report parse failures.
- Parse every `.yml`/`.yaml` under `config/`, `templates/`, `.github/workflows/`. Report invalid YAML.
- `config/project-manifest.json` → `MXM_version` matches release tag. `last_activity` and `last_updated` match release date.

### 3. Reference integrity
- Every `/mxm-*` command referenced in docs (README, HELP, CLAUDE.md, documents/reference/MXM_COMMAND_MAP.md) → file exists at `.claude/commands/{name}.md`.
- Every MCP server named in `.mcp.json` → `args[0]` path resolves.
- Every SKILL.md referenced in `documents/reference/SKILLS_MAP.md` and `CLAUDE.d/dispatch.md` → file exists.
- `documents/ledgers/AGENT_SKILL_INVENTORY.md` counts match filesystem reality: agents under `agents/MXM/`; domains = `.claude/skills/*/SKILL.md`; commands = `.claude/commands/mxm-*.md`; MCP servers = `mcp/mxm-*` dirs; ADRs = `documents/ADRs/ADR-*.md`; hook scripts = `.claude/hooks/*.{sh,ps1}`.

### 4. Brand / rename consistency
- Zero `\bARIA\b` (whole-word uppercase) or `\baria-` (lowercase prefix) outside the 4 hardcoded WAI-ARIA files:
  - `.claude/skills/design-resources/references/accessibility.md`
  - `.claude/skills/design-resources/references/critique-frameworks.md`
  - `.claude/skills/design-resources/references/component-patterns.md`
  - `documents/references/sample-project/output-examples/design-output.md`
- Zero `nk@isystematic.com`, `sales@isystematic.com`, `security@isystematic.com` in tracked files.
- Every Maxim-runtime folder is dot-prefixed in docs, scripts, configs: `.mxm-skills`, `.mxm-global`, `.mxm-operator-profile`, `.mxm-system`, `.mxm-packs`, `.mxm-executive-summary`, `.claude-sessions-memory`, `.brand-foundation`. Non-dot variants = BLOCKER.

### 5. Executable Contract compliance (ADR-002)
- `BUG_TRACKER.md`, `documents/ledgers/MOAT_TRACKER.md`, `documents/ledgers/DEBUGGING_PLAYBOOK.md`, `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` reflect real state (not stale templates if activity occurred).
- `CHANGELOG.md` has the release version's entry.
- `documents/ADRs/INDEX.md` lists every ADR file under `documents/ADRs/`; each cross-link resolves.
- `documents/ledgers/MOAT_TRACKER.md` has a row for every SKILL.md that cites a MOAT-NN ID (no orphan citations).

### 6. Secret / PII scan
- Zero `sk_live_`, `rk_live_`, `pk_live_`, `AKIA`, `BEGIN PRIVATE KEY`, `BEGIN RSA PRIVATE KEY` in tracked files (outside `documents/planning/` which is gitignored).
- `.gitignore` covers: `documents/planning/`, `documents/architecture/`, `documents/architecture/.secrets/`, `cloudflare-worker/secrets/`, `.brand-foundation/personal.local/`, `.brand-foundation/startups/`, `.env`, `.env.*`, `**/node_modules/`, `pack-engine/*pack-engine*.exe`.
- No committed `.env` file. `.env.example` present + sanitized.

### 7. Word-mid corruption scan
- Zero `[a-zA-Z]Maxim[a-zA-Z]` hits (catches `VMaximble` from `Variable`, `vMaximnt` from `variant`, etc.).
- Zero `VARIA[a-z]` or `vARIA[a-z]` mid-word hits.
- Zero `[A-Z]+-UNENHANCED` variants other than the intended tag form.

### 8. Hook scripts
- Every `.sh` in `.claude/hooks/` has a `.ps1` counterpart and vice versa.
- Shebangs parse (`#!/usr/bin/env bash` or `#!/usr/bin/env pwsh`).
- No stale `.aria-skills/` refs in any hook.
- Hooks registered in `.claude/hooks/hooks.json` (if present) resolve to existing files.

## Output format

One concise line per finding. Group by bucket number. Classify each finding:

- **BLOCKER** — must fix before release. Security, data-integrity, or contract-violating.
- **NIT** — can defer post-release. Cosmetic or low-impact.

End with:

```
VERDICT: READY TO PUSH
```

or

```
VERDICT: BLOCKERS: N
  1. [bucket].[short desc] — file:line
  2. [bucket].[short desc] — file:line
  ...
```

The `/mxm-release` command blocks on any N > 0. The operator must resolve all blockers before re-running release.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
