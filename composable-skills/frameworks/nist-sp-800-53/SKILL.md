---
skill_id: nist-sp-800-53
name: NIST SP 800-53 (Security and Privacy Controls)
version: 1.0.0
category: security-compliance
type: framework
frameworks: []
triggers:
  - apply nist sp 800-53
  - use nist-sp-800-53 framework
  - nist sp 800-53 analysis
collaborates_with:
  - security-architect
  - compliance-officer
  - security-auditor
  - infrastructure-maintainer
ethics_required: true
priority: medium
tags: [security-compliance, framework]
created: 2026-07-08
updated: 2026-07-08
---

# NIST SP 800-53 (Security and Privacy Controls)

## Purpose
Apply NIST SP 800-53 to select, implement, and assess a comprehensive catalog of security and privacy controls for federal and federal-adjacent systems.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `nist-sp-800-53` |
| Category | Security & Compliance |
| Version | 1.0.0 |
| Owner | NIST (National Institute of Standards and Technology) |
| Maturity | Established (Rev 5, 2020) |
| Primary References | NIST SP 800-53 Rev 5 |

## Prompt Template
```
You are applying the NIST SP 800-53 (Security and Privacy Controls) framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: security & compliance
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Identify**: What aspect of NIST SP 800-53 applies to this situation?
2. **Analyze**: Break down the problem using framework principles:
   - Apply relevant framework principles to the context
3. **Synthesize**: Combine insights into actionable recommendations
4. **Validate**: Check recommendations against framework guidelines

OUTPUT STRUCTURE:
- Framework Application: Which principles were used and why
- Analysis: Step-by-step application to the specific context
- Recommendations: Prioritized actions based on framework guidance
- Limitations: Any constraints or assumptions in the application

QUALITY CHECKS:
□ All recommendations align with NIST SP 800-53 principles
□ Ethical considerations have been evaluated
□ Stakeholder impacts have been considered
□ Next steps are clear and actionable
```

## Core Principles
NIST SP 800-53 organizes controls into families. Selected families include:
- **Access Control (AC)**: Who can access what and how
- **Audit & Accountability (AU)**: Logging and audit trails
- **Configuration Management (CM)**: Secure baseline configurations
- **Incident Response (IR)**: Incident handling procedures
- **Risk Assessment (RA)**: Risk identification and analysis
- **System & Communications Protection (SC)**: Network and boundary controls
- **System & Information Integrity (SI)**: Malware, patching, monitoring

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|----------------|
| Control Selection | Choose control families for a system baseline | Right-sized, defensible control set |
| Federal Compliance | Map controls to FedRAMP and federal requirements | Compliance-ready control mapping |
| Control Assessment | Audit implemented controls against the catalog | Documented assessment evidence |
| Control Implementation | Deploy access, audit, and integrity controls | Hardened, monitored infrastructure |

## Reference Materials
- [NIST SP 800-53 Rev 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) - NIST (National Institute of Standards and Technology)

## Usage Guidelines
- **Start with context**: Clearly define the problem space before applying framework
- **Adapt, don't adopt**: Customize framework application to your specific situation
- **Document decisions**: Record how and why framework principles were applied
- **Review outcomes**: Evaluate results to improve future framework application
- **Share learnings**: Contribute insights back to team knowledge base

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]

## Ethical Guidelines
- ALWAYS apply principle of least privilege
- NEVER store sensitive data in plaintext or logs
- ALWAYS follow responsible disclosure practices

## Success Metrics
- **Clarity**: Framework application produces clearer decision rationale
- **Consistency**: Similar situations receive similar framework-guided analysis
- **Stakeholder Alignment**: Framework language improves cross-functional understanding
- **Outcome Quality**: Decisions show improved consideration of relevant factors
- **Learning**: Framework application generates insights for future improvement

## Related Skills
- *No directly related skills defined*

## Testing Strategy
- Validate that recommendations clearly map back to NIST SP 800-53 principles
- Review one real example and one edge case before adopting the output
- Confirm stakeholder, ethical, and operational constraints were considered
- Document adjustments made when the framework needed adaptation for context

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
