# mxm-behavioral

Behavioral science framework selection and audit MCP server. Returns structured framework applications and audits content effectiveness.

## Tools

| Tool | Purpose |
|---|---|
| `recommend_frameworks` | Top 3 frameworks for a task and domain (e.g., onboarding flow design → Fogg + COM-B + Hook Model) |
| `apply_framework` | Apply a specific framework to a context, returning components and steps |
| `get_framework_details` | Full framework details: description, when to use, components, application steps |
| `behavioral_audit` | Audit content (landing page, email, onboarding, ad) against Fogg + COM-B + EAST + Hook Model |
| `nudge_design` | Design nudge architecture for a behavior change goal using EAST + Nudge Theory |

## Frameworks Available (63)

Fogg Behavior Model · COM-B · EAST · Hook Model · Cialdini's 6 Principles · JTBD · AIDA · Nudge Theory · Self-Determination Theory · Stages of Change · Loss Aversion · System 1/2 (Kahneman) · BJ Fogg Tiny Habits · Octalysis · IKEA Effect · Anchoring · 55 more (see `documents/reference/FRAMEWORKS_MASTER.md`).

## Run

```bash
node ./mcp/mxm-behavioral/server.js
```

## License

Apache 2.0 (see repository root).
