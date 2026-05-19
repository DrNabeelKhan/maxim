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
updated: 2026-05-19
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

### Level 1 — Visceral (pre-cognitive · 100ms)
- Immediate, automatic emotional response
- Triggered by sensory characteristics (color · shape · sound · texture · symmetry · proportion · faces)
- Cross-cultural near-universals (e.g., faces · sweet flavors · golden ratio proportions)
- Cannot be reasoned away — visceral reaction precedes cognition

### Level 2 — Behavioral (cognitive use · seconds-to-minutes)
- Pleasure or frustration from USING the product
- Effectiveness · efficiency · understandability · feedback
- This is where traditional usability lives (Nielsen's heuristics · Don Norman's earlier *Design of Everyday Things*)

### Level 3 — Reflective (meaning · long-term)
- Self-image · memory · storytelling about the product
- "Does this product reflect who I want to be?"
- "Will I be proud to mention this purchase?"
- Most luxury / craft / artisanal positioning lives here

The three levels are not hierarchical — they operate in parallel and feed each other. Visceral attraction can amplify behavioral satisfaction (aesthetic-usability effect). Reflective meaning can rescue products with mediocre behavioral usability (Apple iconic products in early years).

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
- Pre-attentive attributes (visual hierarchy readable in 100ms?)
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
- **Visceral is fast and powerful.** A product's first 100ms impression sets expectations that influence behavioral perception for the entire session.
- **Aesthetic-usability effect is real.** Aesthetically pleasing products are PERCEIVED as easier to use, even when objectively equal. (Tractinsky et al. 2000)
- **Reflective level drives long-term loyalty.** Behavioral satisfaction alone produces switching when a slightly better behavioral option appears. Reflective meaning produces sticky preference.
- **Beautiful broken things vs ugly working things.** A beautiful product with mediocre behavioral design often beats an ugly product with perfect behavioral design in user-preference studies.
- **Affect changes cognition.** Positive affect broadens attention and creativity; negative affect narrows focus and triggers risk-aversion. Design affects how users will engage with content.

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
- Norman, D.A. (1988). *The Design of Everyday Things.* Basic Books.
- Tractinsky, N., Katz, A.S., & Ikar, D. (2000). "What is beautiful is usable." *Interacting with Computers* 13(2): 127–145.
- Nielsen Norman Group on Emotional Design — https://www.nngroup.com/books/emotional-design/

## Usage Guidelines
- Audit all three levels in design reviews; most teams only check behavioral.
- Aesthetic improvement is not a vanity item; it's leverage on perceived usability.
- For premium positioning, visceral and reflective drive price tolerance more than behavioral.
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
- Long-term retention (reflective-driven products retain better than behavior-only)

## Related Skills
- `composable-skills/frameworks/fitts-law/SKILL.md` (if exists) — behavioral level
- `composable-skills/frameworks/color-psychology/SKILL.md` (if exists) — visceral level
- `composable-skills/frameworks/cialdinis-6-principles/SKILL.md` — reflective social proof
- `composable-skills/frameworks/self-determination-theory/SKILL.md` — reflective autonomy support
- `composable-skills/frameworks/cognitive-load-theory/SKILL.md` — behavioral capacity

## Testing Strategy
- Three-level user research:
  - Visceral: 100ms first-impression study (image flash + word association)
  - Behavioral: task-based usability study (effectiveness · efficiency · error rate)
  - Reflective: post-session interview about identity / meaning / memory
- A/B test designs varying ONLY visceral attributes (color · proportion) keeping behavioral identical
- Expected: 10–25% perceived-usability lift from purely visceral improvements

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in v1.2.0 final WS6b (2026-05-19)._
