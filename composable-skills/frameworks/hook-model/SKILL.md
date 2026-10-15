---
skill_id: hook-model
name: Hook Model
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply hook model
  - hook model analysis
  - habit-forming product
  - trigger action variable reward investment
  - retention and engagement design
  - manipulation matrix
collaborates_with:
  - habit-formation-coach
  - behavioral-designer
  - product-strategist
  - growth-hacker
ethics_required: true
priority: high
tags: [behavior-science, framework, habit-formation, retention, product-design, ethics]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-14
---

# Hook Model

## Purpose
Use the Hook Model to understand and design how a product becomes part of someone's routine. Nir Eyal describes a four-phase cycle, **Trigger → Action → Variable Reward → Investment**, that users pass through repeatedly. Each pass makes the next more likely, until the product is used out of habit rather than deliberate choice. Because the model is about forming habits, it carries an unusually direct ethical obligation, and Eyal's own Manipulation Matrix is part of applying it properly.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `hook-model` |
| Category | Behavior Science — Habit Formation and Product Design |
| Version | 2.0.0 |
| Originator | Nir Eyal |
| First published | 2014 |
| Primary reference | Eyal with Hoover, *Hooked: How to Build Habit-Forming Products* (2014) |
| Builds on | Fogg Behavior Model (the Action phase) · operant conditioning (variable reward) |

## The Model

### 1. Trigger
What prompts the behavior.
- **External triggers** carry the information about what to do next. Eyal's four types: **paid**, **earned**, **relationship** and **owned**.
- **Internal triggers** are associations in the user's mind, very often a negative emotion such as boredom, loneliness or uncertainty, which the product relieves. A habit has formed when the internal trigger alone is enough.

### 2. Action
The simplest behavior done in anticipation of a reward. Eyal adopts the Fogg Behavior Model here: action requires sufficient motivation and ability when the trigger arrives, so the design goal is to make the action as easy as possible.

### 3. Variable Reward
A reward that varies keeps attention. Eyal identifies three kinds:
- **Rewards of the tribe** — social: connection, approval, recognition.
- **Rewards of the hunt** — the search for resources or information.
- **Rewards of the self** — mastery, competence, completion.

### 4. Investment
The user puts something in: time, data, effort, social capital or money. Investment **stores value** in the product, so it improves with use, and **loads the next trigger**, starting the next cycle.

### The Habit Zone
Habits form most readily for behaviors that are both **frequent** and **perceived as useful**.

### The Manipulation Matrix
Eyal's test for whether to apply the model at all, using two questions: **would the maker use the product themselves**, and **does it materially improve users' lives?**

| | Materially improves users' lives | Does not |
|---|---|---|
| **Maker uses it** | Facilitator | Entertainer |
| **Maker does not use it** | Peddler | Dealer |

Eyal's guidance is to build as a facilitator.

## Core Principles
- **The goal is the internal trigger.** External triggers start the cycle; the habit exists when the user returns without one.
- **Make the action simpler before adding motivation.** The Action phase rests on the Fogg Behavior Model, and ease is the more reliable lever.
- **Variability holds attention; a reward that never changes stops being noticed.** But the reward must still deliver real value.
- **Investment comes after the reward, not before.** Ask for effort once the user has received value.
- **Habit-forming design is an ethical choice.** Apply the Manipulation Matrix before applying the rest of the model.

## Applications & Use Cases
| Use Case | Application | Hook phase |
|---|---|---|
| Retention diagnosis | Find which phase of the cycle breaks for users who lapse | All four |
| Identifying the internal trigger | Interview for the emotion or situation that precedes use | Trigger |
| Reducing friction in the core loop | Remove steps between trigger and reward | Action |
| Designing a rewarding core experience | Choose a reward type that matches the job the user hires the product for | Variable Reward |
| Building stored value | Let user contributions make the product better for them | Investment |
| Ethical review of engagement features | Place the product on the Manipulation Matrix | Ethics |

## Usage Guidelines
- **Check the Manipulation Matrix first.** If the product would not materially improve users' lives, do not apply the rest of the model.
- **Confirm the product sits in the Habit Zone**, frequent enough and useful enough, before designing for habit at all.
- **Identify the internal trigger through research**, not assumption, and write down the situation and emotion precisely.
- **Map the full cycle** for the core behavior and find the weakest phase.
- **Use Eyal's habit testing: identify, codify, modify.** Find your habitual users, codify the path they took, and design the product so others can follow it.

## Prompt Template
```
You are applying the Hook Model (Eyal 2014).

PRODUCT AND CORE BEHAVIOR: [[what the user does repeatedly]]

0. MANIPULATION MATRIX — answer first
   - Would the maker use this themselves?
   - Does it materially improve users' lives?
   - Quadrant: facilitator | peddler | entertainer | dealer
   If not facilitator, stop and say why.

1. HABIT ZONE: how often, and how useful is it perceived to be?

2. TRIGGER
   - External: paid | earned | relationship | owned
   - Internal: the emotion or situation that should come to prompt use

3. ACTION: the simplest action, and its main barrier (see Fogg Behavior Model)

4. VARIABLE REWARD: tribe | hunt | self, and the real value it delivers

5. INVESTMENT: what the user puts in, how it stores value, and which trigger it loads

OUTPUT: the weakest phase, the specific change, and the ethical assessment.
```

## Ethical Guidelines
- **Build as a facilitator.** Eyal's own test: use it yourself, and be confident it materially improves users' lives.
- **Do not target vulnerable users.** Habit-forming mechanics applied to people prone to compulsive use cause real harm.
- **Do not exploit the internal trigger.** Relieving a real need is the point; cultivating the negative emotion to sell its relief is manipulation.
- **Keep variable rewards honest.** Withheld or artificially rationed value is a dark pattern.
- **Make it easy to stop.** Design notification controls and exits as carefully as the hook itself.

## Testing Strategy
- Measure each phase separately: trigger response, action completion, reward engagement, and investment.
- Compare the paths of habitual and non-habitual users to find where they diverge.
- Track signs of compulsive or regretted use alongside engagement, not just engagement.

## Success Metrics
- Share of returning users who arrive without an external trigger, as evidence the internal trigger has formed.
- Frequency and consistency of the core behavior.
- Retention cohorts over time.
- User-reported value and regret, as an ethical counterweight to engagement metrics.

## Collaboration Protocol
- Inbound from: `habit-formation-coach` · `product-strategist` · `growth-hacker` · `behavioral-designer`
- Outbound to: CSO office (ethics) for any use involving minors, health, finance, gambling-like mechanics or vulnerable users
- Cross-framework: Fogg Behavior Model for the Action phase; operant conditioning for the theory of variable reward; Self-Determination Theory for whether engagement is healthy.

## Related Skills
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — the basis of the Action phase
- `composable-skills/frameworks/operant-conditioning/SKILL.md` — reinforcement schedules behind variable reward
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — autonomy, competence and relatedness as a health check on engagement
- `composable-skills/frameworks/com-b-model/SKILL.md` — a broader diagnosis when the habit will not form

## Reference Materials
- Eyal, N., with Hoover, R. (2014). *Hooked: How to Build Habit-Forming Products.* Portfolio / Penguin.
- Eyal, N., with Li, J. (2019). *Indistractable: How to Control Your Attention and Choose Your Life.* BenBella Books.
- Fogg, B.J. (2009). "A Behavior Model for Persuasive Design." *Proceedings of Persuasive '09.* ACM.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-14, replacing a generated template stub._
