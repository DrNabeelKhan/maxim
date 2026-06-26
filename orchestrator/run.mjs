// Maxim — mxm-orchestrator CLI runner (ADR-022)
// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
//
// Surface for `/mxm-workflow run <name>`. Loads a workflow module from
// orchestrator/workflows/<name>.mjs and runs it through the engine.
// Dry-run is the DEFAULT — pass --go-live to allow the side-effect (commit).
//
//   node orchestrator/run.mjs <name>            # dry-run (no side-effect)
//   node orchestrator/run.mjs <name> --go-live  # live (commit fires on verify pass)

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { runWorkflow } from './engine.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const [, , name, ...flags] = process.argv;
const dryRun = !flags.includes('--go-live'); // default ON

if (!name) {
  console.error('usage: node orchestrator/run.mjs <name> [--go-live]');
  process.exit(2);
}

const wfPath = path.join(__dirname, 'workflows', `${name}.mjs`);
if (!fs.existsSync(wfPath)) {
  console.error(`workflow not found: ${path.relative(path.resolve(__dirname, '..'), wfPath)}`);
  process.exit(2);
}

const mod = await import(pathToFileURL(wfPath).href);
// Accept: default-export object, named `workflow`, or a zero-arg factory.
let wf = mod.default ?? mod.workflow;
if (typeof wf === 'function') wf = wf({});
if (!wf || !wf.id) {
  const factory = Object.values(mod).find((v) => typeof v === 'function');
  if (factory) wf = factory({});
}
if (!wf || typeof wf.run !== 'function') {
  console.error(`"${name}" does not export a Workflow (need {id, run, verify})`);
  process.exit(2);
}

if (dryRun) console.error(`[dry-run] ${wf.id} — no side-effect will fire. Use --go-live to commit.`);
const res = await runWorkflow(wf, {}, { dryRun });
console.log(JSON.stringify(res, null, 2));
process.exit(res.terminal_state === 'failed' || res.terminal_state === 'exhausted' ? 1 : 0);
