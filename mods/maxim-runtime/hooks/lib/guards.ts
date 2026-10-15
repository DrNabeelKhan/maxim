// Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.
// Pure checks behind the runtime's guards. The $-calling side lives in register.tsx.

import { basename, normalize, segments, toSlash } from './paths.ts'

// High-confidence secret patterns, ported from .claude/hooks/pre-commit.sh.
export const SECRET_PATTERNS: ReadonlyArray<{ name: string; re: RegExp }> = [
  { name: 'AWS access key', re: /AKIA[0-9A-Z]{16}/ },
  { name: 'AWS secret key', re: /aws_secret_access_key\s*=\s*["'][A-Za-z0-9/+=]{40}["']/ },
  { name: 'Anthropic API key', re: /sk-ant-[a-zA-Z0-9_-]{32,}/ },
  { name: 'OpenAI or Stripe-style secret key', re: /sk-[a-zA-Z0-9]{32,}/ },
  { name: 'Stripe live key', re: /\b(?:sk|rk)_live_[A-Za-z0-9]{16,}/ },
  { name: 'GitHub token', re: /\bgh[pousr]_[A-Za-z0-9]{36}/ },
  { name: 'GitLab token', re: /glpat-[A-Za-z0-9_-]{20}/ },
  { name: 'Private key', re: /-----BEGIN (?:RSA |EC |DSA |OPENSSH |)PRIVATE KEY-----/ },
  { name: 'Slack token', re: /xox[baprs]-[A-Za-z0-9-]{10,}/ },
]

export type SecretFinding = { file: string; kind: string }

// Scans a unified diff's added lines. Reports file and pattern, never the match itself.
export const scanDiff = (diff: string): SecretFinding[] => {
  const findings: SecretFinding[] = []
  const seen = new Set<string>()
  let file = '(unknown file)'
  for (const line of diff.split(/\r?\n/)) {
    if (line.startsWith('+++ ')) {
      file = line.slice(4).replace(/^b\//, '')
      continue
    }
    if (!line.startsWith('+') || line.startsWith('+++')) continue
    for (const p of SECRET_PATTERNS) {
      if (p.re.test(line)) {
        const key = `${file}\u0000${p.name}`
        if (!seen.has(key)) {
          seen.add(key)
          findings.push({ file, kind: p.name })
        }
      }
    }
  }
  return findings
}

// A Bash command that makes a git commit (not merely mentions one in a message).
export const isGitCommit = (command: string): boolean =>
  /(^|[;&|(]\s*|\s)git(\s+-[cC]\s+\S+)*\s+commit(?![-\w])/.test(command) && !/\bcommit\b[^;&|]*--dry-run/.test(command)

// Whether the commit also takes changes not yet staged (git add in the same line, or -a/--all).
export const commitsUnstaged = (command: string): boolean =>
  /\bgit\s+add\b/.test(command) || /\bcommit\b[^;&|]*\s(-[a-zA-Z]*a[a-zA-Z]*|--all)\b/.test(command)

// Words that mark security-sensitive code. Deliberately not bare "token" (design tokens)
// or "session" (session-memory folders): auth and secret words cover those cases.
const SENSITIVE =
  /(auth|login|oauth|jwt|api[-_]?key|access[-_]?token|refresh[-_]?token|secret|credential|password|passwd|payment|billing|stripe|checkout|invoice|webhook|encrypt|crypto|kms|\.env|pii|phi|hipaa|gdpr|consent|privacy|license)/i

// Folders whose contents are notes and records, not code: never a CSO trigger.
const NOT_CODE = /^\.(claude-sessions-memory|mxm-skills|mxm-global|mxm-operator-profile)$/i

// A file whose edit should get the CSO perspective (CLAUDE.md auto-escalation rule 1).
export const isSecuritySensitive = (filePath: string): boolean => {
  const name = basename(filePath)
  if (/\.(md|txt|lock|svg|png|jpe?g|gif)$/i.test(name)) return false
  if (segments(filePath).some(s => NOT_CODE.test(s))) return false
  return SENSITIVE.test(name) || segments(filePath).slice(-3, -1).some(s => SENSITIVE.test(s))
}

// Folders Maxim links as read-only junctions (CLAUDE.md: never write through them).
const JUNCTION_NAMES = new Set(['.mxm-system', '.claude'])

export const touchesJunctionName = (filePath: string): boolean =>
  segments(filePath).some(s => JUNCTION_NAMES.has(s.toLowerCase()))

// The folders along a path that carry a junction-prone name, deepest last, each with
// the part of the path below it: where a link would make a write read-only-violating.
export const junctionCandidates = (absPath: string): { dir: string; rest: string[] }[] => {
  const segs = segments(absPath)
  const lead = toSlash(absPath).startsWith('/') ? '/' : ''
  const out: { dir: string; rest: string[] }[] = []
  segs.forEach((seg, i) => {
    if (JUNCTION_NAMES.has(seg.toLowerCase())) out.push({ dir: lead + segs.slice(0, i + 1).join('/'), rest: segs.slice(i + 1) })
  })
  return out
}

export const csoNote = (filePath: string): string =>
  `[Maxim CSO auto-loop] ${normalize(filePath)} looks security-sensitive (auth, payments, secrets, PII or licensing). ` +
  `Before finishing, review this change from the CSO perspective: secrets kept out of code and logs, ` +
  `least privilege, input validation, and any compliance obligations. Say what you checked.`
