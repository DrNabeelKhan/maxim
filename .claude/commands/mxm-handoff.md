---
name: /mxm-handoff
description: Generate a verify-first continuation handoff prompt (ADR-023) — a paste-into-a-new-window block that lets a fresh session resume with zero context loss and no hallucination. Points to source-of-truth + forces verification rather than embedding stale facts. Available anytime; also runs as Phase 4 of /mxm-session-end.
skill: session-memory
office: coo
lead_agent: planner
related: [session-memory, operator-profile, proactive-watch]
framework: null
adr: documents/ADRs/ADR-023-continuation-handoff-prompt.md
confidence_default: 🟢 HIGH
---

# /mxm-handoff

> **The portable half of continuity.** `SESSION_CONTINUITY.md` + `agents-handoff.md` are the durable record; `auto-compact.md` resumes the *same* conversation across compaction. `/mxm-handoff` produces the **paste-into-a-fresh-window** prompt that resumes a *different* window — on any surface — without re-reading everything and without hallucinating from stale prose.

Ratified by ADR-023. Governed by `templates/continuation-prompt.template.md`.

---

## When to Run

| Trigger | Action |
|---|---|
| You're about to continue in a new window / new chat / different surface | **Run this** |
| Context window feels heavy (long session, many tool calls, compaction already fired) | Run this, then start the new window |
| Phase 4 of `/mxm-session-end` | Offered automatically (always asked) |
| Operator says "give me a handoff", "continue in a new window", "hand this off" | Run this |

This command never changes repo state — it only reads + emits a prompt.

---

## The Anti-Hallucination Contract (ADR-023 — non-negotiable)

A handoff prompt fails when it **embeds facts that go stale** (git HEAD, capability counts, "what's done") — the next window trusts the prose, the prose is wrong, and it hallucinates forward. This command does the opposite. The generated prompt:

1. **Points to source-of-truth**, it does not substitute for it — names the three bridges to read first.
2. **Forces verification** — ships runnable git/version commands whose *output overrides* anything in the prompt, with the explicit rule **"where this prompt and the files disagree, the files win."**
3. **Never inlines counts/rosters/long file bodies** — references them at their canonical path (those are exactly the values a paste gets wrong).
4. **Carries operator decisions verbatim**, flagged *do-not-decide-for-him*.
5. **Marks every unverified value** as `UNVERIFIED — read <source> first` rather than guessing a plausible value.

---

## Behavior

1. **Load the template** `templates/continuation-prompt.template.md` and ADR-023 (the contract).
2. **Gather VERIFIED state only** (never guess):
   - `git rev-parse --short HEAD` · `--abbrev-ref HEAD` · `git rev-list --left-right --count HEAD...origin/<branch>` · `git status --porcelain` · `git describe --tags --abbrev=0`
   - version source of truth (e.g. `config/agent-registry.json` → `"version"`)
   - the project's bridge paths + inventory path (do NOT read counts INTO the prompt — reference the path)
   - this session's: last shipped, in-flight items, immediate next task, open operator decisions, non-decision pending items, load-bearing rules
   - For any value not verified this session → write `UNVERIFIED — read <source> first`.
3. **Fill the template.** Keep the SNAPSHOT short; let §2 (VERIFY STATE) re-derive truth.
4. **Write** the result to `.claude-sessions-memory/CONTINUATION-PROMPT.md` (runtime-local, gitignored) **and print it inline** so it can be copy-pasted immediately.
5. **Confidence-tag** the emission (ADR-010): 🟢 HIGH only if every placeholder was filled from verified state; 🟡 if any `UNVERIFIED` markers remain (and say which).

---

## Output Format

```
Maxim HANDOFF ▸ Generating continuation prompt…

  Verified: HEAD=<sha> · branch=<b> · <==origin|N ahead/behind> · tree=<clean|dirty> · tag=<t> · version=<v>
  Unverified placeholders: <none | list>

  Written: .claude-sessions-memory/CONTINUATION-PROMPT.md

  ──────────────── paste below into a fresh window ────────────────
  <the full filled prompt>
  ─────────────────────────────────────────────────────────────────

  🟢 HIGH — all state verified.   (or 🟡 MEDIUM — N unverified, listed above)
```

---

## Difference from Adjacent Commands

| Command | Produces | Resumes |
|---|---|---|
| **`/mxm-handoff`** | A paste-ready continuation prompt | A **fresh/different** window, any surface |
| `auto-compact.md` (session-memory) | A compact-seed file | The **same** conversation across in-place compaction |
| `/mxm-session-end` | The durable 9-document bundle | The project's persistent record (offers `/mxm-handoff` as Phase 4) |
| `/mxm-status` / `/mxm-recall` | A read-only snapshot / replay | Nothing — reading, not handing off |

---

## Related

- ADR-023 — Continuation Handoff Prompt Standard
- ADR-002 — Documents as Executable Contracts (the session-end bundle this projects from)
- `templates/continuation-prompt.template.md` — the fill-in template
- `.claude/skills/session-memory/auto-compact.md` — the in-place compaction cousin
- `/mxm-session-end` — runs this as Phase 4 (always asked)

---

## Dispatch

| Signal | Action |
|---|---|
| User says "hand off", "continue in a new window", "give me a handoff prompt" | Run this command |
| Self-assessed context heavy at session close | Recommend running this (no fabricated percentage) |
| User says "end session" | Run `/mxm-session-end` (which offers this at Phase 4) |
