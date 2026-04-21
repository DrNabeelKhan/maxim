# Maxim Skill — Session Memory

> Layer 1 — Supreme Authority | Cross-Office: All Offices
> Version: 1.0.0 | Created: 2026-04-11

## Domain

Persistent cross-session memory, context preservation, debugging playbooks, lessons learned, and session continuity. Every Claude session MUST read and write memory files.

## Dispatch Rule

This skill is ALWAYS ACTIVE. It does not need to be triggered — it runs on every session start and end. It cannot be disabled, even in Super User mode.

## Maxim MOAT — Behavioral Enforcement

Every session MUST apply:
- **Session Start:** Read MEMORY.md index → load project_current_state → check feedback_debugging_playbook for known issues
- **Session End:** Write progress, update task plan, append lessons/debugging entries
- **Error Capture:** Every error, retry, workaround → append to feedback_debugging_playbook.md
- **Decision Capture:** Every architecture/product decision → append to decision-log.md
- **Never Duplicate:** One canonical location per file type (see Dedup Policy)

## File Architecture (3-tier, from claude-memory reference)

| Tier | Prefix | Purpose | Examples |
|---|---|---|---|
| Project | `project_*` | Current status, decisions, specs | project_current_state.md |
| Reference | `reference_*` | Directory indexes, fast lookup | reference_key_files.md |
| Feedback | `feedback_*` | Lessons learned, debugging patterns | feedback_debugging_playbook.md |

All files use YAML frontmatter:
```yaml
---
name: [title]
description: [one-line summary]
type: project | reference | feedback
originSessionId: [optional — for feedback entries]
---
```

## Canonical File Locations

| File | Location | Rule |
|---|---|---|
| MEMORY.md | .claude-sessions-memory/ | Master index — always first |
| project_current_state.md | .claude-sessions-memory/ | Updated every session end |
| reference_key_files.md | .claude-sessions-memory/ | Updated when files added/moved |
| feedback_debugging_playbook.md | .claude-sessions-memory/ | Append-only — never delete entries |
| feedback_lessons_learned.md | .claude-sessions-memory/ | Append-only |
| task_plan.md | .claude-sessions-memory/ | NOT root, NOT planning/ |
| progress.md | .claude-sessions-memory/ | NOT root |
| findings.md | .claude-sessions-memory/ | NOT root |
| decision-log.md | .claude-sessions-memory/ | Append-only |
| handoff.md | .claude-sessions-memory/ | Updated on session end |
| session-*.md | .claude-sessions-memory/ | One per session date |

## Routing Integration

This skill integrates with all Maxim offices. No routing trigger required — it is invoked automatically at session boundaries by the Maxim dispatch layer.

Cross-skill data flows:
- Receives decision events from: `enterprise-architecture`, `engineering`, `product`, `security`
- Receives error events from: `engineering`, `testing`, `studio-operations`
- Feeds context into: every skill at session start

## Deduplication Policy

If a file matching a canonical name is found outside `.claude-sessions-memory/`:
1. Read the non-canonical copy
2. Merge content into the canonical file (append, no overwrite)
3. Backup original to `.mxm-backup/[filename]-[date]`
4. Log the dedup action in `decision-log.md`
5. Do NOT delete the original silently — always inform the user

## Confidence Tag

🟢 HIGH — This skill is always active, always matched, behavioral layer fully applied.
