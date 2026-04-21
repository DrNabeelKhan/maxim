# Maxim Skill — Studio Operations

> Layer 1 — Supreme Authority | Executive Office: COO

## Domain

Business operations, analytics, financial modeling, infrastructure maintenance, legal compliance, partnership management, and customer success. A multi-office domain — agents from CTO, CEO, and CSO offices converge here for agency-wide operational tasks.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`planner` — COO Office

## Active Agents

- `analytics-reporter` — analytics dashboards, KPI tracking, data insights, anomaly detection (CTO office, routes here for operational reporting)
- `customer-success-manager` — customer health tracking, churn prevention, success planning, QBR management
- `financial-modeler` — budget tracking, financial forecasting, expense management, financial reporting (absorbs `finance-tracker` via Op-D: Modeling · Tracking modes; CEO office)
- `infrastructure-maintainer` — system uptime, incident management, infrastructure health, IaC maintenance (CTO office)
- `legal-compliance-checker` — contract review, regulatory affairs, terms of service, localization law (CSO office, ethics gate active for contract/regulatory review)
- `partnership-manager` — partnership strategy, partner onboarding, alliance management, deal structuring (CEO office)
- `support-responder` — tier-1 support, support documentation, escalation routing, FAQ management

## Skill Modes

Sub-skill SKILL.md files per specialist. Key modes:
- `analytics-reporter` → Dashboard · KPI · Insights · Anomaly Detection
- `financial-modeler` → Modeling · Tracking (Op-D: absorbed from `finance-tracker`)
- `infrastructure-maintainer` → Uptime · Incident · IaC · Health Monitoring
- `legal-compliance-checker` → Contract Review · Regulatory · ToS · Localization Law
- `partnership-manager` → Strategy · Onboarding · Alliance · Deal Structuring
- `customer-success-manager` → Health Tracking · Churn Prevention · QBR · Success Planning
- `support-responder` → Tier-1 · Documentation · Escalation · FAQ

## Ethics Gate

`legal-compliance-checker` ethics gate active — contract and regulatory review outputs require human sign-off before execution.
When financial or legal outputs touch regulated industries or PII → compliance skill auto-looped (CSO auto-loop rule).

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/engineering-team/google-workspace-cli` — workspace automation, ops tooling, Google Workspace integration
- `community-packs/claude-skills-library/documentation/` — documentation standards, knowledge management patterns
- `community-packs/claude-skills-library/orchestration/` — multi-agent operational workflow patterns
- `community-packs/claude-skills-library/finance/` — financial modeling templates, budget frameworks

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the studio-operations skill:

- `analytics report`, `dashboard`, `KPI tracking`, `data insights`
- `budget tracking`, `expense management`, `financial report`, `financial forecast`
- `customer success`, `churn prevention`, `customer health`, `QBR`
- `infrastructure maintenance`, `system uptime`, `incident management`
- `contract review`, `legal review`, `terms of service`, `regulatory affairs`
- `partnership management`, `partner onboarding`, `alliance strategy`
- `support`, `help desk`, `customer support`, `escalation routing`
- `business operations`, `agency operations`, `studio workflow`

## Cross-Agent Auto-Loops

When studio-operations skill activates, the following agents are auto-notified:

- `planner` — COO lead for all operational workflow coordination
- `compliance` skill — auto-looped on all legal, regulatory, and financial compliance tasks (CSO auto-loop rule)
- `security-analyst` — auto-looped when operations involve PII, customer data, or infrastructure security (CSO auto-loop rule)
- `enterprise-architect` — CEO lead notified for strategic partnership and financial decisions
- `infrastructure-maintainer` — auto-looped on all system health and incident tasks

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | studio-operations | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
