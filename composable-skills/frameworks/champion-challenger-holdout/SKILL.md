---
skill_id: champion-challenger-holdout
name: Champion–Challenger with Holdout
version: 1.0.0
category: operational
type: framework
frameworks: []
triggers:
  - apply champion-challenger with holdout
  - use champion-challenger-holdout framework
  - champion challenger holdout analysis
collaborates_with:
  - experiment-tracker
  - data-scientist
  - product-strategist
  - confidence-tagger
ethics_required: true
priority: medium
tags: [operational, framework]
created: 2026-07-08
updated: 2026-07-08
---

# Champion–Challenger with Holdout

## Purpose
Promote a change only if it beats the incumbent on a *frozen holdout* without weakening a must-pass check. The champion stays in place until a challenger provably wins, which makes the process resistant to Goodhart's Law — optimizing a proxy metric until it stops meaning anything.

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `champion-challenger-holdout` |
| Category | Operational |
| Version | 1.0.0 |
| Owner | Goodhart's Law (Charles Goodhart) + holdout validation (statistical learning) |
| Maturity | Established (ML/eval) — applied to prompt/policy/framework changes in Maxim v1.3.3 |
| Primary References | Frozen holdout; must-pass gates; uncertainty-favors-incumbent |

## Prompt Template
```
You are applying the Champion–Challenger with Holdout framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: operational
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Name the champion**: Identify the incumbent that stays until provably beaten.
2. **Freeze a holdout**: Reserve an untouched evaluation set, separate from the working set.
3. **Score the challenger**: Compare it to the champion on the frozen holdout.
4. **Check must-pass gates**: Block promotion if any guardrail check regresses.
5. **Resolve uncertainty**: When the result is ambiguous, keep the champion.

OUTPUT STRUCTURE:
- Champion vs Challenger: What is being compared
- Holdout Result: Performance on the frozen evaluation set
- Gate Status: Whether any must-pass guardrail regressed
- Decision: Promote or keep champion (uncertainty → incumbent)
- Limitations: Any constraints or assumptions in the application

QUALITY CHECKS:
□ The holdout was frozen and separate from the working set
□ No must-pass gate regressed under the challenger
□ Ambiguous results kept the champion
□ Ethical considerations have been evaluated
```

## Core Principles
- **Champion vs challenger**: The incumbent is kept until a challenger provably wins.
- **Frozen holdout**: An untouched evaluation set, separate from the working set.
- **Must-pass gates**: Promotion is blocked if any guardrail check regresses.
- **Uncertainty → incumbent**: Keep the champion when the result is ambiguous.
- **Documentation**: Record the holdout evidence behind any promotion.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|----------------|
| Experiment tracking (Experiment Tracker) | Versioned champion/challenger experiments | Auditable promotion history |
| Holdout design (Data Scientist) | Holdout design + significance | Statistically sound comparison |
| Policy promotion (Product Strategist) | Policy promotion decisions | Changes ship only when they beat incumbent |
| Promotion confidence (Confidence Tagger) | Promotion confidence on holdout evidence | Confidence tag grounded in holdout result |

## Reference Materials
- [Goodhart's Law](https://en.wikipedia.org/wiki/Goodhart%27s_law) - Charles Goodhart
- Holdout / cross-validation literature - statistical learning

## Usage Guidelines
- **Start with context**: Define the incumbent and the metric before proposing a challenger.
- **Adapt, don't adopt**: Size the holdout and significance bar to the decision's stakes.
- **Document decisions**: Record the holdout result and gate status behind every promotion.
- **Review outcomes**: Confirm no must-pass guardrail regressed before promoting.
- **Share learnings**: Feed Goodhart failure modes back into gate design.

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]

## Ethical Guidelines
- ALWAYS keep the holdout frozen and untouched by the working process
- NEVER promote a challenger that regresses a must-pass guardrail
- ALWAYS default to the incumbent when the evidence is ambiguous

## Success Metrics
- **Clarity**: The champion, challenger, holdout, and must-pass gates are explicit
- **Consistency**: Similar changes are evaluated on comparable holdouts
- **Stakeholder Alignment**: Champion/challenger vocabulary improves promotion discipline
- **Outcome Quality**: Fewer Goodhart-style regressions ship
- **Learning**: Failed challengers sharpen future gate design

## Related Skills
- `orchestrator` — promotes workflow/policy changes through holdout evidence
- `testing` — supplies the frozen evaluation sets

## Testing Strategy
- Validate that the holdout was frozen and separate from the working set
- Review one real example and one edge case (ambiguous result → keep champion) before adopting the output
- Confirm no must-pass gate regressed under the challenger
- Document adjustments made when the framework needed adaptation for context

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
