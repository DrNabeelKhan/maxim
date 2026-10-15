---
skill_id: prospect-theory
name: Prospect Theory (Loss Aversion · Reference Dependence · Probability Weighting)
version: 1.1.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply prospect theory
  - loss aversion analysis
  - reference dependence framing
  - probability weighting
  - pricing psychology
collaborates_with:
  - behavioral-designer
  - conversion-optimizer
  - decision-architect
  - product-strategist
  - growth-hacker
ethics_required: true
priority: high
tags: [behavior-science, framework, decision-making, pricing, loss-aversion]
adr: ADR-007
created: 2026-05-19
updated: 2026-10-15
---

# Prospect Theory (Loss Aversion · Reference Dependence · Probability Weighting)

## Purpose
Apply Prospect Theory to design pricing, framing, and choice architecture that aligns with how humans actually make decisions under risk — NOT how classical economics assumes they do. The most product-relevant finding: **losses are weighted roughly twice as heavily as equivalent gains** (λ ≈ 2.25 in Tversky & Kahneman 1992; a 2024 meta-analysis of 607 estimates puts the mean near 1.96, with wide variation by task). Note what this does and does not imply: it describes how outcomes are *valued*, not how persuasive a *message* is. Meta-analyses of gain- versus loss-framed messages find small, context-dependent effects, so frames should be tested, not assumed.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `prospect-theory` |
| Category | Behavior Science — Decision Making Under Risk |
| Version | 1.1.0 |
| Originators | Daniel Kahneman & Amos Tversky (1979) · Cumulative Prospect Theory (1992) |
| Maturity | Established — Nobel Prize 2002 (Kahneman); foundational behavioral economics |
| Primary references | Kahneman & Tversky "Prospect Theory: An Analysis of Decision under Risk" *Econometrica* 47(2): 263–291 (1979) · *Thinking, Fast and Slow* Chap. 26–28 (2011) |

## The Three Core Phenomena

1. **Loss Aversion**
   - Losses are weighted roughly 2x as heavily as equivalent gains in valuation (λ ≈ 2.25 in the 1992 estimate; meta-analytic mean ≈ 1.96; varies by task and population)
   - Implication for messaging: this does NOT mean "Don't lose $X" reliably beats "Save $X". Message-framing meta-analyses find effects of |r| ≤ ~.08, sometimes favouring gain frames (O'Keefe & Jensen 2007, 2009; Gallagher & Updegraff 2012). Test frames on your own audience.

2. **Reference Dependence**
   - Outcomes are evaluated relative to a reference point, not in absolute terms
   - Implication: the implied reference (previous price · competitor price · first quote · status quo) shapes how a value is felt
   - Reference points can be set honestly or manipulated; only the first is acceptable (see Ethical Guidelines)

3. **Probability Weighting**
   - People overweight small probabilities when probabilities are described (lotteries · insurance · rare-but-catastrophic events)
   - People underweight medium-to-large probabilities: with the 1992 gain-domain weighting function, a 75% chance of a gain is weighted roughly like 57%
   - When people learn probabilities from experience rather than description, rare events tend to be *under*weighted (Hertwig et al. 2004)
   - Implication: "99.9% uptime" and "1-in-1000 failure rate" can trigger different intuitions; how the probability is presented matters

## The Value Function

Prospect Theory's value function is **S-shaped**, asymmetric around the reference point:
- **Concave for gains** (diminishing sensitivity — $100 → $200 feels bigger than $1000 → $1100)
- **Convex for losses** (diminishing sensitivity — losing $100 → $200 hurts more than losing $1000 → $1100)
- **Steeper for losses than gains** (loss aversion, λ > 1)

## Prompt Template
```
You are applying Prospect Theory.

CONTEXT:
- Decision under design: [[decision]]
- Stakes: gain · loss · mixed
- Probability characteristics: certain · medium probability · low probability · very low probability
- How the user learns the probability: described · experienced

PROSPECT ANALYSIS:
1. Reference point — what is the user's current implicit reference?
2. Frame — is the current framing gain-side or loss-side?
3. Probability — what's the actual probability vs how it will likely be perceived?
4. Asymmetry — does the design account for losses weighing about twice as much as gains?

FRAMING HYPOTHESES (test each; message-framing effects are small and context-dependent):
- Prevention behaviours: gain frames did slightly better in meta-analyses
- Status-quo defense: a loss frame naming what the user actually keeps or loses
- Free-tier risk surfacing: loss frame WITHOUT manufactured urgency (ethics gate)

PRICING-SPECIFIC APPLICATIONS:
- Annual discount framing: test "Save 17%" against a loss-side framing. Check the arithmetic: if annual saves 17%, monthly costs about 20.5% more, not 17%.
- Tier comparison: position the recommended tier as the reference point
- Anchor placement: test highest-price-first against lowest-price-first
- Decoy effect: an inferior third option can make the target option look better by comparison

ANTI-PATTERN CHECK:
- Manufactured loss frames (false urgency · invented scarcity) = dark pattern
- Reference-point manipulation that misleads (fake "original price") = unethical
- Probability misframing on high-stakes risk = unethical

OUTPUT:
- Reference-point and frame diagnosis
- Framing hypotheses to test, with how to measure them
- Ethical-flag if any manufactured loss frames present
```

## Core Principles
- **Loss aversion is about valuation, not message strength.** Losses weigh about twice as much as gains when people evaluate outcomes; loss-framed messages are not reliably more persuasive.
- **Reference point shapes value.** A $99 product feels expensive next to a $50 reference and cheap next to a $200 reference.
- **Probability weighting depends on presentation.** Described small probabilities are overweighted (insurance, lotteries); experienced rare events are often underweighted.
- **Endowment effect.** People often ask more to give up something they own than they would pay to get it: about 2x in the original mug experiments (Kahneman, Knetsch & Thaler 1990), but the ratio varies widely by good and can shrink under some elicitation procedures (Plott & Zeiler 2005).
- **Status quo bias.** Reference dependence makes change feel like loss, which is part of why defaults are powerful.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Pricing tier presentation | Make the recommended tier the reference; test framings | Measured, not assumed, upgrade effect |
| Annual billing prompt | Test "Lock in this year's price" against "Save 17%" | Evidence for which frame works for your audience |
| Cancellation flows | Remind users of benefits they actually have ("You'll lose your...") | Lower churn (must be honest) |
| Free trial design | Trial length that lets users build real usage, chosen by experiment | Higher trial-to-paid conversion |
| Insurance / risk products | Present real low-probability risks honestly | Informed decisions |
| A/B test framing | Test gain vs loss frame on meaningful CTAs | Effect size for your context |
| Negotiation | Set a reasoned first anchor | Better terms |

## Reference Materials
- Kahneman, D. & Tversky, A. (1979). "Prospect Theory: An Analysis of Decision under Risk." *Econometrica* 47(2): 263–291.
- Tversky, A. & Kahneman, D. (1992). "Advances in Prospect Theory: Cumulative Representation of Uncertainty." *Journal of Risk and Uncertainty* 5(4): 297–323.
- Kahneman, D. (2011). *Thinking, Fast and Slow.* Farrar, Straus and Giroux. Chapters 26–28.
- Camerer, C. (2000). "Prospect Theory in the Wild: Evidence from the Field." In D. Kahneman & A. Tversky (eds.), *Choices, Values, and Frames*, pp. 288–300. Cambridge University Press.
- Kahneman, D., Knetsch, J.L., & Thaler, R.H. (1990). "Experimental Tests of the Endowment Effect and the Coase Theorem." *Journal of Political Economy* 98(6): 1325–1348.
- Plott, C.R., & Zeiler, K. (2005). "The Willingness to Pay–Willingness to Accept Gap, the 'Endowment Effect,' Subject Misconceptions, and Experimental Procedures for Eliciting Valuations." *American Economic Review* 95(3): 530–545.
- Hertwig, R., Barron, G., Weber, E.U., & Erev, I. (2004). "Decisions from Experience and the Effect of Rare Events in Risky Choice." *Psychological Science* 15(8): 534–539.
- O'Keefe, D.J., & Jensen, J.D. (2007). "The Relative Persuasiveness of Gain-Framed and Loss-Framed Messages for Encouraging Disease Prevention Behaviors: A Meta-Analytic Review." *Journal of Health Communication* 12(7): 623–644.
- O'Keefe, D.J., & Jensen, J.D. (2009). "The Relative Persuasiveness of Gain-Framed and Loss-Framed Messages for Encouraging Disease Detection Behaviors: A Meta-Analytic Review." *Journal of Communication* 59(2): 296–316.
- Gallagher, K.M., & Updegraff, J.A. (2012). "Health Message Framing Effects on Attitudes, Intentions, and Behavior: A Meta-analytic Review." *Annals of Behavioral Medicine* 43(1): 101–116.
- Brown, A.L., Imai, T., Vieider, F.M., & Camerer, C.F. (2024). "Meta-analysis of Empirical Estimates of Loss Aversion." *Journal of Economic Literature* 62(2): 485–516.

## Usage Guidelines
- **Identify the reference point first.** Without knowing the reference, framing recommendations are guesses.
- **Test gain vs loss frame on meaningful CTAs** and measure the effect; do not assume a lift.
- **Account for the roughly 2x loss weighting** when designing incentive structures: taking something away is felt more than giving the same amount.
- **Use probability weighting honestly.** Don't manufacture rare-but-catastrophic fears; do surface real low-probability risks (security · data loss · regulatory exposure).
- **Pair with Cialdini's principles** carefully: scarcity must be real, and authority must be genuine.

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `decision-architect` · `pricing-strategist` (CPO) · `growth-hacker`
- Outbound to: same agents + `conversion-optimizer` for funnel A/B tests
- Cross-framework: pairs with Dual Process Theory (fast intuitive evaluation), Cialdini (scarcity + authority), Nudge theory (defaults and status quo)

## Ethical Guidelines
- **Bright line:** Manufactured loss frames are dark patterns. "Last 2 items!" when stock is 200 = unethical regardless of conversion lift.
- **Reference manipulation must be honest.** Fictitious "original price" comparisons are addressed by the US FTC Guides Against Deceptive Pricing (16 CFR Part 233) and by consumer-protection law in many jurisdictions.
- **Probability misrepresentation on stakes-bearing decisions** (health · finance · legal) is unethical.
- **Endowment-effect reminders in cancellation flows** are acceptable IF the surfaced benefits are real; not if they're fabricated.

## Success Metrics
- Measured A/B effect of framing changes in your own context (no general benchmark; published framing effects are small)
- Decision regret rate at 30/90 days (high regret = loss-frame exploitation)
- Pricing elasticity vs reference-point shifts (controlled experiments)

## Related Skills
- `composable-skills/frameworks/dual-process-theory/SKILL.md` — fast versus deliberate evaluation
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — scarcity + authority
- `composable-skills/frameworks/cognitive-biases/SKILL.md` — anchoring and related biases
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Motivation × Ability × Prompt
- `composable-skills/frameworks/east-framework/SKILL.md` — make the honest option Easy + Attractive + Timely

## Testing Strategy
- A/B test gain vs loss frame on highest-impact CTAs (pricing · upgrade · cancellation · annual)
- Measure conversion AND regret (post-decision survey at 7/30/90 days)
- High-regret loss-frame wins = ethical flag; the frame won on manipulation, not honest preference
- Pair with reference-point experiments — test "high anchor first" vs "low anchor first" on the same offer set

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in WS6a of v1.2.0 sprint (2026-05-19). Revised 2026-10-15 after primary-source verification: loss aversion separated from message framing; unsourced conversion figures removed; probability-weighting example corrected._
