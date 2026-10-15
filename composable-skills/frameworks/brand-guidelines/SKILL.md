---
skill_id: brand-guidelines
name: Brand Guidelines
version: 2.0.0
category: content-marketing
type: framework
frameworks: []
triggers:
  - brand guidelines
  - brand book
  - style guide
  - logo usage rules
  - voice and tone guide
collaborates_with:
  - brand-guardian
  - content-creator
  - ui-designer
  - social-media-strategist
  - article-writer
ethics_required: false
priority: medium
tags: [content-marketing, framework, brand, identity, voice]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Brand Guidelines

## Purpose
Use brand guidelines to make a brand recognisable and consistent wherever it appears, by defining its strategy, voice and visual identity precisely enough that different people produce work that looks and sounds like the same company. Guidelines exist because consistency builds recognition and trust over time, and because without written rules every new designer or writer reinvents the brand a little.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `brand-guidelines` |
| Category | Content Marketing — Brand Identity |
| Version | 2.0.0 |
| Key references | Wheeler, *Designing Brand Identity* · Aaker, *Building Strong Brands* (1996) · Keller, customer-based brand equity (1993) |

## What Guidelines Cover
- **Strategy**: purpose, positioning, audience and the promise the brand makes.
- **Voice and tone**: the brand's personality in words, and how tone shifts by context while the voice stays constant.
- **Logo**: approved versions, clear space, minimum size and examples of misuse.
- **Colour**: primary and secondary palettes with values for screen and print, and accessible contrast pairings.
- **Typography**: typefaces, hierarchy and usage rules.
- **Imagery and iconography**: style, subject matter and what to avoid.
- **Layout**: grids, spacing and templates for common formats.

## Core Principles
- **Consistency builds recognition.** Repeated, consistent exposure is how a brand becomes familiar.
- **Voice is constant; tone adapts.** The same personality speaks differently in an error message and in a launch.
- **Show, do not just tell.** Examples of correct and incorrect use teach faster than rules alone.
- **Accessibility is part of the brand.** Colour pairings must meet contrast requirements.
- **Guidelines are a living tool.** Version them and update them as the brand evolves.

## Applications & Use Cases
| Use Case | Application | Section used |
|---|---|---|
| Onboarding designers and writers | A single reference for how the brand looks and sounds | All |
| Agency and partner briefs | Clear rules for external producers | Logo, colour, typography |
| Product UI | Consistent colour, type and tone in the interface | Colour, voice |
| Marketing campaigns | Recognisable assets across channels | Imagery, layout |
| Rebrands | Defining and rolling out a new identity | Strategy, all |
| Brand audits | Checking existing material against the rules | All |

## Usage Guidelines
- **Start with strategy**; visual rules without a positioning produce consistency without meaning.
- **Write voice principles with examples** of what to say and what not to say.
- **Specify colour values for every medium** and the approved accessible combinations.
- **Include misuse examples** for the logo and key assets.
- **Assign an owner and a version number**, and record changes.

## Prompt Template
```
You are writing or auditing brand guidelines.

STRATEGY: purpose · positioning · audience · promise
VOICE: 3-4 personality traits, each with "we say / we don't say" examples
TONE BY CONTEXT: e.g. onboarding, errors, marketing, support
VISUAL: logo rules · colour with values and accessible pairs · typography · imagery
AUDIT (if reviewing material): where does it depart from the guidelines, and does it matter?
```

## Ethical Guidelines
- **Do not imitate another brand's identity** closely enough to cause confusion.
- **Keep claims in brand messaging truthful**; a consistent voice does not excuse an inaccurate promise.

## Testing Strategy
- Audit a sample of recent material against the guidelines periodically.
- Test recognition with users unfamiliar with the brand.

## Success Metrics
- Share of audited material that complies.
- Brand recognition and recall measures.
- Time for new contributors to produce on-brand work.

## Collaboration Protocol
- Inbound from: `brand-guardian` · `ui-designer` · `content-creator`
- Outbound to: `ui-designer` for design-system tokens; `article-writer` for voice
- Cross-framework: Design systems implement the visual rules in product; WCAG sets the contrast requirements.

## Related Skills
- `composable-skills/frameworks/design-systems/SKILL.md` — implementing brand rules in product
- `composable-skills/frameworks/wcag/SKILL.md` — accessible colour and type
- `composable-skills/frameworks/platform-specific-writing/SKILL.md` — voice across channels

## Reference Materials
- Wheeler, A. (2017). *Designing Brand Identity: An Essential Guide for the Whole Branding Team* (5th ed.). Wiley. (6th ed., 2024, with R. Meyerson, is subtitled *A Comprehensive Guide to the World of Brands and Branding*.)
- Aaker, D.A. (1996). *Building Strong Brands.* Free Press.
- Keller, K.L. (1993). "Conceptualizing, Measuring, and Managing Customer-Based Brand Equity." *Journal of Marketing*, 57(1), 1–22.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
