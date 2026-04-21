# /mxm-update

## Usage
- Claude Code: `/mxm-update`
- Claude CLI: `claude "/mxm-update"`
- Claude Desktop: type `/mxm-update` in chat

Updates the current project's Maxim configuration to the latest version. Reads ALL existing project data before making changes. Never overwrites user data.

**Triggers:** "update maxim", "upgrade maxim", "migrate project", "maxim update"

## Behavior

### Step 1 — Detect versions

1. Read `config/project-manifest.json` → extract `mxm_version` (current installed version)
2. Read `config/agent-registry.json` → extract `version` (target version from Maxim source)
3. If current == target: output the following and stop:
   ```
   Project is already up to date (v[version]). Run /mxm-status for full health check.
   ```
4. If current < target: proceed to Step 2
5. If either file is missing: note the gap and proceed to Step 2 with version shown as `unknown`

### Step 2 — Full project intelligence scan

Before touching anything, read and report on ALL of the following if they exist.

**Core config:**
- `config/project-manifest.json` — parse all fields, note which sections are present vs missing
- `CLAUDE.project.md` — check which sections from the template are filled in vs placeholder
- `config/agent-registry.json` — check version field

**Planning state (check ALL naming variants):**
- `task_plan.md` (project root)
- `progress.md` (project root)
- `findings.md` (project root)
- `planning/*.md` (any files in planning/)
- `*-planning/*.md` (any planning variant directories)
- `mxm-architecture/planning/*`

**Claude memory and sessions (check ALL naming variants):**
- `.claude-sessions-memory/handoff.md`
- `.claude-sessions-memory/decision-log.md`
- `.claude-sessions-memory/skill-gaps.log`
- `.claude-sessions-memory/session-*.md` (list all found)
- `claude-memory/` (any files in variant directory)
- `documents/ledgers/SESSION_CONTINUITY.md`

**Maxim runtime:**
- `.mxm-skills/agents-skill-gaps.log` — count total entries, count Maxim-UNENHANCED entries
- `.mxm-skills/agents-handoff.md` — check status field (BLOCKED / PARTIAL / FAILED / none)
- `.mxm-skills/agents-session-*.md` — list all session files found with dates
- `platform/.mxm-skills/` — check if monorepo variant exists

**Project phase docs:**
- `PHASE*_CLI_INSTRUCTIONS.md` (any matching pattern)
- `V1_SPRINT*_CLI_INSTRUCTIONS.md` (any matching pattern)

**Manifest-referenced documents:**
- If `config/project-manifest.json` has a `documents` section, verify each declared path exists on disk
- Report any declared document paths that are missing

### Step 3 — Display gap report

Output a structured gap report BEFORE making any changes:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Maxim UPDATE SCAN  ·  [project-id]  ·  [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Current Maxim Version : [mxm_version from manifest or "unknown"]
  Target Maxim Version  : [version from agent-registry.json or "unknown"]
  Upgrade Required     : YES | NO

MANIFEST FIELDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Present  : [list sections found]
  Missing  : [list sections absent vs template — tech_stack.frontend, domains, development, documents, etc.]

MISSING PROJECT FILES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [list each missing directory or file that will be created]
  e.g. .claude-sessions-memory/  — will create
       .mxm-skills/agents-skill-gaps.log      — will create (empty)
       .gitignore (Maxim entries) — will merge

PLANNING FILE STATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Found: [list all planning files discovered and their locations]
  Duplicates: [flag if task_plan.md found in multiple locations]

SKILL GAP SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total entries    : [n]
  Maxim-UNENHANCED  : [n]
  Open handoff     : [BLOCKED | PARTIAL | FAILED | none]

SUGGESTED FIELD VALUES (inferred from existing project data)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [List any [TBD] fields where a value can be inferred from existing files]
  e.g. development.github_repo → "DrNabeelKhan/your-repo" (inferred from git config)

CHANGES TO BE APPLIED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. Backup config/project-manifest.json → config/project-manifest.backup.json
  2. Backup CLAUDE.project.md → CLAUDE.project.backup.md
  3. Add missing manifest sections with [TBD] placeholders
  4. Bump mxm_version: [current] → [target]
  5. Create missing directories: [list]
  6. Create missing runtime files: [list]
  7. Merge duplicate planning files → .claude-sessions-memory/
  8. Update .gitignore with Maxim entries
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Then ask: "Apply these changes? (yes / no / show me the manifest diff first)"

- If "show me the manifest diff first": output the full before/after JSON diff for `config/project-manifest.json` only, then re-ask.
- If "no": stop. Output "Update cancelled. No files were changed."
- If "yes": proceed to Step 4.

### Step 4 — Confirm and apply

Execute in this exact order:

1. **Backup manifest** — copy `config/project-manifest.json` → `config/project-manifest.backup.json`
2. **Backup CLAUDE.project.md** — copy `CLAUDE.project.md` → `CLAUDE.project.backup.md` (if file exists)
3. **Merge manifest** — open `config/project-manifest.json` and:
   - Preserve ALL existing field values without modification
   - Add any missing top-level sections from the current template (`tech_stack.frontend`, `tech_stack.backend`, `tech_stack.infrastructure`, `domains`, `development`, `documents`) with `[TBD]` placeholder values
   - Bump `mxm_version` to the target version from `agent-registry.json`
   - Update `manifest_version` to `"1.1.0"` if currently below that
   - Update `last_updated` to today's date (YYYY-MM-DD)
   - Validate the resulting JSON is well-formed before writing
4. **Create missing directories** — create `.mxm-skills/` and `.claude-sessions-memory/` if absent
5. **Create missing runtime files** — create empty versions of:
   - `.mxm-skills/agents-skill-gaps.log` (if absent)
   - `.mxm-skills/agents-handoff.md` with status: none (if absent)
6. **Merge duplicate planning files** — if `task_plan.md` or `progress.md` exist in multiple locations, consolidate content into `.claude-sessions-memory/` and leave a redirect note at the duplicate location
7. **Update .gitignore** — ensure the following Maxim entries are present (append if missing, never duplicate):
   ```
   # Maxim runtime
   .mxm-skills/agents-session-*.md
   .claude-sessions-memory/session-*.md
   config/project-manifest.backup.json
   CLAUDE.project.backup.md
   ```
8. **Validate JSON** — read back `config/project-manifest.json` and confirm it parses without error

If any step fails, report the failure, restore from backup, and stop.

### Step 5 — Output completion

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Maxim UPDATE COMPLETE  ·  [project-id]  ·  [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Version       : [old] → [new]
  Files created : [list]
  Fields added  : [list of new manifest keys]
  .gitignore    : [updated | already current]
  Backups       : config/project-manifest.backup.json
                  CLAUDE.project.backup.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Next: Run /mxm-status to verify full system health.
Fill in any [TBD] fields in config/project-manifest.json and CLAUDE.project.md.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟢 HIGH · Maxim update applied cleanly
```

### Tag output: 🟢 HIGH
