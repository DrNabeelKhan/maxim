# ADR-017 — Office-as-Dispatch-Boundary + MCP-Catalog Specialist Surface

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-19
- **Deciders:** DrNabeelKhan
- **Related:** ADR-001 (agent dispatch baseline · confidential), ADR-002 (Documents as Executable Contracts), ADR-007 (Behavioral Moat Framing), ADR-016 (Voice Writing Agent Architecture)

---

## Context

Maxim ships **91 specialist agents** across 7 executive offices + orchestrators (per v1.2.0 GA roster reorganization). The marketing claim, the `/mxm-help agents` catalog, the executive-router routing table, and the `mxm-catalog` MCP all assert these 91 as the agent surface.

But Claude Code's actual subagent dispatch mechanism — the `Agent` tool's `subagent_type` — only resolves to agents declared in `plugin.json`'s `agents[]` array and placed in `.claude/agents/`. Through v1.2.0.3, that registry contained **12 agents**: `executive-router`, `enterprise-architect`, `implementer`, `planner`, `pre-release-audit`, `release-manager`, `reviewer`, `security-analyst`, `skill-synthesizer`, `tester`, `ui-ux-designer`, `voltagent-bridge`.

The other 79 specialists (including `nk-writer`, `content-strategist`, `product-strategist`, `innovation-researcher`, and every CSO/CMO/CPO/CINO/COO/CTO specialist) lived only as filesystem documents at `agents/MXM/{office}/`. When `executive-router` tried to dispatch a writing task to `nk-writer`, the receiving Claude could not find `nk-writer` in the subagent catalog and silently fell back to inlining the response in default Claude voice. The 91-vs-12 gap was a **dispatch identity failure** between declared architecture and actual reality.

Three additional constraints applied at decision time:

1. **The MCP catalog already exists.** `mxm-catalog` (8th MCP shipped in v1.2.0.1) exposes `route_task`, `get_agent_dna`, `list_agents`, `get_handoff_chain`, `list_offices`, `list_skills`, `search_skills` as structured RPC tools. The specialist tier already has a programmatic dispatch surface — it just wasn't wired to the subagent-registry side.

2. **Cross-surface fidelity matters.** Subagent registration only helps Claude Code. The MCP works on Claude Code AND Claude Desktop AND (via API) Claude.ai Web. A specialist-tier mechanism that runs through MCP gives cross-surface parity by construction.

3. **The lead-as-dispatch-target couples the registry to role identity.** Promoting `content-strategist` as the CMO dispatch face means future re-decisions about who leads CMO require touching the subagent registry. Office-as-dispatch-target decouples the routing surface from the lead role choice.

---

## Decision

Maxim adopts a **two-layer dispatch architecture**.

### Layer 1 — Office Routing Tier (Claude Code subagents)

The dispatchable subagent registry contains exactly two kinds of agents:

1. **Office Agents (7)** — one dispatchable agent per executive office. Each office agent is a thin internal router that classifies the inbound task and embodies the right specialist from its office's roster:
   - `ceo-office` · `cto-office` · `cmo-office` · `cso-office` · `cpo-office` · `coo-office` · `cino-office`

2. **Critical Orchestrators (8)** — agents whose behavior must fire structurally (not via office routing). These auto-loop on every output or fire on cross-office signals:
   - `executive-router` (entry point)
   - `reviewer` · `tester` · `release-manager` · `pre-release-audit` (quality + release chain)
   - `ethics-orchestrator` · `behavioral-overlay-orchestrator` · `confidence-tagger` · `compliance-orchestrator` · `handoff-coordinator` (v1.2.0 WS5 governance orchestrators)

3. **Utility (3)** — `skill-synthesizer` · `voltagent-bridge` · plus office-leads kept for backward compatibility (`enterprise-architect`, `implementer`, `planner`, `security-analyst`, `ui-ux-designer`) during the v1.2.0.4 transition. These continue to dispatch but are de-emphasized in favor of office agents.

**Layer 1 total: ~19 dispatchable subagent files.** Declared in `plugin.json` agents[] array. Reachable via `Agent(subagent_type=...)`.

### Layer 2 — Specialist Catalog (MCP-routed)

The remaining 72 specialist agents (and the 19 Layer 1 agents themselves) remain documented at `agents/MXM/{office}/<name>.md`. They are reached programmatically via the `mxm-catalog` MCP:

- `mxm-catalog.list_agents(office)` returns the office's full specialist roster
- `mxm-catalog.route_task(task)` returns the recommended `{office, lead, specialist}` for a given task
- `mxm-catalog.get_agent_dna(agent_name)` returns the specialist's complete DNA (Role, Triggers, Frameworks Used, Output Format, Skills Consumed, Collaboration Matrix)
- `mxm-catalog.get_handoff_chain(office)` returns the office's collaboration matrix

The Layer 1 office agents use these MCP calls to determine which specialist to embody for a given task. The embodied specialist's documented Output Format is reproduced in the response. The specialist embodied is named in the audit trail.

---

## Rationale

**Why office-as-dispatch and not lead-as-dispatch:**

- Office identity is stable; lead identity is a role choice. Coupling the registry to offices means the dispatch surface survives lead reorganizations.
- The executive-router's routing table already targets offices conceptually ("Marketing / brand / SEO / content / GTM → CMO Office, Lead: content-strategist"). Promoting offices makes the actual dispatch match the documented intent. Promoting leads forces an ongoing mismatch between concept and mechanism.
- Inside an office, the right specialist for a given task varies (`nk-writer` for operator-voice writing · `seo-specialist` for SEO copy · `behavioral-designer` for behavioral overlays). A single privileged lead can't serve all of these cleanly. An office router can.
- The mental model — "I'm talking to the CMO office" — matches how org charts actually work. Operators don't generally know which specific person inside an org chart should handle a request; they route to the office.

**Why MCP catalog and not filesystem read for specialist embodiment:**

- The MCP returns structured JSON (Role, Triggers, Output Format as parseable fields), not parsed markdown. Cheaper and more reliable.
- The infrastructure already exists. `mxm-catalog` was built for exactly this routing task and was deployed in v1.2.0.1. The architecture was already implicit in the codebase; this ADR makes it explicit.
- MCP routing is surface-agnostic. The same routing path works on Claude Code AND Claude Desktop AND (via API) Claude.ai Web. Filesystem-read only works on Claude Code.
- Telemetry comes free. Every `get_agent_dna` call is loggable — we can finally measure which specialists are invoked at what rate. Future drift class (Class 14 candidate: dispatch-traffic-drift) feeds off this data.

**Why two layers and not all 91 promoted:**

- Subagent dispatch consumes a context window per hop. Promoting 91 means dispatch chains can become 5–6 hops deep with corresponding cost.
- Most "specialists" are role variants of their office (e.g., `conversion-optimizer`, `persuasion-specialist`, `behavioral-designer` are all CMO sub-roles). Promoting each as a standalone subagent forces the dispatching Claude to scan a 91-entry registry to pick one — discovery friction grows superlinearly.
- A small leadership tier + catalog mechanism is the architecture pattern that Anthropic's own `claude-skills-library` ships with (~536 SKILL.md, only a handful plugin-discoverable). It's the established pattern for plugins with 100+ agents.

**Why promote BOTH offices AND orchestrators:**

- Orchestrators are not office-bound. They fire across offices (ethics-orchestrator on regulated work regardless of office; confidence-tagger on every output). They need direct dispatch identity.
- Quality + release chain (reviewer, tester, release-manager, pre-release-audit) must be reachable from any office without going through that office's agent. They're shared infrastructure.

---

## Consequences

### What this makes easier

- **All 91 agents become reachable.** The 72 catalog-only specialists become embodyable via MCP-routed lookup; the 19 Layer 1 agents are directly dispatchable. The "91 agents" claim becomes structurally true rather than aspirational.
- **Cross-surface parity by construction.** Claude Desktop (which has the MCPs but not subagents) and Claude.ai Web (which has MCP via API but not subagents) reach the same specialist tier as Claude Code. The surface fidelity matrix gains a row.
- **Lead reorganizations don't require registry changes.** If CMO decides `nk-writer` should be the default for unspecified writing tasks instead of `content-strategist`, that's a one-line change in `cmo-office.md`'s classification logic. No `.claude/agents/` edits, no `plugin.json` edits, no subagent restart.
- **The executive-router routing table simplifies.** Its target column collapses from `{office + lead}` to just `{office_agent}`. Specialist routing moves into each office.
- **Telemetry path opens.** Every `mxm-catalog.get_agent_dna` call is a measured event. We can finally answer "which specialists are most-used" with data.

### What this makes harder

- **The 91-vs-19 distinction has to be communicated.** Operator-facing docs (`/mxm-help`, README, HELP.md, plugin description) must honestly describe "19 dispatchable + 91-agent catalog via mxm-catalog" rather than the prior "91 agents" shorthand. The honesty is a feature, but it requires doc work.
- **MCP-down means specialist routing degrades.** If `mxm-catalog` MCP is unavailable, office agents fall back to filesystem read of `agents/MXM/{office}/*.md`. This fallback path needs to exist and be documented.
- **New dispatch pattern is novel.** Operators familiar with "agents = subagents" will need to understand the two-layer model. Mode 4 of `/mxm-help` (agents catalog) gets a structural rewrite.
- **`nk-writer` invocation is now indirect.** Operator says "draft a WA message" → executive-router → cmo-office → mxm-catalog routing → nk-writer DNA load → voice-routing skill fires → message emitted. Three real hops + MCP. Latency is acceptable but the chain is observable in audit trails.

### What this locks us into

- The `mxm-catalog` MCP becomes load-bearing for specialist routing. Future MCP refactors must preserve its public tool surface (`route_task`, `get_agent_dna`, `list_agents`, `get_handoff_chain`).
- Office agents must remain thin routers. They are dispatchers, not workers. Putting non-routing logic in an office agent re-couples the dispatch surface to specific work — defeating the architectural point.
- The orchestrator promotions are now part of the dispatch contract. Removing one of `ethics-orchestrator`, `behavioral-overlay-orchestrator`, `confidence-tagger`, `compliance-orchestrator`, or `handoff-coordinator` from the registry requires an ADR (likely a superseding decision).

### Migration shape (if reversal needed)

To reverse: collapse Layer 1 + Layer 2 back into a flat promotion of all 91 agents (or a curated subset). Move specialist routing logic from `mxm-catalog` MCP back into individual subagent dispatch. Re-target executive-router's routing table at named leads instead of office agents. The MCP itself can remain; only its role in dispatch retires.

Reversal is non-trivial but not catastrophic. The MCP catalog data is the same either way; only the dispatch path changes.

---

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| **Promote all 91 agents** | Registry bloat, dispatch chain depth, discovery friction. No plugin with 100+ agents ships this way at scale. |
| **Promote office leads only (12 leads)** | Couples registry to lead role identity. Forces lead choice to be permanent. Doesn't address how leads embody specialists. |
| **Promote office leads + critical orchestrators (~17–22)** | Closer to right shape but still ties dispatch to lead role. Doesn't leverage `mxm-catalog` MCP infrastructure that already exists. |
| **Filesystem-read specialist embodiment** | Works on Claude Code only. Markdown parsing is fragile. No telemetry. Bypasses MCP infrastructure that was built for this. |
| **Status quo (12 promoted, 79 catalog-only)** | The architecture documented as "91 agents" remains aspirational. Voice routing breaks silently (Mr. Khan's KFAS WhatsApp incident). Dispatch identity mismatch persists. |

---

## References

- v1.2.0.3 incident: nk-writer dispatch failure on operator's KFAS/ARIA WhatsApp ask. Receiving Claude correctly identified `nk-writer` was not in dispatchable subagent list; fell back to inline default-Claude voice.
- `mxm-catalog` MCP tool surface — defined in `mcp/mxm-catalog/server.js`. Tools: `route_task`, `get_agent_dna`, `list_agents`, `list_offices`, `list_skills`, `list_commands`, `get_handoff_chain`, `get_skill_detail`, `search_skills`.
- `agents/MXM/executive-router.md` — current routing table targets `{Office, Lead Agent}`. This ADR refactors to target `{Office Agent}` only.
- Anthropic `claude-skills-library` — ~536 SKILL.md, only a handful plugin-discoverable. Established pattern for plugins with 100+ catalog entries.
- v1.2.0.1 release — `mxm-catalog` MCP shipped as 8th MCP. Infrastructure for this ADR was already in place; this ADR makes the architecture explicit.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
