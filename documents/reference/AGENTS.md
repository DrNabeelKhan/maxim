# Agent Instructions — Maxim Knowledge & Brand Foundation Layer

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.


> Companion to `CLAUDE.md`. CLAUDE.md tells you HOW Maxim works.
> This file tells you HOW TO USE the wiki and .brand-foundation layers.
> Loaded automatically by every Maxim session.

---

## TL;DR for Agents

1. **Before any research** → run `/mxm-wiki query <topic>` first. Don't go to the web until you've checked existing knowledge.
2. **Before any external content** → load `.brand-foundation/personal/` then the active startup's `.brand-foundation/startups/{id}/` folder.
3. **When you learn something new** → drop it in `raw/` and the next `/mxm-wiki ingest` cycle will integrate it.
4. **Trust by tag** → `explored: true` + `confidence: high` = use directly. `explored: false` = treat as unverified draft and flag in any output.
5. **Never publish** content that depends solely on `explored: false` pages.

---

## The Knowledge Layer (v1.0.0+)

Maxim's knowledge layer is built on **MemPalace** (graph + vector + KG) with 4 wiki skills wrapping it. There is no separate wiki vector store — MemPalace IS the store.

### Directory Layout (per project, gitignored)

```
.mxm-knowledge/                 ← lives in .gitignore (project-scoped knowledge)
├── raw/                         ← immutable source inbox
│   ├── clippings/               ← web clips, article dumps
│   ├── ideas/                   ← freeform notes & brain dumps
│   ├── sources/                 ← PDFs, papers, transcripts
│   └── x-archive/               ← social exports
└── lint-report.md               ← latest /mxm-wiki lint output
```

The structured wiki is stored INSIDE MemPalace — query it via `/mxm-wiki query`, not by opening files.

### Page Schema (used in MemPalace drawer frontmatter)

```yaml
---
title: ""
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
sources: []                  # links back to raw/ files
confidence: high | medium | low
explored: false              # AI-generated pages start unverified
startup: null                # set if scoped to a specific startup
---
```

### Mandatory Page Sections (in order)

1. **TLDR** — 2–3 sentence summary
2. **Main Content** — H2/H3 structured body
3. **Counter-Arguments** — data gaps, opposing evidence, caveats (NEVER skip)
4. **Related** — `[[wikilinks]]` to other pages (≥2 inbound required for new pages)
5. **Sources** — links back to raw/ files

---

## Wiki Trust Levels

| Page state | Use as |
|---|---|
| `explored: true` + `confidence: high` | Source of truth — cite directly |
| `explored: true` + `confidence: medium` | Use with appropriate hedging |
| `explored: false` (any confidence) | Unverified draft — flag in any output |
| `confidence: low` (any explored state) | Cite as informal, not authoritative |

---

## When To Run Each Wiki Skill

| You're about to... | Run this skill first |
|---|---|
| Research a topic | `/mxm-wiki query <topic>` — check existing knowledge before web |
| Write public content | `/mxm-wiki query <topic>` + load `.brand-foundation/` |
| Drop a new article/PDF/note in `raw/` | `/mxm-wiki ingest` (or schedule nightly) |
| Review AI-generated pages | `/mxm-wiki explore` — human-in-the-loop verification queue |
| Audit wiki health | `/mxm-wiki lint` (weekly) — catches contradictions, stale, orphans |

---

## The Brand Foundation Layer

Two-layer architecture. Personal voice never changes across startups; only audience, positioning, and compliance change.

```
.brand-foundation/                        ← committed to git
├── personal/                            ← your permanent voice (ships at framework level)
│   ├── voice-profile.md
│   ├── ai-tells.md                      ← banned phrases — STRICT scan before output
│   └── content-rules.md
└── startups/                            ← scaffold per project via bootstrap --BrandFoundation
    ├── isimplification/
    │   ├── positioning.md
    │   ├── audience.md
    │   └── compliance-rules.md
    ├── sentinelflow/
    ├── fixit-iservices/
    ├── drivingtutors/
    ├── gulflawai/
    └── [...]
```

### Loading Protocol (every external-facing output)

1. **ALWAYS load `personal/` first**:
   - `.brand-foundation/personal/voice-profile.md` — tone, sentence architecture
   - `.brand-foundation/personal/ai-tells.md` — banned phrases (strict scan)
   - `.brand-foundation/personal/content-rules.md` — hard dos and don'ts

2. **DETECT active startup** from:
   - Current working directory name
   - `config/project-manifest.json → project.id`
   - User-specified project name in the prompt

3. **LOAD matching startup folder** (if it exists):
   - `.brand-foundation/startups/{detected}/positioning.md`
   - `.brand-foundation/startups/{detected}/audience.md`
   - `.brand-foundation/startups/{detected}/compliance-rules.md`

4. **APPLY precedence**:
   - Personal rules **override** startup rules when they conflict
   - Startup compliance rules **override** personal content rules for regulated content
   - When no startup context detected: personal layer only

5. **BEFORE final output**:
   - Run `ai-tells.md` banned-phrase scanner over every paragraph
   - Verify tone matches the startup's audience table
   - Check no banned phrases from the startup-specific list appear
   - Tag output 🟢 only after a clean pass

---

## Per-Agent Wiki Roles

Use these as defaults — override in your agent's individual file if needed.

| Agent Role | Wiki Interaction |
|---|---|
| Research agents (innovation-researcher, trend-researcher, competitive-analyst, market-analyst) | Run `/mxm-wiki ingest` after every web-search session |
| Writer agents (content-strategist, email-campaign-writer, landing-page-optimizer, documentation-writer) | Run `/mxm-wiki query` + load `.brand-foundation/` before output |
| Compliance agents (compliance-officer, data-privacy-officer, ai-ethics-reviewer, legal-compliance-checker) | Read wiki pages tagged with regulatory frameworks (`gdpr`, `hipaa`, etc.) for current rule state |
| Strategy agents (product-strategist, business-architect, enterprise-architect) | Run `/mxm-wiki query` for cross-project synthesis; file outputs as new wiki pages |
| Memory agents (any session-end work) | Append the session's discoveries to `raw/` for the next ingest cycle |

---

## When You Discover Something New

1. Drop the new information into `raw/ideas/<topic>.md` (or `raw/sources/` for external material).
2. Either:
   - Run `/mxm-wiki ingest` immediately (synchronous), or
   - Let the next nightly ingest cycle pick it up (asynchronous — preferred for large batches).
3. The ingest skill creates structured wiki pages with `explored: false`, links them bidirectionally, and updates the index.
4. Run `/mxm-wiki explore` later to verify and confirm the AI-generated pages.

This keeps the wiki **self-expanding** with a human-in-the-loop verification gate.

---

## Quality Rules (enforced by `/mxm-wiki ingest` and `/mxm-wiki lint`)

- **80% relevance filter** — low-signal sources are skipped during ingest
- **Mandatory Counter-Arguments section** on every page — forces surfacing of gaps and opposing data
- **`explored: false` default** on all AI-generated pages
- **Bidirectional `[[wikilinks]]`** required (≥2 inbound for new pages)
- **No duplicate pages** — overlapping topics merge into existing pages
- **Weekly `/mxm-wiki lint`** catches contradictions, staleness (>90 days), orphans, broken links

---

## Voice Mode (v1.0.0+)

`/mxm-voice` accepts natural-language utterances and routes them through the executive-router. Hotword phrases live in `config/voice-phrases.yml` (user-editable).

When a voice utterance is processed:
1. Whisper STT transcribes the audio (local or OpenAI cloud)
2. `mxm-voice` MCP server matches against `voice-phrases.yml` patterns
3. Matched phrases dispatch to the mapped slash command
4. Unmatched utterances route through `executive-router` for intent classification
5. Kokoro TTS speaks back the response (local or OpenAI cloud)

When VoiceMode is not installed, `/mxm-voice` prints install instructions and exits gracefully.

---

## Reference Index

| Document | Purpose |
|---|---|
| `CLAUDE.md` | Universal Maxim operating standard |
| `CLAUDE.d/dispatch.md` | Domain Dispatch Table + Conflict Resolution |
| `CLAUDE.d/session-memory.md` | Session protocols + junction read-only enforcement |
| `.brand-foundation/personal/` | Permanent voice (loaded first) |
| `.brand-foundation/startups/{id}/` | Per-startup positioning (loaded second, scaffolded by bootstrap) |
| `.claude/skills/wiki-ingest/SKILL.md` | Ingest workflow detail |
| `.claude/skills/wiki-query/SKILL.md` | Query workflow detail |
| `.claude/skills/wiki-lint/SKILL.md` | Lint workflow detail |
| `.claude/skills/wiki-explore/SKILL.md` | Explore workflow detail |
| `.claude/skills/junction-guard/SKILL.md` | Junction read-only enforcement |
| `.claude/commands/mxm-wiki.md` | `/mxm-wiki <subcommand>` entry point |
| `.claude/commands/mxm-voice.md` | `/mxm-voice` entry point |
| `config/voice-phrases.yml` | User-editable voice hotword config |
| `config/scheduler-thresholds.json` | Usage-aware scheduler thresholds |
