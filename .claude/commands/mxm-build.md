---
description: TIER 1 verb-first — build a feature, module, or capability. Routes to CTO implementer with TDD discipline, Fogg B=MAP scope check, CSO auto-loop on regulated data, CPO loop on frontend work.
---

# /mxm-build

## Usage
- Claude Code: `/mxm-build <what to build>`
- Claude CLI: `claude "/mxm-build <what to build>"`
- Claude Desktop: type `/mxm-build <what to build>` in chat

User-facing verb-first command (TIER 1 surface added v1.2.0). Routes invisibly to the right specialists so the operator does not have to think about which office owns a build task.

**Triggers:** "build a", "build me a", "implement", "code this", "ship a feature", "add a feature", "create a", "make a", "develop a"
**Primary Office:** CTO → `implementer` (lead) → routes to specialist (backend-implementer, frontend-implementer, api-architect, data-pipeline-engineer, etc.) per signal
**Auto-loops:**
- CSO `security-analyst` — auto-loops if task signals touch regulated data (PII, PHI, PCI, financial records, AI model outputs) or auth/payment/credential code paths
- CPO `product-strategist` + `ui-ux-designer` — auto-loops if task signals are frontend (UI component, page, layout, accessibility)
- COO `planner` — auto-loops if scope > 1 day implementation time per Fogg B=MAP scope check (motivation × ability × prompt suggests planning step required first)

**Reads:** `task_plan.md` (if exists) · `.claude/skills/engineering/` · `.claude/skills/testing/` (for TDD) · `documents/reference/FRAMEWORKS_MASTER.md`
**Chains to:** `/mxm-test` (test discipline) → `/mxm-review` (quality gate)

## Behavioral Overlay

- **Fogg B=MAP scope check (BLOCKING heuristic):** Before any code is written, score the task on Motivation (operator urgency), Ability (clear specification + dependencies in place), Prompt (immediate trigger present). If Ability is low — task spans >1 dev-day or has unresolved upstream dependencies — pause and route to `/mxm-plan` first instead of building blind. Tag: 🟡 MEDIUM if scope is borderline; 🔴 LOW if Ability fails the check.
- **TDD discipline:** When task touches application code with existing test coverage, write the failing test FIRST, then implement to green. Skip TDD only when explicitly building a one-shot script with no future maintenance burden — and tag those outputs 🟡 MEDIUM with a note.
- **Confidence tag rubric (per ADR-010):** 🟢 HIGH = clear scope + test-first + reviewer second-pass passed. 🟡 MEDIUM = scope clear but TDD skipped OR reviewer waived. 🔴 LOW = scope unclear or CSO regulated-data flag pending.

## Behavior

1. **Fogg B=MAP scope pre-check** — if Ability low (task >1 day, dependencies unclear), pause and recommend `/mxm-plan` first
2. Read `task_plan.md` if active; otherwise treat the command argument as the task spec
3. **Signal scan** — auto-loop CSO if regulated-data signals; auto-loop CPO if frontend signals; auto-loop COO if scope borderline
4. Activate CTO `implementer` lead; lead routes to the right specialist (backend / frontend / API / data / ML / mobile / infra) per signal
5. Apply TDD discipline: write failing test → implement to green → refactor under green
6. Run `.claude/skills/testing/` validation on the result
7. Append progress to `progress.md`; write findings to `findings.md`
8. Hand off to `/mxm-review` via `.mxm-skills/agents-handoff.md` for quality gate
9. Tag output per the confidence rubric above

## TIER 1 surface note

This command is a thin router-frontend. The actual work happens in the CTO office. Power users can still type `/mxm-cto` directly to skip the auto-loop heuristics — `/mxm-build` is the plain-English entry point so a first-time user does not need to know the office structure.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 1 surface added v1.2.0 per AGENT_ROSTER_v1.2_PROPOSAL.md._
