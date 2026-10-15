---
skill_id: soc-2
name: SOC 2
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - soc 2
  - soc 2 type ii
  - trust services criteria
  - soc 2 audit readiness
  - security assurance report
collaborates_with:
  - security-auditor
  - compliance-officer
  - infrastructure-maintainer
  - legal-compliance-checker
ethics_required: true
priority: high
tags: [security, framework, soc2, aicpa, assurance, audit]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# SOC 2

## Purpose
Use SOC 2 to give customers independent assurance about how a service organisation protects their data and systems. A SOC 2 report is an attestation by a licensed CPA firm, under AICPA standards, on controls relevant to the **Trust Services Criteria**. It is not a certification and there is no pass mark: the report describes the system, the controls and the auditor's opinion, including any exceptions. It is a common requirement for SaaS vendors selling to businesses, especially in the United States.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `soc-2` |
| Category | Security — Assurance Reporting |
| Version | 2.0.0 |
| Owner | American Institute of Certified Public Accountants (AICPA) |
| Criteria | Trust Services Criteria (2017, with revised points of focus 2022) |
| Related reports | SOC 1 (controls relevant to financial reporting) · SOC 3 (general-use summary) |

## Key Elements
**Trust Services Categories**
- **Security** (the common criteria): required in every SOC 2.
- **Availability.**
- **Processing integrity.**
- **Confidentiality.**
- **Privacy.**
The organisation chooses which categories beyond security to include.

**Report types**
- **Type I**: whether controls are suitably designed, at a point in time.
- **Type II**: whether controls are suitably designed and operated effectively over a period, typically several months to a year.

The common criteria are organised around the COSO internal control principles, plus areas such as logical access, system operations, change management and risk mitigation.

## Core Principles
- **Attestation, not certification.** The auditor gives an opinion; exceptions are reported.
- **Your controls, your description.** The organisation defines its system and controls; the auditor tests them.
- **Operating effectiveness needs evidence over time.** Type II tests samples across the period.
- **Scope the system boundary** deliberately: services, infrastructure, people, data and subservice organisations.
- **Continuous compliance** beats a once-a-year scramble.

## Applications & Use Cases
| Use Case | Application | Element |
|---|---|---|
| Enterprise sales requirement | Obtain a Type II report for the relevant service | Type II |
| First-time readiness | Gap assessment, then a Type I | Type I |
| Customer due diligence | Share the report under NDA | Report |
| Vendor risk management | Review vendors' reports, exceptions and complementary controls | Report |
| Public trust signal | Publish a SOC 3 summary | SOC 3 |
| Aligning frameworks | Map controls shared with ISO 27001 | Common criteria |

## Usage Guidelines
- **Choose the categories** customers actually need, starting with security.
- **Run a readiness assessment** before the audit period starts.
- **Automate evidence collection** for access reviews, change management and monitoring.
- **Define complementary user entity controls** that customers are responsible for.
- **Review subservice organisations' reports**, such as your cloud provider's.

## Prompt Template
```
You are preparing for a SOC 2 examination (AICPA Trust Services Criteria).

SERVICE and system boundary: [[...]]
CATEGORIES in scope: security (+ availability · processing integrity · confidentiality · privacy)
REPORT TYPE and period:
CONTROLS by common-criteria area: designed? operating? evidence source
SUBSERVICE ORGANISATIONS and complementary user entity controls:
GAPS before the audit period:
```

## Ethical Guidelines
- **Never misrepresent a report's scope, type or exceptions** to customers.
- **Do not create evidence after the fact;** controls must actually have operated.

## Testing Strategy
- Internal testing of samples before the auditor does.
- Mock walkthroughs with control owners.

## Success Metrics
- Exceptions in the auditor's report.
- Evidence collected automatically versus manually.
- Sales cycles unblocked by the report.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `infrastructure-maintainer`
- Outbound to: `security-auditor`; `legal-compliance-checker` for report sharing and NDAs
- Cross-framework: ISO 27001 for an international certification; NIST CSF for program design; COBIT for governance.

## Related Skills
- `composable-skills/frameworks/iso-27001/SKILL.md` — international certification
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — program design
- `composable-skills/frameworks/cobit/SKILL.md` — governance
- `composable-skills/frameworks/sox/SKILL.md` — financial reporting controls

## Reference Materials
- AICPA. (2017, revised points of focus 2022). *Trust Services Criteria for Security, Availability, Processing Integrity, Confidentiality, and Privacy.*
- AICPA. *SOC 2 Reporting on an Examination of Controls at a Service Organization Relevant to Security, Availability, Processing Integrity, Confidentiality, or Privacy* (Guide).
- COSO. (2013). *Internal Control — Integrated Framework.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
