---
skill_id: cialdinis-6-principles
name: Cialdini's Principles of Persuasion
version: 2.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply cialdini principles
  - cialdini analysis
  - principles of persuasion
  - social proof
  - reciprocity scarcity authority
  - persuasive copy review
collaborates_with:
  - persuasion-specialist
  - conversion-optimizer
  - influence-strategist
  - content-creator
  - article-writer
ethics_required: true
priority: high
tags: [behavior-science, framework, persuasion, influence, social-proof, copywriting]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Cialdini's Principles of Persuasion

## Purpose
Use Cialdini's principles to understand why people say yes, and to make honest requests more persuasive. Robert Cialdini identified six principles in *Influence* (1984): **reciprocity, commitment and consistency, social proof, authority, liking and scarcity**. He later added a seventh, **unity**, in *Pre-Suasion* (2016). Each describes a mental shortcut that usually serves people well, which is precisely why each one can be abused, so this framework is applied with its ethics, not apart from them.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `cialdinis-6-principles` (slug kept for compatibility; the framework now has seven principles) |
| Category | Behavior Science — Persuasion and Social Influence |
| Version | 2.0.0 |
| Originator | Robert B. Cialdini, Arizona State University |
| First published | 1984 |
| Primary references | *Influence* (1984; new and expanded edition 2021) · *Pre-Suasion* (2016) |

## The Principles
1. **Reciprocity.** People feel obliged to return what they have received. Giving first, genuinely and without strings, creates that obligation.
2. **Commitment and consistency.** Having taken a position, people want to act consistently with it. Small, active, public and voluntary commitments are the strongest.
3. **Social proof.** When uncertain, people look to what others like them are doing.
4. **Authority.** People defer to credible experts. Credibility rests on real expertise and trustworthiness.
5. **Liking.** People say yes to those they like, and liking grows from similarity, genuine compliments and cooperation.
6. **Scarcity.** Things seem more valuable when they are rare or becoming less available.
7. **Unity** (added in *Pre-Suasion*). People are influenced by those they see as part of a shared identity, "one of us".

## Core Principles
- **Each principle is a shortcut that usually works for people.** That is why it persuades, and why misusing it is a breach of trust.
- **The principle must be true.** Social proof needs real numbers, authority needs real credentials, scarcity needs a real limit.
- **Similarity sharpens social proof.** Evidence from people like the audience persuades far more than evidence from people in general.
- **Small commitments lead to larger ones.** Ask for a small, freely chosen first step.
- **Combine principles with care.** Stacking several cheaply makes a message feel manipulative.

## Applications & Use Cases
| Use Case | Application | Principle |
|---|---|---|
| Landing pages | Show real usage, reviews or customers similar to the visitor | Social proof |
| Free trials and content | Give genuine value before asking | Reciprocity |
| Onboarding | Ask for a small, active first commitment | Commitment and consistency |
| Expert or enterprise sales | Surface real credentials and evidence early | Authority |
| Limited offers | Communicate a real deadline or limit, never an invented one | Scarcity |
| Community and membership | Build a genuine shared identity | Unity |

## Usage Guidelines
- **Audit what is already true** about the offer before writing anything: the real numbers, credentials, limits and shared identity.
- **Match the principle to the audience's uncertainty.** Social proof helps the undecided; authority helps where expertise matters.
- **Use the most similar evidence available.** A testimonial from a peer outweighs one from a celebrity.
- **Make commitments active and voluntary.** A pre-ticked box is not a commitment.
- **Test each principle separately** before combining, so you know which one actually moved the result.

## Prompt Template
```
You are applying Cialdini's principles of persuasion (Cialdini 1984; unity, 2016).

REQUEST: [[what you want the person to do]]
AUDIENCE: [[who, and what they are uncertain about]]

TRUTH AUDIT — only use what is true:
- Real social proof (numbers, similar customers):
- Real authority (credentials, evidence):
- Real scarcity (actual limit or deadline):
- Genuine value you can give first:
- Genuine shared identity:

PRINCIPLES
1 reciprocity · 2 commitment and consistency · 3 social proof · 4 authority · 5 liking · 6 scarcity · 7 unity

OUTPUT: which principles apply, the exact wording or design change, and an ethics check that every claim is true.
```

## Ethical Guidelines
- **Never fabricate.** Invented testimonials, fake counts, false deadlines and borrowed credentials are deception, not persuasion.
- **Scarcity must be real.** "Only 2 left" when stock is plentiful is a dark pattern and, in many places, a consumer-protection breach.
- **Reciprocity must be a gift, not a trap.** Free things with hidden obligations damage trust.
- **Respect the decision.** Persuasion presents a true case well; it does not remove the person's ability to say no.

## Testing Strategy
- A/B test one principle at a time against the existing version.
- Measure downstream outcomes such as refunds, churn and complaints, not just conversion.
- Check results across segments; social proof from one group can repel another.

## Success Metrics
- Conversion on the specific request.
- Refund, cancellation and complaint rates, as a check on persuasion without regret.
- Trust indicators such as review ratings and repeat purchase.

## Collaboration Protocol
- Inbound from: `persuasion-specialist` · `conversion-optimizer` · `content-creator` · `article-writer`
- Outbound to: CSO office for claims in regulated sectors, where advertising rules apply to authority and scarcity
- Cross-framework: Prospect Theory pairs with scarcity; Elaboration Likelihood Model explains when principles work as peripheral cues; AIDA gives structure to a persuasive message.

## Related Skills
- `composable-skills/frameworks/prospect-theory/SKILL.md` — loss framing behind scarcity
- `composable-skills/frameworks/elaboration-likelihood-model/SKILL.md` — when shortcuts persuade and when arguments do
- `composable-skills/frameworks/aida/SKILL.md` — structuring the message the principles sit in
- `composable-skills/frameworks/social-learning-theory/SKILL.md` — the mechanics behind social proof

## Reference Materials
- Cialdini, R.B. (1984). *Influence: The Psychology of Persuasion.* William Morrow.
- Cialdini, R.B. (2016). *Pre-Suasion: A Revolutionary Way to Influence and Persuade.* Simon & Schuster.
- Cialdini, R.B. (2021). *Influence, New and Expanded: The Psychology of Persuasion.* Harper Business.
- Cialdini, R.B., & Goldstein, N.J. (2004). "Social Influence: Compliance and Conformity." *Annual Review of Psychology*, 55, 591–621.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
