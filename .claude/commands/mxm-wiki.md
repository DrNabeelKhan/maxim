---
name: mxm-wiki
description: "Knowledge layer entry point. Subcommands: ingest / query / lint / explore. Built on MemPalace per the Brandvoice pattern."
---

# /mxm-wiki

Maxim's RAG knowledge layer — built on MemPalace, governed by the Brandvoice pattern.

## Subcommands

| Subcommand | Skill | Purpose |
|---|---|---|
| `/mxm-wiki ingest [path?]` | `wiki-ingest` | Convert raw sources → structured wiki pages in MemPalace. Default scans `raw/`. Optional path scopes to one source. |
| `/mxm-wiki query <question>` | `wiki-query` | Answer a question with cited synthesis. Counter-Arguments mandatory. Knowledge gaps explicit. |
| `/mxm-wiki lint` | `wiki-lint` | Audit corpus for contradictions, stale, orphans, duplicates, broken links, AI-tells. Writes `lint-report.md`. NEVER auto-fixes. |
| `/mxm-wiki explore [filter?]` | `wiki-explore` | Human-in-the-loop verification queue for `explored: false` pages. Filter by topic/since/startup/room. |

## Default Behavior (no subcommand)

If invoked without a subcommand, prints this usage card.

## Examples

```
/mxm-wiki ingest
/mxm-wiki ingest raw/sources/handoff-paper.pdf

/mxm-wiki query "What overlaps between iSimplification and SentinelFlow?"
/mxm-wiki query "Compliance frameworks for UAE legal AI"

/mxm-wiki lint
/mxm-wiki lint --since=2026-04-01

/mxm-wiki explore
/mxm-wiki explore --topic=compliance
/mxm-wiki explore --startup=isimplification
```

## Wiki-First Principle (per documents/reference/AGENTS.md)

**Always check the wiki BEFORE going to the web.**

- Research agents auto-trigger `/mxm-wiki query` first.
- After web research, drop findings in `raw/` and run `/mxm-wiki ingest`.
- Substantive answers are filed as new wiki pages with `explored: false`.
- `/mxm-wiki explore` closes the verification loop before pages are cited externally.

## Trust Levels (output annotations)

| Page state | Use as |
|---|---|
| `explored: true` + `confidence: high` | Source of truth — cite directly |
| `explored: true` + `confidence: medium` | Use with hedging |
| `explored: false` (any confidence) | Unverified draft — flag in any output |
| `confidence: low` | Cite as informal, not authoritative |

## Brand Foundation Integration

When a wiki query produces external-facing output:

1. Auto-loads `.brand-foundation/personal/voice-profile.md`
2. Detects active startup → loads `.brand-foundation/startups/{id}/positioning.md` (if scaffolded)
3. Runs `.brand-foundation/personal/ai-tells.md` banned-phrase scanner over output
4. Output gets the standard Maxim confidence tag 🟢🟡🔴

## Underlying Storage

All wiki content lives in **MemPalace** (no separate vector store):
- `wing_knowledge/sources/` — source summary pages
- `wing_knowledge/concepts/` — ideas, frameworks, mental models
- `wing_knowledge/entities/` — people, tools, companies
- `wing_knowledge/syntheses/` — cross-source analysis pages
- `wing_knowledge/outputs/` — filed query answers
- `wing_knowledge/sops/` — repeatable processes
- `wing_knowledge/templates/` — page starters
- `wing_knowledge/index/index-md` — auto-maintained TLDR index
- `wing_knowledge/log/log-md` — append-only changelog

The graph layer (KG) stores entity relationships via `mempalace_kg_add` for traversal queries.

## Voice Mode Hotwords

Default `config/voice-phrases.yml` entries for `/mxm-wiki`:

```yaml
- pattern: "maxim run wiki ingest"
  dispatch: "/mxm-wiki ingest"
- pattern: "maxim query wiki *"
  dispatch: "/mxm-wiki query $1"
- pattern: "maxim audit the wiki"
  dispatch: "/mxm-wiki lint"
- pattern: "maxim review unverified pages"
  dispatch: "/mxm-wiki explore"
```

User-editable — see `config/voice-phrases.yml`.

## Scheduling

Recommended scheduled tasks (set up via `/mxm-tasks`):

| Frequency | Task |
|---|---|
| Nightly 11pm | `/mxm-wiki ingest` (catches anything dropped in `raw/` during the day) |
| Weekly Monday 7am | `/mxm-wiki lint` (saves `lint-report.md` for the week) |
| Bi-weekly | `/mxm-wiki explore` (interactive — recommended manual run) |

Usage-aware scheduling (v1.0.0+) auto-pauses these if Anthropic limits are tight.

## Source References

- `documents/reference/AGENTS.md` — wiki usage guide
- `.claude/skills/wiki-ingest/SKILL.md`
- `.claude/skills/wiki-query/SKILL.md`
- `.claude/skills/wiki-lint/SKILL.md`
- `.claude/skills/wiki-explore/SKILL.md`
- `FINAL_RELEASE_CHANGES/Brandvoice-wiki-example.md` — pattern source
- `.brand-foundation/personal/` — loaded automatically for external output
