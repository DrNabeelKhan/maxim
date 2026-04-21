---
name: /mxm-watch
description: Proactive drift detection across 10 universal drift classes. Surfaces silent regressions between declared reality (docs, inventories, ADRs) and actual reality (filesystem, git, deps).
skill: proactive-watch
office: coo
lead_agent: planner
framework: composable-skills/frameworks/proactive-watch.md
adr: documents/ADRs/ADR-002-executable-contracts.md
confidence_default: 🟢 HIGH
---

# /mxm-watch

> **Proactive Watch** — continuous enforcement of the Executable Contracts meta-principle.
> Catches drift at every invocation across 10 drift classes. Reports with severity, triage routing, and evidence.

---

## Purpose

v1.0.0 shipped with two near-disasters caught manually pre-commit:
- Agent count drift (87 vs 88 — fix required 6 doc changes)
- "vaporware" delete (171 files auto-restored only because a human looked twice)

Both would have been caught by `/mxm-watch` at session start. This command makes drift-detection a visible habit, not an afterthought.

---

## Usage

```
/mxm-watch                         # run all enabled LIGHT-phase checkers
/mxm-watch --light                 # explicit LIGHT (default)
/mxm-watch --checker <name>        # run a single checker
/mxm-watch --list                  # list available checkers
/mxm-watch --full                  # reserved for v1.0.0 (agent triage)
/mxm-watch --critical              # reserved for v1.0.0+ (blocks commits)
```

---

## What It Checks (10 drift classes)

| # | Class | Triage | Catches |
|---|---|---|---|
| 1 | inventory-drift | COO | Declared agent/skill/command count ≠ filesystem |
| 2 | version-drift | COO | Version string mismatches across docs |
| 3 | contract-drift | CEO 🔒 | ACCEPTED ADR contradicted by code |
| 4 | cross-doc-drift | COO | CHANGELOG/README/HELP disagreement |
| 5 | orphan-refs | CTO | Commands/hooks pointing to missing files |
| 6 | dependency-drift | CTO | Missing node_modules, outdated subtrees |
| 7 | git-hygiene | CTO | Uncommitted > 10 files, behind origin |
| 8 | junction-drift | CTO | Broken symlinks / Windows junctions |
| 9 | stale-handoff | COO | handoff.md > 7 days old |
| 10 | compliance-drift | CSO 🔒 | Secret patterns, PII, license mismatch |

🔒 = locked triage (contract-drift always → CEO; compliance-drift always → CSO).

---

## Behavior

### LIGHT phase (v1.0.0 — ships now)

- Runs in < 3 seconds
- Warn-only — never blocks session or commit
- Output: inline summary to stderr + JSONL to `.mxm-skills/watch-report.jsonl`
- Evidence framed as "fix now vs cost later" (Present-Bias Mitigation)
- Fail modes: critical=fail-closed, standard=fail-open (hybrid)

### FULL phase (v1.0.0 — scheduled)

- Agent triage — routes detected drift to appropriate office
- Opens review-queue / bug-tracker / ADR items automatically
- Portfolio-wide cross-project rollup
- Scheduled daily via `mxm-tasks`

### CRITICAL phase (v1.0.0+)

- Runs in pre-commit hook
- Blocks commits on critical-contract drift
- Escape hatch: `[contract-drift-ack: <reason>]` in commit message

---

## Output Example

```
Maxim WATCH (light) ▸ phase=light project=maxim
  ⚠ inventory-drift: documents/ledgers/AGENT_SKILL_INVENTORY.md:agents (severity 3, triage coo)
  ⚠ version-drift: README.md:no-match-for-6.4.1 (severity 3, triage coo)
  ⚠ stale-handoff: handoff-9-days-old (severity 2, triage coo)
Maxim WATCH (light) ▸ drift=3 errors=0 report=.mxm-skills/watch-report.jsonl
```

---

## Configuration

Per-project: `config/watch-profile.yml` (schema: `.claude/skills/proactive-watch/schemas/watch-profile.schema.json`).

Defaults inherited from: `config/watch-profile.TEMPLATE.yml`.

Triage matrix: editable except `contract-drift` (🔒 CEO) and `compliance-drift` (🔒 CSO).

---

## Integration Points

- **SessionStart hook** — runs `watch --light` silently; summary appended to session banner
- **MCP:** `mxm-context.watch_run`, `watch_report`, `watch_configure` (v1.0.0+ after MCP consolidation)
- **Pre-commit hook (v1.0.0+)** — CRITICAL phase checks
- **Portfolio sync** — reads `.mxm-skills/watch-report.jsonl` across projects (FULL phase, v1.0.0+)

---

## Dispatch

| Signal | Action |
|---|---|
| First command of a session | SessionStart already ran LIGHT — this shows the cached report |
| Mid-session manual invocation | Re-runs checkers, updates report |
| `super_user.enabled = true` | Checkers still run, but advisory framing suppressed; outputs tagged 🔵 SUPER USER |
| `status.gated = true` | Watch still runs (drift detection is not gated work) |

---

## Related

- Framework: `composable-skills/frameworks/proactive-watch.md`
- Skill: `.claude/skills/proactive-watch/SKILL.md`
- Drivers: `.claude/skills/proactive-watch/watch.{sh,ps1}`
- Config: `config/watch-profile.yml`
- ADR: `documents/ADRs/ADR-002-executable-contracts.md`
- Contract rules: `CLAUDE.d/protocols.md` § Documents as Executable Contracts
