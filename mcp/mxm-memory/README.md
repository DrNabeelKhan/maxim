# mxm-memory

Cross-session memory persistence MCP server. Reads, writes, and searches session memory across project boundaries.

## Tools

| Tool | Purpose |
|---|---|
| `store_memory` | Store a fact/decision/observation to project session memory (appends to `decision-log.md`) |
| `search_memory` | Search across `.claude-sessions-memory/` files for a query string |
| `get_recent_decisions` | Decisions from decision log, optionally filtered by recency (days) |
| `get_session_history` | Session summaries sorted by date from `session-*.md` files |

## Data Source (per-project)

```
.claude-sessions-memory/
├── decision-log.md        ← append-only decisions with rationale
├── handoff.md             ← session bridge
├── session-YYYY-MM-DD.md  ← per-session summaries
├── progress.md            ← active work state
└── MEMORY.md              ← index
```

## Relationship to MemPalace

This server provides **file-based** memory (always available, zero deps). For semantic search and graph queries, use the separate **MemPalace MCP server** (when installed) — see `.claude/skills/memory-palace/`.

## Run

```bash
node ./mcp/mxm-memory/server.js
```

## License

Apache 2.0 (see repository root).
