// Maxim — mxm-orchestrator engine (ADR-022, Phase 1 MVP)
// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
//
// The deterministic core of the Autonomous Workflow Standard. Pure Node, zero
// external deps, cross-platform (node:path / node:fs only — no shell, no bash
// escaping, per the PATTERN-01 cross-platform discipline). This is the part that
// MUST be real code rather than a markdown instruction, because the §5 acceptance
// test requires a provable hard-kill on budget breach.
//
// Governance contract: .claude/skills/orchestrator/SKILL.md
// Surface command:     .claude/commands/mxm-workflow.md

import fs from 'node:fs';
import path from 'node:path';

// Named terminal states — reused verbatim from the `loops` skill so the
// interactive (loops) and unattended (workflow) layers speak one vocabulary.
export const TERMINAL = {
  SUCCESS: 'success',
  CLEAN_NO_OP: 'clean-no-op',
  BLOCKED: 'blocked',
  APPROVAL_REQUIRED: 'approval-required',
  EXHAUSTED: 'exhausted', // a BudgetGuard hard-stop
  STAGNATED: 'stagnated',
  FAILED: 'failed', // error / verification fail → dead-letter
};

export class BudgetExceeded extends Error {
  constructor(kind, limit, attempted) {
    super(`BudgetGuard hard-stop: ${kind} limit ${limit} exceeded (attempted ${attempted})`);
    this.name = 'BudgetExceeded';
    this.kind = kind;
    this.limit = limit;
    this.attempted = attempted;
  }
}

export class WorkflowVerificationFailed extends Error {
  constructor(verdict, detail) {
    super(`Verification returned "${verdict}"${detail ? `: ${detail}` : ''}`);
    this.name = 'WorkflowVerificationFailed';
    this.verdict = verdict;
  }
}

// ── BudgetGuard ──────────────────────────────────────────────────────────────
// Tracks tokens / tool_calls / runtime / cost against hard limits. Any breach
// throws BudgetExceeded synchronously — the engine catches it, marks the run
// `exhausted`, and dead-letters it BEFORE any side-effect can fire.
export class BudgetGuard {
  constructor(budget = {}) {
    this.limits = {
      max_tokens: budget.max_tokens ?? null,
      max_tool_calls: budget.max_tool_calls ?? null,
      max_runtime_s: budget.max_runtime_s ?? null,
      max_cost_usd: budget.max_cost_usd ?? null,
    };
    this.spent = { tokens: 0, tool_calls: 0, cost_usd: 0 };
    this.startedAt = null;
  }

  start(now) {
    this.startedAt = now;
  }

  charge(kind, amount, now) {
    if (!(kind in this.spent)) throw new Error(`BudgetGuard: unknown charge kind "${kind}"`);
    this.spent[kind] += amount;
    this._check(now);
  }

  tick(now) {
    this._check(now);
  }

  _check(now) {
    const L = this.limits;
    if (L.max_tokens != null && this.spent.tokens > L.max_tokens)
      throw new BudgetExceeded('max_tokens', L.max_tokens, this.spent.tokens);
    if (L.max_tool_calls != null && this.spent.tool_calls > L.max_tool_calls)
      throw new BudgetExceeded('max_tool_calls', L.max_tool_calls, this.spent.tool_calls);
    if (L.max_cost_usd != null && this.spent.cost_usd > L.max_cost_usd)
      throw new BudgetExceeded('max_cost_usd', L.max_cost_usd, this.spent.cost_usd);
    if (L.max_runtime_s != null && this.startedAt != null && now != null) {
      const elapsed = (now - this.startedAt) / 1000;
      if (elapsed > L.max_runtime_s)
        throw new BudgetExceeded('max_runtime_s', L.max_runtime_s, Number(elapsed.toFixed(3)));
    }
  }

  snapshot(now) {
    const runtime_s =
      this.startedAt != null && now != null ? Number(((now - this.startedAt) / 1000).toFixed(3)) : 0;
    return { tokens: this.spent.tokens, tool_calls: this.spent.tool_calls, cost_usd: this.spent.cost_usd, runtime_s };
  }
}

// ── StateStore ───────────────────────────────────────────────────────────────
// Run/step persistence + idempotency markers + dead-letter, all under the
// project-local .mxm-skills/workflows/ tree (gitignored, runtime-local).
export class StateStore {
  constructor(baseDir) {
    this.runsDir = path.join(baseDir, 'workflows', 'runs');
    this.dlqDir = path.join(baseDir, 'workflows', 'dead-letter');
    this.idemDir = path.join(baseDir, 'workflows', 'idempotency');
    for (const d of [this.runsDir, this.dlqDir, this.idemDir]) fs.mkdirSync(d, { recursive: true });
  }

  _safe(s) {
    return String(s).replace(/[^a-zA-Z0-9._-]/g, '_');
  }

  seen(key) {
    if (!key) return false;
    return fs.existsSync(path.join(this.idemDir, this._safe(key)));
  }

  mark(key, runId) {
    if (!key) return;
    fs.writeFileSync(path.join(this.idemDir, this._safe(key)), String(runId), 'utf8');
  }

  saveRun(runId, state) {
    fs.writeFileSync(path.join(this.runsDir, `${this._safe(runId)}.json`), JSON.stringify(state, null, 2), 'utf8');
  }

  deadLetter(runId, state) {
    const p = path.join(this.dlqDir, `${this._safe(runId)}.json`);
    fs.writeFileSync(p, JSON.stringify(state, null, 2), 'utf8');
    return p;
  }
}

// ── RunLog ───────────────────────────────────────────────────────────────────
// One structured JSON record per step → .mxm-skills/runlog.jsonl (the unified
// log that supersedes the per-automation ad-hoc .jsonl shapes).
export class RunLog {
  constructor(baseDir) {
    fs.mkdirSync(baseDir, { recursive: true });
    this.file = path.join(baseDir, 'runlog.jsonl');
  }

  record(rec) {
    fs.appendFileSync(this.file, JSON.stringify(rec) + '\n', 'utf8');
  }
}

// ── Registry ─────────────────────────────────────────────────────────────────
// Enable/disable workflows + per-workflow dry-run. Workflow modules live in
// orchestrator/workflows/ and export a factory or a Workflow object.
export class Registry {
  constructor() {
    this.workflows = new Map();
  }

  register(workflow) {
    if (!workflow || !workflow.id) throw new Error('Registry.register: workflow.id required');
    if (typeof workflow.run !== 'function') throw new Error(`Registry.register: workflow "${workflow.id}" needs run()`);
    if (typeof workflow.verify !== 'function')
      throw new Error(`Registry.register: workflow "${workflow.id}" needs a verify() gate (ADR-022: no unattended output ships unverified)`);
    this.workflows.set(workflow.id, { workflow, enabled: true });
    return this;
  }

  enable(id, on = true) {
    const e = this.workflows.get(id);
    if (e) e.enabled = on;
    return this;
  }

  get(id) {
    return this.workflows.get(id);
  }

  list() {
    return [...this.workflows.values()].map((e) => ({ id: e.workflow.id, enabled: e.enabled, dry_run: e.workflow.dry_run !== false }));
  }
}

// ── runWorkflow ──────────────────────────────────────────────────────────────
// The Trigger→Agent→Verify pipeline with guards. dry_run defaults ON.
export async function runWorkflow(workflow, context = {}, opts = {}) {
  const clock = opts.clock || (() => Date.now());
  const baseDir = opts.baseDir || path.join(process.env.CLAUDE_PROJECT_DIR || process.cwd(), '.mxm-skills');
  const dryRun = opts.dryRun != null ? opts.dryRun : workflow.dry_run !== false; // default ON
  const runId = opts.runId || `${workflow.id}-${clock()}`;

  const log = opts.logger || new RunLog(baseDir);
  const store = opts.store || new StateStore(baseDir);
  const escalate = opts.escalate || (() => {});

  const guard = new BudgetGuard(workflow.budget || {});
  guard.start(clock());

  const base = { run_id: runId, workflow_id: workflow.id, dry_run: dryRun };
  const rec = (step, extra = {}) => log.record({ ...base, ts: clock(), step, budget: guard.snapshot(clock()), ...extra });

  // Idempotency — a re-fire with a seen key is a clean no-op (no double-send).
  const idemKey = typeof workflow.idempotency_key === 'function' ? workflow.idempotency_key(context) : null;
  if (store.seen(idemKey)) {
    const s = { ...base, terminal_state: TERMINAL.CLEAN_NO_OP, reason: 'idempotent-skip', idempotency_key: idemKey };
    rec('idempotent-skip', { terminal_state: TERMINAL.CLEAN_NO_OP, idempotency_key: idemKey });
    store.saveRun(runId, s);
    return s;
  }

  rec('start', {
    trigger: typeof workflow.trigger === 'function' ? workflow.trigger() : 'manual',
    limits: guard.limits,
    idempotency_key: idemKey,
  });

  try {
    // RUN (the maker) — gets charge()/tick() so it reports consumption to the guard.
    const runCtx = {
      ...context,
      dryRun,
      charge: (kind, amount) => guard.charge(kind, amount, clock()),
      tick: () => guard.tick(clock()),
    };
    const output = await workflow.run(runCtx);
    rec('run-complete', {});

    // VERIFY (separate gate) — pass | fail | escalate.
    const verdict = await workflow.verify(output, { ...context, dryRun });
    rec('verify', { verdict });

    if (verdict === 'fail') throw new WorkflowVerificationFailed(verdict, output && output.reason);
    if (verdict === 'escalate') {
      const s = { ...base, terminal_state: TERMINAL.APPROVAL_REQUIRED, verdict, output, budget: guard.snapshot(clock()) };
      rec('escalate', { terminal_state: TERMINAL.APPROVAL_REQUIRED });
      escalate(s);
      store.saveRun(runId, s);
      return s;
    }

    // COMMIT (the only place a side-effect happens) — gated on !dryRun AND verified pass.
    let sideEffect = 'skipped (dry-run)';
    if (!dryRun && typeof workflow.commit === 'function') {
      sideEffect = await workflow.commit(output, {
        ...context,
        charge: (kind, amount) => guard.charge(kind, amount, clock()),
      });
    }
    rec('commit', { side_effect: sideEffect });

    // Only mark idempotency after a real (non-dry-run) committed side-effect,
    // so a dry-run never blocks the real run and a failed commit can retry.
    if (!dryRun) store.mark(idemKey, runId);

    const terminal = output && output.noop ? TERMINAL.CLEAN_NO_OP : TERMINAL.SUCCESS;
    const s = { ...base, terminal_state: terminal, verdict, output, side_effect: sideEffect, budget: guard.snapshot(clock()) };
    rec('done', { terminal_state: terminal });
    store.saveRun(runId, s);
    return s;
  } catch (err) {
    const isBudget = err instanceof BudgetExceeded;
    const terminal = isBudget ? TERMINAL.EXHAUSTED : TERMINAL.FAILED;
    const s = {
      ...base,
      terminal_state: terminal,
      error: { name: err.name, message: err.message, kind: err.kind || null },
      budget: guard.snapshot(clock()),
    };
    rec(isBudget ? 'budget-hard-stop' : 'error', { terminal_state: terminal, error: err.message });
    const dlqPath = store.deadLetter(runId, s);
    s.dead_letter = dlqPath;
    escalate(s);
    return s;
  }
}
