---
skill_id: marketing-paid-measurement
name: Paid & Measurement
version: 1.0.0
parent: marketing
office: CMO
reads_first: MARKETING-CONTEXT.md
triggers:
  - paid ads
  - Google Ads
  - Facebook Ads
  - attribution
  - analytics
  - tracking
  - ROAS
  - PPC
  - paid social
  - UTM
  - conversion tracking
  - ad spend
  - programmatic
---

# Paid & Measurement

> **Before starting:** Read `MARKETING-CONTEXT.md` in this domain for product, ICP, and positioning context.

## What This Skill Does

Designs paid media strategies, builds measurement frameworks, and sets up attribution systems that connect ad spend to revenue. Covers channel selection, budget allocation, creative strategy, UTM taxonomy, and conversion tracking architecture. Ensures every marketing dollar is measurable and every report is actionable -- not vanity metrics.

## Key Questions to Ask

1. What is the total monthly/quarterly ad budget?
2. What channels are currently running? What is the ROAS per channel?
3. What is the target CAC and current LTV:CAC ratio?
4. What analytics tools are in place? (GA4, Mixpanel, Amplitude, etc.)
5. Is server-side tracking implemented or only client-side?
6. What is the attribution model in use? (last-click, first-touch, multi-touch)
7. What compliance constraints apply to ad targeting? (GDPR, CCPA, industry-specific)

## Framework / Approach

### Channel Selection Matrix

| Channel | Best For | ICP Signal | Min Budget/Month |
|---|---|---|---|
| Google Search | High-intent capture | Searching for solutions | $1,000+ |
| Google Display/YouTube | Awareness, retargeting | Top-of-funnel, remarketing | $2,000+ |
| Meta (Facebook/Instagram) | B2C, lookalike audiences | Interest/behavior targeting | $1,500+ |
| LinkedIn | B2B, decision-makers | Job title, company, industry | $3,000+ |
| Twitter/X | Tech, developer, real-time | Interest communities | $1,000+ |
| Reddit | Niche communities | Subreddit targeting | $500+ |
| TikTok | Gen Z/Millennial B2C | Interest, behavior | $1,000+ |
| Programmatic | Scale, retargeting | Audience data platforms | $5,000+ |

### Attribution Architecture

1. **UTM Taxonomy** -- Standardize before launching anything:
   - `utm_source` -- Platform (google, meta, linkedin)
   - `utm_medium` -- Channel type (cpc, paid-social, display)
   - `utm_campaign` -- Campaign name (lowercase, hyphenated)
   - `utm_content` -- Creative variant (ad-a, ad-b)
   - `utm_term` -- Keyword (search only)

2. **Conversion Tracking Setup**:
   - Define macro conversions (purchase, signup, demo booked)
   - Define micro conversions (page view, scroll depth, video play, add-to-cart)
   - Implement server-side tracking where possible (cookie deprecation resilience)
   - Set up cross-domain tracking if multiple properties

3. **Attribution Model Selection**:
   - **Last-click** -- Simple, biased toward bottom-funnel (default in most tools)
   - **First-touch** -- Credits awareness channels (useful for brand investment justification)
   - **Linear** -- Equal credit across touchpoints (useful for understanding full journey)
   - **Data-driven** -- ML-based, requires volume (GA4, platform-specific)
   - **Incrementality testing** -- Gold standard: holdout groups to measure true lift

### Budget Allocation Framework

1. Start with the **70/20/10 rule**:
   - 70% -- Proven channels with positive ROAS
   - 20% -- Scaling channels with promising early data
   - 10% -- Experimental channels / new creative
2. Rebalance monthly based on marginal ROAS (not average ROAS)
3. Account for attribution lag -- don't kill campaigns before conversion windows close

### Reporting Cadence

| Report | Frequency | Audience | Key Metrics |
|---|---|---|---|
| Performance dashboard | Daily | Marketing team | Spend, impressions, clicks, CPA |
| Channel report | Weekly | Marketing lead | ROAS by channel, budget pacing |
| Attribution report | Monthly | CMO/CEO | Blended CAC, LTV:CAC, incrementality |
| Quarterly review | Quarterly | Executive team | Total marketing ROI, channel mix strategy |

## Output Format

```markdown
## Paid Media Plan: [Campaign / Quarter]

### Budget Allocation
| Channel | Monthly Budget | Target CPA | Target ROAS |
|---|---|---|---|
| [channel] | [$X] | [$Y] | [Z:1] |

### UTM Convention
- Source: [taxonomy]
- Medium: [taxonomy]
- Campaign naming: [convention]

### Tracking Architecture
- Analytics platform: [tool]
- Conversion events: [list]
- Attribution model: [model]
- Server-side: [yes/no, tool]

### Creative Strategy
| Channel | Format | Message Angle | CTA |
|---|---|---|---|
| [channel] | [format] | [angle] | [CTA] |

### Measurement Plan
| Metric | Definition | Target | Source |
|---|---|---|---|
| [metric] | [how calculated] | [goal] | [tool] |
```

## Related Skills
- `cro` -- landing page optimization for ad traffic
- `growth-retention` -- full-funnel metrics beyond acquisition
- `copywriting` -- ad copy and creative messaging
- `customer-research` -- audience insights for targeting

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
