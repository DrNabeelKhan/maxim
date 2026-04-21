# /mxm-ceo

## Usage
- Claude Code: `/mxm-ceo`
- Claude CLI: `claude "/mxm-ceo"`
- Claude Desktop: type `/mxm-ceo` in chat

Routes to CEO Office. Lead: `enterprise-architect`.
Scope: strategy · vision · finance · enterprise architecture · partnerships · governance

## Behavior
1. Read `config/project-manifest.json` for project identity
2. Activate `enterprise-architect` as lead
3. Read `.claude/skills/enterprise-architecture/`
4. Check if `.mxm-executive-summary/` exists in the current project root
   - If YES: Also read `.mxm-executive-summary/CONTEXT.md` for startup intelligence
   - Activate `.claude/skills/ceo-automation/Maxim-WRAPPER.md`
   - Report available CEO automation cycles: `/ceo-morning`, `/ceo-overnight`
   - If NO: Continue with standard CEO office behavior
5. Apply CEO office roster: `business-architect` · `financial-modeler` ·
   `governance-specialist` · `influence-strategist` · `investor-pitch-writer` ·
   `negotiation-specialist` · `partnership-manager` · `studio-producer`
6. CEO arbitration: resolves strategic conflicts between offices
7. Write `.mxm-skills/agents-handoff.md` on completion
8. Tag output: 🟢 HIGH
