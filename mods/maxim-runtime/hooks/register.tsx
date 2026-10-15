// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
//
// maxim-runtime: Maxim's in-engine runtime for Claude Code function hooks.
// It runs beside the maxim plugin's shell hooks and takes over the parts that
// work better inside the engine:
//
//   standard   the operating standard joins the system prompt (prompt.compose)
//              instead of a session-start message, and the shell copy is trimmed
//   router     ADR-021's keyword router, plus a small-model classifier only when
//              the keywords are unsure; the route shows in the status line, so the
//              model no longer prints a banner, and the shell router's directive
//              is dropped while this one is active
//   guards     writes through .mxm-system/.claude junctions are refused, a git
//              commit whose diff carries a secret is refused, and an edit to a
//              security-sensitive file brings the CSO review note
//   tags       a substantive answer with no confidence tag is flagged
//   /maxim     a pane with what the runtime did this session
//   framework  an in-process framework lookup that works without the MCP servers
//
// On a Claude Code without function hooks none of this loads and the shell
// hooks behave exactly as before.

import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { RouteSource, RuntimeStatus } from '../types'
import {
  commitsUnstaged,
  csoNote,
  isGitCommit,
  isSecuritySensitive,
  junctionCandidates,
  scanDiff,
  touchesJunctionName,
} from './lib/guards.ts'
import {
  definitionBody,
  findFramework,
  findMaxim,
  loadRoutingTable,
  loadStandard,
  sessionSummaryOnly,
} from './lib/maxim.ts'
import type { MaximHome } from './lib/maxim.ts'
import { basename, fromMsys, isAbsolute, isWindowsPath, join, normalize, parent, samePath } from './lib/paths.ts'
import { classify, directive, statusLine } from './lib/router.ts'
import type { Route, RoutingTable } from './lib/router.ts'

const PANE = 'maxim'
const TOOL = 'mcp__maxim-runtime__framework'
const SHELL_ROUTER_PREFIX = '[Maxim Default-On Router'
const TAG = /[\u{1F7E2}\u{1F7E1}\u{1F534}\u{1F535}\u{1F510}]/u
const SUBSTANTIVE_CHARS = 400

const INITIAL: RuntimeStatus = {
  maximRoot: null,
  maximVersion: null,
  standardActive: false,
  routerMode: 'hybrid',
  lastRoute: null,
  routeCounts: {},
  junctionBlocks: 0,
  secretBlocks: 0,
  csoFlags: [],
  tagged: 0,
  untagged: 0,
}

const status = atom({ plugin: 'maxim-runtime', key: 'status' } as const, INITIAL)

// Module-level caches: a reload of the module starts them over.
let home: Promise<MaximHome | null> | undefined
let table: Promise<RoutingTable | null> | undefined
let standard: Promise<string | null> | undefined

// The router takes over from the shell router only once this module's classic-hook
// filter is known to run: where an organization manages Claude Code those events pass
// over installed plugins, so the runtime leaves routing to the shell router there and
// nothing is sent twice. `handledPrompt` marks the prompt whose shell directive to drop.
let classicSeen = false
let handledPrompt = false

function patch($: EngineInterface, fn: (s: RuntimeStatus) => RuntimeStatus) {
  return update($, status, s => fn(s ?? INITIAL))
}

function getHome($: EngineInterface): Promise<MaximHome | null> {
  home ??= findMaxim($, $.plugin.root)
  return home
}

async function getTable($: EngineInterface): Promise<RoutingTable | null> {
  table ??= getHome($).then(h => (h ? loadRoutingTable($, h) : null))
  return table
}

async function getStandard($: EngineInterface): Promise<string | null> {
  standard ??= getHome($).then(h => (h ? loadStandard($, h) : null))
  return standard
}

// The path a write tool targets: Write and Edit name file_path, NotebookEdit notebook_path.
function targetOf(e: object): string {
  const x = e as { file_path?: unknown; notebook_path?: unknown }
  return String(x.file_path ?? x.notebook_path ?? '')
}

// Whether the write passes through a link sitting at a .mxm-system or .claude folder:
// that folder's real path differs from its parent's real path plus its own name. A link
// higher up (a whole projects folder that is a symlink) is not a junction write.
// Answers the real target, or null.
async function throughLink($: EngineInterface, target: string): Promise<string | null> {
  const abs = isAbsolute(target) ? normalize(target) : join(await $.session.cwd(), target)
  const userHome = await homeDir($)
  for (const { dir, rest } of junctionCandidates(abs)) {
    // The user's own ~/.claude may be a dotfiles symlink; it is not a Maxim junction.
    if (userHome && basename(dir).toLowerCase() === '.claude' && samePath(parent(dir), userHome)) continue
    let real: string | undefined
    let parentReal: string | undefined
    try {
      real = (await $.fs.stat(dir, { resolve: true })).realPath
      parentReal = (await $.fs.stat(parent(dir), { resolve: true })).realPath
    } catch {
      continue // missing: nothing to pass through
    }
    if (real === undefined || parentReal === undefined) continue
    if (!samePath(real, join(parentReal, basename(dir)))) return join(real, ...rest)
  }
  return null
}

// The user's home folder, from the environment; null when it cannot be read.
async function homeDir($: EngineInterface): Promise<string | null> {
  try {
    const h = (await $.env.get('USERPROFILE')) ?? (await $.env.get('HOME'))
    return h ? normalize(h) : null
  } catch {
    return null
  }
}

// The CSO review note for a security-sensitive file, once per file per session.
async function flagCso($: EngineInterface, filePath: string): Promise<string | null> {
  if (!isSecuritySensitive(filePath)) return null
  const key = normalize(filePath)
  const s = (await read($, status)) ?? INITIAL
  if (s.csoFlags.includes(key)) return null
  await patch($, x => ({ ...x, csoFlags: [...x.csoFlags, key].slice(-50) }))
  $.ui.toast(`Maxim CSO: ${basename(key)} is security-sensitive; review requested`)
  return csoNote(key)
}

// The directory a command's git runs in: `git -C <dir>` or the last `cd <dir>` before it.
async function commitDir($: EngineInterface, command: string): Promise<string> {
  const unquote = (s: string) => s.replace(/^["']|["']$/g, '')
  const cwd = await $.session.cwd()
  const gitC = /\bgit\s+-C\s+("[^"]+"|'[^']+'|\S+)/.exec(command)?.[1]
  const cds = [...command.matchAll(/(?:^|&&|;)\s*cd\s+("[^"]+"|'[^']+'|[^\s;&]+)/g)].map(m => m[1] ?? '')
  const dir = gitC ?? cds[cds.length - 1]
  if (!dir) return cwd
  const raw = unquote(dir)
  const d = isWindowsPath(cwd) ? fromMsys(raw) : raw
  return isAbsolute(d) ? normalize(d) : join(cwd, d)
}

// Whether the project opted out of routing with .mxm-skills/router-off.
async function isRouterOff($: EngineInterface): Promise<boolean> {
  try {
    await $.fs.stat(join(await $.session.cwd(), '.mxm-skills', 'router-off'))
    return true
  } catch {
    return false
  }
}

// Asks the small model to pick a route; undefined when it names none or is slow.
async function modelRoute($: EngineInterface, text: string, t: RoutingTable): Promise<Route | undefined> {
  const labels = [...t.routes.map(r => r.id), 'none']
  const answer = await Promise.race([
    $.model.classify(text, labels, { model: 'haiku' }).catch(() => undefined),
    $.clock.sleep(4000).then(() => undefined),
  ])
  return t.routes.find(r => r.id === answer)
}

// Records where Maxim lives and whether the standard loaded; run at session start
// and again by /maxim, so the report is right even when the module loaded mid-session.
async function refreshStatus($: EngineInterface, routerMode: string): Promise<{ home: MaximHome | null; standardFound: boolean }> {
  const h = await getHome($)
  const std = await getStandard($)
  await patch($, s => ({
    ...s,
    maximRoot: h?.root ?? null,
    maximVersion: h?.version ?? null,
    standardActive: std !== null,
    routerMode,
  }))
  return { home: h, standardFound: std !== null }
}

function summary(s: RuntimeStatus): string[] {
  const routes = Object.entries(s.routeCounts)
    .map(([id, n]) => `${id} ${n}`)
    .join(', ')
  return [
    `Maxim plugin: ${s.maximRoot ? `${s.maximVersion ?? '?'} at ${s.maximRoot}` : 'not found'}`,
    `Standard in system prompt: ${s.standardActive ? 'yes' : 'no'}`,
    `Router: ${s.routerMode}; last route: ${s.lastRoute ? `${s.lastRoute.office} · ${s.lastRoute.id} (${s.lastRoute.source})` : 'none'}`,
    `Routes this session: ${routes || 'none'}`,
    `Guards: ${s.junctionBlocks} junction write(s) refused, ${s.secretBlocks} commit(s) with secrets refused`,
    `CSO reviews requested: ${s.csoFlags.length}${s.csoFlags.length ? ` (${s.csoFlags.slice(-3).map(basename).join(', ')})` : ''}`,
    `Confidence tags on substantive answers: ${s.tagged} tagged, ${s.untagged} untagged`,
  ]
}

export const register: Register = (on, options) => {
  const routerMode = String(options.router ?? 'hybrid')
  const guardsOn = options.guards !== false

  // ---------------------------------------------------------------- session
  on('session.start', async ($, e, next) => {
    const { home: h } = await refreshStatus($, routerMode)
    await $.command.register({
      name: 'maxim',
      description: 'Show what the Maxim runtime did this session: route, guards, CSO flags, confidence tags',
    })
    if (h) {
      await $.tool.register({
        name: 'framework',
        description:
          "Look up one of Maxim's framework definitions (purpose, components, use cases, steps, references) by name or slug, " +
          "for example 'Prospect Theory', 'EU AI Act' or 'owasp-top-10'. Reads Maxim's framework files directly, " +
          'so it works even when the mxm-behavioral MCP server is not connected.',
        inputSchema: {
          type: 'object',
          properties: { name: { type: 'string', description: 'Framework name or slug' } },
          required: ['name'],
        },
      })
    } else {
      $.ui.log('maxim-runtime: the maxim plugin was not found beside this runtime; routing and the standard stay with the shell hooks.')
    }
    return next(e)
  })

  // ---------------------------------------------------------------- standard
  on('prompt.compose', async ($, e, next) => {
    classicSeen = true
    const composed = await next(e)
    const std = await getStandard($)
    if (!std) return composed
    return { sections: [...composed.sections, { id: 'maxim-runtime:standard', text: std, scope: 'session' as const }] }
  })

  // The shell session-start hook still sends the standard; it is in the system prompt now.
  on('classic.SessionStart', async ($, e, next) => {
    classicSeen = true
    const r = await next(e)
    if (!r.additionalContext || !(await getStandard($))) return r
    const kept = r.additionalContext.map(sessionSummaryOnly).filter((x): x is string => x !== null && x !== '')
    return { ...r, additionalContext: kept }
  })

  // ---------------------------------------------------------------- router
  // The shell router still runs; for a prompt this runtime handled, its directive is dropped.
  on('classic.UserPromptSubmit', async ($, e, next) => {
    classicSeen = true
    const isHandled = handledPrompt
    handledPrompt = false
    const r = await next(e)
    if (!isHandled || !r.additionalContext) return r
    return { ...r, additionalContext: r.additionalContext.filter(c => !c.startsWith(SHELL_ROUTER_PREFIX)) }
  })

  on('prompt.submit', async ($, e, next) => {
    handledPrompt = false
    // Until this module's classic hooks are seen to run, the shell router keeps routing.
    if (e.command || e.isMeta || !classicSeen) return next(e)
    const t = await getTable($)
    if (!t) return next(e)
    handledPrompt = true // this runtime owns routing for this prompt, route or not
    if (routerMode === 'off' || t.enabled === false || (await isRouterOff($))) {
      $.ui.status(undefined)
      return next(e)
    }

    const verdict = classify(e.text, t)
    let route: Route | undefined
    let source: RouteSource = 'keywords'
    if (verdict.kind === 'route') {
      route = verdict.route
    } else if (verdict.kind === 'unsure' && routerMode === 'hybrid') {
      route = await modelRoute($, verdict.text, t)
      source = 'model'
    }

    if (!route) {
      $.ui.status(undefined)
      return next(e)
    }
    const picked = route
    $.ui.status(statusLine(picked, source))
    await patch($, s => ({
      ...s,
      lastRoute: { id: picked.id, office: picked.office, source },
      routeCounts: { ...s.routeCounts, [picked.id]: (s.routeCounts[picked.id] ?? 0) + 1 },
    }))
    return next({ ...e, context: [...(e.context ?? []), directive(picked)] })
  }).catch(($, e, next) => next(e))

  // ---------------------------------------------------------------- guards
  on('tool.call', { tool: ['Write', 'Edit', 'NotebookEdit'] }, async ($, e, next) => {
    if (!guardsOn) return next(e)
    const filePath = targetOf(e)
    if (filePath && touchesJunctionName(filePath)) {
      const real = await throughLink($, filePath)
      if (real) {
        await patch($, s => ({ ...s, junctionBlocks: s.junctionBlocks + 1 }))
        return {
          deny:
            `Maxim junction guard: ${filePath} passes through a read-only junction to ${real} ` +
            '(CLAUDE.md: never write through .mxm-system or .claude junctions). Session data belongs in this ' +
            "project's own folders (.claude-sessions-memory, .mxm-skills). Edit the junction's target only if it is " +
            'a repository you are meant to change, in that repository.',
        }
      }
    }
    const ran = await next(e)
    if (!filePath || ran.deny !== undefined || ran.isError === true) return ran
    const note = await flagCso($, filePath)
    return note ? { ...ran, context: [...(ran.context ?? []), note] } : ran
  }).catch(($, e, next) => {
    if (next.called) return next(e)
    return touchesJunctionName(targetOf(e))
      ? { deny: 'Maxim junction guard could not check this path, so the write is refused. Edit the real folder, not a .mxm-system or .claude junction.' }
      : next(e)
  })

  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    if (!guardsOn || !isGitCommit(e.command)) return next(e)
    const cwd = await commitDir($, e.command)
    // A scan that cannot run throws, and the .catch below refuses the commit.
    const diffs = [await $.process.run(['git', 'diff', '--cached', '-U0', '--no-color'], { cwd })]
    if (commitsUnstaged(e.command)) diffs.push(await $.process.run(['git', 'diff', '-U0', '--no-color'], { cwd }))
    const findings = diffs.filter(d => d.exitCode === 0).flatMap(d => scanDiff(d.stdout))
    if (findings.length === 0) return next(e)
    await patch($, s => ({ ...s, secretBlocks: s.secretBlocks + 1 }))
    const list = findings.map(f => `${f.file} (${f.kind})`).join('; ')
    return {
      deny:
        `Maxim secret guard: this commit would add a secret: ${list}. Nothing was committed. ` +
        'Move the value to an environment variable or a secret store, unstage it, then commit again.',
    }
  }).catch(($, e, next) => {
    if (next.called) return next(e)
    return isGitCommit(e.command)
      ? {
          deny:
            'Maxim secret guard could not scan this commit, so it was not made. Check the staged changes for secrets ' +
            '(git diff --cached), then commit from a terminal, or turn the maxim-runtime guards setting off in /config.',
        }
      : next(e)
  })

  // ---------------------------------------------------------------- confidence tags
  on('turn.complete', async ($, e, next) => {
    const r = await next(e)
    if (e.agentId !== undefined || e.reason !== 'answer' || e.answer.length < SUBSTANTIVE_CHARS) return r
    const isTagged = TAG.test(e.answer)
    await patch($, s => (isTagged ? { ...s, tagged: s.tagged + 1 } : { ...s, untagged: s.untagged + 1 }))
    if (!isTagged) $.ui.toast('Maxim: that answer has no confidence tag (ADR-010)')
    return r
  })

  // ---------------------------------------------------------------- framework tool
  on('tool.call', { tool: TOOL }, async ($, e) => {
    const query = String(e.name ?? '').trim()
    const h = await getHome($)
    const found = h && query ? await findFramework($, h, query) : null
    const text = found
      ? `# ${found.slug}\n\n${definitionBody(found.text)}`
      : `No Maxim framework matches "${query}". Use a name or slug from composable-skills/frameworks, e.g. "prospect-theory".`
    return { result: { content: [{ type: 'text' as const, text }], isError: !found } }
  })

  // ---------------------------------------------------------------- /maxim
  on('command.run', { command: 'maxim' }, async $ => {
    await refreshStatus($, routerMode)
    const s = (await read($, status)) ?? INITIAL
    await $.ui.open({ id: PANE, title: 'Maxim' })
    return { text: summary(s).join('\n') }
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const s = (await read($, status)) ?? INITIAL
    return (
      <Box flexDirection="column">
        <Text bold>Maxim runtime</Text>
        {summary(s).map(line => (
          <Text>{line}</Text>
        ))}
      </Box>
    )
  })
}
