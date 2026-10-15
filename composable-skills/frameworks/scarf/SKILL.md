---
skill_id: scarf
name: SCARF Model
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply SCARF model
  - workplace psychology analysis
  - status certainty autonomy relatedness fairness
  - threat response analysis
  - psychological safety
collaborates_with:
  - behavioral-designer
  - habit-formation-coach
  - decision-architect
  - onboarding-designer
ethics_required: true
priority: medium
tags: [behavior-science, framework, workplace, neuroscience, social-threat]
adr: ADR-007
created: 2026-05-19
updated: 2026-10-15
---

# SCARF Model

## Purpose
Apply David Rock's SCARF model to diagnose social threat / reward responses in organizational, team, and product-experience contexts. SCARF identifies five domains the brain treats as primary social rewards or threats — Status · Certainty · Autonomy · Relatedness · Fairness. Rock (2008) proposes that these social domains engage brain networks similar to those for primary survival threats and rewards; how far the circuitry actually overlaps is debated in later research. Many "soft skill" failures and "engagement problems" can be read as SCARF threats.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `scarf` |
| Category | Behavior Science — Workplace / Social Neuroscience |
| Version | 1.0.0 |
| Originator | David Rock (NeuroLeadership Institute, 2008) |
| Maturity | Established — widely adopted in leadership development; grounded in social neuroscience research |
| Primary references | Rock, D. (2008) "SCARF: a brain-based model for collaborating with and influencing others." *NeuroLeadership Journal* · neuroleadership.com |

## The Five Domains

| Domain | Definition | Threat trigger | Reward trigger |
|---|---|---|---|
| **Status** | Relative importance to others | Demotion · public criticism · subordinate role assignment | Recognition · promotion · expertise acknowledgment |
| **Certainty** | Ability to predict the future | Ambiguity · unclear expectations · sudden change | Clear plans · transparency · process predictability |
| **Autonomy** | Sense of control over events | Micromanagement · forced compliance · removed choices | Genuine choice · self-directed work · trust |
| **Relatedness** | Sense of safety with others | Outsider treatment · isolation · in-group/out-group dynamics | Shared identity · mentorship · genuine acknowledgment |
| **Fairness** | Perception of equitable exchange | Unjust treatment · arbitrary decisions · favoritism | Transparent process · merit-based outcomes · acknowledged contribution |

Threats in any of the 5 domains activate withdrawal behavior, defensive reasoning, and reduced cognitive performance. Rewards drive engagement, creative thinking, and pro-social behavior.

## Prompt Template
```
You are applying the SCARF Model.

CONTEXT:
- Scenario: [[scenario description]]
- Stakeholders: [[list with roles]]

SCARF DIAGNOSIS:
For each domain, identify whether the scenario triggers:
- Status:      THREAT | NEUTRAL | REWARD · evidence
- Certainty:   THREAT | NEUTRAL | REWARD · evidence
- Autonomy:    THREAT | NEUTRAL | REWARD · evidence
- Relatedness: THREAT | NEUTRAL | REWARD · evidence
- Fairness:    THREAT | NEUTRAL | REWARD · evidence

PRIMARY THREAT (if any): <which domain is driving the response?>

INTERVENTION DESIGN:
- For each THREAT domain, propose specific mitigations
- For each REWARD opportunity missed, propose enhancements
- Avoid swapping threats (relieving Autonomy threat by introducing Certainty threat)
```

## Core Principles
- **Social threats and rewards are treated as primary.** Rock's model holds that SCARF triggers engage approach and avoidance responses, not just "preferences."
- **Threats weigh more than rewards.** Threat responses tend to be stronger and longer-lasting than reward responses (Baumeister et al., 2001, cited in Rock, 2008). Public criticism is a primary status threat.
- **Certainty matters more under stress.** Ambiguity adds load that overloaded people can least afford.
- **Autonomy doesn't mean independence.** It means perceived choice. Rock notes that even a subtle perception of autonomy helps, so small choices (workflow ordering · scheduling) count.
- **Relatedness is the in-group/out-group switch.** Signals of shared identity build relatedness; outsider treatment threatens it.
- **Unfairness triggers a strong threat response** (Rock 2008, citing Tabibnia & Lieberman 2007), so arbitrary decisions cost more trust than they appear to.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Organizational change announcements | Reduce Certainty + Autonomy threats via early communication + choices | Lower resistance to change |
| Performance feedback design | Status-protective framing + Fairness signals | Better receptivity to growth feedback |
| Onboarding programs | Maximize Relatedness early + provide Certainty about expectations | Higher retention + faster productivity |
| Product UX (settings · errors · onboarding) | Reduce Autonomy threats (default-overriding) and Certainty threats (ambiguous errors) | Lower abandonment |
| Team meetings | Fairness in airtime + Status acknowledgment for contributions | Better psychological safety |
| Sales conversations | Reduce Status threats (don't condescend); provide Certainty (clear next steps) | Better close rates |

## Reference Materials
- Rock, D. (2008). "SCARF: a brain-based model for collaborating with and influencing others." *NeuroLeadership Journal* 1, 44–52.
- Baumeister, R.F., Bratslavsky, E., Finkenauer, C., & Vohs, K.D. (2001). "Bad is stronger than good." *Review of General Psychology* 5(4), 323–370.
- Rock, D. (2009). *Your Brain at Work.* HarperBusiness.
- NeuroLeadership Institute — https://neuroleadership.com/

## Usage Guidelines
- Diagnose ALL 5 domains, not just the obvious one. The threat driving a reaction is often not the one the surface conversation is about (practitioner heuristic; which domains generate the strongest responses is an open research question in Rock 2008).
- Use language that signals reward, not just absence of threat. "You're doing great" (Status reward) beats "no concerns about your work" (Status neutral).
- For organizational change: front-load Certainty (clear timeline · what stays the same) + Autonomy (where employees have input).

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `decision-architect` · `onboarding-designer`
- Outbound to: same agents for intervention implementation
- Cross-framework: pairs with Self-Determination Theory (Autonomy domain overlap), Prospect Theory (Status threat is loss-frame relevant)

## Ethical Guidelines
- **SCARF-aware manipulation is dark patterning.** Engineering relatedness or status threats to coerce is unethical regardless of behavioral outcome.
- For organizational use: SCARF reveals the structural issues, not just the conversational ones. Patching SCARF threats while leaving the structural cause unaddressed is hollow.

## Success Metrics
- Threat-domain frequency reduction in pulse surveys (e.g., "fairness perception" tracked quarterly)
- Engagement metrics that distinguish proactive engagement vs anxiety-driven engagement
- Reduced turnover within 90 days of SCARF-informed interventions

## Related Skills
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — Autonomy domain overlap
- `composable-skills/frameworks/prospect-theory/SKILL.md` — Status threats are loss frames
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Motivation degradation under threat
- `composable-skills/frameworks/com-b-model/SKILL.md` — Capability + Motivation impact

## Testing Strategy
- Quarterly pulse surveys with SCARF-domain-specific questions
- A/B test communication styles (threat-reduced vs control) and measure response rates + sentiment
- Measure the lift in your own context; there is no established benchmark for SCARF-aware messaging

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in v1.2.0 final WS6b (2026-05-19)._
