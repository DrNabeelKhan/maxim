---
skill_id: ccpa
name: CCPA
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - ccpa
  - cpra
  - california privacy
  - do not sell or share
  - consumer privacy rights
collaborates_with:
  - compliance-officer
  - legal-compliance-checker
  - support-responder
ethics_required: true
priority: high
tags: [security, framework, privacy, ccpa, cpra, california, regulation]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# CCPA

## Purpose
Use the California Consumer Privacy Act (CCPA), as amended by the California Privacy Rights Act (CPRA), to meet California's privacy obligations: tell consumers what personal information you collect and why, honour their rights to know, delete, correct and opt out of sale or sharing, and limit use of sensitive personal information. It applies to for-profit businesses that do business in California and meet a size or data threshold. This definition is a working guide, not legal advice.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `ccpa` |
| Category | Privacy — Regulation |
| Version | 2.0.0 |
| Law | California Civil Code §1798.100 et seq.; CCPA effective 2020, amended by the CPRA (Proposition 24, approved November 2020), operative 1 January 2023 |
| Enforcement | California Privacy Protection Agency and the California Attorney General |
| Regulations | Agency regulations, updated over time, including on risk assessments, cybersecurity audits and automated decision-making technology; check the current text |

## Key Requirements
**Who it applies to**: for-profit businesses doing business in California that meet at least one threshold: annual gross revenue above a set amount (originally $25 million, now adjusted for inflation); buying, selling or sharing the personal information of 100,000 or more consumers or households; or earning at least half of annual revenue from selling or sharing personal information.

**Consumer rights**
- **Right to know and access** what is collected, used and disclosed.
- **Right to delete.**
- **Right to correct** inaccurate information.
- **Right to opt out of sale or sharing**, including sharing for cross-context behavioural advertising.
- **Right to limit use of sensitive personal information.**
- **Right to non-discrimination** for exercising rights.

**Business obligations**: a notice at collection; a privacy policy; a "Do Not Sell or Share My Personal Information" link where applicable; honouring opt-out preference signals such as Global Privacy Control; contracts with service providers, contractors and third parties; and reasonable security.

## Core Principles
- **Notice at or before collection,** stating categories, purposes and retention.
- **Purpose limitation**: use must be reasonably necessary and proportionate to the disclosed purposes.
- **Make opting out easy,** including honouring browser privacy signals.
- **Contracts flow obligations** to service providers and third parties.
- **Security is a duty;** breaches of certain data can lead to private lawsuits.

## Applications & Use Cases
| Use Case | Application | Requirement |
|---|---|---|
| Applicability check | Test against the thresholds | Scope |
| Advertising and tracking | Treat cross-context behavioural advertising as sharing; honour opt-outs | Opt-out |
| Consumer requests | Verify identity and respond within the statutory timeline | Rights |
| Sensitive data | Offer the right to limit, or restrict use to permitted purposes | Sensitive PI |
| Vendor management | Contracts with required terms | Contracts |
| Privacy policy update | Annual review of disclosures | Notice |

## Usage Guidelines
- **Confirm applicability** and identify all personal information you collect, including from cookies and pixels.
- **Map sales and sharing**, especially advertising technology.
- **Provide opt-out mechanisms** and honour Global Privacy Control signals.
- **Build a verified request process** that meets statutory timelines.
- **Check the current regulations** before relying on any requirement, as they change.

## Prompt Template
```
You are assessing CCPA/CPRA compliance. Not legal advice.

BUSINESS and applicability thresholds: [[...]]
PERSONAL INFORMATION: categories, sources, purposes, retention
SENSITIVE PI: categories and uses
SALE / SHARING: recipients, opt-out mechanism, GPC handling
RIGHTS PROCESS: know · delete · correct · opt out · limit; verification; timelines
CONTRACTS: service providers, contractors, third parties
NOTICES: at collection; privacy policy
```

## Ethical Guidelines
- **This is not legal advice.** Confirm with qualified counsel and the current regulations.
- **Do not use dark patterns.** California's rules state that consent obtained through dark patterns is not valid consent.
- **Do not penalise consumers** for exercising their rights.

## Testing Strategy
- Test opt-out flows, including with Global Privacy Control enabled.
- Audit tags and pixels for undisclosed sharing.
- Test request handling against timelines.

## Success Metrics
- Requests completed on time.
- Opt-out signals honoured across properties.
- Vendors under compliant contracts.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `support-responder`
- Outbound to: `legal-compliance-checker` for interpretation
- Cross-framework: GDPR for EU obligations; DMBOK for data inventory; HIPAA where health data is excluded or overlaps.

## Related Skills
- `composable-skills/frameworks/gdpr/SKILL.md` — EU data protection
- `composable-skills/frameworks/dmbok/SKILL.md` — data inventory and governance
- `composable-skills/frameworks/hipaa/SKILL.md` — US health information

## Reference Materials
- California Consumer Privacy Act of 2018, Cal. Civ. Code §1798.100 et seq., as amended by the California Privacy Rights Act of 2020.
- California Code of Regulations, Title 11, Division 6 (CCPA regulations).
- California Privacy Protection Agency. cppa.ca.gov.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
