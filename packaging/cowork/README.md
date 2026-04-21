# maxim.plugin — Cowork Deployment

> Maxim's Claude.ai Cowork plugin. Ships ~85% fidelity of the full Claude Code deployment — everything except executable hooks and auto-file-reading.

**Version:** v1.0.0 · **Target surface:** Claude.ai Cowork

---

## What's In This Plugin

The `maxim.plugin` file (assembled per `ASSEMBLY.md`) bundles:

| Component | Count | Source |
|---|---|---|
| **Core skills** | 20 of 34 | `../../.claude/skills/` (subset — see `skills/MANIFEST.md`) |
| **Behavioral frameworks** | All 64 | `../../composable-skills/frameworks/` (reference library) |
| **Slash commands** | 14 of 37 | `../../.claude/commands/` (subset — see `commands/MANIFEST.md`) |
| **MCP connectors** | 7 | Consolidated from the 7 servers (post v1.0.0 merge) |
| **Project Instructions shim** | 1 | Embedded `documents/cross-surface/maxim-project-instructions.md` as fallback |

**Not included** (Cowork limitation):
- Executable hooks (`.claude/hooks/`) — Cowork doesn't execute shell scripts deterministically
- Full session-memory persistence — Cowork projects have their own isolation
- Proactive Watch LIGHT in SessionStart — run `/mxm-watch` manually

---

## Included Skills (20 of 34)

Selection criteria: skills that are surface-agnostic, have high user value, and don't depend on executable hooks.

**Executive office dispatchers (7):**
- ceo-automation, engineering, marketing, security, product, studio-operations, enterprise-architecture

**Domain intelligence (6):**
- brand, design, design-system, ui-styling, banner-design, slides

**Behavioral / meta (4):**
- behavior-science-persuasion, compliance, content-creation, product-development-research

**Operational (3):**
- proactive-watch, session-memory, operator-profile

**Skipped** (hook-dependent or CLI-only):
- junction-guard (Windows junctions — no Cowork equivalent)
- usage-aware-scheduler (depends on OAuth API + local scheduler)
- voice (depends on local voicemode binary)
- wiki-* (4 skills — depend on MemPalace MCP; shipped as connector)
- memory-palace (shipped as connector)
- testing (CI-dependent)
- deprecated (internal)

The skipped skills are replaced by **Cowork connectors** where equivalent capability exists, or by **advisory-only versions** for hook-dependent skills.

---

## Included Commands (14 of 37)

Every office shortcut + the discipline commands:

- `/mxm-ceo`, `/mxm-cto`, `/mxm-cmo`, `/mxm-cso`, `/mxm-cpo`, `/mxm-coo`, `/mxm-cino` — office routing
- `/mxm-route` — executive router
- `/mxm-watch` — drift detection (manual invoke, no auto SessionStart)
- `/mxm-session-end` — 9-doc closure bundle (advisory in Cowork — you run it mentally)
- `/mxm-update` — capability sync
- `/mxm-release` — release flow (advisory — actual release happens in CLI)
- `/mxm-help`, `/mxm-status` — introspection

Skipped commands: `/mxm-ceo-morning`, `/mxm-ceo-overnight`, `/mxm-ceo-setup` (depend on scheduler); `/mxm-voice` (depends on voicemode); `/mxm-wiki` subcommands (depend on MCP).

---

## Included MCP Connectors (7 of 7)

Post v1.0.0 consolidation — 9 servers merged to 7:

| Connector | Tools | Purpose |
|---|---|---|
| `mxm-context` | 13 (was 6) | Architecture / manifest / decision log / session memory + design refs (absorbed) + `watch_run` / `watch_report` / `watch_configure` |
| `mxm-catalog` | 9 (was dispatch 5 + skills 4) | Agent + skill + command + office catalog; `list_*` + `get_*` + `route_task` |
| `mxm-behavioral` | 5 | Framework selection, behavioral audit, nudge design |
| `mxm-compliance` | 5 | Framework compliance, ROPA generation, jurisdiction reqs |
| `mxm-memory` | 4 | Cross-session memory, recent decisions, search, store |
| `mxm-portfolio` | 7 | Portfolio overview, investor profile, project registry, tasks, sync |
| `mxm-voice` | 4 | Voice-driven dispatch (wraps voicemode where available; no-op otherwise) |

**Total tools: 47** (up from 44 in v1.0.0 despite fewer servers — the 3 new watch tools net out against consolidation efficiency).

---

## Fidelity Caveats

| Feature | CLI | Cowork via Plugin | Degradation |
|---|---|---|---|
| Behavioral layer | 🟢 | 🟢 | None |
| Office routing | 🟢 | 🟢 | None |
| CSO auto-loop | 🟢 | 🟢 | None |
| Confidence tagging | 🟢 | 🟢 | None |
| Slash commands | 🟢 (37) | 🟡 (14) | Hook-dependent commands absent |
| MCP servers | 🟢 (7) | 🟢 (7) | All tools work |
| Executable hooks | 🟢 | 🔴 | **Advisory only** |
| Auto file loading | 🟢 | 🟡 | User uploads manually |
| Session memory | 🟢 | 🟡 | Cowork-scoped, not per-project |
| Proactive Watch | 🟢 auto | 🟡 manual | Run `/mxm-watch` explicitly |

**Users who need 100% fidelity must use Claude Code CLI/IDE.** The plugin is for team workspaces and remote environments where repo-cloning isn't available.

---

## Installation

```
1. Download maxim.plugin (built from this directory per ASSEMBLY.md)
2. Open Claude.ai Cowork → Settings → Plugins → Install from file
3. Select maxim.plugin
4. Restart the Cowork session
5. Maxim skills activate automatically on trigger phrases
6. Upload your CLAUDE.md / project-manifest.json / .brand-foundation/ files
   to give Maxim project-specific context
```

### Customization

Cowork plugins can be customized per-organization:
- Use the `cowork-plugin-customizer` skill to rebrand, trim skills, or add connectors
- Commercial users may replace `maxim` branding with their own
- Behavioral layer + CSO auto-loop + confidence tagging remain non-negotiable per Maxim licensing

---

## Files in This Directory

| File | Purpose |
|---|---|
| `README.md` | This file — plugin overview + fidelity |
| `ASSEMBLY.md` | How to build the `.plugin` file from source |
| `plugin.json` | Plugin manifest (loaded by Cowork at install time) |
| `skills/MANIFEST.md` | Which skills are bundled |
| `commands/MANIFEST.md` | Which commands are bundled |

The actual `.plugin` file is **not** committed to the repo — it's built at release time and published as a GitHub release artifact. This directory holds the **source + manifest + assembly instructions**.

---

## Related

- `documents/cross-surface/maxim-surface-guide.md` — three-tier deployment overview
- `documents/cross-surface/maxim-project-instructions.md` — Web / Desktop alternative
- `documents/reference/MXM_INSTALL.md` — Code CLI / IDE alternative
- ADR-002 — Executable Contracts (cross-surface drift enforcement)
- `cowork-plugin-management:create-cowork-plugin` skill — plugin creation tooling
- `cowork-plugin-management:cowork-plugin-customizer` skill — per-org customization
