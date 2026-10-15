---
skill_id: zachman-framework
name: Zachman Framework
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - zachman framework
  - enterprise ontology
  - classify architecture artifacts
  - architecture coverage check
collaborates_with:
  - enterprise-architect
  - data-architect
  - solution-architect
ethics_required: false
priority: medium
tags: [enterprise-architecture, framework, zachman, ontology, classification]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Zachman Framework

## Purpose
Use the Zachman Framework to classify the descriptive representations of an enterprise and to check which ones exist and which are missing. It is a two-dimensional schema: one axis asks the six basic questions (what, how, where, who, when, why), the other lists the perspectives of the audiences who need answers. Zachman describes it as an ontology, not a method: it tells you **what** descriptions an enterprise needs, not **how** to produce them. That is why it is often used alongside a method such as TOGAF.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `zachman-framework` |
| Category | Enterprise Architecture — Classification Schema |
| Version | 2.0.0 |
| Origin | Zachman, *IBM Systems Journal* (1987); extended by Sowa & Zachman (1992) |
| Current version | Zachman Framework 3.0 (2011), published by Zachman International |

## The Two Axes
**Columns: the interrogatives**
- **What**: inventory (things and data).
- **How**: process (transformations).
- **Where**: distribution (locations and networks).
- **Who**: responsibility (people and roles).
- **When**: timing (events and cycles).
- **Why**: motivation (goals and means).

**Rows: the audience perspectives (version 3.0 names)**
- **Executive**: scope and context.
- **Business management**: business concepts.
- **Architect**: system logic.
- **Engineer**: technology physics.
- **Technician**: tool components.
- **Enterprise**: the operating instances.

Earlier versions name the rows planner, owner, designer, builder, subcontractor and the functioning enterprise.

## Core Principles
- **Each cell is unique.** A cell answers one question from one perspective.
- **Cells are primitive.** Keep one interrogative per model and compose them later, rather than mixing them.
- **Columns have no order.** No question is more important than another.
- **Rows are different, not just more detailed.** Each perspective is a distinct model for a distinct audience.
- **A classification, not a process.** Pair it with a method to produce the artifacts.

## Applications & Use Cases
| Use Case | Application | Axis |
|---|---|---|
| Architecture repository structure | Organise artifacts by cell | Both |
| Gap analysis of documentation | Find empty cells that matter | Both |
| Stakeholder communication | Choose the row for the audience | Rows |
| Requirements completeness | Check all six questions are answered | Columns |
| Data architecture | Separate conceptual, logical and physical data models | What column |
| Method selection | Map method deliverables to cells | Both |

## Usage Guidelines
- **Map existing artifacts to cells** to see coverage.
- **Prioritise the empty cells** that matter for the current decision; not every cell needs to be filled.
- **Keep models single-variable**, one interrogative each.
- **Address each audience at its own row**, rather than giving executives engineering models.
- **Use a method such as TOGAF** to produce the missing artifacts.

## Prompt Template
```
You are applying the Zachman Framework 3.0 (Zachman 1987; 2011).

SCOPE: [[...]]
FOR EACH ROW (executive · business management · architect · engineer · technician)
  FOR EACH COLUMN (what · how · where · who · when · why)
    existing artifact? / gap / needed for current decision?
PRIORITY GAPS and the method to fill them:
```

## Ethical Guidelines
- **Do not use completeness as a sales tool.** Filling every cell is rarely necessary; recommend only what the decision needs.

## Testing Strategy
- Check that each artifact maps to exactly one cell; split those that span several.

## Success Metrics
- Decision-relevant cells covered.
- Time to find an architecture artifact in the repository.

## Collaboration Protocol
- Inbound from: `enterprise-architect` · `data-architect`
- Outbound to: `solution-architect` for producing missing artifacts
- Cross-framework: TOGAF as the method; ArchiMate as the modelling language; DMBOK for data models in the What column.

## Related Skills
- `composable-skills/frameworks/togaf/SKILL.md` — a method to produce the artifacts
- `composable-skills/frameworks/archimate/SKILL.md` — modelling notation
- `composable-skills/frameworks/dmbok/SKILL.md` — data architecture

## Reference Materials
- Zachman, J.A. (1987). "A framework for information systems architecture." *IBM Systems Journal*, 26(3), 276–292.
- Sowa, J.F., & Zachman, J.A. (1992). "Extending and formalizing the framework for information systems architecture." *IBM Systems Journal*, 31(3), 590–616.
- Zachman International. *The Zachman Framework for Enterprise Architecture, Version 3.0* (2011).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
