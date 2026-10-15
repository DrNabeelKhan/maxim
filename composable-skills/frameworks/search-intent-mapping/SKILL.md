---
skill_id: search-intent-mapping
name: Search Intent Mapping
version: 2.0.0
category: search-visibility
type: framework
frameworks: []
triggers:
  - search intent
  - keyword intent mapping
  - what are people searching for
  - match content to queries
  - informational vs transactional
collaborates_with:
  - keyword-intent-researcher
  - seo-specialist
  - content-creator
  - article-writer
ethics_required: false
priority: high
tags: [search-visibility, framework, keyword-research, intent, content-strategy]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Search Intent Mapping

## Purpose
Use search intent mapping to work out what a searcher actually wants from a query, and to match each query to the type of page that satisfies it. A page can be excellent and still fail because it answers the wrong need: a buying guide for a query where people want a definition, or a product page for a query where people are still researching. Mapping intent before writing is the cheapest way to avoid that mismatch.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `search-intent-mapping` |
| Category | Search Visibility — Keyword and Intent Research |
| Version | 2.0.0 |
| Foundational taxonomy | Broder, "A taxonomy of web search", *SIGIR Forum* (2002): navigational, informational, transactional |
| Related | Google's rater guidelines classify intent as Know, Do, Website and Visit-in-person |

## Intent Types
- **Informational**: the searcher wants to learn something. Best served by guides, explanations and answers.
- **Navigational**: the searcher wants a specific site or page. Best served by that page.
- **Commercial investigation**: the searcher is comparing options before deciding. Best served by comparisons and reviews.
- **Transactional**: the searcher wants to act, such as buying or signing up. Best served by product, pricing or sign-up pages.

Broder's 2002 taxonomy has three types; practitioners commonly split out commercial investigation as a fourth.

**The results page is the evidence.** The kinds of pages Google already ranks for a query are the clearest signal of the intent it has inferred.

## Core Principles
- **Intent decides the page type,** and the page type decides whether you can rank.
- **Look at the live results** before deciding intent; the ranking pages reveal it.
- **Many queries have mixed intent.** Serve the dominant one first.
- **One primary intent per page.** A page trying to inform and sell at once often does neither well.
- **Intent shifts over time and by context,** for example around events or seasons.

## Applications & Use Cases
| Use Case | Application | Intent |
|---|---|---|
| Planning new content | Group keywords by intent and assign a page type to each group | All |
| Pages that rank but do not convert | Check whether the page type matches the query intent | Transactional |
| Pages that never rank | Compare against the page types that do rank | All |
| Comparison content | Serve commercial-investigation queries with honest comparisons | Commercial |
| Site architecture | Map intent groups to sections of the site | All |
| Answer-engine visibility | Answer informational queries directly and early | Informational |

## Usage Guidelines
- **Collect the target queries**, then review the current results for each.
- **Classify the dominant intent** from the types of pages ranking.
- **Group queries that share intent** and map each group to one page.
- **Choose the page format the results favour**: guide, comparison, product page or tool.
- **Answer the core question early** on informational pages, then expand.

## Prompt Template
```
You are mapping search intent (Broder 2002; informational, navigational, commercial, transactional).

QUERY: [[the search]]
LIVE RESULTS: what page types currently rank?
DOMINANT INTENT:
SECONDARY INTENT, if mixed:
PAGE TYPE TO BUILD:
WHAT THE PAGE MUST ANSWER FIRST:
QUERIES TO GROUP ONTO THE SAME PAGE:
```

## Ethical Guidelines
- **Serve the intent honestly.** Pages that bait an informational query with a sales pitch frustrate users.
- **Comparisons must be fair**, including where a competitor is the better choice.

## Testing Strategy
- Track ranking, click-through and engagement by intent group.
- Revisit intent classifications periodically, since the results pages change.

## Success Metrics
- Rankings and click-through for mapped query groups.
- Engagement suited to the intent, such as reading for informational pages and conversion for transactional ones.
- Share of pages with one clear primary intent.

## Collaboration Protocol
- Inbound from: `keyword-intent-researcher` · `seo-specialist` · `content-creator`
- Outbound to: `article-writer` with the page type and the question to answer first
- Cross-framework: Jobs-to-be-Done explains the motive behind a query; content calendar schedules the mapped pages.

## Related Skills
- `composable-skills/frameworks/google-search-central/SKILL.md` — how Google serves results
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — the job behind the search
- `composable-skills/frameworks/content-calendar/SKILL.md` — scheduling mapped content
- `composable-skills/frameworks/llm-visibility/SKILL.md` — answering questions AI systems field

## Reference Materials
- Broder, A. (2002). "A taxonomy of web search." *SIGIR Forum*, 36(2), 3–10.
- Google. *Search Quality Rater Guidelines* (user intent and Needs Met).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
