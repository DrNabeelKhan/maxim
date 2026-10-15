---
skill_id: emotional-design
name: Emotional Design (Don Norman)
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply emotional design
  - visceral behavioral reflective design
  - Don Norman emotional design
  - aesthetic-usability effect
  - design for delight
collaborates_with:
  - ui-ux-designer
  - behavioral-designer
  - brand-guardian
  - product-strategist
ethics_required: true
priority: medium
tags: [behavior-science, framework, UX, design, emotion]
adr: ADR-007
created: 2026-05-19
updated: 2026-10-15
---

# Emotional Design (Don Norman)

## Purpose
Apply Don Norman's Emotional Design framework to design experiences that work at all three levels of human emotional processing — visceral (immediate · pre-cognitive), behavioral (use · function · effectiveness), and reflective (meaning · self-image · memory). Most product design optimizes one level (usually behavioral) and ignores the other two. Emotional Design explains why aesthetically pleasing products feel easier to use, why memorable products outperform purely functional ones, and why luxury / craft products command price premiums beyond their utility.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `emotional-design` |
| Category | Behavior Science — UX / Affect / Design |
| Version | 1.0.0 |
| Originator | Donald A. Norman (2004) |
| Maturity | Established — Norman's earlier *Design of Everyday Things* established usability; *Emotional Design* extended to affect |
| Primary references | Norman, D. (2004). *Emotional Design: Why We Love (or Hate) Everyday Things.* Basic Books · nngroup.com/books/emotional-design |

## The Three Levels of Emotional Processing

### Level 1 — Visceral (pre-cognitive · fast)
- Immediate, automatic emotional response
- Triggered by sensory characteristics (color · shape · sound · texture · symmetry · proportion · faces)
- Norman lists near-universal visceral responses, such as to symmetry, warmth, sweet tastes and smiling faces
- Comes first and fast, though the reflective level can override it (a feared roller coaster that is enjoyed; acquired tastes)
- Visual-appeal judgments of web pages can form within about 50 ms (Lindgaard et al., 2006)

### Level 2 — Behavioral (cognitive use · seconds-to-minutes)
- Pleasure or frustration from USING the product
- Effectiveness · efficiency · understandability · feedback
- This is where traditional usability lives (Nielsen's heuristics · Don Norman's earlier *Design of Everyday Things*)

### Level 3 — Reflective (meaning · long-term)
- Self-image · memory · storytelling about the product
- "Does this product reflect who I want to be?"
- "Will I be proud to mention this purchase?"
- Most luxury / craft / artisanal positioning lives here

Norman describes the levels as layered, from visceral at the bottom to reflective at the top, with influence running both ways: bottom-up from perception and top-down from thought. Visceral attraction can amplify perceived usability (the aesthetic-usability effect). Reflective meaning can make people more forgiving of usability flaws, though how far it does so is not well quantified.

## Prompt Template
```
You are applying Emotional Design.

CONTEXT:
- Product / interface / experience under design: [[description]]
- User population: [[description]]
- Current design state: [[current approach]]

THREE-LEVEL AUDIT:

VISCERAL (pre-cognitive aesthetic response):
- First-impression quality (color · proportion · symmetry · negative space)
- Pre-attentive attributes (visual hierarchy readable at a glance; appeal judgments form within ~50 ms)
- Emotional tone (warm / cold · serious / playful · approachable / authoritative)
- Cross-cultural pitfalls (color symbolism · iconography · facial direction)

BEHAVIORAL (use experience):
- Effectiveness — does the user accomplish the task?
- Efficiency — minimal cognitive + physical effort?
- Feedback — does the system communicate state changes?
- Error handling — graceful · helpful · respect for user?
- Discoverability — affordances visible?

REFLECTIVE (meaning · memory · self-image):
- Story the product enables the user to tell about themselves
- Memory hooks — what will the user remember after using this?
- Self-image alignment — does this reflect the user's aspired identity?
- Social signaling — how does the user perceive being seen using this?
- Long-term meaning — does the product connect to lasting values?

INTERVENTION DESIGN:
- For weak visceral: review color palette · typography · proportion · pre-attentive hierarchy
- For weak behavioral: usability audit · feedback design · error handling
- For weak reflective: brand narrative · craft signaling · meaning architecture

AESTHETIC-USABILITY EFFECT CHECK:
- If visceral is weak, behavioral perception suffers regardless of actual usability
- Investing in visceral often pays back in perceived usability — not a vanity expense
```

## Core Principles
- **Three levels operate in parallel.** Don't optimize one and ignore the others.
- **Visceral is fast and powerful.** Visual-appeal judgments form within about 50 ms and carry over into perceived usability (Lindgaard et al., 2006).
- **Aesthetic-usability effect is real.** Aesthetically pleasing products are PERCEIVED as easier to use, even when objectively equal. (Tractinsky et al. 2000)
- **The reflective level shapes long-term relationship with a product.** Norman places memory, self-image and meaning here; treat its effect on loyalty as a hypothesis to measure, not a given.
- **Beauty and usability interact in both directions.** Attractive designs are perceived as more usable (Tractinsky et al., 2000), and degraded usability can lower perceived beauty (Tuch et al., 2012). Do not count on beauty to cover behavioral defects.
- **Affect changes cognition.** Positive affect broadens attention and creativity (Fredrickson, 2001). Negative emotions differ: fear tends toward risk aversion, anger toward risk seeking (Lerner & Keltner, 2001).

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Product onboarding | Front-load visceral delight; smooth behavioral path; close with reflective ownership moment | Higher activation + memorable first session |
| Brand identity | Three-level coherence (visceral palette · behavioral consistency · reflective meaning) | Stronger preference |
| Premium positioning | Invest in visceral + reflective; behavioral is table stakes | Justified price premium |
| Error states / failure flows | Soften visceral tone of errors; provide behavioral recovery; protect user's reflective self-image | Lower abandonment + complaint rate |
| Marketing landing pages | Visceral impression in hero · behavioral clarity of value prop · reflective social proof | Higher conversion + memorability |
| Product packaging / unboxing | Visceral first-touch · behavioral satisfaction (snap fit · weight) · reflective story (sustainability · craft) | Premium perception |

## Reference Materials
- Norman, D.A. (2004). *Emotional Design: Why We Love (or Hate) Everyday Things.* Basic Books.
- Norman, D.A. (1988). *The Psychology of Everyday Things.* Basic Books. (Retitled *The Design of Everyday Things* from 1990; revised edition 2013.)
- Lindgaard, G., Fernandes, G., Dudek, C., & Brown, J. (2006). "Attention web designers: You have 50 milliseconds to make a good first impression!" *Behaviour & Information Technology* 25(2), 115–126.
- Tuch, A.N., Roth, S.P., Hornbæk, K., Opwis, K., & Bargas-Avila, J.A. (2012). "Is beautiful really usable? Toward understanding the relation between usability, aesthetics, and affect in HCI." *Computers in Human Behavior* 28(5), 1596–1607.
- Fredrickson, B.L. (2001). "The role of positive emotions in positive psychology: The broaden-and-build theory of positive emotions." *American Psychologist* 56(3), 218–226.
- Lerner, J.S., & Keltner, D. (2001). "Fear, anger, and risk." *Journal of Personality and Social Psychology* 81(1), 146–159.
- Tractinsky, N., Katz, A.S., & Ikar, D. (2000). "What is beautiful is usable." *Interacting with Computers* 13(2): 127–145.
- Nielsen Norman Group on Emotional Design — https://www.nngroup.com/books/emotional-design/

## Usage Guidelines
- Audit all three levels in design reviews; most teams only check behavioral.
- Aesthetic improvement is not a vanity item; it's leverage on perceived usability.
- For premium positioning, invest in visceral and reflective quality as well as behavioral, and test the effect on willingness to pay rather than assuming it.
- For utility products (admin tools · enterprise UIs), don't neglect visceral — but optimize behavioral relentlessly first.

## Collaboration Protocol
- Inbound from: `ui-ux-designer` · `behavioral-designer` · `brand-guardian` · `product-strategist`
- Outbound to: same agents + `seo-specialist` (visceral first-impression on landing pages)
- Cross-framework: pairs with Fitts' Law / Hick's Law (behavioral level), Color Psychology (visceral), Cialdini (reflective social proof), Self-Determination Theory (reflective autonomy support)

## Ethical Guidelines
- Visceral manipulation is real; using visceral appeal to mask behavioral defects (broken feature behind beautiful UI) is unethical
- Reflective appeals that exploit identity insecurity (luxury for status anxiety) are dark patterns
- Aesthetic-usability effect can be used or abused; honest products invest in BOTH levels, not just visceral

## Success Metrics
- First-impression rating (pre-task) vs behavioral satisfaction (post-task)
- Aesthetic-usability gap (if visceral score is high but behavioral low, the design is over-promising)
- Reflective metrics: NPS · brand affinity · would-recommend · "feels like me"
- Long-term retention, compared across designs that differ in reflective quality

## Related Skills
- `composable-skills/frameworks/nielsen-heuristics/SKILL.md` — behavioral level usability
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — reflective social proof
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — reflective autonomy support
- `composable-skills/frameworks/dual-process-theory/SKILL.md` — fast versus deliberate processing

## Testing Strategy
- Three-level user research:
  - Visceral: brief-exposure first-impression study (e.g. 50 ms image flash + rating, after Lindgaard et al. 2006)
  - Behavioral: task-based usability study (effectiveness · efficiency · error rate)
  - Reflective: post-session interview about identity / meaning / memory
- A/B test designs varying ONLY visceral attributes (color · proportion) keeping behavioral identical
- Measure the perceived-usability change; there is no established benchmark for purely visceral improvements

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in v1.2.0 final WS6b (2026-05-19)._
