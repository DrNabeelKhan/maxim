---
skill_id: aida
name: AIDA
version: 2.0.0
category: content-marketing
type: framework
frameworks: []
triggers:
  - apply aida
  - aida framework
  - attention interest desire action
  - structure sales copy
  - landing page structure
  - ad copy structure
collaborates_with:
  - article-writer
  - content-creator
  - social-media-strategist
  - persuasion-specialist
  - growth-hacker
ethics_required: true
priority: high
tags: [content-marketing, framework, copywriting, sales, funnel]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# AIDA

## Purpose
Use AIDA to structure a persuasive message so it moves a reader in a deliberate order: first **Attention**, then **Interest**, then **Desire**, then **Action**. It is one of the oldest models in advertising and selling, and it remains useful because most failed copy breaks one of the four stages, for example by asking for action before creating desire, or by never earning attention at all. It is a structure for a message, not a description of how people actually buy, and works best when treated that way.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `aida` |
| Category | Content Marketing — Message Structure |
| Version | 2.0.0 |
| Originator | Attributed to E. St. Elmo Lewis (1898) |
| Early documentation | Strong, "Theories of Selling", *Journal of Applied Psychology* (1925) |
| Family | Hierarchy-of-effects models, such as Lavidge & Steiner (1961) |

## The Model
1. **Attention.** Earn a moment of focus: a headline, opening line or image that speaks to something the reader already cares about.
2. **Interest.** Hold it by making the message relevant, with specifics about their situation rather than about the product.
3. **Desire.** Turn interest into wanting: show the outcome, back it with evidence, and handle the main objection.
4. **Action.** Ask clearly for one specific next step, and make it easy.

**Common variants** add a stage: AIDCA adds Conviction before Action; AIDAS adds Satisfaction after it, recognising that the relationship continues after the sale.

## Core Principles
- **Order matters.** Asking for action before desire exists is the most common failure.
- **Attention is earned with relevance, not volume.** A loud headline that misleads loses the reader at the Interest stage.
- **Desire needs evidence.** Claims without proof stall the reader before Action.
- **One message, one action.** Several competing calls to action weaken all of them.
- **It is a writing structure, not a buyer model.** Real buying journeys loop and skip; AIDA organises a single message within them.

## Applications & Use Cases
| Use Case | Application | Stage most often broken |
|---|---|---|
| Landing pages | Map each section to one stage, in order | Desire, through weak evidence |
| Ad copy | Fit all four stages into a short format | Attention, through irrelevance |
| Sales emails | Open with relevance, close with one clear ask | Action, through a vague request |
| Video scripts | Hook in the first seconds, demonstrate, then call to action | Attention |
| Product announcements | Lead with the reader's problem, not the feature | Interest |
| Diagnosing underperforming copy | Find the stage where readers drop off | Varies |

## Usage Guidelines
- **Know the reader's problem before writing the headline**; attention comes from relevance to that problem.
- **Write the call to action first**, then work backwards so every earlier stage leads to it.
- **Back every Desire claim with evidence** such as data, a demonstration or a credible testimonial.
- **Give one primary action** and remove anything that competes with it.
- **Diagnose by stage**: where do readers stop? Fix that stage before rewriting the whole message.

## Prompt Template
```
You are structuring a message with AIDA (attributed to Lewis, 1898).

READER: [[who, and the problem they have]]
ACTION: [[the one specific thing you want them to do]]

ATTENTION — the opening that speaks to their problem:
INTEREST — specifics that show you understand their situation:
DESIRE — the outcome, the evidence, the main objection answered:
ACTION — one clear, easy next step:

CHECK
- Is any claim unsupported?
- Is there more than one call to action?
- Does the opening promise something the body does not deliver?
```

## Ethical Guidelines
- **Attention must not be bait.** A headline that misrepresents the content breaks trust at the next stage.
- **Desire must rest on truth.** Overstated outcomes create regret and refunds.
- **Do not manufacture urgency in the Action stage.** Use real deadlines only.

## Testing Strategy
- Test one stage at a time, for example two headlines with identical bodies.
- Use scroll depth or read-through to find where readers drop out.
- Measure the action and its downstream quality, such as activation or retention, not just clicks.

## Success Metrics
- Click-through or open rate, for Attention.
- Read-through or scroll depth, for Interest and Desire.
- Conversion on the single call to action.
- Downstream quality of those conversions.

## Collaboration Protocol
- Inbound from: `article-writer` · `content-creator` · `social-media-strategist` · `growth-hacker`
- Outbound to: `persuasion-specialist` for the Desire stage, `conversion-optimizer` for testing
- Cross-framework: Cialdini supplies the evidence and persuasion used in Desire; Prospect Theory informs framing; platform-specific writing adapts the structure to each channel.

## Related Skills
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — persuasion principles for the Desire stage
- `composable-skills/frameworks/prospect-theory/SKILL.md` — gain and loss framing
- `composable-skills/frameworks/platform-specific-writing/SKILL.md` — adapting the structure per channel
- `composable-skills/frameworks/elaboration-likelihood-model/SKILL.md` — matching argument depth to reader involvement

## Reference Materials
- Strong, E.K. (1925). "Theories of Selling." *Journal of Applied Psychology*, 9(1), 75–86.
- Lavidge, R.J., & Steiner, G.A. (1961). "A Model for Predictive Measurements of Advertising Effectiveness." *Journal of Marketing*, 25(6), 59–62.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
