# Maxim — Bug Tracker

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 5 entries logged + RESOLVED — the v1.0.0 launch install bug-bash (2026-04-21..2026-04-27). All five surfaced only on a real macOS install; structural Windows tests passed throughout. See DEBUGGING_PLAYBOOK.md §1 for the meta-pattern.

---

## Executable Contract (v1.0.0+)

This file is not a log. It is a **live registry** of bugs and recurring failure patterns. Anything that can regress silently lives here with a fingerprint, repro, and regression-prevention link.

Each entry MUST include:

| Field | Required | Purpose |
|---|---|---|
| `BUG-NNN` | ✅ | Monotonic ID — never reused. First bug in Maxim v1.0.0+ becomes BUG-001. |
| Title | ✅ | One-line symptom, not guess. |
| Reported | ✅ | ISO date + source (user, CI, self-audit, Proactive Watch). |
| Severity | ✅ | P0 (production down) / P1 (user-blocking) / P2 (degraded) / P3 (minor). |
| Status | ✅ | OPEN / IN-PROGRESS / RESOLVED / WONTFIX (with reason). |
| Root cause | on RESOLVED | One sentence — what actually broke, not what we fixed. |
| Fix | on RESOLVED | Commit SHA + file path + line. |
| Regression guard | on RESOLVED | Test, CI check, or Proactive Watch rule that catches recurrence. No guard → flag in Recurring-Pattern registry. |

---

## Recurring-Pattern Registry

Patterns that have struck more than once earn a permanent entry here with a named mitigation. This is the ledger's teeth — it converts one-off fixes into standing guards.

### PATTERN-01 · Cross-platform structural assumptions (Windows-Git → Mac/Linux)

Three of the v1.0.0 launch bugs (BUG-003 exec bit, BUG-004 PATH, BUG-005 sparse-checkout) were invisible to local Windows testing and only surfaced on a real macOS install. Mitigation: add a CI job that runs `claude plugin install` on `macos-latest` after every push to main; gate releases on it. Tracked as v1.1 hardening item.

---

## Open Bugs

_(None.)_

---

## Resolved Bugs

### BUG-001 · `/plugin marketplace add` fails with `plugins.0.source: Invalid input`

| Field | Value |
|---|---|
| **Reported** | 2026-04-24 (user — Mac test session) |
| **Severity** | P0 — blocks all installs |
| **Status** | RESOLVED 2026-04-24 |
| **Root cause** | The base `maxim` plugin entry in `.claude-plugin/marketplace.json` used `source: "../"` (path-traversal-out string). Claude Code's marketplace schema rejects bare relative paths that climb out of the marketplace directory. |
| **Fix** | `8a82be1` — switched to `source: { source: "git-subdir", url: "...", path: ".", ref: "main" }`. (Note: this fix was correct schema but introduced BUG-005 — see below.) |
| **Regression guard** | None standalone — gated by PATTERN-01 macOS-install CI. |

### BUG-002 · `/help` shows zero `/maxim:mxm-*` commands after install

| Field | Value |
|---|---|
| **Reported** | 2026-04-24 (user — Mac test session) |
| **Severity** | P0 — plugin appears empty |
| **Status** | RESOLVED 2026-04-24 |
| **Root cause** | 34 of 38 `.claude/commands/mxm-*.md` files lacked YAML frontmatter. Claude Code's plugin loader silently skips command files without a `description:` field — no error logged, no surface signal. |
| **Fix** | `c4e93f0` — prepended `---\ndescription: ...\n---\n` to all 34 missing files (per-command hand-crafted descriptions). The 4 already-compliant commands (`mxm-session-end`, `mxm-voice`, `mxm-watch`, `mxm-wiki`) untouched. |
| **Regression guard** | Add a pre-commit check: every `.claude/commands/*.md` must start with `---\n` and contain a `description:` line in its frontmatter. v1.1 hardening item. |

### BUG-003 · `bash bootstrap/X.sh` returns "permission denied" on Mac/Linux

| Field | Value |
|---|---|
| **Reported** | 2026-04-25 (user — Mac install attempt) |
| **Severity** | P0 — bootstrap scripts unrunnable; SessionStart hook silently fails |
| **Status** | RESOLVED 2026-04-25 |
| **Root cause** | Every `.sh` file in the repo (60 files: 7 hooks + 6 bootstrap + 8 distribution mirrors + 1 skill + others) was tracked by git as `100644` (no exec bit). Files added from Windows default to non-executable because Windows filesystems don't carry the bit. On clone to Mac/Linux, files materialize without `+x` and direct invocation fails. |
| **Fix** | `e3d6008` — `git update-index --chmod=+x` on every tracked `.sh`. All 60 files now `100755`. |
| **Regression guard** | Add `.gitattributes` rule: `*.sh text eol=lf` plus a pre-commit hook that runs `chmod +x` on any newly-staged `.sh`. v1.1 hardening item. |

### BUG-004 · MCP server failed: timeout immediately after install

| Field | Value |
|---|---|
| **Reported** | 2026-04-25 (user — Mac install attempt) |
| **Severity** | P1 — plugin partially loads but MCP-dependent features fail |
| **Status** | RESOLVED 2026-04-25 |
| **Root cause** | Two compounding issues. First: each of the 7 MCP servers in `mcp/mxm-*/` is a self-contained Node package needing `@modelcontextprotocol/sdk` + `zod`; `node_modules/` is gitignored, so a fresh clone lacks dependencies and `node ./mcp/mxm-portfolio/server.js` throws `ERR_MODULE_NOT_FOUND`. Second: Node.js itself wasn't on the test user's interactive shell PATH (it was installed at `/usr/local/bin/node` via Homebrew Cellar but PATH didn't include it). |
| **Fix** | `82385c9` — added `bootstrap/mxm-mcp-install.{sh,ps1}` (npm install per MCP server) and wired auto-run into SessionStart hook with sentinel-based skip-on-subsequent-sessions. `4b7fcd2` — README now flags Node.js as a hard prerequisite with verify commands and macOS install instructions. |
| **Regression guard** | SessionStart hook detects missing `node_modules` and self-heals on first session. README upfront warning prevents the no-Node ambush. v1.1 hardening item: pre-flight check on `claude --version`-style probe before declaring install successful. |

### BUG-005 · Plugin installs successfully but only 1% of files materialize on disk

| Field | Value |
|---|---|
| **Reported** | 2026-04-25 (user — "no commands showing still" after BUG-001 fix) |
| **Severity** | P0 — silent total install failure |
| **Status** | RESOLVED 2026-04-25 |
| **Root cause** | `git-subdir` source type with `path: "."` triggers Claude Code's plugin loader to apply a sparse-checkout filter of `/*` + `!/*/` — i.e. "include all top-level files, exclude all top-level directories." For a plugin at the repo root this means ONLY the 8 root-level files (CHANGELOG, CLAUDE.md, README, LICENSE, .env.example, .gitignore, .mcp.json, CONTRIBUTING) check out. The other 909 files (every command, agent, hook, skill, MCP server, bootstrap script, plugin.json itself) are excluded. Install reports success because the manifest validates from cache, but the runtime is broken because nothing is on disk to load. |
| **Fix** | `cee9aa6` — switched maxim's `source` from `git-subdir` to `url`: `{ source: "url", url: "https://github.com/DrNabeelKhan/maxim.git" }`. The `url` source type does a full clone (no sparse-checkout filter). Verified end-to-end on the Mac: install dir went from 8 entries to 23, all 38 commands present, all 7 MCP servers present, all hooks present, `claude plugin validate` ✔. |
| **Regression guard** | PATTERN-01 macOS-install CI would catch this; structural Windows tests cannot. Also add a post-install assertion: count of files in `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/` must be ≥ 80% of `git ls-files | wc -l` from the source repo. |

---

## WontFix

_(None.)_

---

## Notes

- Bugs found during Proactive Watch runs (LIGHT or FULL) must land here before the session ends.
- Bugs surfaced by the compliance audit hook (`.claude/hooks/pre-commit.sh`) are logged to `.mxm-skills/compliance-audit.jsonl` and cross-linked here when a pattern emerges.
- Reporter agent = `security-analyst` for any PII/secret/regulated-data bug by default.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
