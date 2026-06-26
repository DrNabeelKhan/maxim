// Maxim — competitor-watch workflow (ADR-022, Workflow #2 — read-only/safe)
// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
//
// The unattended "monitor a competitor, ping on real moves" version of the
// `competitor-watch` skill. READ-ONLY (🟢): it never acts on the world, it only
// surfaces changes — so even go-live has no destructive side-effect. The agent
// performs the actual web/intel work by following .claude/skills/competitor-watch;
// this definition gives the orchestrator the governance (budget, idempotency,
// dry-run-default, verification, logging).
//
//   node orchestrator/run.mjs competitor-watch     # dry-run → prints the PLAN
//   /mxm-workflow go-live competitor-watch          # turns on morning delivery

export default {
  id: 'competitor-watch',
  trigger: () => 'schedule', // e.g. "0 8 * * 1" weekly via the usage-aware-scheduler
  idempotency_key: (ctx) => `competitor-watch:${ctx.competitor || 'unset'}:${ctx.date || 'manual'}`,
  budget: { max_tokens: 80000, max_tool_calls: 50, max_runtime_s: 420, max_cost_usd: 0.60 },
  dry_run: true,

  async run(ctx) {
    ctx.charge('tool_calls', 1);
    const plan = [
      'load the last snapshot for the named competitor (StateStore)',
      'gather current signals via web / a competitive-intel connector (read-only)',
      'diff vs. last snapshot — keep only REAL moves (launch / pricing / positioning)',
      'score each move vs. the operator moat (Porter / 7 Powers); mark fact vs. inference',
      'deliver a digest; persist the new snapshot for next time',
    ];
    if (ctx.dryRun) {
      return { noop: false, mode: 'dry-run', plan, read_only: true, requires: 'competitor name + web/intel source' };
    }
    if (!ctx.competitor) {
      return { blocked: true, reason: 'no competitor specified — set ctx.competitor (e.g. "Acme Corp")' };
    }
    // Read-only: the agent gathers + diffs here; no external action is ever taken.
    return { ok: true, competitor: ctx.competitor, moves: ctx.moves ?? [], read_only: true };
  },

  verify(output) {
    if (output.blocked) return 'escalate';
    if (output.mode === 'dry-run') return Array.isArray(output.plan) && output.plan.length > 0 ? 'pass' : 'fail';
    return output.ok ? 'pass' : 'fail';
  },

  // Read-only workflow: "commit" = deliver the digest + persist the snapshot. No external action.
  async commit() {
    return 'digest delivered + snapshot persisted (read-only; nothing acted on)';
  },
};
