---
skill_id: iso-27001
name: ISO 27001
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - iso 27001
  - isms
  - information security management system
  - statement of applicability
  - iso certification
collaborates_with:
  - security-auditor
  - compliance-officer
  - security-architect
  - infrastructure-maintainer
ethics_required: true
priority: high
tags: [security, framework, iso, isms, certification, compliance]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# ISO 27001

## Purpose
Use ISO/IEC 27001 to establish, run and continually improve an **information security management system (ISMS)**: a risk-based management system for protecting the confidentiality, integrity and availability of information. Organisations can be certified against it by accredited certification bodies, which makes it a common requirement in customer contracts, especially outside the United States. Its requirements are about managing security systematically; the controls you choose depend on your risks.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `iso-27001` |
| Category | Security — Management System Standard |
| Version | 2.0.0 |
| Current edition | ISO/IEC 27001:2022, with Amendment 1:2024 (climate action changes) |
| Control guidance | ISO/IEC 27002:2022 |
| Certification | Accredited certification bodies; a three-year cycle with surveillance audits |

## Structure
**Clauses 4 to 10 (mandatory requirements)**
- **4 Context**: issues, interested parties, scope.
- **5 Leadership**: commitment, policy, roles.
- **6 Planning**: risk assessment, risk treatment, objectives.
- **7 Support**: resources, competence, awareness, communication, documented information.
- **8 Operation**: carry out risk assessment and treatment.
- **9 Performance evaluation**: monitoring, internal audit, management review.
- **10 Improvement**: nonconformity, corrective action, continual improvement.

**Annex A**: 93 reference controls in four themes: organisational, people, physical and technological.

**Statement of Applicability (SoA)**: lists each Annex A control, whether it applies, why, and its implementation status.

## Core Principles
- **Risk-based.** Controls follow from assessed risks, not from a checklist.
- **Leadership accountability.** Top management must own the ISMS.
- **Plan-do-check-act.** Management review, internal audit and corrective action drive improvement.
- **Documented and evidenced.** Auditors need evidence that the system operates.
- **Scope deliberately.** The certification covers only the defined scope.

## Applications & Use Cases
| Use Case | Application | Element |
|---|---|---|
| Customer security requirements | Certify the ISMS for the relevant scope | Certification |
| Building a security program | Use the clauses as the management framework | Clauses 4-10 |
| Selecting controls | Risk treatment, justified in the SoA | Annex A, SoA |
| Supplier assurance | Request suppliers' certificates and scope | Certification |
| Aligning multiple frameworks | Map SOC 2, NIST CSF and others to Annex A | Annex A |
| Continual improvement | Internal audits and management reviews | Clauses 9-10 |

## Usage Guidelines
- **Define the scope** in terms customers and auditors will understand.
- **Run a documented risk assessment** with consistent criteria.
- **Produce a Statement of Applicability** with justifications for every control.
- **Run internal audits and management reviews** before the certification audit.
- **Track nonconformities to closure** with corrective actions.

## Prompt Template
```
You are implementing an ISO/IEC 27001:2022 ISMS.

SCOPE (organisation, locations, services): [[...]]
CONTEXT: interested parties and their requirements
RISK ASSESSMENT: method, criteria, top risks
RISK TREATMENT: selected Annex A controls (organisational · people · physical · technological)
STATEMENT OF APPLICABILITY: control · applies? · justification · status
AUDIT READINESS: internal audit, management review, open nonconformities
```

## Ethical Guidelines
- **Do not misrepresent certification scope** to customers.
- **Protect personal data** within the ISMS; consider ISO/IEC 27701 for privacy management.

## Testing Strategy
- Internal audits against clauses and selected controls.
- Control testing for effectiveness, not just existence.

## Success Metrics
- Certification achieved and maintained.
- Nonconformities by severity and time to close.
- Risk treatment plan progress.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `security-architect`
- Outbound to: `security-auditor` · `infrastructure-maintainer`
- Cross-framework: SOC 2 for US-style assurance reports; NIST CSF for outcome mapping; COBIT for wider I&T governance; ISO 42001 for AI management systems.

## Related Skills
- `composable-skills/frameworks/soc-2/SKILL.md` — US assurance reporting
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — outcome mapping
- `composable-skills/frameworks/iso-42001/SKILL.md` — AI management system
- `composable-skills/frameworks/cobit/SKILL.md` — I&T governance

## Reference Materials
- ISO/IEC 27001:2022. *Information security, cybersecurity and privacy protection — Information security management systems — Requirements.*
- ISO/IEC 27001:2022/Amd 1:2024. *Climate action changes.*
- ISO/IEC 27002:2022. *Information security controls.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
