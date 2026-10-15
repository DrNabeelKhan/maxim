---
skill_id: hipaa
name: HIPAA
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - hipaa
  - protected health information
  - phi
  - business associate agreement
  - hipaa security rule
collaborates_with:
  - compliance-officer
  - legal-compliance-checker
  - security-architect
  - support-responder
ethics_required: true
priority: high
tags: [security, framework, privacy, hipaa, health, regulation]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# HIPAA

## Purpose
Use HIPAA, the US Health Insurance Portability and Accountability Act of 1996 and its rules, to protect individually identifiable health information. Its administrative simplification rules govern how **covered entities** (health plans, health care clearinghouses and health care providers that conduct standard electronic transactions) and their **business associates** use, disclose and secure **protected health information (PHI)**, and how they respond to breaches. This definition is a working guide, not legal advice.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `hipaa` |
| Category | Privacy and Security — Regulation |
| Version | 2.0.0 |
| Regulations | 45 CFR Parts 160 and 164 |
| Enforcement | US Department of Health and Human Services, Office for Civil Rights (OCR) |
| Key amendment | HITECH Act (2009): extended obligations to business associates and created breach notification |
| Pending changes | HHS proposed significant Security Rule changes in a 2025 rulemaking; check its status |

## The Rules
- **Privacy Rule**: permitted uses and disclosures of PHI; the **minimum necessary** standard; individuals' rights, such as access and amendment; and a notice of privacy practices.
- **Security Rule**: administrative, physical and technical safeguards for electronic PHI (ePHI), starting with a **risk analysis**. Implementation specifications are either required or addressable.
- **Breach Notification Rule**: notify affected individuals without unreasonable delay and no later than 60 days after discovery; notify HHS; and notify the media for breaches affecting more than 500 residents of a state or jurisdiction.
- **Enforcement Rule**: investigations and civil money penalties.

**De-identification** (45 CFR 164.514): either the Safe Harbor method (removing 18 specified identifiers) or Expert Determination.

## Core Principles
- **Know whether you are a covered entity, a business associate, or neither.** Many health apps are not covered by HIPAA, though other laws may apply.
- **Minimum necessary**: use and disclose only what the purpose requires.
- **Risk analysis drives security,** and it must be kept current.
- **Business associate agreements** are required before a business associate handles PHI.
- **Patients have rights**, including timely access to their records.

## Applications & Use Cases
| Use Case | Application | Rule |
|---|---|---|
| Health-tech vendor selling to providers | Sign BAAs and meet the Security Rule | Security, BAAs |
| Cloud hosting of ePHI | BAA with the provider and configured safeguards | Security |
| Security program | Documented risk analysis and risk management plan | Security |
| Analytics on health data | De-identify by Safe Harbor or Expert Determination | Privacy |
| Patient access requests | Provide records within required timelines | Privacy |
| Lost laptop or breach | Breach risk assessment and notifications | Breach Notification |

## Usage Guidelines
- **Determine your HIPAA role** for each product and customer.
- **Perform and document a risk analysis** of ePHI, and update it when systems change.
- **Sign BAAs** with customers and downstream subcontractors as required.
- **Apply minimum necessary** in data flows, access and logging.
- **Prepare breach assessment and notification procedures** with the 60-day outer limit.

## Prompt Template
```
You are assessing HIPAA obligations (45 CFR Parts 160, 164). Not legal advice.

ORGANISATION and HIPAA role (covered entity / business associate / neither): [[...]]
PHI / ePHI flows: sources, systems, recipients
PRIVACY: permitted uses, minimum necessary, patient rights
SECURITY: risk analysis status; administrative · physical · technical safeguards
BAAs: upstream and downstream
BREACH readiness: assessment method, notification timelines
DE-IDENTIFICATION (if used): method
```

## Ethical Guidelines
- **This is not legal advice.** Confirm with qualified counsel and current HHS guidance.
- **Health data is deeply sensitive;** protect it beyond the legal minimum where you can.
- **Do not treat non-HIPAA status as permission;** the FTC and state laws may still apply to health data.

## Testing Strategy
- Annual and change-triggered risk analysis.
- Access log reviews for inappropriate access to records.
- Breach tabletop exercises.

## Success Metrics
- Risk analysis current and risks tracked to treatment.
- BAAs in place for all applicable relationships.
- Patient access requests met on time.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `support-responder`
- Outbound to: `legal-compliance-checker`; `security-architect` for safeguards
- Cross-framework: NIST SP 800-53 and NIST CSF for safeguards; SANS incident response for breach handling; SOC 2 and ISO 27001 for assurance.

## Related Skills
- `composable-skills/frameworks/nist-sp-800-53/SKILL.md` — security controls
- `composable-skills/frameworks/sans-incident-response/SKILL.md` — incident handling
- `composable-skills/frameworks/soc-2/SKILL.md` — assurance reporting
- `composable-skills/frameworks/gdpr/SKILL.md` — EU health data obligations

## Reference Materials
- Health Insurance Portability and Accountability Act of 1996, Public Law 104-191.
- 45 CFR Parts 160 and 164 (Privacy, Security, Breach Notification and Enforcement Rules).
- US Department of Health and Human Services, Office for Civil Rights. *HIPAA guidance.* hhs.gov/hipaa.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
