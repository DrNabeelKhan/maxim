---
skill_id: theory-of-planned-behavior
name: Theory of Planned Behavior (TPB)
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply theory of planned behavior
  - TPB analysis
  - intention vs action gap
  - subjective norms behavior
  - perceived behavioral control
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - conversion-optimizer
  - decision-architect
ethics_required: true
priority: medium
tags: [behavior-science, framework, motivation, intention-action]
adr: ADR-007
created: 2026-05-19
updated: 2026-05-19
---

# Theory of Planned Behavior (TPB)

## Purpose
Apply Ajzen's Theory of Planned Behavior to diagnose the intention-action gap. TPB explains why people fail to do what they intend — by decomposing intention into three predictors (Attitudes · Subjective Norms · Perceived Behavioral Control) and intention into behavior (gated by actual control). When products show high stated interest but low conversion, the gap is usually one of TPB's components.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `theory-of-planned-behavior` |
| Category | Behavior Science — Intention → Action |
| Version | 1.0.0 |
| Originator | Icek Ajzen (1985 · 1991 refinement) |
| Maturity | Established — one of the most-cited frameworks in behavioral science; thousands of empirical studies |
| Primary references | Ajzen, I. (1991) "The theory of planned behavior." *Organizational Behavior and Human Decision Processes* 50(2): 179–211 · people.umass.edu/aizen/tpb.html |

## The Model

```
ATTITUDE TOWARD BEHAVIOR  ──┐
                            │
SUBJECTIVE NORMS           ──┼──→ INTENTION ──→ BEHAVIOR
                            │                    ↑
PERCEIVED BEHAVIORAL CTRL  ──┘                    │
                            │_____________________│
                                  (also directly affects behavior)
```

**Attitude toward the behavior** = personal evaluation (positive/negative feeling about performing it)
**Subjective Norms** = perceived social pressure (what important others think you should do)
**Perceived Behavioral Control** = perceived ease/difficulty (can I actually do this?)
**Intention** = motivational readiness to perform the behavior
**Actual Behavior** = the outcome (also gated by ACTUAL control, not just perceived)

## Prompt Template
```
You are applying the Theory of Planned Behavior (TPB).

CONTEXT:
- Target behavior: [[behavior]]
- Population: [[description]]
- Current intervention or design: [[approach]]

THREE-COMPONENT DIAGNOSIS:
1. ATTITUDE diagnosis
   - Beliefs about outcomes (cognitive)
   - Affect toward outcomes (emotional)
   - Net attitude: positive / neutral / negative
2. SUBJECTIVE NORMS diagnosis
   - Important referents (who matters to this population?)
   - Perceived expectations from those referents
   - Motivation to comply with referents
3. PERCEIVED BEHAVIORAL CONTROL diagnosis
   - Self-efficacy beliefs
   - Perceived barriers
   - Perceived resources / facilitators

INTENTION-ACTION GAP DIAGNOSIS:
- Stated intention strength: high / medium / low
- Behavior conversion rate: %
- Gap source: weak intention | strong intention but low control | strong intention but social-norm violation

INTERVENTION DESIGN:
- For attitude gaps: salient-outcome highlighting
- For subjective-norm gaps: social-proof + referent-specific testimonials
- For perceived-control gaps: scaffolding + skill-building + barrier removal
- For intention-behavior gaps: implementation intentions ("when X happens, I'll do Y")
```

## Core Principles
- **Intention is a function of three things, not one.** Persuading on attitude alone fails when subjective norms or control are negative.
- **Subjective norms matter most in collectivist cultures and high-stakes decisions.** In individualist contexts they're often weak; in family/health/career decisions they dominate.
- **Perceived control predicts behavior even when intention is weak.** Operators with high self-efficacy take action; operators with low self-efficacy delay even when motivated.
- **Implementation intentions close the intention-action gap.** "When X situation occurs, I'll do Y action" turns intention into automatic response.
- **Actual control limits perceived control's predictive power.** If barriers are real (cost · time · access), perceived control matters less than reducing the real barriers.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Health behavior change products | Diagnose which TPB component is the bottleneck | Higher behavior conversion |
| Sustainability / environmental behavior | Subjective norms via community visibility | Stronger social-pressure-driven adoption |
| Education / skill products | Perceived behavioral control via progressive scaffolding | Higher course completion |
| Sales conversion funnels | Diagnose the leak point (interest → click → signup → use) | Targeted intervention |
| Public health campaigns | Population-segmented TPB diagnosis | Higher uptake |
| Workplace policy adoption | Address subjective norms (peer compliance signals) + perceived control (training) | Faster adoption |

## Reference Materials
- Ajzen, I. (1991). "The theory of planned behavior." *Organizational Behavior and Human Decision Processes* 50(2): 179–211.
- Ajzen, I. (2002). "Perceived Behavioral Control, Self-Efficacy, Locus of Control, and the Theory of Planned Behavior." *Journal of Applied Social Psychology* 32(4): 665–683.
- Constructing Theory of Planned Behavior questionnaires — https://people.umass.edu/aizen/tpb.measurement.pdf
- Ajzen's TPB resource page — https://people.umass.edu/aizen/tpb.html

## Usage Guidelines
- Measure each TPB component separately in user research. A combined "would you do X?" question hides which component is the bottleneck.
- Implementation intentions are the lowest-cost, highest-leverage intervention to close intention-behavior gaps.
- Pair with TTM (stage-of-change determines which TPB component dominates).

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `conversion-optimizer` · `decision-architect`
- Outbound to: same agents + `habit-formation-coach` (where the target is repeated behavior)
- Cross-framework: pairs with Transtheoretical Model (stage informs which TPB component dominates), Fogg Behavior Model (Ability ≈ Perceived Behavioral Control), Cialdini (social proof informs Subjective Norms)

## Ethical Guidelines
- Manufactured subjective norms (fake testimonials · invented "everyone is doing it" claims) are dark patterns
- Inflating perceived control beyond actual control sets users up for failure
- Targeting behavior change against the user's underlying values (manipulating attitude) is unethical

## Success Metrics
- TPB-component-segmented conversion rates (which component is the bottleneck?)
- Intention-behavior gap closure rate after implementation-intentions intervention
- Behavior maintenance at 90 days (TPB predicts maintenance better than initial conversion)

## Related Skills
- `composable-skills/frameworks/transtheoretical-model/SKILL.md` — stage determines TPB component dominance
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Ability ≈ Perceived Behavioral Control
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — Social Proof = Subjective Norms
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — Autonomous motivation strengthens all three TPB components

## Testing Strategy
- Pre/post TPB questionnaires segmented by intervention type
- A/B test attitude-focused vs control-focused vs norms-focused messaging on the same population
- Expected: 20–40% lift when intervention matches the diagnosed bottleneck vs random framing

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in v1.2.0 final WS6b (2026-05-19)._
