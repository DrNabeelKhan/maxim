# How to Use Maxim in Your Environment

> **Version:** v1.3.0 · **Audience:** Anyone who installed Maxim

---

## What Is Maxim? (SCQA framing)

**Situation:** You use Claude to ship work. Code · docs · pitches · compliance posture · marketing copy · research synthesis · everything.

**Complication:** Out of the box, Claude gives you ungrounded outputs. No framework citation. No drift detection. No structural compliance enforcement. No audit trail. No voice consistency. Generic-LLM "looks good" answers that don't survive operator review.

**Question:** How do you keep Claude's productivity without losing the rigor your work requires?

**Answer:** Maxim is a behavioral intelligence layer that runs on top of Claude. It adds **91 specialist agents** routed through 7 executive offices (24 dispatchable + 67 specialist catalog via mxm-catalog MCP per ADR-017) · **37 skill domains** · **78 peer-reviewed behavioral frameworks** dispatched per task · **14 compliance frameworks** enforced at the MCP layer · **9 MCPs (95 tools)** including NotebookLM research synthesis · **13 drift classes** scanning every session start · **structural framework citation** on every output (ADR-007) · **confidence tag** on every output (ADR-010). Every emission Maxim ships is grounded, audited, and traceable.

**v1.3.2 multi-tenant readiness + coherence:** the install wizard defaults to **90-day Trial** of all 14 packs (no card required). v1.3.2 ships full capability-count coherence across all operator-facing surfaces after pre-release-audit caught the 87→95 MCP tool undercount that had drifted through v1.2.0 → v1.3.1. See the moat work on your real work before deciding which tier to keep.

---

## Installation

### Windows (Recommended — Global Install)
```powershell
# Clone once, install globally
git clone https://github.com/DrNabeelKhan/maxim.git
cd maxim
.\bootstrap\install-global.ps1   # Run as Administrator (creates symlinks)
```

### Mac / Linux
```bash
git clone https://github.com/DrNabeelKhan/maxim.git
cd maxim
bash bootstrap/new-project-setup.sh
```

### Per-Project (any OS)
```powershell
.\bootstrap\link-local-project.ps1 -ProjectPath "C:\Your\Project"
```

### MCP Servers (optional but recommended)
```bash
cd mcp && for dir in maxim-*/; do (cd "$dir" && npm install); done
claude mcp add mxm-portfolio -s user -- node /path/to/maxim/mcp/mxm-portfolio/server.js
# Repeat for all 8 servers — see mcp/README.md for full config
```

---

## Claude Surface Routing

| Surface | Best For | How Maxim Activates |
|---|---|---|
| **Claude Code** (VS Code / Cursor) | Implementation, refactoring, file changes | CLAUDE.md loads automatically |
| **Claude Desktop** | MCP tools, cross-project decisions, memory graph | MCP servers + CLAUDE.md |
| **Claude CLI** | Automation, scheduling, CI/CD triggers | CLAUDE.md + named sessions |
| **Claude Cowork** | Business docs, investor content, persistent project context | Cowork plugin + project docs |
| **Claude Dispatch** | Scheduled tasks, overnight cycles | Scheduled tasks |
| **claude.ai** | Research, competitive analysis, ideation | No Maxim (use for research only) |

---

## Daily Workflow

### Morning (6 AM — automated or manual)
1. `/mxm-ceo-morning` — metrics digest, burn rate, team capacity, pipeline, customer health
2. Review queue triage (Task 0) — approve/defer synthesized skills and gap fixes
3. Pick highest-priority task from `/mxm-tasks next`

### Work Blocks
4. Open project in Claude Code → Maxim loads automatically
5. `/mxm-plan` → `/mxm-implement` → `/mxm-review` → `/mxm-test`
6. Session memory written automatically at session end

### Evening (2 AM — automated)
7. `/mxm-ceo-overnight` — strategy check, competitive audit, growth report, gap triage
8. Portfolio sync runs daily at 5:27 AM — global context fresh for next morning

---

## Key Commands (31 total)

| Command | What It Does |
|---|---|
| `/mxm-help` | Full command reference |
| `/mxm-status` | Current project state + Maxim version |
| `/mxm-route` | Route a task to the right office/agent |
| `/mxm-plan` | Create implementation plan |
| `/mxm-implement` | Execute plan |
| `/mxm-review` | Code/content review |
| `/mxm-test` | Test coverage |
| `/mxm-release` | Version bump + session end |
| `/mxm-ceo` | CEO office — strategy, finance, partnerships |
| `/mxm-cto` | CTO office — engineering, infrastructure |
| `/mxm-cmo` | CMO office — marketing, content, SEO |
| `/mxm-cso` | CSO office — security, compliance, privacy |
| `/mxm-cpo` | CPO office — product, UX, design |
| `/mxm-coo` | COO office — operations, delivery, support |
| `/mxm-tasks` | Global task management |
| `/mxm-portfolio` | Cross-project dashboard |
| `/mxm-remember` | Store to MemPalace |
| `/mxm-recall` | Search MemPalace |

---

## MCP Servers (8 servers, 42 tools)

| Server | Tools | Purpose |
|---|---|---|
| `mxm-portfolio` | 7 | Portfolio context + sync_portfolio |
| `mxm-context` | 6 | Per-project intelligence |
| `mxm-compliance` | 5 | Compliance-as-a-service |
| `mxm-behavioral` | 5 | Behavioral science engine |
| `maxim-dispatch` | 5 | Agent routing |
| `mxm-memory` | 4 | Unified memory search |
| `maxim-skills` | 4 | Skill catalog discovery |
| `maxim-design` | 4 | Brand design (59 templates) |

---

## Memory Architecture

Three layers, all working together:

| Layer | Storage | Persistence | Used By |
|---|---|---|---|
| **Session Memory** | `.claude-sessions-memory/` per project | File-based, across sessions | All agents |
| **MemPalace** | ChromaDB + knowledge graph | Semantic search + KG | `/mxm-remember`, `/mxm-recall` |
| **claude-mem** | ChromaDB vector store | Cross-session search | Plugin |

**Data Flow Rule:** Project sessions write to project-level memory. Global sync reads project files and updates `.mxm-global/`. Global is a derived cache — never the source of truth.

---

## CEO Automation

Setup: `/mxm-ceo-setup` on any project. Creates `.mxm-executive-summary/` with templates.

| Cycle | Schedule | What It Does |
|---|---|---|
| Morning | 6 AM weekdays | Metrics, burn rate, pipeline, customer health |
| Overnight | 2 AM weekdays | Strategy, competitive audit, growth report, gap triage |

---

## Prompts Library

Ready-to-use prompts in `templates/prompts/`:

| Prompt | Use Case |
|---|---|
| `PROMPT_health-check.md` | Verify full Maxim installation (8 layers) |
| `PROMPT_maxim-capabilities-demo.md` | Demo all 9 MCP servers |
| `PROMPT_project-global-sync.md` | Sync project state to global context |
| `PROMPT_new-project-setup.md` | Bootstrap a new Maxim project |
| `PROMPT_existing-project-organize.md` | Organize existing project folders |
| `PROMPT_ceo-automation-setup.md` | Set up CEO morning/overnight cycles |

---

## Getting Help

- `/mxm-help` — in-session command reference
- `documents/guides/HELP.md` — comprehensive user guide
- `documents/guides/GETTING_STARTED.md` — first-time setup
- `CONTRIBUTING.md` — how to contribute skills and agents