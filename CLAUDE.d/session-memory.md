# CLAUDE.d / Session & Memory Storage

> Loaded by `CLAUDE.md` as a reference module. Contains the FULL Session Start
> Protocol, Session End Protocol, Memory Junction Auto-Heal, Data Flow Rule,
> Auto-Inventory Protocol, Staleness Prevention Protocol, and Version Sync Protocol.
>
> Critical summary lives in `CLAUDE.md`. This file is the operational detail.

---

## 📁 Storage Location Map

| What to store | Write to | Never write to |
|---|---|---|
| Active task plan | `./task_plan.md` | Maxim repo / global |
| Progress tracking | `./progress.md` | Maxim repo / global |
| Session summary | `./.mxm-skills/agents-session-[YYYY-MM-DD].md` | Maxim repo / global |
| Skill gap log entry | `./.mxm-skills/agents-skill-gaps.log` | Maxim repo / global |
| Agent handoff state | `./.mxm-skills/agents-handoff.md` | Maxim repo / global |
| Background agent log | `./.mxm-skills/agents-background.log` | Maxim repo / global |
| Review queue | `./.mxm-skills/review-queue.md` | Maxim repo / global |
| Compliance notes | `./.mxm-skills/agents-compliance-notes.md` | Maxim repo / global |
| Decision log | `./.mxm-skills/agents-decision-log.md` | Maxim repo / global |
| Any scratch / working file | `./.mxm-skills/agents-scratch-[topic].md` | Maxim repo / global |
| Architecture docs (PRD, FRD, SRD) | `./documents/architecture/` | root, `planning/`, random folders |
| Build intakes, API keys, credentials | `./documents/architecture/.secrets/` | root, `config/`, committed files |
| Business docs (investor, financial) | `./documents/business/` | root, random folders |
| Prototypes, POCs, v0 demos | `./prototypes/` | root, `src/`, `apps/` |

---

## Project Folder Detection

At the start of every session, determine the current working project folder:

1. Check if `config/project-manifest.json` exists in the current folder → this IS the project root
2. If not found, search parent directories up to 3 levels → use first match
3. If still not found → **prompt the user** before creating any files:
   ```
   ⚠️  No config/project-manifest.json found in this folder or parent directories.
       Is this a new project? Run:
         .\bootstrap\link-local-project.ps1 -ProjectPath "<this folder>"
       Or confirm the project root path before I create any files.
   ```
4. **Never silently write files to an unidentified location**

---

## Memory Junction Auto-Heal (every session start)

After detecting the project root, verify the memory junction exists:

1. Compute Claude project key: project root path → strip `:` → replace `\` and `/` with `-`
2. Check `$HOME/.claude/projects/{key}/memory/`
   - If it is a **real directory** (not a junction): migrate files to `.claude-sessions-memory/` → delete dir → create junction
   - If it is **absent**: create `.claude-sessions-memory/` in project root if needed → create junction
   - If it is already a **junction**: verify target is `.claude-sessions-memory/` in project root
3. If target mismatch: report it, do NOT auto-fix (ask user first)
4. Never write session memory to a real `memory/` directory — only through the junction

---

## Session Start Protocol (full 11-step flow)

When Claude Code opens a folder or starts a new session:

1. Detect project root (rule above)
2. Verify memory junction (rule above)
3. Read `config/project-manifest.json` → load project identity, compliance scope, lifecycle status, gated flag.
   **Note:** `config/agent-registry.json` is plugin-level only — absent in user projects is **correct and expected**. Read it from `$CLAUDE_PLUGIN_ROOT/config/agent-registry.json` if needed. Do NOT surface a warning about its absence in non-plugin-repo projects.
4. **Gate check** — if `status.lifecycle == "archived"` → refuse work and exit
5. **Gate check** — if `status.gated == true` → require explicit user approval before any action
6. Read `CLAUDE.project.md` if present → load project-specific rules
7. Read `documents/ledgers/SESSION_CONTINUITY.md` → load session bridge
8. Check `.mxm-skills/agents-handoff.md` → report any BLOCKED/PARTIAL/FAILED state before proceeding
9. Check `.mxm-skills/agents-skill-gaps.log` → surface open gaps
10. Check `.mxm-skills/review-queue.md` → count PENDING items, report count
11. Check `.claude-sessions-memory/` → load session memory (`MEMORY.md`, `project_current_state.md`, `handoff.md`)
12. Check `task_plan.md` / `progress.md` → report active task if present
13. Output session start summary (one block, see `CLAUDE.md` for format)

The deterministic version of this flow runs as `.claude/hooks/session-start.{sh,ps1}` (executable hook). The skill-level protocol above runs after the hook for judgment-based steps.

---

## Session End Protocol (full 12-step flow)

Runs on `/mxm-release` or task completion:

1. Write `.claude-sessions-memory/session-[YYYY-MM-DD].md` with:
   - Tasks completed this session
   - Decisions made and rationale
   - Files created/modified
   - Open items for next session
   - Skill gaps discovered
2. Update `.claude-sessions-memory/progress.md` with current state
3. Update `.claude-sessions-memory/project_current_state.md` with checkpoint
4. Update `.claude-sessions-memory/handoff.md` with session summary + open tasks
5. Append to `.claude-sessions-memory/feedback_debugging_playbook.md` if ANY errors occurred
6. Append to `.claude-sessions-memory/feedback_lessons_learned.md` if ANY retries/workarounds
7. Update `.claude-sessions-memory/MEMORY.md` index if new files created
8. Update `.mxm-skills/agents-handoff.md` if passing to another agent
9. Append any new gaps to `.mxm-skills/agents-skill-gaps.log`
10. Run auto-inventory: update `.claude-sessions-memory/file_inventory.md` (see auto-inventory.md)
11. Sync global context (if `.mxm-global/` accessible): call `mxm-portfolio.sync_portfolio` MCP tool OR manually update `.mxm-global/PORTFOLIO-METRICS.md` project row with current version, lifecycle, market, gated flag, and last activity date
12. Confirm: "Session memory saved to [project root]/.claude-sessions-memory/"

> **Session without memory writes = session wasted.** This is NOT optional.

---

## Data Flow Rule (applies to all users)

```
Project sessions  → write project-level memory at session end (steps 1-10 above)
                  → update .mxm-global/ from project state (step 11 — READ project, WRITE global)
CEO automation    → READ local project files → UPDATE .mxm-global/ (never reverse)
Scheduled sync    → READ all project manifests → UPDATE .mxm-global/ (catches dormant projects)

.mxm-global/ is a derived cache for cross-surface sharing (NEVER the source of truth)
Project-level files are ALWAYS the source of truth
NEVER write from .mxm-global/ back to project-level files
```

---

## Junction Read-Only Enforcement (NK universe rule)

When Maxim accesses its own repo through a junction (`.mxm-system\` or `.claude\` inside another project):

- ✅ **Reading** through junctions is ALLOWED
- ❌ **Writing** through junctions is FORBIDDEN
- ❌ **Deleting** through junctions is FORBIDDEN
- ❌ **Git commits** through junctions are FORBIDDEN

If a write is attempted through a junction path, refuse with: "Junction is read-only. Open the source repo at `E:\Projects\Maxim\maxim\` directly to make changes."

---

## Auto-Inventory Protocol

On every session end, run the file inventory scan (`.claude/skills/session-memory/auto-inventory.md`):

1. Scan project for architecturally significant files
2. Diff against existing `.claude-sessions-memory/file_inventory.md`
3. Write updated inventory with ADDED/MODIFIED/REMOVED changes
4. Sync new entries to `reference_key_files.md`
5. Check for version drift — if any version mismatch detected, warn user

---

## Staleness Prevention Protocol

On every session end, after memory writes, prevent global staleness via two mechanisms:

**Mechanism 1 — Session-end sync (Option C, runs every session):**
Step 11 of Session End Protocol calls `mxm-portfolio.sync_portfolio` MCP tool (if available) OR manually updates the current project's row in `.mxm-global/PORTFOLIO-METRICS.md`. Keeps global context fresh for every project actively worked on.

**Mechanism 2 — Scheduled daily sync (Option B, runs once/day):**
The `mxm-global-sync` scheduled task runs daily before the CEO morning cycle. It calls `sync_portfolio` which scans ALL project manifests and updates `.mxm-global/` — catching dormant projects not opened recently.

**Current working project (full check):**
1. `.mxm-global/TASKS.md` — are there completed tasks not marked done? Mark them.
2. `.mxm-global/` — call `sync_portfolio` MCP tool (updates PORTFOLIO-METRICS.md and project_state.md automatically)
3. `.claude-sessions-memory/file_inventory.md` — run auto-inventory diff (see above).
4. Version sync — run `bootstrap/sync-version.ps1 -WhatIf` to check for drift across README, HELP, SKILLS_MAP, SESSION_CONTINUITY, MXM_COMMAND_MAP, new-project-setup.sh. If mismatch found, warn user and suggest running sync-version.

**Other portfolio projects (automatic):**
The `sync_portfolio` tool scans all projects under `MXM_PROJECTS_ROOT` (default: `E:/Projects`). No manual per-project checks needed — the tool reads each manifest and updates global state. Skips `lifecycle: archived`. Flags `gated: true`. Surfaces `lifecycle: needs_update`.

---

## Version Sync Protocol (maxim repo only)

Before any release commit, run `bootstrap/sync-version.ps1` (or `.sh`):
1. Reads version from `config/agent-registry.json` (single source of truth)
2. Propagates to: README badge, HELP header/footer, MXM_COMMAND_MAP footer, SKILLS_MAP, SESSION_CONTINUITY, new-project-setup.sh
3. Reports: which files updated, which already current, which missing
4. Prevents the 8-file manual version update that causes drift

```powershell
.\bootstrap\sync-version.ps1                       # sync current version
.\bootstrap\sync-version.ps1 -NewVersion "6.4.0"   # bump + sync
.\bootstrap\sync-version.ps1 -WhatIf               # dry run
```

---

## Multi-Project Safety Rule

If multiple projects are open simultaneously (multiple VS Code/Claude Code windows):
- Each session writes ONLY to its own project folder
- Never cross-write between projects
- Project identity is determined by the folder Claude Code was opened in
- If ambiguous, ask: "Which project is this session for?"

**One named exception (ADR-013):** a child project MAY append one line to
`<parent>/.claude-sessions-memory/children-rollup.md` at session end. This is
the only allowed cross-project write. All other cross-writes remain forbidden.

---

## Multi-Project Inheritance Protocol (ADR-013)

> Ratified 2026-05-13. Governs parent/child topology declared in `config/project-manifest.json` → `topology`.

### Topology kinds

| `topology.kind` | Meaning | Session-start behavior | Session-end behavior |
|---|---|---|---|
| `standalone` (default) | No inheritance. Current behavior unchanged. | Normal | Normal |
| `parent` | Declares child projects. Reads their states. | Aggregate children dashboard in SESSION START output | Normal |
| `child` | Belongs to a parent. Reports up. | Normal | Append rollup line to parent's `children-rollup.md` |

Container directories (no `config/project-manifest.json`) are invisible — not a topology kind, no configuration needed.

### Session-start step 11.5 — Parent dashboard

Runs ONLY when `topology.kind == "parent"`, after step 11 (load session memory), before printing the summary.

```
For each path in topology.children:
  1. Read <child>/.mxm-skills/agents-handoff.md → extract status line
  2. Read <child>/.claude-sessions-memory/children-rollup.md → extract last line
  3. Build one display row: "<child-id>  <status-emoji>  <status>  <date>  <summary>"
  4. Inject into SESSION START output under "Children:" section
  5. Fail-soft: if child path missing, no manifest, or no memory files → show "⚪ NO DATA", continue
  6. NEVER block session start on missing child data
```

Output format:
```
Maxim SESSION START
  Project   : parent-project-id
  Root      : E:\Projects\nabeelkhan
  Handoff   : READY
  Open gaps : 0
  Children  :
    vazir      🟢 READY      2026-05-13  voice pipeline + TTS
    project-b  🟡 PARTIAL    2026-05-12  auth flow in progress
    project-c  ⚪ NO DATA
```

### Session-end corollary — Child rollup

Runs ONLY when `topology.kind == "child"` and `topology.parent` is a non-null path.

```
1. Resolve <parent>/.claude-sessions-memory/children-rollup.md
2. Read .mxm-skills/agents-handoff.md → extract status (default: "READY")
3. Read .claude-sessions-memory/handoff.md → extract last non-empty line as summary
4. Append ONE line to parent's children-rollup.md:
   [YYYY-MM-DDTHH:MM:SSZ] | <project-id> | <status> | <one-line-summary>
5. Fail-soft: if parent path missing, or write fails → log warning to
   .mxm-skills/agents-skill-gaps.log and exit normally
6. NEVER block session end on rollup failure
```

### Cross-write rule (amendment to Multi-Project Safety Rule)

| Write direction | Allowed |
|---|---|
| Child → `<parent>/.claude-sessions-memory/children-rollup.md` (append only) | ✅ ALLOWED — the only named exception per ADR-013 |
| Parent → any child file | ❌ FORBIDDEN |
| Sibling → sibling | ❌ FORBIDDEN |
| `.mxm-global/` sync (existing) | ✅ ALLOWED — governed by separate data-flow rule |

### Configuring a parent project

In `config/project-manifest.json`:

```json
"topology": {
  "kind": "parent",
  "children": [
    "E:/Projects/nabeelkhan/VAZIR",
    "E:/Projects/nabeelkhan/other-project"
  ],
  "parent": null
}
```

### Configuring a child project

```json
"topology": {
  "kind": "child",
  "children": [],
  "parent": "E:/Projects/nabeelkhan"
}
```

### What a container directory looks like

`E:\Projects\ARIA\` has no `config/project-manifest.json` → it is invisible to
Claude Code's project detection. Projects inside it (`aria-simplification`) are
standalone. No topology configuration needed in container directories.
