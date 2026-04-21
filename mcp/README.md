# Maxim MCP Servers

> 7 Model Context Protocol servers exposing Maxim Framework intelligence to any Claude surface and compatible AI tools.

**Version:** 1.3.0 | **Maxim:** v1.0.0 | **Servers:** 7 | **Tools:** 55

## What Changed in v1.0.0

**Consolidation** (performance + cohesion — see ADR-002):
- `maxim-dispatch` + `maxim-skills` → **`mxm-catalog`** (9 tools)
- `maxim-design` → absorbed into **`mxm-context`** (4 tools added)
- **3 new tools** added to `mxm-context`: `watch_run`, `watch_report`, `watch_configure`

**Net:** 9 servers → 7, 44 tools → 47. Hard cutover — no alias layer. Tool namespaces changed; see migration table below.

## Quick Start

```bash
# Install all servers
cd mcp && for dir in maxim-*/; do (cd "$dir" && npm install); done

# Auto-discovery: opening this repo in any MCP-compatible Claude surface
# will register all 7 servers via the root .mcp.json.
```

## Servers

| # | Server | Priority | Tools | Purpose |
|---|---|---|---|---|
| 1 | [`mxm-portfolio`](mxm-portfolio/README.md) | P1 | 7 | Cross-project portfolio context + sync_portfolio |
| 2 | [`mxm-context`](mxm-context/README.md) | P1 | **13** | Per-project intelligence + design refs (absorbed) + drift detection (new) |
| 3 | [`mxm-catalog`](mxm-catalog/README.md) | P2 | **9** | Agent routing + skill / command catalog (merged dispatch + skills) |
| 4 | [`mxm-compliance`](mxm-compliance/README.md) | P2 | 5 | Compliance checking (14 frameworks) |
| 5 | [`mxm-behavioral`](mxm-behavioral/README.md) | P2 | 5 | Behavioral science engine (64 frameworks — added Proactive Watch) |
| 6 | [`mxm-memory`](mxm-memory/README.md) | P3 | 4 | Unified memory search across session files |
| 7 | [`mxm-voice`](mxm-voice/README.md) | P3 | 4 | Voice-driven office routing (wraps mbailey/voicemode) |

**Total tools: 47.**

## Migration from v1.0.0 (Breaking Changes)

Tool namespace cutover — update any external consumers accordingly:

| v1.0.0 Tool | v1.0.0 Tool |
|---|---|
| `mcp__maxim-dispatch__route_task` | `mcp__mxm-catalog__route_task` |
| `mcp__maxim-dispatch__list_agents` | `mcp__mxm-catalog__list_agents` |
| `mcp__maxim-dispatch__get_agent_dna` | `mcp__mxm-catalog__get_agent_dna` |
| `mcp__maxim-dispatch__list_offices` | `mcp__mxm-catalog__list_offices` |
| `mcp__maxim-dispatch__get_handoff_chain` | `mcp__mxm-catalog__get_handoff_chain` |
| `mcp__maxim-skills__list_skills` | `mcp__mxm-catalog__list_skills` |
| `mcp__maxim-skills__search_skills` | `mcp__mxm-catalog__search_skills` |
| `mcp__maxim-skills__get_skill_detail` | `mcp__mxm-catalog__get_skill_detail` |
| `mcp__maxim-skills__list_commands` | `mcp__mxm-catalog__list_commands` |
| `mcp__maxim-design__get_brand_design` | `mcp__mxm-context__get_brand_design` |
| `mcp__maxim-design__list_brands` | `mcp__mxm-context__list_brands` |
| `mcp__maxim-design__get_design_template` | `mcp__mxm-context__get_design_template` |
| `mcp__maxim-design__get_design_reference` | `mcp__mxm-context__get_design_reference` |

### New in v1.0.0

- `mcp__mxm-context__watch_run` — run Proactive Watch drift detection
- `mcp__mxm-context__watch_report` — read the JSONL drift report
- `mcp__mxm-context__watch_configure` — read a project's watch profile

## Auto-Discovery (Preferred)

The repo-root [`.mcp.json`](../.mcp.json) declares all 7 servers. Any MCP-compatible client (Claude Code, Claude Desktop, Cursor, Windsurf, Cowork) auto-registers them when opening the repo.

## Manual Configuration — Claude Desktop

If you need to add servers manually, append to `%APPDATA%/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "mxm-portfolio": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/mxm-portfolio/server.js"],
      "env": { "MXM_PROJECTS_ROOT": "E:/Projects" }
    },
    "mxm-context": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/mxm-context/server.js"]
    },
    "mxm-compliance": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/mxm-compliance/server.js"],
      "env": { "MXM_ROOT": "E:/Projects/Maxim/maxim" }
    },
    "mxm-behavioral": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/mxm-behavioral/server.js"],
      "env": { "MXM_ROOT": "E:/Projects/Maxim/maxim" }
    },
    "maxim-dispatch": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/maxim-dispatch/server.js"],
      "env": { "MXM_ROOT": "E:/Projects/Maxim/maxim" }
    },
    "mxm-memory": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/mxm-memory/server.js"]
    },
    "maxim-skills": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/maxim-skills/server.js"],
      "env": { "MXM_ROOT": "E:/Projects/Maxim/maxim" }
    },
    "maxim-design": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/maxim-design/server.js"],
      "env": { "MXM_ROOT": "E:/Projects/Maxim/maxim" }
    },
    "mxm-voice": {
      "command": "node",
      "args": ["E:/Projects/Maxim/maxim/mcp/mxm-voice/server.js"],
      "env": { "VOICEMODE_REQUIRED": "false" }
    }
  }
}
```

## Environment Variables

| Variable | Default | Used By |
|---|---|---|
| `MXM_PROJECTS_ROOT` | `E:/Projects` | portfolio |
| `MXM_ROOT` | `E:/Projects/Maxim/maxim` | compliance, behavioral, dispatch, skills, design |
| `VOICEMODE_REQUIRED` | `false` | voice (graceful degradation if voicemode not installed) |
| `VOICEMODE_SAVE_AUDIO` | `false` | voice (whether to retain audio recordings) |

See repo-root [`.env.example`](../.env.example) for the full env var template.

## Per-Server Documentation

Each server has its own `README.md` with the tool list, data sources, and run instructions. Click a server name in the table above.

## Architecture

- Node.js 18+ with `@modelcontextprotocol/sdk` ^1.29.0
- Each server reads from local filesystem only (no database, no network) — except voice which delegates to mbailey/voicemode
- Markdown parsing via regex (no heavy dependencies)
- YAML frontmatter parsing for skill metadata
- All tools are read-only except `update_task` (portfolio), `store_memory` (memory), and voice tools

## License

Apache 2.0 (see repository root). Brand templates retain original licenses (typically Apache 2.0/MIT per VoltAgent's distribution).
