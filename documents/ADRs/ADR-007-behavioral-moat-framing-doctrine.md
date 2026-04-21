# ADR-007 — Behavioral Moat Framing Doctrine for SKILL.md files

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** documents/ledgers/MOAT_TRACKER.md

---

## Context

Every SKILL.md in Maxim has two readers: the Claude model executing it and the human buyer reading it. A skill file that reads like a generic "you are a helpful assistant" prompt fails both. The model can't distinguish it from the 536 SKILL.md files in alirezarezvani's library. The buyer can't articulate why Maxim is worth $19.99/mo.

The doctrine is the fix — an in-file standard that makes Maxim's moat legible on every page.

---

## Decision

Every SKILL.md in Maxim MUST open with three anchored claims, in this order:

1. **Mechanism claim.** One sentence naming the behavioral science mechanism this skill applies, with author and year in brackets. No hedging. Example: *"Every banner output applies pre-attentive attribute theory [Treisman, 1980] as its primary framing mechanism."*
2. **Anti-pattern claim.** One sentence describing what a non-Maxim (generic LLM) output looks like for the same request, so the reader can tell them apart. Example: *"A generic LLM will propose visually balanced layouts; Maxim's banner skill deliberately breaks balance to trigger pattern interruption."*
3. **MOAT row citation.** Every SKILL.md that ships as a paid pack cites a `MOAT-NN` row from documents/ledgers/MOAT_TRACKER.md. If no row exists, no moat claim is allowed (enforced by pre-commit hook).

A SKILL.md may add more structure (references, examples, checklists), but these three claims are mandatory and positioned at the top.

---

## Rationale

The moat only counts if the buyer can see it. A confidence tag on the output is a weak signal; a mechanism + anti-pattern pair in the skill file is a strong signal. The cross-link to documents/ledgers/MOAT_TRACKER.md closes the loop: marketing copy, investor decks, and SKILL.md files all pull from one source of truth.

The alternative — "moat lives in the model's behavior and you'll know it when you see it" — is how most AI products position themselves. The buyer experiences it as indistinguishable quality and prices it as a commodity.

---

## Consequences

**Easier:** writing landing copy (pull from MOAT_TRACKER), reviewing a pack contribution (does it cite a moat row? does the mechanism claim parse?), explaining pricing to a buyer (each tier unlocks specific mechanism claims).

**Harder:** shipping a skill without a citable framework. "Vibes-based" skills don't clear the bar — the operator has to either find a framework or decline to ship.

**Locks us into:** the documents/ledgers/MOAT_TRACKER.md dependency. A SKILL.md cannot ship in advance of its moat row.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
