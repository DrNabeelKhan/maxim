---
skill_id: independent-verification
name: Independent Verification
version: 1.0.0
category: operational
type: framework
frameworks: []
triggers:
  - apply independent verification
  - use independent-verification framework
  - independent verification analysis
collaborates_with:
  - reviewer
  - tester
  - security-analyst
  - pre-release-audit
ethics_required: true
priority: medium
tags: [operational, framework]
created: 2026-07-08
updated: 2026-07-08
---

# Independent Verification

## Purpose
The agent that produces work is never the agent that approves it. Generation and approval are separate passes so that output is checked against the original requirement — not against the producer's own claim that it is done.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `independent-verification` |
| Category | Operational |
| Version | 1.0.0 |
| Owner | Separation of Duties / Four-Eyes Principle (internal controls — COSO/ISACA) |
| Maturity | Established (governance) — applied to agent output in Maxim v1.3.3 |
| Primary References | Generation–approval separation; fail-closed verification gate |

## Prompt Template
```
You are applying the Independent Verification framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: operational
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Split generation from approval**: The producer and the verifier are distinct agents or passes.
2. **Verify against the requirement**: The independent reviewer re-checks against the requirement, not the producer's claim.
3. **Fail closed**: If no verifier is present and there is no explicit opt-in, refuse to mark the work done.
4. **Record the verdict**: Capture what was checked and the independent result.

OUTPUT STRUCTURE:
- Separation: Who produced vs. who verified
- Verification: What was checked against the requirement
- Gate Decision: Approved, rejected, or refused (fail-closed)
- Limitations: Any constraints or assumptions in the application

QUALITY CHECKS:
□ Producer and verifier are distinct
□ Verification was against the requirement, not the producer's claim
□ Absent a verifier and opt-in, the work was NOT marked done
□ Ethical considerations have been evaluated
```

## Core Principles
- **Generation/approval split**: Producer and verifier are distinct agents or passes.
- **Independent reviewer**: Re-checks against the requirement, not the producer's claim.
- **Fail-closed gate**: No verifier present and no opt-in → refuse to mark done.
- **Documentation**: Record the independent verdict and what it was measured against.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|----------------|
| Independent review (Reviewer) | Independent verification pass | Output checked against the requirement |
| Proof-of-test (Tester) | Proof-of-test re-validation | Tests independently re-run, not trusted on claim |
| Regulated output (Security Analyst) | CSO independent check on regulated output | Compliance verified by a separate agent |
| Pre-tag audit (Pre-Release Audit) | Adversarial pre-tag verification | Release blocked until independently cleared |

## Reference Materials
- [COSO Internal Control Framework](https://www.coso.org/) - Separation of Duties / Four-Eyes Principle
- [ISACA](https://www.isaca.org/) - internal controls guidance

## Usage Guidelines
- **Start with context**: Identify the requirement the work will be verified against before generation.
- **Adapt, don't adopt**: Choose the verifier appropriate to the risk (reviewer, tester, CSO, pre-release audit).
- **Document decisions**: Record the independent verdict separately from the producer's output.
- **Review outcomes**: Confirm the verifier measured against the requirement, not the producer's claim.
- **Share learnings**: Feed recurring verification misses back into the review checklist.

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]

## Ethical Guidelines
- ALWAYS keep the producer and the approver distinct
- NEVER let an agent self-certify regulated or high-risk output
- ALWAYS fail closed when no independent verifier is available

## Success Metrics
- **Clarity**: The requirement being verified against is explicit
- **Consistency**: Similar output types get the same class of independent check
- **Stakeholder Alignment**: Four-eyes vocabulary improves cross-functional trust
- **Outcome Quality**: Fewer producer-self-certified defects reach release
- **Learning**: Verification misses generate stronger checklists

## Related Skills
- `orchestrator` — enforces a separate verification gate in autonomous workflows
- `testing` — proof-of-test re-validation as an independent pass

## Testing Strategy
- Validate that the verifier was a distinct agent/pass from the producer
- Review one real example and one edge case (no verifier available → fail closed) before adopting the output
- Confirm the verdict was measured against the requirement
- Document adjustments made when the framework needed adaptation for context

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
