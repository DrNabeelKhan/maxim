---
skill_id: swot-analysis
name: SWOT Analysis
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - swot analysis
  - strengths weaknesses opportunities threats
  - tows matrix
  - strategic position
  - situational analysis
collaborates_with:
  - competitive-analyst
  - product-strategist
  - market-analyst
  - business-architect
ethics_required: false
priority: medium
tags: [product-research, framework, strategy, situational-analysis]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# SWOT Analysis

## Purpose
Use SWOT to take stock of a strategic position by setting internal **Strengths** and **Weaknesses** against external **Opportunities** and **Threats**. It is quick and widely understood, which makes it useful for shared discussion. Its well-known weakness is that it produces lists rather than decisions, so it is most useful when followed by the TOWS step, which turns the four lists into strategic options.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `swot-analysis` |
| Category | Product Research — Strategic Situation Analysis |
| Version | 2.0.0 |
| Origin | Disputed; commonly traced to 1960s work at Harvard Business School and the Stanford Research Institute |
| Extension | TOWS matrix, Weihrich, *Long Range Planning* (1982) |

## The Four Quadrants
- **Strengths** (internal, helpful): capabilities and resources that give an advantage.
- **Weaknesses** (internal, harmful): gaps and limitations.
- **Opportunities** (external, helpful): trends and openings in the environment.
- **Threats** (external, harmful): risks from competitors, regulation, technology or the market.

### TOWS — from lists to strategies
- **SO**: use strengths to pursue opportunities.
- **WO**: overcome weaknesses by taking opportunities.
- **ST**: use strengths to counter threats.
- **WT**: minimise weaknesses and avoid threats.

## Core Principles
- **Internal versus external is the key distinction.** Strengths and weaknesses are within your control; opportunities and threats are not.
- **Be specific and evidence-based.** "Strong brand" means little without evidence.
- **Relative, not absolute.** A strength matters only compared with competitors.
- **Prioritise.** A long list of equal items does not guide decisions.
- **Always finish with TOWS** so the analysis produces options.

## Applications & Use Cases
| Use Case | Application | Note |
|---|---|---|
| Strategy offsites | A shared starting picture for discussion | Follow with TOWS |
| Product reviews | Assess a product's position against competitors | Keep it comparative |
| Market entry | Weigh internal capability against the market | Pair with Five Forces |
| Personal or team planning | Quick self-assessment | Evidence over opinion |
| Investment memos | Summarise position and risks | Prioritise items |
| Annual planning | Refresh the picture and the strategic options | Track changes year to year |

## Usage Guidelines
- **Gather external analysis first**, for example Five Forces or market research, to inform opportunities and threats.
- **Make every item specific and supported by evidence.**
- **Rank items within each quadrant** by importance.
- **Build the TOWS matrix** to generate strategic options.
- **Select a few options to act on** with owners and measures.

## Prompt Template
```
You are running a SWOT and TOWS analysis (Weihrich 1982).

SUBJECT: [[company, product or unit]]   COMPARED WITH: [[main competitors]]
STRENGTHS (internal, with evidence, ranked):
WEAKNESSES (internal, ranked):
OPPORTUNITIES (external, ranked):
THREATS (external, ranked):
TOWS
- SO:
- WO:
- ST:
- WT:
CHOSEN OPTIONS, with owners:
```

## Ethical Guidelines
- **Be honest about weaknesses**; a flattering SWOT is useless and misleading.
- **Ground external claims in evidence**, not speculation about competitors.

## Testing Strategy
- Review past SWOTs against what actually happened, to improve judgment.

## Success Metrics
- Strategic options produced and acted on.
- Accuracy of identified threats and opportunities over time.

## Collaboration Protocol
- Inbound from: `competitive-analyst` · `market-analyst` · `product-strategist`
- Outbound to: CEO office for strategic choices
- Cross-framework: Porter's Five Forces informs the external quadrants; OKRs turn chosen options into goals.

## Related Skills
- `composable-skills/frameworks/porters-five-forces/SKILL.md` — external analysis
- `composable-skills/frameworks/okrs/SKILL.md` — turning options into goals
- `composable-skills/frameworks/cognitive-biases/SKILL.md` — guarding against optimism bias

## Reference Materials
- Weihrich, H. (1982). "The TOWS Matrix — A Tool for Situational Analysis." *Long Range Planning*, 15(2), 54–66.
- Learned, E.P., Christensen, C.R., Andrews, K.R., & Guth, W.D. (1965). *Business Policy: Text and Cases.* Irwin.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
