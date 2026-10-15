// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// The keyword router of ADR-021, ported from .claude/hooks/user-prompt-router.sh
// so a mod session classifies exactly as the shell router does, then shows the
// result in the status line instead of asking the model to print a banner.

export type Route = {
  id: string
  keywords: string[]
  office: string
  skills: string[]
  frameworks: string[]
}

export type RoutingTable = {
  enabled?: boolean
  weak_keywords?: string[]
  confidence_floor?: number
  confidence_margin?: number
  long_prompt_chars?: number
  routes: Route[]
}

export type Verdict =
  | { kind: 'route'; route: Route }
  | { kind: 'unsure'; text: string } // worth asking a model: real intent, no confident keyword route
  | { kind: 'skip' } // not intent: empty, a /mxm-* command, a structural lead, or a pasted document

const escapeRegex = (s: string): string => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')

// Word-boundary match allowing a simple plural, as the shell router does.
export const keywordHit = (keyword: string, text: string): boolean =>
  new RegExp('\\b' + escapeRegex(keyword.toLowerCase()) + '(?:s|es)?\\b').test(text)

// Fenced code, tagged blocks and blockquotes are pasted or quoted content, not intent.
export const stripNoise = (t: string): string =>
  t
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/~~~[\s\S]*?~~~/g, ' ')
    .replace(/<([a-zA-Z][\w-]*)\b[^>]*>[\s\S]*?<\/\1>/g, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/^\s*>.*$/gm, ' ')

export const classify = (prompt: string, table: RoutingTable): Verdict => {
  const text = prompt.trim()
  if (!text) return { kind: 'skip' }
  const low = text.toLowerCase()
  if (/\/mxm-[a-z][a-z-]*/.test(low)) return { kind: 'skip' }
  const lead = low.trimStart()
  if (lead.startsWith('<') || lead.startsWith('```') || lead.startsWith('~~~') || lead.startsWith('>')) {
    return { kind: 'skip' }
  }
  const body = stripNoise(low)
  if (!body.trim()) return { kind: 'skip' }

  const weak = new Set((table.weak_keywords ?? []).map(w => w.toLowerCase()))
  const floor = table.confidence_floor ?? 2
  const margin = table.confidence_margin ?? 1
  const longChars = table.long_prompt_chars ?? 1200
  const zone = body.slice(0, 160)

  let best: Route | undefined
  let bestScore = 0
  let bestZone = 0
  let secondScore = 0
  for (const route of table.routes) {
    const matched = route.keywords.filter(k => keywordHit(k, body))
    const strong = matched.filter(k => !weak.has(k.toLowerCase()))
    if (matched.length === 0 || (strong.length === 0 && matched.length < 2)) continue
    const zoneBonus = strong.some(k => keywordHit(k, zone)) ? 1 : 0
    const score = strong.length + zoneBonus
    if (score > bestScore) {
      secondScore = bestScore
      best = route
      bestScore = score
      bestZone = zoneBonus
    } else if (score > secondScore) {
      secondScore = score
    }
  }

  const isLongPaste = text.length > longChars && bestZone === 0
  if (best && bestScore >= floor && bestScore - secondScore >= margin && !isLongPaste) {
    return { kind: 'route', route: best }
  }
  // A long paste with no instruction-zone signal is a document, not a request.
  if (text.length > longChars) return { kind: 'skip' }
  // Too short to carry intent ("yes", "go", "thanks") is a reply, not a task.
  if (body.trim().length < 20) return { kind: 'skip' }
  return { kind: 'unsure', text: body.trim().slice(0, 2000) }
}

// What the model reads beside the prompt. No banner request: the status line shows
// the route, so the model spends no tokens echoing it.
export const directive = (route: Route): string =>
  `[Maxim router · ADR-021] This is a ${route.office}-office task (${route.id}). ` +
  `Use Maxim skills: ${route.skills.join(', ')}. ` +
  `Apply frameworks: ${route.frameworks.join(', ')}; cite each framework you actually use (ADR-007) ` +
  `and end with a confidence tag (ADR-010). The route is shown to the user in the status line; do not print a routing banner.`

export const statusLine = (route: Route, source: 'keywords' | 'model'): string =>
  `Maxim · ${route.office} · ${route.id}${source === 'model' ? ' (model)' : ''}`
