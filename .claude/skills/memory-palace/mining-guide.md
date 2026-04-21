# MemPalace Mining Guide — What to Mine, What to Skip

> This guide defines what files MemPalace should index for Maxim projects.
> MemPalace respects .gitignore — exclusions go there.

---

## Mining Principle

**Mine only what Maxim creates, accesses, and reasons about.**
Skip everything that's generated, vendored, binary, or throwaway.

---

## What TO Mine (text files Maxim agents read/write)

| File Type | Examples | Why |
|---|---|---|
| Architecture docs | `documents/architecture/*.md` — PRD, FRD, SRD, ARCHITECTURE.md | Core project decisions |
| Business docs | `documents/business/*.md` — investor narrative, financial models | CEO/strategy context |
| Project config | `config/project-manifest.json`, `CLAUDE.project.md` | Project identity |
| Maxim runtime | `.mxm-skills/agents-*.md`, `.mxm-skills/agents-*.log` | Skill gaps, handoffs |
| Session memory | `.claude-sessions-memory/*.md` | Cross-session context |
| Root docs | `README.md`, `CHANGELOG.md`, `documents/ledgers/SESSION_CONTINUITY.md` | Project overview |
| API specs | `openapi.yaml`, `schema.prisma`, `*.sql` migrations | Technical contracts |
| CI/CD | `.github/workflows/*.yml` | Infrastructure decisions |
| PDF/PPTX/DOCX | `*.pdf`, `*.pptx`, `*.docx` in documents/ | Business documents |

## What to SKIP (add to .gitignore before mining)

| Folder/Pattern | Why |
|---|---|
| `community-packs/` | Vendored read-only skills — not your project content |
| `composable-skills/` | Workflow engine — generic, not project-specific |
| `ide-adapters/` | IDE config files — no semantic value |
| `tools/` | VoltAgent subagent catalog — reference, not project content |
| `community-packs/voltagent-subagents/` | VoltAgent categories — reference |
| `prototypes/` | Throwaway builds — mine only if you want historical context |
| `templates/` | Generic templates — not project-specific content |
| `node_modules/` | Dependencies — never mine |
| `.git/` | Git internals |
| `dist/`, `build/`, `.next/` | Build output |
| `__pycache__/` | Python cache |
| `.backup/` | Backup files |
| `*.png`, `*.jpg`, `*.gif`, `*.svg` | Images — can't be embedded as text |
| `*.woff`, `*.ttf`, `*.eot` | Fonts |
| `*.min.js`, `*.min.css` | Minified files |
| `package-lock.json`, `bun.lock` | Lock files — no semantic value |
| `FINAL_RELEASE_CHANGES/` | Historical sprint specs — already executed |

---

## Gitignore Entries for Mining

Add these to any project's `.gitignore` BEFORE running `mempalace mine`:

```gitignore
# MemPalace mining exclusions — skip non-essential content
community-packs/
composable-skills/
ide-adapters/
tools/subagent-catalog/
community-packs/voltagent-subagents/
prototypes/
templates/
node_modules/
dist/
build/
.next/
__pycache__/
.backup/
FINAL_RELEASE_CHANGES/
*.png
*.jpg
*.gif
*.svg
*.ico
*.woff
*.woff2
*.ttf
*.eot
*.min.js
*.min.css
package-lock.json
bun.lock
```

---

## Per-Project Mining Commands

**IMPORTANT:** MemPalace's `.gitignore` support only excludes files that are git-ignored
AND untracked. Folders like `community-packs/` and `composable-skills/` are tracked in git,
so `.gitignore` won't exclude them. **Mine specific subdirectories instead of whole repos.**

### maxim (the framework — 347 files, not 3,588)

```bash
# Initialize once
mempalace init --yes E:\Projects\Maxim\maxim

# Mine only Maxim-created content — skip community-packs/, composable-skills/, tools/, ide-adapters/
mempalace mine E:\Projects\Maxim\maxim\.claude\skills
mempalace mine E:\Projects\Maxim\maxim\.claude\commands
mempalace mine E:\Projects\Maxim\maxim\agents\Maxim
mempalace mine E:\Projects\Maxim\maxim\config
mempalace mine E:\Projects\Maxim\maxim\docs
mempalace mine E:\Projects\Maxim\maxim\bootstrap

# NEVER mine these:
# community-packs/           — 2,277 vendored files (read-only reference)
# composable-skills/  — 521 workflow engine files
# community-packs/voltagent-subagents/   — VoltAgent catalog
# ide-adapters/       — IDE config files
# tools/              — subagent catalog
# prototypes/         — throwaway builds
# templates/          — generic templates
```

### Other projects (mine the whole folder — they're smaller)

```bash
# mxm-simplification (skip prototypes/ if large)
mempalace init --yes E:\Projects\Maxim\mxm-simplification
mempalace mine E:\Projects\Maxim\mxm-simplification\architecture
mempalace mine E:\Projects\Maxim\mxm-simplification\business
mempalace mine E:\Projects\Maxim\mxm-simplification\config

# Small projects — mine the whole folder (few files)
mempalace init --yes E:\Projects\[PROJECT]
mempalace mine E:\Projects\[PROJECT]
```

---

## Expected Mining Scale (focused subdirectory approach)

| Project | Focused Scope | Files | Estimated Embeddings |
|---|---|---|---|
| maxim | .claude/skills, commands, agents/Maxim, config, docs, bootstrap | ~347 | ~4,000 |
| mxm-simplification | architecture/, business/, config/ | ~100 | ~1,500 |
| fixit-iservices-leads | config/, session memory | ~50 | ~500 |
| Maxim-Autobots | config/, session memory | ~20 | ~200 |
| **Total** | | **~517 files** | **~6,200 embeddings** |

Compare to unfocused whole-repo mining: 3,588 files → 52,040 embeddings (90% waste).

---

## Cross-Machine Mining

MemPalace's SQLite DB is portable. Mine on a faster machine, copy the DB:

```bash
# Mine on Mac (faster CPU)
pip install mempalace
mempalace init --yes /path/to/project
mempalace mine /path/to/project

# Copy DB to Windows
scp ~/.mempalace/palace/chroma.sqlite3 user@windows:~/.mempalace/palace/
```
