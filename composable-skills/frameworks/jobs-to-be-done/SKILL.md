---
skill_id: jobs-to-be-done
name: Jobs-to-be-Done
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply jobs-to-be-done
  - use jobs-to-be-done framework
  - jobs-to-be-done analysis
collaborates_with:
  - product-strategist
  - user-researcher
  - behavioral-designer
  - market-analyst
  - innovation-researcher
ethics_required: true
priority: medium
tags: [behavior-science, framework]
created: 2026-03-14
updated: 2026-03-14
---

# Jobs-to-be-Done

## Purpose
Apply Jobs-to-be-Done to understand and influence human behavior in product design, marketing, and user experience.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `jobs-to-be-done` |
| Category | Behavior Science |
| Version | 1.0.0 |
| Owner | Clayton Christensen |
| Maturity | Established (2000s) |
| Primary References | JTBD Framework |

## Prompt Template
```
You are applying the Jobs-to-be-Done framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: behavior science
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Identify**: What aspect of Jobs-to-be-Done applies to this situation?
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
□ All recommendations align with Jobs-to-be-Done principles
□ Ethical considerations have been evaluated
□ Stakeholder impacts have been considered
□ Next steps are clear and actionable
```

## Core Principles
- **Foundation**: Jobs-to-be-Done provides structured approach to behavior science
- **Application**: Use when facing decisions requiring behavior science guidance
- **Adaptation**: Customize application to specific context while maintaining core integrity
- **Documentation**: Record how framework was applied and outcomes achieved

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|----------------|
| Strategic Planning | Apply Jobs-to-be-Done to structure analysis | Clearer priorities and rationale |
| Problem Solving | Use framework to break down complex issues | Systematic approach to solutions |
| Team Alignment | Share framework language with stakeholders | Common understanding and vocabulary |
| Documentation | Record framework application in decisions | Audit trail and knowledge transfer |

## Reference Materials
- [JTBD Framework](https://www.jobs-to-be-done.com/) - Clayton Christensen

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
- ALWAYS prioritize user autonomy and informed consent
- NEVER use for manipulative or coercive purposes
- ALWAYS provide clear opt-out mechanisms

## Success Metrics
- **Clarity**: Framework application produces clearer decision rationale
- **Consistency**: Similar situations receive similar framework-guided analysis
- **Stakeholder Alignment**: Framework language improves cross-functional understanding
- **Outcome Quality**: Decisions show improved consideration of relevant factors
- **Learning**: Framework application generates insights for future improvement

## Related Skills
- *No directly related skills defined*

## Testing Strategy
- Validate that recommendations clearly map back to Jobs-to-be-Done principles
- Review one real example and one edge case before adopting the output
- Confirm stakeholder, ethical, and operational constraints were considered
- Document adjustments made when the framework needed adaptation for context

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
