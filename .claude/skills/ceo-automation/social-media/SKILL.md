# Social Media -- Prompt Catalog

> Domain: ceo-automation/social-media | Office: CMO
> Reference: `ceo-automation-prompts.md` lines 2130-2291

## Maxim MOAT — Behavioral Enforcement

Every social media output MUST apply:
- **Hook Model** (Nir Eyal) — every post must have a Trigger, enable Action, deliver Variable Reward
- **AIDA** — Attention (first line), Interest (body), Desire (proof), Action (CTA)
- **Cialdini's Principles** — Social proof, Authority, Scarcity on promotional posts
- **Pattern Interruption** — first line must break scroll pattern (no "I'm excited to share")
- **EAST** — make engagement Easy, Attractive, Social, Timely
- **Fogg Behavior Model** — reduce friction for the desired audience action
- Auto-loop `content-strategist` on all social content
- Auto-loop `brand/` skill for voice consistency enforcement
- Never autopost without human review — Claude drafts, user approves
- Confidence tag every output: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW

## Standard Prefix

```
Read .mxm-executive-summary/CONTEXT.md and BRAND-VOICE.md first.
Read config/project-manifest.json for compliance scope.
Save output to .mxm-executive-summary/logs/social-[platform]-[date].md
```

## Prompt Index

### Facebook

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Weekly founder update post | morning | WINS.md, BRAND-VOICE.md | 150-250 words from founder perspective, genuine question ending |
| Community question post | morning | ICP.md, PRODUCT.md | Under 100 words, opinionated question, optional poll |
| Customer spotlight post | afternoon | WINS.md, CRM-notes.md | Most recent win with numbers, 200 words, soft CTA |
| How-to educational post | overnight | PRODUCT.md, ICP.md | 5-7 step numbered list, 250 words, clear outcome headline |
| Feature launch announcement | morning | CHANGELOG.md, PRODUCT.md, BRAND-VOICE.md | Old way > problem > new feature > who helps > CTA, under 200 words |
| Behind-the-scenes founder story | overnight | BRAND-VOICE.md | 200-300 words, specific, lesson or question ending |

### X (Twitter)

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Daily insight tweet batch | morning | PRODUCT.md, ICP.md | 5 standalone tweets, non-obvious insights, under 240 chars each |
| 10-tweet thread | overnight | published-posts.md, BRAND-VOICE.md | Blog-to-thread conversion, bold claim opener, CTA closer |
| Founder build-in-public tweet | morning | METRICS.md, WINS.md | One real number, honest context, community question, under 280 chars |
| Controversial hot take | morning | ICP.md, MARKET.md | 3 contrarian tweets, specific and defensible, under 240 chars |
| Launch day tweet sequence | morning | CHANGELOG.md, LAUNCH-PLAN.md, PRODUCT.md | 4 tweets: announcement, use case, early stat, thank-you |
| Reply and engagement targets | morning | ICP.md, COMPETITORS.md | 10 reply templates for ICP's common tweet types |

### LinkedIn

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Founder narrative post | overnight | BRAND-VOICE.md, OKRs.md, WINS.md | 250-400 words, hook, short paragraphs, story/number, closing question |
| Tactical how-to post | overnight | PRODUCT.md, ICP.md | 5-7 step framework, 300 words, "save this" CTA |
| Case study carousel outline | overnight | WINS.md, CRM-notes.md, PRODUCT.md | 10-slide outline: result > problem > steps > result > quote > CTA |
| Industry insight post | morning | MARKET.md, COMPETITORS.md, ICP.md | 250-350 words, trend + why it matters + what's wrong + smart move |
| Product launch post | morning | CHANGELOG.md, PRODUCT.md, BRAND-VOICE.md | 200-300 words, don't start with "We"/"Today"/"Excited" |
| Lessons learned post | overnight | SPRINT.md, WINS.md, BRAND-VOICE.md | 250-350 words, genuine mistake, discovery, what changed |

### Cross-Platform

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Full launch content kit | overnight | CHANGELOG.md, PRODUCT.md, ICP.md, BRAND-VOICE.md | Facebook + X + LinkedIn + 5 email subjects + 60-sec video script |
| Weekly content calendar | overnight | PRODUCT.md, WINS.md, ICP.md, BRAND-VOICE.md | 7-day plan: per day per platform — type, topic, hook, goal |
| Testimonial repurpose kit | overnight | WINS.md, CRM-notes.md | 3 wins x 3 platforms (Facebook/tweet/LinkedIn) |
| 30-day content themes | overnight | ICP.md, PRODUCT.md, COMPETITORS.md | 30 themes mapped to awareness/engagement/education/proof/conversion |
| Startup story series | overnight | BRAND-VOICE.md, WINS.md, OKRs.md | 4-part founder story: why/first version/first customer/where going |

## Posting Schedule Reference

| Platform | Best Post Time | Prep |
|---|---|---|
| Facebook | 9 AM - 1 PM | Draft overnight, add visual morning, post manually |
| X (Twitter) | 8-10 AM and 6-9 PM | Draft morning, schedule via Buffer |
| LinkedIn | 8-10 AM weekdays | Draft overnight, review morning, post manually |

**Rule:** Never autopost without human review. Claude drafts, you approve and post.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
