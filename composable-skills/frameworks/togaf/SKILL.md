---
skill_id: togaf
name: TOGAF
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - togaf
  - architecture development method
  - adm cycle
  - enterprise architecture roadmap
  - architecture governance
collaborates_with:
  - enterprise-architect
  - solution-architect
  - business-architect
  - governance-specialist
ethics_required: false
priority: high
tags: [enterprise-architecture, framework, togaf, adm, open-group, governance]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# TOGAF

## Purpose
Use TOGAF, The Open Group Architecture Framework, to develop and govern enterprise architecture in a structured, repeatable way. Its core is the **Architecture Development Method (ADM)**, an iterative cycle that takes an organisation from a vision of its target architecture, through business, data, application and technology design, to a governed migration plan. TOGAF is a method and a vocabulary, not a template to fill in completely: its own guidance expects it to be tailored to the organisation.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `togaf` |
| Category | Enterprise Architecture — Method |
| Version | 2.0.0 |
| Owner | The Open Group |
| Current edition | TOGAF Standard, 10th Edition (2022), split into Fundamental Content and Series Guides |
| Related standards | ArchiMate (modelling language, also The Open Group) · ISO/IEC/IEEE 42010 (architecture description) |

## The Architecture Development Method
- **Preliminary**: set up the architecture capability, principles and tailoring.
- **A. Architecture Vision**: scope, stakeholders, the vision and approval to proceed.
- **B. Business Architecture.**
- **C. Information Systems Architectures**: data and application.
- **D. Technology Architecture.**
- **E. Opportunities and Solutions**: identify work packages and transition architectures.
- **F. Migration Planning**: a sequenced, costed roadmap.
- **G. Implementation Governance**: architecture oversight of delivery projects.
- **H. Architecture Change Management**: keep the architecture current as things change.
- **Requirements Management** sits at the centre and feeds every phase.

Phases B to D each compare a **baseline** (current) with a **target** architecture and record the **gaps**.

## Core Principles
- **Iterate and tailor.** Run the ADM at the depth the decision needs, not every step in full.
- **Start from business drivers**, not from technology.
- **Baseline, target, gap.** Every architecture domain is analysed this way.
- **Govern the architecture**, through principles, compliance reviews and an architecture board.
- **Reuse** through the Architecture Repository and the Enterprise Continuum, from generic to organisation-specific.

## Applications & Use Cases
| Use Case | Application | ADM Phase |
|---|---|---|
| Establishing an EA practice | Define principles, governance and tailoring | Preliminary |
| Transformation programme | Vision, target architectures and roadmap | A to F |
| Application rationalisation | Baseline and target application architecture | C |
| Cloud migration | Technology target state and transition architectures | D, E, F |
| Keeping projects aligned | Architecture compliance reviews | G |
| Responding to change | Assess change requests against the architecture | H |

## Usage Guidelines
- **Agree architecture principles first**, each with a rationale and implications.
- **Scope each ADM cycle** to a decision; avoid boiling the ocean.
- **Record baseline, target and gaps** for each domain you work on.
- **Turn gaps into work packages and a sequenced roadmap** with transition architectures.
- **Set up architecture governance**, such as a board and compliance reviews, before implementation begins.

## Prompt Template
```
You are running a TOGAF ADM cycle (TOGAF Standard, 10th Edition).

SCOPE and the decision this cycle supports: [[...]]
PRINCIPLES that apply:
VISION (Phase A): stakeholders, concerns, target outcome
FOR EACH DOMAIN (B business · C data, application · D technology):
  baseline · target · gaps
OPPORTUNITIES (E): work packages, transition architectures
ROADMAP (F): sequence, dependencies, cost
GOVERNANCE (G): how delivery will be checked against the architecture
```

## Ethical Guidelines
- **Represent stakeholder concerns honestly,** including those of groups the change affects but who are not sponsors.
- **Do not present a target architecture as approved** before governance has approved it.

## Testing Strategy
- Trace every work package back to a gap and a business driver.
- Review architecture deliverables with the stakeholders whose concerns they address.

## Success Metrics
- Projects passing architecture compliance reviews.
- Roadmap milestones delivered against plan.
- Reduction in duplicated capabilities or applications.

## Collaboration Protocol
- Inbound from: `enterprise-architect` · `business-architect` · `governance-specialist`
- Outbound to: `solution-architect` for project-level designs
- Cross-framework: ArchiMate for models; Zachman for classifying artifacts; BIZBOK for business architecture depth; COBIT for IT governance.

## Related Skills
- `composable-skills/frameworks/archimate/SKILL.md` — modelling language for ADM deliverables
- `composable-skills/frameworks/zachman-framework/SKILL.md` — classifying architecture artifacts
- `composable-skills/frameworks/bizbok/SKILL.md` — business architecture
- `composable-skills/frameworks/cobit/SKILL.md` — IT governance

## Reference Materials
- The Open Group. (2022). *The TOGAF Standard, 10th Edition.*
- ISO/IEC/IEEE 42010:2022. *Software, systems and enterprise — Architecture description.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
