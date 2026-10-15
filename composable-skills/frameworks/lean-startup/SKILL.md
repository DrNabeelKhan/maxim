---
skill_id: lean-startup
name: Lean Startup
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - lean startup
  - minimum viable product
  - build measure learn
  - validated learning
  - pivot or persevere
collaborates_with:
  - product-strategist
  - innovation-researcher
  - rapid-prototyper
  - data-scientist
ethics_required: true
priority: high
tags: [product-research, framework, mvp, experimentation, startups]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Lean Startup

## Purpose
Use the Lean Startup method to reduce the risk of building something nobody wants, by treating a new product's plan as a set of assumptions and testing the riskiest ones as cheaply and quickly as possible. Eric Ries named it on his blog in 2008 and set it out in his 2011 book, building on Steve Blank's customer development. The central loop is **Build, Measure, Learn**, and the goal of each turn is **validated learning**: evidence about customers, not just output.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `lean-startup` |
| Category | Product Research — Experimentation and Validation |
| Version | 2.0.0 |
| Originator | Eric Ries |
| First published | 2008 (blog post "The lean startup"); book 2011 |
| Builds on | Steve Blank's customer development, *The Four Steps to the Epiphany* (2005) |

## Key Concepts
- **Leap-of-faith assumptions**: the value hypothesis (will people get value?) and the growth hypothesis (how will new customers find it?).
- **Minimum viable product (MVP)**: the smallest thing that lets you complete a Build-Measure-Learn loop with the least effort. It is an experiment, not a cut-down product.
- **Build, Measure, Learn**: plan backwards, deciding what you need to learn, what you must measure to learn it, and only then what to build.
- **Validated learning**: progress measured in evidence about customers.
- **Innovation accounting**: actionable metrics that show whether learning is moving the business, as opposed to vanity metrics.
- **Pivot or persevere**: a deliberate, regular decision based on the evidence.

## Core Principles
- **Test the riskiest assumption first.**
- **An MVP is a learning tool.** Its quality bar is whatever it takes to produce trustworthy evidence.
- **Actionable metrics, not vanity metrics.** Cohorts and conversion beat total sign-ups.
- **Speed of learning is the advantage.** Shorter loops mean more turns before money runs out.
- **Pivot on evidence, at planned points**, rather than drifting or persisting by default.

## Applications & Use Cases
| Use Case | Application | Concept |
|---|---|---|
| New product idea | List assumptions and test the riskiest | Leap-of-faith assumptions |
| Demand testing | A landing page or concierge service before building | MVP |
| Feature decisions | Ship small and measure behavior | Build-Measure-Learn |
| Board and investor updates | Report cohort metrics and learning | Innovation accounting |
| Strategy reviews | Scheduled pivot-or-persevere meetings | Pivot or persevere |
| Corporate innovation | Small teams with learning milestones | Validated learning |

## Usage Guidelines
- **Write the assumptions down** and rank them by risk and uncertainty.
- **Design the experiment before the MVP**: what will you measure, and what result would change your mind?
- **Choose the cheapest MVP that gives trustworthy evidence**: a landing page, a concierge or a Wizard of Oz test.
- **Use cohort-based, actionable metrics.**
- **Hold pivot-or-persevere decisions on a schedule.**

## Prompt Template
```
You are applying the Lean Startup method (Ries 2011).

VALUE HYPOTHESIS:
GROWTH HYPOTHESIS:
RISKIEST ASSUMPTION:
LEARN: what do we need to find out?
MEASURE: which actionable metric, and what threshold changes our mind?
BUILD: the cheapest MVP that produces that evidence
DECISION DATE for pivot or persevere:
```

## Ethical Guidelines
- **Be honest with early customers.** A Wizard of Oz or concierge test must not deceive people in ways that harm them.
- **Do not take payment for things you cannot deliver.**
- **Protect data** collected during experiments.

## Testing Strategy
- Pre-register the success threshold for each experiment.
- Use cohorts so changes in the product are not confused with changes in the audience.

## Success Metrics
- Learning velocity: validated assumptions per period.
- Movement in actionable metrics such as activation and retention by cohort.
- Time and cost per experiment.

## Collaboration Protocol
- Inbound from: `product-strategist` · `innovation-researcher` · `rapid-prototyper`
- Outbound to: `data-scientist` for experiment analysis
- Cross-framework: Jobs-to-be-Done for what to test; A/B testing for rigour; design thinking for discovery.

## Related Skills
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — the job the product must do
- `composable-skills/frameworks/ab-testing/SKILL.md` — experiment rigour
- `composable-skills/frameworks/design-thinking/SKILL.md` — discovery before validation

## Reference Materials
- Ries, E. (2008, 8 September). "The lean startup." *Startup Lessons Learned* (blog).
- Ries, E. (2011). *The Lean Startup.* Crown Business.
- Blank, S. (2005). *The Four Steps to the Epiphany.* Cafepress / K&S Ranch.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
