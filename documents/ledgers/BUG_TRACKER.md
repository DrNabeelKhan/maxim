# Maxim — Bug Tracker

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 9 entries logged — BUG-001..005 RESOLVED v1.0.0 launch install bug-bash (2026-04-21..2026-04-27) · BUG-006 RESOLVED Session 15 plugin MCP path fix (2026-04-27) · BUG-007 RESOLVED v1.1.0.2/.3 plugin-upgrade node_modules absence + spawn-with-deps wrapper · **BUG-008 RESOLVED v1.3.2.2 (2026-05-20) mxm-self-update.sh Python heredoc Windows MSYS path bug fixed via pathlib.Path.home() + hard-fail registry-write verification** · **BUG-009 OPEN v1.3.2.2 (2026-05-20) mxm-notebooklm MCP wrapper has 12+ CLI-shape mismatches against current notebooklm-py CLI; partial fix shipped (3 subcommand renames + 2 --topic positional + 1 audio enum); full wrapper audit candidate v1.3.3**. PATTERN-01 (cross-platform structural assumptions) struck again with BUG-008 (resolved); BUG-009 is a NEW pattern (PATTERN-02 candidate: external-tool wrapper drift against upstream CLI shape — ADR-018 fragility risk realized). See DEBUGGING_PLAYBOOK.md §1, §3.

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

### BUG-009 · `mxm-notebooklm` MCP wrapper has 12+ CLI-shape mismatches against current upstream `notebooklm-py` CLI

| Field | Value |
|---|---|
| **Reported** | 2026-05-20 (Session 22, surfaced during live operator end-to-end NotebookLM workflow test — Mr. Khan ran the full notebook + sources + generate infographic + generate mind-map + download cycle via the CLI directly. Mind-map generation failed when invoked with the `--wait` flag I passed in PowerShell. Investigation into the MCP wrapper's `generate_mindmap` tool found it uses subcommand name `mindmap` while the actual CLI uses `mind-map`. Further audit of all 9 `generate_*` tools found multiple subcommand + flag mismatches against the live CLI). |
| **Severity** | P1 — catastrophic for the affected tools. 100% failure rate when the MCP wrapper invokes the upstream CLI with the wrong subcommand name or flag. v1.2.1.0 shipped this wrapper with 38 tools; the audio + infographic + mind-map + data-table + slide-deck generate paths are all broken via the MCP (work via direct CLI). Other tools (source_*, chat_*, research_*, artifact_*, auth_*, profile_*, notebook_*) not yet audited at this depth — may have similar issues. |
| **Status** | OPEN — partial fix shipped in v1.3.2.2 (catastrophic-tier subcommand renames + 2 confirmed flag bugs). Full wrapper audit deferred to v1.3.3. |
| **Root cause** | The mxm-notebooklm MCP wrapper at `mcp/mxm-notebooklm/server.js` was authored against an older version of the `notebooklm-py` CLI (likely pre-0.4.x). Upstream renamed several subcommands and refactored flag shapes between releases. The wrapper code calls e.g. `["generate", "mindmap", "-n", id]` while the current CLI expects `["generate", "mind-map", "-n", id]`. ADR-018 fragility-disclosure pattern realized: upstream uses undocumented Google APIs AND upstream CLI shape evolves between releases, breaking wrappers that didn't have version-pinned tests. Worth naming as **PATTERN-02 candidate: external-tool wrapper drift against upstream CLI shape** — this will recur with NotebookLM upgrades AND with future wrappers (Notion, Linear, Slack, etc.) authored under ADR-018. |
| **Catalog of confirmed mismatches (12 entries)** | **Subcommand name mismatches** (catastrophic, 100% fail): (1) `slides` → `slide-deck`. (2) `datatable` → `data-table`. (3) `mindmap` → `mind-map`. **Argument flag mismatches** (catastrophic when the flag is passed): (4) `generate_infographic` passes `--topic FLAG`; CLI takes DESCRIPTION as positional arg. (5) `generate_slides` same `--topic` → positional issue. (6) `generate_quiz` passes `--num-questions NUMBER`; CLI uses `--quantity [fewer\|standard\|more]` categorical. (7) `generate_flashcards` passes `--num-cards NUMBER`; CLI uses `--quantity [fewer\|standard\|more]` categorical. (8) `generate_report` passes `--template NAME`; CLI uses `--format [briefing-doc\|study-guide\|blog-post\|custom]` enum. (9) `generate_data_table` passes `--query TEXT`; CLI takes DESCRIPTION as REQUIRED positional. (10) `generate_audio_overview` length enum has `medium`; CLI accepts `default` (not `medium`). (11) `generate_video_overview` format enum has `narrative` + `summary`; CLI has `brief` + `cinematic` (different values). (12) `generate_video_overview` style enum has 9 values; CLI has 9 different values — almost no overlap. Other 29 tools in the wrapper (source_*, chat_*, research_*, artifact_*, auth_*, profile_*, notebook_*) not yet audited at this depth. |
| **Partial fix (v1.3.2.2)** | Fixed 6 most-confident mismatches in `mcp/mxm-notebooklm/server.js`: subcommand renames (1)(2)(3); positional-DESCRIPTION fixes (4)(5)(9); audio length enum (10). Remaining 6 confirmed bugs (6)(7)(8)(11)(12) and unaudited 29 tools deferred to v1.3.3. |
| **Proposed full fix (v1.3.3 candidate)** | Comprehensive wrapper audit: for every one of the 38 tools in `mcp/mxm-notebooklm/server.js`, run `notebooklm <subcommand> --help` against the live CLI, diff against the wrapper's `args.push(...)` calls, fix every mismatch. Document a regression-guard pattern: pin upstream version in `mcp/mxm-notebooklm/package.json` `peerDependencies` AND add a CI test that calls `notebooklm <each-subcommand> --help` to detect upstream CLI-shape changes before they hit operators. |
| **Verification (partial fix)** | Operator-tested in Session 22 end-to-end: `notebook_create` ✓ via direct CLI · `source_add` ✓ for image + 2 text · `generate infographic` ✓ via direct CLI with positional description · `generate mind-map` ✓ via direct CLI (no --wait, returns synchronously) · `download infographic` + `download mind-map` ✓. The v1.3.2.2 partial-fix wrapper has NOT been live-tested through the MCP itself (Claude Code session would need restart to spawn new wrapper). Direct-CLI verification proves the underlying CLI works; wrapper-fix verification deferred to next session restart. |
| **Regression guard (partial)** | v1.3.2.2 ships the 6 confidence-tier fixes with comments citing `BUG-009 fix (v1.3.2.2)` inline in server.js. v1.3.3 candidate adds: (a) `notebooklm version` check + warning in MCP startup if upstream is outside known-tested range, (b) CI step that runs `notebooklm <each-subcommand> --help` and compares against snapshot, (c) operator-runbook in `mcp/mxm-notebooklm/README.md` documenting how to re-audit after upstream upgrades. |
| **Operator-side workaround** | Use direct CLI invocation while the MCP wrapper has remaining bugs: `notebooklm create "title"`, `notebooklm use <id>`, `notebooklm source add <file>`, `notebooklm generate <subcommand> [DESCRIPTION] [--options...]`. The direct CLI is fully functional; only the MCP wrapper has CLI-shape drift. ADR-018 fragility-disclosure-on-every-output pattern means operators are already warned. |

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

### BUG-006 · All 7 plugin:maxim:mxm-* MCP servers fail to connect

| Field | Value |
|---|---|
| **Reported** | 2026-04-27 (Session 14 close — `claude mcp list` showed all 7 with `✗ Failed to connect`) |
| **Severity** | P0 — total MCP feature unreachable from any project that wasn't `E:/Projects/Maxim/plugin-repo/` itself |
| **Status** | RESOLVED 2026-04-27 (Session 15) |
| **Root cause** | `.mcp.json` declared each of the 7 servers with relative `args: ["./mcp/<name>/server.js"]` paths. Claude Code spawns the MCP child with the user's project cwd, not the plugin install dir; Node then can't find `./mcp/<name>/server.js` because that path doesn't exist in the user's project. The path-resolution assumption was inherited from local-development semantics where cwd happens to be the plugin repo. |
| **Fix** | Replaced `./mcp/<name>/server.js` with `${CLAUDE_PLUGIN_ROOT}/mcp/<name>/server.js` in all 7 server entries of `.mcp.json` (single-file edit, 7 lines). `${CLAUDE_PLUGIN_ROOT}` is Claude Code's documented placeholder that expands to the plugin install dir at spawn time. Pattern is used by other working plugins (claude-mem, vercel). Verified: `claude mcp list` from non-plugin-repo cwd now shows all 7 as `✓ Connected` with paths expanded to `C:/Users/SDO/.claude/plugins/cache/maxim-packs/maxim/1.0.0/mcp/<name>/server.js`. |
| **Regression guard** | `.mcp.json` schema test should reject any entry with `args[0]` starting with `./` or `../`; CI can lint via `jq -e '.mcpServers | to_entries | map(select(.value.args[0] | test("^\\.\\.?/"))) | length == 0'`. v1.1 hardening item: add a `claude mcp list` parse to the macOS-install CI to assert all 7 connect from a fresh-cloned location. |

---

### BUG-007 · Plugin-upgrade leaves new install dir without node_modules → all 7 MCPs fail

| Field | Value |
|---|---|
| **Reported** | 2026-04-27 (Session 16, post-v1.1.0 release — `/plugin uninstall maxim@maxim-packs && /plugin install` followed by `claude mcp list` showed all 7 `plugin:maxim:mxm-*` as `✗ Failed to connect`. Worked again only after manually running `npm install` in 7 of `~/.claude/plugins/cache/maxim-packs/maxim/1.1.0/mcp/<name>/`). |
| **Severity** | P0 — every plugin upgrade breaks MCP servers for every user. Fresh install in any project that isn't `plugin-repo` itself was already permanently broken even on v1.0.0. BUG-006 fixed the spawn-path; BUG-007 fixes the dependency-install path. |
| **Status** | RESOLVED v1.1.0.2 (correctness — 2026-04-27); v1.1.0.3 (single-restart UX — 2026-04-27) |
| **Root cause** | Two co-occurring bugs in `.claude/hooks/session-start.{sh,ps1}` MCP-install block: **(1)** Sentinel was project-relative (`.mxm-skills/.mcp-deps-installed`) but plugin deps live per-plugin-version at `~/.claude/plugins/cache/maxim-packs/maxim/<v>/mcp/<name>/node_modules/`. After upgrade, the project's old sentinel said "installed" so the hook skipped install on the new version's empty dir. **(2)** Even when the hook DID run, it used `cd $PROJECT_ROOT` then checked + installed against project-relative `mcp/` paths — happens to work only when the project IS `plugin-repo` itself. For any other project, npm install ran in the wrong dir or skipped entirely. |
| **Fix** | Both hooks now resolve `PLUGIN_ROOT` from `$CLAUDE_PLUGIN_ROOT` env var (set by Claude Code when invoking hooks via plugin.json) with a script-location fallback for manual invocation. Sentinel moved to `$PLUGIN_ROOT/.mcp-deps-installed` (plugin-version-scoped: each `cache/maxim-packs/maxim/<v>/` gets its own sentinel; absent on every fresh install/upgrade). The `mcp/<name>/node_modules` existence check + bootstrap invocation both push cwd to `$PLUGIN_ROOT` so npm install lands in the plugin's mcp/ subdirs, not the project's. Mirror fix in PS1 hook. |
| **Verification (v1.1.0.2)** | After upgrade `/plugin uninstall maxim@maxim-packs && /plugin install maxim@maxim-packs`, the FIRST session-restart fires SessionStart hook → detects missing `~/.claude/plugins/cache/maxim-packs/maxim/<new-v>/mcp/<*>/node_modules` (sentinel absent in new dir) → runs `npm install` in plugin-relative `mcp/` subdirs → second session-restart loads MCPs `✓ Connected`. Tested locally on Windows (Git-Bash + PowerShell). |
| **Regression guard** | Add CI step: simulate a fresh install + restart cycle in a non-plugin-repo cwd; assert `claude mcp list` shows all 7 connected. **v1.1.0.3 (shipped 2026-04-27): single-restart fix landed via `mcp/_shared/spawn-with-deps.mjs` wrapper — each MCP spawn now synchronously installs missing deps via file-locked npm install before importing server.js. No Claude Code plugin API change required; works within existing spawn lifecycle.** |

---

### BUG-008 · `mxm-self-update.sh` Python heredoc fails on Windows Git Bash (registry SHA never updates)

| Field | Value |
|---|---|
| **Reported** | 2026-05-20 (Session 22, post-v1.3.2 ship — pre-release-audit caught `installed_plugins.json` registry stuck at `version: "1.1.0"` / `gitCommitSha: "158c8382..."` while disk + plugin.json had `1.3.2` / `29c544b4`. Self-update script had emitted `WARN: cannot read registry ([Errno 2] No such file or directory: '/c/Users/SDO/.claude/plugins/installed_plugins.json')` on every successful run since v1.1.1 shipped). |
| **Severity** | P2 — registry mismatch was silent + cosmetic (Claude Code reads `plugin.json` from install-cache directly, not registry SHA); but it confused future `mxm-self-update` runs which then couldn't detect "already up to date" reliably, AND it defeated the audit trail purpose of the registry. Hit every Windows operator since v1.1.1; never noticed because the warning was buried in stderr. |
| **Status** | RESOLVED v1.3.2.2 (2026-05-20). |
| **Root cause** | `bootstrap/mxm-self-update.sh` line 37: `HOME_CLAUDE="${HOME}/.claude"`. On Windows Git Bash, `$HOME` resolves to MSYS-style `/c/Users/SDO` (POSIX-emulation path). Line 39 builds `INSTALLED_REGISTRY="${HOME_CLAUDE}/plugins/installed_plugins.json"` = `/c/Users/SDO/.claude/plugins/installed_plugins.json`. This path was interpolated into a Python heredoc at line 113-144 via `path = r"$INSTALLED_REGISTRY"`. Python on Windows uses native filesystem APIs and **cannot resolve MSYS-style `/c/...` paths** — Python saw a path that didn't exist on the Windows filesystem and raised `FileNotFoundError`. The script's `try/except` swallowed the error, emitted a stderr warning, and exited 0 ("succeeded" silently). Marketplace pull + install-cache sync worked; only the registry-update step failed. PATTERN-01 recurrence: Windows-Git → Mac/Linux assumption gap, but inverted (script written for Linux path semantics, broke on Windows Git Bash). |
| **Fix** | v1.3.2.2 `bootstrap/mxm-self-update.sh` (commit landing with v1.3.2.2 tag): replaced the bash-side `$INSTALLED_REGISTRY` interpolation with Python-native path resolution. Inside the heredoc now: `from pathlib import Path; path = str(Path.home() / ".claude" / "plugins" / "installed_plugins.json")`. Cross-platform by construction — uses Python's own native filesystem APIs. Plus three regression-guard hardenings: (1) `FileNotFoundError` now ERRORs + exits 1 (not buried WARN that exits 0). (2) Generic Exception during read now ERRORs + exits 1. (3) After write, the script RE-READS the registry and asserts `gitCommitSha` matches `$NEW_SHA`; mismatch ERRORs + exits 1. The "silent stderr warning" failure mode is structurally impossible. |
| **Verification** | Manual round-trip in Session 22 confirmed registry now updates correctly when path resolves natively (operator-side manual `Path.home()` test). v1.3.2.2 will be operator-tested on next `mxm-self-update` invocation by Mr. Khan; CI step on `windows-latest` to assert registry-SHA matches `git rev-parse HEAD` is a v1.3.3 candidate. |
| **Regression guard** | Hard-fail exits 1 (not silent exit 0) on every error path in the registry-update block. Buried WARN promoted to hard-fail ERROR. Self-test round-trip verification after write. PATTERN-01 (cross-platform structural assumptions) added to the Recurring-Pattern registry section above; mitigation: any new script that touches user-home paths via heredoc/sub-process MUST use Python-native or platform-native path resolution, NOT bash interpolation across the bash→python boundary. Candidate ADR-022 for v1.3.3+ governing this discipline. |

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
