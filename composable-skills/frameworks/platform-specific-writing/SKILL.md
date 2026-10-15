---
skill_id: platform-specific-writing
name: Platform-Specific Writing
version: 2.0.0
category: content-marketing
type: framework
frameworks: []
triggers:
  - write for linkedin
  - adapt this for each platform
  - platform-specific copy
  - write a thread
  - newsletter version
collaborates_with:
  - article-writer
  - social-media-strategist
  - content-creator
  - video-script-writer
ethics_required: false
priority: medium
tags: [content-marketing, framework, copywriting, social-media, channels]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Platform-Specific Writing

## Purpose
Use platform-specific writing to write each piece for how people actually read on that channel, rather than reformatting one text everywhere. Readers behave differently on a professional feed, a short-form timeline, an inbox and a long article: they scan differently, give different amounts of attention, and expect different structures. Most online reading is scanning, which is why the opening and the structure matter more than the prose in the middle.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `platform-specific-writing` |
| Category | Content Marketing — Channel Writing |
| Version | 2.0.0 |
| Nature | An established practice drawing on reading research and platform norms |
| Key reference | Nielsen, "How Users Read on the Web" (Nielsen Norman Group, 1997) |
| Note | Character limits and features change; check each platform's current guidance |

## Platform Profiles
- **Professional feeds (e.g. LinkedIn).** The first lines decide whether a reader expands the post. Lead with a specific insight or claim, use short paragraphs, and end with a question or a clear point.
- **Short-form timelines (e.g. X).** One idea per post; a thread works when each post stands on its own and the first one earns the rest.
- **Visual platforms (e.g. Instagram).** The image or video carries the message; the caption supports it.
- **Email newsletters.** The subject line and preview text decide the open; one main idea and one call to action decide the click.
- **Long-form articles and blogs.** Descriptive headings, front-loaded paragraphs and a scannable structure, since most readers scan before they read.
- **Video scripts.** Earn attention in the opening seconds and write for the ear, not the eye.

## Core Principles
- **Write for scanning.** Readers scan first; headings, opening lines and structure carry the message.
- **Front-load the point.** The first line of a post, the subject of an email and the first sentence of a paragraph matter most.
- **One idea per unit.** A post, an email or a section should do one thing well.
- **Native beats reformatted.** Copy pasted across channels reads as an afterthought.
- **Respect each platform's norms**, including tone, length and how links are treated.

## Applications & Use Cases
| Use Case | Application | Key adaptation |
|---|---|---|
| Launch announcement | One core message, written natively for each channel | Different openings per platform |
| Thought leadership | A specific claim up front on professional feeds | First lines that earn the expand |
| Repurposing a long article | Pull one idea per post rather than summarising | One idea per unit |
| Newsletter | Subject and preview written as carefully as the body | Earn the open |
| Threads | Each post independently useful | Standalone units |
| Video | Script for speech, with an early hook | Write for the ear |

## Usage Guidelines
- **Decide the single point first**, then write the opening line that carries it.
- **Adapt structure, not just length**, to each platform's reading behavior.
- **Check current platform limits and features** before writing; they change.
- **Use descriptive headings and short paragraphs** for anything long.
- **Read it as the audience would scroll past it**: would the first line stop them?

## Prompt Template
```
You are adapting a message for each platform.

CORE MESSAGE: [[the single point]]
AUDIENCE: [[who, on which platforms]]

FOR EACH PLATFORM
- Opening line that carries the point:
- Structure suited to how people read there:
- Call to action appropriate to the platform:

CHECK: is each version native, or a reformatted copy?
```

## Ethical Guidelines
- **Disclose sponsorships and affiliate links** as each platform and the law require.
- **Do not use misleading openings** to win the expand or the open; the body must deliver what the first line promises.

## Testing Strategy
- Test opening lines and subject lines separately from body copy.
- Compare native versions against reformatted ones on the same channel.

## Success Metrics
- Expand, open and click rates by platform.
- Read-through or watch-through.
- Downstream conversion from each channel.

## Collaboration Protocol
- Inbound from: `article-writer` · `social-media-strategist` · `content-creator` · `video-script-writer`
- Outbound to: `brand-guardian` for voice consistency across channels
- Cross-framework: AIDA structures each version; content calendar schedules them; brand guidelines keep the voice consistent.

## Related Skills
- `composable-skills/frameworks/aida/SKILL.md` — message structure within each platform
- `composable-skills/frameworks/content-calendar/SKILL.md` — scheduling across channels
- `composable-skills/frameworks/brand-guidelines/SKILL.md` — one voice across platforms

## Reference Materials
- Nielsen, J. (1997). "How Users Read on the Web." Nielsen Norman Group.
- Handley, A. (2014). *Everybody Writes.* Wiley.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
