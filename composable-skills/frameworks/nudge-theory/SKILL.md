---
skill_id: nudge-theory
name: Nudge Theory
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply nudge theory
  - nudge theory analysis
  - choice architecture
  - default design
  - libertarian paternalism
  - sludge audit
collaborates_with:
  - nudge-architect
  - decision-architect
  - behavioral-designer
  - product-strategist
ethics_required: true
priority: high
tags: [behavior-science, framework, choice-architecture, defaults, sludge]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Nudge Theory

## Purpose
Use Nudge Theory to design the context in which people choose, so that the choice that serves them is easier to make, without removing any option or materially changing incentives. Thaler and Sunstein call the person who shapes that context a **choice architect**, and note that there is no neutral design: every form, menu and default influences the outcome. The useful question is therefore not whether to influence, but how to do it transparently and in the chooser's interest.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `nudge-theory` |
| Category | Behavior Science — Choice Architecture |
| Version | 2.0.0 |
| Originators | Richard H. Thaler and Cass R. Sunstein |
| First published | 2008 (book); "libertarian paternalism" set out in 2003 |
| Primary references | *Nudge* (2008) · *Nudge: The Final Edition* (2021) |
| Recognition | Thaler received the Nobel Memorial Prize in Economic Sciences in 2017 |

## The Theory

**A nudge** is any aspect of choice architecture that changes behavior predictably without forbidding options or significantly changing economic incentives. To count as a nudge it must be easy and cheap to avoid. A ban is not a nudge, and neither is a large tax.

**Libertarian paternalism.** Steer people toward choices that make their lives better by their own judgment, while preserving their freedom to choose otherwise.

### The tools of choice architecture (from *Nudge*)
- **Defaults.** Many people accept whatever is pre-set, so the default is one of the most powerful design choices.
- **Expect error.** Design for the mistakes people predictably make.
- **Give feedback.** Tell people promptly how they are doing and when something is going wrong.
- **Understand mappings.** Help people connect a choice to the outcome they will actually experience.
- **Structure complex choices.** Simplify, sort and filter when options are many or hard to compare.
- **Incentives.** Make the relevant costs and benefits salient to the person choosing.

### Sludge
Sludge is the opposite of a good nudge: friction that makes it harder to do something in your own interest, such as a long cancellation process or a burdensome claim form. *The Final Edition* gives it extended attention.

## Core Principles
- **There is no neutral design.** Order, defaults and wording always influence choice, so choose them deliberately.
- **Defaults are decisions on the user's behalf.** Set them to what most people would choose if they had time and information.
- **Preserve freedom of choice.** Opting out must be easy; otherwise the design is coercion, not a nudge.
- **Nudge for good.** Thaler's test: would the people being nudged endorse it?
- **Remove sludge as well as adding nudges.** Taking friction out of beneficial actions often matters as much as adding prompts.

## Applications & Use Cases
| Use Case | Application | Choice-architecture tool |
|---|---|---|
| Retirement saving | Automatic enrolment with an easy opt-out | Defaults |
| Organ donation and consent schemes | Set the default thoughtfully and make the choice easy to change | Defaults |
| Pricing pages | Order and group plans so the comparison is clear | Structure complex choices |
| Error-prone forms | Validate inline, confirm irreversible actions | Expect error, feedback |
| Cancellation and claims | Audit for friction that works against the user | Sludge removal |
| Energy and spending feedback | Show usage against a meaningful comparison | Feedback, mappings |

## Usage Guidelines
- **Map the existing choice architecture first**, including the current default, the order of options and every step.
- **Set defaults to the option most people would choose with full information**, and make changing it easy.
- **Audit for sludge** in the paths that serve the user, such as cancelling, claiming, correcting or opting out.
- **Apply Thaler's endorsement test** before shipping: would users approve of the nudge if it were explained to them?
- **Test against a control.** Nudges are hypotheses, and their effects vary by population and context.

## Prompt Template
```
You are applying Nudge Theory and choice architecture (Thaler & Sunstein 2008).

DECISION: [[what the person is choosing]]
THE CHOOSER'S INTEREST: [[the outcome they would endorse with full information]]

CURRENT CHOICE ARCHITECTURE
- Default:
- Order and grouping of options:
- Steps and friction, mark any SLUDGE:

TOOLS
- Defaults · Expect error · Give feedback · Understand mappings · Structure complex choices · Incentives

DESIGN
- Proposed default and why it serves the chooser:
- How easy is opt-out?
- Sludge to remove:

ENDORSEMENT TEST: would the chooser approve of this if it were explained? yes / no, and why.
```

## Ethical Guidelines
- **Nudge for the chooser, not the organisation.** A default chosen to benefit the business at the user's expense is a dark pattern, not a nudge.
- **Keep it transparent.** A nudge that only works if hidden is not acceptable.
- **Opting out must stay cheap.** If avoiding it is costly, it has become coercion.
- **Watch for unequal effects.** Defaults that suit the average person can harm those whose circumstances differ.

## Testing Strategy
- Randomise exposure to the redesigned choice and compare against the current design.
- Measure the decision and its later consequences, not just the immediate choice.
- Track opt-out rates; a very low rate can mean a strong default or a hidden exit, so check which.

## Success Metrics
- Share of people ending up with the option they would endorse.
- Opt-out and reversal rates.
- Time and effort needed to complete beneficial actions, as a sludge measure.
- Satisfaction or regret measured after the decision.

## Collaboration Protocol
- Inbound from: `nudge-architect` · `decision-architect` · `behavioral-designer` · `product-strategist`
- Outbound to: CSO office when defaults touch consent, privacy or regulated choices
- Cross-framework: EAST for an applied checklist; Prospect Theory for why defaults and losses weigh heavily; COM-B for diagnosing what blocks the choice.

## Related Skills
- `composable-skills/frameworks/east-framework/SKILL.md` — a practical checklist built on this tradition
- `composable-skills/frameworks/prospect-theory/SKILL.md` — status quo bias and loss aversion behind the power of defaults
- `composable-skills/frameworks/dual-process-theory/SKILL.md` — why automatic thinking makes choice architecture matter
- `composable-skills/frameworks/com-b-model/SKILL.md` — diagnosis before redesign

## Reference Materials
- Thaler, R.H., & Sunstein, C.R. (2003). "Libertarian Paternalism." *American Economic Review*, 93(2), 175–179.
- Thaler, R.H., & Sunstein, C.R. (2008). *Nudge: Improving Decisions About Health, Wealth, and Happiness.* Yale University Press.
- Thaler, R.H., & Sunstein, C.R. (2021). *Nudge: The Final Edition.* Penguin Books.
- Thaler, R.H., & Benartzi, S. (2004). "Save More Tomorrow: Using Behavioral Economics to Increase Employee Saving." *Journal of Political Economy*, 112(S1), S164–S187.
- Sunstein, C.R. (2016). *The Ethics of Influence: Government in the Age of Behavioral Science.* Cambridge University Press.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
