---
skill_id: raci-matrix
name: RACI Matrix
version: 2.0.0
category: project-management
type: framework
frameworks: []
triggers:
  - raci matrix
  - who is responsible
  - responsibility assignment
  - roles and responsibilities
  - accountable owner
collaborates_with:
  - project-shipper
  - studio-producer
  - governance-specialist
ethics_required: false
priority: medium
tags: [project-management, framework, roles, accountability, governance]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# RACI Matrix

## Purpose
Use a RACI matrix to make clear who does what on a piece of work, by assigning each person or role one of four involvement types for each task or decision: **Responsible, Accountable, Consulted, Informed**. Most coordination failures come from unclear ownership: work nobody owns, work with too many owners, or decisions that skip the people who needed to be heard. A RACI makes those gaps visible on one page.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `raci-matrix` |
| Category | Project Management — Responsibility Assignment |
| Version | 2.0.0 |
| Nature | A long-established responsibility-assignment convention with no single originating publication |
| Variants | RASCI (adds Support) · DACI (Driver, Approver, Contributor, Informed) |

## The Four Roles
- **Responsible**: does the work. There can be several.
- **Accountable**: owns the outcome and signs off. **Exactly one per task.**
- **Consulted**: gives input before the decision or work; two-way communication.
- **Informed**: kept up to date after the fact; one-way communication.

## Core Principles
- **One Accountable per task.** Two owners means no owner.
- **Every task needs at least one Responsible.**
- **Keep Consulted lists short.** Too many people consulted slows everything.
- **Accountable and Responsible can be the same person** on small tasks.
- **Review the matrix when people or scope change.**

## Applications & Use Cases
| Use Case | Application | Common finding |
|---|---|---|
| Project kick-off | Assign roles for each deliverable | Tasks with no owner |
| Cross-team initiatives | Clarify handoffs between teams | Several people think they own it |
| Decision-making | Who decides, who is consulted | Decisions made without input |
| Process documentation | Roles in recurring processes | Bottleneck roles |
| Governance and compliance | Ownership of controls | Controls with no accountable owner |
| Reorganisations | Re-map ownership after structure changes | Orphaned responsibilities |

## Usage Guidelines
- **List tasks or decisions in rows and roles in columns.**
- **Assign exactly one A per row**, then the R, C and I.
- **Check each row and column**: no row without an A or R; no person overloaded with A's.
- **Agree the matrix with everyone in it**, not just the project lead.
- **Revisit it at milestones** and when people change.

## Prompt Template
```
You are building a RACI matrix.

TASKS / DECISIONS (rows): [[...]]
ROLES (columns): [[...]]
FOR EACH ROW: exactly one A · at least one R · minimal C · I as needed
CHECKS
- Rows with no A or no R:
- Rows with more than one A:
- People with too many A's (overload):
- Long C lists (slow decisions):
```

## Ethical Guidelines
- **Accountability needs matching authority.** Do not make someone accountable for outcomes they cannot control.

## Testing Strategy
- After a project, compare the planned RACI with who actually did and decided what.

## Success Metrics
- Tasks with exactly one accountable owner.
- Delays caused by unclear ownership.
- Rework from decisions made without required consultation.

## Collaboration Protocol
- Inbound from: `project-shipper` · `studio-producer` · `governance-specialist`
- Outbound to: COO office for operating-model changes
- Cross-framework: Agile/Scrum defines its own accountabilities; Stage-Gate needs named gatekeepers; COBIT uses RACI-style charts for governance.

## Related Skills
- `composable-skills/frameworks/agilescrum/SKILL.md` — Scrum's accountabilities
- `composable-skills/frameworks/stage-gate/SKILL.md` — gatekeeper roles
- `composable-skills/frameworks/cobit/SKILL.md` — governance responsibility charts

## Reference Materials
- No single originating publication. RACI is a long-established convention in project management and IT governance; frameworks such as COBIT publish RACI-style charts for their own processes.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
