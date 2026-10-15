---
skill_id: itil
name: ITIL
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - itil
  - it service management
  - incident management
  - change enablement
  - service desk
collaborates_with:
  - infrastructure-maintainer
  - support-responder
  - technology-architect
  - governance-specialist
ethics_required: false
priority: high
tags: [enterprise-architecture, framework, itil, itsm, service-management]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# ITIL

## Purpose
Use ITIL to manage IT-enabled services so that they create value for customers and users. ITIL 4 frames service management as a **service value system**: guiding principles, governance, a value chain of activities, a set of practices and continual improvement, all working together. It replaced the earlier, more process-heavy service lifecycle with a flexible model that works alongside Agile, DevOps and Lean.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `itil` |
| Category | Enterprise Architecture — IT Service Management |
| Version | 2.0.0 |
| Owner | PeopleCert (acquired AXELOS, the previous owner, in 2021) |
| Current version | ITIL 4 (Foundation published 2019) |
| Related standard | ISO/IEC 20000-1 (service management system requirements) |

## The Service Value System
- **Guiding principles** (seven): focus on value; start where you are; progress iteratively with feedback; collaborate and promote visibility; think and work holistically; keep it simple and practical; optimise and automate.
- **Governance.**
- **Service value chain** (six activities): plan; improve; engage; design and transition; obtain or build; deliver and support.
- **Practices** (34 in ITIL 4), grouped as general management, service management and technical management. Examples: incident management, problem management, change enablement, service desk, service level management.
- **Continual improvement.**

**Four dimensions** to consider for every service: organisations and people; information and technology; partners and suppliers; value streams and processes.

## Core Principles
- **Value is co-created** with customers, not delivered to them.
- **Start where you are.** Build on what works before replacing it.
- **Progress iteratively** with feedback, rather than in big-bang programmes.
- **Think holistically** across all four dimensions.
- **Keep it simple, then optimise and automate.**

## Applications & Use Cases
| Use Case | Application | Practice |
|---|---|---|
| Restoring service fast | Incident management with clear priorities and escalation | Incident management |
| Recurring outages | Find and remove root causes | Problem management |
| Risky changes | Risk-based change authorisation, with standard changes pre-approved | Change enablement |
| Single point of contact | A service desk across channels | Service desk |
| Agreeing expectations | Service level targets with customers | Service level management |
| Improving over time | A continual improvement register | Continual improvement |

## Usage Guidelines
- **Map the value streams** for key services before redesigning practices.
- **Adopt practices selectively**, starting with the ones causing most pain.
- **Separate incident (restore service) from problem (remove cause)** management.
- **Make change enablement risk-based**, with automation and pre-approved standard changes.
- **Keep a continual improvement register** and work through it.

## Prompt Template
```
You are improving IT service management with ITIL 4.

SERVICE and its consumers: [[...]]
VALUE STREAM: from demand to value, step by step
FOUR DIMENSIONS: people · information and technology · partners · processes
PRIORITY PRACTICES: current pain, target state
GUIDING PRINCIPLES applied:
IMPROVEMENT REGISTER: next three items
```

## Ethical Guidelines
- **Treat users fairly in prioritisation;** make priority rules transparent.
- **Protect personal data** captured in tickets and service records.

## Testing Strategy
- Run major-incident exercises.
- Review changes that failed and how they were authorised.

## Success Metrics
- Mean time to restore service.
- Repeat incidents linked to known problems.
- Change success rate.
- Customer satisfaction with services.

## Collaboration Protocol
- Inbound from: `infrastructure-maintainer` · `support-responder` · `technology-architect`
- Outbound to: `governance-specialist` for alignment with COBIT
- Cross-framework: COBIT for governance; CI/CD and Kanban for delivery flow; SANS incident response for security incidents.

## Related Skills
- `composable-skills/frameworks/cobit/SKILL.md` — governance of I&T
- `composable-skills/frameworks/cicd/SKILL.md` — automated change delivery
- `composable-skills/frameworks/sans-incident-response/SKILL.md` — security incident handling

## Reference Materials
- AXELOS. (2019). *ITIL Foundation: ITIL 4 Edition.* TSO.
- ISO/IEC 20000-1:2018. *Service management — Part 1: Service management system requirements.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
