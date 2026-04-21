# Maxim Skill — Design

> Layer 1 — Supreme Authority | Executive Office: CPO

## Domain

UX design, interaction design, user journeys, accessibility auditing, onboarding flows, and visual design execution. The "how users think and flow through an interface" domain — distinct from design-system (tokens/components) and ui-styling (CSS implementation).

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`product-strategist` — CPO Office

## Active Agents

- `ui-designer` — UI design, visual design, component design, visual storytelling (absorbs `visual-storyteller` via Op-D: Visual Storytelling mode)
- `ux-researcher` — UX research, user journey mapping, usability research, generative research (absorbs `user-researcher` + `usability-tester` via Op-D: Generative · Evaluative · Synthesis modes)
- `onboarding-designer` — onboarding flow design, first-run experience, activation journey
- `accessibility-auditor` — WCAG 2.1 AA auditing, inclusive design, assistive technology compatibility

**Op-C Skill DNA mode (embedded in design/SKILL.md):**
- Mode: Whimsy Layer — from `whimsy-injector`

## Skill Modes

Sub-skill SKILL.md files per specialist. Key modes:
- `ui-designer` → Visual Design · Component Design · Visual Storytelling (Op-D: absorbed from `visual-storyteller`)
- `ux-researcher` → Generative · Evaluative · Synthesis (Op-D: absorbed from `user-researcher` · `usability-tester`)
- `onboarding-designer` → First-Run · Activation Journey · Contextual Onboarding
- `accessibility-auditor` → WCAG Audit · Inclusive Design · AT Compatibility
- Design/SKILL.md → Whimsy Layer (Op-C: absorbed from `whimsy-injector`)

## Ethics Gate

None. Standard Maxim behavioral output quality applies.
Note: `accessibility-auditor` outputs always reference WCAG 2.1 AA as minimum compliance baseline. When design decisions involve user data collection → compliance skill auto-looped (CSO auto-loop rule).

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/product-team/` — UX research templates, user journey frameworks, accessibility audit patterns
- `community-packs/ui-ux-pro-max/.claude/skills/design/` — advanced UI/UX execution patterns, interaction design references

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the design skill:

- `UX research`, `user journey`, `usability research`, `UX insights`
- `user research`, `user interviews`, `ethnographic study`, `user insights`
- `usability test`, `user testing`, `heuristic evaluation`, `usability issues`
- `UI design`, `visual design`, `design system`, `component design`
- `visual storytelling`, `infographics`, `presentations`, `visual narrative`
- `onboarding flow`, `first-run experience`, `activation journey`, `user activation`
- `accessibility audit`, `WCAG`, `inclusive design`, `screen reader`
- `user flow`, `user journey map`, `information architecture`, `wireframe`

## Cross-Agent Auto-Loops

When design skill activates, the following agents are auto-notified:

- `ui-designer` — CPO lead for all visual design outputs
- `ux-researcher` — auto-looped for user research and journey validation
- `behavior-science-persuasion` skill — auto-looped for UX behavioral trigger validation
- `design-system` skill — auto-looped when design outputs require token or component governance
- `ui-styling` skill — auto-looped when design requires CSS or Tailwind implementation
- `accessibility-auditor` — auto-looped on all UI outputs for WCAG compliance check
- `ui-ux-pro-max` skill — escalated to master design intelligence when task spans multiple design sub-domains

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | design | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
