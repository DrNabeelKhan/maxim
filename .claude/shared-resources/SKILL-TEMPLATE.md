---
skill_id: [your-skill-id]
name: [Your Skill Name]
version: 0.1.0
category: [parent-domain]
office: [CEO|CTO|CMO|CSO|CPO|COO|CINO]
lead_agent: [agent-name]
triggers:
  - [keyword 1]
  - [keyword 2]
collaborates_with:
  - [agent 1]
  - [agent 2]
---

# [Your Skill Name]

> Office: [office] | Lead: [lead_agent]

## Purpose

[2-3 sentences describing what this skill does and when it activates.
Explain the behavioral science value-add that differentiates this from raw external skills.
State what problem this skill solves.]

## Sub-Skill Routing

<!-- Remove this section if this is a leaf skill, not a domain dispatcher -->

| Signal | Routes To | Agent |
|---|---|---|
| [keyword/pattern] | [sub-skill-folder/SKILL.md] | [agent-name] |
| [keyword/pattern] | [sub-skill-folder/SKILL.md] | [agent-name] |

## Activation

This skill activates when:
- User invokes [slash command]
- Task contains keywords: [triggers]
- Executive router detects [signal type]
- Auto-looped by: [agent names, if applicable]

## Behavioral Layer

- Confidence: HIGH
- Compliance: reads `config/project-manifest.json` before decisions
- Handoff: writes `.mxm-skills/agents-handoff.md` on completion
- Frameworks: [list applicable frameworks from documents/reference/FRAMEWORKS_MASTER.md]

### Confidence Criteria

| Condition | Tag |
|---|---|
| Maxim skill matched, behavioral layer fully applied | HIGH |
| Partial match or stub active | MEDIUM |
| No Maxim skill, raw external used | LOW / Maxim-UNENHANCED |

## External Sources

- Primary: `community-packs/claude-skills-library/[path]/`
- Design: `community-packs/ui-ux-pro-max/.claude/skills/[path]/`
- VoltAgent: `community-packs/voltagent-subagents/[category]/`

## References

<!-- Links to references/ files loaded on demand -->
- [reference-name]: `references/[filename].md`

## Output Format

<!-- Expected deliverable structure -->

1. [Deliverable 1]: [format description]
2. [Deliverable 2]: [format description]
