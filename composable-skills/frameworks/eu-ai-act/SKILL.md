---
skill_id: eu-ai-act
name: EU AI Act
version: 1.0.0
category: security-compliance
type: framework
frameworks: []
triggers:
  - apply eu ai act
  - use eu-ai-act framework
  - eu ai act risk classification
  - ai act compliance analysis
collaborates_with:
  - security-analyst
  - compliance-orchestrator
  - enterprise-architect
  - data-architect
  - product-strategist
ethics_required: true
priority: high
tags: [security-compliance, framework]
created: 2026-07-08
updated: 2026-10-15
---

# EU AI Act

## Purpose
Apply the EU AI Act to classify, govern, and document AI systems under the European Union's risk-based regulatory regime — ensuring products meet conformity, transparency, and human-oversight obligations before and after market entry.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `eu-ai-act` |
| Category | Security & Compliance |
| Version | 1.0.0 |
| Owner | European Union |
| Instrument | Regulation (EU) 2024/1689, published 12 July 2024, in force 1 August 2024 |
| Amended by | Regulation (EU) 2026/1744 (Digital Omnibus on AI), published 24 July 2026, in force July 2026 |
| Application | Phased: prohibitions and AI literacy from 2 February 2025; GPAI model obligations from 2 August 2025; Annex III high-risk systems from 2 December 2027 and Annex I (product-embedded) high-risk systems from 2 August 2028, as amended by 2026/1744 |
| Primary References | Risk-based regulation of artificial intelligence systems |

## Risk Classification
| Risk Level | Description | Examples |
|------------|-------------|----------|
| Unacceptable (Art. 5) | Prohibited AI practices | Social scoring; real-time remote biometric identification in publicly accessible spaces for law enforcement (with narrow, authorised exceptions); from the 2026 amendment, non-consensual sexual deepfakes and child sexual abuse material |
| High Risk (Art. 6, Annexes I and III) | Significant conformity requirements | Recruitment AI, credit scoring (Annex III); AI that is a safety component of a product needing third-party conformity assessment, such as some medical devices (Annex I) |
| Limited Risk (Art. 50) | Transparency obligations | Chatbots, deepfakes |
| Minimal Risk | No tier-specific requirements (Art. 4 AI literacy still applies) | Spam filters, AI in games |

**General-purpose AI (GPAI) models** are regulated separately in Chapter V, at the model level, not as a risk tier of AI systems. A high-risk system can be built on a GPAI model.

## Compliance Requirements for High-Risk Systems
| Requirement | Description |
|-------------|-------------|
| Risk Management System (Art. 9) | Identify, analyze, and mitigate risks |
| Data Governance (Art. 10) | Training data quality and relevance |
| Technical Documentation (Art. 11) | Pre-market and ongoing documentation |
| Record-Keeping (Art. 12) | Automatic logging of events |
| Transparency to Deployers (Art. 13) | Instructions for use and information deployers need |
| Human Oversight (Art. 14) | Ensure meaningful human control |
| Accuracy, Robustness & Cybersecurity (Art. 15) | Performance metrics and resilience |
| Quality Management System (Art. 17) | Provider's documented quality system |

Disclosure to people that they are interacting with an AI system is a separate duty under Art. 50, which applies to limited-risk systems.

## Prompt Template
```
You are applying the EU AI Act framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: security & compliance
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Classify**: Which EU AI Act risk level applies (Unacceptable / High / Limited / Minimal)? Separately, is a GPAI model involved (Chapter V)?
2. **Analyze**: Map the system against the compliance requirements for that risk tier:
   - High risk: risk management, data governance, technical documentation, record-keeping, transparency to deployers, human oversight, accuracy & robustness, quality management
   - Limited risk: Art. 50 disclosure duties
3. **Synthesize**: Combine findings into a conformity path and disclosure obligations
4. **Validate**: Check against EU AI Act enforcement timelines and prohibited-practice list

OUTPUT STRUCTURE:
- Framework Application: Risk classification and why
- Analysis: Requirement-by-requirement gap assessment
- Recommendations: Prioritized conformity actions
- Limitations: Assumptions, jurisdictional scope, phased-enforcement caveats

QUALITY CHECKS:
□ Risk classification is defensible and documented
□ Human-oversight and transparency obligations addressed
□ Ethical considerations have been evaluated
□ Next steps map to enforcement timelines
```

## Core Principles
- **Foundation**: The EU AI Act provides a risk-based structure for governing AI systems in the EU market.
- **Application**: Use when scoping, building, or auditing AI products that reach EU users or high-risk domains.
- **Adaptation**: Match obligations to the specific risk tier; do not over- or under-apply controls.
- **Documentation**: Maintain technical documentation and audit trail as first-class conformity evidence.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|------------------|
| AI product compliance | Classify system and map obligations | Clear conformity path per risk tier |
| Regulatory alignment | Cross-check against prohibited practices | Reduced enforcement exposure |
| AI risk architecture | Bake oversight + robustness into design | Governed-by-design AI system |
| Training data governance | Assess data quality and relevance | Defensible data-governance posture |
| Responsible AI product strategy | Align roadmap to transparency duties | Trust-forward product positioning |

## Reference Materials
- Regulation (EU) 2024/1689 (Artificial Intelligence Act). *Official Journal of the European Union*, L, 12 July 2024. https://eur-lex.europa.eu/eli/reg/2024/1689/oj
- Regulation (EU) 2026/1744 of 8 July 2026 (Digital Omnibus on AI), amending Regulation (EU) 2024/1689. *Official Journal*, 24 July 2026. Check the amended Article 113 for each application date.
- artificialintelligenceact.eu — unofficial explorer of the Act's text, maintained by the Future of Life Institute (not an EU site).

## Usage Guidelines
- **Start with classification**: Determine the risk tier before assessing controls.
- **Adapt, don't adopt**: Apply only the obligations the tier actually triggers.
- **Document decisions**: Record classification rationale and requirement mapping.
- **Review outcomes**: Re-assess as obligations phase in (high-risk dates moved to December 2027 and August 2028 by Regulation (EU) 2026/1744), and check for further amendments.
- **Share learnings**: Contribute classification patterns back to team knowledge base.

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework.
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]
- Auto-loop the security-analyst (CSO) on any regulated-AI or PII-adjacent task.

## Ethical Guidelines
- ALWAYS prioritize meaningful human oversight and user autonomy.
- NEVER use for prohibited practices (Art. 5), such as social scoring or unauthorised real-time remote biometric identification.
- ALWAYS disclose clearly when a user is interacting with an AI system.

## Success Metrics
- **Clarity**: Risk classification produces a defensible conformity rationale.
- **Consistency**: Similar systems receive similar tier-based obligations.
- **Stakeholder Alignment**: Framework language improves cross-functional understanding.
- **Outcome Quality**: Decisions show improved consideration of risk, oversight, and transparency.
- **Learning**: Application generates reusable classification insight.

## Related Skills
- `compliance` (Maxim compliance skill layer)
- `security` (Security & Threat Intelligence)

## Testing Strategy
- Validate that recommendations clearly map back to the EU AI Act risk tiers.
- Review one real example and one edge case before adopting the output.
- Confirm stakeholder, ethical, and enforcement-timeline constraints were considered.
- Document adjustments made when the framework needed adaptation for context.

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
