---
skill_id: dora
name: DORA (Digital Operational Resilience Act)
version: 2.0.0
category: security-compliance
type: framework
frameworks: []
triggers:
  - dora regulation
  - digital operational resilience act
  - ict risk management
  - ict third-party risk
  - threat-led penetration testing
collaborates_with:
  - compliance-officer
  - security-architect
  - incident-responder
  - penetration-tester
  - legal-compliance-checker
ethics_required: true
priority: medium
tags: [security-compliance, framework, dora, eu, financial-services, resilience]
adr: ADR-007
created: 2026-07-08
updated: 2026-10-15
---

# DORA (Digital Operational Resilience Act)

## Purpose
Apply DORA to manage ICT risk and operational resilience for EU financial entities. DORA is an EU regulation that sets one harmonised set of requirements for how banks, insurers, investment firms, payment institutions, crypto-asset service providers and other financial entities govern ICT risk, report major ICT incidents, test their resilience, manage ICT third-party providers and share threat intelligence. It also brings critical ICT providers to the financial sector under direct EU oversight. Not to be confused with the DORA delivery metrics used in software engineering. This definition is a working guide, not legal advice.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `dora` |
| Category | Security & Compliance — Regulation |
| Version | 2.0.0 |
| Instrument | Regulation (EU) 2022/2554, applicable since 17 January 2025 |
| Supplementing rules | Regulatory and implementing technical standards (RTS/ITS) developed by the European Supervisory Authorities (EBA, EIOPA, ESMA) |
| Supervision | National competent authorities; Lead Overseers for designated critical ICT third-party providers |

## The Five Pillars
- **ICT risk management**: a documented framework owned by the management body, covering identification, protection, detection, response, recovery, learning and communication.
- **ICT-related incident management and reporting**: classify incidents and report major ones to the competent authority through an initial notification, an intermediate report and a final report, on deadlines set in the technical standards.
- **Digital operational resilience testing**: a risk-based testing programme for all in-scope entities, plus threat-led penetration testing (TLPT) at least every three years for entities identified by their authorities.
- **ICT third-party risk**: a register of information on all ICT service contracts, mandatory contract terms, exit strategies, and concentration-risk assessment.
- **Information sharing**: voluntary arrangements for sharing cyber threat information among financial entities.

## Core Principles
- **The management body is accountable** for ICT risk and must approve and oversee the framework.
- **Proportionality**: requirements scale with an entity's size, risk profile and the nature of its services.
- **Resilience must be tested,** not assumed; TLPT uses real threat intelligence.
- **Outsourcing does not transfer responsibility.** The financial entity remains fully responsible for its obligations.
- **Report major incidents fast and consistently** using the harmonised classification criteria.

## Applications & Use Cases
| Use Case | Application | Pillar |
|---|---|---|
| ICT risk management | Establish a board-approved framework and risk strategy | ICT risk management |
| ICT incident reporting | Classify incidents and report major ones on the mandated timeline | Incident reporting |
| Resilience testing | Run a testing programme and, where required, TLPT | Resilience testing |
| Third-party risk | Review contracts with ICT providers against mandatory terms and plan exits | Third-party risk |
| Register of information | Maintain the register of ICT contractual arrangements for supervisors | Third-party risk |
| ICT providers serving finance | Prepare for client due diligence and possible critical designation | Third-party risk |

## Usage Guidelines
- **Confirm scope:** which entity types and services DORA covers, and whether simplified requirements apply.
- **Map ICT risk management to the regulation and its technical standards,** with management-body approval.
- **Implement incident classification and reporting procedures** and test them against the deadlines.
- **Build and maintain the register of information** and remediate contracts missing mandatory terms.
- **Plan the testing programme,** including TLPT if your authority identifies you.

## Prompt Template
```
You are assessing compliance with DORA (Regulation (EU) 2022/2554). Not legal advice.

ENTITY TYPE and scope (proportionality / simplified regime?): [[...]]
ICT RISK MANAGEMENT: framework, management-body oversight, gaps
INCIDENT REPORTING: classification criteria, reporting workflow, deadlines
RESILIENCE TESTING: programme; TLPT applicability
THIRD-PARTY RISK: register of information; contracts vs mandatory terms; exit plans; concentration
INFORMATION SHARING: arrangements in place
PRIORITY GAPS:
```

## Ethical Guidelines
- **This is not legal advice.** Confirm with counsel and the current technical standards.
- **Report incidents truthfully and on time,** even when it is uncomfortable.
- **Conduct TLPT only within authorised scope** and agreed rules of engagement.

## Testing Strategy
- Incident-reporting drills against the regulatory deadlines.
- Exit-plan tests for critical ICT providers.
- Scenario-based resilience tests, including severe but plausible scenarios.

## Success Metrics
- Major incidents reported within deadlines.
- ICT contracts compliant with mandatory terms.
- Testing findings remediated on schedule.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `legal-compliance-checker`
- Outbound to: `security-architect` for ICT risk controls; `incident-responder` for reporting; `penetration-tester` for TLPT
- Cross-framework: NIST CSF for risk-management structure; SANS incident response for handling; ISO 27001 for the security management system.

## Related Skills
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — risk-management structure
- `composable-skills/frameworks/sans-incident-response/SKILL.md` — incident handling
- `composable-skills/frameworks/iso-27001/SKILL.md` — security management system
- `composable-skills/frameworks/gdpr/SKILL.md` — overlapping breach obligations

## Reference Materials
- Regulation (EU) 2022/2554 on digital operational resilience for the financial sector. *Official Journal of the European Union*, L 333, 27 December 2022.
- European Supervisory Authorities (EBA, EIOPA, ESMA). DORA regulatory and implementing technical standards.
- European Central Bank. *TIBER-EU Framework* (threat intelligence-based ethical red teaming).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Revised 2026-10-15: generic template sections replaced with authored content._
