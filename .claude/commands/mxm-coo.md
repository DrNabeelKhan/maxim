---
description: Routes to the COO Office. Lead: planner. Scope: operations, delivery, support, sprints, experiments.
---

# /mxm-coo

## Usage
- Claude Code: `/mxm-coo`
- Claude CLI: `claude "/mxm-coo"`
- Claude Desktop: type `/mxm-coo` in chat

Routes to COO Office. Lead: `planner`.
Scope: operations · delivery · sprints · project management · support · workflow

## Behavior
1. Activate `planner` as lead
2. Read `.claude/skills/project-management/` · `.claude/skills/studio-operations/` ·
   `.claude/skills/testing/`
3. Apply COO office roster (9 agents):
   `project-shipper` · `support-responder` · `customer-success-manager` ·
   `workflow-optimizer` · `sprint-prioritizer` · `experiment-tracker` ·
   `knowledge-base-curator` · `tool-evaluator` · `changelog-writer`
4. Multi-session tasks: activate `planning-with-files` skill
5. Write `.mxm-skills/agents-handoff.md` on completion
6. Tag output: 🟢 HIGH
