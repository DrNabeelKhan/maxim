---
description: TIER 1 verb-first — plan a sprint, feature, or migration. Wraps Planning-With-Files community pack with Maxim behavioral overlay (Fogg B=MAP scope check, COM-B, Coverage Matrix) and confidence tagging.
---

# /mxm-plan

## Usage
- Claude Code: `/mxm-plan <what to plan>`
- Claude CLI: `claude "/mxm-plan <what to plan>"`
- Claude Desktop: type `/mxm-plan <what to plan>` in chat

TIER 1 verb-first surface (v1.0.0+; aligned with v1.2.0 verb-first roster). Activates the `planner` orchestrator. Reads `community-packs/planning-with-files/SKILL.md`. Writes planning files and architecture documents to canonical locations.

**Triggers:** "plan this", "write a plan", "before we start", "multi-session", "plan a sprint", "plan a feature", "plan a migration"
**Primary Office:** COO → `planner` (lead)
**Auto-loops:**
- CPO `product-strategist` — auto-loops on feature/product planning (Jobs-to-be-Done, OKR mapping)
- Relevant behavioral framework selector — picks the right framework from FRAMEWORKS_MASTER.md per task domain (Fogg/COM-B/EAST for behavior change; SCQA/Minto for strategy docs; etc.)

**Reads:** `community-packs/planning-with-files/SKILL.md` · `templates/sprint-plan.md` (if sprint planning) · `documents/reference/FRAMEWORKS_MASTER.md`
**Chains to:** `/mxm-implement` (or `/mxm-build`) after plan approval

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

## Behavioral Overlay

- **Fogg B=MAP scope check:** Every plan declares Motivation (operator urgency), Ability (resources, dependencies, scope vs. dev-day budget), Prompt (immediate trigger). Plans where Ability is low get explicit "split into N smaller plans" notes — Maxim refuses to plan unattainable scope as if it were attainable.
- **Coverage Matrix (sprint plans only):** Sprint plans include a Coverage Matrix appendix per `templates/sprint-plan.md` cross-referencing every workstream against ADRs, BUG_TRACKER patterns, MOAT_TRACKER claims, and compliance frameworks. Drift between plan and Coverage Matrix is a Class 3 contract-drift instance.
- **Confidence tag rubric (per ADR-010):** 🟢 HIGH = plan grounded in read manifest + Coverage Matrix complete + Fogg scope clean. 🟡 MEDIUM = plan complete but Coverage Matrix abbreviated. 🔴 LOW = scope exceeds Ability (split required).

## Behavior

1. Read `config/project-manifest.json` for project identity and compliance scope
2. **Fogg B=MAP scope check** — score the task; flag if Ability low and recommend split
3. Read `community-packs/planning-with-files/SKILL.md`
4. Activate `planner` — write canonical `task_plan.md`
5. If sprint plan: also write per `templates/sprint-plan.md` with Coverage Matrix appendix
6. If architecture docs needed (PRD, FRD, SRD) → write to `documents/architecture/`
7. If build intakes or credentials → write to `documents/architecture/.secrets/`
8. Confirm plan with user before proceeding
9. Initialize `progress.md` and `findings.md`
10. Tag output per the confidence rubric above

## TIER 1 surface note

Verb-first entry point. Power users can type `/mxm-coo` directly. `/mxm-plan` is the plain-English surface for any operator who thinks "plan X" before they think "COO planner agent."
