// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// The values maxim-runtime keeps in $.state for this session.

export type RouteSource = 'keywords' | 'model'

export type RouteRecord = {
  id: string
  office: string
  source: RouteSource
}

export type RuntimeStatus = {
  maximRoot: string | null
  maximVersion: string | null
  standardActive: boolean
  routerMode: string
  lastRoute: RouteRecord | null
  routeCounts: Record<string, number>
  junctionBlocks: number
  secretBlocks: number
  csoFlags: string[]
  tagged: number
  untagged: number
}

declare module 'claude-code' {
  interface PluginState {
    'maxim-runtime': { status: RuntimeStatus }
  }
}
