# /mxm-design

## Usage
- Claude Code: `/mxm-design`
- Claude CLI: `claude "/mxm-design"`
- Claude Desktop: type `/mxm-design` in chat

Activates the CPO design cluster. `ui-ux-designer` orchestrates all design sub-domains.

**Triggers:** "design this", "UX", "UI", "wireframe", "design system", "brand"
**Office:** CPO → `ui-ux-designer` (orchestrator)
**Reads:** `.claude/skills/design/` · `.claude/skills/ui-ux-pro-max/` ·
           `.claude/skills/design-system/` · `.claude/skills/ui-styling/` ·
           `.claude/skills/brand/` · `.claude/skills/slides/`

## Behavior

1. Activate `ui-ux-designer` — activates all 6 design sub-domains in parallel
2. Apply `behavior-science-persuasion` as behavioral foundation (always loops)
3. Route to specialist: `ui-designer` · `ux-researcher` · `brand-guardian`
4. Apply `.claude/skills/ui-ux-pro-max/` as master design conductor
5. Tag output: 🟢 HIGH
