---
skill_id: archimate
name: ArchiMate
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - archimate
  - architecture model
  - architecture viewpoint
  - layered architecture diagram
collaborates_with:
  - enterprise-architect
  - solution-architect
  - business-architect
ethics_required: false
priority: medium
tags: [enterprise-architecture, framework, archimate, modelling, open-group]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# ArchiMate

## Purpose
Use ArchiMate, an open modelling language from The Open Group, to describe enterprise architecture consistently across business, applications and technology, and to show how those layers relate. Where TOGAF supplies a method, ArchiMate supplies a precise notation: a defined set of elements and relationships, so that models drawn by different people mean the same thing and can be analysed, not just looked at.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `archimate` |
| Category | Enterprise Architecture — Modelling Language |
| Version | 2.0.0 |
| Owner | The Open Group |
| Current specification | ArchiMate 4 (released April 2026). The structure below follows ArchiMate 3.2 (2022), which remains widely used in tools and models. ArchiMate 4 reorganises parts of the language while aiming for user-level compatibility; check the ArchiMate 4 specification for its element set. |
| Companion method | TOGAF ADM |

## Structure of the Language
**Core layers**
- **Business**: actors, roles, processes, services, business objects.
- **Application**: components, interfaces, application services, data objects.
- **Technology**: nodes, devices, system software, networks, artifacts.

**Additional elements**: strategy (capabilities, value streams, resources, courses of action), physical (equipment, facilities, materials), motivation (stakeholders, drivers, goals, requirements, principles) and implementation and migration (work packages, deliverables, plateaus, gaps).

**Aspects**: active structure (who or what acts), behavior (what is done) and passive structure (what is acted on).

**Relationship groups**: structural (composition, aggregation, assignment, realization), dependency (serving, access, influence, association), dynamic (triggering, flow) and specialization.

**Viewpoints** select the elements relevant to a particular stakeholder concern.

## Core Principles
- **One model, many views.** Draw views from a single consistent model rather than separate diagrams.
- **Use the defined semantics.** Each relationship has a precise meaning; do not use them decoratively.
- **Connect the layers.** The value of ArchiMate is showing how technology serves applications and applications serve the business.
- **Choose viewpoints for the audience.** Show each stakeholder only what addresses their concern.
- **Model to answer a question**, not to document everything.

## Applications & Use Cases
| Use Case | Application | Elements |
|---|---|---|
| Impact analysis | Trace what depends on a system before changing it | Cross-layer relationships |
| Application landscape | Components, interfaces and data flows | Application layer |
| Capability-based planning | Map capabilities to the systems that realise them | Strategy elements |
| Migration roadmaps | Plateaus, gaps and work packages | Implementation and migration |
| Requirement traceability | Link goals and requirements to elements | Motivation elements |
| Infrastructure views | Nodes, networks and deployment | Technology layer |

## Usage Guidelines
- **Start with the question the model must answer**, then pick the viewpoint.
- **Keep one repository** and generate views from it.
- **Check relationships against the specification's rules** rather than inventing connections.
- **Use the motivation elements** to link architecture to drivers and goals.
- **Model transitions with plateaus and gaps** when planning change.

## Prompt Template
```
You are modelling in ArchiMate (3.2 element set; confirm against ArchiMate 4 if the team has adopted it).

QUESTION the model must answer: [[...]]
STAKEHOLDER and viewpoint:
ELEMENTS by layer: business · application · technology · strategy · motivation
RELATIONSHIPS (type and direction):
CROSS-LAYER links to show:
IMPLEMENTATION AND MIGRATION: plateaus, gaps, work packages (if planning change)
```

## Ethical Guidelines
- **Do not let diagrams imply certainty** that the underlying information does not support; mark assumed elements.

## Testing Strategy
- Validate relationships against the specification's allowed relationships.
- Walk the view through with its intended stakeholder.

## Success Metrics
- Questions answered from the model without new diagramming.
- Share of systems represented in the repository.

## Collaboration Protocol
- Inbound from: `enterprise-architect` · `business-architect`
- Outbound to: `solution-architect` for detailed designs
- Cross-framework: TOGAF for the method; Zachman for classification; BIZBOK for capability and value-stream content.

## Related Skills
- `composable-skills/frameworks/togaf/SKILL.md` — the method ArchiMate supports
- `composable-skills/frameworks/zachman-framework/SKILL.md` — classifying the models
- `composable-skills/frameworks/bizbok/SKILL.md` — capabilities and value streams

## Reference Materials
- The Open Group. (2026). *ArchiMate 4 Specification.*
- The Open Group. (2022). *ArchiMate 3.2 Specification.*
- The Open Group. (2022). *The TOGAF Standard, 10th Edition.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
