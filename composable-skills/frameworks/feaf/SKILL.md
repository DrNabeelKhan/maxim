---
skill_id: feaf
name: FEAF
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - feaf
  - federal enterprise architecture
  - reference models
  - government enterprise architecture
collaborates_with:
  - enterprise-architect
  - security-architect
  - compliance-officer
ethics_required: false
priority: medium
tags: [enterprise-architecture, framework, feaf, government, reference-models]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# FEAF

## Purpose
Use the Federal Enterprise Architecture Framework (FEAF) to structure enterprise architecture in United States federal agencies, or as a model for public-sector architecture elsewhere. FEAF gives agencies a common set of **reference models** for classifying their performance goals, business functions, data, applications, infrastructure and security, so that investments can be compared and shared across government. Its planning method, the Collaborative Planning Methodology, guides how architecture work is done.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `feaf` |
| Category | Enterprise Architecture — Public Sector |
| Version | 2.0.0 |
| Owner | US Office of Management and Budget (OMB) |
| Current version | FEAF Version 2 (2013), with *The Common Approach to Federal Enterprise Architecture* (2012) |
| Legal basis | Clinger-Cohen Act (1996), which made agency CIOs responsible for IT architecture |

## The Six Reference Models
- **Performance Reference Model (PRM)**: links investments to agency and government goals and measures.
- **Business Reference Model (BRM)**: describes government functions and services, independent of which agency performs them.
- **Data Reference Model (DRM)**: describes and categorises data to support discovery and sharing.
- **Application Reference Model (ARM)**: categorises software and applications.
- **Infrastructure Reference Model (IRM)**: categorises network, hosting and platform assets.
- **Security Reference Model (SRM)**: a common language for security and privacy across the other models.

**Collaborative Planning Methodology (CPM)**: an iterative planning process that runs from organising and planning through investment, implementation and measurement.

## Core Principles
- **A common taxonomy enables comparison.** Shared reference models let agencies find duplication and reuse.
- **Tie architecture to performance.** Investments should be justified by mission outcomes.
- **Security and privacy run across every layer**, not in a separate silo.
- **Plan collaboratively** with stakeholders across organisational boundaries.
- **Architecture supports investment decisions**, including budget submissions.

## Applications & Use Cases
| Use Case | Application | Model |
|---|---|---|
| Finding duplicate systems | Classify applications and compare across agencies | ARM, BRM |
| Investment justification | Link IT investments to mission performance | PRM |
| Data sharing | Common data descriptions across agencies | DRM |
| Shared services | Identify common functions to consolidate | BRM |
| Security architecture | Consistent controls across systems | SRM |
| Public-sector EA outside the US | Adapt the reference-model approach | All |

## Usage Guidelines
- **Classify investments and systems against the reference models** before proposing new ones.
- **State the performance outcome** each investment supports.
- **Use the Collaborative Planning Methodology** to involve stakeholders across organisations.
- **Apply the Security Reference Model** to every architecture layer.
- **Check current OMB guidance**, as federal requirements and reporting change.

## Prompt Template
```
You are applying FEAF v2 (OMB, Common Approach 2012).

AGENCY / PROGRAMME: [[...]]
REFERENCE MODEL CLASSIFICATION:
performance (PRM) · business (BRM) · data (DRM) · application (ARM) · infrastructure (IRM) · security (SRM)
DUPLICATION or reuse opportunities:
CPM STAGE and next steps:
```

## Ethical Guidelines
- **Public systems serve citizens.** Weigh accessibility, privacy and equity of service in architecture choices.
- **Be transparent about investment justification;** do not inflate performance links.

## Testing Strategy
- Check that every investment maps to at least one performance measure.

## Success Metrics
- Duplicate systems identified and retired.
- Investments with a documented performance link.
- Shared services adopted across organisations.

## Collaboration Protocol
- Inbound from: `enterprise-architect` · `compliance-officer`
- Outbound to: `security-architect` for SRM alignment
- Cross-framework: TOGAF for general method; FedRAMP for federal cloud authorisation; NIST SP 800-53 for federal security controls.

## Related Skills
- `composable-skills/frameworks/togaf/SKILL.md` — general architecture method
- `composable-skills/frameworks/fedramp/SKILL.md` — federal cloud authorisation
- `composable-skills/frameworks/nist-sp-800-53/SKILL.md` — federal security controls

## Reference Materials
- US Office of Management and Budget. (2013). *Federal Enterprise Architecture Framework, Version 2.*
- US Office of Management and Budget. (2012). *The Common Approach to Federal Enterprise Architecture.*
- Clinger-Cohen Act of 1996 (Information Technology Management Reform Act).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
