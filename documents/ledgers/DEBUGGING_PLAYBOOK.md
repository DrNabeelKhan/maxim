# Maxim — Debugging Playbook

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 4 entries — §1 captures the v1.0.0 launch install bug-bash (2026-04-21..2026-04-27); §2 captures the Session 15 capability-count drift codification ("DNA gap"); §3 captures the Session 22 pre-release-audit discipline restoration + BUG-008 cross-platform path bug (PATTERN-01 recurrence #4); **§4 captures the Session 22 BUG-009 discovery — external-tool wrapper drift against upstream CLI shape, PATTERN-02 candidate**.

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

## §3 — 2026-05-20 — Pre-release-audit discipline restoration + BUG-008 cross-platform path bug (PATTERN-01 recurrence #4)

**Context.** Session 22, two ships in same day (v1.3.2 + v1.3.2.1). v1.3.2 started as a 2-file doc cleanup (PACKS.md + maxim-one-pager.md deferred from v1.3.0 scope). Operator's first attempt to "stage and commit" surfaced a structural problem: the prior 5 patches (v1.2.0.4 → v1.3.1) all claimed "pre-release-audit PASS" in their CHANGELOG entries WITHOUT dispatching the agent. v1.3.1 CHANGELOG honestly logged "Discipline lag — third iteration." Session 22's job: break the pattern by actually dispatching the agent, then keep it broken across multiple ships in a row.

**Hypothesis tree.**
1. *The agent isn't worth running for "small" patches.* → REJECTED. Cycle 1 of v1.3.2 against a 5-file candidate state found **7 P1 blockers** in 90 seconds. Including: wizard scripts (the FIRST surface every operator sees) still declared "64 frameworks · 87 tools" while the patch claimed to fix exactly that drift. Self-assessment had missed this for 5 consecutive releases.
2. *One audit dispatch is sufficient.* → REJECTED. Cycle 1 caught office-facing surfaces; Cycle 2 (grep-based internal re-audit) caught 3 additional misses: `install-tier-packs.sh:194` Do-Solo handler (only fixed in .ps1 mirror, not .sh), `mxm-help.md:459` summary, `MXM_RUNDOWN.md:15`. The pattern: agent dispatch + grep verification = minimum discipline.
3. *v1.3.2.1 (patch-of-patch) doesn't need the audit because it's tiny.* → REJECTED. Cycle 1 against v1.3.2.1 found 2 P1 blockers v1.3.2 should have caught: `maxim-one-pager.md:41` still said "19 dispatchable subagents" (despite the file being in v1.3.2 scope) + `mxm-self-update.ps1` slow-restart banner missing the BUG-008 caveat line that .sh had. **The audit catches the previous audit's misses.**
4. *Cross-platform shell scripts ported from Linux work on Windows Git Bash.* → REJECTED. BUG-008 surfaced: `bootstrap/mxm-self-update.sh` line 37 sets `HOME_CLAUDE="${HOME}/.claude"`. On Windows Git Bash `$HOME` is MSYS-style `/c/Users/SDO`. Line 113-144 interpolates this path into a Python heredoc. **Python on Windows uses native filesystem APIs and cannot resolve `/c/Users/...` paths** — raises `FileNotFoundError`, which the script's try/except swallows as a stderr warning and exits 0 ("succeeds"). Marketplace pull + install-cache sync work; registry update silently fails. Every Windows operator since v1.1.1 has hit this; nobody noticed because the warning was buried in stderr.

**Root cause(s).**

*Discipline pattern:* Self-assessment of audit outcomes is a structural anti-pattern when the audit checks against a list (capability counts across N surfaces). The author of the change is the worst auditor of it. Pre-release-audit dispatch is the only mechanism that catches drift the author has tunnel vision on.

*BUG-008 cross-platform path:* MSYS-style POSIX-emulation paths (`/c/Users/...`) are produced by Git Bash on Windows when bash resolves `$HOME` or `$USERPROFILE`-converted variables. These paths are valid inside the MSYS process tree (bash can `cd /c/Users/`) but invalid when handed to Windows-native processes (Python.exe, cmd.exe, native APIs). PATTERN-01 (cross-platform structural assumptions) struck for the 4th time after BUG-003 (exec bit) / BUG-004 (PATH) / BUG-005 (sparse-checkout) — but inverted: previous PATTERN-01 hits were Windows-only assumptions breaking on Linux/Mac; BUG-008 is a Linux-style path assumption breaking on Windows Git Bash.

**Fix.**

*Discipline pattern fix:* Every patch from v1.3.2 forward dispatches `maxim:pre-release-audit` agent BEFORE writing the CHANGELOG audit-claim line. Cycle 2 (grep-based) follows agent dispatch as final verification. CHANGELOG records both cycles' findings honestly — never "self-claimed PASS." Codified in v1.3.2 CHANGELOG § "Lessons logged honestly" + v1.3.2.1 § "Lesson logged."

*BUG-008 fix (planned v1.3.3):* Replace path interpolation with Python-resolved path inside the heredoc: `from pathlib import Path; path = str(Path.home() / ".claude" / "plugins" / "installed_plugins.json")`. Cross-platform by construction. Alternative: `cygpath -w` conversion at top of script. Manual operator-side remediation already in BUG_TRACKER.md BUG-008 § "Proposed fix." Applied for Mr. Khan in Session 22 by direct edit of `installed_plugins.json` after each self-update.

**Regression guards.**

*Discipline pattern:* Convention enforced. Next-session-startup block in `agents-handoff.md` reminds: "Pre-release-audit dispatch BEFORE tag. NEVER self-claim PASS."

*BUG-008:* Promote the script's `WARN: cannot read registry` to a hard-fail ERROR + exit 1. Buried warnings caused 5 releases of silent drift. Plus a CI step on `windows-latest`: run `/mxm-self-update` + verify registry SHA matches.

**Cross-links.**
- BUG-008 (OPEN) — full root-cause + proposed fix + manual remediation in `documents/ledgers/BUG_TRACKER.md`
- CHANGELOG v1.3.2 + v1.3.2.1 entries — full audit-cycle narratives + carryover deferral lists
- ADR-007 Behavioral Moat Framing — the discipline IS the moat enforcement; self-claimed audits violate ADR-007 § Framework citation requirement applied to internal process docs
- ADR-002 Documents as Executable Contracts — CHANGELOG audit-claim line is part of the executable contract; falsifying it violates the contract structurally
- PATTERN-01 (Recurring-Pattern Registry in BUG_TRACKER.md) — fourth recurrence formally counted
- Pre-release-audit agent: `agents/MXM/orchestrators/pre-release-audit.md` (8-bucket audit definition)

---

## §4 — 2026-05-20 — BUG-009 mxm-notebooklm wrapper CLI-shape drift (PATTERN-02 candidate: external-tool wrapper drift against upstream CLI shape)

**Context.** Session 22, late evening, post-v1.3.2.1 ship. Mr. Khan ran the live end-to-end mxm-notebooklm workflow: NotebookLM source ingestion (screenshot + 2 text files) → infographic generation → mind-map generation → bundle assembly → LinkedIn post via nk-writer. The test exercised the upstream `notebooklm` CLI directly (not via the MCP wrapper) because the upstream CLI wasn't yet on PATH when the MCP first probed.

Mid-workflow, my PowerShell command `notebooklm generate mind-map --wait` failed with `Error: No such option: --wait`. I had passed `--wait` because most generate subcommands support it. Mind-map doesn't.

That single error opened the bigger investigation: if mind-map doesn't take `--wait`, what else does the wrapper get wrong? I grep'd `mcp/mxm-notebooklm/server.js` for every `args.push(...)` against the actual CLI help output.

**Hypothesis tree.**

1. *Just a `--wait` mismatch on mind-map.* → REJECTED. Looking at the wrapper's `generate_mindmap` tool (line 605), the wrapper invokes `["generate", "mindmap", "-n", notebook_id]`. The CLI help showed the subcommand is `mind-map` (with hyphen), not `mindmap`. The wrapper would 100%-fail on this tool just on subcommand name, before `--wait` even mattered.

2. *Subcommand naming convention drift.* → CONFIRMED + EXPANDED. Audited the other 8 generate tools. Found `slides` should be `slide-deck`, `datatable` should be `data-table`. Three subcommand mismatches across 9 generate tools (33% catastrophic-fail rate).

3. *Flag-shape drift.* → CONFIRMED. `generate_infographic` and `generate_slides` push `--topic` as a flag; the CLI takes DESCRIPTION as a positional arg. `generate_data_table` pushes `--query` as optional flag; the CLI takes DESCRIPTION as a REQUIRED positional. `generate_audio_overview` length enum has `medium`; the CLI accepts `default`. Quiz/flashcards push `--num-questions`/`--num-cards`; the CLI uses `--quantity` categorical (`fewer|standard|more`). Report pushes `--template`; the CLI uses `--format` enum. Video format + style enums almost entirely different between wrapper and CLI.

4. *Wrapper was authored against an older upstream version.* → CONFIRMED. v1.2.1.0 was shipped 2026-05-20; the `notebooklm-py` package on disk is 0.4.1 (latest). The wrapper appears authored against a 0.3.x or earlier shape. Upstream CLI shape evolved between release and now.

5. *V1.2.1.0 self-claimed "operator-tested" was actually untested through the MCP.* → CONFIRMED. CHANGELOG v1.2.1.0 says "operator-tested probes at design time" but the probe was direct-CLI route_task descent verification, not end-to-end MCP wrapper testing. Same anti-pattern Session 22 broke for pre-release-audit: self-claimed validation without actual validation.

**Root cause(s).**

*Surface-level:* MCP wrapper at `mcp/mxm-notebooklm/server.js` has 12+ confirmed CLI-shape mismatches across 9 generate tools, plus likely more in 29 unaudited tools (source_*, chat_*, research_*, artifact_*, auth_*, profile_*, notebook_*).

*Structural:* When an ADR-018 three-layer integration wraps an upstream CLI, the wrapper's `args.push(...)` calls are SCHEMA-COUPLED to the upstream's exact subcommand names + flag shapes + enum values. Upstream is free to evolve those (rename `mindmap` → `mind-map`, refactor flags, add new enum values) between releases. The wrapper has no contract holding upstream stable. No CI test catches the drift. No version pin warns the operator. Silent breakage on upstream upgrade is the default failure mode.

*Process:* v1.2.1.0 self-claimed operator-testing without actually testing through the MCP layer. The wrapper was AUTHORED against the CLI but the AUTHOR tested by reading the upstream's docs, not by invoking the wrapper as an operator would.

**Fix.**

*v1.3.2.2 partial fix (shipped):* 6 high-confidence corrections in `mcp/mxm-notebooklm/server.js`. Each carries inline `// BUG-009 fix (v1.3.2.2):` comment citing the cause. 3 subcommand renames + 2 `--topic` → positional DESCRIPTION + 1 `--query` → REQUIRED positional + 1 audio length enum.

*v1.3.3 candidate (full fix):* Comprehensive 38-tool audit. For every tool in `mcp/mxm-notebooklm/server.js`, run `notebooklm <subcommand> --help` against live CLI, diff against `args.push(...)` calls, fix every mismatch. Add `peerDependencies` version-pin in `mcp/mxm-notebooklm/package.json`. Add a CI step that runs `notebooklm <each-subcommand> --help` and compares against a checked-in snapshot, detecting upstream shape changes before they reach operators.

**Regression guards.**

*Pattern-level:* This is the first articulated occurrence of PATTERN-02 — external-tool wrapper drift against upstream CLI shape. It will recur with every future ADR-018 integration (Notion, Linear, Slack, Figma, Higgsfield, etc.). The mitigation MUST be structural: version-pin the upstream, snapshot `--help` output for each subcommand, CI-diff the snapshot on every upgrade, document the drift in the wrapper's MAXIM_INTEGRATION.md.

*Process-level:* Codify "operator-tested at design time" as a hard discipline. Not direct-CLI testing by the author. End-to-end MCP-wrapper testing by an operator who hasn't seen the wrapper code. This is the only test that catches CLI-shape drift between author intent and runtime reality.

*ADR-018 amendment candidate (v1.3.3):* Promote the snapshot-based drift detection to a § Mandatory Disclosure alongside "license compatibility check" and "fragility disclosure." Title: "Upstream CLI shape stability check (mandatory)."

**Cross-links.**

- BUG-009 (OPEN with 12-mismatch catalog + partial-fix-shipped) — `documents/ledgers/BUG_TRACKER.md`
- CHANGELOG v1.3.2.2 — full bug narrative + lesson logged about v1.2.1.0 self-claimed operator-testing
- ADR-018 (External Tool Integration Pattern) — fragility-disclosure-on-every-output pattern realized; the pattern needs amendment to add upstream CLI shape stability
- BUG-007 (RESOLVED) — earlier external-tool integration discipline failure (plugin-upgrade node_modules absence); same pattern in a different layer
- §3 above — Session 22 pre-release-audit discipline restoration; PATTERN-02 emerged as the second new pattern surfaced in the same session

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
