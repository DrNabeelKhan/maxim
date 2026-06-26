# Maxim — 30 Everyday Skills · 50 Autonomous Workflows · Bounded Loops

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
> **Status:** draft · aligned to v1.3.8 · marketing one-pager
> **Headline (locked):** *30 everyday skills · 50 autonomous workflows · bounded loops.*

---

## The one line

**30 everyday skills. 50 autonomous workflows. Bounded loops. One governed layer no standalone tool has.**

---

## The idea — three ways to put AI to work

| Layer | What it is | When you use it |
|---|---|---|
| **Skills** | one-shot tools — *"write a post," "build an app," "make an invoice"* | you want a thing, now |
| **Loops** | repeat-until-right — Maxim redoes the work against a stopping condition **while you watch** | "iterate until the tests pass / it's on-brand" |
| **Workflows** | run **unattended** — Maxim works while you're away, with brakes | "do this every morning / overnight without me" |

The difference that matters: a **loop** assumes you're in the chair, so it can stay light. A **workflow** assumes you're *gone* — so it ships with a hard budget, a separate verification gate, and dry-run-by-default. That's the part everyone else skips.

---

## Why Maxim instead of 30 separate apps

Every output Maxim produces carries the layer the point tools don't:

- **A named framework** behind the work (Cialdini, Fogg, MEDDIC, Porter…) — cited, not vibes (ADR-007).
- **A confidence tag** — 🟢/🟡/🔴 — so you know when to trust it and when to check (ADR-010).
- **A security auto-loop** — anything touching personal/regulated data routes through a compliance gate you can't bypass.

Thirty tools give you thirty outputs. Maxim gives you thirty *governed* outputs from one layer that learns your voice, your brand, and your standards.

---

## The 30 everyday skills (the menu)

**24 are live as dedicated one-tap skills today; the other 4 on-brand are delivered through Maxim's existing engine. (Only the 2 personal-life skills are out of scope.)**

- **Content:** Voice Match · Quote Engine · Repurpose Engine · Hook Lab · Post Analyzer
- **Building:** Spec→App · Bug Hunter · Code Reviewer · Deploy Helper · API Wiring
- **Freelance:** Lead Qualifier · Proposal Writer · Scope Guard · Client Update · Invoice Builder
- **Design:** Brand Kit · Landing Page · Logo Concepts · UI Critique · Slide Designer
- **Life & work:** Morning Brief · Inbox Triage · Decision Helper *(personal-life skills intentionally out of scope)*
- **Research:** Company Teardown · Daily Digest · Source Checker · Paper Summary · Competitor Watch

*Honesty note for internal use:* of the 30 → **24 dedicated skills** · 4 delivered via existing capability (Deploy Helper → `/mxm-ship` · API Wiring → `api-integrator` · Client Update → `changelog-writer` · Morning Brief → `/mxm-ceo-morning`) · 2 skipped (Meal/Travel — off-brand). **All 28 on-brand are covered, 0 gaps.** Inbox Triage, Daily Digest & Competitor Watch also ship **unattended dry-run workflow** versions (consume connectors, never auto-act).

---

## The 50 autonomous workflows (what's actually real)

Maxim ships the **Autonomous Workflow Standard** (ADR-022) and the **`mxm-orchestrator`** that runs it — plus a **catalog of 50 workflow blueprints** spanning content, code, sales, research, support, and ops. You **build any of the 50 on demand**, and every one inherits the same brakes:

- **Budget guard** — hard token / cost / time / call limits; a runaway hard-stops.
- **Separate verification** — nothing ships unattended without passing a checker.
- **Dry-run by default** — it shows you what it *would* do before it's allowed to act.
- **Idempotent + logged** — never double-sends; every step is recorded.

**Proof, not promise:** the orchestrator's guard-breach test passes **29/29** — a workflow told to overspend is killed *before* anything reaches the outside world.

---

## Bounded loops

The "do X until it's right" engine: drive test coverage to a floor, sweep a repo for a recurring bug, ratchet quality across rounds — each with an **explicit stop** and an **independent verification pass**. A Maxim loop never reports a stall or an exhausted budget as success.

---

## The moat line

> **Everyone else sells you autonomy. Maxim sells you autonomy you can *trust* — bounded, verified, logged, and dry-run by default.**

That's the line that matters to the buyer who can't afford a runaway: the regulated team, the agency on a client's data, the founder who can't babysit the bot.
