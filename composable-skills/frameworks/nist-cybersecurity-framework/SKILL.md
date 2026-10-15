---
skill_id: nist-cybersecurity-framework
name: NIST Cybersecurity Framework
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - nist csf
  - nist cybersecurity framework
  - cybersecurity program
  - current and target profile
  - govern identify protect detect respond recover
collaborates_with:
  - incident-responder
  - security-architect
  - threat-analyst
  - security-auditor
  - infrastructure-maintainer
ethics_required: true
priority: high
tags: [security, framework, nist, csf, risk-management, governance]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# NIST Cybersecurity Framework

## Purpose
Use the NIST Cybersecurity Framework (CSF) to understand, assess, prioritise and communicate cybersecurity risk across an organisation. It describes **outcomes**, not specific controls, so it works for organisations of any size and sector and can be mapped to more detailed control sets such as NIST SP 800-53, ISO/IEC 27001 or the CIS Controls. Version 2.0 added a **Govern** function and broadened the audience beyond critical infrastructure to all organisations.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `nist-cybersecurity-framework` |
| Category | Security — Risk Management Framework |
| Version | 2.0.0 |
| Owner | US National Institute of Standards and Technology (NIST) |
| Current version | CSF 2.0 (February 2024); earlier versions 1.0 (2014) and 1.1 (2018) |
| Supporting resources | Implementation examples · quick-start guides · informative references to other standards |

## Structure
**The CSF Core: six functions**
- **Govern**: strategy, expectations, policy, roles and supply-chain risk management.
- **Identify**: understand assets, risks and improvement opportunities.
- **Protect**: safeguards to manage risk.
- **Detect**: find and analyse possible attacks and compromises.
- **Respond**: act on detected incidents.
- **Recover**: restore assets and operations.

Each function divides into **categories** and **subcategories** (specific outcomes).

**Organisational profiles**: a **current profile** (outcomes achieved now) and a **target profile** (outcomes sought); the gap drives an action plan.

**Tiers**: Partial, Risk Informed, Repeatable and Adaptive, describing how rigorous cybersecurity risk governance and management practices are.

## Core Principles
- **Outcomes, not prescriptions.** The CSF says what to achieve; you choose controls to achieve it.
- **Governance anchors everything.** Cybersecurity risk is an enterprise risk with leadership accountability.
- **Profiles make gaps visible** and turn them into a prioritised plan.
- **A common language** for executives, technical staff and partners.
- **Continuous improvement**, revisiting profiles as threats and business change.

## Applications & Use Cases
| Use Case | Application | Element |
|---|---|---|
| Building a security program | Current and target profiles, then a roadmap | Profiles |
| Board reporting | Report risk and progress by function | Functions |
| Mapping controls | Link CSF outcomes to SP 800-53, ISO 27001 or CIS Controls | Informative references |
| Supply-chain risk | Set expectations for suppliers | Govern |
| Incident readiness | Assess Respond and Recover outcomes | Respond, Recover |
| Small organisations | Use the quick-start guides | All |

## Usage Guidelines
- **Define scope and the business context** before assessing.
- **Create a current profile** honestly, with evidence.
- **Set a target profile** based on risk appetite, threats and obligations.
- **Prioritise the gaps** into an action plan with owners and dates.
- **Map outcomes to a detailed control set** for implementation and audit.

## Prompt Template
```
You are assessing against the NIST Cybersecurity Framework 2.0.

SCOPE and business context: [[...]]
FOR EACH FUNCTION (govern · identify · protect · detect · respond · recover)
  current outcomes · target outcomes · gap · priority
TIER (current / target):
ACTION PLAN: owner, date, mapped controls (SP 800-53 / ISO 27001 / CIS)
```

## Ethical Guidelines
- **Report the current profile honestly,** including weaknesses, to those accountable.
- **Consider privacy alongside security;** NIST's Privacy Framework is designed to work with the CSF.

## Testing Strategy
- Evidence-based assessment of each claimed outcome.
- Incident and recovery exercises for Respond and Recover.

## Success Metrics
- Gap between current and target profile over time.
- Action-plan items completed on schedule.
- Incident detection and recovery times.

## Collaboration Protocol
- Inbound from: `security-architect` · `security-auditor` · `threat-analyst`
- Outbound to: `incident-responder` · `infrastructure-maintainer`
- Cross-framework: NIST SP 800-53 and CIS Controls for controls; ISO 27001 for a certifiable management system; MITRE ATT&CK for detection priorities.

## Related Skills
- `composable-skills/frameworks/nist-sp-800-53/SKILL.md` — detailed controls
- `composable-skills/frameworks/cis-controls/SKILL.md` — prioritised safeguards
- `composable-skills/frameworks/iso-27001/SKILL.md` — certifiable management system
- `composable-skills/frameworks/mitre-attck/SKILL.md` — adversary techniques

## Reference Materials
- NIST. (2024). *The NIST Cybersecurity Framework (CSF) 2.0.* NIST CSWP 29.
- NIST. (2018). *Framework for Improving Critical Infrastructure Cybersecurity, Version 1.1.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
