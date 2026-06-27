# ADR-023 — Continuation Handoff Prompt Standard (Verify-First, Anti-Hallucination Session Pickup)

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-06-27
- **Deciders:** Mr. Khan (operator) · COO office / planner (owns `/mxm-session-end`) · CTO office / implementer
- **Related:** ADR-002 (documents as executable contracts — the session-end bundle is the contract this extends) · ADR-010 (confidence tagging) · ADR-013 (multi-project memory inheritance) · `session-memory` skill + `auto-compact.md` (in-place compaction cousin) · `/mxm-session-end` · `/mxm-handoff` (new this ADR)

---

## Context

A long session ends — or a context window fills — and the work has to continue in a **fresh window**. Today that handoff is improvised: the operator either pastes an ad-hoc summary or re-derives state by hand. When the summary is improvised, it tends to **embed facts that have already gone stale** — a git HEAD, a capability count, "what's done" — and the next window trusts the prose. The prose is wrong, and the new session confidently hallucinates forward from a bad premise. This is the single most common way clean cross-session state gets broken, and it is squarely the failure mode Maxim exists to prevent (the global never-hallucinate rule).

Maxim already has the *durable* half of continuity: the `/mxm-session-end` 9-document bundle (ADR-002) writes `SESSION_CONTINUITY.md` + `agents-handoff.md` as executable contracts, and `auto-compact.md` writes a compact-seed that survives **in-place** compaction. What is missing is the **portable** half: a single paste-into-a-new-window prompt that lets a *fresh* chat — possibly on a different surface, with none of this session's context — resume **without re-reading everything and without hallucinating**.

There are two hard constraints that shape the design:

1. **No real context-percentage meter exists inside a skill.** No tool exposes "you are at 85% of context." Hard-coding an "85% gate" would mean inventing a number Maxim cannot measure — exactly the unverifiable-default anti-pattern the global rule forbids. So the trigger must be a *self-assessment + always-ask*, not a fabricated gauge.
2. **A paste cannot be kept in sync.** Any fact copied into a handoff prompt is stale the moment the repo moves. So the prompt must not *be* the source of truth — it must *point at* the source of truth and force re-verification.

The empirical proof that the verify-first shape works: this very session was resumed cleanly from exactly such a prompt (read three bridges → verify git state → carry pending decisions → confirm-and-summarize). The HEAD quoted in that resume prompt was already one closure stale; because the prompt instructed "verify before acting," the discrepancy was caught in the first 30 seconds instead of poisoning the session.

---

## Decision

Maxim adopts a **Continuation Handoff Prompt Standard**: a structured, verify-first prompt generated on demand by a new `/mxm-handoff` command and offered as **Phase 4** of every `/mxm-session-end`. It is governed by the template at `templates/continuation-prompt.template.md`, renders to `.claude-sessions-memory/CONTINUATION-PROMPT.md` (runtime-local, gitignored) **and** prints inline for paste.

The standard has four parts:

**1. The anti-hallucination contract (the load-bearing rule).** The handoff prompt POINTS to source-of-truth and FORCES verification; it never substitutes for them. Concretely, every generated prompt MUST contain, in order: (a) a **READ-FIRST** list naming the three bridges (`SESSION_CONTINUITY.md` top block · `agents-handoff.md` · the memory index) to read before acting; (b) a **VERIFY-STATE** block of runnable git/version commands whose *output* overrides anything in the prompt, carrying the explicit rule **"where this prompt and the files disagree, the files win"**; (c) a short **SNAPSHOT** labelled *unverified orientation*; (d) the operator's open **DECISIONS** carried verbatim and flagged *do-not-decide-for-him*; (e) the **LOAD-BEARING RULES**; (f) a **FIRST-RESPONSE CONTRACT** requiring the next window to confirm-read + verify + summarize-back *before* starting work. Capability counts, full rosters, and long file bodies are **not** inlined — they are referenced at their source-of-truth path, because those are exactly the values a paste gets wrong.

**2. The trigger — self-assess + always ask (no fabricated meter).** `/mxm-session-end` **always** offers to generate the handoff prompt (it is a Phase-4 step, asked every run). Independently, the assistant **proactively recommends YES** when it self-assesses the session is heavy — long transcript, high tool-call volume, summarization/compaction already fired, or many files touched — phrased as a judgement ("context looks heavy — I recommend a handoff prompt"), **never** as a false percentage. `/mxm-handoff` generates one on demand at any time, mid-session, independent of session-end. This satisfies the operator's "85%+ → offer handoff" intent honestly: an always-on offer plus an evidence-based recommendation, with no invented gauge.

**3. Generation rules (so the prompt itself never hallucinates).** Every placeholder is filled from **verified session state only**. A value not verified this session is written as `UNVERIFIED — read <source> first`, never as a plausible-looking guess. The generator reads live state (git HEAD/branch/origin, the version source of truth, the inventory path) rather than trusting prior prose. The snapshot is kept short; verification re-derives truth.

**4. Relationship to existing continuity.** This is a **cousin of, not a replacement for**, `auto-compact.md`: auto-compact's compact-seed resumes the **same** conversation across in-place compaction; the continuation handoff resumes a **different/fresh** window or surface. Both are downstream of the ADR-002 session-end contract; the handoff prompt is a *projection* of `SESSION_CONTINUITY.md` + `agents-handoff.md` into a portable, paste-ready form — it adds a tenth optional artifact to session-end without altering the locked 9-document bundle (the bundle list itself is unchanged; the handoff is generated *from* it).

---

## Consequences

**Positive:**
- A fresh window resumes with zero context loss and a structural guard against hallucinating from stale prose — the verify-first contract catches drift in the first response, as it did this session.
- Honest by construction: no fabricated context-percentage; the trigger is an always-on offer plus an evidence-based recommendation.
- Cross-surface: the prompt is plain text, so it works on CLI, Desktop, and Web (unlike hooks, which are CLI-only). The generation is skill-driven, so it too is cross-surface.
- Reinforces the moat: anti-hallucination continuity is a visible instance of the governance Maxim sells.

**Negative / cost:**
- One more thing session-end asks. Mitigated: it is a single yes/no, and skippable in one keystroke for trivial sessions.
- The generated `.claude-sessions-memory/CONTINUATION-PROMPT.md` is a point-in-time artifact; if not regenerated it goes stale. Mitigated: it is runtime-local + gitignored, and its own header declares "verify against the repo — the files win," so a stale copy still self-corrects when used.
- Adds the 50th command (`/mxm-handoff`) and the 18th public ADR (this one) → capability counts move; propagated via `bootstrap/sync-counts.sh` per the Commit Protocol.

**Neutral:**
- The 9-document session-end bundle is unchanged; the handoff is an additive Phase-4 generation step, not a new locked document.

---

## Alternatives considered

- **Hard 85% context gate.** Rejected: no tool exposes a real context percentage; it would bake in an unmeasurable number, violating the never-hallucinate rule. Replaced by self-assess + always-ask.
- **Embed full state (counts, rosters, HEADs) directly in the prompt.** Rejected: that is the exact mechanism by which handoffs hallucinate. The verify-first / point-at-source design is the whole point.
- **Reuse `auto-compact.md` as-is.** Rejected: compact-seed targets same-conversation compaction and assumes the prior context is partially retained; the handoff targets a cold fresh window and must be fully self-orienting + verification-forcing.
- **CLI-only hook that measures transcript size as a proxy.** Considered and deferred: it would only fire in Claude Code CLI (hooks are CLI-only) and add a second, surface-split trigger path. The cross-surface self-assess + always-ask covers the need without the split; a transcript-size proxy can be added later as a pure enhancement if desired.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
