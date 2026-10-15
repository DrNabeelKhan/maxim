---
skill_id: okrs
name: OKRs
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - okrs
  - objectives and key results
  - set quarterly goals
  - write key results
  - goal alignment
collaborates_with:
  - product-strategist
  - sprint-prioritizer
  - analytics-reporter
  - project-shipper
ethics_required: false
priority: high
tags: [product-research, framework, goal-setting, alignment, metrics]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# OKRs

## Purpose
Use Objectives and Key Results to set a small number of ambitious goals and define, in measurable terms, what achieving them would look like. An **Objective** says what you want to achieve and is qualitative and motivating; its **Key Results** say how you will know, and are measurable outcomes. The method came from Andy Grove at Intel and was popularised by John Doerr, who introduced it to Google in 1999.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `okrs` |
| Category | Product Research — Goal Setting |
| Version | 2.0.0 |
| Origin | Andy Grove, Intel; described in *High Output Management* (1983) |
| Popularised by | John Doerr, *Measure What Matters* (2018) |

## The Structure
- **Objective**: what you want to accomplish. Clear, significant, action-oriented. Not a metric.
- **Key Results**: usually three to five per objective. Specific, time-bound, measurable outcomes that show the objective was achieved.
- **Committed versus aspirational OKRs.** Committed OKRs are expected to be fully met. Aspirational ones are deliberately ambitious; Doerr describes Google grading these from 0 to 1, with around 0.6 to 0.7 considered a strong result.
- **Cadence**: commonly quarterly, with regular check-ins.

## Core Principles
- **Key results measure outcomes, not activity.** "Launch the feature" is a task; "raise weekly activation from 30% to 40%" is a result.
- **Few and focused.** Too many OKRs mean no priorities.
- **Transparent.** Visible OKRs let teams align with each other.
- **Separate from compensation**, so people set honest, ambitious goals rather than safe ones.
- **Distinguish committed from aspirational** so a 70% result is read correctly.

## Applications & Use Cases
| Use Case | Application | Note |
|---|---|---|
| Quarterly planning | A few objectives per team, each with measurable results | Keep the set small |
| Company alignment | Teams link their OKRs to company objectives | Alignment, not strict cascade |
| Product strategy | Translate strategy into measurable outcomes | Outcomes over outputs |
| Turnarounds | Committed OKRs for must-hit results | Expect full delivery |
| Moonshots | Aspirational OKRs that stretch the team | Partial achievement is success |
| Reviews | Grade honestly and learn from misses | Not tied to pay |

## Usage Guidelines
- **Write the objective first**, as a short, qualitative statement of what matters.
- **Write key results as measurable changes**, with a baseline and a target.
- **Test each key result**: if it were achieved, would the objective really be met?
- **Label each OKR as committed or aspirational.**
- **Check in regularly** and grade honestly at the end of the cycle.

## Prompt Template
```
You are writing OKRs (Grove; Doerr 2018).

OBJECTIVE (qualitative, what matters): [[...]]
TYPE: committed | aspirational
KEY RESULTS (3-5, measurable outcomes with baseline -> target):
1.
2.
3.
CHECK: are these outcomes or tasks? If all were hit, is the objective achieved?
```

## Ethical Guidelines
- **Do not tie OKRs to pay or punishment**; it encourages sandbagging and gaming.
- **Watch for key results that can be gamed** at customers' expense.

## Testing Strategy
- Review whether achieved key results actually moved the underlying business outcome.
- Compare predicted and actual grades to calibrate ambition.

## Success Metrics
- Share of key results that are outcomes rather than tasks.
- Grading accuracy and honesty over successive cycles.
- Alignment of team OKRs to company objectives.

## Collaboration Protocol
- Inbound from: `product-strategist` · `sprint-prioritizer` · `analytics-reporter`
- Outbound to: `project-shipper` for delivery planning
- Cross-framework: Growth hacking's north star metric often anchors a key result; Agile/Scrum delivers the work.

## Related Skills
- `composable-skills/frameworks/growth-hacking/SKILL.md` — north star metrics
- `composable-skills/frameworks/agilescrum/SKILL.md` — delivering toward the goals
- `composable-skills/frameworks/champion-challenger-holdout/SKILL.md` — guarding against metric gaming

## Reference Materials
- Grove, A.S. (1983). *High Output Management.* Random House.
- Doerr, J. (2018). *Measure What Matters.* Portfolio / Penguin.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
