# mxm-catalog

> **Unified catalog MCP server** — agents, offices, skills, commands.
> Consolidated in v1.0.0 from the former `maxim-dispatch` + `maxim-skills` servers (ADR-002).

**9 tools total.**

---

## Tools

### Agent / office routing (formerly `maxim-dispatch`)

| Tool | Purpose |
|---|---|
| `route_task` | Route a task to the correct office + lead agent + skills, with confidence score |
| `list_agents` | List all 88 Maxim agents, optionally filtered by office |
| `get_agent_dna` | Get the full markdown (DNA) of a specific agent |
| `list_offices` | List all 7 executive offices with leads + agent counts |
| `get_handoff_chain` | Get the planner → implementer → reviewer → tester → release-manager chain for a task |

### Skill / command catalog (formerly `maxim-skills`)

| Tool | Purpose |
|---|---|
| `list_skills` | List all `.claude/skills/` domains (34 in v1.0.0) with metadata |
| `search_skills` | Search skills by trigger / tag / framework keyword |
| `get_skill_detail` | Get a skill's full SKILL.md content |
| `list_commands` | List all `/mxm-*` slash commands (37 in v1.0.0) with descriptions |

---

## Migration from v1.0.0

Tool namespaces changed (hard cutover — no aliases per ADR-002 / v1.0.0 release notes):

| v1.0.0 | v1.0.0 |
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

Behavior and arguments are identical — only the server namespace changes.

---

## Why Consolidate?

From ADR-002 + release-sprint discussion:

- **Performance** — two Node processes merged to one. Lower startup cost, fewer handshakes, less memory.
- **Cohesion** — both servers answered "what exists in Maxim?" — one for agents, one for skills. That's a single semantic domain.
- **Discovery** — users querying Maxim capabilities no longer need to know which server hosts which tool.

Trade-off: breaks any external consumer using `maxim-dispatch` or `maxim-skills`. Per user directive, no aliasing — hard cutover. Since this is a pre-v7 framework with no known external consumers, the cost is minimal.

---

## Configuration

### MCP registration (`.mcp.json`)

```json
{
  "mxm-catalog": {
    "command": "node",
    "args": ["mcp/mxm-catalog/server.js"]
  }
}
```

### Install

```bash
cd mcp/mxm-catalog
npm install
```

### Environment

| Variable | Default | Purpose |
|---|---|---|
| `MXM_ROOT` | `E:/Projects/Maxim/maxim` | Absolute path to maxim repo (for cross-project deployments) |

---

## Related

- `../README.md` — full MCP server catalog (7 servers, 47 tools total)
- `../mxm-context/` — absorbed `maxim-design` tools + new `watch_*` tools
- `documents/ADRs/ADR-002-executable-contracts.md` — consolidation rationale
- `CHANGELOG.md` § v1.0.0 — release notes

---

## Version History

- **1.1.0** (v1.0.0) — consolidated from dispatch + skills
- **1.0.0** (v1.0.0) — shipped as two separate servers (dispatch, skills)
