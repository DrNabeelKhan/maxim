---
description: Planning mode — wraps Planning-With-Files community pack with Maxim behavioral overlay (Fogg B=MAP, COM-B) and confidence tagging.
---

# /mxm-plan

## Usage
- Claude Code: `/mxm-plan`
- Claude CLI: `claude "/mxm-plan"`
- Claude Desktop: type `/mxm-plan` in chat

Activates the `planner` orchestrator. Reads `community-packs/planning-with-files/SKILL.md`.
Writes planning files and architecture documents to canonical locations.

**Triggers:** "plan this", "write a plan", "before we start", "multi-session"
**Office:** COO → `planner` (lead)
**Reads:** `community-packs/planning-with-files/SKILL.md`
**Chains to:** `/mxm-implement` after plan approval

**Canonical file locations:**
| File | Location |
|---|---|
| `task_plan.md` | `.claude-sessions-memory/` (or project root for active use) |
| `progress.md` | `.claude-sessions-memory/` |
| `findings.md` | `.claude-sessions-memory/` |
| PRD, FRD, SRD, ARCHITECTURE.md | `documents/architecture/` |
| Build intakes, API keys | `documents/architecture/.secrets/` |
| Business docs, investor narrative | `documents/business/` |
| Prototypes, POCs | `prototypes/` |

## Behavior

1. Read `config/project-manifest.json` for project identity and compliance scope
2. Read `community-packs/planning-with-files/SKILL.md`
3. Activate `planner` — write canonical `task_plan.md`
4. If architecture docs needed (PRD, FRD, SRD) → write to `documents/architecture/`
5. If build intakes or credentials → write to `documents/architecture/.secrets/`
6. Confirm plan with user before proceeding
7. Initialize `progress.md` and `findings.md`
8. Tag output: 🟢 HIGH — planning-with-files active
