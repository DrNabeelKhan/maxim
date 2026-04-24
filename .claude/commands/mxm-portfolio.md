---
description: Portfolio view across projects — reads config/project-manifest.json from every registered project, surfaces cross-project drift and priorities.
---

# /mxm-portfolio

## Usage
- Claude Code: `/mxm-portfolio`
- Claude CLI: `claude "/mxm-portfolio"`
- Claude Desktop: type `/mxm-portfolio` in chat

Displays the full project portfolio status. Reads all project manifests and .mxm-global/ to produce a cross-project dashboard.

## Behavior

1. Read `.mxm-global/GLOBAL-CONTEXT.md` (if exists)
2. Read `.mxm-global/PORTFOLIO-METRICS.md` (if exists)
3. Read `.mxm-global/TASKS.md` (if exists)
4. For each project in portfolio:
   - Read `config/project-manifest.json` (if accessible)
   - Read `.mxm-executive-summary/CONTEXT.md` (if exists)
   - Report: name, status, MRR, top priority, compliance scope
5. Output portfolio dashboard table
6. Highlight cross-project patterns and shared resources
7. Flag stale projects (no commit in 30+ days)
8. Suggest resource reallocation based on portfolio health

### Tag output: 🟢 HIGH
