---
skill_id: sus
name: SUS
version: 2.0.0
category: design-ux
type: framework
frameworks: []
triggers:
  - system usability scale
  - sus score
  - measure usability
  - usability benchmark
  - perceived usability survey
collaborates_with:
  - usability-tester
  - ux-researcher
  - product-strategist
ethics_required: false
priority: medium
tags: [design-ux, framework, usability, measurement, survey]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# SUS

## Purpose
Use the System Usability Scale to measure how usable people perceive a product to be, with a short, standard questionnaire that produces a single score from 0 to 100. John Brooke created it in 1986 as a "quick and dirty" measure. It has since become one of the most widely used usability questionnaires because it is short, free, reliable even with small samples, and comparable across products and over time.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `sus` |
| Category | Design and UX — Usability Measurement |
| Version | 2.0.0 |
| Originator | John Brooke |
| Created / published | 1986 / 1996 |
| Benchmark research | Bangor, Kortum & Miller (2008) · Sauro & Lewis |

## The Instrument
- **Ten statements**, each rated on a five-point scale from strongly disagree to strongly agree.
- Items **alternate between positive and negative** wording to reduce response bias.
- **Scoring**: for odd-numbered items subtract 1 from the response; for even-numbered items subtract the response from 5; add the ten results and multiply by 2.5.
- The result runs from **0 to 100** and is **not a percentage**.

**Interpretation.** Across large sets of studies, the average score is about 68 (Sauro and Lewis), so scores are best read against that benchmark or as percentiles.

## Core Principles
- **Use the standard wording**, or results are not comparable with benchmarks.
- **It is not a percentage.** A score of 68 is roughly average, not 68% usable.
- **Measures perception, not cause.** SUS shows whether there is a problem, not what it is.
- **Reliable with small samples,** which makes it practical for iterative testing.
- **Compare over time and against benchmarks**, not in isolation.

## Applications & Use Cases
| Use Case | Application | Note |
|---|---|---|
| After usability tests | Administer once tasks are complete | Standard practice |
| Release-over-release tracking | Repeat with the same method | Watch the trend |
| Comparing designs | Score alternatives with similar users | Same tasks |
| Benchmarking | Compare against the ~68 average | Use percentiles |
| Vendor evaluation | Compare tools used for the same job | Consistent tasks |
| Executive reporting | One simple usability number | With context |

## Usage Guidelines
- **Administer after participants have used the product** for representative tasks.
- **Use the original ten items and scale** without modification.
- **Score correctly**, applying the odd and even item rules.
- **Report against the benchmark**, with sample size and confidence intervals.
- **Pair with qualitative findings** to explain the score.

## Prompt Template
```
You are measuring usability with SUS (Brooke 1996).

PRODUCT AND TASKS: [[...]]   PARTICIPANTS: n = __
SCORING: odd items (r - 1) · even items (5 - r) · sum x 2.5
MEAN SCORE and confidence interval:
VERSUS BENCHMARK (~68 average):
QUALITATIVE FINDINGS that explain the score:
```

## Ethical Guidelines
- **Do not present SUS as a percentage** or overstate what a small sample shows.

## Testing Strategy
- Use consistent tasks and participant profiles across rounds.
- Report confidence intervals, especially with small samples.

## Success Metrics
- SUS score trend across releases.
- Position relative to the benchmark.

## Collaboration Protocol
- Inbound from: `usability-tester` · `ux-researcher` · `product-strategist`
- Outbound to: `ui-designer` with the qualitative findings
- Cross-framework: Nielsen heuristics identify likely causes; user journey mapping locates problems in the experience.

## Related Skills
- `composable-skills/frameworks/nielsen-heuristics/SKILL.md` — finding likely causes
- `composable-skills/frameworks/user-journey-mapping/SKILL.md` — locating problems in the journey
- `composable-skills/frameworks/ab-testing/SKILL.md` — comparing designs rigorously

## Reference Materials
- Brooke, J. (1996). "SUS: A 'quick and dirty' usability scale." In Jordan, Thomas, Weerdmeester & McClelland (eds.), *Usability Evaluation in Industry.* Taylor & Francis.
- Brooke, J. (2013). "SUS: A Retrospective." *Journal of Usability Studies*, 8(2), 29–40.
- Bangor, A., Kortum, P.T., & Miller, J.T. (2008). "An Empirical Evaluation of the System Usability Scale." *International Journal of Human–Computer Interaction*, 24(6), 574–594.
- Sauro, J., & Lewis, J.R. *Quantifying the User Experience.* Morgan Kaufmann (2012; 2nd ed. 2016).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
