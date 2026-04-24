---
description: Activate the Superpowers workflow pattern set — brainstorming, TDD, systematic debugging, subagent dispatch, git worktrees, writing plans.
---

# /mxm-superpowers

## Usage
- Claude Code: `/mxm-superpowers`
- Claude CLI: `claude "/mxm-superpowers"`
- Claude Desktop: type `/mxm-superpowers` in chat

Activates composable workflow patterns from `community-packs/superpowers/`.

**Triggers:** "use superpowers", "subagent mode", "parallel specialists",
              "systematic debug", "TDD", "verify before done"
**Reads:** `community-packs/superpowers/skills/`
**Patterns:**
  - `writing-plans`               — new feature / new project
  - `executing-plans`             — plan exists, now implementing
  - `subagent-driven-development` — parallel specialists needed
  - `test-driven-development`     — tests first
  - `systematic-debugging`        — bug or regression
  - `verification-before-completion` — before marking any task done

## Behavior

1. Classify requested pattern from trigger signal
2. Activate matching superpowers skill from `community-packs/superpowers/skills/`
3. Combine with office dispatch as appropriate
4. Tag output: 🟢 HIGH
