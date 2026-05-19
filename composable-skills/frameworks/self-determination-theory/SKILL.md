---
skill_id: self-determination-theory
name: Self-Determination Theory (SDT)
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply self-determination theory
  - use SDT
  - intrinsic motivation analysis
  - autonomy competence relatedness
  - extrinsic vs intrinsic motivation
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - ux-researcher
  - product-strategist
  - onboarding-designer
ethics_required: true
priority: high
tags: [behavior-science, framework, motivation, intrinsic-motivation]
adr: ADR-007
created: 2026-05-19
updated: 2026-05-19
---

# Self-Determination Theory (SDT)

## Purpose
Apply Self-Determination Theory to design experiences that strengthen intrinsic motivation rather than extrinsic carrot-and-stick conditioning. SDT fills a gap that Fogg + COM-B do not address: WHY people sustain effortful behavior over years, not just whether they perform it once. Closes the long-term-engagement gap that gamification and reward-loop products consistently miss.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `self-determination-theory` |
| Category | Behavior Science — Motivation (Intrinsic) |
| Version | 1.0.0 |
| Originators | Edward Deci & Richard Ryan (1985; ongoing) |
| Maturity | Established — 40+ years of cross-cultural empirical validation |
| Primary references | Deci & Ryan "Intrinsic Motivation and Self-Determination in Human Behavior" (1985) · selfdeterminationtheory.org |

## The Three Innate Psychological Needs

SDT posits that humans have three innate, universal psychological needs. Behavior change that violates any of them is unsustainable; behavior change that satisfies all three is self-perpetuating.

1. **Autonomy** — sense that one's actions are self-endorsed and self-chosen (NOT the same as independence; one can be autonomously interdependent)
2. **Competence** — sense of effectiveness and mastery in one's interactions with the environment
3. **Relatedness** — sense of belonging, mutual care, and connection with others

When all three needs are met, intrinsic motivation flourishes. When any are thwarted, motivation degrades — first to extrinsic (carrot-and-stick), then to amotivation (apathy).

## The Motivation Continuum (Organismic Integration Theory sub-theory)

SDT distinguishes 6 regulation types along a continuum:

```
Amotivation → External regulation → Introjected → Identified → Integrated → Intrinsic
(no agency)   (carrot/stick)        (guilt/shame)  (valued)     (self-aligned) (joy/flow)
```

Identified and integrated regulation are nearly as sustainable as intrinsic — the practical product target is "identified" or higher.

## Prompt Template
```
You are applying Self-Determination Theory (SDT).

CONTEXT:
- Target behavior or product experience: [[description]]
- Current motivational design (if any): [[approach]]

NEEDS DIAGNOSIS:
1. Autonomy — does the design honor the user's volition, or coerce/pressure them?
2. Competence — does the design support feelings of effectiveness, or undermine them?
3. Relatedness — does the design connect the user to others meaningfully, or isolate?

REGULATION TYPE DIAGNOSIS:
- What current regulation type does the design produce? (Amotivation → External → Introjected → Identified → Integrated → Intrinsic)
- What regulation type does the operator WANT to produce?

DESIGN PRESCRIPTIONS:
- Autonomy supports:   meaningful choices · rationale provision · acknowledge perspectives · minimize controlling language
- Competence supports: optimal challenge · informational feedback · skill-building progression
- Relatedness supports: warm acknowledgment · authentic connection · mutual care signals

OUTPUT:
- Need-satisfaction audit of the current design
- Regulation-type diagnosis (current vs target)
- Specific design changes to shift toward intrinsic regulation
- Anti-patterns flagged (controlling language · contingent rewards · social comparison · ego-involvement)
```

## Core Principles
- **Need-satisfaction is universal but contextually expressed.** All humans need autonomy, competence, relatedness; cultures express the needs differently.
- **Extrinsic rewards undermine intrinsic motivation** for already-interesting tasks (the famous "overjustification effect"). Use rewards strategically — not for tasks people would do anyway.
- **Controlling language degrades autonomy** even when ostensibly motivational. "You should..." and "You have to..." trigger reactance.
- **Informational feedback supports competence; evaluative feedback undermines it.** "Here's what worked..." beats "Good job!"
- **Identified regulation is the practical target.** Pure intrinsic ("I do this for the joy of it") is rare; identified ("I do this because it's important to me") is sustainable and achievable through design.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Onboarding design | Reduce controlling language; emphasize user choice + value | Higher activation and retention |
| Gamification | Avoid pure-reward loops; add competence-supportive feedback | Sustainable engagement |
| Learning products | Build optimal-challenge progression with informational feedback | Higher completion + skill transfer |
| Habit-formation features | Frame around identified regulation, not external pressure | Lower 90-day churn |
| Workplace productivity tools | Honor autonomy in workflow choices | Reduced burnout signal + better adoption |
| Health products | Patient-centered language vs prescriptive | Better adherence over time |

## Reference Materials
- Deci, E. & Ryan, R. (1985). *Intrinsic Motivation and Self-Determination in Human Behavior.* Plenum.
- Ryan, R. & Deci, E. (2017). *Self-Determination Theory: Basic Psychological Needs in Motivation, Development, and Wellness.* Guilford Press.
- Center for Self-Determination Theory — https://selfdeterminationtheory.org/

## Usage Guidelines
- Diagnose need-satisfaction in user research, not just outcome metrics. NPS doesn't reveal autonomy thwarting; qualitative interviews do.
- Audit copy for controlling language (should · must · have to · need to · supposed to) — replace with autonomy-supportive language (can · could · might consider · invite you to).
- Avoid contingent rewards for tasks users find intrinsically interesting — the reward will eventually undermine the interest.
- Pair with Fogg Behavior Model (moment-of-action) and TTM (stage-of-change) for full motivational design.

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `ux-researcher` · `habit-formation-coach` · `onboarding-designer`
- Outbound to: same agents + `content-strategist` for copy audit
- Cross-framework: pairs with TTM (regulation type by stage) and COM-B (Motivation component)

## Ethical Guidelines
- Need-satisfaction is intrinsically prosocial. SDT's design patterns AND its ethics point the same direction.
- Beware: gamification + reward loops that satisfy competence transiently while undermining autonomy long-term are SDT violations even if metrics rise.
- Manipulating users via fake autonomy (illusory choice + manufactured competence + parasocial relatedness) is unethical regardless of behavioral outcome.

## Success Metrics
- Need-satisfaction survey instruments (BPNSFS · Work-related Basic Need Satisfaction Scale) for diagnostic
- Long-term retention (12+ months) as proxy for intrinsic regulation
- Reduction in pressure-related metrics (cortisol proxies · self-reported stress) for workplace contexts

## Related Skills
- `composable-skills/frameworks/transtheoretical-model/SKILL.md` — regulation type shifts across TTM stages
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Motivation component overlaps with SDT need-satisfaction
- `composable-skills/frameworks/com-b-model/SKILL.md` — Motivation component is informed by SDT
- `composable-skills/frameworks/hook-model/SKILL.md` — Hook Model's variable-reward pattern can violate SDT autonomy; warn explicitly

## Testing Strategy
- A/B test autonomy-supportive vs controlling language with matched populations; measure both immediate conversion AND 90-day retention
- Expected effect: short-term conversion may be similar; long-term retention diverges 20–40%
- Need-satisfaction survey deltas are leading indicators for the long-term split

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in WS6a of v1.2.0 sprint (2026-05-19). One of 4 HIGH-priority behavioral frameworks per FRAMEWORK_ROADMAP § v1.2.E._
