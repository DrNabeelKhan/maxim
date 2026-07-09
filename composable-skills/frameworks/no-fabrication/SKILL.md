---
skill_id: no-fabrication
name: No-Fabrication
version: 1.0.0
category: operational
type: framework
frameworks: []
triggers:
  - apply no-fabrication
  - use no-fabrication framework
  - no fabrication analysis
collaborates_with:
  - confidence-tagger
  - reviewer
  - security-analyst
ethics_required: true
priority: medium
tags: [operational, framework]
created: 2026-07-08
updated: 2026-07-08
---

# No-Fabrication

## Purpose
Every rate or metric carries its sample size / interval; no claim ships without evidence. Reports say "12/30 passing," not "mostly passing," and a loop never reports an `error` or `exhausted` outcome as `success`.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `no-fabrication` |
| Category | Operational |
| Version | 1.0.0 |
| Owner | Epistemic honesty / evidentialism — operationalized as the autonomy-loop honesty rule |
| Maturity | Emerging (2026) — formalizes Maxim's confidence-tagging (ADR-010) into a citable framework |
| Primary References | Evidence-bound reporting; sample-size disclosure; no-claim-without-proof |

## Prompt Template
```
You are applying the No-Fabrication framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: operational
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Bind claims to evidence**: State "12/30 passing", not "mostly passing".
2. **Disclose the sample size**: Any rate states N (and interval where applicable).
3. **No claim without proof**: A loop never reports error/exhausted as success.
4. **Tag confidence**: Attach the ADR-010 confidence signal to the reported claim.

OUTPUT STRUCTURE:
- Claim: The metric or rate being reported
- Evidence: The N (and interval) behind it
- Honesty Check: Confirmation that no failing outcome was reported as success
- Limitations: Any constraints or assumptions in the application

QUALITY CHECKS:
□ Every rate states its sample size (and interval where applicable)
□ No claim ships without supporting evidence
□ No error/exhausted outcome was reported as success
□ Ethical considerations have been evaluated
```

## Core Principles
- **Evidence-bound reporting**: "12/30 passing", not "mostly passing".
- **Sample-size disclosure**: Any rate states N (and interval where applicable).
- **No-claim-without-proof**: A loop never reports `error`/`exhausted` as `success`.
- **Documentation**: Record the evidence and confidence tag behind each claim.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|----------------|
| Confidence rubric (Confidence Tagger) | Confidence rubric (ADR-010) enforcement | Every claim carries a grounded confidence tag |
| Claim review (Reviewer) | Rejects unsupported claims | Unevidenced statements never ship |
| Compliance assertions (Security Analyst) | Evidence-bound compliance assertions | Regulated claims backed by proof |

## Reference Materials
- [inferencegod/autonomy-loop](https://github.com/inferencegod/autonomy-loop) - prior art, per ADR-007

## Usage Guidelines
- **Start with context**: Identify every rate or metric that will appear in the output.
- **Adapt, don't adopt**: Include an interval where the sample size warrants it.
- **Document decisions**: Record the evidence and confidence tag behind each claim.
- **Review outcomes**: Confirm no failing outcome was relabeled as success.
- **Share learnings**: Feed recurring fabrication risks into the confidence rubric.

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]

## Ethical Guidelines
- ALWAYS state the sample size behind a reported rate
- NEVER report an `error` or `exhausted` outcome as `success`
- ALWAYS refuse to ship a claim that has no supporting evidence

## Success Metrics
- **Clarity**: Every rate is reported with its N (and interval where applicable)
- **Consistency**: Similar claims are held to the same evidence bar
- **Stakeholder Alignment**: Evidence-bound vocabulary improves trust in reports
- **Outcome Quality**: No fabricated or inflated claims reach the reader
- **Learning**: Caught fabrication risks strengthen the confidence rubric

## Related Skills
- `orchestrator` — enforces honest terminal reporting in autonomous workflows
- `loops` — the evidence-bound honesty rule for bounded loop outcomes

## Testing Strategy
- Validate that every rate in the output states its sample size
- Review one real example and one edge case (a failing loop must not read as success) before adopting the output
- Confirm each claim maps to supporting evidence
- Document adjustments made when the framework needed adaptation for context

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
