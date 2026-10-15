---
skill_id: core-web-vitals
name: Core Web Vitals
version: 2.0.0
category: search-visibility
type: framework
frameworks: []
triggers:
  - core web vitals
  - lcp inp cls
  - page speed
  - page experience
  - performance audit
collaborates_with:
  - seo-specialist
  - technical-seo-auditor
  - frontend-developer
  - performance-benchmarker
ethics_required: false
priority: high
tags: [search-visibility, framework, performance, web-vitals, ux]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Core Web Vitals

## Purpose
Use Core Web Vitals to measure and improve three aspects of real users' experience of a page: how fast the main content appears, how quickly the page responds to interaction, and how stable the layout is while it loads. Google defines the metrics and their thresholds, measures them from real Chrome users, and uses them among its page experience signals. They matter for search, but more directly they measure whether a page feels fast and solid to the people using it.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `core-web-vitals` |
| Category | Search Visibility — Page Experience and Performance |
| Version | 2.0.0 |
| Originator | Google (web.dev) |
| Key change | INP replaced FID as the responsiveness metric on 12 March 2024 |
| Thresholds | Assessed at the 75th percentile of page loads, separately for mobile and desktop |

## The Three Metrics
| Metric | Measures | Good | Poor |
|---|---|---|---|
| **LCP** — Largest Contentful Paint | Loading: when the main content is visible | ≤ 2.5 s | > 4.0 s |
| **INP** — Interaction to Next Paint | Responsiveness to user input across the visit | ≤ 200 ms | > 500 ms |
| **CLS** — Cumulative Layout Shift | Visual stability: unexpected layout movement | ≤ 0.1 | > 0.25 |

Values between "good" and "poor" are rated "needs improvement". A page passes when the 75th percentile of its real-user loads is "good" on all three.

**Field data versus lab data.** Field data from the Chrome User Experience Report reflects real users and is what counts. Lab tools such as Lighthouse are for diagnosis and do not measure INP directly.

## Core Principles
- **Field data decides.** A perfect lab score does not mean real users have a good experience.
- **The 75th percentile, not the average.** Slow devices and networks determine the result.
- **Mobile and desktop are assessed separately.** Mobile is usually the harder one.
- **Relevance still dominates ranking.** Good vitals help, but they do not outrank helpful content.
- **Fix causes, not scores.** Large images, render-blocking resources, long JavaScript tasks and unsized media are the usual culprits.

## Applications & Use Cases
| Use Case | Application | Metric |
|---|---|---|
| Slow hero images | Prioritise, compress and correctly size the LCP element | LCP |
| Heavy JavaScript | Break up long tasks, defer non-critical scripts | INP |
| Ads and embeds shifting content | Reserve space with explicit dimensions | CLS |
| Web fonts causing shifts | Use appropriate font-display and matched fallbacks | CLS |
| Slow server response | Reduce time to first byte with caching and a CDN | LCP |
| Pre-launch checks | Lab-test, then confirm in field data after release | All |

## Usage Guidelines
- **Start from field data** in Search Console or the CrUX report to see which pages fail and on which metric.
- **Identify the LCP element** on failing pages and make it load first.
- **Profile interactions** to find long tasks that delay INP.
- **Give every image, video, ad and embed explicit dimensions** to prevent layout shift.
- **Confirm fixes in field data**, which takes time to update, rather than relying on lab scores.

## Prompt Template
```
You are improving Core Web Vitals (Google, web.dev). Thresholds at the 75th percentile:
LCP <= 2.5 s · INP <= 200 ms · CLS <= 0.1

PAGE: [[url]]   DEVICE: mobile | desktop
FIELD DATA: LCP __ · INP __ · CLS __   (source: CrUX / Search Console)

FOR EACH FAILING METRIC
- Likely cause:
- Specific fix:
- How it will be confirmed in field data:
```

## Ethical Guidelines
- **Do not game the metrics** at users' expense, for example by hiding content to improve a score.
- **Performance is an accessibility and equity issue**: users on slower devices and networks are affected most.

## Testing Strategy
- Diagnose with lab tools, then verify with field data over the following weeks.
- Add real-user monitoring to catch regressions before they show in aggregated reports.

## Success Metrics
- Share of URLs passing all three metrics, for mobile and desktop.
- 75th-percentile values for LCP, INP and CLS.
- Engagement or conversion changes on improved pages.

## Collaboration Protocol
- Inbound from: `seo-specialist` · `technical-seo-auditor` · `performance-benchmarker`
- Outbound to: `frontend-developer` for implementation
- Cross-framework: Google Search Central for page-experience guidance; WCAG, since performance and accessibility overlap.

## Related Skills
- `composable-skills/frameworks/google-search-central/SKILL.md` — official search guidance
- `composable-skills/frameworks/wcag/SKILL.md` — overlapping accessibility concerns
- `composable-skills/frameworks/cicd/SKILL.md` — performance budgets in the pipeline

## Reference Materials
- Google. "Web Vitals" and "Defining the Core Web Vitals metrics thresholds." web.dev.
- Google. "Interaction to Next Paint (INP)." web.dev; INP became a Core Web Vital on 12 March 2024.
- Google Search Central. "Understanding Core Web Vitals and Google search results."

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
