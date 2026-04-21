# Maxim Hooks — Lifecycle Event Protocols

> **As of v1.0.0**, Maxim ships **executable hooks** alongside protocol documentation.
> Hooks are deterministic enforcement of behavior previously documented-only.
> **v1.0.0** adds Git Hygiene Gate hooks (preamble + postamble) and wires Proactive Watch LIGHT into SessionStart.

---

## Hooks Shipped

| Event | Bash | PowerShell | Purpose | Since |
|---|---|---|---|---|
| **SessionStart** | `session-start.sh` | `session-start.ps1` | Detects project root, ensures runtime dirs, surfaces handoff state + skill gaps + pending review count + **Proactive Watch LIGHT drift count** | v1.0.0 (watch added v1.0.0) |
| **SessionEnd** | `session-end.sh` | `session-end.ps1` | Writes session-YYYY-MM-DD.md placeholder, touches handoff.md last_seen, appends to background log | v1.0.0 |
| **PreCommit** | `pre-commit.sh` | `pre-commit.ps1` | Blocks commits with hardcoded secrets (9 patterns); warns on PII patterns (3 patterns); appends every scan to `.mxm-skills/compliance-audit.jsonl` | v1.0.0 |
| **Git Hygiene Preamble** | `git-hygiene-preamble.sh` | `git-hygiene-preamble.ps1` | GH1 (clean tree) + GH2 (expected branch) + GH3 (up-to-date with origin). Run at start of any bundled task / sprint. | v1.0.0 |
| **Git Hygiene Postamble** | `git-hygiene-postamble.sh` | `git-hygiene-postamble.ps1` | GHN1 (clean tree) + GHN2 (pushed to origin). Run at end of any bundled task / sprint. | v1.0.0 |

Total: **5 events, 10 executable scripts.**

All hooks fail-soft (exit 0) except PreCommit (blocks on secrets) and Git Hygiene hooks (exit 1/2/3 on gate failure — caller decides what to do).

---

## Wiring Hooks Into Your Project

### Option A — `.claude/settings.json` (recommended for Claude Code)

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "", "command": "bash .claude/hooks/session-start.sh" }
    ],
    "SessionEnd": [
      { "matcher": "", "command": "bash .claude/hooks/session-end.sh" }
    ],
    "PreCommit": [
      { "matcher": "", "command": "bash .claude/hooks/pre-commit.sh" }
    ]
  }
}
```

On Windows, swap `bash .claude/hooks/X.sh` for `pwsh .claude/hooks/X.ps1`.

### Option B — Git pre-commit hook (works without Claude Code)

```bash
ln -sf ../../.claude/hooks/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

PowerShell:

```powershell
New-Item -Type SymbolicLink -Path .git\hooks\pre-commit -Target ..\..\.claude\hooks\pre-commit.sh
```

(Or copy the script if your filesystem doesn't support symlinks.)

### Option C — Multi-surface (Cowork, Desktop, CLI)

Hooks shipped here run only in Claude Code. Maxim's protocol-as-skill layer (see "Protocol Detail" sections below) covers behavior on other surfaces. Both layers operate together — hooks for deterministic enforcement, skills for cross-surface portability.

---

## Hook Event Mapping (Full Catalog)

| Hook Event | Maxim Implementation | Where Defined |
|---|---|---|
| **SessionStart** | Executable hook + Session Start Protocol + Proactive Watch LIGHT | `session-start.{sh,ps1}` + `session-memory/SKILL.md` + `.claude/skills/proactive-watch/` |
| **SessionEnd** | Executable hook + Session End Protocol | `session-end.{sh,ps1}` + `session-memory/SKILL.md` + `operator-profile/SKILL.md` |
| **PreCommit** | Executable hook (secrets/PII scan) + Commit Protocol (auto-update CHANGELOG, sync-version) | `pre-commit.{sh,ps1}` + `CLAUDE.md` |
| **Git Hygiene Preamble** | Executable hook for start-of-task gate (GH1–GH3) | `git-hygiene-preamble.{sh,ps1}` (v1.0.0+) |
| **Git Hygiene Postamble** | Executable hook for end-of-task gate (GHN) | `git-hygiene-postamble.{sh,ps1}` (v1.0.0+) |
| **PreToolUse** | CSO auto-loop: security/compliance pre-check on sensitive operations | `CLAUDE.md` (skill-level, not executable) |
| **PostToolUse** | Auto-inventory: flag significant files | `session-memory/auto-inventory.md` (skill-level) |
| **Notification** | Skill gap detection: log to `agents-skill-gaps.log` | `CLAUDE.md` dispatch sequence (skill-level) |

PreToolUse, PostToolUse, and Notification remain skill-level because they require Claude judgment (intent classification, signal detection) that shell scripts cannot provide.

---

## Protocol Detail: SessionStart (executable + skill-level)

The hook handles deterministic checks; the skill-level protocol handles judgment-based work.

**Hook does:**
1. Detect project root via `config/project-manifest.json`
2. Ensure `.mxm-skills/`, `.claude-sessions-memory/`, `.mxm-operator-profile/` exist
3. Read handoff status from `.mxm-skills/agents-handoff.md`
4. Count open skill gaps and pending review queue items
5. Print one-line summary to stderr

**Skill-level protocol does (after hook):**
6. Verify memory junction (auto-heal if needed)
7. Load project identity from manifest
8. Load `CLAUDE.project.md` overrides
9. Read `documents/ledgers/SESSION_CONTINUITY.md`
10. Load session memory (`MEMORY.md`, `project_current_state.md`, `handoff.md`)

---

## Protocol Detail: SessionEnd (executable + skill-level)

**Hook does:**
1. Touch today's `session-YYYY-MM-DD.md` (placeholder if missing)
2. Touch `handoff.md` last_seen timestamp
3. Append `session_end` event to `.mxm-skills/agents-background.log`

**Skill-level protocol does (during session-end work):**
4. Populate the session file with tasks completed, decisions, files created/modified
5. Update `progress.md`, `project_current_state.md`, `handoff.md`
6. Append to debugging playbook and lessons learned if errors occurred
7. Update `MEMORY.md` index
8. Append new gaps to `.mxm-skills/agents-skill-gaps.log`
9. Run auto-inventory scan
10. Run staleness prevention protocol (`sync_portfolio` MCP tool)

---

## Protocol Detail: PreCommit (executable + skill-level)

**Hook does (executable enforcement):**
- Scans staged file diffs for 9 high-confidence secret patterns (AWS keys, OpenAI/Anthropic keys, GitHub PATs, private keys, Slack tokens)
- Warns on 3 PII patterns (SSN, Visa, MasterCard) in non-doc/test files
- Appends every scan to `.mxm-skills/compliance-audit.jsonl` (immutable audit log)
- Blocks commit on secret violation (exit 1)

**Skill-level protocol does (Claude-driven):**
- Auto-update CHANGELOG, HELP, SKILLS_MAP, MXM_COMMAND_MAP based on commit scope
- Run `sync-version.ps1 -WhatIf` to detect version drift
- Update documents/ledgers/MOAT_TRACKER.md feature timeline on release commits

---

## Protocol Detail: PreToolUse (CSO Auto-Loop)

Triggered before tool execution when security-sensitive signals detected (skill-level only):

- Task contains: auth, payments, PII, credentials, tokens, secrets
- Task targets: regulated domains (healthcare, finance, legal)
- Action: `security-analyst` agent notified automatically

---

## Protocol Detail: PostToolUse (Auto-Inventory)

Triggered after file creation/modification (skill-level):

- Scan for architecturally significant files
- Flag new/changed files for `.claude-sessions-memory/file_inventory.md` update
- Sync to `reference_key_files.md`

---

## Protocol Detail: Notification (Skill Gap Detection)

Triggered when Maxim dispatch sequence Step 1 returns NO (skill-level):

- Log to `.mxm-skills/agents-skill-gaps.log`
- Format: `[YYYY-MM-DD HH:MM] | {domain} | {task-description} | {suggested-skill-name} | {project}`

---

## Protocol Detail: Git Hygiene Gate (v1.0.0+)

Invoked explicitly at the start and end of any bundled task / sprint / release sprint. Ratified by the 15-learning pattern (see ADR-002 and `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md`).

### Preamble (GH1–GH3)

```bash
.claude/hooks/git-hygiene-preamble.sh [expected-branch]
```

- **GH1** — working tree must be clean (exit 1 if dirty)
- **GH2** — must be on expected branch if specified (exit 2 if wrong)
- **GH3** — must be up-to-date with `origin/<branch>` (exit 3 if behind)

### Postamble (GHN)

```bash
.claude/hooks/git-hygiene-postamble.sh [--skip-push-check]
```

- **GHN1** — working tree must be clean (exit 1 if uncommitted)
- **GHN2** — all commits pushed to `origin/<branch>` (exit 2 if unpushed)

Exit codes allow the invoking sprint / task runner to decide whether to proceed or block. Never bypass with `--no-verify` — if a false positive blocks work, fix the hook.

---

## Protocol Detail: Proactive Watch (v1.0.0+)

Integrated into SessionStart hook. Runs `.claude/skills/proactive-watch/watch.{sh,ps1}` at LIGHT phase on session open.

**What it does in session-start:**
- Runs all 10 enabled drift checkers (inventory, version, contract, cross-doc, orphan-refs, dependency, git-hygiene, junction, stale-handoff, compliance)
- Writes `.mxm-skills/watch-report.jsonl` (JSONL, one line per drift)
- Surfaces `drift=N errors=M` counts in the session start banner
- Fail-open on standard checkers; fail-closed on critical (compliance, contract)

**Manual invocation:** `/mxm-watch` (see `.claude/commands/mxm-watch.md`)

**Per-project config:** `config/watch-profile.yml` (template at `config/watch-profile.TEMPLATE.yml`)

See `composable-skills/frameworks/proactive-watch.md` for the full framework spec.

---

## Audit Log Format

`.mxm-skills/compliance-audit.jsonl` — append-only JSONL written by PreCommit hook:

```jsonl
{"timestamp":"2026-04-16T11:15:00Z","file":"agents/compliance/gdpr.py","violation":"secret_exposure","action":"blocked"}
{"timestamp":"2026-04-16T11:18:00Z","file":"src/users.ts","violation":"pii_pattern","action":"warned"}
```

This log is the **enterprise compliance evidence trail**. Never delete entries. Rotate by month if it grows large.

---

## Bypassing Hooks (Use With Care)

```bash
git commit --no-verify  # bypasses PreCommit hook — leaves AUDIT GAP
```

Maxim recommends NEVER using `--no-verify`. If a legitimate commit is blocked by a false-positive secret pattern, fix the pattern in the hook script and re-commit.
