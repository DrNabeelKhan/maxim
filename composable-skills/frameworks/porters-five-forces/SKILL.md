---
skill_id: porters-five-forces
name: Porter's Five Forces
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - porter's five forces
  - industry analysis
  - competitive forces
  - is this market attractive
  - industry structure
collaborates_with:
  - market-analyst
  - competitive-analyst
  - product-strategist
  - innovation-researcher
ethics_required: false
priority: high
tags: [product-research, framework, strategy, competition, industry-analysis]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Porter's Five Forces

## Purpose
Use the Five Forces to understand the structure of an industry and why it is more or less profitable. Michael Porter argued in 1979 that competition for profits extends beyond direct rivals to four other forces: new entrants, suppliers, buyers and substitutes. Their combined strength sets how much of the value an industry creates its players can keep, and analysing them shows where a company can position itself or reshape the forces in its favour.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `porters-five-forces` |
| Category | Product Research — Competitive Strategy |
| Version | 2.0.0 |
| Originator | Michael E. Porter, Harvard Business School |
| First published | 1979 |
| Primary references | Porter, *HBR* (1979; updated 2008) · *Competitive Strategy* (1980) |

## The Five Forces
1. **Threat of new entrants**: shaped by barriers such as economies of scale, switching costs, capital needs and regulation.
2. **Bargaining power of suppliers**: high when suppliers are concentrated or their input is hard to replace.
3. **Bargaining power of buyers**: high when buyers are concentrated, price-sensitive or can switch easily.
4. **Threat of substitutes**: products from outside the industry that meet the same need.
5. **Rivalry among existing competitors**: intensity of competition on price, product and marketing.

Porter's 2008 update notes that factors such as government, technology and complementary products are not forces in themselves; they matter through their effect on the five.

## Core Principles
- **Define the industry correctly.** The analysis depends on drawing the boundary in the right place.
- **The strongest forces determine profitability.**
- **Substitutes are often underestimated** because they come from outside the industry.
- **Analyse structure, not snapshots.** Look at what drives each force and how it is changing.
- **Use it to choose a position**, where the forces are weakest, or to reshape them.

## Applications & Use Cases
| Use Case | Application | Force often decisive |
|---|---|---|
| Market entry decisions | Assess barriers and incumbent reactions | New entrants |
| Pricing strategy | Understand buyer power and switching costs | Buyers |
| Supplier strategy | Identify dependency and alternatives | Suppliers |
| Product strategy | Map substitutes that meet the same need | Substitutes |
| Investment analysis | Judge long-run industry profitability | All |
| Competitive positioning | Find a position where forces are weakest | All |

## Usage Guidelines
- **Define the industry**: the product scope and geographic scope.
- **Assess each force** with evidence, rating it low, medium or high, and name its drivers.
- **Identify the strongest forces**, since they determine profitability.
- **Look at trends** that will strengthen or weaken each force.
- **Translate the analysis into strategy**: positioning, defences, or ways to reshape the forces.

## Prompt Template
```
You are applying Porter's Five Forces (Porter 1979, 2008).

INDUSTRY (product and geographic scope): [[...]]
FOR EACH FORCE — strength (low/medium/high), drivers, evidence, trend:
1. New entrants
2. Supplier power
3. Buyer power
4. Substitutes
5. Rivalry
STRONGEST FORCES:
STRATEGIC IMPLICATIONS: position, defend, or reshape?
```

## Ethical Guidelines
- **Gather competitive information legally and ethically.**
- **Do not use the analysis to coordinate with competitors**; that can breach competition law.

## Testing Strategy
- Check the analysis against actual industry profitability data where available.
- Revisit when a major trend, such as new technology or regulation, shifts a force.

## Success Metrics
- Quality of strategic decisions informed by the analysis.
- Accuracy of the predicted direction of each force over time.

## Collaboration Protocol
- Inbound from: `market-analyst` · `competitive-analyst` · `product-strategist`
- Outbound to: CEO office for strategy decisions
- Cross-framework: SWOT turns external analysis into options; TAM/SAM/SOM sizes the market; Jobs-to-be-Done reveals substitutes.

## Related Skills
- `composable-skills/frameworks/swot-analysis/SKILL.md` — combining internal and external analysis
- `composable-skills/frameworks/tamsamsom/SKILL.md` — sizing the market
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — substitutes through the job lens

## Reference Materials
- Porter, M.E. (1979). "How Competitive Forces Shape Strategy." *Harvard Business Review*, March–April 1979.
- Porter, M.E. (1980). *Competitive Strategy.* Free Press.
- Porter, M.E. (2008). "The Five Competitive Forces That Shape Strategy." *Harvard Business Review*, January 2008.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
