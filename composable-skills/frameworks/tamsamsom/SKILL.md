---
skill_id: tamsamsom
name: TAM/SAM/SOM
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - tam sam som
  - market sizing
  - total addressable market
  - how big is the market
  - bottom-up market size
collaborates_with:
  - market-analyst
  - product-strategist
  - innovation-researcher
  - competitive-analyst
ethics_required: true
priority: high
tags: [product-research, framework, market-sizing, fundraising, strategy]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# TAM/SAM/SOM

## Purpose
Use TAM, SAM and SOM to size a market in three nested layers: the whole demand for a solution, the part you can serve, and the part you can realistically win. The convention is standard in strategy and fundraising. Its real value is the reasoning it forces, about who exactly the customers are, how many there are and what they would pay, rather than the headline number, which is easy to inflate.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `tamsamsom` |
| Category | Product Research — Market Sizing |
| Version | 2.0.0 |
| Nature | A widely used convention with no single originating publication |
| Methods | Top-down (from industry data) · Bottom-up (from customer counts and prices) · Value theory |

## The Three Layers
- **TAM, Total Addressable Market**: total demand for the type of solution if you had every possible customer.
- **SAM, Serviceable Available Market**: the part of TAM your product and business model can actually serve, given geography, segment and channel.
- **SOM, Serviceable Obtainable Market**: the part of SAM you can realistically capture in a defined period, given competition and capacity.

### Two ways to estimate
- **Top-down**: start from an industry total and narrow it down. Fast, but easy to overstate.
- **Bottom-up**: count the customers you can reach and multiply by what they would pay. Slower and more credible.

## Core Principles
- **Bottom-up is more credible than top-down.** It shows you understand your customers.
- **Define the customer precisely** before counting them.
- **SOM is what matters for planning**; TAM sets the ceiling.
- **State every assumption** so others can check it.
- **Triangulate** by estimating more than one way and comparing.

## Applications & Use Cases
| Use Case | Application | Layer most scrutinised |
|---|---|---|
| Fundraising decks | Show a credible, bottom-up path to revenue | SAM, SOM |
| Market entry | Decide whether a segment is worth pursuing | SAM |
| Product prioritisation | Compare opportunities by obtainable size | SOM |
| Pricing and packaging | Test revenue per customer assumptions | All |
| Annual planning | Set realistic revenue targets | SOM |
| Investor due diligence | Check a company's claimed market size | TAM |

## Usage Guidelines
- **Define the target customer and the unit of purchase** first.
- **Build bottom-up**: number of reachable customers multiplied by annual value per customer.
- **Narrow TAM to SAM** with explicit filters such as geography and segment.
- **Estimate SOM from realistic share and capacity**, referencing comparable companies.
- **Cross-check against a top-down estimate** and explain any large gap.

## Prompt Template
```
You are sizing a market (TAM / SAM / SOM).

CUSTOMER DEFINITION: [[who buys, and the unit of purchase]]
BOTTOM-UP
- Reachable customers:        (source)
- Annual value per customer:  (source)
- TAM / SAM:
SAM FILTERS (geography, segment, channel):
SOM: realistic share x period, with comparables:
TOP-DOWN CROSS-CHECK and gap explanation:
ASSUMPTIONS, each labelled sourced or estimated:
```

## Ethical Guidelines
- **Do not inflate market size** to impress investors; misleading figures in fundraising can carry legal risk.
- **Label estimates as estimates** and cite every source.

## Testing Strategy
- Compare actual traction against the SOM forecast and revise the assumptions.
- Sensitivity-test the key assumptions.

## Success Metrics
- Accuracy of SOM forecasts against actual revenue.
- Share of assumptions backed by a source.

## Collaboration Protocol
- Inbound from: `market-analyst` · `product-strategist` · `innovation-researcher`
- Outbound to: CEO office for fundraising and planning
- Cross-framework: Porter's Five Forces for the attractiveness of the market; Jobs-to-be-Done for defining the customer.

## Related Skills
- `composable-skills/frameworks/porters-five-forces/SKILL.md` — market attractiveness
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — defining who the customer is
- `composable-skills/frameworks/no-fabrication/SKILL.md` — evidence-bound figures

## Reference Materials
- No single originating publication. The layered TAM / SAM / SOM convention is standard practice in venture finance and corporate strategy; follow the sourcing discipline above in place of a canonical text.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
