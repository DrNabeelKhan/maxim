# ADR-010 — Confidence Tag Technical Educator Rubric

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** ADR-007 (moat framing)

---

## Context

Maxim tags every output with a confidence signal (🟢 HIGH, 🟡 MEDIUM, 🔴 LOW, 🔵 SUPER USER, 🔐 GATED). Without a rubric, these tags drift toward "🟢 everything" because the model has no incentive to downgrade itself.

The Technical Educator voice is one of Maxim's three voice variants (with Philosophical Architect and Friendly Educator — see `.brand-foundation/`). It is also the voice most useful for explaining *why* a confidence tag was chosen, because it frames claims with explicit epistemic structure.

---

## Decision

Every 🟢 HIGH, 🟡 MEDIUM, and 🔴 LOW tag MUST be justified with a four-line rubric in the Technical Educator voice:

```
Basis — [what supports this confidence level]
Gap — [what is missing or uncertain]
Mitigation — [what the reader should do to close the gap]
Next — [what would move the confidence up or down]
```

Concretely:

- **🟢 HIGH** requires a Maxim skill match + cited framework + no open gaps that affect the output's usability.
- **🟡 MEDIUM** applies when there is either a framework match without a skill match, or a skill match with a known gap.
- **🔴 LOW / Maxim-UNENHANCED** applies when the output comes from an external pack with no Maxim behavioral overlay, or when the skill match is absent and the output is generic-LLM-quality.
- **🔵 SUPER USER** suppresses CSO auto-loop and compliance pre-enforcement per `config/project-manifest.json` `super_user.enabled = true`.
- **🔐 GATED** applies when the project's `status.gated = true` — the output is provisional pending explicit operator approval.

---

## Rationale

The four-line rubric gives the reader a decision surface, not just a color. "🟢 HIGH — Basis: skill X applied framework Y. Gap: customer-specific data not validated. Mitigation: run `/mxm-review` with customer context. Next: confirm with the customer before shipping." is actionable. "🟢 HIGH" alone is not.

The Technical Educator voice is chosen because the structure (claim + gap + mitigation + next) is how the voice naturally speaks. Trying to communicate confidence in a more sales-y voice produces reliability theater.

---

## Consequences

**Easier:** auditing Maxim output quality (do the tags parse against the rubric? are 🟢s actually 🟡s?). Building trust with buyers who want to see the reasoning. Training new contributors to write at a consistent epistemic standard.

**Harder:** writing outputs quickly — the rubric is a small tax on every response. Skills that produce high-volume short outputs (e.g., email drafts) adopt a compact variant (single-line Basis, Gap).

**Locks us into:** the four-line rubric shape. Simplifying it would be a breaking change for any integration that parses confidence metadata.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
