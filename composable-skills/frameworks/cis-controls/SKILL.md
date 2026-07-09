---
skill_id: cis-controls
name: CIS Controls (Center for Internet Security)
version: 1.0.0
category: security-compliance
type: framework
frameworks: []
triggers:
  - apply cis controls
  - use cis-controls framework
  - cis safeguard assessment
  - security baseline hardening
collaborates_with:
  - security-analyst
  - security-auditor
  - infrastructure-maintainer
  - compliance-orchestrator
  - enterprise-architect
ethics_required: true
priority: high
tags: [security-compliance, framework]
created: 2026-07-08
updated: 2026-07-08
---

# CIS Controls (Center for Internet Security)

## Purpose
Apply the CIS Controls to prioritize and implement a defensible set of cyber-defense actions — using Implementation Groups to scale safeguards to an organization's size and risk, starting from the highest-leverage controls.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `cis-controls` |
| Category | Security & Compliance |
| Version | 1.0.0 |
| Owner | Center for Internet Security (CIS) |
| Maturity | Established (v8, 2021) |
| Primary References | Prioritized set of actions to protect against cyber threats |

## Implementation Groups
| Group | Target Organization | Control Count |
|-------|---------------------|---------------|
| IG1 | Small/low-risk | 56 safeguards |
| IG2 | Mid-size organizations | 130 safeguards |
| IG3 | Large/high-risk | All 153 safeguards |

## Top 5 CIS Controls
| Control | Name | Description |
|---------|------|-------------|
| 1 | Inventory of Enterprise Assets | Know all hardware in your environment |
| 2 | Inventory of Software Assets | Know all software running |
| 3 | Data Protection | Classify, handle, and retain data |
| 4 | Secure Configuration | Establish and maintain secure configurations |
| 5 | Account Management | Manage the lifecycle of all accounts |

## Prompt Template
```
You are applying the CIS Controls framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: security & compliance
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Identify**: Which Implementation Group (IG1 / IG2 / IG3) fits the organization?
2. **Analyze**: Assess against the prioritized controls, starting with Controls 1–5:
   - Asset inventory, software inventory, data protection, secure configuration, account management
3. **Synthesize**: Combine findings into a prioritized safeguard roadmap
4. **Validate**: Check coverage against the target IG safeguard count

OUTPUT STRUCTURE:
- Framework Application: IG selection and control priority
- Analysis: Control-by-control gap assessment
- Recommendations: Prioritized safeguard actions
- Limitations: Assumptions and scope boundaries

QUALITY CHECKS:
□ Implementation Group selection is justified
□ Top-priority controls (1–5) are assessed first
□ Ethical considerations have been evaluated
□ Roadmap maps to the target safeguard count
```

## Core Principles
- **Foundation**: The CIS Controls provide a prioritized, tiered set of cyber-defense safeguards.
- **Application**: Use when hardening an environment or building a security roadmap under resource constraints.
- **Adaptation**: Select the Implementation Group that matches the organization's size and risk.
- **Documentation**: Maintain asset inventories and configuration baselines as living evidence.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|------------------|
| Control implementation | Deploy safeguards by IG tier | Prioritized, achievable hardening |
| Baseline assessment | Measure against Controls 1–5 first | Clear security gap picture |
| Configuration hardening | Establish secure configurations | Reduced attack surface |
| Compliance roadmap | Sequence safeguards to a target IG | Defensible improvement plan |

## Reference Materials
- [CIS Controls v8](https://www.cisecurity.org/controls) — Center for Internet Security (CIS)

## Usage Guidelines
- **Start with the IG**: Pick the Implementation Group before assessing safeguards.
- **Adapt, don't adopt**: Do not chase IG3 safeguards a small org cannot sustain.
- **Document decisions**: Record inventories, baselines, and control-coverage state.
- **Review outcomes**: Re-assess as the environment and threat landscape evolve.
- **Share learnings**: Feed safeguard results back into the roadmap.

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework.
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]
- Auto-loop the security-analyst (CSO) on any hardening or safeguard-assessment task.

## Ethical Guidelines
- ALWAYS prioritize proportionate, sustainable defensive controls.
- NEVER use control tooling for unauthorized surveillance or access.
- ALWAYS protect and classify data per the Data Protection control.

## Success Metrics
- **Clarity**: IG selection and control priority produce a defensible rationale.
- **Consistency**: Similar environments receive similar safeguard treatment.
- **Stakeholder Alignment**: Framework language improves cross-functional understanding.
- **Outcome Quality**: Decisions show measurable reduction in attack surface.
- **Learning**: Assessments generate reusable hardening insight.

## Related Skills
- `security` (Security & Threat Intelligence)
- `compliance` (Maxim compliance skill layer)

## Testing Strategy
- Validate that recommendations clearly map back to the CIS Controls and IG tiers.
- Review one real example and one edge case before adopting the output.
- Confirm stakeholder, ethical, and resource-constraint factors were considered.
- Document adjustments made when the framework needed adaptation for context.

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
