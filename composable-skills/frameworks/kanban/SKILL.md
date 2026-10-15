---
skill_id: kanban
name: Kanban
version: 2.0.0
category: project-management
type: framework
frameworks: []
triggers:
  - kanban
  - wip limits
  - visualize workflow
  - flow efficiency
  - lead time and throughput
collaborates_with:
  - sprint-prioritizer
  - project-shipper
  - experiment-tracker
  - studio-producer
ethics_required: false
priority: medium
tags: [project-management, framework, flow, wip, lean]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Kanban

## Purpose
Use the Kanban Method to improve how work flows through a team by making it visible, limiting how much is in progress at once, and managing the flow rather than the people. It grew from the kanban signalling system in the Toyota Production System and was adapted for knowledge work by David J. Anderson. It starts with what you do now and improves it in small, evolutionary steps, which makes it easy to adopt without a reorganisation.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `kanban` |
| Category | Project Management — Flow-Based Delivery |
| Version | 2.0.0 |
| Origin | Toyota Production System (Taiichi Ohno) |
| Knowledge-work method | David J. Anderson, *Kanban* (2010) |
| Underlying law | Little's Law (Little, 1961): average work in progress = throughput × average lead time |

## The General Practices
1. **Visualise the work**: a board showing every item and its stage.
2. **Limit work in progress (WIP)**: an explicit cap per stage.
3. **Manage flow**: watch how work moves and remove blockages.
4. **Make policies explicit**: for example, what "done" means for each stage.
5. **Implement feedback loops**: regular reviews of flow and service.
6. **Improve collaboratively, evolve experimentally.**

## Core Principles
- **Stop starting, start finishing.** Limiting WIP shortens lead time.
- **Start with what you do now.** Change incrementally rather than imposing a new process.
- **Manage the work, not the workers.**
- **Little's Law makes WIP a lever**: at the same throughput, less WIP means shorter lead times.
- **Blocked and waiting time is usually the largest part of lead time.**

## Applications & Use Cases
| Use Case | Application | Practice |
|---|---|---|
| Support and operations teams | Continuous flow without fixed sprints | Manage flow |
| Overloaded teams | Introduce WIP limits | Limit WIP |
| Unclear status | A shared board for all work | Visualise |
| Slow delivery | Measure lead time and find where work waits | Manage flow |
| Handoffs between teams | Explicit entry and exit policies per stage | Explicit policies |
| Continuous improvement | Regular flow reviews | Feedback loops |

## Usage Guidelines
- **Map the current workflow** as columns before changing anything.
- **Set WIP limits per stage**, start loose, then tighten.
- **Track lead time and throughput** for each item.
- **Make policies explicit**, including definitions of done and how work is prioritised.
- **Hold regular flow reviews** and change one thing at a time.

## Prompt Template
```
You are applying the Kanban Method (Anderson 2010).

CURRENT WORKFLOW (stages): [[...]]
WIP NOW per stage:                  PROPOSED WIP LIMITS:
LEAD TIME and THROUGHPUT:
WHERE WORK WAITS OR BLOCKS:
EXPLICIT POLICIES needed:
ONE IMPROVEMENT to try next, and how to measure it:
```

## Ethical Guidelines
- **Use flow metrics to improve the system, not to rank individuals.**

## Testing Strategy
- Compare lead time and throughput before and after each change.
- Use cumulative flow diagrams to see bottlenecks.

## Success Metrics
- Average and 85th-percentile lead time.
- Throughput per week.
- Flow efficiency: active time as a share of total lead time.

## Collaboration Protocol
- Inbound from: `sprint-prioritizer` · `project-shipper` · `studio-producer`
- Outbound to: COO office for cross-team flow
- Cross-framework: Agile/Scrum for iterative delivery; CI/CD speeds the final stages of flow.

## Related Skills
- `composable-skills/frameworks/agilescrum/SKILL.md` — iterative delivery
- `composable-skills/frameworks/cicd/SKILL.md` — accelerating delivery stages
- `composable-skills/frameworks/raci-matrix/SKILL.md` — ownership of stages

## Reference Materials
- Anderson, D.J. (2010). *Kanban: Successful Evolutionary Change for Your Technology Business.* Blue Hole Press.
- Ohno, T. (1988). *Toyota Production System: Beyond Large-Scale Production.* Productivity Press.
- Little, J.D.C. (1961). "A Proof for the Queuing Formula: L = λW." *Operations Research*, 9(3), 383–387.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
