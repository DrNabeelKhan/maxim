---
skill_id: cobit
name: COBIT
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - cobit
  - it governance
  - governance of enterprise it
  - control objectives
  - it audit framework
collaborates_with:
  - governance-specialist
  - compliance-officer
  - enterprise-architect
  - infrastructure-maintainer
ethics_required: true
priority: high
tags: [enterprise-architecture, framework, cobit, governance, isaca, audit]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# COBIT

## Purpose
Use COBIT, published by ISACA, to govern and manage enterprise information and technology (I&T) so that it creates value, manages risk and uses resources well. COBIT separates **governance**, where a board evaluates, directs and monitors, from **management**, which plans, builds, runs and monitors. It defines a set of governance and management objectives, and is widely used by IT auditors as a reference for control.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `cobit` |
| Category | Enterprise Architecture — I&T Governance |
| Version | 2.0.0 |
| Owner | ISACA |
| Current version | COBIT 2019, which ISACA is succeeding with COBIT 7 (the COBIT 7 Foundations certificate replaces the COBIT 2019 one on 27 October 2026). The structure below is COBIT 2019's; check COBIT 7 for changes. |
| Related standards | ISO/IEC 38500 (governance of IT) · COSO · ITIL · ISO/IEC 27001 |

## Structure
**Five domains of objectives** (40 objectives in COBIT 2019)
- **EDM — Evaluate, Direct and Monitor**: governance.
- **APO — Align, Plan and Organise**: management.
- **BAI — Build, Acquire and Implement**: management.
- **DSS — Deliver, Service and Support**: management.
- **MEA — Monitor, Evaluate and Assess**: management.

**Components of a governance system**: processes; organisational structures; principles, policies and procedures; information; culture, ethics and behaviour; people, skills and competencies; and services, infrastructure and applications.

**Design factors** such as strategy, risk profile, compliance requirements and sourcing model tailor which objectives matter most.

**Capability levels** (0 to 5) assess how well processes are performed.

## Core Principles
- **Provide stakeholder value**: governance exists to balance benefits, risk and resources.
- **Holistic approach**: governance needs all seven components, not processes alone.
- **Dynamic**: the governance system adapts as design factors change.
- **Governance is distinct from management.**
- **Tailor to the enterprise**, using design factors and focus areas.

## Applications & Use Cases
| Use Case | Application | Domain |
|---|---|---|
| Board oversight of IT | Define direction, oversight and reporting | EDM |
| IT audit planning | Use objectives as an audit reference | All |
| Process improvement | Assess capability levels and close gaps | APO, BAI, DSS |
| Aligning IT with strategy | Goals cascade from enterprise to alignment goals | APO |
| Risk management | Integrate I&T risk into enterprise risk | EDM, APO |
| Regulatory compliance | Map objectives to regulatory controls | MEA |

## Usage Guidelines
- **Use the design factors** to decide which objectives to prioritise; do not implement all 40 at once.
- **Separate governance and management roles** clearly.
- **Assess current capability levels** for priority processes, then set targets.
- **Cascade enterprise goals to I&T goals** so that work traces to value.
- **Monitor and report** to the governing body regularly.

## Prompt Template
```
You are designing I&T governance with COBIT 2019 (ISACA).

ENTERPRISE CONTEXT and design factors: [[...]]
PRIORITY OBJECTIVES (EDM · APO · BAI · DSS · MEA):
FOR EACH: current capability level · target · gap · owner
COMPONENTS needed: processes · structures · policies · information · culture · skills · services
GOVERNANCE vs MANAGEMENT roles:
REPORTING to the board:
```

## Ethical Guidelines
- **Culture, ethics and behaviour are a component of governance,** not an afterthought.
- **Report risks honestly to the governing body,** including unfavourable assessments.

## Testing Strategy
- Audit sampled processes against their stated capability level.
- Check that each priority objective has a named owner and evidence.

## Success Metrics
- Priority processes at target capability.
- Audit findings by severity over time.
- I&T goals traceable to enterprise goals.

## Collaboration Protocol
- Inbound from: `governance-specialist` · `compliance-officer`
- Outbound to: `enterprise-architect` · `infrastructure-maintainer`
- Cross-framework: ITIL for service management practices; ISO 27001 for information security; SOC 2 for assurance reporting; TOGAF for architecture.

## Related Skills
- `composable-skills/frameworks/itil/SKILL.md` — service management practices
- `composable-skills/frameworks/iso-27001/SKILL.md` — information security management
- `composable-skills/frameworks/soc-2/SKILL.md` — assurance reporting
- `composable-skills/frameworks/togaf/SKILL.md` — enterprise architecture

## Reference Materials
- ISACA. (2018). *COBIT 2019 Framework: Introduction and Methodology.*
- ISACA. (2018). *COBIT 2019 Framework: Governance and Management Objectives.*
- ISO/IEC 38500. *Information technology — Governance of IT for the organization.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
