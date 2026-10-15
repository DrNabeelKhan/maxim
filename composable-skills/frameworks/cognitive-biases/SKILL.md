---
skill_id: cognitive-biases
name: Cognitive Biases
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - cognitive bias review
  - debias this decision
  - pre-mortem
  - anchoring availability confirmation bias
  - decision quality check
collaborates_with:
  - decision-architect
  - persuasion-specialist
  - negotiation-specialist
  - product-strategist
  - ux-researcher
ethics_required: true
priority: high
tags: [behavior-science, framework, heuristics, debiasing, decision-quality]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Cognitive Biases

## Purpose
Use the heuristics-and-biases research to find where a decision, a design or a forecast is likely to go systematically wrong, and to correct for it. Tversky and Kahneman showed in 1974 that people rely on a few mental shortcuts that are usually efficient but produce predictable errors. Knowing the common biases lets you design processes that catch them, which is more reliable than trying to think harder.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `cognitive-biases` |
| Category | Behavior Science — Judgment and Decision-Making |
| Version | 2.0.0 |
| Foundational work | Tversky & Kahneman, "Judgment under Uncertainty: Heuristics and Biases", *Science* (1974) |
| Synthesis | Kahneman, *Thinking, Fast and Slow* (2011) |

## The Biases Most Worth Checking
- **Anchoring.** Estimates stay too close to an initial number, even an irrelevant one.
- **Availability.** Events that are easy to recall seem more likely than they are.
- **Representativeness.** Judging likelihood by resemblance to a stereotype, while neglecting base rates.
- **Confirmation bias.** Seeking and weighting evidence that supports what we already believe.
- **Framing effect.** The same choice described as a gain or a loss produces different decisions.
- **Status quo bias.** A disproportionate preference for keeping things as they are.
- **Sunk cost fallacy.** Continuing because of what has already been spent, not what is to come.
- **Planning fallacy.** Underestimating time, cost and risk of one's own plans.

## Core Principles
- **Biases are systematic, not random.** Because they are predictable, processes can be designed to counter them.
- **Knowing about a bias does not remove it.** Structural safeguards work better than good intentions.
- **Most decisions need a check on only a few biases.** Identify the two or three most likely given the situation.
- **Base rates first.** Start from how often things like this usually turn out before adjusting for the specifics.
- **Debias the process, not the person.** Change the steps, the order and who speaks first.

## Applications & Use Cases
| Use Case | Application | Bias addressed |
|---|---|---|
| Project estimates | Compare against a reference class of past projects | Planning fallacy, anchoring |
| Go or no-go decisions | Run a pre-mortem before committing | Overconfidence, confirmation |
| Continuing a failing initiative | Judge only future costs and benefits | Sunk cost |
| Hiring and reviews | Score independently before discussion | Anchoring, halo |
| Research synthesis | Look explicitly for disconfirming evidence | Confirmation |
| Pricing and negotiation | Be aware of the first number put on the table | Anchoring |

## Usage Guidelines
- **Name the decision and its stakes**, then pick the two or three biases most likely to affect it.
- **Use a reference class** for any forecast of time, cost or success.
- **Run a pre-mortem**: imagine the decision has failed and list the reasons why.
- **Collect judgments independently** before group discussion, so the first speaker does not anchor everyone.
- **Ask what would change your mind**, and write it down before seeing the outcome.

## Prompt Template
```
You are reviewing a decision for cognitive biases (Tversky & Kahneman 1974).

DECISION: [[what is being decided, and the stakes]]

LIKELY BIASES — pick the two or three that fit, with evidence:
anchoring · availability · representativeness · confirmation · framing · status quo · sunk cost · planning fallacy

FOR EACH
- Where it could be distorting the decision:
- The safeguard (reference class, pre-mortem, independent scoring, reframing):

BASE RATE: how do decisions like this usually turn out?
WHAT WOULD CHANGE THE CONCLUSION:
```

## Ethical Guidelines
- **Use bias knowledge to improve decisions, not to exploit them.** Deliberately triggering biases to push people against their interests is manipulation.
- **Apply the review to your own reasoning,** not only to others'.

## Testing Strategy
- Compare forecasts made with and without reference-class anchoring against actual outcomes.
- Track decisions reviewed with a pre-mortem against those that were not.

## Success Metrics
- Forecast accuracy for time and cost.
- Share of decisions where a pre-mortem surfaced a risk that later materialised.
- Rate of reversed decisions and their cost.

## Collaboration Protocol
- Inbound from: `decision-architect` · `product-strategist` · `ux-researcher` · `negotiation-specialist`
- Outbound to: CEO office for arbitration on high-stakes decisions
- Cross-framework: Dual Process Theory explains the mechanism; Prospect Theory covers framing and loss aversion in depth.

## Related Skills
- `composable-skills/frameworks/dual-process-theory/SKILL.md` — System 1 and System 2
- `composable-skills/frameworks/prospect-theory/SKILL.md` — framing, loss aversion, reference dependence
- `composable-skills/frameworks/nudge-theory/SKILL.md` — designing choices that account for bias

## Reference Materials
- Tversky, A., & Kahneman, D. (1974). "Judgment under Uncertainty: Heuristics and Biases." *Science*, 185(4157), 1124–1131.
- Tversky, A., & Kahneman, D. (1981). "The Framing of Decisions and the Psychology of Choice." *Science*, 211(4481), 453–458.
- Samuelson, W., & Zeckhauser, R. (1988). "Status Quo Bias in Decision Making." *Journal of Risk and Uncertainty*, 1, 7–59.
- Arkes, H.R., & Blumer, C. (1985). "The Psychology of Sunk Cost." *Organizational Behavior and Human Decision Processes*, 35(1), 124–140.
- Nickerson, R.S. (1998). "Confirmation Bias: A Ubiquitous Phenomenon in Many Guises." *Review of General Psychology*, 2(2), 175–220.
- Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*, September 2007.
- Kahneman, D. (2011). *Thinking, Fast and Slow.* Farrar, Straus and Giroux.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
