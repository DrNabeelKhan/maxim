# mxm-orchestrator — Autonomous Workflow Standard (ADR-022)

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

The deterministic core of Maxim's **unattended** automation. A *workflow* is a process a trigger fires **without a human present** — so budgets, a separate verification gate, idempotency, and dry-run are **mandatory** (a human isn't there to stop a runaway). Governed by [ADR-022](../documents/ADRs/ADR-022-autonomous-workflow-standard.md). Authoring contract: [`.claude/skills/orchestrator/SKILL.md`](../.claude/skills/orchestrator/SKILL.md). Surface: `/mxm-workflow`.

**Loops vs. workflows:** the `loops` skill governs *interactive, operator-present* iteration (no invented budgets). This governs the *unattended* case (budgets enforced). They compose — this engine reuses the `loops` terminal-state vocabulary.

## Files

| File | Purpose |
|---|---|
| `engine.mjs` | The engine — `BudgetGuard`, `StateStore`, `RunLog`, `Registry`, `runWorkflow()`. Pure Node, zero deps, cross-platform. |
| `run.mjs` | CLI runner for `/mxm-workflow run <name>` (dry-run default; `--go-live` to commit). |
| `acceptance-test.mjs` | The ADR-022 §5 guard-breach test. **29/29 PASS (2026-06-26).** |
| `workflows/` | Workflow definitions. `noop-acceptance.mjs` is the test fixture. |

## The `Workflow` contract

```js
export default {
  id: 'competitor-monitor',
  trigger: () => 'schedule',
  idempotency_key: (ctx) => `${ctx.date}`,          // re-fire dedup
  budget: { max_tokens: 40000, max_tool_calls: 30, max_runtime_s: 600, max_cost_usd: 0.50 },
  dry_run: true,                                     // DEFAULT ON until go-live
  async run(ctx) { /* the maker. ctx.charge('tokens'|'tool_calls'|'cost_usd', n); ctx.tick(); */
    return { /* output */ };
  },
  verify(output, ctx) { return 'pass' | 'fail' | 'escalate'; },  // SEPARATE gate (required)
  async commit(output, ctx) { /* the ONLY place a side-effect happens */ },
};
```

The engine runs `trigger → run → verify → (commit)`. `commit()` fires **only** when `dry_run === false` **and** `verify()` returned `pass`. Any `BudgetGuard` breach throws before `commit`, so a runaway never reaches the outside world.

## Run it

```bash
node orchestrator/acceptance-test.mjs        # prove the guards (must print READY)
node orchestrator/run.mjs <name>             # dry-run a workflow (no side-effect)
node orchestrator/run.mjs <name> --go-live   # live (commit fires on verify pass)
```

## Guarantees (proven by the acceptance test)

- **Hard-kill** on any of `max_tokens / max_tool_calls / max_runtime_s / max_cost_usd` → terminal `exhausted` + dead-letter + log, **nothing sent externally**.
- **Verification gate** — `fail` → dead-letter; `escalate` → review queue (`approval-required`); only `pass` proceeds.
- **Dry-run default ON** — the side-effect is skipped; idempotency is *not* marked (a dry-run never blocks the real run).
- **Idempotency** — a re-fire with a seen key is a clean no-op (no double-send/charge/publish).

## State (project-local, gitignored)

```
.mxm-skills/runlog.jsonl                  # one JSON record per step (the unified log)
.mxm-skills/workflows/runs/<run>.json     # per-run state
.mxm-skills/workflows/dead-letter/<run>.json
.mxm-skills/workflows/idempotency/<key>   # idempotency markers
```
