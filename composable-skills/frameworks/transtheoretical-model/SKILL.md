---
skill_id: transtheoretical-model
name: Transtheoretical Model (TTM / Stages of Change)
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply transtheoretical model
  - use stages of change
  - TTM analysis
  - readiness to change
  - precontemplation contemplation preparation action maintenance
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - conversion-optimizer
  - nudge-architect
  - product-strategist
ethics_required: true
priority: high
tags: [behavior-science, framework, motivation, change-management]
adr: ADR-007
created: 2026-05-19
updated: 2026-05-19
---

# Transtheoretical Model (TTM / Stages of Change)

## Purpose
Apply the Transtheoretical Model to design interventions calibrated to where a person currently sits in the change cycle. Most behavior-change failures come from applying action-stage tactics (sign up · convert · do it) to precontemplation-stage subjects (didn't know they had the problem yet) — TTM forces the intervention to match the stage. Complements Fogg Behavior Model + COM-B by adding temporal sequencing.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `transtheoretical-model` |
| Category | Behavior Science — Motivation / Change Management |
| Version | 1.0.0 |
| Originators | James Prochaska & Carlo DiClemente (1977; expanded with John Norcross) |
| Maturity | Established — 40+ years of empirical validation, ~1000+ peer-reviewed studies |
| Primary references | Prochaska & DiClemente "Stages of Change in the Modification of Problem Behaviors" (1992) · uri.edu/cprc/transtheoretical-model |

## The Five Stages

1. **Precontemplation** — not aware of problem · no intention to change in next 6 months · resistant to information
2. **Contemplation** — aware of problem · weighing pros and cons · ambivalent · intention to change within 6 months
3. **Preparation** — decided to change · planning small steps · intention to act within 30 days
4. **Action** — actively modifying behavior · 0–6 months of new behavior
5. **Maintenance** — sustaining new behavior · 6+ months · vulnerable to relapse
6. **(Termination)** — habit fully internalized · no relapse risk · often considered the asymptotic 6th stage

## Prompt Template
```
You are applying the Transtheoretical Model (TTM / Stages of Change).

CONTEXT:
- Behavior under consideration: [[behavior_description]]
- Target population: [[population]]
- Current intervention design (if any): [[intervention]]

STAGE DIAGNOSIS:
1. Estimate the dominant stage of the population (precontemplation / contemplation / preparation / action / maintenance)
2. Identify the stage-distribution split (typical: 40% precontemplation / 40% contemplation / 20% preparation+action)
3. Diagnose which stage the current intervention is calibrated for
4. Flag the mismatch (if any) between intervention design and population stage

STAGE-MATCHED INTERVENTION:
- Precontemplation:  Consciousness-raising · dramatic relief · environmental reevaluation
- Contemplation:     Self-reevaluation · weighing pros/cons (decisional balance) · self-liberation
- Preparation:       Helping relationships · self-efficacy reinforcement · commitment devices
- Action:            Reinforcement management · counterconditioning · stimulus control
- Maintenance:       Relapse prevention · social support · environmental supports

OUTPUT:
- Stage diagnosis with confidence band
- Intervention-stage mismatch (if present)
- Stage-matched intervention recommendations (per the 10 processes of change)
- Decisional balance worksheet for contemplators
```

## Core Principles
- **Stage-matched intervention beats universal intervention.** A "just sign up" CTA to precontemplators is ~10x less effective than consciousness-raising for the same population.
- **The 10 processes of change map to stages.** Cognitive/affective processes dominate early stages; behavioral processes dominate later.
- **Movement is non-linear.** Relapse is part of the cycle, not failure. Maintenance-stage subjects can cycle back to contemplation; design for re-entry.
- **Decisional balance** (pros vs cons of change) shifts predictably across stages — interventions can directly influence it.
- **Self-efficacy** rises through the stages; tracking it is a leading indicator of stage transition.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Onboarding sequencing | Different first-touch content for precontemplators vs preparators | Higher activation rate |
| Email nurture design | Sequence emails by stage signals (engagement · clicks · time) | Better long-cycle conversion |
| Health-behavior products | Calibrate prompts to user's current stage | Higher retention + outcomes |
| Compliance training | Match training content to organizational change stage | Better policy adoption |
| Habit-formation features | Action + maintenance stage support patterns | Reduced churn at habit-vulnerable points |

## Reference Materials
- Prochaska, J. & DiClemente, C. (1992). "Stages of Change in the Modification of Problem Behaviors." *Progress in Behavior Modification* 28: 183–218.
- Norcross, J., Krebs, P., & Prochaska, J. (2011). "Stages of Change." *Journal of Clinical Psychology* 67(2): 143–154.
- University of Rhode Island Cancer Prevention Research Center — https://web.uri.edu/cprc/transtheoretical-model/

## Usage Guidelines
- Diagnose stage BEFORE designing intervention. Skipping diagnosis defaults the intervention to action-stage assumptions.
- Survey instruments: URICA (University of Rhode Island Change Assessment Scale) for clinical contexts; behavioral signals (engagement events) for product contexts.
- Track stage transitions, not just outcomes — stage transition is a leading indicator of long-term behavior change.

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `conversion-optimizer` · `nudge-architect` · `habit-formation-coach`
- Outbound to: same agents for stage-matched intervention implementation
- Cross-framework: pairs with Fogg Behavior Model (Motivation × Ability × Prompt fits stage-specific) and COM-B (Capability gaps differ by stage)

## Ethical Guidelines
- Stage diagnosis must be based on observable signals + self-report, not assumption
- Manipulating subjects from precontemplation directly to action via dark patterns is unethical regardless of behavioral outcome
- Maintenance-stage relapse must not be framed as user failure; the model explicitly normalizes relapse as part of the cycle

## Success Metrics
- Stage-transition rate (% of population advancing one stage per period)
- Stage-appropriate engagement (e.g., contemplators reading decisional-balance content)
- Long-term outcome metrics — TTM's value shows over 12+ months, not 12 days

## Related Skills
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — moment-of-action overlay on TTM stages
- `composable-skills/frameworks/com-b-model/SKILL.md` — Capability + Opportunity gaps by stage
- `composable-skills/frameworks/east-framework/SKILL.md` — make stage-appropriate intervention Easy + Attractive + Social + Timely
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — intrinsic motivation rises through TTM stages

## Testing Strategy
- A/B test stage-matched vs universal intervention with a population sample diagnosed via URICA or behavioral proxy
- Expected effect size: 15–30% lift in stage-transition rate when intervention matches stage vs random assignment

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in WS6a of v1.2.0 sprint (2026-05-19). One of 4 HIGH-priority behavioral frameworks per FRAMEWORK_ROADMAP § v1.2.E._
