# Maxim Skill — Behavior Science & Persuasion

> Layer 1 — Supreme Authority | Executive Office: CMO (persuasion agents) + CEO (influence/negotiation agents)

## Domain

Behavioral economics, cognitive bias application, decision architecture, and ethical persuasion frameworks. The behavioral science backbone of Maxim — every other skill proactively loops here for psychological validation of outputs.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`behavioral-designer` — CMO Office (persuasion agents)
`influence-strategist` — CEO Office (influence/negotiation agents)

## Active Agents

- `behavioral-designer` — behavior change design, friction reduction, motivation mapping (Fogg BM, COM-B, EAST)
- `conversion-optimizer` — conversion rate science, funnel psychology, ELM-based persuasion
- `decision-architect` — choice architecture design, cognitive bias mitigation, System 1/2 decision framing
- `habit-formation-coach` — habit loop design, Hook Model, cue-routine-reward engineering
- `nudge-architect` — choice environment design, default options, opt-in/opt-out architecture
- `persuasion-specialist` — persuasive copy, Cialdini's 6 Principles, influence audience, sales messaging
- `influence-strategist` — strategic influence at scale, partnership influence, organizational persuasion (CEO office)
- `negotiation-specialist` — negotiation frameworks, BATNA, principled negotiation (CEO office)

## Skill Modes

Sub-skill SKILL.md files per specialist. No root mode list — each specialist has its own SKILL.md.
Key specialist frameworks:
- `behavioral-designer` → Fogg Behavior Model · COM-B · EAST Framework
- `conversion-optimizer` → ELM · AIDA · Funnel Psychology
- `decision-architect` → Cognitive Biases · Kahneman System 1/2 · Choice Architecture
- `habit-formation-coach` → Hook Model · Cue-Routine-Reward · Behavioral Loops
- `nudge-architect` → Nudge Theory · Default Options · Opt-in Architecture
- `persuasion-specialist` → Cialdini's 6 Principles · Social Proof · Scarcity
- `influence-strategist` → Strategic Influence · Stakeholder Mapping · Coalition Building
- `negotiation-specialist` → BATNA · Principled Negotiation · Anchoring

## Ethics Gate

`ethics_required: true` — ALL 8 agents in this domain.
Ethical guidelines enforced on every output. Dark patterns are explicitly prohibited.
Persuasion outputs must align with documents/governance/ETHICAL_GUIDELINES.md:
- No manipulation that bypasses informed consent
- No exploitation of cognitive vulnerabilities for harmful outcomes
- No deceptive framing or false urgency creation
- All persuasion techniques must serve genuine user value

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/c-level-advisor/` — executive influence patterns, strategic persuasion at C-suite level
- `community-packs/claude-skills-library/business-growth/` — growth psychology, retention behavior science, engagement frameworks

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the behavior-science-persuasion skill:

- `design behavior change`, `create habit loop`, `reduce friction`, `increase motivation`
- `choice architecture`, `default options`, `nudge design`, `decision framing`
- `persuasive copy`, `influence audience`, `conversion copywriting`, `sales messaging`
- `behavioral science`, `cognitive bias`, `behavioral economics`
- `Fogg Behavior Model`, `COM-B`, `EAST framework`, `Hook Model`
- `Cialdini`, `social proof`, `scarcity`, `reciprocity`, `authority`
- `conversion rate`, `funnel optimization`, `CRO psychology`
- `habit formation`, `engagement loop`, `retention psychology`

## Cross-Agent Auto-Loops

When behavior-science-persuasion skill activates, the following agents are auto-notified:

- `behavioral-designer` — CMO lead for persuasion and behavior change outputs
- `conversion-optimizer` — auto-looped on all conversion and funnel optimization tasks
- `compliance` skill — auto-looped when persuasion techniques touch regulated industries or vulnerable populations (CSO auto-loop rule + ethics gate)
- `security-analyst` — auto-looped if behavioral data involves PII collection (CSO auto-loop rule)

**Note:** This skill is proactively looped BY other Maxim skills:
- Every `marketing` output → loops here for campaign psychology validation
- Every `design` output → loops here for UX behavioral trigger validation
- Every `content-creation` output → loops here for persuasive copy psychology
- Every `slides` output → loops here for investor/executive psychology

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | behavior-science-persuasion | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
