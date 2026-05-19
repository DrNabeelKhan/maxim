---
skill_id: diffusion-of-innovations
name: Diffusion of Innovations
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply diffusion of innovations
  - adoption curve analysis
  - innovators early adopters laggards
  - Rogers innovation
  - crossing the chasm
collaborates_with:
  - growth-hacker
  - gtm-strategist
  - product-strategist
  - innovation-researcher
ethics_required: true
priority: medium
tags: [behavior-science, framework, adoption, market, innovation]
adr: ADR-007
created: 2026-05-19
updated: 2026-05-19
---

# Diffusion of Innovations

## Purpose
Apply Everett Rogers' Diffusion of Innovations to model how new ideas, products, and behaviors spread through populations. The 5 adopter categories (Innovators · Early Adopters · Early Majority · Late Majority · Laggards) and 5 innovation attributes (Relative Advantage · Compatibility · Complexity · Trialability · Observability) explain why some innovations spread rapidly and others stall. Combined with Moore's "Crossing the Chasm" refinement, this framework is the lingua franca of go-to-market strategy for new products.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `diffusion-of-innovations` |
| Category | Behavior Science — Adoption / Marketing |
| Version | 1.0.0 |
| Originator | Everett Rogers (1962 · 5th edition 2003) |
| Maturity | Foundational — one of the most-cited frameworks in marketing, sociology, and behavior change |
| Primary references | Rogers, E. (2003). *Diffusion of Innovations* (5th ed.) · Moore, G. (1991). *Crossing the Chasm* (the GTM application) · diffusionofinnovations.com |

## The Five Adopter Categories

| Category | % of Population | Defining Traits | Decision Driver |
|---|---|---|---|
| **Innovators** | 2.5% | Risk-tolerant · technically literate · venturesome · gateway to the rest | Curiosity · technical fit |
| **Early Adopters** | 13.5% | Opinion leaders · status from being first · social influencers | Vision · advantage · early access |
| **Early Majority** | 34% | Deliberate · pragmatic · waits for proof | Reduced risk · concrete benefit |
| **Late Majority** | 34% | Skeptical · cost-sensitive · adopts under social pressure | Necessity · cost effectiveness |
| **Laggards** | 16% | Traditional · isolated · skeptical of change | Forced adoption or never |

## Moore's Chasm (1991 refinement)

Between Early Adopters and Early Majority sits **the chasm** — a gap where many products fail. Early Adopters buy on vision; Early Majority buys on proof. Marketing tactics that work for Early Adopters (visionary positioning · cutting-edge framing) actively repel Early Majority (who want proof · references · whole-product completeness).

**Crossing the chasm requires targeting a beachhead segment** within Early Majority — picking ONE niche, dominating it, then expanding adjacent. Trying to "win the whole market" from the chasm typically fails.

## The Five Innovation Attributes (Rogers' adoption predictors)

| Attribute | Definition | Adoption acceleration |
|---|---|---|
| **Relative Advantage** | Perceived improvement over current alternative | Higher = faster adoption |
| **Compatibility** | Fit with existing values · workflows · infrastructure | Higher = faster adoption |
| **Complexity** | Difficulty to understand and use | Lower = faster adoption |
| **Trialability** | Ability to test before commitment | Higher = faster adoption |
| **Observability** | Visibility of results to other potential adopters | Higher = faster adoption |

Rogers showed these five attributes explain ~50% of adoption-rate variance. Products that score high on all five spread rapidly; products that score low on multiple attributes stall regardless of marketing spend.

## Prompt Template
```
You are applying Diffusion of Innovations.

CONTEXT:
- Product or behavior being diffused: [[description]]
- Current adoption stage: pre-launch | innovators | early adopters | chasm | early majority | majority | laggards
- Current marketing/GTM approach: [[approach]]

ADOPTER-CATEGORY DIAGNOSIS:
- Who is the current target population?
- Which adopter category dominates the current customer base?
- Are marketing tactics matched to the dominant category?

CHASM DIAGNOSIS:
- Is the product approaching the Early Adopter → Early Majority chasm?
- Is there a beachhead segment identified within Early Majority?
- Is the whole-product offering complete for the beachhead?

INNOVATION-ATTRIBUTE DIAGNOSIS (score each 1–5):
- Relative Advantage:  <score> · evidence
- Compatibility:       <score> · evidence
- Complexity:          <score (lower=better)> · evidence
- Trialability:        <score> · evidence
- Observability:       <score> · evidence

INTERVENTION DESIGN:
- For low Relative Advantage: clarify and amplify benefit framing
- For low Compatibility: integrations · migration tools · co-existence patterns
- For high Complexity: simplification · scaffolded onboarding · template defaults
- For low Trialability: free trials · sandbox · open-source variants · interactive demos
- For low Observability: case studies · public-facing customer dashboards · community
```

## Core Principles
- **The adoption curve is not just demographic — it's behavioral.** Same person can be Innovator for one product, Laggard for another.
- **Different categories require different marketing.** Visionary positioning for Early Adopters; proof-and-reference for Early Majority; cost-and-necessity for Late Majority.
- **The chasm is real.** Many products win Innovators + Early Adopters but stall before Early Majority. Pre-chasm-success metrics overestimate market potential.
- **Beachhead strategy beats horizontal.** Dominating one Early Majority niche enables expansion; trying to win broadly from the chasm typically fails.
- **Innovation attributes are levers.** Each attribute can be deliberately improved through product or positioning changes.
- **Observability accelerates adoption disproportionately.** Visible adoption (community · public usage · network effects) compounds.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| New product GTM | Beachhead-segment strategy for chasm crossing | Higher chance of Early Majority entry |
| Marketing positioning | Match messaging to dominant adopter category | Higher conversion |
| Product roadmap | Increase Trialability + Observability for stalled adoption | Adoption acceleration |
| Enterprise sales | Identify Early Adopter champions within target accounts | Faster pilots → expansion |
| Open-source projects | Maximize Trialability (free) + Observability (community) | Faster spread |
| Behavior-change interventions (public health · sustainability) | Diagnose which adopter category is the bottleneck | Targeted intervention |

## Reference Materials
- Rogers, E.M. (2003). *Diffusion of Innovations* (5th ed.). Free Press.
- Moore, G.A. (1991). *Crossing the Chasm: Marketing and Selling High-Tech Products to Mainstream Customers.* HarperBusiness.
- Diffusion of Innovations resource site — https://www.diffusionofinnovations.com/

## Usage Guidelines
- Identify the dominant adopter category in your customer base FIRST. Marketing to "the market" is marketing to no one.
- Use Moore's beachhead strategy when approaching the chasm — pick ONE Early Majority niche to dominate.
- Audit the 5 innovation attributes deliberately; weak attributes are addressable, not inherent.
- Pair with TPB (Subjective Norms drive Early Majority adoption — peer-driven), Cialdini (Social Proof), Social Learning Theory (modeling).

## Collaboration Protocol
- Inbound from: `growth-hacker` · `gtm-strategist` · `product-strategist` · `innovation-researcher`
- Outbound to: same agents for category-specific intervention
- Cross-framework: pairs with Cialdini (Social Proof for Early Majority), TPB (Subjective Norms), Social Learning Theory (Observability ≈ modeling)

## Ethical Guidelines
- Diffusion-of-innovations analysis is descriptive; don't conflate with manipulation
- Targeting Late Majority + Laggards under social pressure manipulation is dark patterning
- Manufactured Observability (fake community · fake adoption metrics) violates the model's core assumption

## Success Metrics
- Per-category conversion rates (do Early Majority convert at a different rate than Early Adopters?)
- Chasm-crossing metric: % of customers who are unambiguously Early Majority (proof-driven, not visionary)
- Adoption-attribute scores over time (Relative Advantage, Compatibility, etc.)
- Time-to-mainstream (months from launch to >50% of TAM)

## Related Skills
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — Social Proof for Early Majority
- `composable-skills/frameworks/social-learning-theory/SKILL.md` — Observability = modeling
- `composable-skills/frameworks/theory-of-planned-behavior/SKILL.md` — Subjective Norms in adopter categories
- `composable-skills/frameworks/wardley-mapping/SKILL.md` (if exists) — component-evolution stage informs diffusion stage

## Testing Strategy
- A/B test category-matched messaging vs unsegmented control
- Measure conversion per adopter category, not just aggregate
- Expected lift: 30–60% on conversion when messaging matches dominant category vs misaligned

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in v1.2.0 final WS6b (2026-05-19)._
