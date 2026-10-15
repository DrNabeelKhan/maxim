---
skill_id: growth-hacking
name: Growth Hacking
version: 2.0.0
category: content-marketing
type: framework
frameworks: []
triggers:
  - growth hacking
  - growth experiments
  - aarrr pirate metrics
  - north star metric
  - ice scoring
  - product-market fit test
collaborates_with:
  - growth-hacker
  - marketing-team
  - product-strategist
  - analytics-reporter
ethics_required: true
priority: high
tags: [content-marketing, framework, growth, experimentation, funnel-metrics]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Growth Hacking

## Purpose
Use growth hacking as a disciplined process for finding what grows a product: run many small, fast experiments across the whole customer lifecycle, measure them against one north star metric, and keep what works. The term was coined by Sean Ellis in 2010. The useful part is not tactics or tricks but the operating cadence: a backlog of ideas, a scoring method, a testing rhythm, and a shared metric that every team moves.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `growth-hacking` |
| Category | Content Marketing — Growth and Experimentation |
| Version | 2.0.0 |
| Originator of the term | Sean Ellis (2010) |
| Primary reference | Ellis & Brown, *Hacking Growth* (2017) |
| Related models | AARRR "pirate metrics" (Dave McClure, 2007) · ICE scoring |

## The Process
1. **Confirm product-market fit first.** Ellis's test asks users how they would feel if they could no longer use the product; growth work on a product people would not miss wastes effort.
2. **Choose a north star metric** that captures the value customers get, not just activity.
3. **Map the funnel with AARRR**: Acquisition, Activation, Retention, Referral, Revenue.
4. **Generate and score ideas**, for example with ICE: Impact, Confidence, Ease.
5. **Run experiments on a fixed cadence**, then analyse, learn and feed the results back into the backlog.

## Core Principles
- **Retention before acquisition.** Pouring users into a product that does not keep them burns money.
- **One north star.** A single metric aligns teams that would otherwise optimise conflicting numbers.
- **Velocity of learning matters more than any single win.** A steady experiment cadence compounds.
- **Activation is usually the cheapest lever.** Getting new users to their first moment of value lifts every later stage.
- **Growth is cross-functional.** Product, marketing, engineering and data share the same backlog.

## Applications & Use Cases
| Use Case | Application | Stage |
|---|---|---|
| Checking readiness to scale | Run the product-market fit survey before spending on acquisition | Pre-growth |
| Onboarding improvement | Shorten time to first value and test changes | Activation |
| Churn reduction | Find and fix the drop-off point after week one | Retention |
| Referral programmes | Design incentives tied to delivered value | Referral |
| Pricing and packaging | Test plan structure and upgrade prompts | Revenue |
| Channel discovery | Small, cheap tests across several channels | Acquisition |

## Usage Guidelines
- **Do not start growth work before product-market fit**; fix the product first.
- **Define the north star metric and the input metrics** that drive it, with owners.
- **Keep a single scored backlog** of experiment ideas across all AARRR stages.
- **Write each experiment as a hypothesis** with an expected effect and a stopping rule, before running it.
- **Record every result, including failures**, so the team does not repeat them.

## Prompt Template
```
You are running a growth process (Ellis & Brown 2017).

PRODUCT-MARKET FIT: [[evidence that users would miss the product]]
NORTH STAR METRIC: [[the value metric]]

AARRR — current rate and biggest drop-off:
acquisition · activation · retention · referral · revenue

EXPERIMENT IDEAS, scored with ICE (impact, confidence, ease, 1-10 each):

TOP EXPERIMENT
- Hypothesis:
- Metric and expected change:
- Stopping rule:
```

## Ethical Guidelines
- **No dark patterns.** Tricking users into sign-ups, shares or charges is not growth; it is churn and complaints deferred.
- **Respect consent and anti-spam law** in referral and messaging experiments.
- **Do not inflate metrics.** A north star that rewards vanity numbers misleads the whole team.

## Testing Strategy
- Use controlled experiments with a pre-registered hypothesis and stopping rule.
- Watch guardrail metrics such as retention and complaints alongside the target metric.

## Success Metrics
- Movement in the north star metric.
- Experiment velocity and the share of experiments that produce a learning.
- Retention curves flattening rather than declining toward zero.

## Collaboration Protocol
- Inbound from: `growth-hacker` · `marketing-team` · `product-strategist` · `analytics-reporter`
- Outbound to: CSO office for referral and messaging experiments that touch consent
- Cross-framework: A/B testing for rigorous experiments; Lean Startup for validated learning; Jobs-to-be-Done for finding what drives retention.

## Related Skills
- `composable-skills/frameworks/ab-testing/SKILL.md` — rigorous experiment design
- `composable-skills/frameworks/lean-startup/SKILL.md` — build, measure, learn
- `composable-skills/frameworks/okrs/SKILL.md` — aligning teams on the north star
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — why customers stay

## Reference Materials
- Ellis, S., & Brown, M. (2017). *Hacking Growth: How Today's Fastest-Growing Companies Drive Breakout Success.* Crown Business.
- McClure, D. (2007). "Startup Metrics for Pirates: AARRR!" Presentation.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
