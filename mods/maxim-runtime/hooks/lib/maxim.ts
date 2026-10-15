// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// Finds the maxim plugin this runtime serves and reads its files, so the routing
// table, the operating standard and the framework definitions have one source.
// Functions that take `$` are function declarations: the engine traces `$`
// through them when it reads the module.

import type { EngineInterface } from 'claude-code'

import { compareVersions, join, parent } from './paths.ts'
import type { RoutingTable } from './router.ts'

export type MaximHome = { root: string; version: string | null }

type Manifest = { name?: string; version?: string }

async function readJson($: EngineInterface, path: string): Promise<unknown> {
  try {
    return JSON.parse(String(await $.fs.read(path)))
  } catch {
    return undefined
  }
}

async function manifestOf($: EngineInterface, dir: string): Promise<Manifest | undefined> {
  const m = await readJson($, join(dir, '.claude-plugin', 'plugin.json'))
  return m && typeof m === 'object' ? (m as Manifest) : undefined
}

// Two layouts: the source repository (mods/maxim-runtime inside the maxim repo, or a
// folder marketplace), and the install cache (<marketplace>/maxim-runtime/<version>
// beside <marketplace>/maxim/<version>), where the newest installed maxim wins.
export async function findMaxim($: EngineInterface, ownRoot: string): Promise<MaximHome | null> {
  const repo = parent(parent(ownRoot))
  const inRepo = await manifestOf($, repo)
  if (inRepo?.name === 'maxim') return { root: repo, version: inRepo.version ?? null }

  const base = join(repo, 'maxim')
  let names: string[] = []
  try {
    names = (await $.fs.list(base)).filter(x => x.kind === 'dir').map(x => x.name)
  } catch {
    return null
  }
  for (const v of names.sort(compareVersions).reverse()) {
    const dir = join(base, v)
    const m = await manifestOf($, dir)
    if (m?.name === 'maxim') return { root: dir, version: m.version ?? v }
  }
  return null
}

export async function loadRoutingTable($: EngineInterface, home: MaximHome): Promise<RoutingTable | null> {
  const t = await readJson($, join(home.root, 'config', 'routing-table.json'))
  if (!t || typeof t !== 'object' || !Array.isArray((t as RoutingTable).routes)) return null
  return t as RoutingTable
}

export const STANDARD_HEADING = '# Maxim is active in this session'

export async function loadStandard($: EngineInterface, home: MaximHome): Promise<string | null> {
  try {
    const text = String(await $.fs.read(join(home.root, 'distributions', 'claude-plugin', 'session-context.md')))
    return text.startsWith(STANDARD_HEADING) ? text.trim() : null
  } catch {
    return null
  }
}

// The session-start hook's context is the standard followed by "## This session".
// With the standard in the system prompt, keep only the per-session summary.
export function sessionSummaryOnly(context: string): string | null {
  if (!context.startsWith(STANDARD_HEADING)) return context
  const i = context.indexOf('\n## This session')
  return i === -1 ? null : context.slice(i + 1).trim()
}

function normalizeName(s: string): string {
  return s.toLowerCase().replace(/[^a-z0-9]+/g, '')
}

async function readDefinition($: EngineInterface, dir: string, slug: string): Promise<{ slug: string; text: string } | null> {
  try {
    return { slug, text: String(await $.fs.read(join(dir, slug, 'SKILL.md'))) }
  } catch {
    return null
  }
}

// Finds a framework definition by slug, by its frontmatter name, or by a fragment of either.
export async function findFramework(
  $: EngineInterface,
  home: MaximHome,
  query: string,
): Promise<{ slug: string; text: string } | null> {
  const dir = join(home.root, 'composable-skills', 'frameworks')
  const want = normalizeName(query)
  if (want.length < 3) return null
  let slugs: string[] = []
  try {
    slugs = (await $.fs.list(dir)).filter(x => x.kind === 'dir').map(x => x.name)
  } catch {
    return null
  }
  const exact = slugs.find(s => normalizeName(s) === want)
  if (exact) return readDefinition($, dir, exact)
  for (const slug of slugs) {
    const def = await readDefinition($, dir, slug)
    if (!def) continue
    const name = normalizeName(/^name:\s*(.+)$/m.exec(def.text)?.[1] ?? '')
    if (name === want || name.startsWith(want)) return def
  }
  const partial = slugs.find(s => normalizeName(s).includes(want))
  return partial ? readDefinition($, dir, partial) : null
}

// A definition without its frontmatter and copyright footer: what the model needs.
export function definitionBody(text: string): string {
  return text
    .replace(/^---[\s\S]*?\n---\s*\n/, '')
    .replace(/\n---\s*\n_Copyright[\s\S]*$/, '')
    .replace(/\n---\s*\n<sub>Copyright[\s\S]*$/, '')
    .trim()
}
