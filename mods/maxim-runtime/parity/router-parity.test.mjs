// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// Parity: in keyword mode, the runtime's router (hooks/lib/router.ts) must route
// every prompt exactly as the shell router (.claude/hooks/user-prompt-router.sh)
// does, against the real config/routing-table.json.
// Run from the repo root: node --test mods/maxim-runtime/parity/router-parity.test.mjs
// Needs bash and python3 on PATH (the shell router's own requirements), and a Node
// that runs TypeScript by type stripping (22.18 or newer) for the router.ts import.

import { test } from 'node:test'
import assert from 'node:assert/strict'
import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'
import { after } from 'node:test'

import { classify } from '../hooks/lib/router.ts'

const here = dirname(fileURLToPath(import.meta.url))
const repo = join(here, '..', '..', '..')
const table = JSON.parse(readFileSync(join(repo, 'config', 'routing-table.json'), 'utf8'))

// The shell router appends to <cwd>/.mxm-skills/routing-log.jsonl; run it in a
// throwaway folder so the test never writes into the repository.
const scratch = mkdtempSync(join(tmpdir(), 'mxm-parity-'))
after(() => rmSync(scratch, { recursive: true, force: true }))

const PROMPTS = [
  'fix the failing test on the api endpoint',
  'write a linkedin post announcing our launch',
  'design a landing page with a dark mode theme',
  'run a gdpr privacy audit of the signup flow',
  'what is our pricing strategy and competitive moat for investors',
  'write a prd with user stories and okrs for onboarding',
  'research emerging tech trends for a whitepaper',
  'plan the next sprint milestones',
  'back to our plan',
  'yes go',
  'thanks',
  'check claude code mods and tell me how can we use them to improve maxim',
  'review this stack design for the routing layer',
  'run /mxm-build on the login api',
  '<system-reminder>build fix bug</system-reminder>',
  '> quoted: fix the bug\nthanks for that',
  'can you help me write a reply to this message from a customer about a security bug',
  'refactor the database pipeline and deploy the backend',
  'the therapist explained the features of the codex',
  'audit our threat model and encryption for pii, then fix the vulnerability',
  'Write the ui component in tailwind with css for the banner',
  'loop until the tests pass, iterate until coverage is complete',
]

function shellRoute(prompt) {
  const out = execFileSync('bash', [join(repo, '.claude', 'hooks', 'user-prompt-router.sh')], {
    input: JSON.stringify({ prompt, cwd: scratch }),
    env: { ...process.env, CLAUDE_PLUGIN_ROOT: repo },
    encoding: 'utf8',
  }).trim()
  if (!out) return null
  const ctx = JSON.parse(out).hookSpecificOutput.additionalContext
  return /task \(([a-z-]+)\)/.exec(ctx)?.[1] ?? 'unparsed'
}

for (const prompt of PROMPTS) {
  test(`same route: ${prompt.slice(0, 60)}`, () => {
    const v = classify(prompt, table)
    const mine = v.kind === 'route' ? v.route.id : null
    assert.equal(mine, shellRoute(prompt))
  })
}
