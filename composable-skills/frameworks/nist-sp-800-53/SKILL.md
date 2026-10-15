---
skill_id: nist-sp-800-53
name: NIST SP 800-53 (Security and Privacy Controls)
version: 2.0.0
category: security-compliance
type: framework
frameworks: []
triggers:
  - nist sp 800-53
  - nist 800-53
  - security control baseline
  - control families
  - risk management framework
collaborates_with:
  - security-architect
  - compliance-officer
  - security-auditor
  - infrastructure-maintainer
ethics_required: true
priority: medium
tags: [security-compliance, framework, nist, controls, privacy, rmf]
adr: ADR-007
created: 2026-07-08
updated: 2026-10-15
---

# NIST SP 800-53 (Security and Privacy Controls)

## Purpose
Apply NIST SP 800-53 to select, implement and assess security and privacy controls for information systems and organisations. It is a comprehensive catalogue of controls, organised into families. It is mandatory for US federal systems and is the basis of FedRAMP, but it is also widely used outside government. Revision 5 made controls outcome-based and usable by any organisation, and brought privacy and supply-chain risk management into the catalogue.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `nist-sp-800-53` |
| Category | Security & Compliance — Control Catalogue |
| Version | 2.0.0 |
| Owner | US National Institute of Standards and Technology (NIST) |
| Current revision | SP 800-53 Rev. 5 (2020), with later minor releases of the catalogue; check the current release |
| Companion publications | SP 800-53A (assessment procedures) · SP 800-53B (control baselines) · SP 800-37 Rev. 2 (Risk Management Framework) |

## Structure
**Twenty control families in Rev. 5**: access control (AC); awareness and training (AT); audit and accountability (AU); assessment, authorisation and monitoring (CA); configuration management (CM); contingency planning (CP); identification and authentication (IA); incident response (IR); maintenance (MA); media protection (MP); physical and environmental protection (PE); planning (PL); program management (PM); personnel security (PS); PII processing and transparency (PT); risk assessment (RA); system and services acquisition (SA); system and communications protection (SC); system and information integrity (SI); and supply chain risk management (SR).

**Each control** has a base statement, optional **control enhancements**, a discussion, related controls and **organisation-defined parameters**.

**Baselines (SP 800-53B)**: low, moderate and high security baselines plus a privacy baseline, selected by system impact level.

**Risk Management Framework (SP 800-37)**: prepare, categorise, select, implement, assess, authorise and monitor.

## Core Principles
- **Start from a baseline, then tailor** to the system's risk, scoping out what does not apply and adding what does.
- **Set the parameters.** Organisation-defined values, such as review frequencies, make controls concrete.
- **Security and privacy are integrated** in one catalogue.
- **Assess implementation and effectiveness,** not just existence, using SP 800-53A.
- **Monitor continuously.** Authorisation reflects risk at a point in time; monitoring keeps it current.

## Applications & Use Cases
| Use Case | Application | Element |
|---|---|---|
| Control selection | Choose a baseline by impact level and tailor it | Baselines |
| Federal compliance | Map controls to FedRAMP and agency requirements | Baselines, RMF |
| Control assessment | Audit implemented controls with SP 800-53A procedures | Assessment |
| Control implementation | Deploy access, audit, configuration and integrity controls | AC, AU, CM, SI |
| Supply chain risk | Apply SR controls to suppliers and components | SR |
| Mapping frameworks | Use NIST mappings to CSF and ISO/IEC 27001 | Catalogue |

## Usage Guidelines
- **Categorise the system** by impact (FIPS 199) and select the matching baseline.
- **Tailor the baseline** and record the rationale for each change.
- **Set every organisation-defined parameter** explicitly.
- **Document implementation in a system security plan** and assess with SP 800-53A.
- **Set up continuous monitoring** and track weaknesses in a plan of action and milestones.

## Prompt Template
```
You are applying NIST SP 800-53 Rev. 5 (with SP 800-53B baselines; SP 800-37 RMF).

SYSTEM and impact level (FIPS 199): [[...]]
BASELINE: low / moderate / high (+ privacy baseline?)
TAILORING: controls scoped out, added, compensating — with rationale
PARAMETERS to define:
FAMILY REVIEW (priority families first): implemented / partial / planned
ASSESSMENT method (SP 800-53A) and evidence:
CONTINUOUS MONITORING and POA&M:
```

## Ethical Guidelines
- **Apply least privilege** and never store sensitive data in plaintext or logs.
- **Use the PT family and the privacy baseline** where PII is processed; security alone is not enough.
- **Do not mark controls implemented without evidence.**

## Testing Strategy
- Assess controls with SP 800-53A examine, interview and test methods.
- Re-assess after significant system changes.

## Success Metrics
- Baseline controls implemented and assessed as effective.
- Open plan-of-action items and their age.
- Findings by family over time.

## Collaboration Protocol
- Inbound from: `security-architect` · `compliance-officer`
- Outbound to: `security-auditor` for assessment; `infrastructure-maintainer` for implementation
- Cross-framework: FedRAMP builds on these baselines; NIST CSF provides outcome-level structure; ISO 27001 Annex A maps to many controls; DevSecOps implements SA and SR controls in delivery.

## Related Skills
- `composable-skills/frameworks/fedramp/SKILL.md` — federal cloud authorisation
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — outcome-level structure
- `composable-skills/frameworks/iso-27001/SKILL.md` — management-system counterpart
- `composable-skills/frameworks/devsecops/SKILL.md` — secure development controls

## Reference Materials
- NIST. (2020). SP 800-53 Rev. 5, *Security and Privacy Controls for Information Systems and Organizations.*
- NIST. (2020). SP 800-53B, *Control Baselines for Information Systems and Organizations.*
- NIST. (2022). SP 800-53A Rev. 5, *Assessing Security and Privacy Controls in Information Systems and Organizations.*
- NIST. (2018). SP 800-37 Rev. 2, *Risk Management Framework for Information Systems and Organizations.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Revised 2026-10-15: generic template sections replaced with authored content._
