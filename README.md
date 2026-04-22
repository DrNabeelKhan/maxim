# Maxim — the behavioral intelligence layer for Claude

> **Start at $19.99 with Solo. The behavioral intelligence specialist for Claude.**

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Agents](https://img.shields.io/badge/agents-88+-green)
![Frameworks](https://img.shields.io/badge/frameworks-78-orange)
![Skills](https://img.shields.io/badge/skill_domains-34-purple)
![Commands](https://img.shields.io/badge/commands-37-yellow)
![MCP](https://img.shields.io/badge/MCP_servers-7-teal)
![Tools](https://img.shields.io/badge/MCP_tools-47-teal)
![Hooks](https://img.shields.io/badge/hooks-10-gray)
![License](https://img.shields.io/badge/license-BSL_1.1-lightgrey)

---

## Install in 30 seconds

```
/plugin install maxim@anthropic-official
```

That command installs the full behavioral intelligence layer into Claude Code. 88+ agents across 7 executive offices. 34+ skill domains. 37+ slash commands. Three governance hooks that fire automatically. Four drift monitors running at 30-second cadence. One output style that enforces framework citation on every external-facing output.

**First session auto-installs 7 community packs** (150 VoltAgent specialists · Superpowers workflow patterns · Planning With Files · Claude Skills Library · UI/UX Pro Max · Higgsfield AI prompts · 59 brand design templates) via the `SessionStart` hook. Takes 1–2 minutes the first time; instant every session after. Requires `git` on PATH. Runs on macOS, Linux, and Windows with no configuration. To trigger a manual refresh (e.g. after a pack update):

```bash
# macOS / Linux
bash bootstrap/mxm-community-packs.sh

# Windows
pwsh -File bootstrap\mxm-community-packs.ps1
```

Commercial packs (L1 capabilities, L2 persona bundles, L3 verticals) install from the private marketplace after purchase:

```
/plugin marketplace add https://github.com/DrNabeelKhan/maxim
/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs
```

Pricing and catalog at https://maxim.isystematic.com.

---

## What Maxim Is

Maxim is a **behavioral intelligence layer** that runs on top of any AI model. It is not a prompt library. It is not a chatbot wrapper. It is a governed, multi-agent operating system with 88+ specialists, 34 skill domains, executive office routing, inter-agent handoff protocol, voice-driven invocation, RAG-backed knowledge graph, usage-aware scheduling, Proactive Watch drift detection, and behavioral science embedded at every layer.

The moat is not the tools. It is **Fogg Behavior Model, COM-B, EAST, Hook Model, and 64 peer-reviewed frameworks** baked into every skill, applied automatically rather than on request. Every output is confidence-tagged. Every security or compliance signal triggers the CSO auto-loop. Every release passes through a governed chain. Every document is treated as an Executable Contract with drift detection running on every session start.

Maxim works with Claude, GPT-4, Gemini, Mistral, or any local model. Swap `default_model_provider` in one config file.

---

## Why Enterprise

| Governance Feature | What It Does |
|---|---|
| **Ethics gates** | 7 agents require `ethics_required: true` pre-check before execution |
| **CSO auto-loop** | Security, compliance, PII signals automatically notify `security-analyst` — no request needed |
| **Compliance pre-enforcement** | `project-manifest.json` declares frameworks per project; agents enforce without being told |
| **Super User mode** | Maxim governance gates suppressed for declared identity — Claude's values layer unaffected |
| **Confidence tagging** | Every output tagged 🟢 HIGH · 🟡 MEDIUM · 🔴 LOW based on skill match and context quality |
| **Inter-agent handoff** | Structured `.mxm-skills/agents-handoff.md` protocol — agents pass state, not assumptions |
| **Session memory** | `.claude-sessions-memory/` stores handoff state, decisions, and skill gaps across sessions |

---

## Architecture

```
LAYER 1 — .claude/skills/          Maxim Domain Skills (Supreme Authority)
           33 domains · 63 frameworks · behavioral science on every output
           v1.0.0 added: wiki-ingest, wiki-query, wiki-lint, wiki-explore,
                         voice, junction-guard, usage-aware-scheduler

LAYER 2 — community-packs/                External Knowledge Base (read-only, vendored)
           claude-skills (536) · ui-ux-pro-max-skill (7) · higgsfield-* (40)
           awesome-design-md (59 brand templates)

LAYER 3 — composable-skills/       Workflow Engine
           superpowers/ · planning-with-files/ · frameworks/ (63)

LAYER 4 — agents/                  Agent Catalog
           88 Maxim agents · 150 VoltAgent specialists across 10 categories

LAYER 5 — mcp/                     MCP Servers (cross-surface intelligence)
           9 servers · 44 tools — auto-discovered via root .mcp.json
```

---

## Executive Offices

| Command | Office | Lead Agent | Activates For |
|---|---|---|---|
| `/mxm-ceo` | CEO | `enterprise-architect` | Strategy, vision, finance, enterprise architecture |
| `/mxm-cto` | CTO | `implementer` | Engineering, APIs, DevOps, AI, infrastructure |
| `/mxm-cmo` | CMO | `content-strategist` | Marketing, brand, SEO, content, GTM |
| `/mxm-cso` | CSO | `security-analyst` | Security, compliance, privacy, risk |
| `/mxm-cpo` | CPO | `product-strategist` | Product strategy, UX, UI, research |
| `/mxm-coo` | COO | `planner` | Operations, delivery, sprints |
| `/mxm-cino` | CINO | `innovation-researcher` | R&D, emerging tech, horizon scanning |
| `/mxm-route` | All | `executive-router` | Unknown intent — classify and route |
| `/mxm-wiki` | All | `wiki-*` skills | Knowledge ingestion + cross-project query (RAG on MemPalace, v1.0.0+) |
| `/mxm-voice` | All | `mxm-voice` MCP | Voice-driven office routing (Whisper STT + Kokoro TTS, v1.0.0+) |
| `/mxm-tasks` | All | scheduler | Usage-aware autonomous task scheduling (v1.0.0+) |

---

## Quick Start

**Windows (recommended) — Global install once, then per project:**

```powershell
# 1. Clone Maxim once
git clone https://github.com/DrNabeelKhan/maxim.git
cd maxim

# 2. Global install (run as Administrator — once only)
.\bootstrap\install-global.ps1

# 3. Bootstrap each new project (as Administrator)
.\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\YourProject" -ProjectName "Your Project"

# OR — from Claude Code / CLI (no PowerShell needed):
/mxm-new-project

# 4. Verify
/mxm-status
```

**Linux / CI — Subtree install:**

```bash
git subtree add --prefix=.mxm-skills \
  https://github.com/DrNabeelKhan/maxim.git main --squash
bash .mxm-skills/bootstrap/new-project-setup.sh
/route [describe your task]
```

See [`documents/guides/GETTING_STARTED.md`](documents/guides/GETTING_STARTED.md) for full setup. See [`documents/reference/MXM_INSTALL.md`](documents/reference/MXM_INSTALL.md) for adopter reference.

---

## Documentation

| Document | Purpose |
|---|---|
| [`documents/guides/GETTING_STARTED.md`](documents/guides/GETTING_STARTED.md) | Full install guide — global + subtree paths |
| [`documents/reference/MXM_INSTALL.md`](documents/reference/MXM_INSTALL.md) | One-page adopter reference — architecture, troubleshooting |
| [`documents/reference/MXM_COMMAND_MAP.md`](documents/reference/MXM_COMMAND_MAP.md) | All slash commands with examples |
| [`documents/reference/SKILLS_MAP.md`](documents/reference/SKILLS_MAP.md) | 33 skill domains with capability map |
| [`documents/reference/FRAMEWORKS_MASTER.md`](documents/reference/FRAMEWORKS_MASTER.md) | 63 behavioral frameworks |
| [`config/agent-registry.json`](config/agent-registry.json) | Full agent catalog (88 agents) |
| [`documents/ledgers/AGENT_SKILL_INVENTORY.md`](documents/ledgers/AGENT_SKILL_INVENTORY.md) | Authoritative inventory: every agent, skill, command, MCP tool, hook — updated on every count change |
| [`mcp/README.md`](mcp/README.md) | 9 MCP servers · 44 tools (auto-discovery via `.mcp.json`) |
| [`documents/reference/AGENTS.md`](documents/reference/AGENTS.md) | Downstream agent instructions (wiki + brand foundation usage, v1.0.0+) |
| [`documents/ledgers/MOAT_TRACKER.md`](documents/ledgers/MOAT_TRACKER.md) | Defensibility tracking + feature timeline |
| [`documents/governance/ETHICAL_GUIDELINES.md`](documents/governance/ETHICAL_GUIDELINES.md) | Governance layer |
| [`CLAUDE.md`](CLAUDE.md) | Universal Maxim operating standard |
| [`documents/templates/CLAUDE.project.TEMPLATE.md`](documents/templates/CLAUDE.project.TEMPLATE.md) | Blank per-project config template |
