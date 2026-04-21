# New Project Setup

> **Usage:** Paste this into Claude Code when bootstrapping a brand-new project.
> Replace `[PROJECT_PATH]` with the target folder (e.g., `E:\Projects\nabeelkhan-site`).
> Replace `[PROJECT_NAME]`, `[PROJECT_ID]`, `[VERTICAL]`, `[STAGE]` with project details.

---

## Prompt

Bootstrap a new Maxim-managed project at `[PROJECT_PATH]`.

### Project Details
- **Name:** [PROJECT_NAME]
- **ID:** [PROJECT_ID] (lowercase, hyphenated)
- **Vertical:** [VERTICAL] (e.g., SaaS, AI, FinTech, EdTech, LegalTech, Personal Brand)
- **Stage:** [STAGE] (idea, early-stage, active, scaling, mature)
- **Compliance:** [LIST_FRAMEWORKS or "none"] (e.g., PIPEDA, GDPR, PCI-DSS)
- **Description:** [ONE_SENTENCE_DESCRIPTION]

### Step 1 — Create folder structure

```
[PROJECT_PATH]/
├── config/
│   └── project-manifest.json
├── CLAUDE.project.md
├── documents/
│   ├── architecture/
│   │   └── .secrets/
│   └── business/
├── prototypes/
├── .mxm-skills/
│   ├── agents-skill-gaps.log
│   ├── agents-handoff.md
│   ├── agents-background.log
│   └── review-queue.md
├── .claude-sessions-memory/
│   ├── handoff.md
│   ├── decision-log.md
│   └── MEMORY.md
├── .mxm-operator-profile/
│   ├── OPERATOR.md
│   ├── preferences.md
│   ├── rejected-patterns.md
│   └── communication-style.md
├── .claude.local/
│   └── settings.local.json
├── TASKS.md
├── README.md
└── .gitignore
```

### Step 2 — Generate project-manifest.json

Read `E:\Projects\Maxim\maxim\config\project-manifest.TEMPLATE.json` as the template.
Fill in the project details from above. Set `mxm_version` to the latest (check `E:\Projects\Maxim\maxim\config\agent-registry.json` for current version).

### Step 3 — Generate CLAUDE.project.md

Read `E:\Projects\Maxim\maxim\CLAUDE.project.TEMPLATE.md` as the template.
Fill in project-specific overrides: brand voice, compliance rules, key documents, build commands.

### Step 4 — Generate settings.local.json

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(node -e \":\"*)",
      "Bash(python3 -c \":\"*)",
      "Read([PROJECT_PATH]/**)",
      "Edit([PROJECT_PATH]/**)",
      "Write([PROJECT_PATH]/**)"
    ]
  }
}
```

### Step 5 — Generate TASKS.md

Read `E:\Projects\.mxm-global\temp\GLOBAL_TODO_v6.md` — search for any tasks tagged with [PROJECT_NAME] or [PROJECT_ID].
If found: extract them into the project's TASKS.md.
If not found: create an empty TASKS.md with the standard table header.

### Step 6 — Generate README.md

Create a README with: project name, one-line description, tech stack (from manifest), getting started, Maxim integration notes.

### Step 7 — Generate .gitignore

Include Maxim-standard entries:
```
.claude-sessions-memory/
.mxm-skills/
.mxm-operator-profile/
.mxm-executive-summary/
.claude.local/
documents/architecture/
```

### Step 8 — Sync global context

Call `mxm-portfolio.sync_portfolio` to register the new project in `.mxm-global/`.
If the MCP tool isn't available: manually add a row to `.mxm-global/PORTFOLIO-METRICS.md` and a line to `.mxm-global/portfolio-registry/project_state.md`.

### Step 9 — Report

```
PROJECT BOOTSTRAPPED: [PROJECT_NAME]
  Path: [PROJECT_PATH]
  Maxim: [version]
  Compliance: [frameworks]
  Files created: [count]
  Global registry: [updated/manual update needed]
  Next: Open [PROJECT_PATH] in Claude Code to start development
```
