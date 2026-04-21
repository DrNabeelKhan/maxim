# mxm-context

Project-level context MCP server. Exposes manifest, decision log, session memory, operator profile, and skill gap data to any Claude surface.

## Tools

| Tool | Purpose |
|---|---|
| `get_manifest` | Project identity, compliance scope, tech stack from `config/project-manifest.json` |
| `get_decision_log` | Recent decisions with rationale from `.claude-sessions-memory/decision-log.md` |
| `get_session_memory` | Handoff state, open tasks, last session summary |
| `get_operator_profile` | Operator identity, preferences, rejected patterns, communication style |
| `get_architecture_docs` | PRD, FRD, SRD summaries from `documents/architecture/` (first 200 lines each) |
| `get_skill_gaps` | Unresolved capability gaps from `.mxm-skills/agents-skill-gaps.log` |

## Data Sources (per-project)

```
config/project-manifest.json           # identity + compliance
.claude-sessions-memory/decision-log.md
.claude-sessions-memory/handoff.md
.mxm-operator-profile/OPERATOR.md
documents/architecture/{PRD,FRD,SRD}.md
.mxm-skills/agents-skill-gaps.log
```

## Run

```bash
node ./mcp/mxm-context/server.js
```

## License

Apache 2.0 (see repository root).
