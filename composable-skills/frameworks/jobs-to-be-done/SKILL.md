---
skill_id: jobs-to-be-done
name: Jobs-to-be-Done
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply jobs to be done
  - jtbd analysis
  - job story
  - switch interview
  - what job does the customer hire this for
  - outcome-driven innovation
collaborates_with:
  - product-strategist
  - user-researcher
  - behavioral-designer
  - market-analyst
  - innovation-researcher
ethics_required: true
priority: high
tags: [behavior-science, framework, product-strategy, customer-research, innovation]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Jobs-to-be-Done

## Purpose
Use Jobs-to-be-Done to understand why people choose a product: they "hire" it to make progress in a particular circumstance, and "fire" it when something does that job better. The unit of analysis is the **job**, not the customer's demographics or the product's features, which is why JTBD often reveals competitors and opportunities that a feature comparison misses. Several schools share the core idea and differ in method, so name the one you are applying.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `jobs-to-be-done` |
| Category | Behavior Science — Customer Motivation and Product Strategy |
| Version | 2.0.0 |
| Key contributors | Clayton Christensen · Tony Ulwick · Bob Moesta |
| Primary references | Christensen et al., *Competing Against Luck* (2016) · Ulwick, *Jobs to Be Done: Theory to Practice* (2016) · Moesta, *Demand-Side Sales 101* (2020) |

## The Framework

**The core idea.** People do not buy products; they hire them to make progress in a specific circumstance. Christensen's well-known example is the morning commuter who hires a milkshake for a long, boring drive, competing with bagels and bananas rather than with other milkshakes.

**Three dimensions of a job**
- **Functional**: the practical task to get done.
- **Emotional**: how the person wants to feel, or avoid feeling.
- **Social**: how they want to be seen by others.

### Three schools
1. **Jobs as progress** (Christensen, Moesta). Focus on the circumstance and the struggle for progress, uncovered through switch interviews.
2. **Outcome-Driven Innovation** (Ulwick). Define the job as a process, list measurable **desired outcomes**, and rank them by importance and satisfaction to find under-served needs.
3. **Job stories** (popularised at Intercom). Write requirements as *When [situation], I want to [motivation], so I can [expected outcome].*

### The forces of progress (Moesta)
Whether someone switches depends on four forces:
- **Push** of the current situation, and **pull** of the new solution, drive change.
- **Anxiety** about the new solution, and **habit** of the present, resist it.

## Core Principles
- **The circumstance defines the job.** The same person hires different products in different situations.
- **Your real competition is whatever gets hired for the job,** including doing nothing or a workaround.
- **Jobs are stable; solutions change.** The job of getting to work has existed far longer than any vehicle.
- **Switching requires push and pull to outweigh anxiety and habit.** Reducing anxiety can matter as much as adding features.
- **Describe outcomes, not features.** "Minimise the time to find the right file" outlives any particular search feature.

## Applications & Use Cases
| Use Case | Application | School |
|---|---|---|
| Product discovery | Interview recent switchers about the moment they decided | Jobs as progress |
| Feature prioritisation | Rank desired outcomes by importance and satisfaction | Outcome-Driven Innovation |
| Writing requirements | Express needs as job stories instead of persona stories | Job stories |
| Competitive analysis | List everything customers hire for the same job | Jobs as progress |
| Positioning and messaging | Speak to the circumstance and the progress sought | All |
| Reducing churn | Learn what job the product is being fired from, and for what | Jobs as progress |

## Usage Guidelines
- **Name the school you are using**, since methods and outputs differ.
- **Interview people who recently switched**, in or out, and reconstruct the timeline of their decision in detail.
- **Separate the job from the solution.** If a statement names your product or a feature, it is not yet a job.
- **Capture functional, emotional and social dimensions**, since purely functional jobs miss much of why people choose.
- **Map the four forces** for each switching story, and look for anxiety and habit as well as push and pull.

## Prompt Template
```
You are applying Jobs-to-be-Done. School: [[jobs-as-progress | outcome-driven innovation | job stories]]

CIRCUMSTANCE: [[when and where the struggle happens]]
THE JOB
- Functional:
- Emotional:
- Social:

WHAT ELSE GETS HIRED (including doing nothing):

FORCES OF PROGRESS
- Push of the current situation:
- Pull of the new solution:
- Anxiety about switching:
- Habit of the present:

JOB STORY: When [situation], I want to [motivation], so I can [expected outcome].

OUTPUT: the job, the real competition, and which force to strengthen or weaken.
```

## Ethical Guidelines
- **Represent what customers actually said.** Do not invent jobs and attribute them to research.
- **Protect interviewees.** Switch interviews gather personal detail; handle it with consent and care.
- **Do not exploit anxiety.** Understanding a customer's fears is for reducing them, not amplifying them.

## Testing Strategy
- Validate jobs against real behavior, not stated preferences alone.
- Check whether solutions designed for a job change switching or retention.
- For outcome-driven work, re-survey importance and satisfaction after changes ship.

## Success Metrics
- Conversion or adoption among people in the target circumstance.
- Retention, showing the product keeps getting hired.
- Movement in satisfaction on the prioritised desired outcomes.
- Switching away from the alternatives you identified.

## Collaboration Protocol
- Inbound from: `product-strategist` · `user-researcher` · `market-analyst` · `innovation-researcher`
- Outbound to: `behavioral-designer` for designing around the forces of progress
- Cross-framework: Lean Startup for testing whether a solution does the job; Fogg Behavior Model for the moment of action; Self-Determination Theory for the emotional dimension.

## Related Skills
- `composable-skills/frameworks/lean-startup/SKILL.md` — validate that a solution does the job
- `composable-skills/frameworks/user-journey-mapping/SKILL.md` — the circumstances around the job
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — the moment the job triggers action
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — emotional dimensions of progress

## Reference Materials
- Christensen, C.M., Hall, T., Dillon, K., & Duncan, D.S. (2016). *Competing Against Luck: The Story of Innovation and Customer Choice.* Harper Business.
- Christensen, C.M., Hall, T., Dillon, K., & Duncan, D.S. (2016). "Know Your Customers' 'Jobs to Be Done'." *Harvard Business Review*, September 2016.
- Ulwick, A.W. (2016). *Jobs to Be Done: Theory to Practice.* Idea Bite Press.
- Moesta, B., with Engle, G. (2020). *Demand-Side Sales 101: Stop Selling and Help Your Customers Make Progress.* Lioncrest.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
