# Maxim Skill Specification -- v1.0.0

> Standard format for all Maxim skill files. Follow this spec when authoring new skills.

## Required YAML Frontmatter

Every SKILL.md must begin with YAML frontmatter:

```yaml
---
skill_id: [kebab-case-unique-id]
name: [Display Name]
version: [semver]
category: [domain-name]
office: [CEO|CTO|CMO|CSO|CPO|COO|CINO|All]
lead_agent: [agent-name]
triggers:
  - [keyword that activates this skill]
collaborates_with:
  - [agent names]
---
```

## Field Definitions

| Field | Required | Description |
|---|---|---|
| `skill_id` | Yes | Unique kebab-case identifier (e.g., `behavior-science-persuasion`) |
| `name` | Yes | Human-readable display name |
| `version` | Yes | Semantic version (major.minor.patch) |
| `category` | Yes | Parent domain folder name |
| `office` | Yes | Executive office this skill reports to |
| `lead_agent` | Yes | Primary agent responsible for this skill |
| `triggers` | Yes | Keywords/phrases that activate this skill |
| `collaborates_with` | No | Agents auto-looped when this skill activates |

## Required Sections

### 1. Purpose

2-3 sentences describing what this skill does and its unique value. Must answer:
- What problem does this skill solve?
- What behavioral science layer does it apply?
- What differentiates it from raw external skills?

### 2. Sub-Skill Routing (if domain dispatcher)

Table mapping task signals to sub-skills:

```markdown
| Signal | Routes To | Agent |
|---|---|---|
| [keyword/pattern] | [sub-skill path] | [agent-name] |
```

### 3. Activation

When this skill triggers:
- Slash command (e.g., `/mxm-cto`)
- Keywords detected in task
- Executive router classification
- Auto-loop from another agent

### 4. Behavioral Layer

Every Maxim skill MUST include:

- **Confidence tagging**: output tagged with the appropriate signal
  - HIGH: Maxim skill matched, behavioral layer fully applied
  - MEDIUM: Maxim stub active OR partial external match
  - LOW / Maxim-UNENHANCED: No Maxim skill matched, raw external used
- **Compliance**: reads `config/project-manifest.json` before decisions
- **Handoff**: writes `.mxm-skills/agents-handoff.md` on completion
- **Frameworks**: list applicable frameworks from `documents/reference/FRAMEWORKS_MASTER.md`

### 5. External Sources

References to external skill sources that are merged:

```markdown
- Primary: community-packs/claude-skills-library/[path]/
- Design: community-packs/ui-ux-pro-max/.claude/skills/[path]/
- VoltAgent: community-packs/voltagent-subagents/[category]/
```

## Optional Sections

### References

Links to `references/` files loaded on demand for deep context.

### Shared Resources

Links to `shared-resources/` files reusable across sub-skills within the domain.

### Output Format

Expected deliverable structure -- tables, documents, code artifacts, etc.

## File Structure Per Domain

```
.claude/skills/[domain]/
|-- SKILL.md              <-- root dispatcher (REQUIRED)
|-- Maxim-WRAPPER.md       <-- behavioral layer (REQUIRED)
|-- [sub-skill]/SKILL.md  <-- sub-skill dispatchers
|-- references/           <-- docs loaded on demand
+-- shared-resources/     <-- reusable across sub-skills
```

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Domain folders | kebab-case | `behavior-science-persuasion` |
| Sub-skill folders | kebab-case matching agent name | `content-strategist` |
| Root dispatcher | uppercase | `SKILL.md` |
| Behavioral wrapper | uppercase | `Maxim-WRAPPER.md` |
| Reference files | kebab-case | `seo-checklist.md` |
| Shared resource files | kebab-case | `tone-matrix.md` |

## Validation Checklist

Before submitting a new skill, verify:

- [ ] YAML frontmatter present and complete
- [ ] `skill_id` is unique across all domains
- [ ] `version` follows semver
- [ ] Purpose section explains behavioral value-add
- [ ] Activation section lists all trigger paths
- [ ] Behavioral Layer section includes confidence, compliance, handoff, frameworks
- [ ] External Sources section lists all merged references
- [ ] Maxim-WRAPPER.md exists alongside SKILL.md
- [ ] Domain SKILL.md updated with routing entry for new sub-skill
