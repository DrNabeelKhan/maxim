---
skill_id: lgpd
name: LGPD (Lei Geral de Proteção de Dados — Brazil)
version: 2.0.0
category: security-compliance
type: framework
frameworks: []
triggers:
  - lgpd
  - brazil data protection
  - lei geral de protecao de dados
  - anpd
  - brazilian privacy law
collaborates_with:
  - compliance-officer
  - legal-compliance-checker
  - data-architect
  - security-architect
ethics_required: true
priority: medium
tags: [security-compliance, framework, privacy, lgpd, brazil, regulation]
adr: ADR-007
created: 2026-07-08
updated: 2026-10-15
---

# LGPD (Lei Geral de Proteção de Dados — Brazil)

## Purpose
Apply the LGPD, Brazil's General Data Protection Law, to process personal data lawfully: on a valid legal basis, in line with its principles, while respecting data subjects' rights and the requirements of the national authority (ANPD). Like the GDPR, it can apply to organisations outside Brazil, for example when processing takes place in Brazil, the purpose is to offer goods or services to people in Brazil, or the data was collected in Brazil. This definition is a working guide, not legal advice.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `lgpd` |
| Category | Security & Compliance — Regulation |
| Version | 2.0.0 |
| Instrument | Law No. 13,709/2018, amended by Law No. 13,853/2019 (which created the ANPD) |
| In force | September 2020; administrative sanctions enforceable from August 2021 |
| Authority | The ANPD, Brazil's national data protection authority, which issues implementing resolutions. Law No. 15,352/2026 restructured it as a special-nature autarchy with regulatory-agency status; check the current text of Art. 55-A for its exact name. |
| Maximum fine | Up to 2% of the organisation's revenue in Brazil, limited to R$50 million per infraction (Art. 52) |

## Legal Bases (Art. 7)
- **Consent** of the data subject.
- **Legal or regulatory obligation** of the controller.
- **Public administration** carrying out public policies.
- **Studies by a research body**, with anonymisation where possible.
- **Performance of a contract** or preliminary procedures at the data subject's request.
- **Exercise of rights** in judicial, administrative or arbitration proceedings.
- **Protection of life** or physical safety.
- **Protection of health**, by health professionals, health services or health authorities.
- **Legitimate interests** of the controller or a third party.
- **Credit protection.**

Sensitive personal data has a narrower set of bases (Art. 11).

## Core Principles
- **Purpose, adequacy and necessity** (Art. 6): process for specific, legitimate purposes and only the minimum data needed.
- **Free access, data quality and transparency**: data subjects can see their data, which must be accurate, with clear information about processing.
- **Security and prevention**: technical and administrative measures to prevent harm.
- **Non-discrimination**: no processing for unlawful or abusive discriminatory purposes.
- **Accountability**: demonstrate the measures taken to comply.

## Applications & Use Cases
| Use Case | Application | Requirement |
|---|---|---|
| LATAM privacy compliance | Assess each processing activity against the Art. 7 legal bases | Legal bases |
| Regulatory alignment | Follow ANPD resolutions and guidance | ANPD |
| Data classification | Identify personal and sensitive data and apply Art. 11 limits | Sensitive data |
| Privacy by design | Embed privacy controls into system design | Security, prevention |
| Data subject requests | Handle access, correction, deletion, portability and other Art. 18 rights | Rights |
| Security incidents | Assess and notify the ANPD and data subjects as required | Art. 48 |

## Usage Guidelines
- **Record each processing activity** with its purpose and Art. 7 or Art. 11 legal basis.
- **Appoint an encarregado** (data protection officer) where required and publish contact details.
- **Set up a rights-request process** covering the Art. 18 rights.
- **Prepare a data protection impact report (RIPD)** for high-risk processing or when the ANPD requests one.
- **Check current ANPD resolutions** on incident notification, international transfers and small processing agents before relying on any deadline or exemption.

## Prompt Template
```
You are assessing LGPD compliance (Law No. 13,709/2018). Not legal advice.

PROCESSING ACTIVITY and territorial nexus to Brazil: [[...]]
ROLE: controller / processor
PURPOSE and LEGAL BASIS (Art. 7; Art. 11 if sensitive):
PRINCIPLES CHECK (Art. 6): necessity, transparency, security, non-discrimination
RIGHTS (Art. 18): fulfilment process
ENCARREGADO, RIPD, international transfers:
INCIDENT readiness (Art. 48; current ANPD resolution):
```

## Ethical Guidelines
- **This is not legal advice.** Confirm with Brazilian counsel and current ANPD resolutions.
- **Apply least privilege** and never store sensitive data in plaintext or logs.
- **Use legitimate interests only after balancing** them honestly against data subjects' rights.

## Testing Strategy
- Test rights-request handling end to end.
- Incident-notification tabletop exercises against ANPD deadlines.
- Audit legal-basis records for completeness.

## Success Metrics
- Processing activities with a documented legal basis.
- Rights requests completed on time.
- Incidents assessed and notified within required timelines.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `data-architect`
- Outbound to: `legal-compliance-checker` for interpretation; `security-architect` for security measures
- Cross-framework: GDPR, on which much of the LGPD is modelled; DMBOK for data governance; ISO 27001 for security management.

## Related Skills
- `composable-skills/frameworks/gdpr/SKILL.md` — EU counterpart
- `composable-skills/frameworks/dmbok/SKILL.md` — data governance
- `composable-skills/frameworks/iso-27001/SKILL.md` — security management

## Reference Materials
- Brazil. Law No. 13,709 of 14 August 2018 (Lei Geral de Proteção de Dados Pessoais), as amended.
- ANPD. Resolutions and guidance. gov.br/anpd.
- Brazil. Law No. 15,352 of 25 February 2026 (restructures the ANPD as a special-nature autarchy and amends the LGPD).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Revised 2026-10-15: generic template sections replaced with authored content; legal bases completed to the ten in Art. 7._
