---
description: Implementation mode — dispatches to CTO office implementer agent with test-first discipline, Superpowers TDD integration, and commit protocol.
---

# /mxm-implement

## Usage
- Claude Code: `/mxm-implement`
- Claude CLI: `claude "/mxm-implement"`
- Claude Desktop: type `/mxm-implement` in chat

Activates the CTO office. `implementer` leads. Reads active `task_plan.md` if present.

**Triggers:** "implement", "build", "code this", "start coding", "/cto"
**Office:** CTO → `implementer` (lead)
**Reads:** `task_plan.md` (if exists) · `.claude/skills/engineering/`
**Chains to:** `/mxm-review` on completion

## Behavior

1. Check for active `task_plan.md` — if present, follow plan steps
2. Activate `implementer` → delegates to relevant CTO office agents
3. Apply `.claude/skills/engineering/` behavioral layer
4. Append completed steps to `progress.md`
5. Write findings to `findings.md`
6. On completion: notify `reviewer` via `.mxm-skills/agents-handoff.md`
7. Tag output: 🟢 HIGH
