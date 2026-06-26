---
description: Autonomous Workflow Standard surface (ADR-022) — author, register, dry-run, and go-live unattended workflows through the mxm-orchestrator with mandatory budget guards, a separate verification gate, idempotency, and dry-run default ON.
---

# /mxm-workflow

## Usage
- Claude Code: `/mxm-workflow [new|list|run|go-live|logs] [name]`
- Claude CLI: `claude "/mxm-workflow list"`
- Claude Desktop: type `/mxm-workflow` in chat

The surface for the `orchestrator` skill (ADR-022). Governs **unattended** automation only — for interactive "iterate until X" work, use the `loops` skill instead. Owned by the COO `planner`.

## Behavior

### Mode 1 — New (`/mxm-workflow new <name>`)
1. Load `.claude/skills/orchestrator/SKILL.md` (the contract) and ADR-022 (§3 the 10-section template).
2. Scaffold a workflow module at `orchestrator/workflows/<name>.mjs` exporting the `Workflow` contract, **verification first** — refuse to scaffold without a "wrong output" definition + a `verify()` gate (ADR-002).
3. Set sane budget guards (concrete `max_tokens/max_tool_calls/max_runtime_s/max_cost_usd`) and `dry_run: true`.
4. If the workflow touches PII/regulated/financial data → wire the **CSO auto-loop** (`security-analyst` into `verify`).
5. Register it (disabled-for-go-live, dry-run ON) and report the 10-section checklist status.

### Mode 2 — List (default: `/mxm-workflow` or `/mxm-workflow list`)
1. Read `orchestrator/workflows/` + the registry; show each workflow's `id`, enabled state, `dry_run` flag, budget, last terminal state (from `.mxm-skills/workflows/runs/`).

### Mode 3 — Run / Dry-run (`/mxm-workflow run <name>`)
1. Execute via the orchestrator in **dry-run** (default): `node orchestrator/run.mjs <name> --dry-run` (or the planner invokes the engine).
2. Show the per-step RunLog (`.mxm-skills/runlog.jsonl`) + terminal state + budget consumed. **No side-effect fires in dry-run.**
3. Confidence-tag the result (ADR-010); if `escalate` → route to the review queue via `handoff-coordinator`.

### Mode 4 — Go-live (`/mxm-workflow go-live <name>`)
1. **Require explicit operator approval in-session** (this flips `dry_run:false` — a side-effectful change).
2. Pre-flight: confirm the acceptance test passes (`node orchestrator/acceptance-test.mjs` → READY) and the workflow has run ≥1 clean dry-run.
3. Flip `dry_run:false`, enable in the registry, and (if scheduled) hand the trigger to the `usage-aware-scheduler`.

### Mode 5 — Logs (`/mxm-workflow logs [name]`)
1. Tail `.mxm-skills/runlog.jsonl` (optionally filtered by `workflow_id`); summarize terminal states, budget spend, and any dead-letter entries (`.mxm-skills/workflows/dead-letter/`).

## Guardrails (ADR-022 §8)
- No workflow ships without all three layers (Trigger→Agent→**Verify**) + the 10 template sections.
- `dry_run` default ON for every side-effectful workflow until the operator approves go-live.
- No sends/trades/publishes/destructive writes unattended without an explicit human-approval gate.
- Every run is logged, budgeted, idempotent, and escalatable. Secrets are requested and loaded from env/Doppler — never hardcoded.
