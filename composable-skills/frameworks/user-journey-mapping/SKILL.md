---
skill_id: user-journey-mapping
name: User Journey Mapping
version: 2.0.0
category: design-ux
type: framework
frameworks: []
triggers:
  - user journey map
  - customer journey mapping
  - map the experience
  - pain points across the journey
  - service blueprint
collaborates_with:
  - ux-researcher
  - user-researcher
  - product-strategist
  - ui-designer
ethics_required: true
priority: high
tags: [design-ux, framework, journey-mapping, service-design, research]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# User Journey Mapping

## Purpose
Use a journey map to visualise the experience a specific person has while trying to achieve a goal, across every stage and channel, including what they do, think and feel. Its value is perspective: it shows the experience end to end from the customer's side, where organisations usually see it in departmental pieces. A journey map built on research reveals the moments that matter most; one built on assumptions only illustrates what the team already believed.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `user-journey-mapping` |
| Category | Design and UX — Experience Mapping |
| Version | 2.0.0 |
| Nature | An established UX and service-design practice |
| Key references | Kalbach, *Mapping Experiences* (2016) · Nielsen Norman Group journey-mapping guidance |
| Related method | Service blueprint (Shostack, *HBR*, 1984), which adds the behind-the-scenes processes |

## The Components
- **Actor**: one specific persona or user type.
- **Scenario and expectations**: the goal and what the person expects.
- **Phases**: the high-level stages of the journey.
- **Actions, thoughts and emotions** at each phase, often shown as an emotional curve.
- **Touchpoints and channels** where interaction happens.
- **Opportunities**: insights and owners for improvement.

## Core Principles
- **One actor, one scenario per map.** Mixing personas blurs the insight.
- **Base it on research**, not assumptions; label any assumption-based map as a hypothesis.
- **Include emotions and thoughts**, not only actions.
- **Show the whole journey across channels**, including steps outside your product.
- **End with owned opportunities**, or the map becomes wall art.

## Applications & Use Cases
| Use Case | Application | Focus |
|---|---|---|
| Onboarding redesign | Map the first days from sign-up to value | Emotional low points |
| Churn investigation | Map the journey of users who left | Where they gave up |
| Cross-channel service | Show handoffs between web, phone and in person | Touchpoints |
| Aligning departments | A shared view of the customer's experience | Whole journey |
| Prioritising improvements | Rank opportunities by impact | Opportunities |
| Service redesign | Extend into a service blueprint | Backstage processes |

## Usage Guidelines
- **Choose one actor and one scenario.**
- **Gather evidence** from interviews, analytics, support tickets and observation.
- **Map phases, then actions, thoughts, emotions and touchpoints** for each.
- **Mark the moments of highest friction and highest importance.**
- **Turn insights into opportunities** with owners and measures.

## Prompt Template
```
You are building a journey map.

ACTOR: [[one specific persona]]
SCENARIO AND EXPECTATIONS: [[goal]]
EVIDENCE USED: interviews · analytics · support data · observation (label assumptions)
FOR EACH PHASE: actions · thoughts · emotions · touchpoints · pain points
MOMENTS THAT MATTER:
OPPORTUNITIES, each with an owner and a measure:
```

## Ethical Guidelines
- **Protect research participants** and anonymise the data behind the map.
- **Represent users' experiences faithfully**, including uncomfortable findings.

## Testing Strategy
- Validate the map with users from the persona.
- Measure the effect of changes at the targeted moments.

## Success Metrics
- Opportunities acted on.
- Improvement at the mapped pain points, such as completion or satisfaction.

## Collaboration Protocol
- Inbound from: `ux-researcher` · `user-researcher` · `product-strategist`
- Outbound to: `ui-designer` for changes at key moments
- Cross-framework: Jobs-to-be-Done for the goal behind the journey; design thinking for generating solutions; SUS for measuring perceived usability.

## Related Skills
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — the goal behind the journey
- `composable-skills/frameworks/design-thinking/SKILL.md` — generating solutions
- `composable-skills/frameworks/nielsen-heuristics/SKILL.md` — evaluating touchpoints

## Reference Materials
- Kalbach, J. (2016). *Mapping Experiences.* O'Reilly Media (2nd ed. 2020).
- Shostack, G.L. (1984). "Designing Services That Deliver." *Harvard Business Review*, January 1984.
- Nielsen Norman Group. Journey mapping guidance. nngroup.com.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
