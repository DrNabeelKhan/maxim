---
skill_id: fogg-behavior-model
name: Fogg Behavior Model
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply fogg behavior model
  - fogg behavior model analysis
  - b=map
  - why are users not doing this
  - motivation ability prompt
  - habit formation
  - tiny habits
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - conversion-optimizer
  - product-strategist
  - ux-researcher
ethics_required: true
priority: high
tags: [behavior-science, framework, behavior-design, habit-formation, onboarding]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-14
---

# Fogg Behavior Model

## Purpose
Use the Fogg Behavior Model to diagnose why a target behavior is not happening and to design for it. The model states that a behavior occurs when three elements converge at the same moment: **Motivation**, **Ability** and a **Prompt** (B = MAP). If the behavior is not happening, at least one of the three is missing at the moment it is needed. The practical value is diagnostic: instead of asking users to "want it more", it locates the specific element that failed.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `fogg-behavior-model` |
| Category | Behavior Science — Behavior Design |
| Version | 2.0.0 |
| Originator | B.J. Fogg, Stanford Behavior Design Lab |
| First published | 2009 |
| Primary references | Fogg, "A Behavior Model for Persuasive Design", *Persuasive '09* (2009) · *Tiny Habits* (2019) |
| Note on terms | The 2009 paper calls the third element a **Trigger**. Fogg later renamed it **Prompt**. |

## The Model

**B = MAP.** Behavior happens when Motivation, Ability and a Prompt are present together.

**The Action Line.** Plot motivation against ability and draw a curve. A prompt that arrives above the curve succeeds; below it, the prompt fails. Motivation and ability compensate for each other: a very easy behavior needs little motivation, and a hard behavior needs a lot.

### Motivation — three core motivators, each with two sides
1. **Sensation**: pleasure and pain. Immediate, felt in the moment.
2. **Anticipation**: hope and fear. The expectation of an outcome.
3. **Social cohesion**: acceptance and rejection.

### Ability — six simplicity factors
Simplicity is set by whichever resource is scarcest for that person at that moment.
1. **Time**
2. **Money**
3. **Physical effort**
4. **Brain cycles** (mental effort, attention)
5. **Social deviance** (going against norms)
6. **Non-routine** (how far it departs from what they already do)

### Prompt — three types, matched to where the person sits on the Action Line
1. **Spark**: ability is high, motivation is low. The prompt must carry motivation.
2. **Facilitator**: motivation is high, ability is low. The prompt must make the action easier.
3. **Signal**: both are high. A reminder is enough.

## Core Principles
- **No prompt, no behavior.** Highly motivated, highly able people still do nothing if nothing prompts them at the right moment. Check the prompt first; it is the most commonly missing element.
- **Ability is more dependable than motivation.** Motivation rises and falls; making the behavior easier keeps working. Fogg's guidance is to simplify before trying to motivate.
- **Simplicity is a property of the person, not the feature.** A step that costs one person seconds can cost another a scarce resource. Identify which of the six factors is scarcest for this user.
- **Match the prompt to the deficit.** A spark sent to someone who lacks ability is noise; a facilitator sent to someone who lacks motivation does nothing.
- **Help people do what they already want to do.** The model works with existing motivation. It is not a method for creating desire that is not there.

## Applications & Use Cases
| Use Case | Application | What to examine |
|---|---|---|
| Onboarding first action | Locate which of M, A or P fails at the first meaningful step | Drop-off at a specific screen |
| Feature adoption | Lower the scarcest simplicity factor for the feature | Feature discovered but not used |
| Habit formation | Anchor a tiny version of the behavior to an existing routine | Behavior starts, then stops |
| Diagnosing a failed conversion | Ask in order: was there a prompt, could they, did they want to | High intent, low completion |
| Notification design | Choose spark, facilitator or signal by the user's state | Prompts ignored or resented |
| Reactivation | Re-prompt with a facilitator that removes the step that stopped them | Lapsed users |

## Usage Guidelines
- **Define one specific behavior first.** "Engage with the product" is not a behavior. "Upload a first file within ten minutes of signup" is.
- **Diagnose before you design.** Work through Prompt, then Ability, then Motivation, and find the element that is actually missing.
- **Find the scarcest simplicity factor** for this user at this moment, and reduce that one before anything else.
- **Pick the prompt type from the diagnosis.** Spark for low motivation, facilitator for low ability, signal when both are already high.
- **For habits, start tiny and anchor it.** Attach the smallest possible version of the behavior to something the person already does reliably, as in Tiny Habits.

## Prompt Template
```
You are applying the Fogg Behavior Model (B = MAP; Fogg 2009).

TARGET BEHAVIOR: [[one specific, observable behavior]]
USER AND MOMENT: [[who, and at what point]]

DIAGNOSIS — check in this order:
1. Prompt: is anything prompting this behavior at the moment it is needed? What, exactly?
2. Ability: which of the six simplicity factors is scarcest for this user right now?
   time · money · physical effort · brain cycles · social deviance · non-routine
3. Motivation: which core motivator is in play, and is it present at that moment?
   sensation (pleasure/pain) · anticipation (hope/fear) · social (acceptance/rejection)

PLACEMENT: where does the user sit relative to the Action Line?

DESIGN:
- The missing element:
- Change that addresses it (prefer reducing the scarcest simplicity factor):
- Prompt type: spark | facilitator | signal, and why

OUTPUT: the failing element, the specific change, and the prompt, each tied to the diagnosis.
```

## Ethical Guidelines
- **Work with existing motivation.** Use the model to help people do what they already want to do, not to manufacture desire they did not have.
- **Do not exploit fear.** Anticipation includes fear; using invented threats as a spark is manipulation.
- **Make the opposite behavior easy too.** If you make signing up one click, make cancelling comparably easy.
- **Respect prompt fatigue.** A prompt that arrives when the person cannot act trains them to ignore you.

## Testing Strategy
- Test one element at a time: change the prompt, or the ability barrier, or the motivational message, and not all three at once, so the result shows which element mattered.
- Instrument the specific behavior, not a proxy for it.
- Segment by user state: the same change can help users who were low on ability and do nothing for those low on motivation.

## Success Metrics
- Completion rate of the specific target behavior at the moment it is prompted.
- Time from prompt to behavior.
- Retention of the behavior over time, for habit goals.
- Opt-out, unsubscribe and complaint rates, as a check on prompt fatigue and over-reach.

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `habit-formation-coach` · `conversion-optimizer` · `ux-researcher`
- Outbound to: `product-strategist` for prioritisation, `conversion-optimizer` for experiments
- Cross-framework: COM-B for a broader diagnosis that adds environment and social context; Hook Model, whose Action phase is built on this model; EAST for public-sector and policy framing.

## Related Skills
- `composable-skills/frameworks/com-b-model/SKILL.md` — broader diagnosis: Capability, Opportunity, Motivation
- `composable-skills/frameworks/hook-model/SKILL.md` — uses this model for its Action phase
- `composable-skills/frameworks/east-framework/SKILL.md` — "Easy" maps closely to Ability
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — the quality of motivation, not just its amount

## Reference Materials
- Fogg, B.J. (2009). "A Behavior Model for Persuasive Design." *Proceedings of the 4th International Conference on Persuasive Technology (Persuasive '09)*, Article 40. ACM.
- Fogg, B.J. (2019). *Tiny Habits: The Small Changes That Change Everything.* Houghton Mifflin Harcourt.
- Fogg, B.J. (2003). *Persuasive Technology: Using Computers to Change What We Think and Do.* Morgan Kaufmann.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-14, replacing a generated template stub._
