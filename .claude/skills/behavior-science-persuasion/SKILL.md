---
skill_id: behavior-science-persuasion
name: Behavior Science & Persuasion
version: 1.0.0
category: behavior-science-persuasion
office: CEO + CMO
lead_agent: behavioral-designer
triggers:
  - behavioral science
  - persuasion
  - nudge
  - habit
  - conversion
  - influence
  - negotiation
  - cognitive bias
  - choice architecture
  - decision framing
  - social proof
  - Cialdini
  - Fogg Behavior Model
  - COM-B
  - EAST framework
  - Hook Model
collaborates_with:
  - influence-strategist
  - conversion-optimizer
  - content-strategist
  - security-analyst
  - compliance
---

# Behavior Science & Persuasion -- Domain Dispatcher

> Office: CEO (influence/negotiation agents) + CMO (persuasion agents) | Lead: behavioral-designer
> Sub-skills: 8 | Frameworks: Fogg Behavior Model, COM-B, EAST, Hook Model, Cialdini's 6 Principles, Elaboration Likelihood Model, Nudge Theory

## Purpose

The behavioral science backbone of Maxim -- every other skill proactively loops here for psychological validation of outputs. This domain applies behavioral economics, cognitive bias application, decision architecture, and ethical persuasion frameworks to every task that touches human motivation, decision-making, or behavior change. All persuasion outputs are gated by documents/governance/ETHICAL_GUIDELINES.md to prohibit dark patterns and manipulation.

## Sub-Skill Routing

| Task Signal | Routes To | SKILL.md Path |
|---|---|---|
| behavior change, friction reduction, motivation mapping | behavioral-designer | behavioral-designer/SKILL.md |
| conversion rate, funnel psychology, CRO | conversion-optimizer | conversion-optimizer/SKILL.md |
| choice architecture, cognitive bias mitigation, System 1/2 | decision-architect | decision-architect/SKILL.md |
| habit loop, cue-routine-reward, engagement loop | habit-formation-coach | habit-formation-coach/SKILL.md |
| strategic influence, coalition building, stakeholder mapping | influence-strategist | influence-strategist/SKILL.md |
| BATNA, principled negotiation, deal structuring | negotiation-specialist | negotiation-specialist/SKILL.md |
| default options, opt-in/opt-out, choice environment | nudge-architect | nudge-architect/SKILL.md |
| persuasive copy, social proof, scarcity, sales messaging | persuasion-specialist | persuasion-specialist/SKILL.md |

## Activation

This domain activates when:
- User invokes `/mxm-behavior`
- Task contains keywords: behavioral science, persuasion, nudge, habit, conversion, influence, negotiation, cognitive bias, choice architecture, decision framing, social proof, Cialdini, Fogg, COM-B, EAST, Hook Model
- Executive router detects behavior change, motivation, or persuasion signals
- Other Maxim skills proactively loop here: marketing (campaign psychology), design (UX behavioral triggers), content-creation (persuasive copy), slides (investor psychology)

## Behavioral Layer

- Confidence: 🟢 HIGH (Maxim skill + external knowledge merged)
- Compliance: reads project-manifest.json before decisions
- Handoff: writes .mxm-skills/agents-handoff.md on completion
- Ethics gate: `ethics_required: true` on ALL 8 agents -- no dark patterns, no manipulation bypassing informed consent
- Frameworks: Fogg Behavior Model, COM-B, EAST Framework, Hook Model, Cialdini's 6 Principles, Elaboration Likelihood Model, Nudge Theory, Kahneman System 1/2, AIDA (conversion contexts)

## External Sources

- Primary: community-packs/claude-skills-library/c-level-advisor/ (executive influence patterns)
- Secondary: community-packs/claude-skills-library/business-growth/ (growth psychology, retention behavior science)
- Conflict resolution: Maxim ALWAYS WINS

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
