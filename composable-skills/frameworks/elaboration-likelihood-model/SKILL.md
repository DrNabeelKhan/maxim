---
skill_id: elaboration-likelihood-model
name: Elaboration Likelihood Model (ELM)
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - elaboration likelihood model
  - central and peripheral route
  - persuasion route
  - argument quality vs cues
  - audience involvement
collaborates_with:
  - persuasion-specialist
  - content-creator
  - marketing-strategist
ethics_required: true
priority: medium
tags: [behavior-science, framework, persuasion, attitude-change, messaging]
adr: ADR-007
created: 2026-07-08
updated: 2026-10-15
---

# Elaboration Likelihood Model (ELM)

## Purpose
Apply the Elaboration Likelihood Model to understand how people are persuaded and to design messages matched to the audience's **motivation** and **ability** to think carefully about them. Developed by Richard Petty and John Cacioppo, the ELM holds that persuasion runs along a continuum of elaboration. At high elaboration, attitudes change through careful scrutiny of the arguments (the **central route**). At low elaboration, they change through simple cues (the **peripheral route**). Attitudes formed centrally tend to last longer, resist counter-persuasion and predict behaviour better.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `elaboration-likelihood-model` |
| Category | Behavior Science — Persuasion |
| Version | 2.0.0 |
| Origin | Petty & Cacioppo (1986) |
| Classic study | Petty, Cacioppo & Goldman (1981): argument quality mattered under high personal involvement; source expertise mattered under low involvement |

## What Determines the Route
**Motivation to elaborate**: personal relevance, need for cognition and personal responsibility or accountability.

**Ability to elaborate**: distraction, time, prior knowledge, message comprehensibility and repetition.

- **Central route**: used when motivation **and** ability are both high. Argument quality drives attitude change.
- **Peripheral route**: used when motivation **or** ability is low. Cues drive attitude change, such as source credibility or attractiveness, the number of arguments, social consensus and mood.

A single variable can play several roles. Source attractiveness, for example, can act as a peripheral cue, as an argument (for a beauty product), or as a factor that changes how much people elaborate.

## Core Principles
- **Elaboration is a continuum,** not a switch between two modes.
- **Match the message to the audience's state.** Strong arguments win when people scrutinise; cues win when they do not.
- **Weak arguments backfire under scrutiny.** For highly involved audiences, poor arguments can produce less agreement.
- **Central-route attitudes are durable,** persisting longer and predicting behaviour better.
- **Variables play multiple roles,** so test how a cue behaves in your context.

## Applications & Use Cases
| Use Case | Application | Route |
|---|---|---|
| Message design | Match argument depth to audience motivation and ability | Both |
| High-involvement decisions | Provide strong, specific evidence for considered purchases or health choices | Central |
| Low-attention channels | Use credible sources and clear cues where scrutiny is unlikely | Peripheral |
| Content strategy | Pair substantive arguments with honest peripheral cues | Both |
| Lasting behaviour change | Raise personal relevance to encourage central processing | Central |
| Testing message variants | Vary argument quality and cues separately to see which drives effect | Both |

## Usage Guidelines
- **Assess the audience's motivation and ability** in the specific context and channel.
- **For high elaboration, lead with strong, specific, relevant arguments** and remove weak ones.
- **For low elaboration, use honest cues,** such as genuine expertise or real social proof, and keep the message simple.
- **Raise elaboration when durable change matters,** for example by increasing personal relevance or reducing distraction.
- **Test argument strength and cues separately** to learn which is driving results.

## Prompt Template
```
You are applying the Elaboration Likelihood Model (Petty & Cacioppo 1986).

AUDIENCE and context: [[...]]
MOTIVATION: personal relevance · need for cognition · accountability → high / low
ABILITY: time · distraction · knowledge · comprehensibility → high / low
LIKELY ROUTE: central / peripheral
CENTRAL ELEMENTS: strongest arguments and evidence
PERIPHERAL ELEMENTS: credible, honest cues
DURABILITY GOAL: should we raise elaboration?
TEST PLAN: vary arguments and cues separately
```

## Ethical Guidelines
- **Prefer the central route for consequential decisions,** so people choose on the merits.
- **Never fabricate cues,** such as fake experts, invented consensus or false scarcity.
- **Do not exploit low-ability states,** such as fatigue or distraction, to push decisions against people's interests.

## Testing Strategy
- A/B tests crossing argument quality with cue presence.
- Measure attitude persistence over time, not only immediate response.

## Success Metrics
- Persistence of attitude or behaviour change at follow-up.
- Conversion quality, such as retention or satisfaction, not just conversion rate.
- Message comprehension scores.

## Collaboration Protocol
- Inbound from: `marketing-strategist` · `persuasion-specialist`
- Outbound to: `content-creator` for message production
- Cross-framework: Cialdini's principles supply many peripheral cues; cognitive biases explain heuristic processing; A/B testing validates route assumptions.

## Related Skills
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — common persuasion cues
- `composable-skills/frameworks/cognitive-biases/SKILL.md` — heuristic processing
- `composable-skills/frameworks/ab-testing/SKILL.md` — testing message variants

## Reference Materials
- Petty, R.E., & Cacioppo, J.T. (1986). "The Elaboration Likelihood Model of Persuasion." *Advances in Experimental Social Psychology*, 19, 123–205.
- Petty, R.E., & Cacioppo, J.T. (1986). *Communication and Persuasion: Central and Peripheral Routes to Attitude Change.* Springer.
- Petty, R.E., Cacioppo, J.T., & Goldman, R. (1981). "Personal involvement as a determinant of argument-based persuasion." *Journal of Personality and Social Psychology*, 41(5), 847–855.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Revised 2026-10-15: generic template sections replaced with authored content; route conditions corrected (peripheral applies when motivation OR ability is low)._
