# Maxim — Debugging Playbook

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 2 entries — §1 captures the v1.0.0 launch install bug-bash (2026-04-21..2026-04-27); §2 captures the Session 15 capability-count drift codification ("DNA gap").

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

### §2 — 2026-04-27 — Capability-count drift across surfaces (the "DNA gap")

**Context.** Total agent count moved 88 → 90 (cost-analyst + sre-analyst migration from aria-simplification). What looked like a one-line `documents/ledgers/AGENT_SKILL_INVENTORY.md` edit turned into a 30+ file sweep across plugin-repo (markdown docs, JSON breakdown comments, ADR examples, marketing collateral, proactive-watch teaching examples) plus a 9-file sweep across `landing-page/` (TSX/TS files: layout descriptions, Open Graph image, structured data, comparisons, pricing copy). Several stale claims (e.g., `87 Maxim agents` in `CLAUDE.d/repo-map.md`) had been silently drifting since v1.0.0 ship. Operator caught the pattern: "Honestly this should be in your project DNA."

**Hypothesis tree (in order considered, with what ruled each in/out):**

1. **AGENT_SKILL_INVENTORY.md is the only place the count lives.** ✗ Wrong. Named "single source of truth" but counts duplicated across 30+ markdown files + JSON + landing-page TSX. Operator's reaction was the diagnostic — they'd seen this pattern before across the 14-session arc.
2. **A simple regex sweep `\d+ agents` → new count works.** ✗ Wrong on three false-positive classes:
   - **Per-office breakdowns**: `25 agents` for CTO Office is correct as 25, not 90 (per-office count, not global). Found in `CLAUDE.d/office-catalog.md` and `AGENT_SKILL_INVENTORY.md` Section 1 itself.
   - **Complexity thresholds**: `>= 3 agents` in agent definition files (cost-analyst.md, skill-synthesizer.md) refers to "≥ N agents in a chain" as a complexity signal, not a count claim.
   - **Historical changelog entries**: `87 agents` / `88 agents` in `config/agent-registry.json`'s internal `changelog[]` array describes past release states; rewriting them corrupts history.
3. **Forward-looking spec documents are also exempt.** ✓ Confirmed during acceptance test. `documents/reference/AGENT_ROSTER_v1.2_PROPOSAL.md` mentions `24 specialist commands` as a v1.2 plan target — not the global current command count. Naive regex would have rewritten 24→38, corrupting the plan doc. Same for `documents/proposals/v1.0.x-count-drift-codification.md`.
4. **One regex pattern covers both bare `\d+ agents` and adjective-prefixed `\d+ specialist agents`.** ✗ Decided against. **Required adjective prefix or `+` suffix** — bare form too ambiguous. Strict pattern: `\b\d+\+\s+kw\b` (open-ended) OR `\b\d+\s+(specialist|governed|peer-reviewed|Maxim)\s+kw\b` (adjectival). Bare `\d+ kw` deliberately not matched — Class 11 detection still flags those, sync-counts skips them, humans review manually.

**Root cause (the meta-pattern).** `AGENT_SKILL_INVENTORY.md` is named source-of-truth but enforces nothing — load-bearing document with no automated downstream propagation. Every other surface that quotes the number is hand-written by humans, who copy-paste the count from wherever they last saw it. Drift is the default state; alignment is the exception. Proactive Watch Class 1 (filesystem-vs-inventory) catches one drift class; the *complementary* class — inventory-vs-marketing-copy — was uncovered Session 15.

**Fix.** Three coordinated changes shipped in v1.0.1:

1. **Proactive Watch Class 11 — `surface-claims-drift`** — codified in `composable-skills/frameworks/proactive-watch.md`. Detects mismatches between INVENTORY and any declared surface (markdown + JSON + landing-page TSX). Configured per `config/watch-profile.yml` with explicit exclusion patterns (CHANGELOG.md, ADR INDEX, `**/v[0-9]*-*.md` versioned historical docs, `**/changelog/**` directories, `documents/proposals/`, `AGENT_ROSTER_v1.x_PROPOSAL.md` forward-looking specs).
2. **`bootstrap/sync-counts.{sh,ps1}`** — companion mechanical-propagation tool. Reads INVENTORY canonical counts (parses each Section's `(N)` header), propagates to all declared surfaces via single perl invocation per file (with grep pre-filter for performance — Windows/Git-Bash cuts 8 perl spawns × 1117 files from ~7 min projected to ~1.3 min observed). Idempotent on clean tree (running on no-drift state is a no-op). Conservative regex avoids the three false-positive classes from hypothesis 2.
3. **Commit Protocol rule** in `CLAUDE.md` + `CLAUDE.d/protocols.md`: when commit touches `agents/MXM/**`, `.claude/skills/**`, `.claude/commands/**`, `mcp/**`, `composable-skills/frameworks/**`, or `.claude/hooks/**`, run `bootstrap/sync-counts.{sh,ps1}` before commit. Pre-commit hook fails-closed on residual drift unless `[surface-claims-drift-ack: <reason>]` in commit message.

**Regression guard.** Three layers:

1. **Class 11 detection in every session** — runs as part of LIGHT-phase Proactive Watch on every SessionStart. Catches drift introduced between sync-counts runs.
2. **`bootstrap/sync-counts.{sh,ps1}` mechanical propagation** — bumps inventory once, propagates everywhere, idempotent. Acceptance-tested with synthetic 90→91 bump (correctly flagged 21 plugin-repo + 4 landing-page surfaces; back to 0 after restore).
3. **Commit Protocol fails-closed** when residual drift detected post-sync — operator must explicitly acknowledge intentional divergence.

**The transferable lesson.** "Single source of truth" is a property of the SYSTEM, not of any one document. If the count is duplicated across N surfaces and propagation is manual, the document with the canonical number is one of N+1 places that drift; declaring it source-of-truth changes nothing on its own. Source-of-truth requires either (a) build-time templating (single declaration, derived everywhere) or (b) detection + mechanical propagation tooling that runs in the commit-time loop. Maxim chose (b) for v1.0.1 — templating would have invasively rewritten 30+ markdown files and broken human-readability. Cost: building two tools (Class 11 + sync-counts). Benefit: future count changes become idempotent + auditable.

**Methodology that worked.** Operator's "this should be in your project DNA" feedback flipped the framing from "let me sweep this" to "let me prevent the next sweep." Acceptance test wasn't traditional unit tests — it was running sync-counts against the just-finished manual sweep and counting how many ADDITIONAL surfaces it caught (12 in plugin-repo, all confirmed legitimate stale claims my manual sweep missed). The synthetic 90→91 INVENTORY bump test confirmed forward-direction correctness. The restore + re-run test confirmed idempotency.

**Cross-links:** Operator feedback `~/.claude/projects/E--Projects-Maxim/memory/feedback_capability_count_propagation.md` · `composable-skills/frameworks/proactive-watch.md` Class 11 spec · `bootstrap/sync-counts.{sh,ps1}` · `config/watch-profile.{yml,TEMPLATE.yml}` Class 11 config · `CLAUDE.md` + `CLAUDE.d/protocols.md` (Commit Protocol updated) · `documents/proposals/v1.0.x-count-drift-codification.md` (full proposal).

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
