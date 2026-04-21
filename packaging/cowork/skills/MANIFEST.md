# Skills Bundled in maxim.plugin (Cowork)

> **20 of 34 skills** included. Selection criteria: surface-agnostic, high user value, no executable-hook dependency.

**Version:** v1.0.0

---

## Included (20)

### Executive office dispatchers (7)

These route tasks to specialist mental models. Surface-agnostic — the routing is pure prompt engineering.

| Skill | Source Path | Office |
|---|---|---|
| `ceo-automation` | `../../.claude/skills/ceo-automation/` | CEO |
| `engineering` | `../../.claude/skills/engineering/` | CTO |
| `marketing` | `../../.claude/skills/marketing/` | CMO |
| `security` | `../../.claude/skills/security/` | CSO |
| `product` | `../../.claude/skills/product/` | CPO |
| `studio-operations` | `../../.claude/skills/studio-operations/` | COO |
| `enterprise-architecture` | `../../.claude/skills/enterprise-architecture/` | CEO |

### Domain intelligence (6)

Reference-heavy skills with high user value.

| Skill | Source Path | Domain |
|---|---|---|
| `brand` | `../../.claude/skills/brand/` | Brand identity / voice |
| `design` | `../../.claude/skills/design/` | Design dispatcher |
| `design-system` | `../../.claude/skills/design-system/` | Token architecture |
| `ui-styling` | `../../.claude/skills/ui-styling/` | shadcn/Tailwind/CSS |
| `banner-design` | `../../.claude/skills/banner-design/` | Digital banners / ads |
| `slides` | `../../.claude/skills/slides/` | Decks / presentations |

### Behavioral / meta (4)

Core Maxim moat skills.

| Skill | Source Path | Purpose |
|---|---|---|
| `behavior-science-persuasion` | `../../.claude/skills/behavior-science-persuasion/` | Fogg / COM-B / EAST / Cialdini application |
| `compliance` | `../../.claude/skills/compliance/` | 14-framework compliance dispatcher |
| `content-creation` | `../../.claude/skills/content-creation/` | External-facing copy with brand foundation |
| `product-development-research` | `../../.claude/skills/product-development-research/` | Research methodology |

### Operational (3)

| Skill | Source Path | Purpose | Notes |
|---|---|---|---|
| `proactive-watch` | `../../.claude/skills/proactive-watch/` | Drift detection | Advisory in Cowork — no SessionStart auto-trigger |
| `session-memory` | `../../.claude/skills/session-memory/` | Session persistence | Scoped to Cowork project |
| `operator-profile` | `../../.claude/skills/operator-profile/` | Personalization | Uses uploaded profile file |

---

## Excluded (14)

### Hook-dependent (4)

These require executable hook runtime — Cowork doesn't support it.

| Skill | Reason | Cowork Alternative |
|---|---|---|
| `junction-guard` | Windows junction semantics | Not applicable outside filesystem access |
| `usage-aware-scheduler` | Anthropic OAuth API + local cron | User runs `/mxm-tasks` in CLI, not Cowork |
| `voice` | Requires local voicemode binary | Voice connector is a no-op in Cowork |
| `testing` | Requires CI / test runner | Users run tests locally; Cowork advisory only |

### MCP-dependent with no Cowork connector (6)

These skills wrap functionality that requires a specific MCP server with runtime that isn't available in Cowork.

| Skill | Blocker | Status |
|---|---|---|
| `wiki-ingest` | MemPalace MCP runtime | Deferred to v7.x when MemPalace supports Cowork |
| `wiki-query` | Same | Deferred |
| `wiki-lint` | Same | Deferred |
| `wiki-explore` | Same | Deferred |
| `memory-palace` | Same | Deferred |
| `design-resources` | External library mounts | Partial via design skill |

### Dispatcher skills with sub-skill orchestration (4)

These work in Cowork but redirect to the specialist skills above — included as prompt references only, not as separate activations.

| Skill | Merged Into |
|---|---|
| `ui-ux-pro-max` | Activates `design` + `ui-styling` + `design-system` via prompt chaining |
| `ai-media-generation` | Deferred to v7.x plugin release |
| `search-visibility` | Deferred |
| `project-management` | Deferred |

---

## Activation Model

In Claude Code, skills activate via YAML-frontmatter triggers matched against user utterance. In Cowork, skill activation is plugin-mediated — the plugin manifest declares which skills are available and Cowork's own dispatch logic matches them.

The bundled skills here retain their original SKILL.md frontmatter; the plugin build step (`ASSEMBLY.md`) adapts the frontmatter to Cowork's plugin schema.

---

## Updates

When a new Maxim release ships:
1. Review the `.claude/skills/` directory for new/changed skills
2. Update this MANIFEST.md
3. Re-run `ASSEMBLY.md` build
4. Publish new `.plugin` artifact

The `cross-doc-drift` checker in Proactive Watch flags when the maxim repo version ahead of the Cowork plugin manifest.
