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

## Frameworks

`apply_framework` and `get_framework_details` resolve a framework in this order:

1. **Authored definition** — if `composable-skills/frameworks/<slug>/SKILL.md` for that framework is authored, it is the answer. This is what makes writing a definition change the tool's output.
2. **Curated** — 8 compact hand-written entries in `server.js`: Fogg Behavior Model · COM-B · EAST · Hook Model · Nudge Theory · Cialdini's Principles · AIDA · Jobs-to-be-Done. Used when the definition for that framework is still a stub. Fogg, COM-B, EAST and Hook now have authored definitions, so the curated entries serve Nudge, Cialdini, AIDA and JTBD.
3. **Reviewed aliases** — a short explicit list in `framework-loader.mjs` (for example `NIST CSF`). Deliberately not fuzzy: names that merely share a word, such as Hero's Journey and User Journey Mapping, are different frameworks.
4. **Any other definition** — every remaining `SKILL.md`, loaded lazily on first use.

Each answer carries a `status`:

| Status | Meaning | What the tool returns |
|---|---|---|
| `authored` | Framework-specific content | Full description, use cases, principles and steps |
| `partial` | Real principles, some generic fields | Full detail, with `generic_fields` naming which ones |
| `stub` | Generated template text only | A plain "not yet authored" message, never the filler |

The status is computed, not declared: a field counts as template text when, after the framework's own name is replaced by a placeholder, it is identical to that field in another definition. Run `node --test mcp/mxm-behavioral/framework-loader.test.mjs` for the current counts, which the suite pins so that authoring a stub is a deliberate, visible change.

`recommend_frameworks` ranks from the domain lists and curated entries only, then fills in content for the chosen frameworks. Its ranking is intentionally unchanged by the definitions: the keyword scorer matches any one-letter word, so scoring against every long definition would make all of them look relevant. · BJ Fogg Tiny Habits · Octalysis · IKEA Effect · Anchoring · 55 more (see `documents/reference/FRAMEWORKS_MASTER.md`).

## Run

```bash
node ./mcp/mxm-behavioral/server.js
```

## License

Apache 2.0 (see repository root).
