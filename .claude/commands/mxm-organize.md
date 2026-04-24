---
description: Reorganize project files, documents, and artifacts — dedupe policy, canonical-path enforcement, documents/ structure rebuild.
---

# /mxm-organize

## Usage
- Claude Code: `/mxm-organize`
- Claude CLI: `claude "/mxm-organize"`
- Claude Desktop: type `/mxm-organize` in chat

Organize an existing project folder to match Maxim bootstrap standard. Run this BEFORE starting development on any project that was bootstrapped but never organized.

**Triggers:** "organize project", "clean up folder", "organize folder", "fix project structure"

## Behavior

1. **Audit current structure** — list top-level contents, classify each as:
   - `Maxim standard` — belongs where it is
   - `Misplaced` — exists but wrong location
   - `Missing` — should exist per Maxim standard
   - `Project-specific` — source code, assets (leave in place)

2. **Check Maxim bootstrap completeness** — verify these exist (create if missing):

   | Required | Path |
   |---|---|
   | Manifest | `config/project-manifest.json` |
   | Project rules | `CLAUDE.project.md` |
   | Runtime state | `.mxm-skills/` (handoff, gaps, background, review-queue) |
   | Session memory | `.claude-sessions-memory/` |
   | Operator profile | `.mxm-operator-profile/` (4 files) |
   | Settings | `.claude.local/settings.local.json` (with Read+Edit+Write) |
   | Architecture | `documents/architecture/` |
   | Secrets | `documents/architecture/.secrets/` |
   | Business docs | `documents/business/` (if investor/financial docs exist) |
   | Prototypes | `prototypes/` (if prototype code exists) |
   | Gitignore | `.gitignore` (with Maxim entries) |
   | README | `README.md` |
   | Tasks | `TASKS.md` |

3. **Move misplaced files** to canonical locations:

   | File Type | Move TO | Common wrong locations |
   |---|---|---|
   | PRD, FRD, SRD, architecture docs | `documents/architecture/` | root, `planning/`, `*-planning/` |
   | API keys, credentials, build intakes | `documents/architecture/.secrets/` | root, `config/`, `.env` files |
   | Investor narrative, financial models | `documents/business/` | root, `planning/` |
   | Prototypes, v0 demos, POCs | `prototypes/` | root, `src/`, `apps/` |
   | Task plans, progress tracking | `.claude-sessions-memory/` | root, `planning/` |

   For each move: show what and where, move the file, update any references.

4. **Create README.md** if missing — from project manifest: name, description, tech stack, Maxim version, compliance.

5. **Create TASKS.md** if missing — check `.mxm-global/temp/GLOBAL_TODO_v6.md` for tasks tagged with this project. If found: extract them. If not: create empty with standard header.

6. **Verify .gitignore** — ensure Maxim entries present:
   ```
   .claude-sessions-memory/
   .mxm-skills/
   .mxm-operator-profile/
   .mxm-executive-summary/
   .claude.local/
   documents/architecture/
   ```

7. **Report:**
   ```
   ORGANIZE COMPLETE: [project-name]
     Bootstrap: [complete/partial — list missing]
     Files moved: [count] (from → to for each)
     Files created: [count]
     README: [created/existed]
     TASKS: [created with N tasks / created empty / existed]
     Gitignore: [updated/correct]
   ```

8. Tag output: HIGH
