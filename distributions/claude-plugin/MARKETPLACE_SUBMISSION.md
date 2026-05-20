# Maxim — Anthropic Official Marketplace Submission

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
> v1.3.2.2 refresh — supersedes the pre-launch v6.4.4 draft and the v1.3.2.1 interim refresh. Source-of-truth for capability counts: `documents/ledgers/AGENT_SKILL_INVENTORY.md`.

**Target:** Anthropic Official Claude Code Plugin Marketplace
**Plugin namespace:** `maxim`
**Submission version:** 1.3.2.2
**Tag:** `v1.3.2.2` (commit SHA recorded in git tag annotation at tag-creation time; v1.3.2.1 was `ac4a7fe7b3f28f7d4ed9c93759138eab8aee89a0`)
**Submitter:** Dr. Nabeel Khan / iSystematic
**Contact:** https://maxim.isystematic.com/contact

---

## What Maxim is (for Anthropic reviewers)

Maxim is a **behavioral intelligence layer** that sits on top of Claude Code. Not a prompt library, not a chat wrapper. It ships a governed multi-agent operating system with structural enforcement of: framework citation on every output (ADR-007), confidence tagging on every output (ADR-010), 14-framework compliance enforcement at the MCP layer (ADR-004), 13-class proactive drift detection, voice-routed writing agents (ADR-016), two-layer office-as-dispatch with cross-surface parity (ADR-017), three-layer external-tool integration pattern (ADR-018), and multi-tenant install wizard with behavioral-persuasion framings (ADR-019).

Live since 2026-04-21 (v1.0.0 launch). Currently at v1.3.2.2. Used by 21+ projects across the iSystematic portfolio.

---

## Submission package — current artifacts

### Required (plugin spec)

| Artifact | Path | Status |
|---|---|---|
| Plugin manifest | `.claude-plugin/plugin.json` | v1.3.2.2 — declares 91 agents · 36 skills · 48 commands · 74 frameworks · 14 compliance · 9 MCPs (95 tools) · 90-day Trial of 14 packs default |
| Marketplace manifest | `.claude-plugin/marketplace.json` | v1.3.2.2 — pack catalog (Maxim base plugin + 14 paid packs across L1 · L2 · L3 tiers) · outer metadata.version + plugin entry version both at 1.3.2.2 (per v1.3.2.1 Bucket 1 amendment) |
| README | `README.md` (root) | v1.3.2.2 with 9-MCP/95-tool table, 6 use cases, ADR index (15 public · 4 confidential) |
| LICENSE | `LICENSE` (root) | BSL 1.1 — converts to Apache 2.0 after 4 years per ADR-005 |
| Version | `1.3.2.2` consistent across plugin.json + marketplace.json (outer + plugin entry) + README badge + this submission doc | Verified by v1.3.2.2 pre-release-audit Cycle 1 Bucket 1 (the bucket Mr. Khan added in v1.3.2.1 after the catalog metadata.version drift was caught) |

### Ship-ready content (counts verified against `server.tool()` declarations + filesystem)

| Component | Path | Count |
|---|---|---|
| Specialist agents | `agents/MXM/` | 91 (80 office specialists + 10 cross-office orchestrators + 1 executive-router) |
| Dispatchable subagents | `.claude/agents/` (declared in `plugin.json` agents[]) | 24 (7 office + 10 orchestrators + 7 utility/lead-compat) |
| Skill domains | `.claude/skills/` | 36 (incl. voice-routing · notebooklm-py) |
| Slash commands | `.claude/commands/` | 48 (7 TIER 1 verb-first · 10 TIER 2 office · 5 TIER 3 persona · 26 domain/workflow) |
| Behavioral frameworks | `composable-skills/frameworks/` + `documents/reference/FRAMEWORKS_MASTER.md` | 74 |
| Compliance frameworks | enforced by `mxm-compliance` MCP + `.claude/skills/compliance/SKILL.md` | 14 (GDPR · PIPEDA · UAE-PDPL · HIPAA · PCI-DSS · SOC2 · ISO 27001/13485/14971 · NIST CSF · EU AI Act · CASL · FINTRAC · WCAG 2.1) |
| MCP servers | `mcp/mxm-*/server.js` | 9 servers · 95 tools (portfolio 9 · context 15 · catalog 9 · compliance 5 · behavioral 7 · memory 6 · voice 4 · commands 2 · notebooklm 38) |
| Hooks | `.claude/hooks/` | 14 scripts (7 hooks × 2 platforms — session lifecycle · git hygiene · pre-commit · junction guard · behavioral-moat drift) |
| Proactive Watch drift classes | `composable-skills/frameworks/proactive-watch.md` | 13 classes (4 free at Core severity · 9 gated severity-block at Pro+) |
| Output styles | `distributions/claude-plugin/output-styles/mxm-mode.md` | 1 (`mxm-mode`) |
| Statusline | `.claude/hooks/mxm-statusline.{sh,ps1}` | 2 (bash + PowerShell) |
| Binary | `mxm-pack-engine` | Cross-platform (linux/amd64 · darwin/arm64 · darwin/amd64 · windows/amd64) |
| Architecture Decision Records | `documents/ADRs/ADR-001..ADR-019` | 19 total (15 public · 4 confidential) |
| Architecture Decision Records — public list | INDEX.md | ADR-002 · 004 · 007 · 008 · 009 · 010 · 011 · 012 · 013 · 014 · 015 · 016 · 017 · 018 · 019 |

### Supporting documentation (quality signal for reviewers)

| Document | Path | Purpose |
|---|---|---|
| Agent + skill inventory | `documents/ledgers/AGENT_SKILL_INVENTORY.md` | Single source-of-truth for capability counts. Verified per release against `server.tool()` grep + filesystem. |
| Frameworks master | `documents/reference/FRAMEWORKS_MASTER.md` | 74 peer-reviewed behavioral frameworks with author/year citations + mechanism statements |
| Ethical guidelines | `documents/governance/ETHICAL_GUIDELINES.md` | Governance boundaries · CSO auto-loop triggers · ethics gate triggers per ADR-007 |
| MOAT tracker | `documents/ledgers/MOAT_TRACKER.md` | 13 defensibility claims with mechanism + framework citation + anti-pattern (Executable Contract per ADR-002) |
| Bug ledger | `documents/ledgers/BUG_TRACKER.md` | 8 entries (7 RESOLVED · 1 OPEN) + PATTERN-01 recurring-pattern registry |
| Debugging playbook | `documents/ledgers/DEBUGGING_PLAYBOOK.md` | 3 entries — append-only failure-pattern journal |
| Changelog | `CHANGELOG.md` | Release history from v1.0.0-rc.1 (2026-04-21) through v1.3.2.2 (2026-05-20). Pre-release-audit dispatch documented for v1.3.2 + v1.3.2.1 + v1.3.2.2 (3 consecutive disciplined ships). |
| Session continuity bridge | `documents/ledgers/SESSION_CONTINUITY.md` | Cross-session state pickup — gitignored, runtime-local |
| Distribution guide | `distributions/claude-plugin/DISTRIBUTION.md` | End-user install + tier model (Solo · Pro · Team · Enterprise + L3 verticals + 90-day Trial default) |

---

## Differentiation — why Maxim is not a generic agent library

### 1. Framework citation enforced on every output (ADR-007 doctrine)

Every Maxim emission names the behavioral science framework that justifies it. Generic LLM "looks good" output is structurally impossible to ship — `behavioral-overlay-orchestrator` rejects pre-emit any output that does not cite at least one named framework with mechanism stated.

74 frameworks cataloged in `FRAMEWORKS_MASTER.md`. Each pack's SKILL.md cites a primary framework (Prospect Theory · Cognitive Load Theory · Signal Detection Theory · COM-B · Dual Process Theory · Fogg B=MAP). Frameworks are the moat — not the count of agents.

### 2. Governance as enforcement, not documentation

- **CSO auto-loop** fires automatically on regex-matched security/compliance/PII/regulated prompts. Non-bypassable; even super-user mode cannot disable for regulated content. `security-analyst` agent reviews every task touching regulated data and returns BLOCK / COMPLIANT / REMEDIATE verdicts.
- **License gate** at the MCP layer per ADR-003 (confidential). Paid packs are gated at every tool call via JWT signature check + tier grant verification + daily heartbeat for revocation propagation. Open-source code + gated runtime.
- **Behavioral-moat prompt hook** refuses to ship external-facing output that does not apply at least one named framework with mechanism stated.

### 3. Audit trail as the defensibility

Every AI decision produces a structured activity record. `activity.jsonl` is the evidence that makes governance auditable, not aspirational. See MOAT-01 (AI Governance, Prospect Theory loss-framing) in `MOAT_TRACKER.md`.

Pre-commit hook scans for secrets · PII · regulated content and writes to `.mxm-skills/compliance-audit.jsonl`. Pre-release-audit agent dispatched before every tag (codified after v1.3.2 broke a 5-release self-claimed-PASS anti-pattern — Session 22 lesson, see CHANGELOG v1.3.2 + v1.3.2.1).

### 4. ADR coverage (architecture as contract)

19 Architecture Decision Records. ADR-002 ratifies "Documents as Executable Contracts" — five canonical ledgers (`CHANGELOG` · `MOAT_TRACKER` · `BUG_TRACKER` · `DEBUGGING_PLAYBOOK` · `AGENT_SKILL_INVENTORY`) are read by the pre-commit hook as live state. Drift between claim and reality blocks the commit.

**Public ADRs (15):** ADR-002 (Executable Contracts) · ADR-004 (Free Tier Contract) · ADR-007 (Behavioral Moat Framing) · ADR-008 (Community Pack System) · ADR-009 (Pack Architecture: 6 L1 + 4 L2 + 4 L3) · ADR-010 (Confidence Tag Rubric) · ADR-011 (Stripe Payment) · ADR-012 (Maxim Overlay Engine MOE) · ADR-013 (Multi-Project Memory Inheritance) · ADR-014 (Maxim Studio AGPL) · ADR-015 (Studio v0.2+ Roadmap) · ADR-016 (Voice Writing Agent Architecture) · ADR-017 (Office-as-Dispatch-Boundary + MCP-Catalog Specialist Surface) · ADR-018 (External Tool Integration Pattern) · ADR-019 (Multi-Tenant Readiness).

**Confidential (4):** ADR-001 (agent dispatch baseline) · ADR-003 (Cloudflare Worker JWT issuance) · ADR-005 (IP Protection: 5-layer architecture) · ADR-006 (External Content Boundary).

### 5. Proactive drift detection — 13 classes ship in Core

`/mxm-watch` runs 13 drift classes at every session start. 4 classes free at Core severity (inventory · version · cross-doc · stale-handoff). 9 additional classes ship in L1.3 Proactive Watch pack with severity-block at Pro+. Signal Detection Theory per-class operating points documented in `composable-skills/frameworks/proactive-watch.md`.

Class 11 (surface-claims-drift) caught the v1.3.2 MCP tool count error (87 → 95) that had drifted through v1.2.0 → v1.3.1 unnoticed.

### 6. Pre-release-audit discipline (structural — Session 22 codification)

After v1.2.0.4 → v1.3.1 (5 consecutive releases) self-claimed "pre-release-audit PASS" in CHANGELOG without dispatching the agent, Session 22 (2026-05-20) broke the anti-pattern: v1.3.2 + v1.3.2.1 each dispatched `maxim:pre-release-audit` BEFORE the tag fired. 4 audit cycles caught 9 P1 blockers + 7 P2 carryovers + 1 OPEN bug. The discipline is now self-reinforcing — every patch from v1.3.2 forward dispatches the audit agent before any CHANGELOG audit-claim line is written.

### 7. Cross-surface parity by construction (ADR-017)

Two-layer dispatch: 24 dispatchable subagents at the routing tier (declared in `plugin.json` agents[]) + 91-agent specialist catalog reached programmatically via `mxm-catalog` MCP. Same specialist routing surface on Claude Code AND Claude Desktop AND Claude.ai Web (via MCP). 91 reachable; 24 dispatchable. The "91 agents" claim is structurally true, not aspirational.

### 8. Three-layer external-tool integration (ADR-018)

NotebookLM integration (v1.2.1.0) is the canonical reference implementation: community-pack copy of upstream MIT skill (`community-packs/notebooklm-py/`) + Maxim-flavored skill with behavioral framing (`.claude/skills/notebooklm-py/SKILL.md` — cites Diátaxis + Diffusion of Innovations + Dual Coding Theory) + 38-tool MCP wrapper (`mcp/mxm-notebooklm/server.js`). Every operation carries a fragility disclosure (upstream uses undocumented Google APIs). CSO source-upload ethics gate fires before Google ingestion.

---

## Submission process

### Current state of Anthropic marketplace ingestion

The Anthropic Claude Code plugin marketplace ingestion process **is not codified in this document** because the canonical process lives at `https://docs.claude.com/claude-code/plugins/marketplace` and may change. As of v1.3.2.2 submission preparation (2026-05-20), three paths are likely:

1. **Git repository submission** — submit the GitHub repo URL `https://github.com/DrNabeelKhan/maxim` (with `marketplace.json` at `.claude-plugin/marketplace.json`). Anthropic's marketplace ingester would read the manifest from the repo's default branch.
2. **Marketplace registry PR** — open a PR against Anthropic's marketplace registry repo (if such a registry exists) with a Maxim entry pointing to the GitHub location + release tag.
3. **Direct submission form** — web form on Anthropic's Claude Code site collecting plugin metadata + repo URL + maintainer contact.

**Operator action required (manual):** Submitter must verify the current process at `https://docs.claude.com/claude-code/plugins/marketplace` before initiating submission. This document captures the metadata package; the submission mechanism itself is Anthropic-determined.

### Required submission metadata (consolidated for all paths)

| Field | Value |
|---|---|
| Plugin name | `maxim` |
| Display name | Maxim |
| Version | `1.3.2.2` |
| Description | The behavioral intelligence layer for Claude. 91 specialist agents across 7 executive offices, 36 skill domains, 48 slash commands, 74 peer-reviewed behavioral frameworks, 14 compliance frameworks, 9 MCPs (95 tools) including NotebookLM research synthesis, license-gated MCP middleware, 13-class proactive drift detection. 90-day Trial of all 14 packs default at install. BSL 1.1 licensed. |
| Author | Dr. Nabeel Khan / iSystematic Inc. |
| Author email | nabeel@nabeelkhan.com |
| License | BSL 1.1 (Apache 2.0 conversion on 2030-04-21 per ADR-005) |
| Homepage | https://maxim.isystematic.com |
| Repository | https://github.com/DrNabeelKhan/maxim |
| Release tag | `v1.3.2.2` |
| Commit SHA | recorded in git tag annotation at tag creation (v1.3.2.1 was `ac4a7fe7b3f28f7d4ed9c93759138eab8aee89a0`) |
| Keywords | behavioral-science · ai-governance · compliance · multi-agent · claude-code · executive-router · drift-detection · mempalace · behavioral-intelligence · prospect-theory · fogg-behavior-model · com-b |
| Category | Agent / Governance / Behavioral Intelligence |
| Pricing model | Core free forever (BSL 1.1 substrate · 91 agents · 95 tools · 13 drift classes · 14 compliance advisory) + 14 paid packs across 3 tiers (6 L1 capability + 4 L2 vertical bundle + 4 L3 industry overlay) + 90-day Trial default unlocking all packs |
| Trial mechanism | 90-day Trial of all 14 packs · no card required · cancel anytime · JWT-gated · default-pre-selected per ADR-019 behavioral framing (Default Effect + Endowment Effect + Loss Aversion) |

### Pre-submission checklist (must pass before initiating Anthropic-side process)

- [x] Plugin manifest version, marketplace.json (outer + plugin entry), README badge, AND this submission doc all agree on `1.3.2.2` (verified Cycle 1 + 2 of v1.3.2.2 pre-release-audit, including the Bucket 1 amendment that catches outer catalog metadata.version drift — added after Mr. Khan caught it in v1.3.2.1)
- [x] `claude mcp list` shows 9 Maxim MCPs ✓ Connected on a fresh restart
- [x] `bash bootstrap/install-tier-packs.sh` wizard runs and offers all 6 install paths (Trial · Solo · Pro · Team · Enterprise · Individual)
- [x] `git log --oneline` shows `v1.3.2.2` tag (SHA in git tag annotation); tag pushed to `origin/main`
- [x] BUG-008 (mxm-self-update.sh Windows MSYS path) RESOLVED in v1.3.2.2 with pathlib.Path.home() Python-native resolution + 3 regression-guard hardenings (hard-fail on read/write error, round-trip SHA verification)
- [x] BUG-009 (mxm-notebooklm wrapper CLI-shape drift) OPEN with 6 catastrophic-tier fixes shipped in v1.3.2.2; remaining 6 confirmed mismatches + 29 unaudited tools deferred to v1.3.3 with full-audit candidate documented in BUG_TRACKER
- [x] AGENT_SKILL_INVENTORY.md counts match `server.tool()` grep (95 tools across 9 MCPs)
- [x] Pre-release-audit dispatched against the candidate state; CHANGELOG entry records real findings, not self-claimed PASS
- [x] BUG_TRACKER.md updated with any new bugs (Session 22 logged BUG-008 OPEN — Windows Git Bash Python heredoc path bug; manual remediation documented; v1.3.3 fix scheduled)
- [x] DEBUGGING_PLAYBOOK.md updated with new failure patterns (§3 Session 22)
- [x] Session-end closure bundle committed and pushed (`707b939`)
- [ ] **Operator action:** verify current Anthropic marketplace submission process at https://docs.claude.com/claude-code/plugins/marketplace
- [ ] **Operator action:** initiate submission per Anthropic's current mechanism (form / PR / contact)

### Post-submission

- [ ] Monitor Anthropic marketplace submission queue for review status
- [ ] Respond to Anthropic reviewer feedback within 5 business days
- [ ] Announce plugin availability on iSystematic channels after approval
- [ ] Update README badge with `/plugin install maxim@anthropic-official` (if Anthropic provides an official namespace)
- [ ] Update PACKS.md and maxim-one-pager.md install instructions to surface the Anthropic-official install path

---

## Known limitations at v1.3.2.2 submission

1. **BUG-008 RESOLVED v1.3.2.2.** `mxm-self-update.sh` Python heredoc now uses `pathlib.Path.home()` for native cross-platform path resolution. Hard-fail on registry read/write errors. Round-trip SHA verification after write. The "silent stderr WARN, exit 0" failure mode is structurally impossible. Operators on Windows Git Bash, WSL, Mac, Linux all use the same code path now.

2. **BUG-009 OPEN v1.3.2.2 (partial fix shipped).** `mxm-notebooklm` MCP wrapper has 12+ confirmed CLI-shape mismatches against current `notebooklm-py` 0.4.1 CLI (subcommand renames, flag vs positional, enum drift). 6 catastrophic-tier fixes shipped in v1.3.2.2: `slides` → `slide-deck`, `datatable` → `data-table`, `mindmap` → `mind-map`, infographic + slides + data_table description args, audio length enum. Remaining 6 confirmed + 29 unaudited tools deferred to v1.3.3 full wrapper audit. Operator workaround: use direct CLI (`notebooklm <subcommand>`) for affected tools. PATTERN-02 candidate (external-tool wrapper drift) documented.

3. **First-restart cold-warm on Windows.** After self-update, the first Claude Code restart takes 5-10 minutes while 9 MCPs cold-spawn concurrently and Windows Defender scans node_modules. Subsequent restarts are normal speed. Warning is in `mxm-self-update.{sh,ps1}` completion banners (v1.3.2.1+).

3. **MCP cold-attach handshake-timeout race.** Heavier MCPs (notebooklm Python wrapper · mempalace Python venv · vazir initialization) sometimes exceed Claude Code's MCP handshake timeout during the 9-concurrent-MCP cold-start window. Symptom: `claude mcp list` reports `✗ Failed to connect` for one or more MCPs; tools eventually surface as the bridge warms. Not a bug — environmental. v1.4 hardening candidate: extend handshake timeout OR sequential cold-spawn.

4. **ADR-009 amendment pending v1.3.3.** ADR-009 defines L2 as "subscription tiers" (Solo/Pro/Professional/Team); v1.3.0 wizard ships L2 as "vertical bundle packs" (founder-os/growth-stack/pro-os/agency-all). PACKS.md v1.3.2 reconciles this in operator-facing docs; ADR amendment pending.

5. **ADR-017 amendment pending v1.3.3.** ADR-017 text says "~19 dispatchable subagent files"; actual count is 24 (per `plugin.json` agents[] array length). Reality is correct in all operator-facing surfaces; ADR text needs amendment.

6. **Cross-platform shell-script discipline gap (PATTERN-01).** Four occurrences of cross-platform structural assumptions surfaced through v1.0.0 launch (BUG-003 · BUG-004 · BUG-005) + Session 22 (BUG-008). Candidate ADR-022 for v1.3.3+ governing how shell scripts handle path resolution across Mac/Linux/WSL/Git Bash/native Windows.

All limitations are documented honestly here so reviewers can evaluate without surprise. None are launch-blockers; all have remediation paths.

---

## Quality signals — recapitulation

For Anthropic reviewers, the five differentiation axes (above) plus the discipline trail (CHANGELOG v1.3.2 + v1.3.2.1 honest accounting of broken anti-pattern + 4 audit cycles + 9 P1 blockers caught + 7 P2 carryovers + 1 OPEN bug) plus the executable-contracts ledger system (ADR-002) plus framework citations on every output (ADR-007) plus structural compliance enforcement (CSO auto-loop) plus 90-day Trial default unlocking the full moat for evaluation (ADR-019 behavioral persuasion framing) — these are the quality signals.

Maxim is the only Claude Code plugin where: every output cites a framework + every output carries a confidence tag + compliance fires automatically + drift gets caught before ship + voice locks across surfaces + the audit trail is structural rather than aspirational.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
