---
skill_id: gdpr
name: GDPR
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - gdpr
  - general data protection regulation
  - lawful basis
  - data subject rights
  - dpia
  - eu personal data
collaborates_with:
  - compliance-officer
  - legal-compliance-checker
  - security-architect
  - data-architect
  - support-responder
ethics_required: true
priority: high
tags: [security, framework, privacy, gdpr, eu, regulation]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# GDPR

## Purpose
Use the General Data Protection Regulation (GDPR) to process personal data of people in the EU lawfully, fairly and transparently. The GDPR is a binding EU regulation, not a voluntary framework: it sets principles for processing, requires a lawful basis for every processing activity, gives individuals enforceable rights, and imposes accountability duties on controllers and processors. It can apply to organisations outside the EU that offer goods or services to, or monitor, people in the EU. This definition is a working guide, not legal advice.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `gdpr` |
| Category | Privacy — Regulation |
| Version | 2.0.0 |
| Instrument | Regulation (EU) 2016/679, applicable since 25 May 2018 |
| Enforcement | National supervisory authorities, coordinated by the European Data Protection Board (EDPB) |
| Maximum fines | Up to €20 million or 4% of worldwide annual turnover, whichever is higher (Art. 83) |
| Related | UK GDPR (separate UK law) · ePrivacy rules for cookies and electronic marketing |

## Key Requirements
- **Principles (Art. 5)**: lawfulness, fairness and transparency; purpose limitation; data minimisation; accuracy; storage limitation; integrity and confidentiality; accountability.
- **Lawful bases (Art. 6)**: consent, contract, legal obligation, vital interests, public task, legitimate interests. Special category data needs an additional condition (Art. 9).
- **Rights (Arts. 12–22)**: information, access, rectification, erasure, restriction, portability, objection, and rights related to automated decision-making.
- **Data protection by design and by default (Art. 25).**
- **Processor contracts (Art. 28)** and **records of processing activities (Art. 30).**
- **Security of processing (Art. 32).**
- **Breach notification**: to the supervisory authority within 72 hours where feasible (Art. 33), and to individuals when the risk to them is high (Art. 34).
- **Data protection impact assessments (Art. 35)** for high-risk processing.
- **International transfers (Chapter V)**: adequacy decisions, standard contractual clauses, binding corporate rules or specific derogations.

## Core Principles
- **Every processing activity needs a lawful basis,** chosen before processing starts.
- **Collect only what you need** and keep it only as long as needed.
- **Be transparent** about what you do with data, in clear language.
- **Accountability**: be able to demonstrate compliance, not just claim it.
- **Build privacy in** from the design stage.

## Applications & Use Cases
| Use Case | Application | Requirement |
|---|---|---|
| New product feature | DPIA screening and privacy by design | Arts. 25, 35 |
| Marketing consent | Valid, specific, freely given consent and easy withdrawal | Arts. 6, 7 |
| Access and deletion requests | A process to respond within one month | Arts. 12, 15, 17 |
| Vendors and sub-processors | Data processing agreements | Art. 28 |
| Data breach | Assess risk and notify within 72 hours where required | Arts. 33, 34 |
| Transfers outside the EU | Choose a transfer mechanism and assess risk | Chapter V |

## Usage Guidelines
- **Maintain a record of processing activities** with purpose, lawful basis, data, recipients and retention.
- **Screen new processing for DPIA need** and complete DPIAs before high-risk processing begins.
- **Set up a rights-request process** with identity verification and deadlines.
- **Sign Article 28 agreements** with every processor.
- **Rehearse breach assessment and notification** against the 72-hour deadline.

## Prompt Template
```
You are assessing GDPR compliance (Regulation (EU) 2016/679). Not legal advice.

PROCESSING ACTIVITY: [[...]]
ROLE: controller / processor / joint controller
PURPOSE and LAWFUL BASIS (Art. 6; Art. 9 condition if special category):
DATA collected, minimised? retention period?
TRANSPARENCY: privacy notice coverage
RIGHTS: how each is fulfilled
PROCESSORS and transfers (Art. 28; Chapter V mechanism):
DPIA needed? SECURITY measures (Art. 32):
```

## Ethical Guidelines
- **This is not legal advice.** Confirm interpretations with qualified counsel or the relevant supervisory authority's guidance.
- **Avoid manipulative consent design,** such as pre-ticked boxes or hidden refusal options.
- **Respect the spirit of the rules,** not only their letter: people's expectations matter.

## Testing Strategy
- Test rights-request handling end to end, including identity checks.
- Audit consent records and withdrawal.
- Breach-notification tabletop exercises.

## Success Metrics
- Rights requests completed within the legal deadline.
- Processing activities with a documented lawful basis.
- Processors with signed agreements.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `data-architect` · `support-responder`
- Outbound to: `legal-compliance-checker` for legal interpretation; `security-architect` for Art. 32 measures
- Cross-framework: CCPA and LGPD for other jurisdictions; DMBOK for data governance; ISO 27001 for security; EU AI Act for AI systems using personal data.

## Related Skills
- `composable-skills/frameworks/ccpa/SKILL.md` — California privacy law
- `composable-skills/frameworks/lgpd/SKILL.md` — Brazil's data protection law
- `composable-skills/frameworks/dmbok/SKILL.md` — data governance
- `composable-skills/frameworks/eu-ai-act/SKILL.md` — AI regulation

## Reference Materials
- Regulation (EU) 2016/679 (General Data Protection Regulation). *Official Journal of the European Union*, L 119, 4 May 2016.
- European Data Protection Board. *Guidelines* (various, including on consent, DPIAs and breach notification). edpb.europa.eu.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
