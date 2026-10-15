---
skill_id: com-b-model
name: COM-B Model
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply com-b model
  - com-b model analysis
  - behaviour change wheel
  - behavior change intervention design
  - why are people not doing this
  - capability opportunity motivation
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - product-strategist
  - ux-researcher
ethics_required: true
priority: high
tags: [behavior-science, framework, behaviour-change-wheel, intervention-design, diagnosis]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-14
---

# COM-B Model

## Purpose
Use COM-B to diagnose what has to change for a behavior to happen, and then to choose interventions systematically rather than by habit or taste. The model holds that a **B**ehavior occurs only when a person has the **C**apability, the **O**pportunity and the **M**otivation to perform it. It sits at the hub of the Behaviour Change Wheel, which connects that diagnosis to nine intervention functions and seven policy categories, so the cause found in the diagnosis determines the kind of intervention chosen.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `com-b-model` |
| Category | Behavior Science — Behaviour Change Intervention Design |
| Version | 2.0.0 |
| Originators | Susan Michie, Maartje van Stralen, Robert West, University College London |
| First published | 2011 |
| Primary references | Michie, van Stralen & West, *Implementation Science* 6:42 (2011) · *The Behaviour Change Wheel* guide (2014) |
| Related standards | Theoretical Domains Framework (TDF) · Behaviour Change Technique Taxonomy v1 (BCTTv1) |

## The Model

### The three sources of behavior, each with two subtypes
1. **Capability** — whether the person can do it.
   - **Physical**: skill, strength, stamina.
   - **Psychological**: knowledge, comprehension, memory, attention, decision-making, self-regulation.
2. **Opportunity** — whether the environment allows it.
   - **Physical**: time, resources, location, cues and physical barriers.
   - **Social**: norms, culture, and what the people around them do and expect.
3. **Motivation** — whether they want to, at the moment it matters.
   - **Reflective**: plans, evaluations, beliefs, intentions.
   - **Automatic**: emotions, impulses, desires and habits.

COM-B is a system, not a checklist. Capability and opportunity both influence motivation, and performing a behavior changes all three in turn.

### The Behaviour Change Wheel
**Nine intervention functions**, each suited to particular COM-B deficits:
Education · Persuasion · Incentivisation · Coercion · Training · Restriction · Environmental restructuring · Modelling · Enablement

**Seven policy categories** that deliver those functions:
Communication and marketing · Guidelines · Fiscal measures · Regulation · Legislation · Environmental and social planning · Service provision

### APEASE — criteria for choosing between candidate interventions
**A**ffordability · **P**racticability · **E**ffectiveness and cost-effectiveness · **A**cceptability · **S**ide-effects and safety · **E**quity

## Core Principles
- **Diagnose before intervening.** The intervention follows from which component is deficient. Training does nothing for someone who already can but has no opportunity.
- **Name the subtype, not just the component.** "Low motivation" is too coarse; reflective and automatic motivation call for different interventions.
- **Opportunity is often the real barrier.** Many apparent motivation problems are environmental: the time, resource or social cue is absent.
- **Behavior is a system.** Changing one component affects the others, and doing the behavior builds capability and motivation for next time.
- **Choose interventions against explicit criteria.** APEASE makes trade-offs visible instead of leaving them to preference.

## Applications & Use Cases
| Use Case | Application | What COM-B adds |
|---|---|---|
| Diagnosing low adoption | Map the barrier to capability, opportunity or motivation and its subtype | Separates "can't" from "won't" from "isn't able to here" |
| Designing an intervention | Move from deficit to intervention function to policy category | A traceable reason for each design choice |
| Public health and policy | Apply the full Behaviour Change Wheel | Its original and most established setting |
| Workplace and process compliance | Find whether the barrier is skill, environment or motivation | Avoids defaulting to more training |
| User research synthesis | Code interview findings against the six subtypes | Turns qualitative findings into a structured diagnosis |
| Comparing intervention options | Score candidates against APEASE | Explicit trade-offs instead of preference |

## Usage Guidelines
- **Specify the behavior precisely:** who needs to do what, when, where, how often and with whom.
- **Diagnose all six subtypes**, not only the one that seems obvious. Gather evidence for each rather than assuming.
- **Map each identified deficit to candidate intervention functions** using the Behaviour Change Wheel, then to the policy categories that could deliver them.
- **Filter candidates with APEASE** before committing, and record why the chosen option won.
- **Specify content with behaviour change techniques** from the BCT Taxonomy so the intervention is described precisely enough to replicate and evaluate.

## The Behaviour Change Wheel process
Michie, Atkins and West (2014) set out three stages:
1. **Understand the behavior.** Define the problem in behavioral terms, select and specify the target behavior, and identify what needs to change using COM-B.
2. **Identify intervention options.** Select intervention functions, then policy categories.
3. **Identify content and implementation options.** Select behaviour change techniques, then the mode of delivery.

## Prompt Template
```
You are applying COM-B and the Behaviour Change Wheel (Michie, van Stralen & West 2011).

TARGET BEHAVIOR: [[who]] needs to [[do what]], [[when / where / how often]]

DIAGNOSIS — evidence for each subtype, marked deficient / adequate / unknown:
- Capability, physical:
- Capability, psychological:
- Opportunity, physical:
- Opportunity, social:
- Motivation, reflective:
- Motivation, automatic:

INTERVENTION FUNCTIONS for each deficit:
  education · persuasion · incentivisation · coercion · training · restriction ·
  environmental restructuring · modelling · enablement

POLICY CATEGORIES that could deliver them.

APEASE screen of the candidates:
  affordability · practicability · effectiveness · acceptability · side-effects · equity

OUTPUT: the deficits with their evidence, the chosen intervention, and why it beat the alternatives.
Mark any subtype diagnosed without evidence as an assumption.
```

## Ethical Guidelines
- **Coercion and restriction are on the wheel; that does not make them appropriate.** Reserve them for cases with a clear public-interest justification, and prefer enabling options first.
- **Equity is a selection criterion, not an afterthought.** An intervention that works on average can widen gaps between groups.
- **Do not relabel structural barriers as motivation.** Calling an opportunity problem a motivation problem shifts blame onto the person.
- **Be transparent with the people affected** about the intervention and its purpose wherever possible.

## Testing Strategy
- Evaluate against the specified behavior, not a proxy such as awareness or attitude.
- Where practical, test interventions targeting different components separately, to learn which deficit was really binding.
- Report the behaviour change techniques used so results can be compared and reproduced.
- Check for effects on equity across segments, not only the average effect.

## Success Metrics
- Change in the specified target behavior, measured directly.
- Change in the targeted COM-B component, measured where possible, showing the mechanism worked as intended.
- Persistence of the behavior after the intervention ends.
- Distribution of the effect across groups.

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `ux-researcher` · `product-strategist` · `habit-formation-coach`
- Outbound to: `behavioral-designer` for intervention design; CSO office when interventions involve restriction, coercion or regulated settings
- Cross-framework: Fogg Behavior Model for a single-moment design view; EAST for an applied checklist; Theory of Planned Behavior for reflective motivation in detail.

## Related Skills
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — a moment-level view of motivation and ability
- `composable-skills/frameworks/east-framework/SKILL.md` — applied techniques for the "how"
- `composable-skills/frameworks/theory-of-planned-behavior/SKILL.md` — reflective motivation: attitudes, norms, perceived control
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — the quality of motivation

## Reference Materials
- Michie, S., van Stralen, M.M., & West, R. (2011). "The behaviour change wheel: A new method for characterising and designing behaviour change interventions." *Implementation Science*, 6, 42.
- Michie, S., Atkins, L., & West, R. (2014). *The Behaviour Change Wheel: A Guide to Designing Interventions.* Silverback Publishing.
- Michie, S., Richardson, M., Johnston, M., et al. (2013). "The behavior change technique taxonomy (v1) of 93 hierarchically clustered techniques." *Annals of Behavioral Medicine*, 46(1), 81–95.
- Cane, J., O'Connor, D., & Michie, S. (2012). "Validation of the theoretical domains framework for use in behaviour change and implementation research." *Implementation Science*, 7, 37.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-14, replacing a generated template stub._
