# Existing Project — Folder Organization

> **Usage:** Paste this into Claude Code when opening an existing project that needs cleanup.
> Replace `[PROJECT_PATH]` with the project path (e.g., `E:\Projects\FixIt`).
> Replace `[PROJECT_NAME]` with the display name.
>
> Run this BEFORE any development work on existing projects.

---

## Prompt

Organize the folder structure for **[PROJECT_NAME]** at `[PROJECT_PATH]` to match the Maxim bootstrap standard.

### Step 1 — Audit current structure

List the top-level contents of `[PROJECT_PATH]`. For each item, classify as:
- **Maxim standard** — belongs where it is (config/, documents/, .mxm-skills/, .claude-sessions-memory/, etc.)
- **Misplaced** — exists but in the wrong location
- **Missing** — should exist per Maxim standard but doesn't
- **Unknown** — project-specific files (source code, assets, etc.) — leave in place

### Step 2 — Check Maxim bootstrap completeness

Verify these exist (create if missing):

| Required | Path | Create if missing? |
|---|---|---|
| Manifest | `config/project-manifest.json` | YES — from template |
| Project rules | `CLAUDE.project.md` | YES — from template |
| Runtime state | `.mxm-skills/` (4 files) | YES |
| Session memory | `.claude-sessions-memory/` | YES |
| Operator profile | `.mxm-operator-profile/` (4 files) | YES |
| Settings | `.claude.local/settings.local.json` | YES — with Read+Edit+Write |
| Architecture | `documents/architecture/` | YES (empty is OK) |
| Secrets | `documents/architecture/.secrets/` | YES (empty is OK) |
| Business docs | `documents/business/` | YES if investor/financial docs exist |
| Prototypes | `prototypes/` | YES if prototype code exists |
| Gitignore | `.gitignore` | YES — with Maxim entries |
| README | `README.md` | YES |
| Tasks | `TASKS.md` | YES |

### Step 3 — Move misplaced files

Apply these canonical location rules:

| File Type | Move TO | Move FROM (common wrong locations) |
|---|---|---|
| PRD, FRD, SRD, architecture docs | `documents/architecture/` | root, `planning/`, `*-planning/`, `architecture/` |
| API keys, credentials, build intakes | `documents/architecture/.secrets/` | root, `config/`, `.env` files |
| Investor narrative, financial models | `documents/business/` | root, `planning/` |
| Prototypes, v0 demos, POCs | `prototypes/` | root, `src/`, `apps/` |
| Task plans, progress tracking | `.claude-sessions-memory/` | root, `planning/` |

For each move:
1. Show what's being moved and where
2. Move the file
3. If the original location had a README or index pointing to it, update the reference

### Step 4 — Create README.md (if missing)

Generate from project manifest:
- Project name and description
- Tech stack (from manifest or inferred from package.json/pyproject.toml)
- Maxim integration: version, compliance frameworks, key commands
- Getting started: how to run/develop locally

### Step 5 — Create TASKS.md (if missing)

If `E:\Projects\.mxm-global\temp\GLOBAL_TODO_v6.md` has tasks for this project:
- Extract them into `[PROJECT_PATH]/TASKS.md`
- Use the standard table format: `| # | Task | Priority | Due | Status |`

If no tasks found: create empty TASKS.md with header only.

### Step 6 — Verify .gitignore

Ensure these Maxim entries are present (add if missing):
```
.claude-sessions-memory/
.mxm-skills/
.mxm-operator-profile/
.mxm-executive-summary/
.claude.local/
documents/architecture/
```

### Step 7 — Report

```
ORGANIZATION COMPLETE: [PROJECT_NAME]
  Maxim bootstrap: [complete/partial — list missing items]
  Files moved: [count] (list each: from → to)
  Files created: [count] (list each)
  README: [created/already existed]
  TASKS: [created with N tasks / created empty / already existed]
  Gitignore: [updated/already correct]
  Next: Run global sync to update .mxm-global/ with this project's state
```
