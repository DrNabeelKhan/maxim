# Maxim Skill Specification

> Version 1.0.0 | Format for authoring Maxim-compatible skills

Maxim skills are markdown files with YAML frontmatter that define specialist capabilities for AI agents. They are consumed by Claude Code, Claude Desktop, and any Claude surface via Maxim's 5-layer dispatch sequence.

## Skill File Format

Every Maxim skill is a `SKILL.md` file placed at `.claude/skills/[domain]/SKILL.md` or `.claude/skills/[domain]/[sub-skill]/SKILL.md`.

### YAML Frontmatter

```yaml
---
skill_id: unique-kebab-case-id
name: Human Readable Name
version: 1.0.0
category: domain-name
office: CEO | CTO | CMO | CSO | CPO | COO | CINO
lead_agent: agent-name
triggers:
  - keyword or phrase that activates this skill
  - another activation trigger
collaborates_with:
  - other-skill-id
  - another-skill-id
frameworks:
  - Framework Name (from documents/reference/FRAMEWORKS_MASTER.md)
compliance_scope:
  - GDPR
  - SOC2
---
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `skill_id` | string | Unique kebab-case identifier |
| `name` | string | Human-readable skill name |
| `version` | semver | Skill version (major.minor.patch) |
| `category` | string | Domain this skill belongs to |
| `office` | enum | Executive office that owns this skill |
| `lead_agent` | string | Primary agent that executes this skill |
| `triggers` | list | Keywords/phrases that activate the skill |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `collaborates_with` | list | Other skills invoked alongside this one |
| `frameworks` | list | Behavioral frameworks applied |
| `compliance_scope` | list | Regulatory frameworks relevant to outputs |

## Quick Example

```yaml
---
skill_id: page-cro
name: Page CRO
version: 1.0.0
category: marketing
office: CMO
lead_agent: conversion-optimizer
triggers:
  - conversion rate
  - landing page optimization
  - CRO audit
collaborates_with:
  - copywriting
  - analytics-reporter
frameworks:
  - Fogg Behavior Model
  - EAST Framework
---
```

```markdown
# Page CRO

> Before starting: Read MARKETING-CONTEXT.md for product and ICP context.

## Purpose

Systematic conversion rate optimization for landing pages using behavioral
science principles and data-driven testing methodology.

## Activation Triggers

- User mentions conversion rate, bounce rate, or landing page performance
- Request to audit or improve a page's effectiveness
- A/B testing strategy or variant design

## Process

1. Audit current page against behavioral triggers
2. Identify friction points using Fogg Behavior Model
3. Propose variants with predicted impact
4. Design measurement plan

## Behavioral Layer

- Confidence: Tag all recommendations HIGH / MEDIUM / LOW
- Compliance: Check project-manifest.json for industry constraints
- Handoff: Write results to .mxm-skills/agents-handoff.md
- CSO Loop: Flag if page collects PII or payment data

## Frameworks Applied

- Fogg Behavior Model (motivation x ability x prompt)
- EAST Framework (Easy, Attractive, Social, Timely)
```

## Behavioral Layer Requirements

Every Maxim skill MUST include a behavioral layer section that addresses:

1. **Confidence tagging** -- all outputs tagged `HIGH`, `MEDIUM`, or `LOW`
2. **Compliance awareness** -- read `config/project-manifest.json` for applicable regulations
3. **Handoff protocol** -- write completion state to `.mxm-skills/agents-handoff.md`
4. **CSO auto-loop** -- flag security/privacy concerns for automatic security review
5. **Framework application** -- reference at least one framework from `documents/reference/FRAMEWORKS_MASTER.md`

## Ecosystem

Maxim skills operate within a layered architecture:

| Layer | Location | Purpose |
|-------|----------|---------|
| Skills | `.claude/skills/[domain]/SKILL.md` | Domain-specific capabilities |
| Agents | `agents/MXM/[office]/[agent].md` | Role-based execution |
| Commands | `.claude/commands/mxm-[name].md` | User-facing entry points |
| Frameworks | `documents/reference/FRAMEWORKS_MASTER.md` | 63+ behavioral science frameworks |
| Workflows | `composable-skills/` | Multi-step patterns (planning, testing, debugging) |

### Dispatch Sequence

When a task arrives, Maxim follows a 5-step lookup:

1. Check `.claude/skills/` for a matching Maxim skill
2. Check `community-packs/` for supplementary domain knowledge
3. Merge Maxim behavioral layer with external references (Maxim wins conflicts)
4. Apply workflow pattern if multi-step
5. Route through the appropriate executive office

## Domains

Current skill domains and their offices:

| Domain | Office | Description |
|--------|--------|-------------|
| `behavior-science-persuasion` | CMO | Behavioral triggers, persuasion frameworks |
| `content-creation` | CMO | Copywriting, documentation, content strategy |
| `design` | CPO | UX/UI design, interaction design |
| `engineering` | CTO | Backend, frontend, AI/ML, DevOps |
| `enterprise-architecture` | CEO | System design, solution architecture |
| `marketing` | CMO | GTM, growth, campaigns |
| `product` | CPO | Product strategy, roadmaps |
| `product-development-research` | CPO | Discovery, validation, user research |
| `project-management` | COO | Delivery, sprints, planning |
| `search-visibility` | CMO | SEO, AEO, search optimization |
| `security` | CSO | Threat modeling, SecOps, compliance |
| `studio-operations` | COO | Agency ops, workflow automation |
| `testing` | CTO | QA, test strategy, coverage |
| `compliance` | CSO | GDPR, ISO 27001, regulatory |
| `ai` | CTO | ML engineering, prompt engineering, RAG |
| `mobile` | CTO | Cross-platform, React Native |
| `brand` | CMO | Brand identity, voice, visual systems |
| `design-system` | CPO | Token architecture, component libraries |
| `slides` | CMO | Presentations, pitch decks |
| `ui-styling` | CPO | CSS, Tailwind, responsive design |

## Compatibility

Maxim skills work with:

- **Claude Code** -- native skill loading via `.claude/skills/`
- **Claude Desktop** -- via `/mxm-context` command
- **Claude CLI** -- via `.claude/commands/`
- **Claude Dispatch** -- background task execution
- **Claude Cowork** -- via plugin integration

## Validation Checklist

Before submitting a new skill:

- [ ] YAML frontmatter includes all required fields
- [ ] `skill_id` is unique across all domains
- [ ] `triggers` list has at least 2 entries
- [ ] Behavioral layer section is present and complete
- [ ] At least one framework from `documents/reference/FRAMEWORKS_MASTER.md` is referenced
- [ ] No hardcoded paths or project-specific values
- [ ] Tested with a sample prompt in Claude Code
