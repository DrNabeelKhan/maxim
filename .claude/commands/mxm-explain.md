---
description: TIER 1 verb-first — explain code, concept, framework, or system. Routes to smart-explorer + the relevant office expert with plain-language confidence tag per ADR-010.
---

# /mxm-explain

## Usage
- Claude Code: `/mxm-explain <what to explain>`
- Claude CLI: `claude "/mxm-explain <what to explain>"`
- Claude Desktop: type `/mxm-explain <what to explain>` in chat

User-facing verb-first command (TIER 1 surface added v1.2.0). The plain-English entry point for understanding code, concepts, frameworks, or system behavior — without needing to know which office owns the topic.

**Triggers:** "explain", "what does this do", "help me understand", "walk me through", "what is", "why does", "how does", "tldr", "summarize"
**Primary tool:** `smart-explorer` (community-packs/claude-mem/smart-explore skill) — token-optimized structural code search using tree-sitter AST parsing
**Routed expert (the office that owns the subject):**
- Architecture, system design, capability map → CEO `enterprise-architect`
- Code, infrastructure, AI, APIs, data pipelines → CTO `implementer` (or routed specialist)
- Marketing, content, brand, SEO mechanics → CMO `content-strategist`
- Security, compliance, threat model → CSO `security-analyst`
- Product strategy, UX, JTBD, OKR → CPO `product-strategist`
- Operations, sprints, runbooks, post-mortems → COO `planner`
- Innovation, emerging tech, horizon scanning → CINO `innovation-researcher`
- Maxim itself — framework, ADR, MOAT_TRACKER row → executive-router answers from the canonical ledgers

**Reads:** the file or symbol named in the argument · `documents/reference/FRAMEWORKS_MASTER.md` (if framework named) · `documents/ADRs/INDEX.md` (if ADR referenced) · `documents/ledgers/MOAT_TRACKER.md` (if moat claim referenced)

## Behavioral Overlay

- **Plain-language confidence tag (per ADR-010 Technical Educator Rubric):** Explanations are tagged on a transparency axis, not just a correctness axis. 🟢 HIGH = explanation grounded in source files Claude actually read in this turn. 🟡 MEDIUM = explanation grounded in framework / ADR / documented behavior but Claude did not re-verify the current source. 🔴 LOW = explanation is general knowledge / interpretation without a specific source citation in this repo. The operator sees the tag at the top of every explanation and can ask Claude to upgrade it by reading the relevant files.
- **Audience-aware framing:** Operator preference (`config/project-manifest.json → operator-profile`) tunes vocabulary depth. Cold sessions default to "skilled technical reader" register; deeper explanations available on request.
- **No over-claim:** if the explanation requires reading files Claude has not opened in this turn, the response says so explicitly and offers to read them rather than inventing.

## Behavior

1. **Subject classification** — is the argument a file path? a symbol? a framework name? an ADR? a concept? a Maxim capability? Route classification determines which expert loops in.
2. **smart-explorer pass** — if the subject is a file/symbol in this repo, run tree-sitter AST exploration first to ground the explanation in actual code structure (not generic LLM lore).
3. **Office routing** — auto-route to the office that owns the subject domain. The expert agent provides the framework-aware explanation; smart-explorer provides the structural grounding.
4. **Source citation** — every explanation cites the files, frameworks, or ADRs it draws from. Citations are clickable (file_path:line_number format).
5. **Plain-language layer** — translate office-specific jargon into the operator's working vocabulary. Default register: skilled technical reader.
6. **Confidence tag** — apply ADR-010 rubric: 🟢 / 🟡 / 🔴 based on grounding depth in this turn.
7. **Offer next step** — at the end of every explanation, suggest the most useful follow-up: "want me to also read X?", "want to see a worked example?", "want me to write a memo on this?"

## Anti-patterns (rejected)

- Generic LLM-lore explanation when the answer is in this repo (use smart-explorer first)
- Explanation that does not cite its sources (every explanation gets a citation block)
- "It's important to note that..." filler and other 30-banned-jargon-term openers (per `myVoiceDNA/core/shared-vocabulary.md`)
- Over-claiming certainty — 🔴 LOW tag exists for a reason; use it honestly

## TIER 1 surface note

Thin router-frontend; smart-explorer + the routed office expert do the work. The operator does not need to know whether the subject lives in CEO, CTO, or CSO territory — type the question, get the answer with sources cited.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 1 surface added v1.2.0 per AGENT_ROSTER_v1.2_PROPOSAL.md._
