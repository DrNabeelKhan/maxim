// Maxim — guard-breach acceptance workflow (ADR-022 §5)
// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
//
// A no-op workflow that can be told to intentionally breach exactly one budget
// guard. Its commit() pushes to a shared `externalSink` — the test asserts the
// sink stays EMPTY on every breach (proving nothing reaches the outside world
// when a guard fires), and gets exactly one entry on the within-budget happy
// path (proving the side-effect DOES fire when verified + go-live).

export function makeAcceptanceWorkflow({ breach = null, externalSink, idem = null }) {
  return {
    id: `noop-acceptance--${breach || 'within-budget'}`,
    trigger: () => 'manual',
    idempotency_key: () => idem,
    budget: { max_tokens: 100, max_tool_calls: 3, max_runtime_s: 1, max_cost_usd: 0.05 },
    dry_run: true, // default ON — overridden per-invocation by the test

    async run(ctx) {
      // Normal, within-budget consumption...
      ctx.charge('tokens', breach === 'tokens' ? 1000 : 10); // 1000 > 100 → breach
      if (breach === 'tool_calls') {
        for (let i = 0; i < 5; i++) ctx.charge('tool_calls', 1); // 5 > 3 → breach
      } else {
        ctx.charge('tool_calls', 1);
      }
      ctx.charge('cost_usd', breach === 'cost' ? 1.0 : 0.001); // 1.0 > 0.05 → breach
      if (breach === 'runtime') {
        ctx.bumpClock(5000); // advance the (injected) clock past max_runtime_s
        ctx.tick(); // → breach
      }
      // Did work + (would) commit → terminal `success`. (We deliberately do NOT
      // return {noop:true} here — that marker is the engine's signal for the
      // distinct `clean-no-op` terminal, exercised by the idempotent re-fire.)
      return { ok: true, did: 'work done' };
    },

    verify(output) {
      return output && output.ok ? 'pass' : 'fail';
    },

    async commit(output, ctx) {
      // THE side-effect. Must never run on a breach (engine throws first) and
      // must never run in dry-run mode.
      externalSink.push({ workflow: this.id, output });
      return 'committed';
    },
  };
}
