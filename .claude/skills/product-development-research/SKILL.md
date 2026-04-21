---
skill_id: product-development-research
name: Product Development Research
version: 1.0.0
category: product-development-research
office: CPO + CINO
lead_agent: product-strategist
triggers:
  - research
  - user research
  - market analysis
  - competitive analysis
  - data science
  - usability
  - innovation research
  - emerging technology
  - TAM
  - SAM
  - SOM
  - horizon scanning
  - R&D
collaborates_with:
  - competitive-analyst
  - data-scientist
  - innovation-researcher
  - market-analyst
  - product-strategist
  - rd-coordinator
  - usability-tester
  - user-researcher
  - security-analyst
---

# Product Development Research -- Domain Dispatcher

> Office: CPO + CINO | Lead: product-strategist (CPO validation), innovation-researcher (CINO R&D)
> Sub-skills: 8 | Frameworks: CRISP-DM, TAM/SAM/SOM, Porter's Five Forces, Design Thinking

## Purpose

Discovery research, competitive intelligence, market analysis, innovation scouting, R&D coordination, and data science validation. Dual-office domain: CPO leads product validation, CINO leads emerging technology and R&D horizon scanning. When research involves user data, PII, or regulated market data, the compliance skill is auto-looped via the CSO auto-loop rule.

## Sub-Skill Routing

| Task Signal | Routes To | SKILL.md Path |
|---|---|---|
| Competitive analysis, competitor research, market positioning | competitive-analyst | product-development-research/competitive-analyst/SKILL.md |
| Data analysis, predictive modeling, A/B test analysis, ML validation | data-scientist | product-development-research/data-scientist/SKILL.md |
| Innovation research, emerging tech scouting, trend analysis | innovation-researcher | product-development-research/innovation-researcher/SKILL.md |
| Market analysis, market sizing, opportunity assessment | market-analyst | product-development-research/market-analyst/SKILL.md |
| Product strategy, roadmap, go-to-market, product vision | product-strategist | product-development-research/product-strategist/SKILL.md |
| R&D project coordination, research pipeline, experiment design | rd-coordinator | product-development-research/rd-coordinator/SKILL.md |
| Usability testing, task analysis, heuristic evaluation | usability-tester | product-development-research/usability-tester/SKILL.md |
| User research, discovery research, generative research | user-researcher | product-development-research/user-researcher/SKILL.md |

## Activation

This domain activates when:
- User invokes `/mxm-cpo`
- Task contains keywords: research, user research, market analysis, competitive analysis, data science, usability, innovation research, emerging technology, TAM, SAM, SOM, Porter's Five Forces, SWOT, horizon scanning, R&D, experiment design, predictive modeling, A/B test

## Behavioral Layer

- Confidence: 🟢 HIGH
- Compliance: reads project-manifest.json
- Handoff: writes .mxm-skills/agents-handoff.md
- Frameworks: CRISP-DM, TAM/SAM/SOM, Porter's Five Forces, Design Thinking, SWOT

## External Sources

- Primary: community-packs/claude-skills-library/product-team/
- Secondary: community-packs/claude-skills-library/ra-qm-team/
- Merge rule: Maxim ALWAYS WINS -- behavioral science + proactive triggers + confidence tagging non-negotiable

---
*Maxim Product Development Research Skill -- Version 1.0.0*
*Maxim behavioral layer: ACTIVE | External merge: product-team + ra-qm-team ABSORBED | Confidence: 🟢 HIGH*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
