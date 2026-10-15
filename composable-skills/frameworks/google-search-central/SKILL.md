---
skill_id: google-search-central
name: Google Search Central
version: 2.0.0
category: search-visibility
type: framework
frameworks: []
triggers:
  - google search central
  - search essentials
  - technical seo audit
  - indexing problem
  - robots.txt and canonical
collaborates_with:
  - seo-specialist
  - technical-seo-auditor
  - keyword-intent-researcher
ethics_required: true
priority: high
tags: [search-visibility, framework, technical-seo, indexing, google]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Google Search Central

## Purpose
Use Google Search Central, Google's official documentation for site owners, as the authoritative reference for how Google finds, understands and ranks pages. Its core is **Google Search Essentials**, which replaced the Webmaster Guidelines in October 2022 and has three parts: technical requirements, spam policies, and key best practices. Starting from the primary source avoids the folklore that surrounds search optimisation.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `google-search-central` |
| Category | Search Visibility — Official Search Guidance |
| Version | 2.0.0 |
| Owner | Google (developers.google.com/search) |
| Core document | Google Search Essentials (formerly the Webmaster Guidelines, renamed October 2022) |
| Tools | Google Search Console · URL Inspection · Rich Results Test |

## How Search Works, in Three Stages
1. **Crawling.** Googlebot discovers and fetches pages, through links and sitemaps.
2. **Indexing.** Google analyses the page and decides whether to store it, choosing a canonical among duplicates.
3. **Serving.** Google returns the most relevant, useful results for each query.

### Google Search Essentials
- **Technical requirements**: Googlebot can access the page, it returns HTTP 200, and it has indexable content.
- **Spam policies**: practices that can lead to lower ranking or removal, such as cloaking, scaled content abuse and link spam.
- **Key best practices**: create helpful, people-first content; use the words people search for; make links crawlable.

## Core Principles
- **robots.txt controls crawling, not indexing.** To keep a page out of the index, allow crawling and use `noindex`.
- **Canonicals are hints.** Google may choose a different canonical than the one you declare if signals conflict.
- **Search Console is the ground truth for your site**: indexing status, coverage issues and search performance.
- **Helpful content first.** Technical correctness enables ranking; it does not create relevance.
- **Avoid the spam policies entirely**, rather than testing their edges.

## Applications & Use Cases
| Use Case | Application | Tool or document |
|---|---|---|
| Pages not indexed | Inspect the URL and read the reported reason | URL Inspection |
| Duplicate content | Consolidate with canonicals and redirects | Canonicalisation docs |
| Site migrations | Map redirects and monitor coverage | Site move guidance |
| Structured data | Validate eligibility for rich results | Rich Results Test |
| Traffic drops | Check manual actions, then algorithm updates | Search Console |
| New site launch | Submit a sitemap and verify ownership | Search Console |

## Usage Guidelines
- **Verify the site in Search Console** before anything else; it is the primary diagnostic.
- **Check the technical requirements first** for any page that is not performing: access, status code, indexability.
- **Use `noindex`, not robots.txt,** to keep pages out of results.
- **Keep one canonical URL per piece of content**, with redirects and consistent internal links.
- **Cite the Search Central page** when making a recommendation, rather than an unattributed rule.

## Prompt Template
```
You are applying Google Search Central guidance.

ISSUE: [[what is wrong]]   URL: [[url]]
CRAWLING: can Googlebot access it? robots.txt? status code?
INDEXING: is it indexed? Declared vs Google-selected canonical? noindex?
SERVING: does it match the query intent? Helpful, people-first content?
SPAM POLICY RISK: any practice that could be classed as spam?
FIX: specific action, with the Search Central document it follows from.
```

## Ethical Guidelines
- **Follow the spam policies.** Cloaking, hidden text, scaled low-value content and link schemes harm users and risk removal.
- **Do not misrepresent content** to search engines or users.

## Testing Strategy
- Use URL Inspection to confirm how Google sees a page after a change.
- Track coverage and performance in Search Console over weeks, since changes take time to reflect.

## Success Metrics
- Indexed versus submitted pages.
- Coverage errors over time.
- Impressions, clicks and average position in Search Console.

## Collaboration Protocol
- Inbound from: `seo-specialist` · `technical-seo-auditor` · `keyword-intent-researcher`
- Outbound to: `frontend-developer` for technical fixes
- Cross-framework: E-E-A-T for quality; Core Web Vitals for page experience; Schema.org for structured data.

## Related Skills
- `composable-skills/frameworks/e-e-a-t/SKILL.md` — content quality and trust
- `composable-skills/frameworks/core-web-vitals/SKILL.md` — page experience
- `composable-skills/frameworks/schemaorg/SKILL.md` — structured data
- `composable-skills/frameworks/search-intent-mapping/SKILL.md` — matching content to queries

## Reference Materials
- Google Search Central. *Google Search Essentials.* developers.google.com/search/docs/essentials.
- Google Search Central. *In-depth guide to how Google Search works.*
- Google Search Central blog. Announcement renaming the Webmaster Guidelines to Google Search Essentials, October 2022.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
