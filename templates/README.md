# templates/

> **Copy-and-fill-in templates** for project scaffolding, session artifacts, sprints, and operator config.
> Unlike `documents/reference/FRAMEWORKS_MASTER.md` (which is reference), these files are meant to be **duplicated** into a target project and customized.

---

## Contents

### Configuration templates

| File | Purpose |
|---|---|
| `mxm-setup.yml` | Maxim-wide setup config used by `bootstrap/` scripts |
| `project.yml` | Per-project config scaffold (legacy; see `config/project-manifest.TEMPLATE.json` for v1.0.0+ successor) |

### Directory templates (copy entire subfolder)

| Folder | Copy to | Purpose |
|---|---|---|
| `ceo-automation/` | `.ceo/` in target project | CEO automation scaffold (daily sync, overnight automation) |
| `operator-profile/` | `.mxm-operator-profile/` | Operator preferences, rejected patterns, personalization model |
| `project-scaffold/` | target project root | Base folder structure for a new Maxim project |
| `session-memory/` | `.claude-sessions-memory/` | Seed files for session memory (MEMORY.md index, etc.) |
| `prompts/` | reference-only (no copy) | Prompt library used by Maxim skills |

### Sprint & execution templates (v1.0.0+)

| File | Copy to | Purpose |
|---|---|---|
| `sprint-plan.md` | `.claude-sessions-memory/sprints/SPRINT-NNN-plan.md` | Per-sprint plan with Coverage Matrix appendix, ADR/bug cross-links, acceptance criteria |
| `sprint-report.md` | `.claude-sessions-memory/sprints/SPRINT-NNN-report.md` | Per-sprint close-out with plan-vs-actual diff, playbook additions, hand-off |

These templates enforce the 15 coordination learnings codified in ADR-002:
- Cross-link discipline (every sprint references related ADRs + bugs + CLI block)
- Coverage Matrix (every audit finding maps to a task ID — nothing slips, nothing duplicates)
- File-set contract (plan declares files; report diffs actual vs planned)
- Acceptance-criteria checklist (sprint can only CLOSE when all boxes checked)

---

## Usage

```bash
# Start a new sprint
mkdir -p .claude-sessions-memory/sprints
cp templates/sprint-plan.md .claude-sessions-memory/sprints/SPRINT-042-plan.md
# Fill in fields, set status to PLANNED

# At kickoff
# Flip status to ACCEPTED; add CLI block to documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md

# At close
cp templates/sprint-report.md .claude-sessions-memory/sprints/SPRINT-042-report.md
# Fill in fields, verify acceptance criteria, commit
```

---

## Rules

1. **Never edit these templates for project-specific values.** Edits here affect all future projects. Project-specific fills go in the **copy**.
2. **New templates require an ADR** if they codify a new pattern (sprint-plan/sprint-report are codified by ADR-002).
3. **Deprecated templates** get a `DEPRECATED.md` stub in their folder with rationale and replacement pointer — never deleted immediately.
4. **`prompts/` is reference-only.** Skills pull prompts from there at runtime; not meant to be copied.

---

## Cross-Links

- `CLAUDE.d/protocols.md` § Documents as Executable Contracts — the meta-principle these templates enforce
- `documents/ADRs/ADR-002-executable-contracts.md` — the formal decision record
- `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` — execution contract ledger (sprint CLI blocks)
- `BUG_TRACKER.md` — bug IDs referenced by sprints
- `documents/ADRs/INDEX.md` — ADR IDs referenced by sprints
