---
skill_id: east-framework
name: EAST Framework
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply east framework
  - east framework analysis
  - easy attractive social timely
  - nudge design
  - behavioural insights
  - make it easier to comply
collaborates_with:
  - nudge-architect
  - conversion-optimizer
  - behavioral-designer
  - marketing-team
ethics_required: true
priority: high
tags: [behavior-science, framework, nudge, behavioural-insights, public-policy]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-14
---

# EAST Framework

## Purpose
Use EAST to turn behavioral insight into practical design changes. Developed by the UK Behavioural Insights Team, it condenses a large body of evidence into four questions about the behavior you want to encourage: is it **Easy**, is it **Attractive**, is it **Social**, and is it **Timely**? It was written for public-service and policy settings, where it was used to redesign letters, forms and processes, and it transfers well to product and service design because each heading is concrete and testable.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `east-framework` |
| Category | Behavior Science — Applied Behavioural Insights |
| Version | 2.0.0 |
| Originator | The Behavioural Insights Team (BIT), UK |
| First published | 2014 |
| Primary reference | Service, Hallsworth, Halpern et al., *EAST: Four Simple Ways to Apply Behavioural Insights* (BIT, 2014) |
| Lineage | A simplification of MINDSPACE (Dolan et al., 2010) |

## The Framework

Each heading carries specific techniques, as set out in the BIT paper.

### Easy
- **Harness the power of defaults.** People tend to stay with the pre-set option.
- **Reduce the "hassle factor".** Small frictions deter behavior out of proportion to their size.
- **Simplify messages.** Make the key action clear and remove what competes with it.

### Attractive
- **Attract attention.** Use salience, personalisation and imagery so the message is noticed.
- **Design rewards and sanctions for maximum effect.** How an incentive is structured matters as much as its size.

### Social
- **Show that most people perform the desired behavior.** Accurate descriptive norms are persuasive.
- **Use the power of networks.** People are influenced by those around them.
- **Encourage people to make a commitment to others.** Public or reciprocal commitments raise follow-through.

### Timely
- **Prompt people when they are likely to be most receptive.** Behavior is easier to change at moments of transition.
- **Consider the immediate costs and benefits.** People weight the present more heavily than the future.
- **Help people plan their response to events.** Concrete if-then plans make follow-through more likely.

## Core Principles
- **Small frictions have large effects.** Removing a step, pre-filling a field or changing a default often matters more than a stronger argument.
- **Defaults are decisions.** Whatever is pre-selected will be chosen by many people, so choose it deliberately and in their interest.
- **Social norms must be true.** "Most people do X" persuades only when it is accurate. Highlighting that many people do the undesired thing can backfire by normalising it.
- **Timing is part of the design.** The same prompt works at one moment and fails at another.
- **Test rather than assume.** BIT's practice pairs each EAST change with a controlled trial, because intuitions about what works are often wrong.

## Applications & Use Cases
| Use Case | Application | EAST lever |
|---|---|---|
| Government letters and notices | Simplify the request and add a true descriptive norm | Easy, Social |
| Form and application completion | Remove fields, pre-fill known data, set sensible defaults | Easy |
| Enrolment and opt-in decisions | Make the beneficial option the default, with easy opt-out | Easy |
| Payment and deadline compliance | Prompt close to the deadline and help people plan | Timely |
| Product onboarding | Reduce steps and personalise the first message | Easy, Attractive |
| Re-engagement campaigns | Send at receptive moments with a clear single action | Timely, Easy |

## Usage Guidelines
- **Follow BIT's four-stage method:** define the outcome, understand the context, build the intervention, then test, learn and adapt.
- **Start with Easy.** Friction and defaults are usually the cheapest and most effective place to begin.
- **Use only accurate social norms**, and check the norm does not draw attention to how many people fail.
- **Choose the moment deliberately.** Map when the person is deciding, and place the prompt there.
- **Run a controlled trial** wherever feasible. EAST is a source of hypotheses, not a substitute for evidence.

## Prompt Template
```
You are applying the EAST framework (Behavioural Insights Team 2014).

OUTCOME: [[the specific behavior you want, and how it will be measured]]
CONTEXT: [[who, where, and the current process step by step]]

EASY
- Defaults: what is pre-set, and is it in the person's interest?
- Hassle: every step, field and wait. Which can go?
- Message: is the single key action unmistakable?

ATTRACTIVE
- Attention: is it noticed? Personalised? Salient?
- Rewards and sanctions: how are incentives structured and framed?

SOCIAL
- Norm: is there a TRUE descriptive norm worth showing?
- Networks: who influences this person?
- Commitment: can they commit to someone else?

TIMELY
- Moment: when are they most receptive?
- Present bias: what does it cost them now versus later?
- Planning: can they form a concrete if-then plan?

OUTPUT: changes under each heading, the single highest-leverage change, and how to test it.
```

## Ethical Guidelines
- **Defaults must serve the person.** A default chosen to benefit the organisation at the person's expense is a dark pattern.
- **Never invent a social norm.** False "most people" statements are deception.
- **Keep opting out easy.** A nudge preserves freedom of choice; an obstacle course does not.
- **Be willing to disclose the technique.** If the design would not survive being explained to the people it targets, reconsider it.

## Testing Strategy
- Use randomised controlled trials where feasible, as BIT does, with the target behavior as the outcome.
- Change one EAST element per variant to learn which lever mattered.
- Measure downstream effects as well as the immediate response, for example later regret or reversals.
- Check whether effects differ across groups.

## Success Metrics
- Change in the target behavior against a control.
- Cost per additional completed behavior, since many EAST changes are cheap to make.
- Opt-out and reversal rates, as a check that the nudge is not working against people's interests.
- Effect persistence over time.

## Collaboration Protocol
- Inbound from: `nudge-architect` · `behavioral-designer` · `conversion-optimizer` · `marketing-team`
- Outbound to: `conversion-optimizer` for experiment design; CSO office for public-sector, regulated or consent-related changes
- Cross-framework: COM-B for a fuller diagnosis of what is blocking the behavior; Fogg Behavior Model, whose Ability maps closely to Easy; Prospect Theory for framing within Attractive.

## Related Skills
- `composable-skills/frameworks/com-b-model/SKILL.md` — systematic diagnosis before applying EAST
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Ability and Prompt correspond to Easy and Timely
- `composable-skills/frameworks/prospect-theory/SKILL.md` — framing rewards and losses
- `composable-skills/frameworks/nudge-theory/SKILL.md` — the wider choice-architecture tradition

## Reference Materials
- Service, O., Hallsworth, M., Halpern, D., Algate, F., Gallagher, R., Nguyen, S., Ruda, S., Sanders, M., et al. (2014). *EAST: Four Simple Ways to Apply Behavioural Insights.* The Behavioural Insights Team.
- Dolan, P., Hallsworth, M., Halpern, D., King, D., & Vlaev, I. (2010). *MINDSPACE: Influencing Behaviour Through Public Policy.* Institute for Government and Cabinet Office.
- Halpern, D. (2015). *Inside the Nudge Unit: How Small Changes Can Make a Big Difference.* WH Allen.
- Hallsworth, M., List, J.A., Metcalfe, R.D., & Vlaev, I. (2017). "The behavioralist as tax collector: Using natural field experiments to enhance tax compliance." *Journal of Public Economics*, 148, 14–31.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-14, replacing a generated template stub._
