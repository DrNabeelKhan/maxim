---
skill_id: sans-incident-response
name: SANS Incident Response
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - incident response
  - security incident
  - incident response plan
  - containment eradication recovery
  - post-incident review
collaborates_with:
  - incident-responder
  - threat-analyst
  - security-auditor
ethics_required: true
priority: high
tags: [security, framework, incident-response, sans, nist]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# SANS Incident Response

## Purpose
Use the SANS incident response process to handle security incidents in a consistent, prepared way: limit the damage, remove the cause, restore operations and learn from what happened. The SANS model has six steps and is widely taught to incident handlers. It closely parallels the NIST incident response guidance, and organisations often combine the two.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `sans-incident-response` |
| Category | Security — Incident Response |
| Version | 2.0.0 |
| Source | SANS Institute; Kral, *Incident Handler's Handbook* (SANS white paper) |
| Related guidance | NIST SP 800-61 (Rev. 2, 2012, four phases; Rev. 3, 2025, organised around CSF 2.0) |

## The Six Steps (PICERL)
- **Preparation**: plan, team, tools, contacts, playbooks and training.
- **Identification**: detect, confirm and scope the incident; start documentation.
- **Containment**: stop the spread, short-term and then longer-term, preserving evidence.
- **Eradication**: remove the cause, such as malware, compromised accounts or vulnerabilities.
- **Recovery**: restore systems to normal operation and monitor for recurrence.
- **Lessons learned**: review what happened and improve.

NIST SP 800-61 Rev. 2 groups the same work into preparation; detection and analysis; containment, eradication and recovery; and post-incident activity.

## Core Principles
- **Preparation decides the outcome.** Most response quality is set before the incident.
- **Contain before you eradicate,** and preserve evidence while you do.
- **Document everything** as it happens: actions, times, decisions and evidence.
- **Communicate through defined channels**, including legal, leadership and regulators where required.
- **Always run lessons learned**, and act on the findings.

## Applications & Use Cases
| Use Case | Application | Step |
|---|---|---|
| Writing an IR plan | Roles, severity levels, contacts and playbooks | Preparation |
| Ransomware | Isolate affected systems and protect backups | Containment |
| Compromised account | Reset credentials, revoke sessions, check persistence | Eradication |
| Restoring service | Rebuild from known-good images and monitor | Recovery |
| Regulatory breach notification | Assess notification duties, such as GDPR's 72 hours | Identification onward |
| Readiness testing | Tabletop exercises | Preparation |

## Usage Guidelines
- **Write and rehearse playbooks** for likely incident types.
- **Define severity levels and escalation paths** before you need them.
- **Preserve evidence** before making changes to affected systems.
- **Check legal and regulatory notification deadlines** at the start of every incident.
- **Hold a blameless review** within days and track the actions to completion.

## Prompt Template
```
You are handling a security incident (SANS PICERL; NIST SP 800-61).

INCIDENT summary and current step: [[...]]
IDENTIFICATION: scope, affected systems, data, severity
CONTAINMENT: short-term · long-term · evidence preserved
ERADICATION: root cause and removal
RECOVERY: restoration plan and monitoring
NOTIFICATION duties (legal, regulatory, customers) and deadlines:
LESSONS LEARNED: what to change
```

## Ethical Guidelines
- **Be truthful with affected people and regulators** about what happened.
- **Protect the privacy of people whose data is involved,** including during investigation.
- **Do not hack back.** Stay within legal boundaries.

## Testing Strategy
- Tabletop exercises at least annually and after major changes.
- Technical drills for detection and containment.

## Success Metrics
- Time to detect, contain and recover.
- Lessons-learned actions completed.
- Repeat incidents from the same cause.

## Collaboration Protocol
- Inbound from: `incident-responder` · `threat-analyst`
- Outbound to: `security-auditor` for post-incident review; legal and communications as required
- Cross-framework: NIST CSF Respond and Recover; MITRE ATT&CK for describing attacker activity; GDPR and HIPAA for breach notification.

## Related Skills
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — Respond and Recover functions
- `composable-skills/frameworks/mitre-attck/SKILL.md` — describing attacker behaviour
- `composable-skills/frameworks/gdpr/SKILL.md` — breach notification duties
- `composable-skills/frameworks/hipaa/SKILL.md` — health data breach notification

## Reference Materials
- Kral, P. *Incident Handler's Handbook.* SANS Institute white paper (commonly dated 2011; SANS lists it as published 21 February 2012). sans.org/white-papers/33901.
- Cichonski, P., Millar, T., Grance, T., & Scarfone, K. (2012). *Computer Security Incident Handling Guide.* NIST SP 800-61 Rev. 2.
- Nelson, A., Rekhi, S., Souppaya, M., & Scarfone, K. (2025). *Incident Response Recommendations and Considerations for Cybersecurity Risk Management: A CSF 2.0 Community Profile.* NIST SP 800-61 Rev. 3.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
