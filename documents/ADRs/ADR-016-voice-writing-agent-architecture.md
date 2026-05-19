# ADR-016 — Voice Writing Agent Architecture

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-15
- **Deciders:** DrNabeelKhan
- **Related:** ADR-007 (behavioral moat framing), ADR-009 (pack architecture), AGENT_ROSTER_v1.2_PROPOSAL.md

---

## Context

Maxim's brand-foundation system has three layers (Maxim base, operator overlay, per-startup
overlay) loaded by a CLAUDE.md doctrine that fires "before generating external-facing content."
The system works correctly when invoked but has two structural gaps the operator surfaced
during the v1.2 sprint planning conversation:

1. **The protocol is an opt-in checklist Claude must remember to apply.** Internal-facing
   content (code review comments, status reports, internal memos) skips voice loading. The
   operator wants every output Maxim produces to be in their voice by default.

2. **The newly introduced `VOICE_SELECTION.md` routing authority** (in `myVoiceDNA/`,
   v1.0, last updated 2026-05-19) is not yet wired into any Maxim agent. The 22-content-type
   routing table, variant selectors, crossover budgets, and token-discipline rules currently
   exist as a human-readable reference; no agent honors them automatically.

A protocol-based approach (amend CLAUDE.md to make voice loading universal) was considered
and rejected as insufficient. LLM judgment of "did I load the voice?" drifts silently.
An agent-based approach makes voice loading a property of the agent's invocation rather
than a checklist Claude has to remember.

---

## Decision

Introduce a **voice writing agent layer** under the CMO office, composed of:

### Component 1 — `nk-writer` agent (CMO office)

A single dedicated writer agent that produces all operator-voiced content. Triggers on any
writing verb (write, draft, compose, email, slack, blog, post, article, deck, paper, memo,
status, report, tutorial, doc, README, proposal, summary) UNLESS an active startup signal
indicates customer-facing content (which routes to the startup-specific writer).

The agent's DNA mandates a routing-first workflow:
1. Read `E:/Projects/nabeelkhan/myVoiceDNA/VOICE_SELECTION.md` at task receipt
2. Classify task → one of 22 content types (use Decision Tree section if ambiguous; ask operator if still ambiguous)
3. Detect variant where applicable (LinkedIn A/B · Email A/B/C · Pitch Deck A/B/C · Status Report Daily/Weekly/Biweekly/Monthly)
4. Load files per the routing-table row (never exceed 15K tokens of voice files)
5. Apply playbook structure + crossover budget per the row
6. Validate output against `core/quality-standards.md` before final emission

The agent NEVER caches the VOICE_SELECTION.md routing table in its DNA. It reads the file
fresh each task. This makes VOICE_SELECTION.md the single source of truth for voice routing
and prevents surface-claims-drift (Class 11) between the agent's beliefs and reality.

### Component 2 — `voice-routing` skill

A new skill at `.claude/skills/voice-routing/SKILL.md` that wraps VOICE_SELECTION.md as a
callable lookup. Input: task description + optional explicit content type. Output: routed
content type + variant + load list + crossover budget + phrasebook section.

Purpose: any agent (not just nk-writer) can ask "what voice configuration would I use for
this task?" without re-implementing the 22-row routing logic. The skill defers entirely to
the file; it does not embed the routing table.

### Component 3 — `_template-brand-writer.md` template (CMO office)

A template for per-startup brand writers. Instantiated by the operator on demand (when
they need to write for a specific startup). Each instance:
- Loads `core/*` files from myVoiceDNA (em-dash rule, vocabulary, quality-standards — baseline structural rules survive across all voices)
- Loads `.brand-foundation/startups/{name}/positioning.md` + `audience.md` + `compliance-rules.md` (STARTUP voice overrides operator voice for customer-facing content)
- Loads VOICE_SELECTION.md content-type playbook for STRUCTURE only
- Writes: structural skeleton from playbook + voice from startup brand

Per-startup instances are NOT pre-shipped. The template ships; instances are created by
the operator's setup workflow when an active startup needs a brand writer.

### Routing rule

`executive-router` is updated with one new dispatch rule:

```
IF task verb ∈ {write, draft, compose, email, slack, blog, post, article, deck, paper,
                memo, status, report, tutorial, doc, README, proposal, summary}:
   IF active_startup detected + customer-facing audience signal:
      → route to {startup}-brand-writer (if instantiated)
      → else fall back to nk-writer with startup overlay note
   ELSE:
      → route to nk-writer
```

The rule fires BEFORE the CSO auto-loop (which still runs after voice routing if security
signals are present).

### Token discipline (hard rule)

The nk-writer agent's DNA includes an explicit constraint:

> "If your loaded voice files exceed 15,000 tokens for a single-voice task, you have made
> a routing error. Stop and re-route through VOICE_SELECTION.md's matrix before continuing.
> Loading all 22 playbooks (89K tokens) is forbidden."

This enforces the anti-pattern catalog in VOICE_SELECTION.md.

---

## Consequences

**Easier:**
- Every writing task in Maxim routes through nk-writer (operator voice) or a brand-writer (startup voice). Voice loading becomes a property of agent invocation, not a doctrinal checklist Claude must remember.
- VOICE_SELECTION.md becomes a live routing authority — updates to the file propagate to the agent on the next task without code changes
- Per-startup writers compose by overlay: operator's structural rules + startup positioning
- Behavioral skills (Cialdini, Fogg, COM-B) compose orthogonally — voice handles style; behavioral handles content strategy
- Token discipline is enforceable at the agent layer, not as an honor system
- Audit trail per output is concrete: agent tag + content type + variant + voice files loaded + behavioral frameworks applied

**Harder:**
- Operators who type writing tasks without verb triggers (e.g., "give me a paragraph about X") rely on executive-router's fallback heuristics. Edge cases will surface and need Trigger refinement.
- VOICE_SELECTION.md becomes a Class 11 surface — if it's missing or malformed on the operator's machine, nk-writer fails loudly. (Fail-loud is correct here; silent voice drift is worse.)
- Per-startup writer instantiation is operator-driven. Until the operator sets up `aria-brand-writer`, customer-facing writing for ARIA falls back to nk-writer with a warning. (Acceptable for v1.2.)

**Locks us into:**
- VOICE_SELECTION.md as the canonical routing authority. Renaming or restructuring the file requires updating nk-writer's DNA path + voice-routing skill simultaneously.
- The 22-content-type taxonomy. Adding a 23rd content type requires only a row addition to VOICE_SELECTION.md (no agent change). Removing or renaming an existing type requires checking nk-writer's classification heuristics for backward compatibility.
- One CMO writer per startup. Federation across multiple writers (e.g., a "team voice" composite) is out of scope for v1.2 and would require a new ADR.

---

## Alternatives Considered

**Alternative 1 — Amend CLAUDE.md doctrine to make voice loading universal (rejected)**

Change CLAUDE.md § Brand Foundation Loading Protocol from "external-facing content" to
"any output." Keep the protocol-based loading.

Rejected because: LLM judgment of "did I apply the voice?" drifts silently. Internal tasks
that don't feel like writing (a JSON config, a quick TODO comment) skip the voice anyway
because Claude's judgment doesn't classify them as content. The agent-based approach makes
the routing explicit and Trigger-driven.

**Alternative 2 — Encode VOICE_SELECTION.md routing in the agent's DNA (rejected)**

Embed the 22-row routing table directly in nk-writer.md's DNA so the agent doesn't need
to read VOICE_SELECTION.md each task.

Rejected because: creates surface-claims-drift between agent DNA and the actual VOICE_SELECTION.md.
Operators will update VOICE_SELECTION.md and forget to update the agent. The agent must read
the file each task to stay current. The cost (one filesystem read per task) is trivial.

**Alternative 3 — Three separate agents instead of one + skill (rejected)**

Split into nk-writer + voice-router + nk-writer-validator agents, each with its own DNA.

Rejected because: over-engineered. The voice-routing logic is mechanical lookup work,
not LLM judgment work. Encoding it as a skill keeps the agent count low and gives any
future agent the same routing capability via skill invocation.

**Alternative 4 — Pre-instantiate per-startup writers at v1.2 ship (rejected)**

Ship aria-brand-writer + gulflaw-brand-writer + vazir-brand-writer + maxim-brand-writer
as net-new agents in the v1.2 roster.

Rejected because: most operators don't have those startups. Shipping unused agents inflates
the registry and creates capability-count drift for everyone. The template-on-demand model
lets operators activate only the writers they need.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
