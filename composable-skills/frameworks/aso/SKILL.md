---
skill_id: aso
name: ASO
version: 2.0.0
category: content-marketing
type: framework
frameworks: []
triggers:
  - app store optimization
  - aso
  - app store listing
  - improve app downloads
  - app keywords
collaborates_with:
  - app-store-optimizer
  - content-creator
  - growth-hacker
  - analytics-reporter
ethics_required: true
priority: medium
tags: [content-marketing, framework, app-stores, mobile, conversion]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# ASO

## Purpose
Use App Store Optimization to help the right people find an app in the Apple App Store and Google Play, and to convince them to install it once they land on the listing. ASO has two halves: **visibility**, through the metadata the stores index for search, and **conversion**, through the icon, screenshots, video, ratings and description that persuade a visitor. The two stores index different fields and offer different testing tools, so optimise each separately.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `aso` |
| Category | Content Marketing — App Store Optimization |
| Version | 2.0.0 |
| Authoritative sources | Apple App Store Review Guidelines and App Store Connect documentation · Google Play Console documentation |
| Note | Field limits and features change; confirm them in each store's current documentation |

## The Levers
**Visibility (search)**
- **App name / title** and **subtitle** (Apple) or **short description** (Google Play).
- **Keyword field** (Apple only), which is indexed but not shown to users.
- **Full description**, which Google Play indexes for search; Apple does not use it for search ranking.
- **Category** selection.

**Conversion (the listing)**
- **Icon**, the first thing seen in search results.
- **Screenshots and preview video**, which carry most of the persuasion.
- **Ratings and reviews**, both the average and recent written reviews.
- **Store-native tools**: Apple custom product pages and in-app events; Google Play store listing experiments and custom store listings.

## Core Principles
- **Visibility and conversion are separate problems.** Ranking for a keyword is wasted if the listing does not convert.
- **The first screenshots do most of the work.** Many visitors never scroll past them.
- **Each store indexes different fields.** What helps in one may do nothing in the other.
- **Ratings drive both trust and ranking.** Ask for reviews at moments of satisfaction, within store rules.
- **Test with the stores' own tools** where available, since they measure real store visitors.

## Applications & Use Cases
| Use Case | Application | Lever |
|---|---|---|
| New app launch | Research keywords and write metadata per store | Visibility |
| Low install rate | Redesign the first screenshots around the main benefit | Conversion |
| Seasonal campaigns | Use in-app events or custom listings | Conversion |
| Paid campaigns | Point ads at tailored custom product pages | Conversion |
| Rating decline | Fix the issues behind recent reviews, then prompt satisfied users | Ratings |
| Localisation | Translate and adapt metadata and screenshots per market | Both |

## Usage Guidelines
- **Research keywords per store and per locale**; search behavior differs.
- **Confirm current field limits** in each store's documentation before writing metadata.
- **Lead screenshots with the core benefit**, not the login screen.
- **Use the official in-app review prompts**, which the stores govern, rather than custom rating gates.
- **Test one listing element at a time** with the store's experiment tools.

## Prompt Template
```
You are optimising an app store listing.

APP AND CORE BENEFIT: [[what it does for whom]]
STORE: Apple App Store | Google Play (optimise each separately)

VISIBILITY
- Target keywords per locale:
- Name / title and subtitle or short description:
- Apple keyword field (Apple only):

CONVERSION
- Icon:
- First three screenshots, each with one benefit:
- Review strategy within store rules:

TEST PLAN using the store's own experiment tools:
```

## Ethical Guidelines
- **Do not buy or fake reviews**, and do not incentivise ratings; both breach store rules.
- **Keep screenshots and claims accurate**; misleading listings breach review guidelines and raise uninstalls.
- **Do not stuff competitors' trademarks** into metadata.

## Testing Strategy
- Use Google Play store listing experiments and Apple product page optimization to test variants.
- Measure installs and early retention, not just conversion.

## Success Metrics
- Keyword rankings for target terms.
- Listing conversion rate (visitors to installs).
- Average rating and review volume.
- Day-one and day-seven retention of new installs.

## Collaboration Protocol
- Inbound from: `app-store-optimizer` · `growth-hacker` · `content-creator`
- Outbound to: `analytics-reporter` for conversion and retention tracking
- Cross-framework: A/B testing principles apply to store experiments; brand guidelines govern visual assets.

## Related Skills
- `composable-skills/frameworks/ab-testing/SKILL.md` — experiment discipline for listing tests
- `composable-skills/frameworks/brand-guidelines/SKILL.md` — consistent icon and screenshot style
- `composable-skills/frameworks/search-intent-mapping/SKILL.md` — understanding what users search for

## Reference Materials
- Apple. *App Store Review Guidelines* and *App Store Connect Help.* developer.apple.com.
- Google. *Play Console Help: Store listing and experiments.* support.google.com.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
