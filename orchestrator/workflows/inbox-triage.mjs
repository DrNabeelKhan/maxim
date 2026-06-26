// Maxim — inbox-triage workflow (ADR-022 + ADR-018)
// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
//
// The unattended "triage my inbox every morning" version of the `inbox-triage`
// skill. It CONSUMES an external Gmail connector/MCP (it never rebuilds email) —
// the agent executes the actual triage by following .claude/skills/inbox-triage,
// while this definition gives the orchestrator the governance: budget guard,
// idempotency, dry-run-default, verification, and the draft-only guarantee.
//
//   node orchestrator/run.mjs inbox-triage            # dry-run → prints the PLAN, touches no email
//   /mxm-workflow go-live inbox-triage                # live (requires a connected Gmail tool + approval)
//
// SAFETY: the Gmail connector is DRAFT-ONLY by platform design — it cannot send.
// This workflow never sends; at most it leaves drafts awaiting your manual send.

export default {
  id: 'inbox-triage',
  trigger: () => 'schedule', // e.g. cron "0 7 * * 1-5" via the usage-aware-scheduler
  idempotency_key: (ctx) => `inbox-triage:${ctx.date || 'manual'}`,
  budget: { max_tokens: 60000, max_tool_calls: 40, max_runtime_s: 300, max_cost_usd: 0.40 },
  dry_run: true, // default ON — go-live requires explicit approval

  async run(ctx) {
    ctx.charge('tool_calls', 1);

    // The triage plan — what the agent will do via the connector (ADR-018).
    const plan = [
      'list recent unread via the Gmail connector (search: is:unread newer_than:1d) — read-only',
      'classify each: reply-now / reply-later / ignore (Eisenhower urgency × importance)',
      'draft replies for the reply-now set (connector is DRAFT-ONLY — never sends)',
      'return a digest: counts per bucket + drafts awaiting approval + the 1–2 that matter',
    ];

    // Dry-run (default): produce the plan; touch no email. Testable with no live connector.
    if (ctx.dryRun) {
      return { noop: false, mode: 'dry-run', plan, requires: 'gmail-connector', would_send: false };
    }

    // Go-live: a real email tool must be present (Anthropic Gmail connector or a Gmail MCP).
    // The agent (via `claude --print` + the inbox-triage skill) performs the triage here.
    if (ctx.gmailToolPresent !== true) {
      return {
        blocked: true,
        reason:
          'no Gmail connector/MCP detected — connect at claude.ai → Settings → Connectors, ' +
          'or `claude mcp add gmail --scope user`',
      };
    }
    return { ok: true, triaged: ctx.triaged ?? null, would_send: false };
  },

  // Separate verification gate (ADR-022): a missing connector escalates to the
  // review queue rather than failing silently; a valid plan/result passes.
  verify(output) {
    if (output.blocked) return 'escalate';
    if (output.mode === 'dry-run') return Array.isArray(output.plan) && output.plan.length > 0 ? 'pass' : 'fail';
    return output.ok ? 'pass' : 'fail';
  },

  // The connector saves DRAFTS only — sending is impossible by platform design.
  // "commit" here = drafts saved + digest delivered. Nothing is ever sent.
  async commit() {
    return 'drafts saved (connector is draft-only; nothing sent)';
  },
};
