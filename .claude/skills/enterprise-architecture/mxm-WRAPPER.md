# Maxim Skill — Enterprise Architecture

> Layer 1 — Supreme Authority | Executive Office: CEO

## Domain

Enterprise systems design, business architecture, solution architecture, data architecture, governance, and technology strategy. The CEO office's primary technical domain — resolves strategic conflicts between all other offices.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`enterprise-architect` — CEO Office

## Active Agents

- `enterprise-architect` — enterprise architecture strategy, digital transformation, architecture roadmaps, IT strategy (CEO lead; resolves inter-office strategic conflicts)
- `solution-architect` — end-to-end solution design, cloud architecture, system integration
- `technology-architect` — technology strategy, tech stack evaluation, platform decisions
- `business-architect` — business capability modeling, value chain design, operating model
- `data-architect` — data platform design, data governance, data modeling, DMBOK compliance
- `governance-specialist` — IT governance, COBIT, RoPA maintenance, audit trail management

## Skill Modes

Sub-skill SKILL.md files per specialist. Key modes:
- `enterprise-architect` → Strategy · Transformation · Roadmap · Governance
- `solution-architect` → Cloud · Integration · Microservices · Serverless
- `technology-architect` → Platform Selection · Tech Stack · Vendor Evaluation
- `business-architect` → Capability Modeling · Value Chain · Operating Model
- `data-architect` → Data Platform · Governance · Modeling · DMBOK
- `governance-specialist` → COBIT · ITIL · Audit · RoPA

## Ethics Gate

None. Standard Maxim behavioral output quality applies.
Note: When architecture decisions involve PII data flows or regulated industries → compliance skill auto-looped (CSO auto-loop rule applies across all offices).

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/c-level-advisor/` — C-suite advisory patterns, strategic framing, executive communication
- `community-packs/claude-skills-library/engineering-team/senior-architect` — consumed by `enterprise-architect` · `solution-architect` · `technology-architect` · `backend-architect` · `business-architect` · `data-architect` · `governance-specialist`
- `community-packs/claude-skills-library/engineering-team/aws-solution-architect` — consumed by `solution-architect` · `devops-automator` · `infrastructure-maintainer` · `cloud-cost-optimizer`
- `community-packs/claude-skills-library/orchestration/` — multi-agent orchestration patterns for enterprise workflows

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the enterprise-architecture skill:

- `enterprise architecture`, `digital transformation`, `architecture strategy`, `IT roadmap`
- `solution design`, `system architecture`, `integration strategy`, `cloud architecture`
- `business capability`, `value chain`, `operating model`, `business architecture`
- `data platform`, `data governance`, `data architecture`, `DMBOK`
- `technology strategy`, `tech stack decision`, `platform selection`, `vendor evaluation`
- `TOGAF`, `Zachman`, `COBIT`, `ITIL`, `governance framework`
- `microservices architecture`, `enterprise integration`, `API gateway`
- `audit trail`, `RoPA`, `governance review`

## Cross-Agent Auto-Loops

When enterprise-architecture skill activates, the following agents are auto-notified:

- `enterprise-architect` — CEO lead, arbitrates strategic conflicts between all offices
- `business-architect` — auto-looped for business capability and operating model alignment
- `governance-specialist` — auto-looped for all governance and audit requirements
- `security-analyst` — auto-looped when architecture involves security-sensitive systems (CSO auto-loop rule)
- `compliance` skill — auto-looped when data governance or regulated industry is in scope
- `implementer` — CTO lead notified when architecture requires engineering execution

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | enterprise-architecture | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
