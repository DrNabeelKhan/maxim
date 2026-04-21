# mxm-portfolio

Portfolio metrics, project state, and cross-project synchronization MCP server for Maxim.

## Tools

| Tool | Purpose |
|---|---|
| `get_portfolio_overview` | Founder, company, project count, compliance summary, core platform |
| `get_project_registry` | Full project tree with Maxim versions across portfolio |
| `get_portfolio_metrics` | Status matrix, compliance coverage, health metrics |
| `get_investor_profile` | Investment stage, revenue model, key differentiators |
| `get_tasks` | Filtered task list (by priority P1/P2/P3 and/or project) |
| `update_task` | Update status of a task in `TASKS.md` by task number |
| `sync_portfolio` | Scan all projects, update `.mxm-global/` from manifest data (skips archived, flags gated) |

## Data Source

Reads from `${MXM_PROJECTS_ROOT}/.mxm-global/` (default `E:/Projects/.mxm-global/`).
`sync_portfolio` writes back to the same location after scanning each project's `config/project-manifest.json`.

## Run

```bash
node ./mcp/mxm-portfolio/server.js
```

Auto-discovered via root `.mcp.json` when opening the repo in any Claude surface.

## Behavior Notes (v1.0.0+)

- `sync_portfolio` **skips** projects with `status.lifecycle: archived` per project-manifest schema
- `sync_portfolio` **flags** projects with `status.gated: true` with 🔐 warning (does not skip)
- `sync_portfolio` **surfaces** projects with `status.lifecycle: needs_update` in sync report
- Daily scheduled task runs `sync_portfolio` at 5:27 AM local — see `templates/scheduled-tasks/mxm-global-sync.json`

## License

Apache 2.0 (see repository root).
