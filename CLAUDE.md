# Maxim — Master AI Instructions

> Model-agnostic. Provider-pluggable. Behaviorally intelligent. Governed by design.

**Governed by:** `config/project-manifest.json` | **Last Updated:** 2026-04-21 | **Version:** v1.0.0
**Project-Specific Rules:** `CLAUDE.project.md` | **Modular Includes:** `CLAUDE.d/`

---

## ⚡ ONE-LINER OPERATING SUMMARY (LLM bootstrap — read first)

```
🧭 Active project = the folder you opened. Equal priority to all others. TASKS.md sets today's work.
🤖 Every task = use Maxim dispatch sequence. Skill > External > Workflow > Behavioral.
🔐 Memory = .claude-sessions-memory/ (per-project) + MemPalace (semantic) + claude-mem (cross-session).
🚫 Never write through .mxm-system\ or .claude\ JUNCTIONS — read-only. Source of truth = the actual repo.
📊 Every output gets a confidence tag: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW | 🔵 SUPER USER | 🔐 GATED.
🛡️ Security/PII/regulated tasks auto-loop CSO (security-analyst). Cannot be bypassed.
🆔 Project identity = config/project-manifest.json. lifecycle: archived → refuse work. gated: true → require approval.
📦 Data flow: project → .mxm-global/ (one-way). NEVER write FROM .mxm-global/ back to project files.
✅ Session end = write memory, update inventory, sync portfolio. NOT optional.
🔁 Commit Protocol = auto-update CHANGELOG/HELP/SKILLS_MAP/MOAT when relevant files change.
```

---

## 🚨 MANDATORY: READ BEFORE ANY ACTION

This file is the **universal Maxim operating standard** — model-agnostic, project-agnostic, reusable across any project. Project identity, compliance requirements, and brand voice live in `CLAUDE.project.md` and `config/project-manifest.json`.

To adopt Maxim for a new project:
1. Copy `config/project-manifest.TEMPLATE.json` → `config/project-manifest.json` and fill in your project
2. Copy `CLAUDE.project.md` → author your project-specific overrides
3. Run `bootstrap/new-project-setup.sh` (see `documents/guides/GETTING_STARTED.md`)

---

## 🧠 WHAT Maxim IS

Maxim is a **behavioral intelligence layer** built on top of technical AI capabilities. Maxim's moat is not the tools it uses — it is the **behavioral science, persuasion frameworks, decision psychology, and cross-domain agent collaboration** baked into every skill.

Maxim skills do not just answer questions. They:
- Apply behavioral science triggers to every output (Fogg Behavior Model, COM-B, EAST)
- Select the right framework from 63+ in `documents/reference/FRAMEWORKS_MASTER.md` for the task context
- Route outputs through the right specialist agents proactively
- Tag every output with a confidence signal 🟢🟡🔴
- Flag compliance, risk, and escalation paths without being asked

**None of the external sources (alirezarezvani, ui-ux-pro-max-skill, superpowers, VoltAgent, planning-with-files) do any of this. Maxim is the only layer that does.**

---

## 📚 MODULAR INCLUDES (CLAUDE.d/)

CLAUDE.md was split in v1.0.0 from ~900 lines into a slim main + modular reference files. Consult these on demand:

| File | Contains |
|---|---|
| [`CLAUDE.d/session-memory.md`](CLAUDE.d/session-memory.md) | Storage map, project detection, junction auto-heal, full Session Start/End protocols, data flow, junction read-only enforcement, auto-inventory, staleness prevention, version sync, multi-project safety |
| [`CLAUDE.d/protocols.md`](CLAUDE.d/protocols.md) | **Documents as Executable Contracts (v1.0.0+)**, Commit Protocol, New Skill Domain Checklist, Build Target Protocol, File Deduplication Policy, Project Scaffold Standard, ADR Lifecycle Protocol |
| [`CLAUDE.d/dispatch.md`](CLAUDE.d/dispatch.md) | Domain Dispatch Table (24 domains incl. v1.0.0 wiki + voice), Conflict Resolution, Cross-Agent Collaboration, Confidence Tagging legend, Workflow Patterns |
| [`CLAUDE.d/office-catalog.md`](CLAUDE.d/office-catalog.md) | Full agent roster across 7 offices + orchestrators (90 agents) |
| [`documents/ADRs/`](documents/ADRs/) | **Architecture Decision Records (v1.0.0+)** — canonical ledger: INDEX.md, TEMPLATE.md, README.md, individual ADRs |
| [`CLAUDE.d/repo-map.md`](CLAUDE.d/repo-map.md) | Authoritative repo structure map + per-project structure |

These modules are LOADED ON DEMAND — Claude reads them when the task touches their domain. The critical rules below are sufficient for most sessions.

---

## 📁 SESSION & MEMORY STORAGE — CRITICAL SUMMARY

> **All session state, memory, logs, plans, and handoffs MUST be written to the current project folder.**
> **NEVER write session data to the Maxim source repo, %USERPROFILE%\.claude\, or any shared/global location.**
> **NEVER write through `.mxm-system\` or `.claude\` JUNCTIONS — they are read-only.**

This rule is absolute and applies in all install modes (GLOBAL, LEGACY-LOCAL, MIXED).

| What to store | Write to |
|---|---|
| Active task plan / progress / findings | `./.claude-sessions-memory/` |
| Skill gap, handoff, review queue, audit log | `./.mxm-skills/` |
| Operator profile (preferences, rejected patterns) | `./.mxm-operator-profile/` |
| Architecture docs (PRD, FRD, SRD) | `./documents/architecture/` (gitignored) |
| Build intakes, API keys, credentials | `./documents/architecture/.secrets/` (gitignored) |
| Business docs (investor, financial) | `./documents/business/` |
| Prototypes, POCs, v0 demos | `./prototypes/` |
| Brand foundation (personal + per-startup) | `./.brand-foundation/` (v1.0.0+) |

**Full storage map and protocols:** [`CLAUDE.d/session-memory.md`](CLAUDE.d/session-memory.md).

---

## 🚀 SESSION START PROTOCOL (high-level)

Runs deterministically via `.claude/hooks/session-start.{sh,ps1}` (executable). Skill-level Claude work then continues:

1. Detect project root via `config/project-manifest.json`
2. Verify memory junction (auto-heal if needed) — see [session-memory.md](CLAUDE.d/session-memory.md)
3. Read manifest → load identity, compliance scope, **lifecycle status, gated flag**
4. **Gate check** — if `lifecycle: archived` → refuse work | if `gated: true` → require explicit user approval
5. Read `CLAUDE.project.md` if present
6. Read `documents/ledgers/SESSION_CONTINUITY.md` → load session bridge
7. Check `.mxm-skills/agents-handoff.md` for BLOCKED/PARTIAL state
8. Check `.mxm-skills/agents-skill-gaps.log` and `.mxm-skills/review-queue.md`
9. Load session memory from `.claude-sessions-memory/`
10. Output session start summary

**Format:**
```
Maxim SESSION START
  Project   : [project.id]
  Lifecycle : [lifecycle status]
  Gated     : [yes/no — flag if true]
  Root      : [path]
  Handoff   : [status or none]
  Open gaps : [count]
  Pending review: [count]
```

---

## 🏁 SESSION END PROTOCOL (high-level)

Runs on `/mxm-session-end` (ritual) or `/mxm-release` (ship). Skill-level work; deterministic placeholder via `.claude/hooks/session-end.{sh,ps1}`.

**v1.0.0+** — session-end runs the **named 9-document closure bundle** (Learning #4, ratified by ADR-002):

1. `documents/ledgers/SESSION_CONTINUITY.md`
2. `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` (if sprint active)
3. `.claude-sessions-memory/progress.md`
4. `BUG_TRACKER.md` (if bug activity)
5. `documents/ledgers/DEBUGGING_PLAYBOOK.md` (if new failure pattern resolved)
6. `documents/ledgers/MOAT_TRACKER.md` (if positioning changed)
7. `CHANGELOG.md` (if user-facing change)
8. `config/project-manifest.json` (`last_activity` at minimum)
9. `MEMORY.md` (if memory files changed)

Plus: append to `session-YYYY-MM-DD.md`, update `agents-handoff.md`, append skill-gaps log, run `/mxm-watch` (LIGHT drift scan), and call `mxm-portfolio.sync_portfolio` MCP for portfolio projects.

**Full bundle protocol:** [`CLAUDE.d/protocols.md`](CLAUDE.d/protocols.md) § Session-End Bundle Protocol.
**Full 12-step session-memory protocol:** [`CLAUDE.d/session-memory.md`](CLAUDE.d/session-memory.md).

> **Session without memory writes = session wasted.**
> **`/mxm-session-end` is the named command. `/mxm-update` is narrower (capability inventory only). `/mxm-release` wraps session-end + version bump.**

---

## 🔄 DATA FLOW RULE (project → global, never reverse)

```
Project sessions  → write project-level memory at session end
                  → update .mxm-global/ from project state (READ project, WRITE global)
CEO automation    → READ local project files → UPDATE .mxm-global/ (never reverse)
Scheduled sync    → READ all project manifests → UPDATE .mxm-global/ (catches dormant projects)

.mxm-global/ is a derived cache for cross-surface sharing (NEVER the source of truth)
Project-level files are ALWAYS the source of truth
NEVER write from .mxm-global/ back to project-level files
```

---

## ⚡ THE Maxim DISPATCH — MANDATORY LOOKUP SEQUENCE

Every task MUST follow this exact sequence.

### Super User Pre-Check

Before executing any dispatch step, read `config/project-manifest.json`:

- If `super_user.enabled = true`: suppress CSO auto-loop, ethics pre-checks, compliance pre-enforcement, escalation gates. Tag outputs: 🔵 SUPER USER. (Claude's own judgment layer is unaffected.)
- If absent or false: all Maxim governance gates active (default).

### Gated Project Pre-Check (v1.0.0+)

- If `status.gated = true`: refuse work until explicit user approval is provided in this session. Tag any subsequent output: 🔐 GATED.
- If `status.lifecycle = archived`: refuse work entirely. Suggest restoring lifecycle or working on a different project.

### Dispatch Sequence

```
TASK RECEIVED
     │
     ▼
STEP 1 ── Does .claude/skills/{domain}/ have an Maxim skill for this?
     │
     ├── YES ──► Activate Maxim skill
     │           │
     │           ▼
     │           Check community-packs/ for matching domain skill
     │           (community-packs/claude-skills-library/, community-packs/ui-ux-pro-max/, community-packs/higgsfield-*/)
     │           │
     │           ├── MATCH FOUND ──► Merge into single unified output:
     │           │                   • Maxim behavioral science + frameworks → KEEP (non-negotiable)
     │           │                   • Maxim proactive triggers + communication standard → KEEP
     │           │                   • Maxim confidence tagging 🟢🟡🔴 → KEEP
     │           │                   • External scripts/references → ABSORB if Maxim has none
     │           │                   • Conflict resolution: Maxim ALWAYS WINS
     │           │
     │           └── NO MATCH ──► Maxim skill runs standalone. Full behavioral layer applied.
     │
     └── NO ───► Log to .mxm-skills/agents-skill-gaps.log
                 │
                 ▼
STEP 2 ── Does community-packs/ have a matching skill?
     │
     ├── YES ──► Use raw. No Maxim behavioral layer.
     │           Flag output: 🔴 Maxim-UNENHANCED
     │           Log to .mxm-skills/agents-skill-gaps.log
     │
     └── NO ───► Steps 3–5 (composable workflow patterns, planning-with-files, behavioral layer)
```

**Full Domain Dispatch Table, Conflict Resolution Rules, Workflow Patterns:** [`CLAUDE.d/dispatch.md`](CLAUDE.d/dispatch.md).

---

## 🏢 EXECUTIVE OFFICE ROUTING

All tasks route through the executive-router unless an explicit office is named.

### Command Shortcuts

| Shortcut | Routes To | Lead Agent | Use When |
|---|---|---|---|
| `/mxm-ceo` | CEO Office | `enterprise-architect` | Strategy, vision, finance, partnerships, enterprise architecture |
| `/mxm-cto` | CTO Office | `implementer` | Engineering, infrastructure, data, AI, APIs, DevOps, cloud |
| `/mxm-cmo` | CMO Office | `content-strategist` | Marketing, brand, content, SEO, conversion, behavioral design |
| `/mxm-cso` | CSO Office | `security-analyst` | Security, compliance, privacy, ethics, risk, incidents |
| `/mxm-cpo` | CPO Office | `product-strategist` | Product strategy, UX, UI, market research, user feedback |
| `/mxm-coo` | COO Office | `planner` | Operations, delivery, support, sprints, experiments |
| `/mxm-cino` | CINO Office | `innovation-researcher` | Innovation, R&D, emerging tech, horizon scanning |
| `/mxm-route` | Executive Router | `executive-router` | Unknown intent — classify and route automatically |
| `/mxm-wiki` | Wiki skills (v1.0.0+) | `wiki-ingest`/`query`/`lint`/`explore` | Knowledge ingestion + cross-project query on MemPalace |
| `/mxm-voice` | Voice skill (v1.0.0+) | `mxm-voice` MCP | Voice-driven office routing (requires mbailey/voicemode) |
| `/mxm-watch` | Proactive Watch (v1.0.0+) | `proactive-watch` skill | Drift detection across 11 classes; runs auto in SessionStart |
| `/mxm-session-end` | Session closure bundle (v1.0.0+) | `planner` (COO) | Mandatory 9-document ritual at end of any non-trivial session |

### Auto-Escalation Rules

These rules apply regardless of which office is active:

1. **CSO auto-loop** — any task containing security, compliance, PII, or regulated industry signals → security-analyst notified automatically
2. **CEO arbitration** — strategic conflicts between offices → enterprise-architect resolves
3. **CSO arbitration** — compliance conflicts → security-analyst resolves
4. **Unroutable tasks** → executive-router logs to `.mxm-skills/agents-skill-gaps.log` and requests clarification

**Full agent roster (90 agents across 7 offices + orchestrators):** [`CLAUDE.d/office-catalog.md`](CLAUDE.d/office-catalog.md).

---

## 📊 CONFIDENCE TAGGING (every output)

| Tag | Meaning |
|---|---|
| 🟢 HIGH | Maxim skill matched, behavioral layer fully applied |
| 🟡 MEDIUM | Maxim stub active OR partial external match |
| 🔴 LOW / Maxim-UNENHANCED | No Maxim skill matched, raw external used |
| 🔵 SUPER USER | Maxim governance suppressed (`super_user.enabled = true`) |
| 🔐 GATED | Project requires explicit approval (`status.gated = true`) |

---

## 🛡️ COMMIT PROTOCOL — CRITICAL SUMMARY

Before every commit, check if it touches:
- `.claude/commands/` → update `documents/reference/MXM_COMMAND_MAP.md` + **`documents/ledgers/AGENT_SKILL_INVENTORY.md`**
- `.claude/skills/` → update `documents/reference/SKILLS_MAP.md` + **`documents/ledgers/AGENT_SKILL_INVENTORY.md`** + `CLAUDE.d/dispatch.md`
- `agents/Maxim/` → **`documents/ledgers/AGENT_SKILL_INVENTORY.md`** (Section 1) + `config/agent-registry.json`
- `config/agent-registry.json` → update README badge if version changed
- `bootstrap/` → update `documents/reference/MXM_INSTALL.md` + `documents/guides/GETTING_STARTED.md`
- Release/version bump → update `CHANGELOG.md` + README badge + `documents/ledgers/MOAT_TRACKER.md` + **`documents/ledgers/AGENT_SKILL_INVENTORY.md`**
- `.claude/hooks/` → update `.claude/hooks/README.md` + **`documents/ledgers/AGENT_SKILL_INVENTORY.md`** (Section 5)
- `mcp/` → update `mcp/README.md` + `.mcp.json` + **`documents/ledgers/AGENT_SKILL_INVENTORY.md`** (Section 4)
- `composable-skills/frameworks/` → **`documents/ledgers/AGENT_SKILL_INVENTORY.md`** (Section 6) + `documents/reference/FRAMEWORKS_MASTER.md`
- `.brand-foundation/` → **`documents/ledgers/AGENT_SKILL_INVENTORY.md`** (Section 8)

**`documents/ledgers/AGENT_SKILL_INVENTORY.md` is the single source of truth for capability counts.** It must match reality on every commit.

**Capability-count propagation (v1.0.1+):** Whenever a commit touches any of `agents/MXM/**`, `.claude/skills/**`, `.claude/commands/**`, `mcp/**`, `composable-skills/frameworks/**`, or `.claude/hooks/**`, the capability count may have changed. Before commit, run `bootstrap/sync-counts.{sh,ps1}` from repo root — the tool reads `documents/ledgers/AGENT_SKILL_INVENTORY.md` and propagates counts to all declared surfaces (markdown docs + landing-page TSX + JSON breakdown comments) per `config/watch-profile.yml` § `surface-claims-drift`. Idempotent on a clean tree (running twice is a no-op). Drift the tool can't auto-resolve gets flagged in `.mxm-skills/watch-report.jsonl` for manual review. See [Proactive Watch Class 11](composable-skills/frameworks/proactive-watch.md) for the underlying detection model.

Deterministic secret/PII scanning runs as `.claude/hooks/pre-commit.{sh,ps1}` (executable hook). **Full Commit Protocol + Build Target + File Dedup:** [`CLAUDE.d/protocols.md`](CLAUDE.d/protocols.md).

---

## 📅 SKILL-GAP LOGGING

Log to `.mxm-skills/agents-skill-gaps.log` whenever Step 1 of dispatch returns NO.

```
[YYYY-MM-DD HH:MM] | {domain} | {task-description} | {suggested-skill-name} | {project}
```

---

## 🚀 MODEL ORCHESTRATION

```
Maxim_MODEL_PROVIDER=anthropic|openai|gemini|mistral|local
```

Default provider and preferred models declared in `config/project-manifest.json` → `tech_stack`. Per-task override possible via env. Cross-provider routing planned for v8.0.0+ (LiteLLM-style proxy).

---

## ⚖️ ETHICAL BOUNDARIES

All outputs governed by `documents/governance/ETHICAL_GUIDELINES.md`. Applicable compliance frameworks per project are declared in `config/project-manifest.json` → `compliance.frameworks`. Enforcement at `security-analyst.md` + `compliance` skill layer + `mxm-compliance` MCP server (14 frameworks: GDPR, PIPEDA, PCI-DSS, SOC2, HIPAA, UAE-PDPL, CASL, FINTRAC, EU AI Act, ISO 27001, ISO 13485, ISO 14971, NIST CSF, WCAG 2.1).

---

## 🏗️ PROJECT BOOTSTRAP

Bootstrap templates and project-to-template mappings are defined in:
- `config/project-manifest.json` → `bootstrap_templates`
- `CLAUDE.project.md` → Project Bootstrap Mapping section

To bootstrap a new project: copy `config/project-manifest.TEMPLATE.json`, fill in your project, then run `bootstrap/new-project-setup.sh` (Linux/Mac/CI) or `.\bootstrap\link-local-project.ps1` (Windows).

---

## 🧬 BRAND FOUNDATION (v1.0.0+, three-layer architecture v1.0.0+)

Maxim ships a three-layer voice system:

- **Layer 1 — Maxim base** (`.brand-foundation/personal/`, committed): Maxim product brand voice. 3-voice architecture (Philosophical Architect / Friendly Educator / Technical Educator), signature patterns, universal ai-tells, structural rules. Non-overridable.
- **Layer 2 — Operator overlay** (`.brand-foundation/personal.local/`, gitignored): your identity, signature extensions, operator-specific banned phrases. Per-machine. Additive to Layer 1.
- **Layer 3 — Startup overlay** (`.brand-foundation/startups/{active}/`, gitignored): vertical-specific positioning, audience, compliance. Compliance overrides operator for regulated content.

Per-project per-startup folders are created via:

```bash
.\bootstrap\link-local-project.ps1 -ProjectPath "<path>" -BrandFoundation
```

**Brand Foundation Loading Protocol** (when generating any external-facing content):

1. ALWAYS load Maxim base layer first: `.brand-foundation/personal/voice-profile.md`, `ai-tells.md`, `content-rules.md`
2. IF `.brand-foundation/personal.local/` exists, overlay operator identity + operator-specific bans
3. DETECT active startup from `config/project-manifest.json` → `brand.active_startup` or `cwd` pattern match
4. IF startup overlay exists at `.brand-foundation/startups/{detected}/`, load positioning + audience + compliance-rules
5. APPLY precedence: Maxim base (non-overridable) → operator adds only → startup adds + compliance-overrides-operator-for-regulated
6. BEFORE final output: run voice-validation checklist from Layer 1; scan against UNIONED ai-tells (base + operator + startup bans)
7. Tag 🟢 HIGH only after all three layers pass clean

Voice management (calibrate/update/scan/reset) via `/mxm-brand-voice` command, governed by `.brand-foundation/VOICE-MANAGEMENT.md`.

The four wiki skills (`wiki-ingest`, `wiki-query`, `wiki-lint`, `wiki-explore`) ingest raw sources into MemPalace as the queryable knowledge layer. See `documents/reference/AGENTS.md` at repo root for downstream agent usage.

---

## 🗣️ VOICE INTERACTION (v1.0.0+)

`/mxm-voice` activates voice-driven office routing via the `mxm-voice` MCP server. Wraps [mbailey/voicemode](https://github.com/mbailey/voicemode) for Whisper STT + Kokoro TTS (local) or OpenAI cloud STT/TTS.

User-editable hotword phrases live in `config/voice-phrases.yml`:

```yaml
phrases:
  - pattern: "maxim draft a landing page"
    dispatch: "/mxm-design landing page"
  - pattern: "maxim research X tell me how it improves Y"
    dispatch: "/mxm-cino research X for Y"
  - pattern: "maxim run my project health check"
    dispatch: "/mxm-health"
```

Add/remove/rename phrases freely — config is loaded fresh on every `/mxm-voice` invocation.

---

## ⏰ USAGE-AWARE SCHEDULING (v1.0.0+)

`/mxm-tasks` now checks Claude usage limits via the OAuth API before firing scheduled work. Thresholds in `config/scheduler-thresholds.json`:

```json
{
  "five_hour_pause_at": 80,
  "seven_day_pause_at": 85,
  "seven_day_opus_pause_at": 80,
  "min_sleep_seconds": 300,
  "api_failure_retry_seconds": 300
}
```

When any threshold is exceeded, scheduled tasks sleep until `resets_at`. Usage is global (all surfaces draw from same pool) — thresholds apply across all surfaces.

---

## 📋 SESSION CONTINUITY

1. Read `documents/ledgers/SESSION_CONTINUITY.md`
2. Check `.mxm-skills/agents-skill-gaps.log` for unresolved gaps
3. Check `community-packs/planning-with-files/` for active task plans
4. All session writes go to the **project folder** — see [session-memory.md](CLAUDE.d/session-memory.md)

---

## 🔗 REFERENCE INDEX

| Document | Purpose |
|---|---|
| `CLAUDE.d/session-memory.md` | Full session/memory protocols (split from CLAUDE.md in v1.0.0) |
| `CLAUDE.d/protocols.md` | Executable Contracts + Commit/Build/Dedup/Skill Domain protocols + ADR Lifecycle + Session-End Bundle + CHANGELOG Discipline |
| `CLAUDE.d/dispatch.md` | Domain Dispatch Table + Conflict Resolution + Workflows |
| `CLAUDE.d/office-catalog.md` | 90 agents across 7 offices |
| `CLAUDE.d/repo-map.md` | Authoritative repo structure |
| `documents/ADRs/` | Architecture Decision Records — canonical ledger (v1.0.0+) |
| `documents/ADRs/README.md` | ADR rules: numbering, lifecycle, when to write |
| `documents/ADRs/TEMPLATE.md` | ADR template with 4 mandatory sections |
| `documents/ADRs/INDEX.md` | All ADRs with current status |
| `documents/reference/FRAMEWORKS_MASTER.md` | 63 behavioral frameworks |
| `documents/governance/ETHICAL_GUIDELINES.md` | Governance boundaries |
| `documents/ledgers/SESSION_CONTINUITY.md` | Session memory bridge |
| `CLAUDE.project.md` | Project-specific overrides |
| `config/project-manifest.json` | Project identity, compliance, lifecycle, tech stack |
| `config/project-manifest.TEMPLATE.json` | Template for new project adoption (v1.0.0 schema) |
| `mcp/README.md` | 9 MCP servers (44 tools) |
| `.mcp.json` | Root MCP server registry (auto-discovery) |
| `.env.example` | Environment variable template |
| `documents/reference/AGENTS.md` | Downstream agent instructions (wiki + brand foundation usage) |
| `documents/ledgers/MOAT_TRACKER.md` | Defensibility tracking (Executable Contract) |
| `BUG_TRACKER.md` | Bug ledger with Recurring-Pattern registry (Executable Contract, v1.0.0+) |
| `documents/ledgers/DEBUGGING_PLAYBOOK.md` | Append-only debugging journal with §N numbering (v1.0.0+) |
| `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` | Sprint execution contract — CLI blocks per sprint (v1.0.0+) |
| `templates/sprint-plan.md` | Sprint plan template with Coverage Matrix + ADR cross-links (v1.0.0+) |
| `templates/sprint-report.md` | Sprint close-out template with plan-vs-actual diff (v1.0.0+) |
| `documents/business/sales-marketing/` | Canonical home for customer-facing copy — 6 subfolders (v1.0.0+) |
| `documents/cross-surface/maxim-project-instructions.md` | **Cross-surface A1** — packaged Maxim for Claude Web/Desktop Projects (v1.0.0+) |
| `documents/cross-surface/maxim-surface-guide.md` | **Cross-surface A3** — 3-tier deployment fidelity guide (v1.0.0+) |
| `packaging/cowork/` | **Cross-surface A2** — Cowork plugin scaffold + manifest + assembly (v1.0.0+) |
| `composable-skills/frameworks/proactive-watch.md` | 64th framework — drift detection (v1.0.0+) |
| `config/watch-profile.TEMPLATE.yml` | Proactive Watch config template (v1.0.0+) |
| `config/watch-profile.yml` | Per-project Proactive Watch config — maxim self-adopts (v1.0.0+) |
| `.mxm-skills/agents-skill-gaps.log` | Gap tracking |
| `.mxm-skills/review-queue.md` | Review items pending human triage |
| `.mxm-skills/compliance-audit.jsonl` | Pre-commit hook audit trail (v1.0.0+) |
| `community-packs/claude-skills-library/` | alirezarezvani reference library (536 SKILL.md) |
| `community-packs/ui-ux-pro-max/` | nextlevelbuilder UI/UX library (7 skills) |
| `community-packs/higgsfield-*/` | 40 video/cinematic prompt skills |
| `community-packs/design-templates/` | 59 brand DESIGN.md templates |
