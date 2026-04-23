# ADR-012 — Maxim Overlay Engine (MOE) Architecture

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-23
- **Deciders:** DrNabeelKhan
- **Related:** ADR-001 (architecture baseline) · ADR-007 (behavioral moat framing) · ADR-008 (community pack system) · ADR-010 (confidence tag rubric) · `documents/reference/FRAMEWORK_ROADMAP.md`

---

## Context

A Claude Code environment frequently has many plugins installed side-by-side. A user might have Maxim, a language-specific autocomplete plugin, a testing harness plugin, a documentation generator, and several MCP servers — all in the same session. Each plugin's outputs flow to the same operator, but only Maxim ships the behavioral-science layer, the 14 compliance frameworks, the confidence-tagging rubric (ADR-010), the MOAT-row citation doctrine (ADR-007), and Proactive Watch drift detection.

Without an explicit decision, Maxim's moat layers apply only to work that originates inside Maxim's own skills. A user's Cursor autocomplete call, their third-party MCP tool invocation, or another plugin's agent output passes through the session ungoverned — no framework applied, no confidence tag, no compliance pre-check.

This is a coexistence posture, not a governance posture. Governance is what the paid tiers promise. Coexistence is what every other plugin in the community marketplace already delivers.

---

## Decision

Maxim ships a first-class **Overlay Engine (MOE)** that applies Maxim's moat layers to capabilities invoked through *any* installed Claude Code plugin, not only Maxim's own skills. The overlay is implemented through Claude Code's existing hook system and runs transparently: every overlay event is logged, every overlay action cites its framework, and every overlay pass-through respects the operator's opt-out configuration.

The overlay operates at four interception points, each already supported by Claude Code's plugin runtime:

1. **`SessionStart`** — enumerate installed plugins, build an **overlay registry** cataloging each plugin's capabilities and pre-computing a framework pairing per capability. Registry stored at `.mxm-skills/overlay-registry.json`.
2. **`UserPromptSubmit`** — detect third-party slash commands and plain prompts that route to non-Maxim capabilities. Inject a short system directive naming the matched framework and the project's active compliance frameworks.
3. **`PreToolUse`** — for any tool call (Maxim's or another plugin's MCP tool, Bash, Write, Edit, Task), apply the project's compliance pre-check. Block tool calls that touch regulated data categories (PII, PHI, PCI) without a matching compliance cite.
4. **`PostToolUse`** — call `mxm-behavioral`'s `behavioral_audit` on outputs above a size threshold. Emit the confidence tag to stderr as a sidebar signal. Log the overlay event to `.mxm-skills/overlay-log.jsonl`. Feed the event to Proactive Watch for drift detection (new watch class 13).

The overlay is **transparent by default**:

- Every overlay event is logged to a visible local JSONL file the operator can read at any time.
- The overlay never modifies the content of another plugin's output silently — it adds sidebar annotations (confidence tag, framework citation, compliance note), not rewrites.
- Operators can disable the overlay per-plugin via `config/overlay-profile.yml`, and can disable it globally by removing the Maxim plugin.
- Overlay output is always tagged as Maxim-origin, never presented as the wrapped plugin's own work.

---

## Rationale

Maxim's moat is not the skills Maxim ships. The moat is the behavioral/compliance/governance **layer**, and a layer is only valuable if it covers surface area. If the layer covers only Maxim-originated work, users get the moat for 20% of their AI-assisted output and noise for the other 80%. If the layer covers every plugin's output, users get the moat everywhere — which is what the paid tiers promise.

The hook mechanism Claude Code already exposes (documented in plugin.json `hooks` + `hooks.json`) fires on every tool call and every user prompt, regardless of which plugin originated the call. This is the correct architectural substrate for an overlay — no cooperation required from other plugin authors, no breaking change required in Claude Code, and no reliance on undocumented APIs.

The alternative — requiring other plugins to opt into Maxim's governance layer — creates a chicken-and-egg problem: plugin authors only adopt if users already run Maxim, and users only buy Maxim if the layer already covers the plugins they use. The hook-based overlay breaks the loop.

---

## Decision details

### Overlay registry

Built once per `SessionStart`, cached until next plugin install/uninstall. Format:

```json
{
  "generated_at": "2026-04-23T14:00:00Z",
  "maxim_version": "1.1.0",
  "plugins": [
    {
      "id": "cursor-autocomplete",
      "source": "github.com/example/cursor-autocomplete",
      "capabilities": ["autocomplete", "refactor-suggest"],
      "framework_pairings": {
        "autocomplete": "cognitive-load-theory",
        "refactor-suggest": "prospect-theory"
      },
      "compliance_posture": "unclaimed",
      "certified": false
    }
  ]
}
```

Framework pairings are computed by matching plugin capability strings against the 64-framework library in `documents/reference/FRAMEWORKS_MASTER.md`. Unmatched capabilities get a default pairing (Fogg B=MAP) with a lower confidence tag.

### Injection discipline

The `UserPromptSubmit` hook adds a short system directive — **not** a rewrite of the user's prompt. Format:

```
[Maxim v1.1 overlay active]
  Matched capability: {plugin}/{capability}
  Behavioral framework: {framework} (cited from FRAMEWORKS_MASTER.md §N)
  Active compliance frameworks: {list from project-manifest.json}
  Confidence tag: required per ADR-010
```

The directive is visible in session logs and auditable. It does not rewrite the operator's intent.

### Compliance gate

`PreToolUse` runs the project's declared compliance frameworks against the tool call's parameters. Detection rules are the existing `mxm-compliance` MCP rule set. Block response format:

```
[Maxim Overlay BLOCK]
  Tool: {tool_name}
  Plugin: {originating_plugin or "built-in"}
  Detected: {data category — PII / PHI / PCI / etc.}
  Violated framework: {framework_id}
  Cite: {section reference in FRAMEWORKS_MASTER.md}
  Override: set MXM_OVERLAY_BYPASS=1 for this call (logged to audit trail)
```

Blocks are bypassable with explicit opt-out so the overlay never becomes a hard denial-of-service when the user intentionally accepts the risk — but every bypass is logged to the immutable audit trail.

### Tier gating

MOE features are tier-gated through the license middleware (separate item in v1.1 plan):

- **Starter** — overlay runs in **observe mode**: logs to `.mxm-skills/overlay-log.jsonl`, prints confidence tags, does not inject directives or block calls
- **Solo / Pro** — overlay adds **framework directives** via `UserPromptSubmit`; compliance checks emit warnings but do not block
- **Professional / Team** — overlay **enforces compliance blocks** via `PreToolUse`; Proactive Watch class 13 (third-party-plugin drift) active
- **L3 vertical overlays** — overlay applies **vertical-specific gates** on top of the base frameworks (e.g., Healthcare overlay blocks any tool touching PHI without a HIPAA cite, regardless of whether the originating plugin knows about HIPAA)

### Ethical guardrails

Every overlay action must clear these checks before emission:

1. Must cite a specific framework from FRAMEWORKS_MASTER.md (no "vibes-based" overlay directives)
2. Must be loggable and reversible (the operator can always see what was injected and turn it off)
3. Must not inject dark patterns — the overlay may apply persuasion frameworks to make Claude's output clearer or more confidence-tagged, never to coerce the operator
4. Must carry the Maxim-origin tag so third-party plugin authors can distinguish their output from overlay annotations

---

## Consequences

**Easier:**
- Marketing — "Maxim governs every plugin you have installed" is a clean claim, defensible by the overlay log
- Pricing — feature tiers map cleanly to overlay capability depth (observe → directive → enforce)
- Moat depth — the overlay log becomes a reviewable artifact ("here are 427 governance events Maxim applied this week")

**Harder:**
- Plugin compatibility — some plugins may emit outputs that don't parse cleanly against `behavioral_audit`; overlay falls back to a lower confidence tag rather than failing loud
- Performance — hook on every tool call has latency cost; mitigation is to cache the overlay registry and short-circuit observe-mode tags
- Plugin-author relations — other plugin authors may initially read "Maxim wraps my plugin" as adversarial; mitigation is transparent logging, per-plugin opt-out, and a certification program that rewards participation

**Locks us into:**
- The `SessionStart` / `UserPromptSubmit` / `PreToolUse` / `PostToolUse` hook API surface. If Claude Code changes the hook contract, MOE needs a revision.
- A one-to-many framework-pairing responsibility — Maxim maintains the map from third-party capabilities to Maxim frameworks. This is a maintenance obligation, tracked in `documents/reference/OVERLAY_PAIRINGS.md` starting v1.3.

---

## Alternatives considered

**Alt 1 — Skills-only governance (status quo).** Ship the behavioral layer only inside Maxim's own skills. Rejected because the moat depth is capped by Maxim's own surface area, not by the user's actual plugin footprint. The whole point of governance is that it covers the environment, not one vendor's slice of it.

**Alt 2 — Cooperative plugin SDK.** Publish `@maxim/plugin-sdk` and require other plugin authors to instrument their code to participate. Rejected as the v1.1 launch path because it's a chicken-and-egg adoption blocker. Revisited as a v2.0 extension layer (ADR-013, TBD) that adds tighter integration for *certified* plugins on top of the hook-based base — but the base must not require it.

**Alt 3 — Output rewriting.** Have the overlay rewrite other plugins' outputs in place before they reach the operator. Rejected on ethical grounds — silently modifying another vendor's work to claim credit is the kind of pattern the ethical guardrails exist to prevent.

**Alt 4 — MCP-only interception.** Limit the overlay to MCP tool calls from other plugins, leaving slash commands and user prompts untouched. Rejected because it misses the largest class of third-party activity: non-MCP slash commands and plain prompts routed to other plugins' agents.

---

## Enforcement

Once MOE ships:

- `.claude/hooks/session-start.{sh,ps1}` builds the overlay registry
- `.claude/hooks/overlay-prompt.{sh,ps1}` implements the `UserPromptSubmit` injection
- `.claude/hooks/overlay-pre.{sh,ps1}` implements the `PreToolUse` gate
- `.claude/hooks/overlay-post.{sh,ps1}` implements the `PostToolUse` audit
- `config/overlay-profile.yml` controls per-plugin opt-out
- `documents/reference/OVERLAY_PAIRINGS.md` (shipping v1.3) documents the capability→framework map
- Proactive Watch gains watch class 13 "third-party-plugin drift" (shipping v1.1)
- AGENT_SKILL_INVENTORY.md adds Section 9 "Overlay Engine" with per-event-type counters

Any skill or hook change that weakens the transparency guarantees in the "Decision details → Injection discipline" and "Ethical guardrails" sections triggers an ADR amendment, not a silent edit.

---

## Relationship to other ADRs

- **ADR-007** — every overlay directive must cite a framework from FRAMEWORKS_MASTER.md. MOE extends the mechanism-citation doctrine from skills to every wrapped capability.
- **ADR-008** — the community pack system already brings 7 external packs into Maxim. MOE is the runtime counterpart: the packs join the environment, and MOE governs everything in that environment, Maxim-native or community-packed.
- **ADR-009** — L3 vertical overlays (Healthcare, Legal, Fintech, GovTech) are the immediate beneficiaries of MOE. The vertical overlay unlocks vertical-specific compliance gates that the base MOE runs through.
- **ADR-010** — confidence tagging extends from Maxim outputs to every wrapped output. Third-party outputs get a tag by default; operators see one rubric across everything.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
