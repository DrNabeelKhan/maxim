---
skill_id: llm-visibility
name: LLM Visibility
version: 2.0.0
category: search-visibility
type: framework
frameworks: []
triggers:
  - llm visibility
  - generative engine optimization
  - geo
  - get cited by ai assistants
  - llms.txt
  - answer engine optimization
collaborates_with:
  - geo-optimizer
  - seo-specialist
  - article-writer
  - authority-builder
ethics_required: true
priority: high
tags: [search-visibility, framework, geo, aeo, ai-search, entities]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# LLM Visibility

## Purpose
Use LLM visibility, also called generative engine optimization (GEO), to make content more likely to be retrieved, quoted and cited accurately by AI assistants and AI search. These systems assemble answers from sources rather than listing links, so being a clear, citable, unambiguous source matters more than ranking position. The field is young: some practices have research behind them, others are emerging conventions, and this definition labels which is which.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `llm-visibility` |
| Category | Search Visibility — Generative and Answer Engines |
| Version | 2.0.0 |
| Research basis | Aggarwal et al., "GEO: Generative Engine Optimization", KDD 2024 (arXiv, 2023) |
| Emerging convention | `llms.txt`, proposed by Jeremy Howard in 2024; adoption by AI providers is not established |
| Maturity | Emerging; practices change quickly |

## The Practices

**Supported by research.** Aggarwal et al. tested content changes against generative engines and found that adding citations to sources, quotations and statistics improved how visibly a source appeared in generated answers.

**Established web practice that carries over**
- **Crawlability for AI crawlers**: robots.txt rules that name the AI crawlers you want to allow.
- **Server-rendered content**, since many crawlers do not execute JavaScript.
- **Structured data and a consistent entity graph**, so systems can tell which pages describe the same thing.
- **Answer-first writing**: the direct answer in the opening sentences, naming the entity rather than "we".

**Emerging conventions**
- **`llms.txt`**: a plain-text summary for language models. Useful and cheap, but treat its effect as unproven.

## Core Principles
- **Be quotable.** A sentence that makes sense out of context, names its subject and states a fact can be lifted into an answer intact.
- **Name the entity.** "Maxim does X" survives extraction; "we do X" loses its attribution.
- **Disambiguate.** A name shared with other things needs explicit context about which one you are.
- **Accuracy is the whole point.** AI systems repeat what they find, so errors propagate and retractions do not.
- **Measure by asking.** Query the assistants your audience uses and record whether and how you are cited.

## Applications & Use Cases
| Use Case | Application | Practice |
|---|---|---|
| Product definitions | One quotable sentence defining what the product is | Answer-first writing |
| Ambiguous brand names | A disambiguation block stating what you are not | Disambiguation |
| Factual claims | Cite sources and include specific figures with attribution | Research-backed |
| Multi-site organisations | Shared `@id`s and reciprocal links | Entity graph |
| AI crawler access | Name allowed AI crawlers in robots.txt | Crawlability |
| Monitoring | A fixed set of probe questions run on a schedule | Measurement |

## Usage Guidelines
- **Write the one-sentence definition first**, so it can be quoted verbatim with no surrounding context.
- **Name the entity in every key answer** rather than using pronouns.
- **Cite sources and use specific, attributed figures**, which the GEO research associates with greater visibility.
- **Render content and structured data server-side**, and allow the AI crawlers you want in robots.txt.
- **Track a fixed probe set** across assistants over time, and treat single responses as anecdotes.

## Prompt Template
```
You are improving LLM visibility (Aggarwal et al. 2024).

ENTITY: [[what you want AI systems to describe correctly]]
ONE-SENTENCE DEFINITION, quotable without context:
DISAMBIGUATION: what this is NOT, if the name is shared:
KEY CLAIMS, each with a source:
TECHNICAL: AI crawlers allowed? Content server-rendered? Entity @ids consistent?
PROBE QUESTIONS to track, and current results:
Label each recommendation: research-backed | established practice | emerging.
```

## Ethical Guidelines
- **Every claim must be true and checkable.** AI systems repeat errors, and corrections rarely catch up.
- **Do not attempt to manipulate model outputs** with hidden text or prompt-injection content; it is deceptive and can backfire.
- **Do not overstate what is proven** in this emerging field.

## Testing Strategy
- Run the same probe questions across several assistants on a schedule and record citations.
- Compare before and after content changes, allowing for the variability of model responses.

## Success Metrics
- Share of probe questions where the entity is cited or described correctly.
- Accuracy of AI descriptions of the entity.
- Referral traffic from AI assistants, where measurable.

## Collaboration Protocol
- Inbound from: `geo-optimizer` · `seo-specialist` · `authority-builder` · `article-writer`
- Outbound to: `technical-seo-auditor` for crawlability and structured data
- Cross-framework: Schema.org for the entity graph; E-E-A-T for credibility; search intent mapping for the questions people ask.

## Related Skills
- `composable-skills/frameworks/schemaorg/SKILL.md` — the entity graph
- `composable-skills/frameworks/e-e-a-t/SKILL.md` — credibility signals
- `composable-skills/frameworks/search-intent-mapping/SKILL.md` — the questions to answer
- `composable-skills/frameworks/no-fabrication/SKILL.md` — evidence-bound claims

## Reference Materials
- Aggarwal, P., Murahari, V., Rajpurohit, T., Kalyan, A., Narasimhan, K., & Deshpande, A. (2024). "GEO: Generative Engine Optimization." *Proceedings of KDD 2024.* arXiv:2311.09735.
- Howard, J. (2024). "The /llms.txt file." llmstxt.org.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
