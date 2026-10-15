---
skill_id: agilescrum
name: Agile/Scrum
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - agile
  - scrum
  - sprint planning
  - product backlog
  - retrospective
  - definition of done
collaborates_with:
  - sprint-prioritizer
  - project-shipper
  - experiment-tracker
  - frontend-developer
  - backend-architect
ethics_required: false
priority: high
tags: [product-research, framework, agile, scrum, delivery]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Agile/Scrum

## Purpose
Use Agile values and the Scrum framework to deliver complex work in short iterations, inspecting results and adapting frequently rather than planning everything up front. The Agile Manifesto (2001) sets out the values; Scrum, defined in the Scrum Guide by Ken Schwaber and Jeff Sutherland, is the most widely used framework for applying them. Scrum is deliberately minimal: a small set of accountabilities, events and artifacts that make progress and problems visible.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `agilescrum` |
| Category | Delivery — Iterative and Incremental Development |
| Version | 2.0.0 |
| Values | *Manifesto for Agile Software Development* (2001): four values, twelve principles |
| Scrum definition | Schwaber & Sutherland, *The Scrum Guide* (2020 edition) |

## Scrum, per the 2020 Scrum Guide
**Three accountabilities**: Product Owner · Scrum Master · Developers.

**Five events**: the Sprint (one month or less), Sprint Planning, Daily Scrum, Sprint Review, Sprint Retrospective.

**Three artifacts, each with a commitment**
- **Product Backlog**, committed to the **Product Goal**.
- **Sprint Backlog**, committed to the **Sprint Goal**.
- **Increment**, committed to the **Definition of Done**.

**Five values**: commitment, focus, openness, respect, courage.

**The Agile Manifesto values** individuals and interactions, working software, customer collaboration and responding to change, over processes and tools, comprehensive documentation, contract negotiation and following a plan.

## Core Principles
- **Empiricism**: transparency, inspection and adaptation.
- **A usable increment every sprint.** "Almost done" work is not an increment.
- **One Product Owner orders the backlog.** Clear ownership of value.
- **The Definition of Done is a quality bar,** not a checklist to negotiate away.
- **Retrospectives drive improvement;** skipping them stops the team learning.

## Applications & Use Cases
| Use Case | Application | Scrum element |
|---|---|---|
| New product development | Short sprints with frequent feedback | Sprint Review |
| Unclear requirements | Refine the backlog as learning arrives | Product Backlog |
| Quality problems | Strengthen the Definition of Done | Increment |
| Team dysfunction | Honest retrospectives with actions | Retrospective |
| Stakeholder alignment | A visible Product Goal | Product Goal |
| Coordination | A short daily replan toward the Sprint Goal | Daily Scrum |

## Usage Guidelines
- **Set a Product Goal** and order the backlog toward it.
- **Plan each sprint around a Sprint Goal**, not just a list of items.
- **Agree and enforce a Definition of Done.**
- **Show working increments at the Sprint Review** to real stakeholders.
- **Leave every Retrospective with at least one concrete improvement.**

## Prompt Template
```
You are applying Scrum (Scrum Guide 2020).

PRODUCT GOAL:
SPRINT GOAL:
SPRINT BACKLOG (items and plan):
DEFINITION OF DONE:
RISKS TO THE SPRINT GOAL:
RETROSPECTIVE: what to keep, what to change, one concrete action
```

## Ethical Guidelines
- **Sustainable pace.** The Agile principles call for a pace teams can maintain indefinitely.
- **Do not use velocity to compare or rank teams.**

## Testing Strategy
- Build testing into the Definition of Done rather than a later phase.
- Review whether increments meet the Definition of Done at every Sprint Review.

## Success Metrics
- Sprint Goals achieved.
- Increments that meet the Definition of Done.
- Lead time from idea to delivered value.
- Improvement actions completed from retrospectives.

## Collaboration Protocol
- Inbound from: `sprint-prioritizer` · `project-shipper` · `experiment-tracker`
- Outbound to: `frontend-developer` · `backend-architect` for delivery
- Cross-framework: Kanban for flow-based teams; OKRs for goals above the backlog; CI/CD for frequent, safe releases.

## Related Skills
- `composable-skills/frameworks/kanban/SKILL.md` — flow-based alternative
- `composable-skills/frameworks/okrs/SKILL.md` — goals above the backlog
- `composable-skills/frameworks/cicd/SKILL.md` — releasing increments safely

## Reference Materials
- Beck, K., et al. (2001). *Manifesto for Agile Software Development.* agilemanifesto.org.
- Schwaber, K., & Sutherland, J. (2020). *The Scrum Guide.* scrumguides.org.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
