# Maxim Skill — Content Creation

> Layer 1 — Supreme Authority | Executive Office: CMO

## Domain

All written content — articles, whitepapers, newsletters, documentation, changelogs, video scripts, and investor content. The CMO's primary execution skill for written output across every format and channel.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`content-strategist` — CMO Office (absorbs `content-creator` via Op-D)

## Active Agents

- `content-strategist` — multi-format content strategy and execution (absorbs `content-creator` via Op-D: Strategy · Execution modes)
- `documentation-writer` — API docs, user guides, technical manuals, knowledge bases
- `email-campaign-writer` — email sequences, newsletters, drip campaigns
- `investor-pitch-writer` — investor decks, executive narratives, fundraising content (CEO office, routes here for written execution)
- `knowledge-base-curator` — knowledge base architecture, article taxonomy, self-serve content
- `changelog-writer` — release notes, changelog governance, version communication

**Op-C Skill DNA modes (demoted agents now embedded in content-creation/SKILL.md):**
- Mode: Article — from `article-writer`
- Mode: Newsletter — from `newsletter-writer`
- Mode: Video Script — from `video-script-writer`
- Mode: Technology Book — from `technology-book-writer`
- Mode: Whitepaper — from `whitepaper-writer`
- Mode: Social Media — from `social-media-strategist`

## Skill Modes

- `Article` — long-form editorial, thought leadership, blog posts
- `Newsletter` — subscriber-focused recurring content, digest formats
- `Video Script` — YouTube, webinar, product demo, tutorial scripts
- `Technology Book` — structured technical book chapters and outlines
- `Whitepaper` — research-backed, authoritative technical documents
- `Social Media` — platform-adapted short-form written content (cross-posts to marketing skill for channel execution)

## Ethics Gate

None. Standard Maxim behavioral output quality applies.

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/marketing-skill/` — content strategy patterns, copywriting frameworks, platform-specific writing conventions (consumed by `content-strategist` · `email-campaign-writer` · `landing-page-optimizer`)

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the content-creation skill:

- `content creation`, `copywriting`, `multi-format content`
- `documentation`, `API docs`, `user guide`, `technical manual`
- `write article`, `write blog`, `long-form content`, `thought leadership`
- `newsletter`, `email sequence`, `drip campaign`
- `whitepaper`, `research report`, `executive brief`
- `video script`, `webinar script`, `tutorial script`
- `changelog`, `release notes`, `version notes`
- `knowledge base`, `help center`, `self-serve content`

## Cross-Agent Auto-Loops

When content-creation skill activates, the following agents are auto-notified:

- `content-strategist` — CMO lead for all written content
- `marketing` skill — auto-looped when content is destined for a campaign channel
- `search-visibility` skill — auto-looped when content requires SEO/AEO optimization
- `behavior-science-persuasion` skill — auto-looped for persuasive copy psychology validation
- `security-analyst` — auto-looped if content touches regulated topics (CSO auto-loop rule)

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | content-creation | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
