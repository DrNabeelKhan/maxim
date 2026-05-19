---
skill_id: social-learning-theory
name: Social Learning Theory (Bandura)
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply social learning theory
  - Bandura modeling
  - observational learning
  - self-efficacy analysis
  - vicarious reinforcement
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - onboarding-designer
  - content-strategist
ethics_required: true
priority: medium
tags: [behavior-science, framework, modeling, observation, self-efficacy]
adr: ADR-007
created: 2026-05-19
updated: 2026-05-19
---

# Social Learning Theory (Bandura)

## Purpose
Apply Bandura's Social Learning Theory (later refined as Social Cognitive Theory) to design experiences where people learn behaviors by observing others — rather than only through direct reinforcement. Modeling, vicarious reinforcement, and self-efficacy are the core mechanisms. Critical for community products, education platforms, social-proof-heavy conversion funnels, and any context where "show, don't tell" drives behavior change.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `social-learning-theory` |
| Category | Behavior Science — Learning / Modeling |
| Version | 1.0.0 |
| Originator | Albert Bandura (1977 · expanded as Social Cognitive Theory 1986) |
| Maturity | Foundational — among the most-cited psychological theories of the 20th century |
| Primary references | Bandura, A. (1977). *Social Learning Theory.* Prentice Hall · albertbandura.com |

## The Four Mediating Processes (Bandura's modeling theory)

For observational learning to result in behavior change, four cognitive processes must occur:

1. **Attention** — observer must attend to the model (factors: model salience · relevance · attractiveness · authority · similarity to observer)
2. **Retention** — observer must encode the modeled behavior (factors: symbolic coding · mental rehearsal · cognitive organization)
3. **Reproduction** — observer must be capable of reproducing the behavior (factors: physical capability · skill prerequisites · environmental opportunity)
4. **Motivation** — observer must have reason to perform the behavior (factors: direct reinforcement · vicarious reinforcement seen on model · self-reinforcement · expectation of similar outcome)

## Self-Efficacy (Bandura's central construct)

Self-efficacy = belief in one's ability to perform a behavior successfully. Built through four sources:

1. **Mastery experiences** — succeeding at related tasks (most powerful)
2. **Vicarious experiences** — seeing similar others succeed
3. **Verbal persuasion** — credible others affirming capability
4. **Physiological states** — interpretation of arousal/anxiety as readiness vs incapability

Self-efficacy is highly task-specific. High self-efficacy at one task doesn't transfer automatically to another.

## Prompt Template
```
You are applying Social Learning Theory.

CONTEXT:
- Target behavior or skill: [[description]]
- Learner population: [[description]]
- Available models / examples / case studies: [[list]]

FOUR MEDIATING PROCESSES DIAGNOSIS:
1. Attention design
   - Are the modeled examples salient and visible?
   - Are models similar enough to observers to feel relevant?
   - Is there authority/expertise signal?
2. Retention design
   - Are behaviors broken into observable steps?
   - Are there memory aids (checklists · diagrams · videos)?
3. Reproduction design
   - Is the prerequisite skill present?
   - Is there scaffolded practice opportunity?
4. Motivation design
   - Is vicarious reinforcement visible (models seen succeeding/benefiting)?
   - Is self-reinforcement supported?
   - Are expected outcomes salient?

SELF-EFFICACY DIAGNOSIS:
- Mastery experiences available? <list small wins users can rack up>
- Vicarious experiences from similar others? <case studies · testimonials · community>
- Verbal persuasion from credible sources? <expert endorsements · feedback>
- Physiological state framing? <anxiety reframed as readiness>

INTERVENTION DESIGN:
- Model selection (who do we show?)
- Behavior decomposition (how do we make it learnable?)
- Practice scaffolding (graduated complexity)
- Reinforcement visibility (consequences shown)
```

## Core Principles
- **People learn primarily by observation,** not direct trial-and-error. Hours of YouTube tutorials work because of social learning.
- **Model similarity drives attention.** Observers attend to models they perceive as relevant to themselves. "People like me did X" is more persuasive than "experts say Y."
- **Vicarious reinforcement works.** Seeing someone else rewarded for a behavior is nearly as motivating as direct reinforcement.
- **Self-efficacy gates behavior.** Without belief in capability, observation doesn't translate to action. Self-efficacy must be built deliberately.
- **Mastery experiences trump verbal persuasion.** "You can do this!" without small-win opportunities is hollow.
- **Reciprocal determinism** — person, behavior, and environment continuously influence each other. SLT explicitly rejects pure behaviorism.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Community-driven products | Surface peer activity to model behaviors | Faster norm adoption · network-effect retention |
| Onboarding tutorials | Video/animated walkthroughs with similar-persona narrators | Higher activation · lower support load |
| Educational platforms | Worked examples + scaffolded practice + visible peer progress | Higher completion · skill transfer |
| Sales testimonials and case studies | Match model demographics to viewer | Higher conversion |
| Health behavior products | Peer success stories + self-efficacy-building micro-wins | Sustained behavior change |
| Workplace training | Modeling by senior peers (not just trainers) | Faster adoption · cultural alignment |

## Reference Materials
- Bandura, A. (1977). *Social Learning Theory.* Prentice Hall.
- Bandura, A. (1986). *Social Foundations of Thought and Action: A Social Cognitive Theory.* Prentice Hall.
- Bandura, A. (1997). *Self-Efficacy: The Exercise of Control.* W.H. Freeman.
- Albert Bandura archive — https://www.albertbandura.com/

## Usage Guidelines
- Choose models who are similar to the target population — not aspirational but unattainable
- Decompose the modeled behavior into observable, retainable steps
- Build self-efficacy through structured mastery experiences before complex action
- Pair vicarious reinforcement (peer success stories) with direct reinforcement (your own small wins)

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `onboarding-designer` · `habit-formation-coach`
- Outbound to: same agents + `content-strategist` (case study design) + `community-manager` (peer-visibility design)
- Cross-framework: pairs with Cialdini (Social Proof), Self-Determination Theory (Competence parallels self-efficacy), Fogg Behavior Model (Ability ≈ self-efficacy)

## Ethical Guidelines
- Fabricated case studies or fake peer success stories are dark patterns
- Cherry-picked models (only the successful 1% shown) inflate expectations and trigger reverse-vicarious-reinforcement (despair · burnout)
- Self-efficacy manipulation toward harmful behaviors is unethical even if mechanism is "modeling"

## Success Metrics
- Behavior adoption rate after observational intervention vs baseline
- Self-efficacy scale scores pre/post (Bandura's Self-Efficacy Scales)
- Long-term retention — SLT-driven adoption tends to be more durable than reinforcement-only

## Related Skills
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — Social Proof principle
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — Competence overlap with self-efficacy
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Ability component
- `composable-skills/frameworks/operant-conditioning/SKILL.md` — direct reinforcement contrast
- `composable-skills/frameworks/diffusion-of-innovations/SKILL.md` — observability is a Rogers adoption attribute

## Testing Strategy
- A/B test modeled-example designs vs text-only explanations on the same skill/behavior
- Measure: completion rate · self-reported self-efficacy delta · 30/90-day retention
- Expected: 30–50% lift on activation; even larger on long-term retention

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in v1.2.0 final WS6b (2026-05-19)._
