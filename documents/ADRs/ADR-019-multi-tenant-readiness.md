# ADR-019 — Multi-Tenant Readiness (Tier Wizard + Operator-Writer Template)

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-20
- **Deciders:** DrNabeelKhan
- **Related:** ADR-004 (Free Tier Executable Contract), ADR-009 (Pack Architecture), ADR-016 (Voice Writing Agent Architecture), ADR-017 (Office-as-Dispatch-Boundary), ADR-018 (External Tool Integration Pattern)

---

## Context

Through v1.2.1.0, Maxim was operated almost entirely by its maintainer. Two single-tenant assumptions baked into the system surfaced as scaling blockers when external operators began testing the install:

1. **Pack installation friction (ADR-009 surface):** 14 paid packs (6 L1 · 4 L2 · 4 L3) each require a separate `/plugin install mxm-pack-X-Y-name@maxim-packs` invocation. New operators face 14 install decisions before they've seen the system work. Cognitive load violates Fogg B=MAP (Ability axis) — the first-run experience is too high-friction for the motivation a new operator brings.

2. **nk-writer single-tenant hardcoding (ADR-016 surface):** the `nk-writer` agent reads voice routing from `E:/Projects/nabeelkhan/myVoiceDNA/VOICE_SELECTION.md` — a path that exists only on the maintainer's machine. The agent is documented in `/mxm-help` as a CMO writing specialist but produces no useful output for any other operator. The 22-content-type structure, 3-voice taxonomy (FE/PA/TE), and 30-banned-jargon list are the maintainer's preferences, not Maxim's.

Both problems share a root cause: Maxim was built as the maintainer's personal operating system, then opened for others without refactoring the single-tenant assumptions. Operator testing in v1.2 sprint surfaced both gaps simultaneously.

The trial mechanic is the missing third piece. New operators evaluating Maxim need to **see** the gated capabilities before they decide which tier to commit to. Without a trial, the decision is "buy unseen" — which violates Prospect Theory (loss aversion on unverified spend) and kills conversion.

---

## Decision

v1.3.0 ships **multi-tenant readiness** as a unified release covering three coordinated changes.

### Change 1 — Tier-aware install wizard (replaces 14-command install with 1 decision)

`bootstrap/install-tier-packs.{sh,ps1}` runs on first invocation of `/mxm-install-tier` (or post-install hook if Claude Code supports it). The wizard:

- Presents 6 options in deliberate order: **Trial** (default · pre-selected) · Solo · Pro · Team · Enterprise · Individual
- Frames each tier by **capability**, not by **price** — Solo and Pro descriptions describe what's UNLOCKED, never what it costs (per operator directive)
- Uses **loss aversion** in capability descriptions: "audit trail on every AI decision" (preventing the loss of un-audited outputs) · "drift catching regressions BEFORE ship" (preventing wasted shipped-broken-thing time) · "voice LOCKED across outputs" (preventing voice-drift damage)
- Defaults to **90-day trial of all 14 packs** so the operator's first encounter with paid capabilities is exploration, not commitment
- Trial mechanic delegated to existing license-gate infrastructure (Cloudflare Worker issues 90-day-expiry JWT per ADR-003)

### Change 2 — Operator-Writer template pattern (generalizes ADR-016)

The existing `agents/MXM/cmo/nk-writer.md` **remains untouched as the canonical example** of an advanced operator-voice writer. Maxim ships a new template `agents/MXM/cmo/_template-operator-writer.md` that any operator can instantiate as their own writer agent.

Pattern (mirrors ADR-016's `_template-brand-writer.md` for startups):

| File | Authored by | Reads voice from |
|---|---|---|
| `_template-operator-writer.md` | Maxim ships | template — never directly invoked |
| `nk-writer.md` | Maxim ships (maintainer's instance) | `E:/Projects/nabeelkhan/myVoiceDNA/` (advanced 22-content-type structure) |
| `{operator-id}-writer.md` | Operator instantiates via `/mxm-brand-voice calibrate` | `.brand-foundation/personal.local/` (3-layer brand foundation Layer 2) |

The `cmo-office.md` writer-dispatch routing changes from `nk-writer` hardcoded to:

```
1. Read .brand-foundation/personal.local/operator-id.txt → operator-id
2. If {operator-id}-writer.md exists in .claude/agents/cmo/ → embody it
3. Else if Maxim's calibration has never been run → surface "/mxm-brand-voice calibrate to set up your operator-voice writer"
4. Else fall back to content-strategist (generic CMO writing without voice routing)
```

`/mxm-brand-voice calibrate` wizard (extended from existing per CLAUDE.md):

- Captures: operator handle · 3-5 voice characteristics · default Maxim banned-jargon list + operator additions · sentence-length preference · primary voice (FE/PA/TE or single)
- Writes: `.brand-foundation/personal.local/voice-profile.md` + `ai-tells.md` + `content-rules.md` + `operator-id.txt`
- Instantiates: `.claude/agents/cmo/{operator-id}-writer.md` from `_template-operator-writer.md` with operator-specific values filled in

### Change 3 — Public-facing documentation rewritten with use-cases + persuasion framing

All public-facing docs (README · MXM_RUNDOWN · ABOUT · HELP · INSTALL · GETTING_STARTED · PACKS · maxim-one-pager) are rewritten to:

- Lead with concrete operator use cases (Jobs-to-be-Done framing — "when an operator wants to X, Maxim does Y")
- Cite which MCP tools fire on each use case (9 MCPs × 87 tools made visible)
- Apply behavioral persuasion via ADR-007 framework citations on every section: Loss Aversion · Default Effect · Endowment Effect · AIDA · SCQA · Minto Pyramid · Diátaxis modes per content type
- Surface the trial mechanic prominently — "see what's behind the gate before you pay"

---

## Rationale

### Why no prices in the wizard for Solo/Pro

Anchoring (Tversky 1974) — showing prices first anchors the operator on cost rather than capability. The operator's first encounter with Maxim should be "look what I get" not "look what I pay." Pricing surfaces at activation (when they pick a paid tier) or at maxim.isystematic.com/pricing — they're not hidden, just deferred until after capability evaluation.

This matches Prospect Theory's reference-point principle: by the time the operator sees the price, they've experienced the moat. Their reference point is "Maxim's capabilities," not "$0." The price then frames as the upgrade cost, not the entry cost.

### Why Trial as default (not Solo)

Default Effect (Thaler & Sunstein 2008) — the default frames as the recommended path. Defaulting to Trial:

- **Reduces decision friction** (Fogg B=MAP, Ability axis) — operator just presses Enter
- **Enables endowment** (Kahneman & Knetsch 1991) — once they have all 14 packs working, giving them up after 90 days feels like loss, not "not buying"
- **Honors loss aversion** — operators who try then cancel have CONFIRMED what they're losing; their decision to cancel is informed, not speculative
- **Generates trial-to-paid conversion data** — Maxim can measure "trial-to-pack-purchase per tier" with the JWT system

### Why nk-writer stays as canonical example (not renamed)

Endowment Effect plus narrative continuity. nk-writer ships as a documented, working agent that demonstrates what an advanced operator-voice instance looks like. Renaming it would:

- Lose the documented example for new operators
- Break Mr. Khan's existing workflow (he uses nk-writer daily)
- Force a renaming cascade through ADR-016, HELP.md, MOAT_TRACKER, etc.

Keeping nk-writer as a named instance + shipping a `_template-operator-writer.md` lets new operators **see the template and the working example simultaneously**, then instantiate their own.

### Why all-in-one v1.3.0 (not two patches)

Both changes share the same root cause (single-tenant assumptions). Shipping them together:

- One restart for testers (lower friction)
- One CHANGELOG entry to document the shift (narrative coherence)
- One ADR (this one) covering the architectural transition
- One marketing moment ("Maxim v1.3.0 — multi-tenant readiness")

Splitting into v1.2.2.0 + v1.2.3.0 would fragment the message and double the test cycles.

### Why public docs get behavioral persuasion (not just informational rewrites)

ADR-007 (Behavioral Moat Framing Doctrine) requires every output to cite the framework justifying it. The public docs are outputs. Therefore they must frame capability claims with cited behavioral frameworks rather than generic marketing copy. This makes Maxim's positioning recursive — the documentation about behavioral intelligence is itself behaviorally intelligent.

The use-case rewrite serves Diátaxis (Procopiou 2017) — current docs are largely reference; new docs add tutorial (getting started) and how-to (use cases per capability) modes. Explanation mode (the ADRs) already exists.

---

## Consequences

### What this makes easier

- **First-run for new operators drops from 14 decisions to 1.** Tier wizard converts 14 install commands into 1 keypress (Trial default).
- **Voice work scales to every operator.** Template pattern means each operator has their own writer instance reading their own voice files. nk-writer becomes a documented example, not a single-point-of-failure.
- **Trial-to-paid conversion is measurable.** Trial JWT issuance + activation pattern feeds telemetry.
- **Public docs do the persuasion work that maintainer messaging did manually.** Operators evaluating Maxim get the moat case framed in operator-voice, with concrete use cases, cited behavioral frameworks, and visible MCP capability surface.
- **Maxim transitions from "Mr. Khan's tool" to "operator-team product" structurally**, not just nominally. The architecture matches the positioning.

### What this makes harder

- **Operator-writer instantiation adds a setup step.** Other operators must run `/mxm-brand-voice calibrate` before voice routing works for them. Documented in onboarding, but it's a step.
- **Tier wizard requires post-install hook OR first-run detection.** If Claude Code plugin manifest doesn't support post-install hooks, the wizard runs on first `/mxm-help` or `/mxm-status` invocation — slightly delayed entry to the wizard surface.
- **License-gate trial mechanic depends on Cloudflare Worker reliability.** If the worker is down, trial issuance fails. Operator experience degrades. Mitigation: cached trial JWT + grace period (per ADR-003, confidential).
- **Public docs become a much larger maintenance surface.** Every capability claim now needs a use case story + framework citation. Update cadence on capability docs increases.

### What this locks us into

- **The tier wizard becomes the canonical first-run surface.** Future changes to pack lineup must update the wizard's options. ADR-009 amendments touch this ADR too.
- **The `_template-operator-writer.md` becomes a contract.** Future ADRs modifying ADR-016 voice routing must preserve the template pattern.
- **Public docs' use-case framing becomes part of Maxim's positioning.** Reverting to dry reference-only docs would break operator-evaluation flow.

### Migration shape (if reversal needed)

- Tier wizard reversal — remove `bootstrap/install-tier-packs.{sh,ps1}` + `/mxm-install-tier` command. Operators revert to manual per-pack install. Documented in HELP.md.
- Operator-writer reversal — keep `_template-operator-writer.md` shipped (no harm); revert `cmo-office.md` to nk-writer-direct dispatch. Other operators lose generic voice routing but Mr. Khan's setup keeps working.
- Public docs reversal — git revert. Docs are non-executable; no operational impact.

All three are independently reversible.

---

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| **Ship all 14 packs bundled into Maxim plugin (no wizard)** | Free-tier users download code they can't use. Plugin size 5–10×. Confusing UX (paid code visible but gated). |
| **No trial, ask operator to pick a tier upfront** | Buy-unseen pattern. Violates Prospect Theory. Kills conversion. |
| **Trial requires credit card upfront** | High-friction. Defaults operators to "no, thanks" rather than "let me try." Loss aversion against form-filling. |
| **Show prices in wizard** | Anchors operator on cost rather than capability. Per operator directive: not in wizard. Prices live at maxim.isystematic.com/pricing. |
| **Rename nk-writer to operator-writer** | Breaks Mr. Khan's workflow. Loses documented example. Cascading doc updates. ADR-016 churn. |
| **Operator-writer reads operator voice from project-manifest** | Voice config doesn't belong in project-manifest (cross-project concern; voice is per-operator-per-machine). Three-layer brand-foundation already designed for this. |
| **Split into v1.2.2.0 + v1.2.3.0** | Fragments the narrative. Two test cycles. Doubles tester friction. |

---

## Behavioral framework citations (ADR-007 compliance for this ADR)

This ADR's positioning depends on:

- **Fogg Behavior Model (B=MAP)** — Behavior happens when Motivation × Ability × Prompt converge. Reducing the install from 14 decisions to 1 increases Ability; the trial default reduces Motivation friction; the wizard itself is the Prompt.
- **Prospect Theory (Kahneman & Tversky 1979)** — Loss aversion (~2× over gain). Operators evaluating Maxim feel loss on capabilities they don't have access to but might need. The trial lets them experience the gated capabilities, then evaluate "what would I lose by giving this up?" — a much stronger conversion signal than "should I buy this?"
- **Default Effect (Thaler & Sunstein 2008)** — Trial as default frames as the recommended path. Endowment-effect setup.
- **Endowment Effect (Kahneman & Knetsch 1991)** — Once operators have the trial running, the packs become "theirs." Giving them up triggers loss aversion. Conversion strengthens.
- **Anchoring (Tversky 1974)** — Capability-first framing anchors operator on what they GAIN before the price (anchored on $0 baseline) frames the upgrade cost.
- **Diátaxis (Procopiou 2017)** — Documentation modes (tutorial · how-to · reference · explanation) — public docs rewrite adds the missing tutorial + how-to modes.
- **AIDA (Strong 1925)** — Attention · Interest · Desire · Action — public doc structure.
- **SCQA (Minto 1973)** — Situation · Complication · Question · Answer — README and ABOUT framing.

---

## References

- **Operator directive** (2026-05-20): "all packs by default... ask user which packs... use behavioral persuasive skills for trial option."
- **ADR-009** Pack Architecture — defines the 14 packs this wizard installs.
- **ADR-016** Voice Writing Agent Architecture — establishes the `_template-{X}-writer.md` pattern this ADR extends.
- **ADR-003** (confidential) — License issuance infrastructure for trial JWTs.
- **ADR-004** Free Tier Executable Contract — defines what Core ships at $0.
- **CLAUDE.md** § Brand Foundation — three-layer architecture this ADR builds on for operator-writer voice loading.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
