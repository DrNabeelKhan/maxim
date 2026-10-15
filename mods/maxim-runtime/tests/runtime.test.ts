// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// Engine tests for maxim-runtime: `claude plugin test mods/maxim-runtime`.
// The world beneath the plugin (files, git, the model, the display) is answered
// from memory by the test's own hooks.

import { describe, expect, mock, test } from 'claude-code/testing'
import type { On } from 'claude-code'

const TABLE = {
  enabled: true,
  weak_keywords: ['plan', 'design'],
  confidence_floor: 2,
  confidence_margin: 1,
  long_prompt_chars: 1200,
  routes: [
    { id: 'build', keywords: ['build', 'fix', 'bug', 'test', 'api', 'endpoint'], office: 'CTO', skills: ['engineering', 'testing'], frameworks: ['TDD / FIRST principles'] },
    { id: 'security', keywords: ['security', 'gdpr', 'threat', 'privacy'], office: 'CSO', skills: ['security', 'compliance'], frameworks: ['STRIDE'] },
    { id: 'design', keywords: ['design', 'ui', 'ux', 'css'], office: 'CPO', skills: ['design'], frameworks: ["Fitts' Law"] },
  ],
}

const STANDARD = '# Maxim is active in this session\n\nCite the framework. Tag your confidence.\n'

// Key headers built at run time, so this file itself never trips a secret scanner.
const DASHES = '-----'
const PEM_RSA = `${DASHES}BEGIN RSA PRIVATE ${'KEY'}${DASHES}`
const PEM_PLAIN = `${DASHES}BEGIN PRIVATE ${'KEY'}${DASHES}`

const FRAMEWORK = [
  '---',
  'skill_id: prospect-theory',
  'name: Prospect Theory (Loss Aversion)',
  '---',
  '',
  '# Prospect Theory',
  '',
  '## Purpose',
  'Losses weigh about twice as much as gains.',
  '',
  '---',
  '_Copyright (c) 2026 iSystematic Inc._',
].join('\n')

type Stat = { kind: 'file' | 'dir' | 'other'; realPath?: string }

type World = {
  files?: Record<string, string>
  stats?: Record<string, Stat>
  diff?: string
  unstagedDiff?: string
  classifyAs?: string
  env?: Record<string, string>
  isProcessBroken?: boolean // process.run cannot start (e.g. a bad working directory)
  sessionContext?: string[] // what the shell session-start hook sends
  shellContext?: string[] // what the shell UserPromptSubmit hooks send
}

type Seen = { statuses: (string | undefined)[]; toasts: string[]; classified: number; runs: string[][]; cwds: string[] }

const ends = (path: string, suffix: string) => path.replace(/\\/g, '/').toLowerCase().endsWith(suffix.toLowerCase())

// Installs the world beneath the plugin and returns what the plugin asked of it.
function world(on: On, w: World = {}): Seen {
  const seen: Seen = { statuses: [], toasts: [], classified: 0, runs: [], cwds: [] }
  const files: Record<string, string> = {
    '/plugin-repo/.claude-plugin/plugin.json': JSON.stringify({ name: 'maxim', version: '9.9.9' }),
    '/config/routing-table.json': JSON.stringify(TABLE),
    '/distributions/claude-plugin/session-context.md': STANDARD,
    '/composable-skills/frameworks/prospect-theory/SKILL.md': FRAMEWORK,
    ...w.files,
  }
  mock.clock(on)
  mock.env(on, w.env ?? {})
  on('classic.SessionStart', () => ({ additionalContext: w.sessionContext ?? [] }))
  on('classic.UserPromptSubmit', () => ({ additionalContext: w.shellContext ?? [] }))
  on('fs.read', ($, e) => {
    const hit = Object.keys(files).find(k => ends(e.path, k))
    if (hit === undefined) throw new Error(`no such file: ${e.path}`)
    return { value: files[hit] as string }
  })
  on('fs.list', ($, e) => {
    if (ends(e.path, '/composable-skills/frameworks')) {
      return { value: [{ name: 'prospect-theory', kind: 'dir' as const, size: 0, mtimeMs: 0, isLink: false }] }
    }
    throw new Error(`no such dir: ${e.path}`)
  })
  on('fs.stat', ($, e) => {
    const p = e.path.replace(/\\/g, '/')
    const st = w.stats?.[p]
    if (!st) throw new Error(`no such path: ${p}`)
    return { value: { kind: st.kind, size: 0, mtimeMs: 0, isLink: false, ...(st.realPath ? { realPath: st.realPath } : {}) } }
  })
  on('session.cwd', () => ({ value: 'C:/work/app' }))
  on('process.run', ($, e) => {
    if (w.isProcessBroken) throw new Error('spawn git ENOENT')
    seen.runs.push([...e.argv])
    seen.cwds.push(String(e.init?.cwd ?? ''))
    const isCached = e.argv.includes('--cached')
    return {
      value: {
        exitCode: 0,
        stdout: isCached ? (w.diff ?? '') : (w.unstagedDiff ?? ''),
        stderr: '',
        isStdoutTruncated: false,
        isStderrTruncated: false,
      },
    }
  })
  on('model.classify', () => {
    seen.classified += 1
    return { value: w.classifyAs }
  })
  on('ui.status', ($, e) => {
    seen.statuses.push(e.text)
    return { value: undefined }
  })
  on('ui.toast', ($, e) => {
    seen.toasts.push(e.text)
    return { value: undefined }
  })
  on('ui.log', () => ({ value: undefined }))
  on('ui.open', () => ({ value: { isPlaced: true as const } }))
  on('command.register', ($, e) => ({ value: { command: e.name } }))
  on('tool.register', ($, e) => ({ value: { tool: `mcp__maxim-runtime__${e.name}` } }))
  on('prompt.submit', ($, e) => ({ text: e.text, ...(e.context ? { context: e.context } : {}) }))
  on('tool.call', () => ({ result: {} as never, text: 'ok' }))
  return seen
}

// Starts the session as the engine does: the classic SessionStart event runs, which
// tells the runtime its classic hooks run here (no organization policy passes them over).
function start($: { classic: { SessionStart: (e: never) => Promise<unknown> } }) {
  return $.classic.SessionStart({ source: 'startup' } as never)
}

// Submits a prompt as the person typing it would (no command, not hidden).
function submit($: { prompt: { submit: (e: never) => Promise<{ context?: readonly string[] }> } }, text: string) {
  return $.prompt.submit({ text } as never)
}

// The reason a tool call was refused, however the engine reports it to the caller.
function refusal(r: { deny?: string; isError?: boolean; text?: string }): string | undefined {
  return r.deny ?? (r.isError === true ? r.text : undefined)
}

// What /maxim reports: the runtime's state as a person sees it.
async function report($: { command: { run: (e: never) => Promise<{ text?: string }> } }): Promise<string> {
  return String((await $.command.run({ command: 'maxim', args: '' } as never)).text)
}

describe('standard', () => {
  test('joins the system prompt as a session section', async ($, on) => {
    world(on)
    on('prompt.compose', () => ({ sections: [{ id: 'intro', text: 'core', scope: 'shared' as const }] }))
    const r = await $.prompt.compose({ model: 'm', promptModel: 'm', surfaces: [], tools: [], outputStyle: null, traits: [] })
    const last = r.sections[r.sections.length - 1]
    expect(last?.id).toBe('maxim-runtime:standard')
    expect(last?.scope).toBe('session')
    expect(last?.text.startsWith('# Maxim is active in this session')).toBe(true)
  })

  test('trims the standard from the shell session-start context, keeping the summary', async ($, on) => {
    world(on, { sessionContext: [`${STANDARD}\n## This session\n\n- Project: demo`, 'another plugin'] })
    const r = await $.classic.SessionStart({ source: 'startup' } as never)
    expect(r.additionalContext).toEqual(['## This session\n\n- Project: demo', 'another plugin'])
  })
})

describe('router', () => {
  test('routes a confident keyword prompt and shows it in the status line', async ($, on) => {
    const seen = world(on)
    await start($ as never)
    const r = await submit($, 'fix the failing test on the api endpoint')
    expect(r.context?.[0]).toContain('CTO-office task (build)')
    expect(r.context?.[0]).not.toContain('Begin your reply')
    expect(seen.statuses).toContain('Maxim · CTO · build')
    expect(seen.classified).toBe(0)
  })

  test('passes a /mxm command and a short reply through untouched', async ($, on) => {
    const seen = world(on, { classifyAs: 'build' })
    await start($ as never)
    expect((await submit($, 'run /mxm-build for the login api')).context).toBeUndefined()
    expect((await submit($, 'yes go')).context).toBeUndefined()
    expect(seen.classified).toBe(0)
  })

  test('asks the model only when the keywords are unsure', async ($, on) => {
    const seen = world(on, { classifyAs: 'security' })
    await start($ as never)
    const r = await submit($, 'can you look over how we store customer records for exposure')
    expect(seen.classified).toBe(1)
    expect(r.context?.[0]).toContain('CSO-office task (security)')
    expect(seen.statuses).toContain('Maxim · CSO · security (model)')
  })

  test('makes no model call in keywords mode', { options: { router: 'keywords' } }, async ($, on) => {
    const seen = world(on, { classifyAs: 'security' })
    await start($ as never)
    const r = await submit($, 'can you look over how we store customer records for exposure')
    expect(r.context).toBeUndefined()
    expect(seen.classified).toBe(0)
  })

  test('drops the shell router directive for a prompt it handled, keeping other context', async ($, on) => {
    world(on, { shellContext: ['[Maxim Default-On Router · ADR-021] This is a CTO-office task', 'other hook context'] })
    await start($ as never)
    await submit($, 'fix the failing test on the api endpoint')
    const r = await $.classic.UserPromptSubmit({ prompt: 'fix the failing test on the api endpoint' } as never)
    expect(r.additionalContext).toEqual(['other hook context'])
  })

  test('leaves routing to the shell router where its classic hooks do not run (managed orgs)', async ($, on) => {
    world(on)
    // No classic SessionStart: an organization policy passes those events over this plugin.
    const r = await submit($, 'fix the failing test on the api endpoint')
    expect(r.context).toBeUndefined()
  })

  test('keeps the shell directive for a prompt it did not handle', async ($, on) => {
    world(on, { shellContext: ['[Maxim Default-On Router · ADR-021] This is a CTO-office task'] })
    await start($ as never)
    const r = await $.classic.UserPromptSubmit({ prompt: 'x' } as never)
    expect(r.additionalContext).toEqual(['[Maxim Default-On Router · ADR-021] This is a CTO-office task'])
  })

  test('respects the project router-off file and drops the shell directive too', async ($, on) => {
    world(on, {
      stats: { 'C:/work/app/.mxm-skills/router-off': { kind: 'file' } },
      shellContext: ['[Maxim Default-On Router · ADR-021] This is a CTO-office task'],
    })
    await start($ as never)
    expect((await submit($, 'fix the failing test on the api endpoint')).context).toBeUndefined()
    const r = await $.classic.UserPromptSubmit({ prompt: 'fix the failing test on the api endpoint' } as never)
    expect(r.additionalContext).toEqual([])
  })
})

describe('guards', () => {
  test('refuses a write through a .mxm-system junction and names the real target', async ($, on) => {
    world(on, {
      stats: {
        'C:/work/app': { kind: 'dir', realPath: 'C:/work/app' },
        'C:/work/app/.mxm-system': { kind: 'dir', realPath: 'E:/Projects/Maxim/plugin-repo' },
      },
    })
    const why = refusal(await $.tool.call({ tool: 'Write', file_path: 'C:/work/app/.mxm-system/CLAUDE.md', content: 'x' } as never))
    expect(why).toContain('junction guard')
    expect(why).toContain('E:/Projects/Maxim/plugin-repo/CLAUDE.md')
    expect(await report($ as never)).toContain('1 junction write(s) refused')
  })

  test('allows a write into a real .claude folder', async ($, on) => {
    world(on, {
      stats: {
        'C:/work/app': { kind: 'dir', realPath: 'C:/work/app' },
        'C:/work/app/.claude': { kind: 'dir', realPath: 'C:/work/app/.claude' },
      },
    })
    const r = await $.tool.call({ tool: 'Edit', file_path: 'C:/work/app/.claude/skills/x/SKILL.md', old_string: 'a', new_string: 'b' } as never)
    expect(refusal(r)).toBeUndefined()
  })

  test('allows a .claude write when only a higher folder is a link', async ($, on) => {
    world(on, {
      stats: {
        'C:/work/app': { kind: 'dir', realPath: 'D:/work/app' },
        'C:/work/app/.claude': { kind: 'dir', realPath: 'D:/work/app/.claude' },
      },
    })
    const r = await $.tool.call({ tool: 'Write', file_path: 'C:/work/app/.claude/notes.md', content: 'x' } as never)
    expect(refusal(r)).toBeUndefined()
  })

  test("allows writes into the user's own ~/.claude even when it is a dotfiles symlink", async ($, on) => {
    world(on, {
      env: { USERPROFILE: 'C:/Users/u' },
      stats: {
        'C:/Users/u': { kind: 'dir', realPath: 'C:/Users/u' },
        'C:/Users/u/.claude': { kind: 'dir', realPath: 'D:/dotfiles/claude' },
      },
    })
    const r = await $.tool.call({ tool: 'Write', file_path: 'C:/Users/u/.claude/projects/x/memory/a.md', content: 'x' } as never)
    expect(refusal(r)).toBeUndefined()
  })

  test('scans in the Windows directory a Git Bash `cd /c/...` names', async ($, on) => {
    const seen = world(on, { diff: '+++ b/readme.md\n+hello\n' })
    await $.tool.call({ tool: 'Bash', command: 'cd /c/work/other && git commit -m ok' } as never)
    expect(seen.cwds).toEqual(['C:/work/other'])
  })

  test('refuses a commit it cannot scan rather than letting it through', async ($, on) => {
    world(on, { isProcessBroken: true })
    const why = refusal(await $.tool.call({ tool: 'Bash', command: 'git commit -m x' } as never))
    expect(why).toContain('could not scan this commit')
  })

  test('does not treat git commit-tree as a commit', async ($, on) => {
    const seen = world(on)
    await $.tool.call({ tool: 'Bash', command: 'git commit-tree abc123 -m x' } as never)
    expect(seen.runs.length).toBe(0)
  })

  test('refuses a commit whose staged diff adds a secret, without echoing it', async ($, on) => {
    const key = 'AKIA' + 'ABCDEFGHIJKLMNOP'
    world(on, { diff: `diff --git a/app.env b/app.env\n+++ b/app.env\n+AWS_KEY=${key}\n` })
    const why = refusal(await $.tool.call({ tool: 'Bash', command: 'git commit -m "add config"' } as never))
    expect(why).toContain('app.env (AWS access key)')
    expect(why).not.toContain(key)
  })

  test('scans unstaged changes when the command also stages them', async ($, on) => {
    const seen = world(on, { unstagedDiff: `+++ b/k.pem\n+${PEM_RSA}\n` })
    const why = refusal(await $.tool.call({ tool: 'Bash', command: 'git add . && git commit -m wip' } as never))
    expect(why).toContain('k.pem (Private key)')
    expect(seen.runs.length).toBe(2)
  })

  test('lets a clean commit and other commands through', async ($, on) => {
    const seen = world(on, { diff: '+++ b/readme.md\n+hello\n' })
    expect(refusal(await $.tool.call({ tool: 'Bash', command: 'git commit -m ok' } as never))).toBeUndefined()
    expect(refusal(await $.tool.call({ tool: 'Bash', command: 'echo "git commit later"' } as never))).toBeUndefined()
    expect(seen.runs.length).toBe(1)
  })

  test('adds the CSO note once when a security-sensitive file is edited', async ($, on) => {
    const seen = world(on)
    const first = await $.tool.call({ tool: 'Write', file_path: 'src/auth/session.ts', content: 'x' } as never)
    expect(first.context?.join(' ')).toContain('Maxim CSO auto-loop')
    expect(seen.toasts.some(t => t.includes('security-sensitive'))).toBe(true)
    const again = await $.tool.call({ tool: 'Write', file_path: 'src/auth/session.ts', content: 'y' } as never)
    expect(again.context ?? []).toEqual([])
  })

  test('does not flag design tokens or session-memory notes', async ($, on) => {
    world(on)
    const tokens = await $.tool.call({ tool: 'Write', file_path: 'src/styles/design-tokens.ts', content: 'x' } as never)
    const notes = await $.tool.call({ tool: 'Write', file_path: '.claude-sessions-memory/auth-notes.json', content: 'x' } as never)
    expect(tokens.context ?? []).toEqual([])
    expect(notes.context ?? []).toEqual([])
  })

  test('guards stay off when the user turns them off', { options: { guards: false } }, async ($, on) => {
    world(on, { diff: `+++ b/a\n+${PEM_PLAIN}\n` })
    expect(refusal(await $.tool.call({ tool: 'Bash', command: 'git commit -m x' } as never))).toBeUndefined()
  })
})

describe('confidence tags and /maxim', () => {
  test('counts an untagged substantive answer and says so', async ($, on) => {
    const seen = world(on)
    on('turn.complete', ($, e) => ({ text: e.answer }))
    const long = 'A substantive answer. '.repeat(30)
    await $.turn.complete({ answer: long, durationMs: 1, isAborted: false, turnId: 't1', reason: 'answer' })
    await $.turn.complete({ answer: `${long}\n\n\u{1F7E2} HIGH`, durationMs: 1, isAborted: false, turnId: 't2', reason: 'answer' })
    await $.turn.complete({ answer: 'short', durationMs: 1, isAborted: false, turnId: 't3', reason: 'answer' })
    expect(await report($ as never)).toContain('1 tagged, 1 untagged')
    expect(seen.toasts.some(t => t.includes('no confidence tag'))).toBe(true)
  })

  test('/maxim reports what the runtime saw', async ($, on) => {
    world(on)
    await start($ as never)
    await submit($, 'fix the failing test on the api endpoint')
    const text = await report($ as never)
    expect(text).toContain('Maxim plugin: 9.9.9')
    expect(text).toContain('last route: CTO · build (keywords)')
  })
})

describe('framework tool', () => {
  test('answers a framework by name from the definition files', async ($, on) => {
    world(on)
    const r = await $.tool.call({ tool: 'mcp__maxim-runtime__framework', name: 'Prospect Theory' } as never)
    // The engine accepts a plugin tool's result only as text (or content blocks),
    // never an MCP { content } envelope: v1.3.11 shipped that and the live call failed.
    expect(typeof r.result).toBe('string')
    expect(String(r.result)).toContain('Losses weigh about twice as much as gains')
    expect(String(r.result)).not.toContain('Copyright')
  })

  test('says so when nothing matches', async ($, on) => {
    world(on)
    const r = await $.tool.call({ tool: 'mcp__maxim-runtime__framework', name: 'zzz unknown' } as never)
    expect(typeof r.result).toBe('string')
    expect(String(r.result)).toContain('No Maxim framework matches')
  })
})
