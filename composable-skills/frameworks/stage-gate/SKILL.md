---
skill_id: stage-gate
name: Stage-Gate
version: 2.0.0
category: project-management
type: framework
frameworks: []
triggers:
  - stage-gate
  - phase gate
  - new product development process
  - go kill decision
  - innovation funnel
collaborates_with:
  - rd-coordinator
  - product-strategist
  - project-shipper
ethics_required: false
priority: medium
tags: [project-management, framework, new-product-development, governance, portfolio]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Stage-Gate

## Purpose
Use Stage-Gate to move new products from idea to launch through a series of work stages separated by decision gates, so that investment rises only as uncertainty falls. Robert Cooper developed the model from studies of successful and failed product launches. Its main value is disciplined **go or kill** decisions: weak projects are stopped early, freeing resources for strong ones.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `stage-gate` |
| Category | Project Management — New Product Development |
| Version | 2.0.0 |
| Originator | Robert G. Cooper |
| Key publications | *Winning at New Products* (1986, later editions) · "Stage-Gate systems", *Business Horizons* (1990) |
| Later development | Agile-Stage-Gate hybrids, combining sprints within stages |

## Stages and Gates
**Typical stages**
1. **Discovery**: generating ideas.
2. **Scoping**: a quick, inexpensive assessment.
3. **Build the business case**: detailed investigation and definition.
4. **Development**: design and build.
5. **Testing and validation**: verify the product and the plan.
6. **Launch**: commercialise.

**Gates** sit between stages. At each one, decision-makers review agreed deliverables against criteria and decide **go, kill, hold or recycle**.

## Core Principles
- **Killing projects is a success of the process,** not a failure.
- **Gates need real criteria and real decision-makers** who control resources.
- **Front-end work pays off.** Sharp scoping and business cases reduce late failures.
- **Investment rises as uncertainty falls.**
- **Adapt the process to the project's risk.** Small projects need fewer, lighter gates.

## Applications & Use Cases
| Use Case | Application | Note |
|---|---|---|
| Manufacturing and hardware | Gate expensive tooling decisions | Its original setting |
| Portfolio management | Compare projects at gates to allocate resources | Kill weak projects |
| Regulated products | Build compliance checkpoints into gates | Medical, finance, food |
| Corporate innovation | Fund ideas in increments | Tie money to evidence |
| Hybrid agile delivery | Sprints within stages, gates for funding | Agile-Stage-Gate |
| Launch readiness | A final gate on market and operational readiness | Avoid premature launch |

## Usage Guidelines
- **Define deliverables and criteria for every gate** in advance.
- **Name gatekeepers** with authority over resources.
- **Make kill decisions explicitly** and record the reasons.
- **Scale the number and weight of gates** to the project's risk and size.
- **Combine with agile delivery** inside stages where requirements are uncertain.

## Prompt Template
```
You are running a Stage-Gate review (Cooper).

PROJECT AND CURRENT STAGE: [[...]]
GATE DELIVERABLES: present / missing
CRITERIA
- Strategic fit:
- Market attractiveness:
- Technical feasibility:
- Financial return and risk:
DECISION: go | kill | hold | recycle, with reasons
NEXT STAGE PLAN and resources, if go:
```

## Ethical Guidelines
- **Gate on safety and compliance**, not only on commercial criteria.
- **Record kill decisions honestly**, without blame, so lessons are kept.

## Testing Strategy
- Track outcomes of projects passed and killed at each gate to calibrate criteria.

## Success Metrics
- Share of launched products meeting their business case.
- Time and money spent on projects later killed.
- Cycle time from idea to launch.

## Collaboration Protocol
- Inbound from: `rd-coordinator` · `product-strategist` · `project-shipper`
- Outbound to: CEO office for portfolio and funding decisions
- Cross-framework: Lean Startup for evidence within stages; Agile/Scrum for delivery inside stages.

## Related Skills
- `composable-skills/frameworks/lean-startup/SKILL.md` — evidence before investment
- `composable-skills/frameworks/agilescrum/SKILL.md` — delivery within stages
- `composable-skills/frameworks/raci-matrix/SKILL.md` — gatekeeper accountability

## Reference Materials
- Cooper, R.G. (1990). "Stage-Gate systems: a new tool for managing new products." *Business Horizons*, 33(3), 44–54.
- Cooper, R.G. *Winning at New Products.* Basic Books (first edition 1986; later editions).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
