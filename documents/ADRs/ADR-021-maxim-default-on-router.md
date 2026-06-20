# ADR-021 — Maxim Default-On (Always-On Intent Router)

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-06-19
- **Deciders:** Mr. Khan (operator) · CEO office / enterprise-architect
- **Related:** ADR-002 (executable contracts) · ADR-007 (framework citation) · ADR-008 (community packs) · ADR-010 (confidence tagging) · ADR-017 (office-as-dispatch-boundary) · ADR-018 (external-tool integration)

---

## Context

Maxim's moat is its behavioral + governance layer, but it is **opt-in**: the operator must explicitly type `/mxm-design`, `/mxm-cmo`, etc. If they forget, Claude Code takes its default route and produces generic ("cookie-cutter") output even though Maxim has a rich, matching skill. The CLAUDE.md dispatch sequence *says* "every task routes through Maxim," but that is an instruction the model follows unreliably — there is **no enforcement**. The result: Maxim's 37 skills, 78 frameworks, 91 agents, and the v1.3.4 fallback registry (1000+ external skills) sit unused unless summoned.

This was the operator's most-cited usability failure ("I designed a page and got a cookie-cutter website"). The fix is to make Maxim **default-on**: route automatically on every prompt, not on a remembered command.

The known cost of always-on routing — token + latency overhead per prompt, and the risk of mis-routing or over-routing — must be *visible and controllable*, not hidden.

---

## Decision

Maxim ships an **always-on intent router** as a `UserPromptSubmit` hook (`.claude/hooks/user-prompt-router.{sh,ps1}`). On every prompt it:

1. **Classifies intent** against an operator-editable routing table (`config/routing-table.json`) — keyword/deterministic, no LLM call.
2. **Injects a routing directive** (only on a confident match) telling Claude which office + skills + frameworks to use, and to apply the Maxim overlay (ADR-007 citation + ADR-010 confidence tag). On a *no native skill* signal, it points at the v1.3.4 fallback (`mxm-find-skill`).
3. **Shows the routing token cost to the user** — the injected directive instructs Claude to open its response with a one-line banner: `🧭 Maxim: <office> · <skills> · <frameworks> · routing ~N tokens`. The token tax is therefore visible on every routed turn, so the operator can judge whether it's worth it.
4. **Respects an opt-out** — a config toggle (`routing-table.json: "enabled": false`) or a per-session sentinel (`.mxm-skills/router-off`) disables injection entirely; an unmatched prompt passes through silently (vanilla behavior preserved). The router is **conservative by default**: it injects only on a clear match, never on ambiguous prompts.

The classifier is **deterministic keyword matching** in this version. An LLM-classifier upgrade is explicitly deferred (see Alternatives).

---

## Rationale

- **Enforcement, not instruction.** A `UserPromptSubmit` hook fires deterministically on every prompt — it cannot "forget" the way the model following a CLAUDE.md instruction does. This is the only mechanism that makes Maxim genuinely default-on. 🟢
- **Transparency over hidden cost.** The operator explicitly asked to *see the routing token cost*. Making the tax visible (the banner) — rather than silently spending it — lets the operator make an informed call and builds trust that Maxim isn't bloating every prompt invisibly. 🟢
- **Conservative + opt-out = safe.** Over-routing (forcing the heavy treatment on a quick question) is the real failure mode. Injecting only on a confident keyword match, with a one-toggle opt-out, bounds the downside. A miss costs nothing (silent passthrough). 🟡 MEDIUM-HIGH
- **Deterministic first.** A keyword classifier is free, fast, predictable, and ships now. An LLM classifier is smarter but costs a model call per prompt and adds latency — earn it after the cheap version proves the pattern. 🟡
- **It completes the v1.3.3–v1.3.4 arc.** The router is the consumer of the `loops` skill (v1.3.3) and the `mxm-find-skill` fallback (v1.3.4): classify → route to native skill, or → fallback search, or → loop orchestration. The pieces were built; this wires them to fire automatically. 🟢

---

## Consequences

**Makes easier:**
- Maxim's skills/agents/frameworks fire without the operator remembering a command — the cookie-cutter problem is structurally addressed.
- The fallback registry (v1.3.4) becomes automatic on a skill miss.
- Routing is auditable (logged to `.mxm-skills/routing-log.jsonl`) and tunable (the operator edits the routing table).

**Makes harder / costs:**
- A token + latency tax on every prompt (bounded by the conservative match + made visible by the banner).
- The routing table is a new surface to maintain as offices/skills evolve.
- Keyword classification will mis-route on novel phrasings; the opt-out and the "miss = passthrough" default bound the harm.

**Locks in:** the `UserPromptSubmit` hook as Maxim's routing enforcement point. Reversal is clean: remove the hook from `hooks.json` (one edit) → Maxim returns to opt-in, no migration.

---

## Alternatives considered

- **LLM-classifier hook** — richer intent understanding, but a model call + latency per prompt. **Deferred** to a future ADR once the deterministic version is validated; the routing table is designed so the classifier can be swapped without changing the contract.
- **Skill-description tuning only** — strengthen each skill's `description` so the model auto-activates it. Lightest, but unenforced and unreliable (the status quo's failure). Rejected as the primary fix; still worth doing as a complement.
- **Always-inject (non-conservative)** — route every prompt unconditionally. Rejected: over-routes quick questions, maximizes the token tax, and erodes trust.

---

## Surface compatibility (verified 2026-06-19 against code.claude.com docs)

The `UserPromptSubmit` contract was verified correct against the Claude Code docs: the event exists ("before Claude processes it"), the `prompt` + `cwd` input fields are real, the emitted `{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"..."}}` schema is the documented format, exit-0 adds stdout as context (exit-2 *erases the prompt* — which is why the router only ever exits 0), `${CLAUDE_PLUGIN_ROOT}` is exported to hook processes, and the plugins reference lists `UserPromptSubmit` among plugin-shippable hook events. 🟢

**But hooks are a Claude Code CLI-exclusive feature.** They do **not** run in Claude Desktop / Web / Cowork (open parity request: [anthropics/claude-code#45514](https://github.com/anthropics/claude-code/issues/45514)). Consequence:
- **Claude Code CLI:** Maxim is default-on (the router fires). ✓
- **Claude Desktop / Web / Cowork:** the router does **not** fire — Maxim falls back to **opt-in** (the pre-v1.3.5 behavior). No regression, but "default-on" is a CLI property until Desktop hook parity ships. Skills, commands, and MCP servers remain cross-surface; only the hook-based router is CLI-bound.

**Known upstream bug to verify on install:** [anthropics/claude-code#10225](https://github.com/anthropics/claude-code/issues/10225) reports plugin `UserPromptSubmit` hooks may "match but never execute" in some versions. After restart, confirm the `🧭 Maxim:` banner actually appears; if it doesn't fire in CLI, that's the upstream issue, not the hook's logic (the contract is verified correct). 🟡

---

## References

- Session-23 simplification brainstorm (the `prompt → Router brain → Office → Agents → Skills` flow) — `documents/architecture/MAXIM_LOOP_ADOPTION_PLAN.md` + chat.
- Consumers: `loops` skill (v1.3.3, ADR-002/007) · `mxm-find-skill` fallback (v1.3.4, ADR-008) · `mxm-catalog.route_task` MCP (intent→agent routing, ADR-017).
- Implementation: `.claude/hooks/user-prompt-router.{sh,ps1}` · `config/routing-table.json` · `.claude/hooks/hooks.json` (`UserPromptSubmit`).
- **Numbering note:** ADR-020 is the (confidential) PaaS direction. The previously-floated ADR-021 (pre-release-audit discipline) and ADR-022 (cross-language path resolution) remain unwritten and take the next free ids (022+). This ADR claims 021 per operator direction (2026-06-19).

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
