# Maxim — Debugging Playbook

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 1 entry — §1 captures the v1.0.0 launch install bug-bash (2026-04-21..2026-04-27).

---

## Executable Contract

Append-only journal. Each entry is numbered `§N`, dated, and formatted for future retrieval. The purpose is pattern memory, not post-mortem theater.

Each `§N` entry MUST include:

```
§N — YYYY-MM-DD — [one-line symptom]

Context: what was being attempted, what broke, signal vs noise.
Hypothesis tree: the branches considered, in order, with what ruled each in or out.
Root cause: the actual mechanism, not the first plausible guess.
Fix: commit SHA + file path + line, or the decision to WONTFIX with reason.
Regression guard: test / CI / Proactive Watch rule that catches it next time.
Cross-links: BUG-NNN, MOAT-NN, ADR-NNN where applicable.
```

Session-end bundle check: if a new failure pattern was resolved during the session, a `§N` entry MUST land before the session closes (ADR-002 bundle rule 5).

---

## Entries

### §1 — 2026-04-27 — Plugin install: structural tests passed locally, install kept failing on Mac

**Context.** Public launch in flight. First real user (alsalman, on macOS Tahoe 26.3.1) tried `/plugin marketplace add DrNabeelKhan/maxim` + `/plugin install maxim@maxim-packs` and reported a sequence of failures: schema rejection, then "no commands showing," then "MCP server failed: timeout," then "still no commands." All five surfaced over three days. Local Windows structural tests (Node.js JSON validators, file existence checks, frontmatter scans, exec-bit audits) reported 50/50 PASS throughout. The signal-noise ratio at the source-of-truth — the live install on a real macOS host — was very high; the noise in our local validation pipeline was zero, which is exactly the dangerous case.

**Hypothesis tree (in order considered, with what ruled each in/out):**

1. **Marketplace.json schema invalid.** ✓ Confirmed for BUG-001 only — fixed in `8a82be1`. Each subsequent failure was something else.
2. **Command files missing required fields.** ✓ Confirmed for BUG-002 — 34/38 lacked frontmatter. Fixed in `c4e93f0`.
3. **User error in install command.** ✗ Ruled out — operator was running the documented commands verbatim.
4. **Anthropic marketplace not approving Maxim.** ✗ Irrelevant to the immediate symptom — we use the self-marketplace path which doesn't depend on Anthropic.
5. **Hooks not firing because of permission denied.** ✓ Confirmed for BUG-003 — every `.sh` was 100644. Fixed in `e3d6008`.
6. **MCP servers crashing on startup.** ✓ Confirmed for BUG-004 — Node.js missing from PATH; also `node_modules` missing. Fixed in `82385c9` + `4b7fcd2`.
7. **Plugin manifest path wrong.** ✗ Verified locally; paths resolve.
8. **Cached state from previous failed install.** ✗ Operator did clean re-add; cache wiped each time.
9. **Some component not registering despite being on disk.** ✓ Plausible. But couldn't see WHICH component without inspecting the live install state.

After hypothesis 9 we hit a wall — Windows structural tests kept passing, but the Mac kept failing with new symptoms. **The unlock was establishing live SSH access to the Mac via Tailscale and inspecting the actual install directory directly.** Five SSH commands later (`ls`, `cat installed_plugins.json`, `cd $PLUGIN_DIR && git status`, `cat .git/info/sparse-checkout`, `ls -d $PLUGIN_DIR/*`), the smoking gun appeared: `git status` reported `You are in a sparse checkout with 1% of tracked files present.` Of 917 tracked files, only 8 had been checked out — every directory was excluded.

**Root cause (the meta-pattern).** Claude Code's `git-subdir` source type with `path: "."` interprets the dot as "the plugin lives at the root level — checkout the root level only, no subdirectory descent." The sparse-checkout pattern it sets is `/*` + `!/*/` — include all files at root, exclude all directories at root. Setting `path: "."` is the wrong shape for a plugin at repo root; it's the shape for "this plugin is one of N siblings in a monorepo, just grab my level." For a single-plugin-at-root structure, the correct shape is `source: { source: "url", url: "..." }` which performs a full clone.

**Fix.** `cee9aa6` — switched maxim's source to the `url` form. Verified via Tailscale SSH: install dir went from 8 files to 23 directories of fully-checked-out content. All commands present, all MCPs present, validation passes, list shows enabled.

**Regression guard.** Two layers:
1. **Live-install CI on macos-latest** — a GitHub Action that runs `claude plugin install` after every push to main, asserts file count + critical-path presence. PATTERN-01 in BUG_TRACKER.md.
2. **Post-install assertion** — count of files in `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/` must be ≥ 80% of the source repo's tracked file count. Catches sparse-checkout regressions across other plugin source types.

**The transferable lesson.** Structural tests catch ~50% of plugin bugs. The other half only surface when the plugin's loader actually runs against a fresh clone on a real OS. Any plugin work that touches `marketplace.json`, `plugin.json`, the source/path shape, or anything that affects `git checkout` behavior MUST be validated by an actual live install, not just by validating the JSON. **Trust the user's test machine over the local validator** — they're running closer to truth.

**Methodology that worked.** Tailscale SSH key auth → `git status` inside install dir → read `.git/info/sparse-checkout` → cross-reference to known plugin source types in the official Anthropic marketplace. Total time from "stuck" to root cause: ~5 SSH commands, ~10 minutes once SSH was set up. Time spent before SSH was set up (guessing from local-only signals): ~3 days across 3 round-trips with the user.

**Cross-links:** BUG-001..BUG-005 (all five resolved bugs) · PATTERN-01 (cross-platform structural assumptions) · ADR-008 (community pack system) · `documents/sales/TEST_MAC_ENVIRONMENT.md` (private — Tailscale SSH setup, ARCHIVED 2026-04-27).

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
