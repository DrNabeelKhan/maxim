# /mxm-context

Generates a portable Maxim context block for use in Claude.ai, Claude Desktop, or Claude Dispatch. Reads your project's manifest, CLAUDE.project.md, and session memory to produce a single paste-ready text block.

## Usage
- Claude Code: `/mxm-context`
- Claude CLI: `claude "/mxm-context"`

## Behavior

1. Read config/project-manifest.json
2. Read CLAUDE.project.md
3. Read .claude-sessions-memory/MEMORY.md (if exists)
4. Read .claude-sessions-memory/project_current_state.md (if exists)
5. Read .claude-sessions-memory/handoff.md (if exists)
6. Read .mxm-executive-summary/CONTEXT.md (if exists)

Generate a single markdown block containing:

```
# Maxim Context — [project.name]
Generated: [today's date] | Maxim v1.0.0

## Project Identity
[from project-manifest.json: name, vertical, stage, description]

## Compliance Scope
[from manifest: frameworks, regulated/payment/hipaa flags]

## Tech Stack
[from manifest: frontend, backend, infrastructure]

## Brand Voice
[from CLAUDE.project.md: tone, audience, core message]

## Current State
[from project_current_state.md if exists, or "No session memory yet"]

## Open Tasks
[from handoff.md if exists]

## Maxim Behavioral Rules
- Apply Fogg Behavior Model on all recommendations
- Apply COM-B on team/customer analysis
- Apply EAST on all action items (Easy, Attractive, Social, Timely)
- Tag confidence: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW
- Route security/compliance signals to CSO auto-loop

## How to Use This Context
Paste this entire block at the start of any Claude.ai or Claude Desktop session.
It gives Claude your project identity, compliance scope, tech stack, and current state.
```

Output: "Context block generated. Copy everything above and paste into Claude.ai or Claude Desktop."

### Tag output: 🟢 HIGH
