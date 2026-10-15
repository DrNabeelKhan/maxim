---
skill_id: dmbok
name: DMBOK
version: 2.0.0
category: enterprise-architecture
type: framework
frameworks: []
triggers:
  - dmbok
  - data governance
  - data management
  - master data
  - data quality program
collaborates_with:
  - data-architect
  - enterprise-architect
  - governance-specialist
  - data-scientist
ethics_required: true
priority: high
tags: [enterprise-architecture, framework, dmbok, data-governance, data-management, dama]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# DMBOK

## Purpose
Use the DAMA Data Management Body of Knowledge (DAMA-DMBOK) to plan and run data management as a discipline: defining who decides about data, how it is modelled, stored, secured, integrated and described, and how its quality is assured. Its best-known image is the **DAMA wheel**: eleven knowledge areas with **data governance** at the centre, because governance coordinates all the others.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `dmbok` |
| Category | Enterprise Architecture — Data Management |
| Version | 2.0.0 |
| Owner | DAMA International |
| Edition | *DAMA-DMBOK: Data Management Body of Knowledge*, 2nd edition (2017); check for later revisions |

## The Eleven Knowledge Areas
- **Data governance** (at the centre): authority, decision rights and oversight for data.
- **Data architecture.**
- **Data modelling and design.**
- **Data storage and operations.**
- **Data security.**
- **Data integration and interoperability.**
- **Document and content management.**
- **Reference and master data.**
- **Data warehousing and business intelligence.**
- **Metadata management.**
- **Data quality.**

## Core Principles
- **Data is an asset** and should be managed with the same discipline as other assets.
- **Governance sits at the centre**, coordinating decision rights across all knowledge areas.
- **Accountability belongs to the business.** Data owners and stewards come from the business, supported by IT.
- **Quality is managed, not assumed.** Define quality requirements and measure them.
- **Metadata makes data usable**: without it, data cannot be found, understood or trusted.

## Applications & Use Cases
| Use Case | Application | Knowledge Area |
|---|---|---|
| Starting a data governance programme | Define owners, stewards, councils and policies | Data governance |
| Conflicting customer records | Establish a master data hub and matching rules | Reference and master data |
| Untrusted reports | Measure and remediate data quality | Data quality |
| Finding and understanding data | Build a data catalogue | Metadata |
| Privacy and regulatory obligations | Classify data and apply protections | Data security |
| Analytics platform | Design warehouse, lake or lakehouse | Warehousing and BI |

## Usage Guidelines
- **Assess maturity across the knowledge areas** and prioritise by business pain.
- **Appoint data owners and stewards** from the business, with defined decision rights.
- **Write data policies and standards** and enforce them through governance.
- **Define critical data elements** and measure their quality.
- **Maintain a business glossary and data catalogue.**

## Prompt Template
```
You are designing a data management programme (DAMA-DMBOK, 2nd ed.).

BUSINESS PROBLEM: [[...]]
GOVERNANCE: owners · stewards · council · decision rights · policies
PRIORITY KNOWLEDGE AREAS (current maturity → target):
CRITICAL DATA ELEMENTS and quality rules:
METADATA: glossary · catalogue · lineage
SECURITY AND PRIVACY: classification and controls
ROADMAP:
```

## Ethical Guidelines
- **Data ethics is part of governance:** consider fairness, consent and the people the data describes.
- **Classify and protect personal data** in line with GDPR, CCPA and other applicable law.
- **Do not repurpose data** beyond the purposes for which it was collected without a lawful basis.

## Testing Strategy
- Automated data quality checks on critical data elements.
- Periodic access reviews for sensitive data.

## Success Metrics
- Critical data elements meeting quality targets.
- Share of data assets with an owner and catalogue entry.
- Time for analysts to find and trust data.

## Collaboration Protocol
- Inbound from: `data-architect` · `governance-specialist` · `data-scientist`
- Outbound to: `enterprise-architect` for architecture alignment; CSO office for data security and privacy
- Cross-framework: GDPR and CCPA for privacy obligations; Zachman's What column for data models; COBIT for wider I&T governance.

## Related Skills
- `composable-skills/frameworks/gdpr/SKILL.md` — personal data obligations
- `composable-skills/frameworks/ccpa/SKILL.md` — California privacy rights
- `composable-skills/frameworks/cobit/SKILL.md` — I&T governance
- `composable-skills/frameworks/zachman-framework/SKILL.md` — classifying data models

## Reference Materials
- DAMA International. (2017). *DAMA-DMBOK: Data Management Body of Knowledge* (2nd ed.). Technics Publications.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
