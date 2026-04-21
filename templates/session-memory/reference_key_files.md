---
name: Key Files Reference
description: Fast lookup table for all architecturally significant files in this project — update when files are added or moved
type: reference
---

# Key Files Reference

> Project: [PROJECT NAME]
> Last Updated: [YYYY-MM-DD]
> Managed by: Maxim session-memory skill

This file provides fast lookup for files that matter architecturally, operationally, or for onboarding. It is not an exhaustive directory listing — only include files that a developer or agent would need to locate quickly during a session.

Update this file whenever a significant new file is created or an existing file is moved.

---

## Session Memory Files

| Category | File | Path | Purpose |
|---|---|---|---|
| Memory Index | MEMORY.md | .claude-sessions-memory/MEMORY.md | Master index — read first every session |
| Current State | project_current_state.md | .claude-sessions-memory/project_current_state.md | Phase, tasks, risks, next step |
| Handoff | handoff.md | .claude-sessions-memory/handoff.md | Last session open items and carry-forward |
| Task Plan | task_plan.md | .claude-sessions-memory/task_plan.md | Active task plan with priorities |
| Progress | progress.md | .claude-sessions-memory/progress.md | Running task completion log |
| Findings | findings.md | .claude-sessions-memory/findings.md | Research and analysis output |
| Decision Log | decision-log.md | .claude-sessions-memory/decision-log.md | Append-only architecture decisions |
| Debugging | feedback_debugging_playbook.md | .claude-sessions-memory/feedback_debugging_playbook.md | Error patterns and fixes |
| Lessons | feedback_lessons_learned.md | .claude-sessions-memory/feedback_lessons_learned.md | Process and architecture insights |
| This File | reference_key_files.md | .claude-sessions-memory/reference_key_files.md | Fast file lookup |

---

## Maxim Configuration

| Category | File | Path | Purpose |
|---|---|---|---|
| Project Manifest | project-manifest.json | config/project-manifest.json | Project identity, compliance, tech stack |
| Universal Rules | CLAUDE.md | CLAUDE.md | Maxim operating standard — all sessions |
| Project Overrides | CLAUDE.project.md | CLAUDE.project.md | Project-specific rule overrides |
| Session Bridge | documents/ledgers/SESSION_CONTINUITY.md | documents/ledgers/SESSION_CONTINUITY.md | Cross-session context bridge |
| Agent Registry | agent-registry.json | config/agent-registry.json | All registered Maxim agents |

---

## Application Source

| Category | File | Path | Purpose |
|---|---|---|---|
| Entry Point | [filename] | [path] | [purpose] |
| Config | [filename] | [path] | [purpose] |
| Environment | [filename] | [path] | [purpose] |
| Docker | [filename] | [path] | [purpose] |

---

## API and Schema

| Category | File | Path | Purpose |
|---|---|---|---|
| OpenAPI Spec | [filename] | [path] | [purpose] |
| DB Schema | [filename] | [path] | [purpose] |
| DB Migrations | [directory] | [path] | [purpose] |
| Data Models | [filename] | [path] | [purpose] |

---

## Infrastructure and Deployment

| Category | File | Path | Purpose |
|---|---|---|---|
| CI/CD Pipeline | [filename] | [path] | [purpose] |
| IaC / Terraform | [directory] | [path] | [purpose] |
| Kubernetes | [directory] | [path] | [purpose] |
| Env Template | [filename] | [path] | [purpose] |

---

## Testing

| Category | File | Path | Purpose |
|---|---|---|---|
| Test Config | [filename] | [path] | [purpose] |
| Unit Tests | [directory] | [path] | [purpose] |
| Integration Tests | [directory] | [path] | [purpose] |
| Test Fixtures | [directory] | [path] | [purpose] |

---

## Security and Compliance

| Category | File | Path | Purpose |
|---|---|---|---|
| Auth Config | [filename] | [path] | [purpose] |
| Secrets Template | [filename] | [path] | [purpose] |
| Compliance Notes | [filename] | [path] | [purpose] |

---

## Maintenance Notes

- Only add files with architectural significance — not every source file
- When a file is deleted or moved, update this table immediately
- If this file is out of date, treat it as a gap and update before proceeding with the session task
