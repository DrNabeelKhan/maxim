---
skill_id: content-calendar
name: Content Calendar
version: 2.0.0
category: content-marketing
type: framework
frameworks: []
triggers:
  - content calendar
  - editorial calendar
  - plan content for the quarter
  - publishing cadence
  - content plan
collaborates_with:
  - social-media-strategist
  - article-writer
  - content-creator
  - newsletter-writer
ethics_required: false
priority: medium
tags: [content-marketing, framework, editorial-planning, publishing]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Content Calendar

## Purpose
Use a content calendar to plan what gets published, where, when and by whom, so content serves a strategy instead of whatever is urgent this week. A good calendar is more than dates: it ties each piece to an audience, a goal and a theme, shows the workflow status of every item, and makes the publishing cadence sustainable for the team that has to produce it.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `content-calendar` |
| Category | Content Marketing — Editorial Planning |
| Version | 2.0.0 |
| Nature | An established editorial practice, not a single published model |
| Useful references | Pulizzi, *Epic Content Marketing* (2013) · Handley, *Everybody Writes* (2014) |

## What Each Calendar Entry Holds
- **Publish date and channel.**
- **Theme or content pillar** it belongs to.
- **Audience and goal**: who it is for and what it should achieve.
- **Format**: article, post, video, newsletter, and so on.
- **Owner** and **workflow status**: idea, drafting, review, approved, scheduled, published.
- **Repurposing plan**: which other formats it will become.
- **Link to performance** once published.

## Core Principles
- **Strategy first, dates second.** Every entry should trace to an audience and a goal.
- **Consistency beats volume.** A cadence the team can sustain outperforms bursts followed by silence.
- **Balance evergreen and timely.** Evergreen content builds over time; timely content rides moments.
- **Plan repurposing at the start.** One researched piece can feed several channels.
- **The calendar is a workflow, not a wish list.** Status and owners make it real.

## Applications & Use Cases
| Use Case | Application | Benefit |
|---|---|---|
| Quarterly planning | Lay out themes and anchor pieces by month | Coherent narrative across the quarter |
| Product launches | Sequence teaser, launch and follow-up content | Coordinated message across channels |
| Seasonal and event timing | Pre-plan content around known dates | No last-minute scrambles |
| Team coordination | Assign owners and track status in one place | Fewer missed deadlines |
| Repurposing | Plan derivative formats for each anchor piece | More output from the same research |
| Performance review | Link entries to results | Learn which themes and formats work |

## Usage Guidelines
- **Define pillars and audiences first**, then fill dates.
- **Set a cadence per channel that the team can sustain**, and protect it.
- **Plan backward from publish dates**, allowing time for review and approval.
- **Track status for every item** so bottlenecks are visible early.
- **Review performance monthly** and adjust themes, formats and cadence.

## Prompt Template
```
You are building a content calendar.

AUDIENCES AND GOALS: [[who, and what content should achieve]]
PILLARS: [[3-5 themes]]
CHANNELS AND SUSTAINABLE CADENCE: [[channel: frequency]]

FOR EACH ENTRY
date · channel · pillar · audience · goal · format · owner · status · repurpose into

CHECK: does every entry trace to a pillar and goal? Is the cadence realistic for the team?
```

## Ethical Guidelines
- **Disclose sponsorships and affiliate relationships** in every scheduled piece that carries them.
- **Do not pre-schedule content that may become inappropriate**; review the calendar around sensitive events.

## Testing Strategy
- Compare engagement and conversion by pillar, format and publishing time.
- Test cadence changes for a full cycle before concluding.

## Success Metrics
- Planned versus published rate.
- Engagement and conversion by pillar and format.
- Lead time from idea to publish.

## Collaboration Protocol
- Inbound from: `social-media-strategist` · `article-writer` · `content-creator` · `newsletter-writer`
- Outbound to: `brand-guardian` for review before scheduling
- Cross-framework: Platform-specific writing adapts each entry per channel; AIDA structures individual pieces.

## Related Skills
- `composable-skills/frameworks/platform-specific-writing/SKILL.md` — adapting entries per channel
- `composable-skills/frameworks/aida/SKILL.md` — structuring each piece
- `composable-skills/frameworks/search-intent-mapping/SKILL.md` — choosing topics people search for

## Reference Materials
- Pulizzi, J. (2013). *Epic Content Marketing.* McGraw-Hill Education.
- Handley, A. (2014). *Everybody Writes.* Wiley.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
