# Maxim Skill — Search Visibility

> Layer 1 — Supreme Authority | Executive Office: CMO

## Domain

SEO, AEO (Answer Engine Optimization), GEO (Generative Engine Optimization), technical search auditing, keyword intelligence, and authority building. The full search visibility lifecycle — from technical health to AI-era generative search optimization.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`seo-specialist` — CMO Office (sole active agent — absorbs 5 specialists via Op-D)

## Active Agents

- `seo-specialist` — the unified search visibility agent. Invoke with mode signal to activate specific capability. Absorbs all 5 deprecated specialists via Op-D.

**Absorbed into `seo-specialist` (Op-D — not separate agents):**
- `aeo-strategist` → Mode: AEO (answer engine, featured snippets, voice search, Schema.org)
- `geo-optimizer` → Mode: GEO (ChatGPT Search, SGE, Perplexity, generative AI search optimization)
- `technical-seo-auditor` → Mode: Technical (crawlability, indexing, Core Web Vitals, site health)
- `keyword-intent-researcher` → Mode: Keyword (keyword research, search intent, content gaps, competitor keywords)
- `authority-builder` → Mode: Authority (backlinks, digital PR, domain authority, brand mentions)

## Skill Modes

- `AEO` — Answer Engine Optimization: featured snippets, voice search, Schema.org markup, position zero
- `GEO` — Generative Engine Optimization: ChatGPT Search, SGE, Perplexity, AI-generated answer optimization
- `Technical` — Technical SEO: crawlability audits, indexing issues, Core Web Vitals, site health
- `Keyword` — Keyword Intelligence: keyword research, search intent mapping, content gap analysis, competitor keywords
- `Authority` — Authority Building: backlink strategy, digital PR, domain authority growth, brand mention monitoring

## Ethics Gate

None. Standard Maxim behavioral output quality applies.

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/marketing-skill/` — SEO frameworks, content optimization patterns, search strategy templates (consumed by `seo-specialist` · `growth-hacker` · `email-campaign-writer` · `landing-page-optimizer` · `content-strategist`)

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the search-visibility skill (activate `seo-specialist` with appropriate mode):

- `optimize for search`, `improve SEO`, `search rankings`, `organic traffic`
- `optimize for voice search`, `featured snippets`, `answer engine`, `position zero` → Mode: AEO
- `optimize for AI search`, `ChatGPT Search`, `SGE`, `Perplexity`, `generative search` → Mode: GEO
- `audit site health`, `crawlability issues`, `indexing problems`, `Core Web Vitals` → Mode: Technical
- `keyword research`, `search intent`, `content gaps`, `competitor keywords` → Mode: Keyword
- `build backlinks`, `digital PR`, `domain authority`, `brand mentions` → Mode: Authority
- `E-E-A-T`, `schema markup`, `structured data`, `rich snippets`

## Cross-Agent Auto-Loops

When search-visibility skill activates, the following agents are auto-notified:

- `seo-specialist` — CMO sole agent for all search visibility tasks
- `content-creation` skill — auto-looped to align content production with search strategy
- `behavior-science-persuasion` skill — auto-looped for search intent and user psychology alignment
- `marketing` skill — auto-looped when search strategy feeds into campaign execution
- `compliance` skill — auto-looped if search content touches regulated industries or claims (CSO auto-loop rule)

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | search-visibility | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
