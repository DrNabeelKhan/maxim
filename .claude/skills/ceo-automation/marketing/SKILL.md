# Marketing -- Prompt Catalog

> Domain: ceo-automation/marketing | Office: CMO
> Reference: `ceo-automation-prompts.md` lines 1600-1765

## Maxim MOAT — Behavioral Enforcement

Every marketing output MUST apply:
- **AIDA** (Attention-Interest-Desire-Action) on all content and email copy
- **PAS** (Problem-Agitate-Solution) on blog posts, landing pages, outreach
- **StoryBrand** (Donald Miller) — customer is hero, brand is guide
- **Hook Model** (Nir Eyal) — Trigger > Action > Variable Reward > Investment on growth prompts
- **EAST** — make every CTA Easy, Attractive, Social, Timely
- Auto-loop `content-strategist` + `seo-specialist` on content/SEO tasks
- Auto-loop `behavioral-designer` on conversion optimization
- Confidence tag every output: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW

## Standard Prefix

```
Read .mxm-executive-summary/CONTEXT.md and BRAND-VOICE.md first.
Read config/project-manifest.json for compliance scope.
Save output to .mxm-executive-summary/logs/[task-name]-[date].md
```

## Prompt Index

### Content Marketing

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Weekly blog brief pack | overnight | PRODUCT.md, ICP.md, COMPETITORS.md | 5 blog briefs: title, keyword, problem, outline, CTA |
| Blog post draft | overnight | BRAND-VOICE.md | 800-word post: hook, problem, solution, example, CTA |
| Content gap analysis | overnight | published-posts.md, COMPETITORS.md | Topics competitors covered that we haven't; ranked by traffic |
| Case study draft | overnight | WINS.md, PRODUCT.md | 600-word case study from best customer outcome |
| Thought leadership angles | overnight | MARKET.md, ICP.md | 4 contrarian angles with LinkedIn post openers |

### Email Marketing

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Newsletter draft | overnight | WINS.md, published-posts.md, METRICS.md | Weekly newsletter: 5 subject lines, 3-section body, 400 words |
| Cold outreach sequence | overnight | ICP.md, PRODUCT.md | 4-email sequence: pattern interrupt, social proof, ask, breakup |
| Nurture sequence | overnight | ICP.md, PRODUCT.md, USER-FEEDBACK.md | 6-email trial-to-paid sequence mapped to user stages |
| Re-engagement campaign | overnight | CRM-notes.md, PRODUCT.md | 3-email win-back for 60+ day inactive contacts |
| Email list health report | overnight | email-stats.md | Open/click/unsub/bounce trends with benchmark comparison |

### SEO and Discovery

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Keyword cluster map | overnight | ICP.md, PRODUCT.md, COMPETITORS.md | Clusters: problem-aware, solution-aware, brand, bottom-funnel |
| On-page SEO audit | overnight | published-posts.md | Per-post: title, meta, H-structure, links, CTA, keyword usage |
| Competitor backlink targets | overnight | COMPETITORS.md, PRODUCT.md | Per-competitor: directories, reviews, media, newsletters, podcasts |

### Growth and Acquisition

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Channel experiment backlog | overnight | METRICS.md, ICP.md, RUNWAY.md | 6 experiments: paid, organic, partnerships, community, PLG, referral |
| Product Hunt launch plan | overnight | PRODUCT.md, ICP.md, WINS.md | Hunter strategy, tagline, description, first comment, schedule |
| Conversion rate audit | overnight | METRICS.md | Above-fold, headline, social proof, CTA, mobile audit |

### Brand and Positioning

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Brand voice guide | overnight | PRODUCT.md, ICP.md, published-posts.md | Extract 4 voice attributes, personality, words list |
| Positioning statement | overnight | ICP.md, COMPETITORS.md, PRODUCT.md | 3 options using Geoffrey Moore template, scored |
| Messaging hierarchy | overnight | ICP.md, PRODUCT.md, USER-FEEDBACK.md | Tagline, value prop, 3 benefit pillars with proof points |
| Awards and PR targets | overnight | PRODUCT.md, METRICS.md, WINS.md | 10 PR/award opportunities with angles and deadlines |

### Marketing Analytics

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Weekly marketing report | overnight | METRICS.md, social-stats.md, email-stats.md | Top-line numbers, WoW changes, best/worst content, 3 recommendations |
| Attribution analysis | overnight | METRICS.md, CRM-notes.md | Last 20 customers by first-touch source; channel conversion rates |

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
