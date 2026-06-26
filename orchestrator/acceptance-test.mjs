// Maxim — mxm-orchestrator guard-breach acceptance test (ADR-022 §5)
// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
//
// Proves the orchestrator BEFORE any real workflow runs on it:
//   - a no-op workflow that breaches each guard (token / call / runtime / cost)
//     → clean hard-stop (terminal=exhausted) + dead-letter + log, NOTHING external.
//   - the within-budget happy path → success + the side-effect fires.
//   - dry-run → success but the side-effect is skipped.
//   - a re-fire with a seen idempotency key → clean-no-op, no double-commit.
//
// Run:  node orchestrator/acceptance-test.mjs   (exit 0 = PASS, 1 = FAIL)

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { runWorkflow, StateStore, RunLog, TERMINAL } from './engine.mjs';
import { makeAcceptanceWorkflow } from './workflows/noop-acceptance.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, '..');
const baseDir = path.join(repoRoot, '.mxm-skills', '_acceptance-test');

// Fresh sandbox each run (deterministic).
fs.rmSync(baseDir, { recursive: true, force: true });
fs.mkdirSync(baseDir, { recursive: true });

const store = new StateStore(baseDir);
const logger = new RunLog(baseDir);
const runlogFile = path.join(baseDir, 'runlog.jsonl');

const results = [];
const check = (name, cond, detail = '') => results.push({ name, ok: !!cond, detail });

function runlogHas(runId, step) {
  if (!fs.existsSync(runlogFile)) return false;
  return fs
    .readFileSync(runlogFile, 'utf8')
    .split('\n')
    .filter(Boolean)
    .map((l) => JSON.parse(l))
    .some((r) => r.run_id === runId && r.step === step);
}

// Each invocation gets a controllable clock so the runtime breach is deterministic.
function makeClock(start = 1_000_000) {
  let now = start;
  return { clock: () => now, bumpClock: (ms) => { now += ms; } };
}

const BREACHES = [
  ['tokens', 'max_tokens'],
  ['tool_calls', 'max_tool_calls'],
  ['cost', 'max_cost_usd'],
  ['runtime', 'max_runtime_s'],
];

console.log('mxm-orchestrator — guard-breach acceptance test (ADR-022 §5)\n');

for (const [breach, limitKind] of BREACHES) {
  const externalSink = [];
  const { clock, bumpClock } = makeClock();
  const wf = makeAcceptanceWorkflow({ breach, externalSink });
  const runId = `acc-${breach}`;
  // dryRun:false on purpose — commit() WOULD fire if the breach didn't hard-stop first.
  const res = await runWorkflow(wf, { bumpClock }, { baseDir, store, logger, clock, runId, dryRun: false });

  check(`[${breach}] terminal = exhausted`, res.terminal_state === TERMINAL.EXHAUSTED, res.terminal_state);
  check(`[${breach}] breached guard = ${limitKind}`, res.error && res.error.kind === limitKind, res.error && res.error.kind);
  check(`[${breach}] dead-letter written`, res.dead_letter && fs.existsSync(res.dead_letter));
  check(`[${breach}] NOTHING sent externally`, externalSink.length === 0, `sink=${externalSink.length}`);
  check(`[${breach}] hard-stop logged`, runlogHas(runId, 'budget-hard-stop'));
}

// Happy path — within budget, go-live (dryRun:false). The side-effect must fire.
{
  const externalSink = [];
  const { clock } = makeClock();
  const wf = makeAcceptanceWorkflow({ breach: null, externalSink, idem: 'idem-key-1' });
  const res = await runWorkflow(wf, {}, { baseDir, store, logger, clock, runId: 'acc-ok', dryRun: false });
  check('[ok] terminal = success', res.terminal_state === TERMINAL.SUCCESS, res.terminal_state);
  check('[ok] side-effect fired (committed)', externalSink.length === 1, `sink=${externalSink.length}`);
  check('[ok] idempotency marked', store.seen('idem-key-1'));

  // Re-fire the SAME idempotency key → clean no-op, no double-commit.
  const res2 = await runWorkflow(wf, {}, { baseDir, store, logger, clock, runId: 'acc-ok-2', dryRun: false });
  check('[idempotent] re-fire = clean-no-op', res2.terminal_state === TERMINAL.CLEAN_NO_OP, res2.terminal_state);
  check('[idempotent] NO double-commit', externalSink.length === 1, `sink=${externalSink.length}`);
}

// Dry-run — within budget but dry_run ON. Success, but side-effect skipped.
{
  const externalSink = [];
  const { clock } = makeClock();
  const wf = makeAcceptanceWorkflow({ breach: null, externalSink, idem: 'idem-key-2' });
  const res = await runWorkflow(wf, {}, { baseDir, store, logger, clock, runId: 'acc-dry', dryRun: true });
  check('[dry-run] terminal = success', res.terminal_state === TERMINAL.SUCCESS, res.terminal_state);
  check('[dry-run] side-effect SKIPPED', res.side_effect === 'skipped (dry-run)', res.side_effect);
  check('[dry-run] nothing committed', externalSink.length === 0, `sink=${externalSink.length}`);
  check('[dry-run] idempotency NOT marked (dry-run never blocks the real run)', store.seen('idem-key-2') === false);
}

// ── Report ───────────────────────────────────────────────────────────────────
let pass = 0;
let fail = 0;
for (const r of results) {
  const tag = r.ok ? 'PASS' : 'FAIL';
  if (r.ok) pass++;
  else fail++;
  console.log(`  ${tag}  ${r.name}${!r.ok && r.detail ? `  (got: ${r.detail})` : ''}`);
}
console.log(`\n${fail === 0 ? 'READY' : 'BLOCKED'} — ${pass} passed, ${fail} failed.`);
console.log(`Artifacts: ${path.relative(repoRoot, baseDir)}/ (runlog.jsonl, workflows/runs/, workflows/dead-letter/)`);
process.exit(fail === 0 ? 0 : 1);
