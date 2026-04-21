---
name: /mxm-session-end
description: Named "Update files inventory" closure bundle. Runs the full 9-document session-end ritual so nothing silent-regresses between sessions. Distinct from /mxm-release (shipping a version) and /mxm-update (capability inventory only).
skill: session-memory
office: coo
lead_agent: planner
related: [session-memory, operator-profile, proactive-watch]
framework: null
adr: documents/ADRs/ADR-002-executable-contracts.md
confidence_default: 🟢 HIGH
---

# /mxm-session-end

> **The closure bundle.** Every session ends with this ritual. Not optional.
> Protects against drift that accumulates when individual docs get updated piecemeal — or worse, not at all.

Ratified by ADR-002 (Documents as Executable Contracts) and Learning #4 from the 15-learning multi-session arc ("Update files inventory as a named command").

---

## When to Run

| Trigger | Action |
|---|---|
| End of any session with non-trivial work | **MANDATORY** |
| End of a sprint / feature / bugfix | run before `/mxm-release` |
| Context window nearing exhaustion | run first, then summarize |
| Before switching projects | run to lock this project's state |
| Mechanical "I only read code" session | skip (no state changed) |

---

## What It Does — The 9-Document Bundle

Each of the following is checked for staleness and updated if the session touched its scope. This is the **named list** — it never changes without an ADR.

| # | Document | What gets updated |
|---|---|---|
| 1 | `documents/ledgers/SESSION_CONTINUITY.md` | Session bridge: what changed, what's open, carry-forward items |
| 2 | `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md` | If sprint touched: executed-command log, status flip |
| 3 | `.claude-sessions-memory/progress.md` | Percent-complete tracker for active initiatives |
| 4 | `BUG_TRACKER.md` | New bugs OPENED, bugs RESOLVED / CLOSED; Recurring-Pattern additions |
| 5 | `documents/ledgers/DEBUGGING_PLAYBOOK.md` | New `§N` section if a new failure pattern was resolved |
| 6 | `documents/ledgers/MOAT_TRACKER.md` | Competitive positioning changes; feature timeline if shipped |
| 7 | `CHANGELOG.md` | Release entry if the session shipped user-facing change |
| 8 | `config/project-manifest.json` | Lifecycle state, last_activity, staleness_warning |
| 9 | `MEMORY.md` (auto-memory index) | Index row updates for touched memory files |

Plus:
- Append to `.claude-sessions-memory/session-YYYY-MM-DD.md`
- Append to `.claude-sessions-memory/feedback_debugging_playbook.md` if debug work happened
- Append to `.claude-sessions-memory/feedback_lessons_learned.md` if insights surfaced
- Append to `.mxm-skills/agents-skill-gaps.log` if any dispatch Step 1 returned NO
- Append to `.mxm-skills/agents-handoff.md` — the hand-off block for next agent/session
- Run `/mxm-watch` — LIGHT drift scan to catch anything that slipped

---

## Execution Order

```
Phase 1 — Collect
  • Enumerate files created / modified this session
  • Enumerate decisions made (flip ADRs, open ADRs)
  • Enumerate bugs opened / closed
  • Enumerate new patterns learned
  • Enumerate skills invoked / gaps found

Phase 2 — Update (one doc at a time, in order 1→9)
  • For each doc: read current state → compare to session diff → update
  • Never batch — discrete commits per doc not required, but discrete mental
    passes per doc are

Phase 3 — Verify
  • Run /mxm-watch (LIGHT) — drift must equal zero (or be explained)
  • Run git status — should reflect the update passes
  • Run git-hygiene-postamble (optional: with --skip-push-check if not shipping)

Phase 4 — Hand-off
  • Update .mxm-skills/agents-handoff.md with next-session-startup block
  • Mark session-YYYY-MM-DD.md CLOSED
  • If portfolio project: call mxm-portfolio.sync_portfolio MCP
```

---

## Difference from Adjacent Commands

| Command | Scope | When to use |
|---|---|---|
| **`/mxm-session-end`** | 9-doc closure ritual + watch | Every session with non-trivial work |
| `/mxm-update` | Capability inventory (documents/ledgers/AGENT_SKILL_INVENTORY.md) only | When you added/removed agents, skills, commands, MCP, hooks, frameworks |
| `/mxm-release` | Version bump + tag + publish flow | When shipping a release (wraps session-end + version bump) |
| `/mxm-recall` | Replay what happened in session N | Reading, not writing |
| `/mxm-status` | Snapshot current state | Reading, not writing |

Rule of thumb: `/mxm-update` is about **capabilities**; `/mxm-session-end` is about **state**; `/mxm-release` is about **shipping**. They compose — `/mxm-release` calls `/mxm-session-end` then bumps version.

---

## Brand Foundation & Compliance Integration

If the session produced external-facing copy (launches, case studies, decks):
- Re-scan against `.brand-foundation/personal/ai-tells.md` before closing
- Verify content under `documents/business/sales-marketing/` complies with `.brand-foundation/startups/{active}/compliance-rules.md`

If the session touched regulated domains (PII, auth, payments, health):
- CSO auto-loop: verify `security-analyst` was notified during session
- Append audit entry to `.mxm-skills/compliance-audit.jsonl`

---

## Output Format

```
Maxim SESSION END ▸ Running closure bundle…

  [1/9] documents/ledgers/SESSION_CONTINUITY.md      ✓ updated (13 files touched, 2 decisions)
  [2/9] documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md  ○ no sprint active — skipped
  [3/9] progress.md                 ✓ updated (Block 4 of v1.0.0 complete)
  [4/9] BUG_TRACKER.md              ○ no bug activity — skipped
  [5/9] documents/ledgers/DEBUGGING_PLAYBOOK.md       ○ no new patterns — skipped
  [6/9] documents/ledgers/MOAT_TRACKER.md             ✓ updated (Proactive Watch moat entry)
  [7/9] CHANGELOG.md                ✓ updated (v1.0.0 unreleased section)
  [8/9] config/project-manifest.json ✓ last_activity touched
  [9/9] MEMORY.md                   ✓ index refreshed

  Handoff: agents-handoff.md        ✓ written
  Watch (light):                    ✓ drift=0 errors=0
  Portfolio sync:                   ○ non-portfolio project — skipped

Maxim SESSION END ▸ 7 docs updated, 2 skipped, 0 drift. Session persisted.
```

---

## Failure Modes

| Condition | Behavior |
|---|---|
| One doc update fails | Continue — log failure, mark doc as "ATTENTION" in handoff |
| `/mxm-watch` reports drift | Show drift; user decides whether to resolve now or carry forward (logged) |
| Git hygiene postamble fails | WARN only — this command does not push |
| Portfolio sync MCP unreachable | Skip — note in handoff for next session |

Session end never hard-fails. Each skip/failure is reported, but the ritual always completes.

---

## Configuration

Currently none — the 9-doc list is locked by ADR-002. To modify it, write a new ADR.

Custom per-project closure hooks can be added by editing:
`.claude/skills/session-memory/SKILL.md` → add to `session_end_proactive_loops` section.

---

## Related

- Learning #4 — "Update files inventory" as named command
- ADR-002 — Documents as Executable Contracts
- `CLAUDE.d/protocols.md` § Session-End Bundle Protocol
- `CLAUDE.d/session-memory.md` — full SessionEnd protocol
- `.claude/hooks/session-end.{sh,ps1}` — deterministic placeholder layer
- `/mxm-watch` — LIGHT scan run at end of bundle
- `/mxm-update` — narrower capability-inventory sync
- `/mxm-release` — wraps session-end + version bump

---

## Dispatch

| Signal | Action |
|---|---|
| User says "end session", "wrap up", "save state" | Run this command |
| User says "ship it", "release" | Run `/mxm-release` (which calls this) |
| User says "just update inventory" | Run `/mxm-update` (narrower) |
| Context < 10% remaining | Proactively suggest running this before summary |
