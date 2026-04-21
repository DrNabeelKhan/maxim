# Maxim Skill — Product Development Research

> Layer 1 — Supreme Authority | Executive Office: CPO + CINO

## Domain

Discovery research, competitive intelligence, market analysis, innovation scouting, R&D coordination, and data science validation. Dual-office domain: CPO leads product validation, CINO leads emerging technology and R&D horizon scanning.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`product-strategist` — CPO Office (product validation)
`innovation-researcher` — CINO Office (R&D and horizon scanning)

## Active Agents

- `product-strategist` — product strategy, product roadmap, go-to-market, product vision (CPO lead for validation)
- `competitive-analyst` — competitive analysis, competitor research, market positioning, benchmarking
- `market-analyst` — market analysis, market sizing (TAM/SAM/SOM), opportunity assessment, industry research
- `data-scientist` — data analysis, predictive modeling, A/B test analysis, ML-backed validation (CTO office, routes here for research validation)
- `innovation-researcher` — innovation research, emerging technology scouting, trend analysis, opportunity identification (CINO lead)
- `rd-coordinator` — R&D project coordination, research pipeline management, experiment design

## Skill Modes

Sub-skill SKILL.md files per specialist. Key modes:
- `product-strategist` → Strategy · Validation · GTM · Vision
- `competitive-analyst` → Deep Dive · Positioning · Benchmarking · SWOT
- `market-analyst` → TAM/SAM/SOM · Industry Scan · Opportunity Assessment
- `data-scientist` → Predictive · A/B Analysis · Segmentation · Modeling
- `innovation-researcher` → Horizon Scanning · Emerging Tech · Trend Analysis
- `rd-coordinator` → Pipeline · Experiment Design · Research Brief

## Ethics Gate

None. Standard Maxim behavioral output quality applies.
Note: When research involves user data, PII, or regulated market data → compliance skill auto-looped (CSO auto-loop rule).

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/product-team/` — product research frameworks, discovery patterns, user research templates
- `community-packs/claude-skills-library/ra-qm-team/` — research quality management, validation frameworks, data governance

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the product-development-research skill:

- `competitive analysis`, `competitor research`, `market positioning`, `benchmarking`
- `market analysis`, `market sizing`, `opportunity assessment`, `industry research`
- `product strategy`, `product roadmap`, `go-to-market`, `product vision`
- `innovation research`, `emerging technology`, `trend analysis`, `opportunity identification`
- `data analysis`, `predictive modeling`, `A/B test analysis`, `machine learning`
- `user research`, `discovery research`, `generative research`, `formative research`
- `TAM`, `SAM`, `SOM`, `Porter's Five Forces`, `SWOT`
- `R&D`, `research brief`, `experiment design`, `horizon scanning`

## Cross-Agent Auto-Loops

When product-development-research skill activates, the following agents are auto-notified:

- `product-strategist` — CPO lead for product validation outputs
- `innovation-researcher` — CINO lead for R&D and horizon scanning outputs
- `product` skill — auto-looped when research informs strategic product decisions
- `behavior-science-persuasion` skill — auto-looped for behavioral research validation
- `data-scientist` — auto-looped when quantitative analysis is required
- `security-analyst` — auto-looped if research involves user data or PII (CSO auto-loop rule)

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | product-development-research | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
