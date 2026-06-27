# Series — "Maxim by Use Case" (Skills × Loops × Workflows)

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
> **Status:** draft content plan · aligned to v1.3.8.2
> **Premise:** every episode shows ONE persona's real day, combining a few **skills**, one **loop**, and one **workflow** — so viewers learn the 3-layer model by watching it solve their problem, not by reading a feature list.

---

## The spine (state it once, in Ep 0, then never lecture again)

- **Skill** = one-shot. **Loop** = repeat-until-right, you're watching. **Workflow** = runs unattended, with brakes.
- Every episode ends on the same beat: *"…and because it's Maxim, it told you how confident it was and never faked a result."*

---

## Episodes

### Ep 0 — "Three ways to put AI to work" (the primer, 60–90s)
The whole series in one frame: skill vs loop vs workflow, one example each. Hook: *"Most people use AI one way. There are three."* CTA: follow for your job's episode.

### Ep 1 — Creator: "Post daily without burning out"
- **Skills:** Voice Match → Repurpose Engine → Hook Lab.
- **Loop:** content-quality-streak (keep drafting until N posts clear the bar).
- **Workflow:** ingest→publish pipeline (drop a transcript → drafts waiting for you each morning).
- **Aha:** one idea → a week of on-voice content, in your voice, while you sleep.

### Ep 2 — Freelancer: "Stop leaking billable hours"
- **Skills:** Lead Qualifier → Proposal Writer → Scope Guard → Invoice Builder.
- **Workflow:** follow-up sequence (stalled deals get tailored nudges — drafts, never auto-sent).
- **Aha:** from "is this lead worth it?" to a sent invoice without rewriting a single template.

### Ep 3 — Founder: "Out-position your competitors"
- **Skills:** Company Teardown → Landing Page → Decision Helper.
- **Loop:** champion-challenger (a new positioning ships only if it beats the incumbent on a frozen test).
- **Workflow:** competitor-monitor (pings you only on a *real* move, dry-run first).
- **Aha:** you find out about their launch the day it happens, with a teardown already written.

### Ep 4 — Indie builder: "Ship while you sleep"
- **Skills:** Spec→App → Bug Hunter → Code Reviewer → Deploy Helper.
- **Loop:** coverage-to-100 (ratchet tests up, never silently down).
- **Workflow:** overnight bug-sweep (opens a PR for your morning review — never merges itself).
- **Aha:** wake up to a green PR, not a 2am alert.

### Ep 5 — Researcher / analyst: "Never miss the one thing"
- **Skills:** Paper Summary → Source Checker → Daily Digest.
- **Loop:** recent-feedback-sweep (find every place a corrected mistake recurs, fix each).
- **Workflow:** second-brain ingestion (raw folder → a linked, queryable wiki).
- **Aha:** ten sources a day collapse into one filtered brief — with the shaky claims flagged.

### Ep 6 — The closer: "Autonomy you can trust" (the moat)
Not a persona — the *why*. Show the guard-breach test live: a workflow told to overspend gets **hard-stopped before anything ships**, dry-run shows-don't-does, every step logged. Hook: *"The scary part of an AI that works while you sleep is the part nobody shows you."* CTA: for teams on real/regulated data.

---

## Professional personas — the `/mxm-*` command surface

> The episodes above lead with an everyday **skill**. These lead with a **command** — one word in your role's vocabulary that routes to the specialist who owns it, loads the named frameworks, and can run the workflow unattended. Same 3-layer spine (skill · loop · workflow); deeper buyer. Each names the frameworks on screen, so the viewer sees the *mechanism*, not a feature bullet.

### Ep 7 — Founder: "Out-position, then price it" → `/mxm-founder`
- **Frameworks:** Duarte Sparkline · Minto Pyramid · AARRR · Prospect Theory · Van Westendorp · Strategyzer BMC.
- **Workflow:** competitor-monitor — real moves only, teardown pre-written, dry-run first.
- **Aha:** a pitch that survives a skeptical investor — narrative, pricing, and moat in one pass.

### Ep 8 — Enterprise architect: "The artifacts, not the advice" → `/mxm-arch`
- **Frameworks:** TOGAF · C4 Model · ArchiMate · Wardley Mapping · Tech Radar · ADR authoring.
- **Workflow:** architecture-drift watch — flags when the code diverges from the documented target architecture.
- **Aha:** a target architecture, C4 diagrams, a Wardley map, and the ADRs — authored, not summarized. Maxim ran this discipline on itself: 21 ADRs.

### Ep 9 — Data leader: "Govern the data, by the book" → `/mxm-arch` (data-architect)
- **Frameworks:** DMBOK (DAMA) knowledge areas · Zachman · master & reference data · data quality.
- **Workflow:** data-governance audit under the CSO compliance gate.
- **Aha:** a DMBOK-grounded data-governance plan — knowledge areas, not a generic best-practices list.

### Ep 10 — Counsel / GRC: "Cite the clause, not a summary" → `/mxm-legal`
- **Frameworks:** 14 compliance frameworks (GDPR · HIPAA · PCI-DSS · SOC 2 · EU AI Act · +9), jurisdiction-aware.
- **Workflow:** ROPA + DPIA drafting; PII scanned before anything leaves the session.
- **Aha:** the exact clause, the exact jurisdiction — a review you can hand to an auditor.

### Ep 11 — CISO / AppSec: "Threat-model while you sleep" → `/mxm-secure`
- **Frameworks:** triple-OWASP (Top 10 + LLM + API) · STRIDE / PASTA / LINDDUN · NIST CSF + AI RMF · MITRE ATLAS · SBOM / AIBOM.
- **Workflow:** overnight security sweep — opens a PR with findings for review, never merges itself.
- **Aha:** a threat model and a bill of materials, generated — not a checklist someone forgot to run.

### Ep 12 — Product manager: "Outcomes, not feature lists" → `/mxm-pm`
- **Frameworks:** Jobs-to-be-Done (Jobs Atlas) · OKR (leading + lagging) · RICE · INVEST.
- **Workflow:** user-feedback sweep — clusters raw signals into JTBD outcomes, surfaces the highest-RICE next bet.
- **Aha:** a PRD grounded in method — the next bet defensible, not a hunch.

> **Site tie-in:** these six map 1:1 to the persona cards on the new `/features` page. An episode is the *motion* version of a card; the card is the *scannable* version of the episode.

---

## Format & production notes

- **Length:** 45–90s each (Reel/Short native). Ep 0 and Ep 6 can run longer (educational + trust).
- **Production:** these are a perfect fit for the existing **beat-system video pipeline** (Remotion + Kokoro/ElevenLabs voice + per-brand tokens) — each episode is a script → MP4, on the Maxim brand. *(Pipeline lives in the personal repo; reuse the engine, render on Maxim brand assets.)*
- **Sequencing:** ship Ep 0 first, then the persona episode matching your loudest audience segment, then the closer. Don't ship all at once — prove one lands.
- **Honesty guardrail:** every episode must be demonstrable on a live build. No workflow shown as "shipping" that isn't built; the digest/competitor episodes show the *dry-run*, not a fake auto-send.

---

## CTA ladder (per episode)

Follow (Ep 0) → "which one are you?" (persona eps) → try the free skill named in the episode → book/trial for the workflow layer (Ep 6). Each episode names **one** skill the viewer can try in the next 60 seconds.
