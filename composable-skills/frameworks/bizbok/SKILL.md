---
skill_id: bizbok
name: BIZBOK
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - bizbok
  - business architecture
  - capability map
  - value stream mapping
  - business capability model
collaborates_with:
  - business-architect
  - enterprise-architect
  - product-strategist
  - market-analyst
ethics_required: false
priority: medium
tags: [enterprise-architecture, framework, business-architecture, capabilities, value-streams]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# BIZBOK

## Purpose
Use the BIZBOK Guide (A Guide to the Business Architecture Body of Knowledge) to describe what a business does and how it delivers value, in a form that stays stable while organisations, processes and systems change. Its central tools are the **capability map**, which lists what the business does, and **value streams**, which show how it delivers value to stakeholders end to end. Together they let strategy be translated into specific, prioritised changes.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `bizbok` |
| Category | Enterprise Architecture — Business Architecture |
| Version | 2.0.0 |
| Owner | Business Architecture Guild |
| Publication | *A Guide to the Business Architecture Body of Knowledge* (BIZBOK Guide), revised periodically; check the current version |

## Core Domains
- **Capabilities**: what the business does, described independently of who does it or how.
- **Value streams**: the end-to-end stages by which value is delivered to a triggering stakeholder.
- **Information**: the business concepts the business uses, such as customer, product and agreement.
- **Organisation**: business units and their relationships, including partners.

Extended domains include strategies, initiatives, products, stakeholders, policies and metrics.

**Cross-mapping** links these domains, for example which capabilities enable each value-stream stage, which business units own which capabilities and which initiatives change them.

## Core Principles
- **Capabilities describe what, not how.** They stay stable while processes and systems change.
- **Each capability appears once** in the map, even if many units perform it.
- **Value streams are stakeholder-centred,** starting from a trigger and ending in value delivered.
- **Business architecture is about the business,** not about IT, though it guides IT decisions.
- **Use cross-mapping** to turn strategy into targeted change.

## Applications & Use Cases
| Use Case | Application | Domain |
|---|---|---|
| Strategy execution | Map strategy to the capabilities that must improve | Capabilities |
| Investment prioritisation | Heat-map capabilities by importance and performance | Capabilities |
| Customer experience redesign | Trace value-stream stages and their enabling capabilities | Value streams |
| Mergers and reorganisations | Compare capability maps across organisations | Organisation |
| Application rationalisation | Map applications to the capabilities they support | Capabilities |
| Shared vocabulary | Define business concepts consistently | Information |

## Usage Guidelines
- **Build a capability map with business stakeholders,** naming capabilities as noun-verb pairs such as "Customer Management."
- **Identify the value streams** for key stakeholders, stage by stage.
- **Cross-map capabilities to value-stream stages.**
- **Assess capabilities** for strategic importance and current performance, then prioritise the gaps.
- **Link initiatives to the capabilities they change**, to expose overlap and gaps.

## Prompt Template
```
You are doing business architecture (BIZBOK Guide).

STRATEGY or problem: [[...]]
CAPABILITY MAP (levels 1-2, noun-verb names):
VALUE STREAMS: triggering stakeholder · stages · value delivered
CROSS-MAP: which capabilities enable each stage?
ASSESSMENT: importance × performance → priority gaps
INITIATIVES: which capabilities each changes; overlaps and gaps
```

## Ethical Guidelines
- **Capability assessments affect people's work.** Present them as an assessment of the business, not of individuals.

## Testing Strategy
- Check that every capability is defined once and named without reference to organisation or technology.
- Validate value streams with people who deliver them.

## Success Metrics
- Investments traceable to priority capabilities.
- Duplicate initiatives identified.
- Stakeholder use of the capability map in planning.

## Collaboration Protocol
- Inbound from: `business-architect` · `product-strategist` · `market-analyst`
- Outbound to: `enterprise-architect` for application and technology alignment
- Cross-framework: TOGAF Phase B; ArchiMate strategy elements for modelling; OKRs for linking capabilities to objectives.

## Related Skills
- `composable-skills/frameworks/togaf/SKILL.md` — business architecture in the ADM
- `composable-skills/frameworks/archimate/SKILL.md` — modelling capabilities and value streams
- `composable-skills/frameworks/okrs/SKILL.md` — objectives the capabilities serve

## Reference Materials
- Business Architecture Guild. *A Guide to the Business Architecture Body of Knowledge (BIZBOK Guide).*
- The Open Group. (2022). *The TOGAF Standard, 10th Edition* — business architecture guidance.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
