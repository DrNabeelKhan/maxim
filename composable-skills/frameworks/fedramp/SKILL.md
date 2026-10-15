---
skill_id: fedramp
name: FedRAMP
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - fedramp
  - federal cloud authorization
  - fedramp moderate
  - authority to operate
  - sell cloud to us government
collaborates_with:
  - compliance-officer
  - security-auditor
  - infrastructure-maintainer
ethics_required: true
priority: medium
tags: [security, framework, fedramp, government, cloud, authorization]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# FedRAMP

## Purpose
Use FedRAMP, the US Federal Risk and Authorization Management Program, to authorise cloud services for use by federal agencies. FedRAMP standardises security assessment, authorisation and continuous monitoring, so that a service authorised once can be reused by many agencies. Its security requirements are based on NIST SP 800-53, at baselines matched to the sensitivity of the data. Authorisation is a substantial undertaking, and the programme has been changing, so check current requirements before planning.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `fedramp` |
| Category | Security — Government Cloud Authorisation |
| Version | 2.0.0 |
| Owner | US General Services Administration (GSA) FedRAMP Program Management Office |
| Established | 2011; codified by the FedRAMP Authorization Act (2022) |
| Control basis | NIST SP 800-53 Rev. 5 baselines |
| Modernisation | FedRAMP 20x, announced 2025, moving towards automated, faster authorisation; check current requirements |

## Key Elements
**Impact baselines** (based on FIPS 199 categorisation)
- **Low**, including a tailored low-impact SaaS baseline.
- **Moderate**: the most common.
- **High**: for the most sensitive unclassified data.

**Process elements**
- **System Security Plan (SSP)**: describes the system and how each control is implemented.
- **Third-Party Assessment Organisation (3PAO)**: independent assessor that tests controls.
- **Security Assessment Plan and Report (SAP, SAR).**
- **Plan of Action and Milestones (POA&M)**: tracks open weaknesses.
- **Authorisation**: typically sponsored by an agency, resulting in an authority to operate.
- **Continuous monitoring**: regular vulnerability scanning, POA&M updates and annual assessments.
- **FedRAMP Marketplace**: lists authorised and in-process services.

## Core Principles
- **Assess once, reuse many times** across agencies.
- **Controls scale with impact level.**
- **Independent assessment** by accredited 3PAOs.
- **Authorisation is the beginning:** continuous monitoring keeps it valid.
- **Define the authorisation boundary precisely;** everything inside it must meet the baseline.

## Applications & Use Cases
| Use Case | Application | Element |
|---|---|---|
| Selling SaaS to federal agencies | Find an agency sponsor and pursue authorisation | Authorisation |
| Choosing a baseline | Categorise data with FIPS 199 | Baselines |
| Readiness assessment | Gap analysis against the baseline before a 3PAO assessment | 3PAO |
| Building on authorised infrastructure | Inherit controls from an authorised cloud provider | Inheritance |
| Ongoing compliance | Monthly scanning and POA&M management | Continuous monitoring |
| Market research | Check the Marketplace for competitors' status | Marketplace |

## Usage Guidelines
- **Confirm demand and a sponsor** before committing to authorisation.
- **Categorise the system** and pick the baseline.
- **Build on authorised infrastructure** to inherit controls where possible.
- **Write the SSP early** and test readiness before engaging a 3PAO.
- **Plan resources for continuous monitoring,** not just initial authorisation.

## Prompt Template
```
You are planning FedRAMP authorisation (NIST SP 800-53 Rev. 5 baselines). Check current FedRAMP requirements.

SERVICE and federal use case: [[...]]
DATA CATEGORISATION (FIPS 199) → baseline: Low / Moderate / High
AUTHORISATION BOUNDARY:
INHERITED CONTROLS from underlying providers:
GAPS against the baseline:
PATH: agency sponsor · 3PAO · timeline
CONTINUOUS MONITORING plan:
```

## Ethical Guidelines
- **Represent authorisation status accurately;** "in process" is not "authorised."
- **Government data serves the public;** protect it to the standard required, not the minimum you can argue for.

## Testing Strategy
- Readiness assessment against the baseline.
- Monthly vulnerability scanning per continuous monitoring requirements.

## Success Metrics
- Authorisation achieved and maintained.
- Open POA&M items and their age.
- Agencies reusing the authorisation.

## Collaboration Protocol
- Inbound from: `compliance-officer` · `infrastructure-maintainer`
- Outbound to: `security-auditor`
- Cross-framework: NIST SP 800-53 for controls; FEAF for federal architecture context; zero trust for federal security strategy.

## Related Skills
- `composable-skills/frameworks/nist-sp-800-53/SKILL.md` — the control baselines
- `composable-skills/frameworks/feaf/SKILL.md` — federal enterprise architecture
- `composable-skills/frameworks/zero-trust-architecture/SKILL.md` — federal zero trust strategy

## Reference Materials
- US General Services Administration. *FedRAMP.* fedramp.gov.
- FedRAMP Authorization Act, part of the James M. Inhofe National Defense Authorization Act for Fiscal Year 2023.
- NIST. (2020). SP 800-53 Rev. 5, *Security and Privacy Controls for Information Systems and Organizations.*
- NIST. (2004). FIPS 199, *Standards for Security Categorization of Federal Information and Information Systems.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
