# Framework: Proactive Watch

> **A universal drift-detection framework for AI-coded, multi-document projects.**
> Ships with Maxim v1.0.0+ as the 64th behavioral framework. Any project adopting Maxim inherits this framework; per-project behavior configured via `config/watch-profile.yml`.

**Category:** Operational · Meta · Governance
**Related frameworks:** File Deduplication, Commit Protocol, Dispatch Sequence, ADR Lifecycle
**Ratified by:** ADR-002 (Documents as Executable Contracts)

---

## Purpose

AI-coded projects accumulate silent regressions:
- Docs say 90 agents, filesystem has 91
- README says v1.0.0, agent-registry says v1.0.0
- CHANGELOG claims feature X, command file is missing
- Bug-042 marked open, code path was deleted weeks ago
- Junctions broken, MCP deps missing, dependencies out of date

Each drift silently erodes trust. Without a continuous watch, drift lives for days, weeks, or forever. The Proactive Watch framework catches it at every session start (and optionally on scheduled cron in later releases).

The **meta-principle** backing this framework: *every document is an executable contract* (ADR-002). Watch is the continuous enforcement layer.

---

## The 11 Universal Drift Classes

Every AI-coded project accumulates drift in these 11 classes. The framework ships a checker for each; projects enable/disable per `watch-profile.yml`.

| # | Class | Typical Example | Default Triage |
|---|---|---|---|
| 1 | **inventory-drift** | Declared capability count ≠ filesystem reality | COO |
| 2 | **version-drift** | Version string mismatches across README / registry / package.json | COO |
| 3 | **contract-drift** | Behavior violates an ACCEPTED ADR | CEO 🔒 |
| 4 | **cross-doc drift** | CHANGELOG claims feature; HELP / docs omit it | COO |
| 5 | **orphan-refs** | Commands point to missing skills; hooks point to missing scripts | CTO |
| 6 | **dependency-drift** | Outdated packages, subtree lag, MCP missing deps | CTO |
| 7 | **git-hygiene** | Uncommitted changes > threshold, branch behind origin | CTO |
| 8 | **junction-drift** | Broken symlinks, wrong junction targets (Windows-specific) | CTO |
| 9 | **stale-handoff** | `.claude-sessions-memory/handoff.md` older than N days | COO |
| 10 | **compliance-drift** | Secret committed, PII leaked, license mismatch | CSO 🔒 |
| 11 | **surface-claims-drift** | Marketing/docs/landing-page hard-codes a count that doesn't match `AGENT_SKILL_INVENTORY.md` | COO |

**🔒 Locked triage:** compliance-drift and contract-drift cannot be re-routed by adopting projects. They preserve Maxim governance integrity.

### Class 11 — surface-claims-drift (added v1.0.1, 2026-04-27)

**Why this class exists.** Class 1 (inventory-drift) catches *filesystem-vs-inventory* mismatch — when `agents/MXM/cino/` has 4 files but `AGENT_SKILL_INVENTORY.md` says 3. Class 11 catches the **complementary** failure mode: *inventory-vs-marketing-copy* drift — when `AGENT_SKILL_INVENTORY.md` says 90 but `README.md` says 88, the landing page's `<StatCell number="88">` says 88, and the pack catalogue still says 88. Without this class, capability counts diverge silently across docs / marketing / website until a human catches it months later.

**Algorithm (LIGHT phase):**

1. Read `documents/ledgers/AGENT_SKILL_INVENTORY.md` and extract canonical numbers for each tracked counter (Section 1: Agents; Section 2: Skill Domains; Section 3: Slash Commands; Section 4: MCP Servers + Tools; Section 5: Hook Scripts; Section 6: Frameworks; Section 7: Compliance).
2. For each counter, scan **declared surface paths** (configurable in `watch-profile.yml`) for hard-coded number literals adjacent to keyword anchors (`agents`, `frameworks`, `commands`, `MCP servers`, `compliance frameworks`, `hooks`, `skill domains`).
3. Pattern: `\b(\d{1,4})\+?\s+(?:specialist\s+|governed\s+|peer-reviewed\s+)?{anchor}\b` (case-insensitive; allows `+`-suffix for "90+ agents").
4. Each numeric mismatch with INVENTORY emits a drift event of severity 3 (warn-only in LIGHT; FULL phase auto-routes to COO review queue).

**False-positive guards.** Pattern requires the keyword anchor adjacent. Currency (`$X.88`), SVG coordinates (`y: 88`), and percentages (`88%`) are excluded by construction since none has the keyword adjacent. Versioned historical docs (`maxim-pack-catalog-v1.0.0.md`) are excluded by glob (`**/v[0-9]*-*.md`). CHANGELOG.md and ADR INDEX.md are excluded — they preserve point-in-time accurate version entries.

**Cross-repo scan.** The `landing-page/` repo is a sibling project that consumes Maxim's identity. Class 11 resolves it via `cross_repo_targets` in `watch-profile.yml` and `MAXIM_LANDING_PAGE` env var. If the env var is unset, landing-page is silently skipped (not flagged as drift) — operator explicitly opts in.

**Companion tooling.** When drift is flagged, `bootstrap/sync-counts.{sh,ps1}` propagates inventory counts mechanically to all declared surfaces. The tool is idempotent — running on a clean tree is a no-op. See [`bootstrap/sync-counts.sh`](../../bootstrap/sync-counts.sh) for the canonical implementation.

---

## Phases

The framework defines three phases, of escalating thoroughness. v1.0.0 ships LIGHT; FULL lands in v1.0.0; CRITICAL in v1.0.0+.

### LIGHT (v1.0.0)
- Runs in SessionStart hook + on-demand via `/mxm-watch`
- Fast (< 3 seconds)
- Surface-level checks — file existence, count comparisons, string grep
- Warn-only — never blocks session start
- Output: inline summary appended to SessionStart banner; details in `.mxm-skills/watch-report.jsonl`

### FULL (v1.0.0)
- Runs on-demand via `/mxm-watch --full` + scheduled cron
- Deeper analysis — semantic drift, cross-doc consistency, ADR conformance
- Agent triage — detected drift routes to office, opens review-queue / bug-tracker / ADR items
- Portfolio-wide rollup across all NK-universe projects

### CRITICAL (v1.0.0+)
- Runs in pre-commit hook
- Blocks commits on critical-contract drift (AGENT_SKILL_INVENTORY, ACCEPTED ADRs)
- Escape hatch: `[contract-drift-ack: <reason>]` in commit message

---

## Per-Project Configuration

Adopting projects write `config/watch-profile.yml`. Unset fields inherit template defaults.

```yaml
enabled: true
phase: light

checkers:
  inventory-drift:
    enabled: true
    source_of_truth: documents/ledgers/AGENT_SKILL_INVENTORY.md
    reality_paths:
      - agents/MXM/**
      - .claude/skills/**
      - .claude/commands/**

  version-drift:
    enabled: true
    anchor: config/agent-registry.json
    must_match:
      - README.md
      - documents/guides/HELP.md
      - documents/guides/ABOUT.md
      - CLAUDE.md
      - package.json
    version_regex: 'v?\d+\.\d+\.\d+'

  contract-drift:
    enabled: true
    adr_dir: documents/ADRs/
    inventory_file: documents/ledgers/AGENT_SKILL_INVENTORY.md

  cross-doc-drift:
    enabled: true
    canonical_docs:
      - CHANGELOG.md
    mirror_docs:
      - README.md
      - documents/guides/HELP.md
      - documents/guides/ABOUT.md

  orphan-refs:
    enabled: true
    check_commands: .claude/commands/
    check_hooks: .claude/hooks/
    check_mcp: .mcp.json

  dependency-drift:
    enabled: true
    npm_paths:
      - mcp/*/package.json
    exclude:
      - community-packs/**

  git-hygiene:
    enabled: true
    stale_uncommitted_hours: 24
    stale_unpushed_hours: 72

  junction-drift:
    enabled: true
    expected_junctions:
      - .mxm-system
      - .claude

  stale-handoff:
    enabled: true
    handoff_path: .claude-sessions-memory/handoff.md
    max_age_days: 7

  compliance-drift:
    enabled: true
    # locked — cannot override triage routing

triage:
  inventory-drift: coo
  version-drift: coo
  contract-drift: ceo         # 🔒 locked
  cross-doc-drift: coo
  orphan-refs: cto
  dependency-drift: cto
  git-hygiene: cto
  junction-drift: cto
  stale-handoff: coo
  compliance-drift: cso       # 🔒 locked

thresholds:
  max_drift_severity: 5       # not enforced in LIGHT; reserved for CRITICAL
  fail_on_error: hybrid       # critical=fail-closed, standard=fail-open
```

---

## Report Schema (standard JSONL)

`.mxm-skills/watch-report.jsonl` — one line per detected drift, any tool can consume.

```json
{"ts":"2026-04-18T12:00Z","phase":"light","project":"maxim","drift_class":"inventory-drift","severity":3,"declared":90,"actual":91,"evidence":"agents/MXM/ceo/new-agent.md","triage":"coo","action":"review-queue"}
```

Severity scale (1–5):
- 1 — cosmetic (e.g., description wording mismatch)
- 2 — minor (e.g., doc lag behind code by < 2 commits)
- 3 — standard (e.g., count drift)
- 4 — material (e.g., ACCEPTED ADR contradicted by new code)
- 5 — critical (e.g., compliance violation, secret drift, orphan hook blocks automation)

---

## Fail-Mode Policy (Hybrid by Severity Tier)

| Checker Tier | On Checker Error | Rationale |
|---|---|---|
| **Critical** (compliance, contract) | Fail-closed — mark drift UNKNOWN, log, escalate | Silent compliance regression = legal/ethical risk |
| **Standard** (other 8 classes) | Fail-open — skip this checker, continue | Buggy checker shouldn't wedge the session |

Every checker error (regardless of tier) writes one line to `.mxm-skills/watch-errors.jsonl`. Nothing fails silently.

---

## Integration with Maxim Architecture

| Layer | How this framework integrates |
|---|---|
| **Framework library** | This doc — one of 64 (v1.0.0+) in `composable-skills/frameworks/` |
| **Skill layer** | `.claude/skills/proactive-watch/` activates the framework |
| **Command layer** | `/mxm-watch [--light\|--full]` manual invocation |
| **MCP layer** | `watch_run`, `watch_report`, `watch_configure` tools on `mxm-context` (7-server consolidation in v1.0.0) |
| **Hook layer** | `session-start.{sh,ps1}` calls watch at phase=light |
| **Office layer** | Triage routing delegates detected drift to offices per matrix |
| **Portfolio layer** | Portfolio sync reads `watch-report.jsonl` across projects → cross-project rollup (FULL phase) |
| **Compliance layer** | `compliance-drift` checker delegates to `mxm-compliance` MCP tools |
| **Contract layer** | Enforces ADR-002 (Executable Contracts meta-principle) |

---

## When to Use This Framework

**Use it:** on every project that adopts Maxim. No opt-out for the framework itself — projects can only tune per-checker flags in their `watch-profile.yml`.

**Skip a specific checker when:** the project structure doesn't generate that drift class (e.g., a non-Windows project may skip junction-drift; a solo monorepo with no external users may skip cross-doc drift checks).

**Extend with custom checkers:** projects can add entries to their `watch-profile.yml` under a `custom_checkers:` block pointing to project-specific scripts. Custom checkers follow the same report-JSONL schema.

---

## Behavioral Science Backing

This framework draws on three behavioral-science principles:

- **Fogg Behavior Model** — B = MAT (Motivation × Ability × Trigger). Watch runs at SessionStart to trigger fix actions while the developer is already engaged (maximum Motivation × Ability).
- **COM-B** — Capability, Opportunity, Motivation for Behavior. Watch provides the Opportunity (visible drift signal) and Capability (clear evidence + action path) while assuming baseline Motivation from the Maxim-adopting team.
- **Present-Bias Mitigation** — catching drift NOW prevents compound cost later (cost of fixing drift grows superlinearly with age; watching is the cheapest intervention point).

---

## Related

- ADR-002 — Documents as Executable Contracts (rationale)
- `CLAUDE.d/protocols.md` § Documents as Executable Contracts (enforcement rules)
- `.claude/skills/proactive-watch/SKILL.md` — skill contract
- `.claude/commands/mxm-watch.md` — user-facing command
- `config/watch-profile.TEMPLATE.yml` — adopter template
- `mxm-context` MCP — `watch_run`, `watch_report`, `watch_configure` tools

---

## Meta

- **Introduced:** v1.0.0 (April 2026)
- **Phase shipped in v1.0.0:** LIGHT only
- **Phase spec deferred:** FULL → v1.0.0; CRITICAL → v1.0.0+
- **Governance:** ADR-002
- **Confidence tag:** 🟢 HIGH (framework is first-class Maxim capability, not external wrapper)
