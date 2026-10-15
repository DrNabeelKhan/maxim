---
skill_id: schemaorg
name: Schema.org
version: 2.0.0
category: search-visibility
type: framework
frameworks: []
triggers:
  - schema.org markup
  - structured data
  - json-ld
  - rich results
  - entity markup
collaborates_with:
  - aeo-strategist
  - technical-seo-auditor
  - article-writer
  - documentation-writer
ethics_required: true
priority: high
tags: [search-visibility, framework, structured-data, json-ld, entities]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Schema.org

## Purpose
Use Schema.org vocabulary to describe the things a page is about, such as an organisation, a person, a product or an article, in a machine-readable form that search engines and other systems can parse reliably. It was launched in 2011 by Google, Microsoft and Yahoo, with Yandex joining later the same year. Beyond eligibility for some rich results, its lasting value is building a consistent **entity graph**: stable identifiers that tell machines which pages describe the same real thing.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `schemaorg` |
| Category | Search Visibility — Structured Data |
| Version | 2.0.0 |
| Founded | 2011 by Google, Microsoft (Bing) and Yahoo; Yandex joined in 2011 |
| Formats | JSON-LD (recommended by Google) · Microdata · RDFa |
| Validation | Schema Markup Validator (validator.schema.org) · Google Rich Results Test |

## Key Concepts
- **Types and properties.** Everything is a `Thing` with more specific types such as `Organization`, `Person`, `Product` and `Article`.
- **`@id`** gives an entity a stable identifier, so several pages and sites can refer to the same entity rather than each describing a new one.
- **`sameAs`** links an entity to its other authoritative profiles.
- **Nesting and references** connect entities, for example an article's `author` pointing to a `Person` by `@id`.

**Rich results are a subset.** Google supports only some types for rich results, and it has restricted or retired several over time, for example FAQ and HowTo rich results were restricted in 2023. Check the current list rather than assuming a type earns a rich result.

## Core Principles
- **Markup must match visible content.** Marking up questions, reviews or prices that are not on the page is against Google's guidelines.
- **Parse, do not grep.** Validate JSON-LD by parsing it; a regex check misses structural errors.
- **One entity, one `@id`, everywhere.** Minting a new unidentified node for an entity that already exists forks it.
- **Use the most specific type that fits.**
- **Structured data describes; it does not guarantee display.**

## Applications & Use Cases
| Use Case | Application | Types |
|---|---|---|
| Organisation identity | Define the organisation once with `@id`, logo and `sameAs` | Organization |
| Authorship | Link articles to a `Person` by `@id` | Article, Person |
| Products and offers | Price, availability and reviews matching the page | Product, Offer |
| Software | Version, licence and publisher | SoftwareApplication |
| Cross-site entity graph | Reference the same `@id` from every related property | Any |
| Breadcrumbs | Show site hierarchy | BreadcrumbList |

## Usage Guidelines
- **Use JSON-LD**, and render it in the served HTML rather than only client-side.
- **Give every important entity a stable `@id`** and reference it instead of redefining it.
- **Keep markup and visible content in sync**; never mark up what the page does not show.
- **Validate with the Schema Markup Validator and the Rich Results Test**, then confirm in Search Console.
- **Re-check after every template change**, since markup often breaks silently.

## Prompt Template
```
You are writing or auditing Schema.org structured data.

ENTITIES ON THIS PAGE: [[organisation, person, product, article...]]
FOR EACH
- Most specific type:
- @id (stable, reused across pages and sites):
- Required and recommended properties:
- References to other entities by @id:
VISIBLE-CONTENT CHECK: is everything marked up actually shown on the page?
VALIDATION: Schema Markup Validator and Rich Results Test results.
```

## Ethical Guidelines
- **Never mark up content that is not visible**, such as hidden FAQs or fabricated reviews; this is cloaking.
- **Do not invent ratings, reviews or credentials** in markup.

## Testing Strategy
- Parse the served HTML and assert on the JSON-LD objects, not on strings.
- Validate after every deploy that touches templates.

## Success Metrics
- Pages with valid structured data and zero parse errors.
- Rich result eligibility and impressions where applicable.
- Consistency of `@id` references across pages and properties.

## Collaboration Protocol
- Inbound from: `aeo-strategist` · `technical-seo-auditor` · `documentation-writer`
- Outbound to: `frontend-developer` for templates
- Cross-framework: Google Search Central for supported features; E-E-A-T for authorship; LLM visibility, where the entity graph helps AI systems.

## Related Skills
- `composable-skills/frameworks/google-search-central/SKILL.md` — supported structured-data features
- `composable-skills/frameworks/e-e-a-t/SKILL.md` — authorship and organisation signals
- `composable-skills/frameworks/llm-visibility/SKILL.md` — entities for AI answers

## Reference Materials
- Schema.org. *Schemas and documentation.* schema.org.
- Google Search Central. *Introduction to structured data* and *General structured data guidelines.*
- Google Search Central blog. Changes to FAQ and HowTo rich results, August 2023.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
