# Maxim — Debugging Playbook

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

**Status:** 5 entries — §1 captures the v1.0.0 launch install bug-bash (2026-04-21..2026-04-27); §2 captures the Session 15 capability-count drift codification ("DNA gap"); §3 captures the Session 22 pre-release-audit discipline restoration + BUG-008 cross-platform path bug (PATTERN-01 recurrence #4); §4 captures the Session 22 BUG-009 discovery — external-tool wrapper drift against upstream CLI shape (PATTERN-02 candidate); **§5 captures the Session 22 PATTERN-01 recurrences #5 and #6 — bash/Python interop bugs at 2 additional boundaries (v1.3.2.3 Step 3b eval + v1.3.2.3.1 bash-assignment-escape-char)**.

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

## §5 — 2026-05-20 — PATTERN-01 recurrences #5 and #6 (bash/Python interop at 2 additional boundaries)

**Context.** Same calendar day as §3 (BUG-008 PATTERN-01 #4). Two more PATTERN-01 occurrences surfaced in the same session, in scripts that were AUTHORED to apply the §3 BUG-008 lesson. The discipline catches the discipline-author. Each at a distinct bash/Python interop boundary.

### Recurrence #5 — v1.3.2.3 mxm-self-update.sh Step 3b

**Trigger.** v1.3.2.3 shipped `bootstrap/mxm-self-update.sh` with a new Step 3b that re-applies `.mcp-disabled` to the freshly-synced `.mcp.json` after each upgrade. The author (me) had just shipped BUG-008's pathlib fix for Step 4 in v1.3.2.2 — the lesson should have transferred. It didn't.

**Hypothesis tree.**
1. *Step 3b is fine because it uses a heredoc, not a heredoc-with-bash-var-into-Python.* → REJECTED. Audit Cycle 1 read the code: Step 3b uses `Path(r"$INSTALL_DIR")` inside the heredoc, where `$INSTALL_DIR` came from bash-side `ls -d "$INSTALL_CACHE_PARENT"/*/` on line 48. `INSTALL_CACHE_PARENT="${HOME}/.claude/..."`. On Windows Git Bash, `$HOME` = `/c/Users/SDO`. So `$INSTALL_DIR` is MSYS-style `/c/Users/SDO/.claude/...` — exactly the path Python on Windows cannot resolve. Same bug as BUG-008, different file, same script.

**Root cause.** I copy-pasted the heredoc pattern for Step 3b without applying the lesson from Step 4 (which used `Path.home()` natively). The temporal gap between "shipping BUG-008 fix in Step 4" and "writing new Step 3b code" was hours — long enough to forget the lesson. The author is the worst auditor.

**Fix.** Rewrote Step 3b heredoc to use `Path.home()` native discovery inside the heredoc, removing all bash-var-into-Python-path interpolation. Plus promoted Step 3b errors from silent WARN+exit-0 to hard-fail ERROR+exit-1.

**How caught.** Pre-release-audit agent dispatch (Cycle 1 against v1.3.2.3 candidate state). The audit prompt explicitly named Step 3b path-resolution as a check item. Agent read the code, spotted the regression, returned BLOCKERS:1.

### Recurrence #6 — v1.3.2.3 bootstrap/mxm-toggle-mcp.sh discovery block

**Trigger.** v1.3.2.3 also shipped `bootstrap/mxm-toggle-mcp.sh` (the operator-facing toggle). The discovery block at the top uses Python heredoc to compute install + marketplace paths, prints them as `INSTALL_DIR=<path>`, and bash `eval`s the captured output. Audit Cycle 1 did NOT catch this — code reading didn't reveal the bug, because the heredoc was correctly using `Path.home()` Python-native. The bug was downstream: Python's print output goes through bash's eval, which has its own escape-char rules.

**Discovery moment.** Within 1 hour of v1.3.2.3 push, the operator (Mr. Khan) ran `bash bootstrap/mxm-toggle-mcp.sh status` on Windows Git Bash. Output: `Install dir: C:UsersSDO.claudepluginscachemaxim-packsmaxim1.1.0` — backslashes stripped from every path. All subsequent actions (disable/enable/status registry-list) failed because `$INSTALL_DIR` etc. now contained nonexistent paths.

**Hypothesis tree.**
1. *Heredoc preserved the backslashes; the bug must be elsewhere.* → CONFIRMED. The Python heredoc with `Path.home()` produced correct paths like `C:\Users\SDO\.claude\plugins\cache\maxim-packs\maxim\1.1.0`. Python printed them via `print(f"INSTALL_DIR={install_dir}")`. Bash captured via `$(...)` — still intact at this point.
2. *Bash assignment eats backslashes.* → CONFIRMED. The eval'd string contains lines like `INSTALL_DIR=C:\Users\SDO\.claude\plugins\...`. Bash assignment statement parses the unquoted RHS through word splitting + escape-char rules. `\U`, `\S`, `\c` are not recognized escape sequences, but bash STILL strips the backslash. Final `$INSTALL_DIR` value: `C:UsersSDO.claudepluginscachemaxim-packsmaxim1.1.0`. All actions then fail because that path doesn't exist.

**Root cause.** Bash's assignment-statement escape-char processing of Python-PRINTED native Windows paths. **Distinct boundary from BUG-008** (which was bash-VARIABLE-INTO-Python-heredoc) and **distinct from recurrence #5** ($INSTALL_DIR-INTO-heredoc). PATTERN-01 family with three concrete sub-patterns now identified:
- Sub-pattern A (BUG-008): bash $VAR interpolated INTO Python heredoc, MSYS path doesn't open
- Sub-pattern B (v1.3.2.3 Step 3b): same as A, different file
- Sub-pattern C (v1.3.2.3.1): Python prints path → bash eval interprets backslashes as escape sequences → strips them

**Fix.** Emit paths via `Path.as_posix()` so they print with FORWARD slashes. Forward-slash paths survive bash eval intact (no escape interpretation of `/`) AND Python on Windows accepts them natively (pathlib handles both separators). 5 print statements updated in the discovery block.

**How caught.** Live operator test on production Windows machine within 1 hour of v1.3.2.3 ship. Stronger than agent code-review for this class of bug — the agent COULD have caught it by reasoning about bash assignment-escape rules, but the live execution surfaces the actual `eval` behavior unambiguously.

### Combined PATTERN-01 lesson (across recurrences #4 + #5 + #6)

Cross-language string interop is the structural risk. ANY script that crosses bash → Python (or other language) MUST resolve paths INSIDE the inner language's native APIs AND emit them in a separator-neutral form (forward slashes on Windows, or single-quoted to bypass bash escape rules). Three distinct bash/Python boundaries have been bug sites in Maxim's history; each needs explicit handling.

Candidate **ADR-022** for v1.3.3: codify the cross-language path-resolution discipline as a Mandatory Disclosure for any future `bootstrap/*.{sh,ps1}` script. Sub-patterns A/B/C all listed with their concrete failure modes and the validated remediations (pathlib.Path.home() for A/B; .as_posix() for C).

### Discipline trail observation

The 5-ship 1-day cadence demonstrated that **the audit catches the audit-author's own ship** (recurrence #5) AND **the live operator test catches what code review missed** (recurrence #6). Both layers are load-bearing. Self-claimed PASS would have shipped 2 broken patches; the agent + operator-test loop caught them within 1 hour.

**Cross-links.**
- §3 above — BUG-008 PATTERN-01 #4 (sub-pattern A)
- CHANGELOG v1.3.2.3 — recurrence #5 caught in Cycle 1
- CHANGELOG v1.3.2.3.1 — recurrence #6 caught by live operator test
- BUG_TRACKER PATTERN-01 entry (recurrences now numbered #4, #5, #6)
- ADR-022 candidate for v1.3.3 (cross-language path-resolution discipline)

## §6 — 2026-06-20 — Native `claude plugin update` drops MCP node_modules → slow first restart (BUG-007 follow-up; donor-reuse fix, v1.3.7)

**Symptom.** Operator restarted expecting the v1.3.3–v1.3.6 features (esp. the ADR-021 router) live; they were absent. The **installed** plugin was frozen at **v1.3.2.3** (commit `003d4d9`, lastUpdated 2026-05-21). A plain restart reloads the cached plugin — it does NOT pull marketplace updates. The router banner could not fire because the router hook was not installed at all (not the [#10225](https://github.com/anthropics/claude-code/issues/10225) match-but-not-execute bug — simply absent).

**Root cause (the deeper one).** After updating to v1.3.6 via `claude plugin marketplace update` + `claude plugin update`, all 9 MCP `node_modules` were **missing** in the freshly-installed version dir. The native `claude plugin update` installs the new version into a new `…/<version>/` dir **without** carrying `node_modules` (unlike Maxim's own `/mxm-self-update`, which preserves them). The `spawn-with-deps.mjs` wrapper (BUG-007 fix) then `npm install`s all 9 servers on the first MCP spawn — a slow, online-only first restart (5–10 min on Windows; some MCPs exceed the handshake timeout and surface late).

**Fix (v1.3.7, `5a177e2`).** Extended `spawn-with-deps.mjs` with **donor reuse**: on a missing-`node_modules` spawn it finds a **sibling installed plugin version** whose per-server dependency signature (`dependencies` + `optionalDependencies`, ignoring name/version/scripts) is identical and copies its `node_modules` in **offline** (`fs.cpSync`, no npm, no network), falling back to `npm install` only for a genuine fresh install or a real dep change. Records `reused_count` in the sentinel. **Verified on the real machine:** firing the v1.3.7 wrapper printed `reusing … from prior version` for all 9 and wrote `reused: 9, installed: 0` — zero npm installs.

**Immediate remediation (operator hitting a slow post-update restart):** the wrapper self-heals on the next spawn; to skip the wait, copy `…/<prev-version>/mcp/*/node_modules` → `…/<new-version>/mcp/*/node_modules` (deps identical when no MCP changed) + write the `.mcp-deps-installed` sentinel — exactly what v1.3.7 now automates.

**Lessons.**
1. **A restart ≠ an update.** Restarts reload the cached plugin; pulling a new version needs `claude plugin marketplace update <mp>` + `claude plugin update <plugin>@<mp>` (or `/mxm-self-update`). Verify the *installed* version (registry + on-disk feature files), not the source/origin version.
2. **The native update path is not Maxim's update path.** `/mxm-self-update` preserved node_modules; the native `claude plugin update` everyone else uses did not. A mitigation that lives only in Maxim's own updater leaves the majority path broken — put the guarantee where it runs regardless of update mechanism (the spawn wrapper).

**Cross-links.** CHANGELOG v1.3.7 · BUG_TRACKER BUG-007 (original node_modules-absence fix) · `mcp/_shared/spawn-with-deps.mjs`.

---

## §7 — 2026-06-26 — The count/version propagation tools were broken/incomplete (the real cause of recurring count-drift; PATTERN-01 #7)

**Symptom.** Every release (incl. v1.3.8) required a manual "whack-a-mole" sweep of stale capability counts across ~12 docs + the marketplace listing. `bootstrap/sync-version.sh --version X.Y.Z` exited **1 with zero output** and bumped nothing; `config/agent-registry.json`'s version had been chronically stale (1.3.1 while the product was 1.3.7).

**Root cause (two independent bugs).**
1. **`sync-version.sh` — PATTERN-01 #7 (cross-platform path).** The version read was `CURRENT=$(python3 -c "...open('$REGISTRY')..." 2>/dev/null || node -e "...readFileSync('$REGISTRY')..." 2>/dev/null)`. `$REGISTRY` is an MSYS path (`/e/Projects/Maxim/...`); **Windows-native node/python cannot resolve it** (node: `node:fs` ENOENT) → both readers fail → `CURRENT=""` → the command substitution exits non-zero → **`set -e` killed the script at that line, silently** (stderr suppressed by `2>/dev/null`), never reaching the friendly error-check below it. A `set -e` + suppressed-stderr + cross-platform-interpreter combo that fails invisibly.
2. **`sync-counts.sh` — incomplete coverage.** (a) It only matched **compound** anchors ("skill domains", "slash commands"), so bare-form prose ("37 skills", "48 commands") was never updated. (b) It **never scanned `.claude-plugin/marketplace.json`** — the live marketplace *description* shipped "37 skill domains, 48 slash commands" stale. (c) No ADR-count handling.

**Fix (v1.3.8.1).**
- `sync-version.{sh,ps1}` → **pure-shell version read** (grep/sed; no node/python, no MSYS-path dependency), dropped `set -e`, expanded the surface list to all version-bearing files (incl. **marketplace.json ×2** + the inventory stamp), added `--check`/`-Check`. Bumped agent-registry 1.3.1→1.3.8.
- `sync-counts.{sh,ps1}` → added **marketplace.json** to the scan + **ADR-count** forms + bare-form summary anchors, **guarded by middot-adjacency** (see lessons). Now produces only correct fixes (validated: 3 real residuals fixed, 0 false positives; `.ps1 -Check` 0/828).
- **Wired `sync-version --check` + `sync-counts --check` into `pre-commit.{sh,ps1}`** (fail-closed: blocks on exit 1 = drift; version always, counts only when the inventory is staged). Count/version drift now fails the commit instead of shipping.

**Lessons.**
1. **PATTERN-01 #7 — never feed an MSYS absolute path to a Windows-native interpreter.** Read JSON in pure shell (grep/sed) or convert the path. And `set -e` + `2>/dev/null` on the failing line = an *invisible* abort — the friendly error never runs. Prefer explicit error handling over `set -e` when a step's stderr is suppressed.
2. **Bare single-word count matching is unsafe; require a structural signature.** "16 agents · lead:" (office roster), "(26 commands)" (tier breakdown), "top-3 frameworks" (per-agent qualifier), and "14 compliance frameworks" (a *different* count) all share the "N noun" shape. The safe discriminator is **middot `·` adjacency** (the capability-summary signature) — and even that is unsafe for **agents** (office rosters use "N agents ·") and **frameworks** (behavioral-78 vs compliance-14 vs top-3). Only `skills`/`commands`/`ADRs` are unambiguous enough.
3. **.NET regex ≠ perl on un-braced backrefs.** In PowerShell `[regex]::Replace`, a replacement of `"$count$1"` where `$count` is digits produces `"52$1"` → fine, but `"$1$count"` produces `"$152"` → .NET reads `$152` as group 152 (invalid → kept literal). **Brace every group ref (`${1}`)**; perl is unaffected. Caught by a unit test before the file scan.
4. **The tool, not the discipline, was the gap.** "Counts must match on every commit" was real policy, but the propagation tool silently didn't propagate. Fixing the *tool* + a fail-closed pre-commit gate is the structural fix; manual sweeps were treating the symptom.

**Cross-links.** CHANGELOG v1.3.8 (count-propagation note) · [[project_v1.3.8_shipped]] memory (sync-version BROKEN / sync-counts INCOMPLETE) · `bootstrap/sync-version.{sh,ps1}` · `bootstrap/sync-counts.{sh,ps1}` · `.claude/hooks/pre-commit.{sh,ps1}` · PATTERN-01 registry (BUG_TRACKER).

---

## §8 — 2026-06-26 — L1 paid packs `✘ failed to load`: `"skills": ["./"]` rejected by the Claude Code 2.1.136 loader ("Path escapes plugin directory")

**Symptom.** After the operator updated to v1.3.8.1 and restarted, the maxim plugin itself loaded fine (agents + skills + MCP all available), but all 6 installed L1 commercial packs showed `✘ failed to load` in `claude plugin list`, with the loader error: `Path escapes plugin directory: ./ (skills)`. Distinct from the corrupt-install incident — this is a manifest-shape problem, not a partial copy.

**Root cause — a version-gated loader behavior.** Each pack ships a single `SKILL.md` **at the pack root** and declares `"skills": ["./"]` in `plugin.json`. The current published docs (plugins-reference) actually say `["./"]` *is* valid (the `SKILL.md` frontmatter `name` becomes the skill name), and **v2.1.142+** even auto-discovers a root-level `SKILL.md` with **no** `skills` field. BUT the operator runs **Claude Code 2.1.136** — older than both behaviors. On 2.1.136 the loader resolves `pluginRoot + "/" + "./"`, which normalizes to `pluginRoot` *exactly* (no trailing separator), so the "must be strictly inside the plugin dir" check fails → "Path escapes plugin directory." The maxim plugin was unaffected because it declares `"skills": "./.claude/skills/"` — a string path to a **subdirectory** that *contains* skill subdirs, which passes the strictly-inside check.

**Fix (version-robust — works on every Claude Code version).** Give each pack the explicit subdirectory layout instead of the terse root form:
- move `SKILL.md` → `skills/<slug>/SKILL.md` (slug = pack topic, e.g. `ai-governance`)
- set `"skills": "./skills/"` (string path to the parent dir — exactly the maxim plugin's proven pattern)

Applied to all **14 source packs** (`packs/pack-l{1,2,3}-*`, uncommitted) **and** the **6 live cache packs** (`~/.claude/plugins/cache/maxim-packs/mxm-pack-l1-*/1.0.0/`). After the cache edit, `claude plugin list` re-evaluated and all 6 flipped to `✔ enabled`.

**Lessons.**
1. **Plugin-manifest features are version-gated; the docs describe the newest loader.** `["./"]` validity and root-`SKILL.md` auto-discovery both require *newer* than the operator's 2.1.136. Always test a manifest change against the operator's actual `claude --version`, not against "what the docs say is supported."
2. **Prefer the explicit `skills/<name>/SKILL.md` + `"skills": "./skills/"` layout for shipped packs.** It is the lowest-common-denominator that loads on every version. The terse `["./"]` is a newer convenience that silently breaks older installs.
3. **`claude plugin validate` ≠ load.** Validate only checks the manifest JSON schema — the broken `["./"]` pack *passes* `validate` yet fails at load. The real verification is a reload (`claude plugin list` re-evaluates load status, or `/reload-plugins` in-session). Don't trust validate to catch path-escape rejections.
4. **A healthy host plugin can coexist with failing child packs.** "No mxm commands" and "packs failed to load" were two *separate* issues sharing one restart — diagnose each independently rather than assuming one root cause.

**Cross-links.** [[project_v1.3.8_shipped]] memory (L1-packs note → now RESOLVED) · `packs/pack-l*/.claude-plugin/plugin.json` · plugins-reference doc (skills field, lines on `["./"]` validity + v2.1.142 auto-discovery) · §6 (the corrupt-install incident this was initially conflated with).

## §9 — 2026-07-08 — "MCP server errors after restart" traced to the slow Python `mempalace` MCP, not Maxim (BUG-013 corrected)

**Symptom.** After a plugin update + restart, the operator saw "MCP server errors / servers did not start" — twice. Initial (wrong) hypothesis: a Maxim `spawn-with-deps.mjs` deps-sentinel spawn race dropping all Maxim servers on the first restart.

**What actually happened.** `claude mcp list` (the authoritative health check) showed **all 9 `plugin:maxim:mxm-*` servers ✔ Connected**; only **`mempalace`** (a SEPARATE, non-Maxim Python MCP, `~/.mempalace-env/Scripts/python.exe -m mempalace.mcp_server`, v3.1.0) was **✘ Failed to connect**. A live MCP `initialize` handshake to `mxm-catalog` returned a valid result. `mempalace` imports fine and, with **stdin held open**, returns a valid `initialize` after a few seconds while logging `MemPalace MCP Server starting…` — so it works, it just cold-starts (Python + DB/embedding) slower than Claude Code's connection/handshake window allows, especially with ~10 servers spawning concurrently at restart.

**Lesson — diagnose MCP failures from the health check, not from in-session tool churn.** Claude Code shows a single aggregate "MCP server errors" banner for ANY failing configured server, including non-Maxim ones; and a coding session's deferred-tool list churns independently of server health. The `/dev/null` manual-spawn test is inconclusive (stdio servers exit 0 cleanly on stdin EOF) — **send a real `initialize` with stdin held open** to prove liveness. My first BUG-013 root cause inferred server death from the in-session tool churn; the health check refuted it.

**Fix (operator-env, no Maxim code).** Raise `MCP_TIMEOUT` (ms) before launching Claude Code (`setx MCP_TIMEOUT 60000`, relaunch; 120000 if still slow) so slow Python servers finish the handshake; and reduce concurrent cold-spawn load (`bash bootstrap/mxm-toggle-mcp.sh disable mxm-notebooklm`; note native `claude plugin update` does NOT re-apply `.mcp-disabled` — only `/mxm-self-update` does). Documented in `mcp/README.md` § Troubleshooting + BUG-013.

**Cross-links.** BUG-013 (corrected) · `mcp/README.md` § Troubleshooting · PATTERN-03 (heavy-MCP cold-spawn tax).

---

## §10 — 2026-07-10 — Desktop MCPs "failed": a TRUNCATED node_modules that passed the presence check + a config hard-coded to an orphaned version dir (BUG-014 + BUG-015)

**Symptom.** After updating to v1.3.9, Claude Desktop → Developer → Local MCP servers showed **every `mxm-*` server "failed / Server disconnected."** Two distinct bugs stacked.

**Layer 1 — dead path (BUG-015).** The config's server args pointed to `…/maxim/**1.1.0**/mcp/…` — a dir native `claude plugin update` had emptied (updates create *versioned* dirs `1.3.7 / 1.3.8.4 / 1.3.9`; the old cosmetic `1.1.0` dir the Desktop config was pinned to no longer had files). `claude_desktop_config.json` is not managed by plugin updates, so a hard-coded version orphans on every update.

**Layer 2 — truncated deps (BUG-014).** Even after repointing to `1.3.9`, a manual smoke test (`node <spawn-with-deps> <server.js>` with a real `initialize` piped) surfaced `ERR_MODULE_NOT_FOUND: '…/@modelcontextprotocol/sdk/server/mcp.js'`. The `node_modules` **dir existed** but was **incomplete** (missing `zod` entirely; the SDK present without `server/mcp.js`). `spawn-with-deps` checked only `existsSync(node_modules)`, so it skipped the rebuild — and `findDonorNodeModules` had **copied the broken tree forward across every version dir** via `cpSync` without validating it. Deleting the broken `node_modules` made the wrapper repopulate it correctly.

**Lesson — presence ≠ completeness; and a stable path beats a re-pointed one.** (1) A dependency check must verify more than "the dir exists" — a whole dep can be missing (`zod`) while the dir is present — and a donor must be validated before it is copied, or one bad install propagates forever. (2) Any config outside the updater's control (Desktop MCP config) must point at a **version-independent** path that resolves the latest at runtime, not a version dir that updates orphan. Same "restart ≠ update ≠ **configured**" skew family as §6 / BUG-013.

**Second lesson — "completeness" is dependency-presence, NOT entry-file resolution (the pre-release audit's catch).** The first fix attempt verified each dep's `package.json` *entry file* (the `.` export target). The **pre-release audit reproduced it false-positiving every valid install**: the real `@modelcontextprotocol/sdk@1.29.0` declares `"." → ./dist/esm/index.js` but **doesn't publish that file** (consumers import subpaths like `./server/mcp.js`), so an entry-file check flags a working tree "incomplete" → deletes + reinstalls it **every spawn** → permanent Desktop timeout + a regressed donor-reuse. The corrected check is **dependency-presence** (a readable `package.json` per declared dep): it never false-positives, and it catches the operator's real failure (a whole missing `zod`). It also corrected my own bad diagnostic — the "SDK `server/mcp.js` missing" I first cited resolves via `exports` into `dist/`, not a root path, so a literal `existsSync('…/server/mcp.js')` is meaningless. *(Where the audit found what the tests missed: no fixture modeled a shipped-package with a non-shipped `.` target.)*

**Fix (v1.3.9.1).** `spawn-with-deps.mjs` gains `depsComplete()`/`depInstalled()` (every declared dependency has a readable `package.json`) wired into the gate, install loop (rm-incomplete-then-rebuild), donor selection (skip broken donors), and post-copy/post-install validation — `spawn-with-deps.test.mjs` (9/9, incl. the audit's false-positive shape as a regression test). New `bootstrap/mxm-desktop-launcher.mjs` resolves the latest version at spawn from a stable user path; `mxm-desktop-config.{sh,ps1}` install it and write version-free entries. Operator's live Desktop config migrated to the launcher.

**Cross-links.** BUG-014 · BUG-015 · §6 (donor-reuse) · Fable P1-3 (MCP attach reliability — this is the "presence-not-completeness" gap it named).

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).

---

## §11 — 2026-08-20 — A drift gate that reports CLEAN, and a canonical tag that deindexes 23 pages

**Two failures, one lesson: the check that passes is not the check that matters.**

### What broke

An SEO/GEO audit of maxim.isystematic.com, done by **parsing served HTML** rather than reading source or trusting a summarizing fetch, surfaced two defects that every prior review had missed.

1. **23 of 24 pages served `<link rel="canonical" href="https://maxim.isystematic.com">`.** Every framework, comparison, docs, pricing and legal page declared the *home page* as its canonical, instructing Google to consolidate them all into `/`. Root cause: `app/layout.tsx` set `alternates: { canonical: "/" }` in the **root layout**, and none of the 22 page files overrode it. Next.js resolves that against `metadataBase` and emits it on every descendant route. One line, sitewide, invisible in review because the home page (the page anyone spot-checks) was correct.
2. **`bootstrap/sync-counts.sh --check` reported `landing-page: 0 of 49 surface files modified`** while the live site served `softwareVersion: "1.1.1"` against a shipped **1.3.9.1**, plus `90 agents`, `78 frameworks`, `47 tools`. See BUG-016 for the four coverage gaps.

### Why it stayed hidden

- **The correct sample was the unrepresentative one.** The home page canonical was right. Checking "does the site have canonicals" returns yes. Checking *each page against its own URL* returns 23 failures. Aggregate questions hide per-item defects.
- **A gate reporting CLEAN is trusted more than no gate.** `sync-counts` existed precisely to stop stale counts shipping. Because it printed clean, nobody looked, and the stale values reached the public JSON-LD that answer engines quote.
- **Source review could not see it.** Both defects only exist in the *served artifact*. The canonical is synthesised by the framework at render; the count drift was in files the collector never globbed. Reading the repo would never have found either.

### The rule

**Assert against the served artifact, per item, never in aggregate.** A gate that answers "is the site fine?" is worth less than one that answers "is *this URL* fine?" 24 times.

### Second-order lesson: my own checkers produced two false findings in this session

Both were caught before being reported, and they are the reason the rule above is worth writing down.

- A FAQ visibility checker reported `0/8 visible` on **every** page including the home page. A uniform-zero result across a whole corpus is far more likely to be a broken checker than a uniform defect. Re-verified by a second method (strip `<script>` blocks, then grep raw) — the finding held, but only after the second method agreed.
- A title-length checker reported one title over 60 characters. It was counting `&#x27;` as six characters. Decoded, it passed. **Measure the decoded string, not the transport encoding.**
- A JSON-LD graph walker reported `Organization` and `WebSite` twice per page. The walker visited `@graph` once explicitly and again via `Object.values()`. The page was correct; the tool was not.

This is DEBUGGING_PLAYBOOK's standing rule restated with fresh evidence: **a check you wrote reporting a failure is a hypothesis.** Three of this session's hypotheses were wrong. The discipline of confirming with an independent method before reporting is what kept them out of the audit.

### Where it landed

- Fixes: landing-page `65bc333` (36 files) — canonicals on 17 static pages + 2 dynamic generators, FAQ cloaking, entity contract, security headers, robots, sitemap, llms.txt
- **Verified live after deploy: 21/21 assertions pass against production URLs**, not against the local build
- Tooling gap: **BUG-016, OPEN** — real fix is the v1.4 derived-counts registry

