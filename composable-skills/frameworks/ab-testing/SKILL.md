---
skill_id: ab-testing
name: A/B Testing
version: 2.0.0
category: project-management
type: framework
frameworks: []
triggers:
  - a/b test
  - design an experiment
  - controlled experiment
  - is this result significant
  - sample size
collaborates_with:
  - experiment-tracker
  - data-scientist
  - growth-hacker
  - product-strategist
  - conversion-optimizer
ethics_required: true
priority: high
tags: [project-management, framework, experimentation, statistics, decision-making]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# A/B Testing

## Purpose
Use A/B testing, or online controlled experiments, to learn the causal effect of a change by randomly assigning users to a control and one or more variants and comparing outcomes. Randomisation is what makes the comparison causal rather than correlational. The method is simple to describe and easy to get wrong, so most of the value lies in the discipline around it: a clear hypothesis, an adequate sample, a metric chosen in advance, and checks that the experiment itself is sound.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `ab-testing` |
| Category | Experimentation — Online Controlled Experiments |
| Version | 2.0.0 |
| Primary reference | Kohavi, Tang & Xu, *Trustworthy Online Controlled Experiments* (2020) |
| Earlier survey | Kohavi et al., "Controlled experiments on the web", *Data Mining and Knowledge Discovery* (2009) |

## The Method
1. **Hypothesis**: the change, the expected effect, and why.
2. **Overall Evaluation Criterion (OEC)**: the primary metric the decision rests on, plus guardrail metrics that must not get worse.
3. **Randomisation unit**: usually the user, so each person sees one experience consistently.
4. **Sample size and duration**: set from the minimum effect worth detecting and the desired statistical power, and run for full weekly cycles.
5. **Run, then check validity**, including a sample ratio mismatch check.
6. **Analyse and decide** against the pre-registered criterion.

## Core Principles
- **Decide the metric and sample size before starting.** Choosing them afterwards invites false positives.
- **Do not stop early on a promising result.** Repeatedly checking significance and stopping when it looks good inflates the false-positive rate.
- **Check the experiment before trusting it.** A sample ratio mismatch, where group sizes differ from the planned split, signals a bug.
- **Guardrails protect against wins that do harm,** such as higher conversion with more refunds.
- **Beware novelty effects.** Early lifts can fade as users get used to a change.

## Applications & Use Cases
| Use Case | Application | Watch for |
|---|---|---|
| Copy and design changes | Test variants of a page against the current one | Novelty effects |
| Pricing and packaging | Test plan structure on new visitors | Guardrails such as refunds |
| Onboarding flows | Measure activation for new users | Randomise by user, not session |
| Algorithm changes | Compare ranking or recommendation versions | Network effects between users |
| Feature launches | Roll out behind a flag as an experiment | Long-term retention, not just day one |
| Email and messaging | Test subject lines and timing | Deliverability as a guardrail |

## Usage Guidelines
- **Write the hypothesis, primary metric, guardrails and stopping rule before launch.**
- **Calculate the required sample size** from the minimum detectable effect and power.
- **Run for whole weeks** to cover day-of-week patterns.
- **Check for sample ratio mismatch** before reading any results.
- **Report confidence intervals, not only p-values,** and record inconclusive and negative results too.

## Prompt Template
```
You are designing an online controlled experiment (Kohavi, Tang & Xu 2020).

CHANGE: [[what is different in the variant]]
HYPOTHESIS: [[expected effect and why]]
PRIMARY METRIC (OEC):
GUARDRAIL METRICS:
RANDOMISATION UNIT:
MINIMUM DETECTABLE EFFECT and POWER -> SAMPLE SIZE and DURATION:
STOPPING RULE (decided now, not after looking):
VALIDITY CHECKS: sample ratio mismatch · instrumentation · novelty
```

## Ethical Guidelines
- **Do not test changes that could seriously harm users**, such as withholding safety information.
- **Respect consent and privacy law** in what is collected and how users are assigned.
- **Do not run deceptive variants**, even for learning.

## Testing Strategy
- Run A/A tests periodically to validate the experimentation platform.
- Re-test important wins to confirm they replicate.

## Success Metrics
- Share of experiments with valid design and no sample ratio mismatch.
- Replication rate of declared wins.
- Decisions informed by experiments rather than opinion.

## Collaboration Protocol
- Inbound from: `experiment-tracker` · `growth-hacker` · `conversion-optimizer` · `product-strategist`
- Outbound to: `data-scientist` for power analysis and interpretation
- Cross-framework: Growth hacking supplies the backlog; Lean Startup frames experiments as validated learning.

## Related Skills
- `composable-skills/frameworks/growth-hacking/SKILL.md` — the experiment backlog and cadence
- `composable-skills/frameworks/lean-startup/SKILL.md` — validated learning
- `composable-skills/frameworks/champion-challenger-holdout/SKILL.md` — guarding against metric gaming

## Reference Materials
- Kohavi, R., Tang, D., & Xu, Y. (2020). *Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing.* Cambridge University Press.
- Kohavi, R., Longbotham, R., Sommerfield, D., & Henne, R.M. (2009). "Controlled experiments on the web: survey and practical guide." *Data Mining and Knowledge Discovery*, 18, 140–181.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
