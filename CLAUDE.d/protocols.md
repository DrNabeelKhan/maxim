# CLAUDE.d / Protocols

> Loaded by `CLAUDE.md` as a reference module. Contains: Documents as Executable Contracts,
> Commit Protocol, New Skill Domain Checklist, Build Target Protocol, File Deduplication Policy,
> Project Scaffold Standard, ADR Lifecycle Protocol.

---

## Documents as Executable Contracts (v1.0.0+)

> **Meta-principle governing this repo. Ratified by ADR-002.**
>
> Every document is an executable contract. BUG_TRACKER is the contract for what's broken.
> ADRs are the contract for decisions. CHANGELOG is the contract with customers.
> MOAT_TRACKER is the contract for positioning. AGENT_SKILL_INVENTORY is the contract for capabilities.
> **When a contract drifts from reality, fix the contract first — then the code.**
> Never ship a fix whose documentation is three files behind.

### The Five Canonical Contract Classes

| Contract | Canonical File | Reality Source | Criticality |
|---|---|---|---|
| **Capability Inventory** | `documents/ledgers/AGENT_SKILL_INVENTORY.md` | `agents/`, `.claude/skills/`, `.claude/commands/`, `mcp/`, hooks, frameworks, .brand-foundation | 🔴 Critical — blocks commit |
| **Decisions** | `documents/ADRs/INDEX.md` + individual ADRs | Code patterns that must conform to ACCEPTED ADRs | 🔴 Critical — blocks commit |
| **Customer Contract** | `CHANGELOG.md` | Git tags + release-shipped files | 🟡 Warning |
| **Bug Ledger** | `BUG_TRACKER.md` (v1.0.0+) | Actual open issues + code paths | 🟡 Warning |
| **Positioning** | `documents/ledgers/MOAT_TRACKER.md` | Feature reality at release time | 🟡 Warning |

### Enforcement Rules

1. **Fix the contract first, then the code.** Always update the contract in the same commit as the reality it describes.
2. **Critical contracts block commits.** If `documents/ledgers/AGENT_SKILL_INVENTORY.md` is out of sync with filesystem, the pre-commit hook rejects the commit.
3. **Warning contracts emit warnings.** Commits proceed, but the drift surfaces in the commit output and is logged to `.mxm-skills/watch-errors.jsonl`.
4. **Escape hatch:** commits may bypass critical blocks by including `[contract-drift-ack: <reason>]` in the commit message. This is deliberate, auditable, and rare.
5. **Proactive Watch is the continuous enforcement layer.** `/mxm-watch` catches drift that slipped past commit-time checks on next session start.
6. **New contract classes require an ADR.** Declaring a new Executable Contract class adds friction; that addition must be deliberate and documented.

See ADR-002 (`documents/ADRs/ADR-002-executable-contracts.md`) for rationale, alternatives considered, and full decision record.

---

## Commit Protocol — Auto-Update on Every Commit

Before creating any git commit, Claude MUST check and update these files if the commit affects their scope:

| If commit touches... | Also update... |
|---|---|
| Any `.claude/commands/` | `documents/reference/MXM_COMMAND_MAP.md` (command count + Quick Reference Card) |
| Any `.claude/skills/` | `documents/reference/SKILLS_MAP.md` (domain count + detail section) |
| Any agent .md in `agents/MXM/` | `documents/reference/MXM_COMMAND_MAP.md` if new agent changes routing |
| `config/agent-registry.json` | `README.md` badge if version changed |
| Any `bootstrap/` script | `documents/reference/MXM_INSTALL.md` + `documents/guides/GETTING_STARTED.md` if usage changed |
| Any release/version bump | `CHANGELOG.md` entry + README badge + documents/guides/HELP.md version refs + `documents/ledgers/MOAT_TRACKER.md` feature timeline |
| `templates/` | `documents/guides/HELP.md` (relevant section if templates changed) |
| `templates/prompts/` | `documents/MXM_RUNDOWN.md` (prompts library section if prompts changed) |
| Any `.claude/hooks/` | `.claude/hooks/README.md` (event mapping table) + `documents/ledgers/AGENT_SKILL_INVENTORY.md` (hook count Section 5) |
| Any `mcp/` server | `mcp/README.md` (server table) + `.mcp.json` (root) + `documents/ledgers/AGENT_SKILL_INVENTORY.md` (MCP count Section 4) |
| Any **`agents/MXM/`** (new/deprecated) | `documents/ledgers/AGENT_SKILL_INVENTORY.md` (Section 1 + master count) + `config/agent-registry.json` (total_mxm_agents) |
| Any **`.claude/skills/`** (new domain) | `documents/ledgers/AGENT_SKILL_INVENTORY.md` (Section 2 + master count) + `documents/reference/SKILLS_MAP.md` + `CLAUDE.d/dispatch.md` Domain Dispatch Table |
| Any **`.claude/commands/`** (new command) | `documents/ledgers/AGENT_SKILL_INVENTORY.md` (Section 3 + master count) + `documents/reference/MXM_COMMAND_MAP.md` + `documents/guides/HELP.md` Quick Reference Card |
| Any **`composable-skills/frameworks/`** | `documents/ledgers/AGENT_SKILL_INVENTORY.md` (Section 6) + `documents/reference/FRAMEWORKS_MASTER.md` |
| **`.brand-foundation/personal/`** or **`startups/`** | `documents/ledgers/AGENT_SKILL_INVENTORY.md` (Section 8) |
| Any **behavior conforming to an ACCEPTED ADR** | Re-read the ADR; if behavior diverges, either write a superseding ADR OR bring code back in line |
| Any **scope-lockdown ADR** exists for the current release | Diff file set against ADR snapshot; flag drift before commit |
| Any **new or closed bug** | `BUG_TRACKER.md` row (OPEN / IN_PROGRESS / RESOLVED / CLOSED) — never allocate bug IDs elsewhere |
| Any **non-trivial debug session** produces a new failure pattern | Append new `§N` section to `documents/ledgers/DEBUGGING_PLAYBOOK.md` — never rewrite older sections |
| Any **sprint start / close** | `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` CLI block + `.claude-sessions-memory/sprints/SPRINT-NNN-{plan,report}.md` |
| Any **customer-facing copy** (launch, catalogue, deck, one-pager, case study, partner program) | Place under `documents/business/sales-marketing/{subfolder}/` — never at repo root |
| Any **2+ bugs sharing root cause** | Add `PATTERN-NN` entry to `BUG_TRACKER.md` Recurring-Pattern Registry + lint/hook rule to prevent recurrence |

This is NOT optional. Every commit message should reflect what ancillary files were updated.

The deterministic version of secret/PII scanning AND contract-drift checks run as `.claude/hooks/pre-commit.{sh,ps1}` (executable hook).

**Critical-contract block:** If `documents/ledgers/AGENT_SKILL_INVENTORY.md` or an ACCEPTED ADR is out of sync with the commit, the hook rejects the commit unless `[contract-drift-ack: <reason>]` is present in the commit message.

---

## ADR Lifecycle Protocol (v1.0.0+)

Every non-reversible decision — technical or process — gets an ADR in `documents/ADRs/`. See `documents/ADRs/README.md` for full rules. Quick reference:

### When to write an ADR

- Architecture choice (MCP vs REST, data store selection)
- Framework / dependency lock-in
- Breaking API change
- Release scope lockdown
- Governance rule
- Workflow standard (e.g., Git Hygiene Gate)
- Deprecation policy

**Do NOT write ADRs for:** trivially reversible changes (one-commit undos), routine refactors, bug fixes that don't change design.

### Status Lifecycle

```
PROPOSED ──► ACCEPTED ──► SUPERSEDED
    │
    └────► WITHDRAWN (rare)
```

- **PROPOSED** flips to **ACCEPTED** at sprint kickoff or when decision goes live
- **ACCEPTED** flips to **SUPERSEDED** when a new ADR replaces it (old ADR gets `Superseded-By: ADR-XXX`)
- **WITHDRAWN** numbers are retired — never reused

### Numbering Rules

- Strictly incremental: ADR-001, ADR-002, ADR-003 …
- Zero-padded to 3 digits
- **Never reuse retired numbers.** Gaps are audit history.

### 4 Mandatory Sections

Every ADR has: **Context**, **Decision**, **Consequences**, **Alternatives Considered (≥3)**.

Copy `documents/ADRs/TEMPLATE.md` to start.

### Commit Protocol integration

Adding / modifying an ADR must update `documents/ADRs/INDEX.md` in the same commit.

### Scope-Lockdown ADRs

When a release enters scope freeze, write a `LOCKDOWN` ADR snapshotting the exact file set. Pre-commit hook diffs the current file set against the lockdown snapshot and flags drift.

---

## New Skill Domain Checklist

When adding a new `.claude/skills/{domain}/` folder, ALL of the following must be completed in the SAME commit:

1. `SKILL.md` with YAML frontmatter (skill_id, name, version, triggers, collaborates_with)
2. `Maxim-WRAPPER.md` with dispatch path, behavioral framing, proactive loops
3. Add row to `documents/reference/SKILLS_MAP.md` Section 2 table (domain number, name, category, office, agents)
4. Add detail entry to `documents/reference/SKILLS_MAP.md` Section 4 (domain description, office, sub-skills, references)
5. Add row to `CLAUDE.d/dispatch.md` Domain Dispatch Table
6. Update `documents/reference/SKILLS_MAP.md` header count (`Cross-reference of all N .claude/skills/`)
7. If joint office ownership: add to BOTH offices in `documents/reference/SKILLS_MAP.md` Section 1 map
8. Update `CHANGELOG.md` with the new domain

**Naming convention:** Skill folders are internal routing identifiers (lowercase, hyphenated). They do NOT use the `mxm-` prefix — that prefix is reserved for user-facing commands in `.claude/commands/`. Skills are process components activated by triggers, not standalone user commands.

**Failure to complete this checklist = incomplete commit. Do not ship partial skill additions.**

---

## Build Target — Remote-First Protocol

Before running ANY build, test, or deploy command:

1. Read `config/project-manifest.json` → `build_target`
2. If `build_target.default == "remote"`:
   - SSH to `build_target.remote.host` (prefer `tailscale_ip` if available)
   - Run commands at `build_target.remote.project_path`
   - Only fall back to local if:
     a. User explicitly says "build locally" / "test locally" / "run on my machine"
     b. SSH connection fails after 2 retries
     c. `build_target.remote.host` is `"[TBD]"` (not configured)
3. If `build_target.default == "local"` or field absent: build locally
4. Report: "Building on [host] (remote)" or "Building locally (user preference)"

---

## File Deduplication Policy

Every file has ONE canonical location. Never create duplicates.

| File Type | Canonical Location | NEVER create at |
|---|---|---|
| `task_plan.md` | `.claude-sessions-memory/` | root, `planning/`, `*-planning/` |
| `progress.md` | `.claude-sessions-memory/` | root, `planning/` |
| `findings.md` | `.claude-sessions-memory/` | root, `planning/` |
| `debugging playbook` | `.claude-sessions-memory/feedback_debugging_playbook.md` | `.mxm-skills/`, root |
| `lessons learned` | `.claude-sessions-memory/feedback_lessons_learned.md` | `.mxm-skills/`, root |
| `decision log` | `.claude-sessions-memory/decision-log.md` | `.mxm-skills/`, root |
| `session summaries` | `.claude-sessions-memory/session-[date].md` | `.mxm-skills/`, root |
| PRD, FRD, SRD, ARCHITECTURE | `documents/architecture/` | root, `planning/`, random folders |
| Build intakes, API keys, secrets | `documents/architecture/.secrets/` | root, `config/`, committed files |
| Investor narrative, financial models | `documents/business/` | root, `planning/`, random folders |
| Prototypes, v0 demos, POCs | `prototypes/` | root, `src/`, `apps/` |

If duplicate found at non-canonical location: merge content to canonical → backup original to `.mxm-backup/` → report to user.

---

## Session-End Bundle Protocol (v1.0.0+)

> Learning #4 from the multi-session arc: "Update files inventory as a named command."
> Ratified by ADR-002 (Documents as Executable Contracts).

At the end of every session with non-trivial work, run `/mxm-session-end` to update the **9-document closure bundle**. This list is locked — changing it requires a new ADR.

### The 9-Document Bundle

| # | Document | Update trigger |
|---|---|---|
| 1 | `documents/ledgers/SESSION_CONTINUITY.md` | Always |
| 2 | `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` | If a sprint ran during the session |
| 3 | `.claude-sessions-memory/progress.md` | Always |
| 4 | `BUG_TRACKER.md` | If any bug was opened / closed / updated |
| 5 | `documents/ledgers/DEBUGGING_PLAYBOOK.md` | If any new failure pattern was resolved |
| 6 | `documents/ledgers/MOAT_TRACKER.md` | If the session changed competitive positioning or shipped a moat-relevant feature |
| 7 | `CHANGELOG.md` | If the session shipped user-facing change |
| 8 | `config/project-manifest.json` | Always (at minimum: `last_activity`) |
| 9 | `MEMORY.md` (auto-memory index) | If memory files changed |

### Supplementary updates

Alongside the 9-doc bundle:
- Append to `.claude-sessions-memory/session-YYYY-MM-DD.md`
- Append to `.claude-sessions-memory/feedback_debugging_playbook.md` (if debug work)
- Append to `.claude-sessions-memory/feedback_lessons_learned.md` (if insights surfaced)
- Append to `.mxm-skills/agents-skill-gaps.log` (if dispatch Step 1 returned NO at any point)
- Update `.mxm-skills/agents-handoff.md` — the hand-off block for the next agent / session
- Run `/mxm-watch` — LIGHT drift scan; drift must be zero or explained
- If portfolio project: call `mxm-portfolio.sync_portfolio` MCP

### Failure semantics

`/mxm-session-end` never hard-fails. Each skipped or failed document is reported; the ritual completes. A session never ends without this bundle run — the hook layer enforces it deterministically where possible; the skill layer enforces it via Claude judgment.

### Difference from adjacent rituals

- `/mxm-session-end` — state closure (this bundle)
- `/mxm-update` — capability inventory only (documents/ledgers/AGENT_SKILL_INVENTORY.md)
- `/mxm-release` — version bump + tag (wraps `/mxm-session-end` + adds shipping steps)

---

## CHANGELOG Discipline (v1.0.0+)

> Learning #12 from the multi-session arc: "Skipped versions are explicitly recorded in CHANGELOG."

### Skipped-Version Protocol

When a planned version is skipped (scope abandoned, rolled into a later release, never shipped), the CHANGELOG **must** record a `SKIPPED` entry explaining why. This preserves audit integrity for future readers asking "why did you go from v2.1.x to v2.3.0?"

### Format

```markdown
## [2.2.0] — SKIPPED

Rationale: Scope folded into v2.3.0 (voice-mode spec proved simpler than anticipated; did not warrant separate release).
```

### Rules

1. **Never silently skip a version.** Every version advertised in a roadmap, ADR, or sprint plan must have a CHANGELOG entry — even if that entry is `SKIPPED`.
2. **Rationale is mandatory.** A SKIPPED entry without a rationale fails the Executable Contracts check.
3. **Use past tense and factual language.** "Scope folded" not "We plan to fold."
4. **Keep the order.** SKIPPED entries preserve their position in the version sequence. Do not re-order or compact.
5. **Skipped ≠ Yanked.** A yanked version (shipped then withdrawn) uses `## [2.2.0] — YANKED` with a separate format covering withdrawal reason, affected users, and remediation.

### When to use which

| Situation | CHANGELOG entry |
|---|---|
| Version was planned, never started | `## [X.Y.Z] — SKIPPED` + rationale |
| Version was in-progress, scope merged into next release | `## [X.Y.Z] — SKIPPED` + "scope folded into X.Y.Z+1" |
| Version shipped to users then withdrawn | `## [X.Y.Z] — YANKED` + withdrawal details |
| Version shipped and is current | `## [X.Y.Z] — YYYY-MM-DD` + normal sections |

### Pre-commit enforcement

The `cross-doc-drift` checker in Proactive Watch flags any git tag that has no corresponding CHANGELOG entry (whether released or SKIPPED). Drift surfaces at session start; must be resolved before the next release ships.

---

## Project Scaffold Standard

Every Maxim project has this folder structure:

```
project/
├── config/                        ← project-manifest.json, agent-registry.json
├── documents/
│   ├── architecture/              ← PRD, FRD, SRD, ARCHITECTURE.md (gitignored)
│   │   └── .secrets/              ← build intakes, API keys, credentials (gitignored)
│   └── business/                  ← investor narrative, financial models
├── prototypes/                    ← v0 demos, POCs, throwaway builds
├── .brand-foundation/              ← v1.0.0+ — personal voice + per-startup positioning
│   ├── personal/                  ← voice-profile, ai-tells, content-rules
│   └── startups/{startup}/        ← positioning, audience, compliance-rules per venture
├── .mxm-skills/                  ← runtime state (gitignored)
├── .claude-sessions-memory/       ← session persistence (gitignored)
├── .mxm-operator-profile/        ← operator model (gitignored)
└── .claude.local/                 ← MCP settings (gitignored)
```

---

## Behavioral-Moat Framing (v1.0.0+ — ADR-007)

Every Maxim skill written or rewritten MUST carry behavioral-moat framing.
This is the moat. Pretty templates are not the product.

Required sections in every Maxim skill SKILL.md (see ADR-007 for full spec):

1. YAML frontmatter: `business_outcome` + `primary_framework`
2. `## The Maxim Moat` — framework driving the skill + replication barrier
3. `## Business Outcome` — specific metric this skill moves
4. `## Primary Behavioral Framework` — mechanism, source, application
5. `## Behavioral → [Domain] Translation` — framework mechanisms → output elements
6. `## Anti-Patterns` — what breaks the mechanism (minimum 3)
7. `## Pack Integrations` — how Pack 2 Behavioral Intelligence deepens the skill

New skills: all 7 sections required at creation.
Existing skills (pre-v1.0.0): sections required on first modification after v1.0.0 (warning until v6.5.0).

Enforcement: `behavioral-moat-drift` pre-commit hook (ships Sprint 4).
Reference implementation: `.claude/skills/ai-media-generation/cinematic-styles/`.
