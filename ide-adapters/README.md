# IDE Adapters

This folder contains IDE-specific hook configurations that activate the full Maxim 5-layer intelligence stack inside your development environment. All 16 adapters are supported.

---

## How This Folder Works

### Layer Source (Upstream)
Adapter hook scripts originate from **OthmanAdi/planning-with-files** and are synced here weekly (every Monday, 6AM UTC) via `sync-sources.yml` JOB 1. This provides the **Layer 3 baseline**: task state tracking, phase completion checks, and session recovery via `task_plan.md`.

### Maxim Overlay (Project-Time)
When you run the Maxim setup wizard (`bootstrap/new-project-setup.sh`), it patches all present adapter hook scripts with the **Maxim overlay** — a block that injects:
- Project identity and compliance flags from `config/project-manifest.json`
- The 5-layer dispatch reminder (Maxim skills first, then upstream sources)
- Active handoff status check from `.mxm-skills/agents-handoff.md`
- `CLAUDE.project.md` load reminder

The overlay is **idempotent** (safe to re-run) and marked with `# [Maxim-OVERLAY]` so it is never applied twice.

### Why Not Edit Directly
Do **not** edit files in this folder directly. The weekly sync (`rsync --delete`) will overwrite any manual changes. The correct places to change adapter behavior are:
1. **Maxim overlay** — edit `bootstrap/new-project-setup.sh` → `patch_ide_adapters()` function
2. **Upstream baseline** — changes come from OthmanAdi/planning-with-files automatically

---

## Supported IDEs (16 adapters)

| Adapter | IDE / Tool | Hook Type |
|---|---|---|
| `.cursor/` | Cursor | hooks.json + bash/ps1 scripts |
| `.gemini/` | Gemini Code Assist | hooks |
| `.kilocode/` | Kilocode | hooks |
| `.kiro/` | Kiro | hooks |
| `.codex/` | OpenAI Codex | hooks |
| `.continue/` | Continue.dev | hooks |
| `.claude-plugin/` | Claude Code Plugin | hooks |
| `.codebuddy/` | CodeBuddy | hooks |
| `.factory/` | Factory | hooks |
| `.mastracode/` | Mastra Code | hooks |
| `.openclaw/` | OpenClaw | hooks |
| `.opencode/` | OpenCode | hooks |
| `.adal/` | ADAL | hooks |
| `.agent/` | Agent | hooks |
| `.github/` | GitHub Copilot | hooks |
| `.pi/` | Pi | hooks |

**Claude Code (native):** No adapter needed. Claude Code auto-reads `CLAUDE.md` + `CLAUDE.project.md` + `.claude/skills/` at repo root.

---

## What the Maxim Overlay Injects

On every session start (`userPromptSubmit` hook), the patched adapter outputs:

```
[Maxim] Project: my-app | Model: anthropic
[Maxim] ⚠ COMPLIANCE ACTIVE — mandatory compliance loop on all agents   ← if regulated
[Maxim] ⚠ PAYMENT SCOPE — PCI-DSS checks active                        ← if payment
[Maxim] ⚠ HIPAA SCOPE — PHI controls + 90% coverage threshold active    ← if HIPAA
[Maxim] Dispatch: 1) .claude/skills/ → 2) community-packs/claude-skills-library/ → 3) composable-skills/ → 4) agents/ → 5) behavioral layer
[Maxim] Maxim skills win all conflicts. Flag unenhanced output: 🔴 Maxim-UNENHANCED. Log gaps to .mxm-skills/agents-skill-gaps.log
[Maxim] CLAUDE.project.md present — load project-specific rules before proceeding.
[Maxim] 🟢 Handoff: READY                                               ← if handoff active
```

On task stop (`stop` hook), if `.mxm-skills/agents-handoff.md` has a non-READY status:
```
[Maxim] 🔴 ESCALATION REQUIRED — escalate_to_human is set in .mxm-skills/agents-handoff.md
[Maxim] Handoff status: BLOCKED. Check .mxm-skills/agents-handoff.md before continuing. Next agent: implementer.
```

---

## Setup Instructions

### Option A — New Project (wizard runs patch automatically)
```bash
bash bootstrap/new-project-setup.sh
# Maxim overlay is applied automatically as part of setup
```

### Option B — Subtree Adoption (patch after add)
```bash
# After git subtree add:
git subtree add --prefix=maxim https://github.com/DrNabeelKhan/maxim.git main --squash

# Step 3c — patch IDE adapters:
bash maxim/bootstrap/new-project-setup.sh --patch-hooks-only
```

### Re-patch After Weekly Sync
The weekly sync restores the OthmanAdi baseline (`rsync --delete`). Re-apply the Maxim overlay after any sync:
```bash
bash bootstrap/new-project-setup.sh --patch-hooks-only
```

### Verify Patch is Active
```bash
bash bootstrap/new-project-setup.sh --validate-only
# Check 9: "IDE adapters: Maxim overlay confirmed"
```

---

## 5-Layer Architecture Reference

```
Layer 1: .claude/skills/           ← Maxim domain skills (Supreme Authority)
Layer 2: community-packs/claude-skills-library/   ← alirezarezvani deep knowledge base
Layer 3: composable-skills/        ← Workflow engine (superpowers + planning-with-files)
Layer 4: agents/                   ← Agent catalog (Maxim + VoltAgent)
Layer 5: IDE adapters (this folder) ← Where you work — activates Layers 1–4
```

The Maxim overlay ensures every IDE session starts with Layer 1–4 context loaded and active, not just Layer 3 task state.

---

**Source:** OthmanAdi/planning-with-files (baseline) + Maxim overlay (project-time patch)
**Sync:** Weekly Monday 6AM UTC via `.github/workflows/sync-sources.yml` JOB 1
**Overlay:** Applied by `bootstrap/new-project-setup.sh` → `patch_ide_adapters()`
**Maintained by:** DrNabeelKhan | iSimplification.io
