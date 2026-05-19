---
description: TIER 3 persona — early-stage technical founders, product-led founders, pre-seed → Series A. Dispatches to CEO enterprise-architect + CMO + CPO with Duarte Sparkline, Minto Pyramid, AARRR, Prospect Theory, Van Westendorp, Strategyzer toolkit, and MOAT_TRACKER-grounded competitive moat analysis.
---

# /mxm-founder

The founder persona surface (TIER 3 added v1.2.0). For early-stage technical founders, product-led founders, and operators running pre-seed → Series A companies. Maxim applies the Strategyzer toolkit + behavioral pricing + MOAT_TRACKER as routing logic — not as marketing copy.

## Usage

```
/mxm-founder <sub-command> <args>
```

Six sub-commands ship in v1.2.0. Each produces a concrete artifact founders actually use with investors, customers, and team — not a "founder advice" essay.

| Sub-command | What it produces | Primary agent | Frameworks |
|---|---|---|---|
| `pitch-deck <thesis>` | Investor deck: problem/solution/market/moat/traction/ask | CMO + CEO | Duarte Sparkline · Minto Pyramid · McKinsey Slide Logic · Dual Coding Theory |
| `gtm-plan <product>` | AARRR funnel + first-100-customers playbook | CMO `growth-hacker` + `gtm-strategist` | Pirate Metrics (AARRR) · HEART · Jobs-to-be-Done |
| `runway-model <expenses>` | Cash runway: burn · cohort LTV · breakeven · dilution | CEO `finance-analyst` (or `enterprise-architect`) | SaaS metrics · cohort analysis · dilution math |
| `pricing <product>` | Tiered pricing with behavioral grounding | CPO `pricing-strategist` (or `product-strategist`) | Prospect Theory · Van Westendorp · price laddering · Cialdini anchoring |
| `business-model-canvas` | BMC + Value Proposition Canvas pair | CEO `enterprise-architect` | Strategyzer (Osterwalder & Pigneur) |
| `competitive-moat` | 7-moat-type audit + defensibility timeline | CEO `enterprise-architect` + reads MOAT_TRACKER | 7 moat types (network effects · scale · brand · regulation · technology · switching costs · process power) |

---

## Sub-command details

### `/mxm-founder pitch-deck <thesis>`

Investor deck applying Duarte Sparkline narrative + Minto Pyramid logic + McKinsey slide structure + Dual Coding Theory (visual+verbal redundancy). Not a generic template — the framework choice signals craft to investors.

**Reads:** thesis (one-line investment story) · `documents/business/` (if traction docs exist) · `documents/ledgers/MOAT_TRACKER.md` · operator profile

**Output:** 12–16 slide structured outline:
```
Pitch Deck — <thesis>
────────────────────
SLIDE 1: Title           — company · thesis · ask amount
SLIDE 2: Problem         — Duarte "what is" baseline · costs of status quo
SLIDE 3: Insight         — Minto top-of-pyramid: the key reframing
SLIDE 4: Solution        — Duarte "what could be" gap · single demo image (Dual Coding)
SLIDE 5: How it works    — minimal architecture · 3-step user journey
SLIDE 6: Market          — TAM/SAM/SOM with sources · top-down + bottom-up reconciliation
SLIDE 7: Traction        — leading + lagging metrics · 6 months of trajectory
SLIDE 8: Business model  — revenue mechanism · unit economics · margin profile
SLIDE 9: Competition     — positioning grid · differentiation per axis
SLIDE 10: Moat           — 7-moat audit summary · which moat is forming · evidence
SLIDE 11: Team           — relevant credentials only · gap-filling hires planned
SLIDE 12: Roadmap        — 18-month phased trajectory · milestones with definitions
SLIDE 13: Ask            — amount · use of funds (table: % to engineering/sales/marketing/ops)
SLIDE 14: Appendix       — financial summary · cohort retention · cap table · references

Framework citations:
  Narrative arc:        Duarte Sparkline (Resonate)
  Slide-level logic:    Minto Pyramid (Pyramid Principle)
  Structure:            McKinsey Slide Logic
  Visual reinforcement: Dual Coding Theory (Paivio)
  Persuasion overlay:   Cialdini authority + social proof + scarcity
```

**Behavioral framing:** investors see hundreds of decks. The craft signal (named frameworks + structural rigor) puts the deck in the "they know what they're doing" bucket. Maxim ships this signal as default.

---

### `/mxm-founder gtm-plan <product>`

Go-to-market plan applying Pirate Metrics (AARRR) + Jobs-to-be-Done + first-100-customers playbook.

**Reads:** product description · CMO skills · `documents/reference/FRAMEWORKS_MASTER.md` § Tier 2 sales/GTM

**Output:**
```
GTM Plan — <product>
────────────────────
PIRATE METRICS (AARRR):
  ACQUISITION:  channels · CAC target · top-of-funnel motion
  ACTIVATION:   activation event · time-to-activation · % conversion
  RETENTION:    cohort retention curve · churn drivers
  REFERRAL:     viral coefficient target · referral mechanism
  REVENUE:      pricing tier mix · ARPU · LTV target

FIRST 100 CUSTOMERS (sequence):
  CUSTOMERS 1–10:    do things that don't scale · founder-led sales · in-person if possible
  CUSTOMERS 11–30:   case study collection · referral mechanism live · first hire
  CUSTOMERS 31–100:  inbound channel turned on · cohort analytics dashboard · pricing test

JOBS-TO-BE-DONE:
  Functional job:    <what the customer is hiring this product to do>
  Emotional job:     <how they want to feel>
  Social job:        <how they want to be perceived>
  Outcome statements: <ranked outcomes operator can map to features>

CHANNEL FIT (Wardley overlay):
  Channel A · stage <Genesis | Custom | Product>  · CAC bet
  Channel B · ...

MILESTONES (12 months):
  M3:  <metric target> · activation gate
  M6:  <metric target> · monetization gate
  M12: <metric target> · scaling gate
```

---

### `/mxm-founder runway-model <expenses>`

Cash runway model. Spreadsheet-grade math — burn rate, cohort LTV, breakeven month, dilution scenarios.

**Reads:** current cash · monthly recurring expenses · revenue trajectory (if any) · planned hires · operator-provided dilution targets

**Output:**
```
Runway Model — <month range>
────────────────────────────
MONTHLY P&L (12-month projection):
  Month  | Revenue | COGS | Gross Margin | OpEx | Net Burn | Cash Balance | Runway Remaining |
  M0     | $X     | $Y  | %             | $Z   | $W      | $C            | N months |
  ...

KEY MILESTONES:
  Cash-runway end: M<N>  (so raise by M<N-4>)
  Breakeven:       M<N>  (or never at current trajectory)
  Headcount-driven OpEx step: M<N>  (next hire)

COHORT LTV (if applicable):
  Cohort  | M0 ARPU | M12 retention | M24 retention | LTV/CAC ratio |
  ...

DILUTION SCENARIOS:
  Pre-money: $X · post-money: $X+raise · operator post-round ownership: %
  Scenario A: $500K raise at $4M pre → 11% dilution
  Scenario B: $1.5M raise at $6M pre → 20% dilution
  Scenario C: bridge SAFE $250K at $7M cap → ~3.5% effective dilution

RECOMMENDED RAISE: $X over Y months runway extension (citing milestone-coverage)
```

**Confidence:** 🟢 HIGH with full operator-supplied inputs · 🟡 with assumed growth rate · 🔴 with no expense data (asks operator first).

---

### `/mxm-founder pricing <product>`

Tiered pricing applying Prospect Theory (loss aversion → reference price anchoring) + Van Westendorp Price Sensitivity Meter + Cialdini anchoring (tier stack ordering).

**Reads:** product description · cost structure · target customer ICP · competitor pricing if known

**Output:**
```
Pricing — <product>
───────────────────
PRICE SENSITIVITY (Van Westendorp PSM):
  Too cheap:    $X  (suspect quality)
  Bargain:      $X  (price point of marginal cheapness)
  Expensive:    $X  (price point of marginal expensiveness)
  Too expensive: $X (refusal)
  OPP (optimum) = intersection of "expensive" and "bargain" curves: $X
  IPP (indifference) = intersection of "too cheap" and "too expensive": $X
  Recommended range: [IPP, OPP] = [$X, $Y]

TIER LADDER (Cialdini anchoring + Prospect Theory):
  Free:       $0/mo       feature subset · acquisition vehicle
  Starter:    $X/mo       solo · main entry · price anchor (high enough to qualify)
  Pro:        $Y/mo       intended median tier · feature set designed for "this is the right one"
  Business:   $Z/mo       team · high-anchor reference for Pro
  Enterprise: contact     custom · creates "leave money on the table" perception above Z

  Tier-stack ratios (Cialdini anchoring): X:Y:Z ≈ 1:3:10 typical
  Anchor effect: Enterprise existence makes Business look reasonable

LOSS-AVERSION FRAMING (Prospect Theory):
  Default UI presentation: "save $X annually by switching to annual billing"
  (NOT: "$Y discount on annual" — loss-aversion frame is 2.25x more persuasive)

ANNUAL DISCOUNT: 17% (10/12) — standard SaaS · don't go deeper without justification

ENTERPRISE FLOOR: $Z/year minimum · 1-year minimum term · CFO-signed contract

Confidence: 🟢 if cost data + target ICP given · 🟡 if competitor pricing assumed · 🔴 if Van Westendorp data not operator-collected
```

---

### `/mxm-founder business-model-canvas`

Strategyzer BMC + Value Proposition Canvas pair. The native artifact Strategyzer-trained operators expect.

**Reads:** project context · operator-described value proposition · customer segment definitions

**Output:** Two filled canvases:
1. Business Model Canvas — 9 building blocks (customer segments · value props · channels · customer relationships · revenue streams · key resources · key activities · key partnerships · cost structure)
2. Value Proposition Canvas — Customer Profile (jobs · pains · gains) + Value Map (products & services · pain relievers · gain creators) with fit-check

Plus a fit-check verdict: "🟢 problem-solution fit", "🟡 partial fit · pivot zone", "🔴 misaligned · re-think before scaling."

---

### `/mxm-founder competitive-moat`

7-moat audit + defensibility timeline. Reads `documents/ledgers/MOAT_TRACKER.md` to ground the analysis in your project's existing moat claims.

**Reads:** `documents/ledgers/MOAT_TRACKER.md` · competitor analysis (operator-supplied or scanned) · product description · `documents/reference/FRAMEWORK_USES.md`

**Output:**
```
Competitive Moat Audit — <product>
──────────────────────────────────
7 MOAT TYPES (per Hamilton Helmer's 7 Powers + adjacent frameworks):
| Moat Type | Strength Today | Trajectory (12mo) | Trajectory (36mo) | Evidence |
|---|---|---|---|---|
| Counter-positioning  | <none/weak/medium/strong> | <↗/→/↘> | <↗/→/↘> | <MOAT-NN row if exists> |
| Scale economies      | ...                       | ...      | ...      | ... |
| Network effects      | ...                       | ...      | ...      | ... |
| Switching costs      | ...                       | ...      | ...      | ... |
| Brand                | ...                       | ...      | ...      | ... |
| Cornered resource    | ...                       | ...      | ...      | ... |
| Process power        | ...                       | ...      | ...      | ... |

CURRENT MOAT_TRACKER STATE (from documents/ledgers/MOAT_TRACKER.md):
  MOAT-01: <one-line summary>
  MOAT-02: <one-line summary>
  ... (list all current rows)

DEFENSIBILITY TIMELINE:
  Now:        primary moat = <which moat type>
  M+12:       primary moat = <which> (strengthening because <reason>)
  M+36:       primary moat = <which> (strengthening because <reason>)

INVESTOR FRAMING:
  Best moat to lead with: <one type> because <reasoning grounded in MOAT-NN evidence>
  Risk of moat erosion: <which moat is most at risk + why>

Confidence: 🟢 if MOAT_TRACKER has live rows · 🟡 if moat-claims thin · 🔴 if no MOAT_TRACKER entries
```

---

## Behavioral Overlay

- **Behavioral pricing is a Maxim differentiator.** Most pricing advice ignores Prospect Theory and Van Westendorp. Maxim wires both as default routing.
- **MOAT_TRACKER is live state.** `/mxm-founder competitive-moat` reads MOAT_TRACKER.md as the source of truth — moats are continuously tracked rows, not one-shot deck slides.
- **Framework craft signal.** Pitch decks with framework citations (Duarte · Minto · McKinsey · Dual Coding · Cialdini) signal investor-readable craft. Maxim makes the framework citations a default, not an addon.
- **Specialist routing (WS5+):** today, sub-commands route through CEO `enterprise-architect` + CMO leads. After WS5 ships `business-model-canvas-strategist` · `pricing-strategist` · `finance-analyst` · `board-deck-author` · `m-and-a-due-diligence-analyst` · `wardley-mapper`, each sub-command routes to the specialist.
- **Confidence tag rubric:** 🟢 HIGH = artifact framework-grounded + MOAT_TRACKER/manifest-grounded + numbers operator-validated. 🟡 MEDIUM = artifact complete but key numbers assumed. 🔴 LOW = generic founder output without framework citations.

## TIER 3 surface note

Founders don't think "I need the CEO office + CMO office in parallel" — they think "I need a pitch deck" or "I need a pricing model." `/mxm-founder` speaks artifact-language and routes invisibly.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 3 persona dispatcher shipped in WS3 of v1.2.0 sprint (2026-05-19) per AGENT_ROSTER_v1.2_PROPOSAL.md § TIER 3._
