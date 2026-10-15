---
skill_id: e-e-a-t
name: E-E-A-T
version: 2.0.0
category: search-visibility
type: framework
frameworks: []
triggers:
  - e-e-a-t
  - experience expertise authoritativeness trust
  - content quality review
  - ymyl content
  - helpful content
collaborates_with:
  - seo-specialist
  - article-writer
  - content-creator
  - authority-builder
  - brand-guardian
ethics_required: true
priority: high
tags: [search-visibility, framework, content-quality, trust, ymyl]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# E-E-A-T

## Purpose
Use E-E-A-T, **Experience, Expertise, Authoritativeness and Trust**, to judge and improve how credible a page and its creator appear, using the same concepts Google asks its search quality raters to apply. It comes from Google's Search Quality Rater Guidelines; Google added the first E, for Experience, in December 2022. Raters do not change rankings directly, but their assessments inform how Google evaluates its ranking systems, so E-E-A-T is a reliable guide to what "good" looks like, especially for topics that affect people's health, money or safety.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `e-e-a-t` |
| Category | Search Visibility — Content Quality |
| Version | 2.0.0 |
| Source | Google, *Search Quality Rater Guidelines* |
| Key change | "Experience" added December 2022 (E-A-T became E-E-A-T) |
| Related guidance | Google, "Creating helpful, reliable, people-first content" |

## The Four Elements
- **Experience**: first-hand experience of the topic, such as having used the product or visited the place.
- **Expertise**: the knowledge or skill of the creator.
- **Authoritativeness**: whether the creator or site is a recognised go-to source for the topic.
- **Trust**: whether the page is accurate, honest, safe and reliable. Google describes Trust as the most important member of the family; the other three support it.

**YMYL ("Your Money or Your Life")** topics, those that could significantly affect health, financial stability, safety or society, are held to a higher standard.

## Core Principles
- **Trust is the centre.** Experience, expertise and authority matter because they make content more trustworthy.
- **Show it, do not assert it.** Bylines, credentials, sources and first-hand evidence demonstrate E-E-A-T; claiming it does not.
- **The standard rises with the stakes.** YMYL content needs demonstrable expertise.
- **E-E-A-T is a quality concept, not a single ranking factor.** There is no score to optimise directly.
- **Experience can matter as much as credentials** for topics such as product reviews.

## Applications & Use Cases
| Use Case | Application | Element emphasised |
|---|---|---|
| Health, finance and legal content | Named expert authors, cited sources, review dates | Expertise, Trust |
| Product reviews | Evidence of real use, original photos and testing | Experience |
| About and author pages | Clear identity, credentials and contact details | Authoritativeness, Trust |
| Content audits | Assess pages against the four elements | All |
| Corrections and updates | Visible update dates and correction notes | Trust |
| Site reputation | Earn independent mentions and reviews | Authoritativeness |

## Usage Guidelines
- **Decide whether the topic is YMYL**; if so, require demonstrable expertise and sourcing.
- **Attribute content to a real, identifiable person or organisation** with relevant credentials or experience.
- **Cite primary sources** for factual claims and date the content.
- **Show first-hand experience** where it applies, with original evidence.
- **Make trust signals easy to find**: who runs the site, how to contact them, and policies.

## Prompt Template
```
You are assessing content against E-E-A-T (Google Search Quality Rater Guidelines).

PAGE AND TOPIC: [[url or summary]]   YMYL? yes / no
EXPERIENCE: what first-hand evidence is shown?
EXPERTISE: who created it, and what qualifies them?
AUTHORITATIVENESS: is the creator or site recognised for this topic? Evidence?
TRUST: accuracy, sourcing, transparency, safety. Any red flags?
IMPROVEMENTS: specific changes, most important first, centred on Trust.
```

## Ethical Guidelines
- **Never fabricate credentials, authors, reviews or experience.** Fake E-E-A-T signals are deception and violate Google's spam policies.
- **Do not present AI-generated or unreviewed content as expert-written.**
- **Correct errors visibly**, especially on YMYL topics.

## Testing Strategy
- Audit samples of content against the four elements on a schedule.
- Track performance of pages before and after trust improvements, accepting that search effects are slow and confounded.

## Success Metrics
- Share of YMYL pages with a qualified named author and cited sources.
- Organic visibility trends for audited pages.
- Independent mentions, reviews and links.

## Collaboration Protocol
- Inbound from: `seo-specialist` · `article-writer` · `authority-builder` · `content-creator`
- Outbound to: CSO office for YMYL claims in regulated domains
- Cross-framework: Google Search Central for the full guidance; Schema.org for marking up authorship and organisation; LLM visibility, where the same trust signals help.

## Related Skills
- `composable-skills/frameworks/google-search-central/SKILL.md` — Google's official guidance
- `composable-skills/frameworks/schemaorg/SKILL.md` — marking up authors and organisations
- `composable-skills/frameworks/llm-visibility/SKILL.md` — credibility signals for AI answers
- `composable-skills/frameworks/no-fabrication/SKILL.md` — evidence-bound claims

## Reference Materials
- Google. *Search Quality Rater Guidelines.* (current edition at guidelines.raterhub.com / Google Search Central).
- Google Search Central. "Our latest update to the quality rater guidelines: E-A-T gets an extra E for Experience." December 2022.
- Google Search Central. "Creating helpful, reliable, people-first content."

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
