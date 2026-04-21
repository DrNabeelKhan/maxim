# Session Instructions for [PROJECT_NAME]

## Maxim Integration

This project uses the Maxim CEO Automation system.
All session behavior follows Maxim dispatch rules from CLAUDE.md.

## Always do first

1. Read config/project-manifest.json for project identity and compliance scope
2. Read .mxm-executive-summary/CONTEXT.md for startup context
3. Read .mxm-executive-summary/sessions/progress.md for current state
4. Read .mxm-executive-summary/sessions/tasks.md for queued tasks
5. Check .mxm-skills/agents-handoff.md for any pending agent handoffs
6. Tell me: current state and next 3 tasks

## Output rules

- Save all outputs to .mxm-executive-summary/logs/
- File naming: [task-name]-[YYYY-MM-DD].md
- Never overwrite existing log files — append date suffix
- Apply Maxim confidence tagging to all outputs
- Tag: HIGH (Maxim skill matched) | MEDIUM (partial) | LOW (no skill)

## Compliance

- Read config/project-manifest.json → compliance.per_project for this project
- If regulated_projects: flag financial data handling
- If payment_projects: PCI-DSS checks active
- If hipaa_projects: PHI controls active

## At end of every session

1. Update .mxm-executive-summary/sessions/progress.md
2. Update .mxm-executive-summary/sessions/tasks.md
3. Write .mxm-skills/agents-handoff.md if passing to another agent
4. Note decisions made and information still needed
