// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// Path helpers that work on both Windows and POSIX spellings. The hooks
// environment has no Node `path`, so these are plain string operations.

export const toSlash = (p: string): string => p.replace(/\\/g, '/')

export const isWindowsPath = (p: string): boolean => /^[a-zA-Z]:\//.test(toSlash(p))

// Git Bash and Cygwin spell drive paths /e/... and /cygdrive/e/...; a Windows process
// cannot start in those, so convert them to E:/... when the session is on Windows.
export const fromMsys = (p: string): string => {
  const s = toSlash(p)
  const m = /^\/(?:cygdrive\/)?([a-zA-Z])(?:\/|$)/.exec(s)
  return m ? `${(m[1] ?? '').toUpperCase()}:/${s.slice(m[0].length)}` : s
}

// Folds `.` and `..`, collapses repeated separators and drops a trailing one.
export const normalize = (p: string): string => {
  const s = toSlash(p)
  const lead = s.startsWith('//') ? '//' : s.startsWith('/') ? '/' : ''
  const out: string[] = []
  for (const part of s.slice(lead.length).split('/')) {
    if (part === '' || part === '.') continue
    if (part === '..' && out.length > 0 && out[out.length - 1] !== '..') out.pop()
    else out.push(part)
  }
  return lead + out.join('/')
}

export const join = (...parts: string[]): string => normalize(parts.join('/'))

export const parent = (p: string): string => {
  const n = normalize(p)
  const i = n.lastIndexOf('/')
  if (i <= 0) return n.startsWith('/') ? '/' : n
  const up = n.slice(0, i)
  return /^[a-zA-Z]:$/.test(up) ? up + '/' : up
}

export const basename = (p: string): string => {
  const n = normalize(p)
  return n.slice(n.lastIndexOf('/') + 1)
}

export const isAbsolute = (p: string): boolean => {
  const s = toSlash(p)
  return s.startsWith('/') || isWindowsPath(s)
}

// Two spellings of one place: Windows paths compare case-insensitively.
export const samePath = (a: string, b: string): boolean => {
  const x = normalize(a)
  const y = normalize(b)
  return isWindowsPath(x) || isWindowsPath(y) ? x.toLowerCase() === y.toLowerCase() : x === y
}

export const segments = (p: string): string[] => normalize(p).split('/').filter(Boolean)

// Compares dotted versions numerically ("1.3.10" > "1.3.9"); non-numeric parts sort last.
export const compareVersions = (a: string, b: string): number => {
  const pa = a.split('.')
  const pb = b.split('.')
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const x = Number(pa[i] ?? 0)
    const y = Number(pb[i] ?? 0)
    if (Number.isNaN(x) || Number.isNaN(y)) {
      const c = String(pa[i] ?? '').localeCompare(String(pb[i] ?? ''))
      if (c !== 0) return c
    } else if (x !== y) return x - y
  }
  return 0
}
