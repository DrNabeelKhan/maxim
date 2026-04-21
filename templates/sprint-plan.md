# SPRINT-NNN: <Short Title>

> Copy this file to `.claude-sessions-memory/sprints/SPRINT-NNN-plan.md` and fill in.
> Governed by ADR-002 (Executable Contracts).

```yaml
sprint_id: SPRINT-NNN
title: <Short Title>
planned: YYYY-MM-DD
kickoff: YYYY-MM-DD
target_close: YYYY-MM-DD
status: PLANNED                    # PLANNED | ACCEPTED | IN_PROGRESS | CLOSED | ABANDONED
owner: <name or role>
related_adrs: []                   # ADR-NNN references
related_bugs: []                   # BUG-NNN references
closes_adrs: []                    # ADRs this sprint makes ACCEPTED or SUPERSEDED
opens_adrs: []                     # ADRs this sprint proposes
cli_block: documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md#SPRINT-NNN
report_doc: .claude-sessions-memory/sprints/SPRINT-NNN-report.md
```

---

## Context

> What problem / opportunity motivates this sprint?
> What's already been learned / tried?

[Write here.]

---

## Objectives

> 2–5 outcomes this sprint commits to deliver. Specific and measurable.

1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

---

## Non-Objectives

> What's explicitly out of scope. Prevents scope creep.

- [Non-objective]
- [Non-objective]

---

## Scope — File Set

> List of files this sprint plans to CREATE / MODIFY / DELETE.
> This is the **file-set contract** — Git Hygiene Gate postamble diffs actual changes against this list.

| Action | Path | Reason |
|---|---|---|
| CREATE | `path/to/new/file.md` | <reason> |
| MODIFY | `path/to/existing/file.md` | <reason> |
| DELETE | `path/to/old/file.md` | <reason> |

---

## Tasks

> Break objectives into actionable tasks. Each gets an ID used in commits and the sprint report.

| Task ID | Description | Blocked By | Status |
|---|---|---|---|
| T1 | <Task description> | — | pending |
| T2 | <Task description> | T1 | pending |
| T3 | <Task description> | — | pending |

---

## Coverage Matrix (audit → task mapping)

> Every finding from every upstream audit / review / bug-tracker scan gets a row here.
> Nothing slips; nothing duplicates. **This is the sprint's contract with prior planning.**

| Finding / Audit Item | Source | Target Task | Notes |
|---|---|---|---|
| <Finding> | <BUG-XXX, audit-YYY, ADR-ZZZ> | T1 | <notes> |
| <Finding> | <...> | T2 | |
| <Finding> | <...> | T3 | |

**Coverage completeness:** <X> findings mapped across <N> tasks. Any unmapped findings are listed below with explicit defer / decline rationale.

### Deferred findings

| Finding | Source | Deferred to | Rationale |
|---|---|---|---|
| <Finding> | <...> | <future sprint> | <why deferred> |

### Declined findings

| Finding | Source | Declined | Rationale |
|---|---|---|---|
| <Finding> | <...> | <date> | <why declined> |

---

## Cross-Links

- **ADRs:** [ADR-NNN](../documents/ADRs/ADR-NNN-*.md) — relevant decisions this sprint implements or challenges
- **Bugs:** [BUG-NNN](../BUG_TRACKER.md#active-bugs) — bugs this sprint will close
- **Prior sprint:** `.claude-sessions-memory/sprints/SPRINT-MMM-report.md` — previous sprint we build on
- **CLI block:** `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md#SPRINT-NNN` — execution contract
- **Changelog entry:** `CHANGELOG.md` — section to update at close

---

## Risks / Unknowns

> Things that could derail the sprint. What we'd do if they hit.

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| <Risk> | L/M/H | L/M/H | <Mitigation> |

---

## Acceptance Criteria (for sprint close)

> The sprint can only be CLOSED when ALL of these are true.

- [ ] All tasks T1…TN complete or explicitly deferred with rationale
- [ ] File set actual = file set planned (drift flagged and justified if not)
- [ ] All related_bugs either closed or explicitly deferred
- [ ] All closes_adrs flipped to ACCEPTED or SUPERSEDED
- [ ] SPRINT-NNN report written (`.claude-sessions-memory/sprints/SPRINT-NNN-report.md`)
- [ ] Git Hygiene Gate postamble passes (`git status` clean, pushed to origin)
- [ ] CHANGELOG updated if the sprint ships user-facing change
- [ ] documents/ledgers/AGENT_SKILL_INVENTORY.md reconciled if capabilities changed (contract block)
- [ ] Any new patterns added to BUG_TRACKER Recurring-Pattern Registry or DEBUGGING_PLAYBOOK

---

## Notes

<Freetext. Anything that doesn't fit above.>
