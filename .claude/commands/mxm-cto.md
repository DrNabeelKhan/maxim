---
description: Routes to the CTO Office. Lead: implementer. Scope: engineering, infrastructure, data, AI, APIs, DevOps, cloud.
---

# /mxm-cto

## Usage
- Claude Code: `/mxm-cto`
- Claude CLI: `claude "/mxm-cto"`
- Claude Desktop: type `/mxm-cto` in chat

Routes to CTO Office. Lead: `implementer`.
Scope: engineering · AI/ML · APIs · DevOps · infrastructure · databases · security architecture

## Behavior
1. Read `config/project-manifest.json` for tech stack
2. Activate `implementer` as lead
3. Read `.claude/skills/engineering/`
4. Apply CTO office roster (25 agents) — routes to specialist based on task type:
   `ai-engineer` · `backend-architect` · `frontend-developer` · `devops-automator` ·
   `rag-specialist` · `prompt-engineer` · `api-integrator` · `data-architect` ·
   `data-scientist` · `mobile-app-builder` · `rapid-prototyper` and more
5. Check for active `task_plan.md` — follow plan if present
6. Append completed steps to `progress.md`
7. On completion: hand off to `reviewer` via `.mxm-skills/agents-handoff.md`
8. Tag output: 🟢 HIGH
