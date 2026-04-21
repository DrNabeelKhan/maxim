# Contributing to Maxim

Thank you for considering contributing to Maxim! This guide explains how to add new skills, agents, and frameworks to the platform.

## Quick Start

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-new-skill`
3. Follow the authoring guide below
4. Submit a Pull Request

## Adding a New Skill

### 1. Choose the right domain

Check `documents/reference/SKILLS_MAP.md` -- does your skill fit an existing domain? If yes, add it as a sub-skill. If no, propose a new domain in your PR description.

Current domains include: `behavior-science-persuasion`, `content-creation`, `design`, `engineering`, `enterprise-architecture`, `marketing`, `product`, `product-development-research`, `project-management`, `search-visibility`, `security`, `studio-operations`, `testing`, `compliance`, `ai`, `mobile`, `brand`, `banner-design`, `design-system`, `slides`, `ui-styling`, and `ui-ux-pro-max`.

### 2. Create the skill file

Place your skill at `.claude/skills/[domain]/[your-skill]/SKILL.md`. If adding to an existing domain, you can also extend the domain's root `SKILL.md`.

```bash
mkdir -p .claude/skills/[domain]/[your-skill]
# Create SKILL.md following the spec in documents/reference/MXM-SKILL-SPEC.md
```

### 3. Required elements

Every skill MUST have:

- **YAML frontmatter** with `skill_id`, `name`, `version`, `category`, `office`, `lead_agent`, `triggers`, and `collaborates_with` (see `documents/reference/MXM-SKILL-SPEC.md`)
- **Purpose section** -- what the skill does and when it activates
- **Activation triggers** -- keywords or contexts that invoke this skill
- **Behavioral Layer** -- confidence tagging, compliance awareness, handoff protocol
- **At least one framework** referenced from `documents/reference/FRAMEWORKS_MASTER.md`

### 4. Maxim behavioral layer compliance

Your skill must:

- Tag outputs with confidence: `HIGH` / `MEDIUM` / `LOW`
- Read `config/project-manifest.json` for compliance scope when relevant
- Write handoff state to `.mxm-skills/agents-handoff.md` on completion
- NEVER bypass CSO auto-loop for security-sensitive tasks
- Reference at least one behavioral framework from `documents/reference/FRAMEWORKS_MASTER.md`

## Adding a New Agent

### 1. Choose the office

Agents belong to one of 7 offices:

| Office | Lead Agent | Domain |
|--------|-----------|--------|
| CEO | `enterprise-architect` | Strategy, vision, finance, partnerships |
| CTO | `implementer` | Engineering, infrastructure, AI, DevOps |
| CMO | `content-strategist` | Marketing, brand, content, SEO |
| CSO | `security-analyst` | Security, compliance, privacy, risk |
| CPO | `product-strategist` | Product strategy, UX, UI, research |
| COO | `planner` | Operations, delivery, sprints |
| CINO | `innovation-researcher` | Innovation, R&D, emerging tech |

### 2. Create the agent file

Place the agent definition at `agents/Maxim/[office]/[agent-name].md`.

### 3. Required sections

Every agent file MUST include:

- **Role** -- 2-3 sentences describing the agent's purpose
- **Responsibilities** -- 5-7 bullet points
- **External Skill Source** -- maps to `community-packs/claude-skills-library/` if applicable
- **Maxim Behavioral Layer** -- confidence tagging, proactive triggers, communication standard
- **Portfolio Projects Served** -- which project types this agent supports
- **Triggers** -- activation keywords and contexts
- **Collaboration Matrix** -- which other agents this one works with
- **Output Format** -- expected deliverable structure
- **Handoff Protocol** -- how state passes to the next agent
- **Skills Used** -- which `.claude/skills/` domains are consumed

### 4. Register the agent

Add the new agent to `config/agent-registry.json` so the dispatch system can find it.

## Adding a Framework

Add your framework to `documents/reference/FRAMEWORKS_MASTER.md` following the existing format:

1. Place it under the appropriate category heading
2. Include: name, source/author, core principle, when to apply
3. Reference it from at least one skill or agent
4. Ensure it does not duplicate an existing framework (63+ already exist)

## Adding or Modifying Commands

Commands live in `.claude/commands/`. If you add or modify a command:

1. Follow the existing naming convention: `mxm-[name].md`
2. Update `documents/reference/MXM_COMMAND_MAP.md` with the new command entry
3. Include usage examples in the command file

## Repository Structure

Key directories for contributors:

```
maxim/
  .claude/skills/         -- Maxim domain skills (primary contribution target)
  agents/Maxim/            -- Agent definitions by office
  composable-skills/      -- Workflow patterns (writing-plans, executing-plans, etc.)
  config/                 -- Agent registry, project manifest template
  community-packs/               -- External skill libraries (read-only, managed via subtree)
  templates/              -- Project scaffold templates
  documents/reference/FRAMEWORKS_MASTER.md    -- 63+ behavioral science frameworks
```

## Pull Request Checklist

- [ ] YAML frontmatter present and valid (if skill or agent)
- [ ] Behavioral layer section included with confidence tagging
- [ ] At least one framework from `documents/reference/FRAMEWORKS_MASTER.md` referenced
- [ ] No `.mxm/` references (use `.mxm-skills/`)
- [ ] No hardcoded project paths or user-specific paths
- [ ] Agent registered in `config/agent-registry.json` (if new agent)
- [ ] `documents/reference/SKILLS_MAP.md` updated (if new domain added)
- [ ] `documents/reference/MXM_COMMAND_MAP.md` updated (if new command added)
- [ ] No secrets, API keys, or credentials included
- [ ] Tested with at least one sample prompt in Claude Code

## Commit Message Convention

Use conventional commits:

```
feat(skills): add competitive-intelligence skill to CPO office
fix(agents): correct collaboration matrix for security-analyst
docs: update SKILLS_MAP with new ai domain entries
chore(config): register new agent in agent-registry.json
```

## What Not to Modify

- `community-packs/` -- managed via git subtree; do not edit directly
- `config/project-manifest.json` -- project-specific; use the template instead
- `.mxm-skills/` -- runtime state, not committed
- `.claude-sessions-memory/` -- session persistence, not committed

## Code of Conduct

Be respectful, constructive, and focused on improving the platform. Maxim's governance architecture (ethics gates, CSO auto-loop, compliance enforcement) reflects our commitment to responsible AI. Contributions that undermine safety guardrails will not be accepted.

## Questions?

- Check `documents/guides/HELP.md` for the full command reference
- Check `documents/guides/GETTING_STARTED.md` for setup instructions
- Open an issue for architectural questions or skill gap proposals

## License

MIT -- see LICENSE file.
