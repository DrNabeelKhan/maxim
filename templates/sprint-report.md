# SPRINT-NNN Report — <Short Title>

> Copy this file to `.claude-sessions-memory/sprints/SPRINT-NNN-report.md` at sprint close.
> The sprint-report is the **close-out contract** — it proves the plan was executed.

```yaml
sprint_id: SPRINT-NNN
title: <Short Title>
planned: YYYY-MM-DD
kickoff: YYYY-MM-DD
closed: YYYY-MM-DD
status: CLOSED                     # CLOSED | ABANDONED
owner: <name or role>

plan_doc: .claude-sessions-memory/sprints/SPRINT-NNN-plan.md
cli_block: documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md#SPRINT-NNN

closes_adrs: []                    # ADRs now ACCEPTED or SUPERSEDED
opens_adrs: []                     # ADRs newly PROPOSED this sprint
closes_bugs: []                    # BUG-NNN rows now CLOSED
opens_bugs: []                     # BUG-NNN rows newly OPENED during sprint
playbook_sections_added: []        # §N numbers added to documents/ledgers/DEBUGGING_PLAYBOOK.md this sprint
pattern_registry_additions: []     # PATTERN-NN numbers added to BUG_TRACKER.md
```

---

## Summary

> 3–5 sentences. What the sprint delivered. What changed for users / developers.

[Write here.]

---

## Objectives — Outcome

> Against the plan's declared objectives.

| # | Objective | Status | Evidence |
|---|---|---|---|
| 1 | <from plan> | ✅ delivered / ⚠️ partial / ❌ abandoned | <commit / PR / file path> |
| 2 | <from plan> | ... | ... |
| 3 | <from plan> | ... | ... |

---

## Task Completion

| Task ID | Description | Status | Closed By |
|---|---|---|---|
| T1 | <from plan> | ✅ done | commit abc123 |
| T2 | <from plan> | ❌ deferred | moved to SPRINT-NN+1 |
| T3 | <from plan> | ... | ... |

---

## File Set — Plan vs Actual

> Diff the file set declared in the plan vs what the sprint actually touched.
> Drift here is contract drift — explain every row that diverged from the plan.

| Action | Path | Planned? | Actual | Notes |
|---|---|---|---|---|
| CREATE | `path/to/file.md` | ✅ | ✅ | as planned |
| MODIFY | `path/to/file.md` | ✅ | ✅ | as planned |
| CREATE | `path/not-in-plan.md` | ❌ | ✅ | <justification — unplanned addition> |
| DELETE | `path/to/old.md` | ✅ | ❌ | <deferred to next sprint — reason> |

**Drift summary:** <N unplanned additions, M planned deletions deferred>
**Drift justifications:** see notes column above

---

## Coverage Matrix — Closed vs Open

> The plan's Coverage Matrix had X findings. Here's what shipped.

| Finding | Source | Status | Evidence |
|---|---|---|---|
| <from plan> | <BUG-XXX> | ✅ resolved | commit abc123 |
| <from plan> | <ADR-YYY> | ⚠️ partial | <remaining work> |
| <from plan> | <audit-ZZZ> | ❌ deferred | moved to SPRINT-NN+1 |

**Coverage closed:** <N> of <M> findings
**Remaining findings:** listed above with defer/decline rationale, carried forward to next sprint

---

## ADRs

### Accepted / Superseded this sprint

| ADR | Title | Status Change |
|---|---|---|
| ADR-NNN | <title> | PROPOSED → ACCEPTED |
| ADR-NNN | <title> | ACCEPTED → SUPERSEDED by ADR-MMM |

### Newly Proposed this sprint

| ADR | Title | Status |
|---|---|---|
| ADR-NNN | <title> | PROPOSED (awaiting next sprint) |

---

## Bugs

### Closed this sprint

| BUG | Severity | Title | Fixed By |
|---|---|---|---|
| BUG-NNN | S1 | <title> | commit abc123 |

### Opened this sprint

| BUG | Severity | Title | Notes |
|---|---|---|---|
| BUG-NNN | S2 | <title> | <reason discovered mid-sprint> |

---

## Recurring Patterns + Playbook Entries

### New playbook sections added

| § | Title | Related Bugs |
|---|---|---|
| §N | <title> | BUG-XXX |

### New recurring patterns codified

| Pattern | Observed In | Remediation |
|---|---|---|
| PATTERN-NN | BUG-XXX, BUG-YYY | <lint rule / pre-commit check> |

---

## CHANGELOG

What gets added to `CHANGELOG.md`:

```markdown
## [version-or-date]

### Added
- ...

### Changed
- ...

### Fixed
- BUG-NNN: ...

### Deprecated
- ...
```

---

## Lessons Learned

> Process / tooling / workflow insights from this sprint that should persist.
> Feed these into `.claude-sessions-memory/feedback_lessons_learned.md` if project-specific,
> or the DEBUGGING_PLAYBOOK if broadly applicable.

1. [Lesson]
2. [Lesson]

---

## Acceptance Criteria — Verification

> From the plan. Confirm every checkbox.

- [x] All tasks T1…TN complete or explicitly deferred with rationale
- [x] File set actual = file set planned (drift flagged and justified)
- [x] All related_bugs either closed or explicitly deferred
- [x] All closes_adrs flipped to ACCEPTED or SUPERSEDED
- [x] SPRINT-NNN report written (this file)
- [x] Git Hygiene Gate postamble passes
- [x] CHANGELOG updated if sprint shipped user-facing change
- [x] documents/ledgers/AGENT_SKILL_INVENTORY.md reconciled if capabilities changed
- [x] New patterns added to BUG_TRACKER Recurring-Pattern Registry or DEBUGGING_PLAYBOOK

---

## Next Sprint Hand-Off

> What the next sprint (or next session) needs to know.

- **Carry-forward tasks:** [list]
- **Carry-forward bugs:** [list]
- **New ADRs needing acceptance:** [list]
- **Operator profile updates:** [if user preferences changed]
- **Skill gaps logged:** [count, pointer to `.mxm-skills/agents-skill-gaps.log`]
