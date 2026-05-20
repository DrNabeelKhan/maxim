# ADR-018 — External Tool Integration Pattern

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-20
- **Deciders:** DrNabeelKhan
- **Related:** ADR-007 (Behavioral Moat Framing), ADR-008 (Community Pack System), ADR-017 (Office-as-Dispatch-Boundary), ADR-016 (Voice Writing Agent Architecture)

---

## Context

Maxim composes with external tools that operators already use — `mbailey/voicemode` for STT/TTS, `claude-mem` for cross-session memory, Higgsfield for video, `teng-lin/notebooklm-py` for NotebookLM research synthesis, and increasingly more as the ecosystem grows. Each has its own license, install path, auth flow, fragility profile, and update cadence.

Through v1.2.0.6, Maxim's pattern for these was ad hoc: voicemode was wrapped into `mxm-voice` MCP without an ADR; claude-mem ships as an MCP without Maxim authorship; community-packs/ holds raw external skill libraries. Different decisions for different tools, no documented rationale linking them.

v1.2.1.0 ships the NotebookLM integration — three layers thick: Maxim-flavored skill + community-pack reference + MCP wrapper with full upstream feature coverage. That's the most complete integration Maxim has shipped. The shape it took is generalizable. Without an ADR codifying the pattern, future integrations (Notion · Linear · Slack · Figma · etc.) will re-decide the same trade-offs from scratch and drift across decisions.

The operator directive accelerating this: *"all features of repo without compromise"* — meaning a future integration must default to full coverage rather than partial. This ADR codifies what "full integration" means structurally so the decision is repeatable.

---

## Decision

Maxim adopts a **three-layer pattern** for integrating any external CLI tool, package, or service. Each layer is optional and additive; together they form the canonical "full integration."

### Layer 1 — Community Pack Reference (always)

Copy the upstream's authoritative skill/usage documentation **verbatim** to `community-packs/<upstream-name>/`. Files:

- `SKILL.md` — upstream skill definition (if upstream ships one)
- `LICENSE` — upstream license (verbatim)
- `UPSTREAM_README.md` — upstream README (verbatim)
- `MAXIM_INTEGRATION.md` — Maxim's authored notes (license combination, value-add summary, update protocol, fragility disclosure pointer)

Layer 1 is the canonical reference. It is preserved so Maxim maintainers and operators can detect upstream drift over time. **Layer 1 is NEVER modified by Maxim** — only re-fetched.

### Layer 2 — Maxim-Flavored Skill (required for free-tier integrations)

Author a Maxim-native skill at `.claude/skills/<domain>/SKILL.md` that:

- Adds ADR-007 behavioral framework citations (the value Maxim adds over upstream)
- Adds office routing logic (which Maxim office(s) embody this skill — per ADR-017)
- Adds ethics gate triggers (when CSO auto-loop should fire on the tool's operations)
- Adds pre-flight checks (auth check, install check, version check)
- Adds fragility disclosure (per § Mandatory Disclosure below)
- Cites Layer 1 as the upstream contract

Layer 2 is Maxim's primary dispatch surface per the CLAUDE.md dispatch sequence (Step 1 — `.claude/skills/` wins over `community-packs/`).

### Layer 3 — MCP Wrapper (optional, recommended for cross-surface integrations)

Author an MCP server at `mcp/mxm-<tool>/` wrapping the upstream CLI or Python API with tool surface granular enough to match upstream's documented public API. The MCP server:

- Shells out to the upstream CLI (or Python lib) — does NOT reimplement upstream features
- Returns parsed JSON envelopes to MCP clients
- Handles long-running operations via task_id + wait_artifact polling pattern
- Includes pre-flight auth check before non-auth operations
- Emits structured errors with operator remediation paths (not raw stack traces)
- Documents its `tool_count`, `tier` (free | gated), `fragility_disclosure` in `package.json` `maxim` block

**Layer 3 is what enables cross-surface parity** (per ADR-017). Without an MCP, the integration is Claude Code-only (skill works on Code but not Desktop / Web). With an MCP, the integration works on every surface that has MCP access.

---

## Mandatory disclosures (§)

### License compatibility check (mandatory)

Before any external integration ships, Layer 1's `MAXIM_INTEGRATION.md` MUST document license compatibility:

| Upstream license | Maxim wrapper (BSL-1.1) | Combination |
|---|---|---|
| MIT / Apache-2.0 / BSD | BSL-1.1 (4-year conversion to Apache-2.0 per ADR-005) | OK with attribution |
| LGPL | BSL-1.1 | OK with attribution (dynamic linking only) |
| GPL / AGPL | BSL-1.1 | **NOT ALLOWED** — copyleft incompatible with BSL distribution model |
| Proprietary | BSL-1.1 | OK only if Maxim has redistribution license |

Integrations with incompatible licenses get Layer 2 only (skill describing how to use, without bundling). No Layer 1 copy, no Layer 3 wrapper.

### Fragility disclosure (mandatory)

If the upstream:

- Uses undocumented APIs of a third party (NotebookLM, scraping-based tools)
- Depends on a CLI binary that operators install separately
- Requires browser auth or external state
- Has rate limiting that affects operator workflow
- Self-describes as "for prototypes / research / personal use rather than production"

...then Layer 2's SKILL.md MUST include a `Fragility Disclosure` section AND every operation's audit trail line MUST cite the disclosure. Operators learn the risk on every output, not buried in install docs.

### Free-tier vs gated decision rubric

Integrations are NOT license-gated by default. The default is free-tier (no JWT gate, no `wrapServerWithLicenseGate()` call). Gating is justified only if:

1. Maxim's wrapper itself adds significant authored IP beyond the upstream (e.g., a proprietary scoring algorithm)
2. AND the wrapper depends on Maxim's paid-tier behavioral frameworks (Pack 6 frameworks etc.)
3. AND operator surveys validate the gate doesn't kill adoption

If any of those is false, ship free-tier. The MIT upstream stays MIT-accessible; Maxim's wrapper enhances rather than restricts.

---

## Rationale

**Why three layers and not two?**

Two layers (skill + community pack) is enough for Code-only integrations — but ADR-017 established cross-surface as a structural moat. An MCP wrapper extends Layer 2's reach to Desktop / Web / Cowork. Skipping Layer 3 forfeits that.

**Why mandatory Layer 1 (community pack copy)?**

Detecting upstream drift requires a baseline. Without a checked-in verbatim copy, Maxim can't tell when upstream added/changed/removed a feature. Operators also benefit — they can read upstream's intent without leaving the repo.

**Why mandatory fragility disclosure on every output?**

The KFAS WhatsApp incident (v1.2.0.3) and the mxm-catalog drift incident (v1.2.0.4) both proved that buried disclosures get ignored. Upstream fragility (undocumented APIs, install dependencies, auth state) belongs on the audit trail of every operation, not in a README operators don't re-read.

**Why free-tier by default?**

Wrapping a free upstream tool in a paid-tier gate makes Maxim look like a tollbooth on someone else's work. The wrapper's value (office routing, ethics gate, audit trail, framework citation) is real but additive, not subtractive. Operators pay for Maxim's behavioral intelligence, not for permission to call notebooklm. Gating the wrapper would degrade trust without proportional revenue.

**Why three optional patterns rather than one prescribed shape?**

Some upstream tools have no SKILL.md (just a CLI) — Layer 1 is community-pack metadata only. Some upstream tools are Python libraries with no CLI — Layer 3's "wrap the CLI" approach doesn't apply; the MCP wraps the lib directly. The three layers describe the SHAPE; the implementation within each layer adapts to the upstream's reality.

---

## Consequences

### What this makes easier

- **Future integrations are templated.** Notion / Linear / Slack / Figma / Higgsfield each get the same three-layer pattern. Operators learn one shape, get consistent behavior.
- **License compatibility is checked at design time.** GPL/AGPL upstreams get flagged before integration work begins, preventing legal cleanup later.
- **Cross-surface parity is the default.** Operators don't have to remember "voicemode works in Code only; notebooklm works everywhere." With Layer 3 MCPs, all integrations work cross-surface.
- **Operator trust survives upstream breakage.** Fragility disclosures on every audit trail mean operators expect occasional upstream failures and have a remediation path documented in the skill itself.
- **Telemetry path opens for all integrations.** MCP-routed operations are loggable. Maxim can finally measure "which external tool integrations are highest-usage" with data, informing future investment.

### What this makes harder

- **Three layers is more work than one.** A simple "just describe the tool" integration becomes a SKILL.md + community-pack + MCP server. Faster integrations get tempted to skip Layer 3 — and when they do, they sacrifice cross-surface parity.
- **Each layer's update path is separate.** When upstream releases a new version, Layer 1 needs re-fetching, Layer 2 may need feature additions, Layer 3 needs new tools. Automation (e.g., a `bootstrap/upstream-update.{sh,ps1}` checker) would help; v1.3.0+ scope.
- **Free-tier MCPs blur the paid-tier story.** If half of Maxim's MCPs are paid (mxm-portfolio, mxm-context, etc.) and half are free (mxm-notebooklm, mxm-voice), operators may not understand the tier line. Layer 1's MAXIM_INTEGRATION.md must clearly state tier rationale.

### What this locks us into

- **Community-packs/ directory is now a load-bearing canonical reference, not just a curiosity.** Cleanup tools (sync-counts EXCLUDE_PATTERNS) must continue to skip it; ADR-008 references must be preserved.
- **Every MCP wrapper's `package.json` MUST include the `maxim` block** with `adr`, `shipped_in`, `tool_count`, `upstream`, `upstream_license`, `maxim_license_gate`, `tier`, `fragility_disclosure` fields. This is the audit trail for the integration decision.
- **The free-tier default cannot be reversed.** Once an integration ships un-gated, gating it later breaks operator workflows. Future integrations must decide tier at design time.

### Migration shape (if reversal needed)

If a single external tool integration needs to be retired or gated retroactively:

1. Layer 1 (community pack) — keep as historical reference; mark deprecated in MAXIM_INTEGRATION.md
2. Layer 2 (Maxim skill) — add deprecation notice in YAML frontmatter; operator clear migration path
3. Layer 3 (MCP wrapper) — add license-gate wrap if gating; or remove from `.mcp.json` if retiring

Each layer has independent reversal cost; no monolithic rollback required.

---

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| **Layer 2 only (skill, no community pack, no MCP)** | Code-only — sacrifices cross-surface parity. Loses canonical upstream reference. Drift detection becomes impossible. |
| **Layer 3 only (MCP, no skill, no community pack)** | MCP without skill means operators have no clear "how do I use this" entry point. Dispatch sequence (Step 1 reads `.claude/skills/`) can't find anything. |
| **All-in-one Maxim re-implementation** | Forking the upstream into Maxim's tree. Breaks license attribution. Doubles maintenance. Loses upstream improvements. |
| **External tool only as documentation reference (no wrapper)** | Operators install separately and use the upstream CLI directly. Maxim adds no value. Defeats the moat positioning. |
| **License-gate all third-party wrappers** | Looks like a tollbooth on someone else's MIT work. Damages trust. Operators don't pay for permission; they pay for behavioral intelligence. |

---

## References

- **v1.2.1.0 NotebookLM integration** — first integration shipped under this ADR. `mcp/mxm-notebooklm/` (38 tools), `.claude/skills/notebooklm-py/SKILL.md`, `community-packs/notebooklm-py/` (upstream MIT pack).
- **Operator directive** (2026-05-20): "*all features of repo without compromise*" — established the "full coverage" default for external integrations.
- **`mxm-voice` precedent** (v1.0.0) — voicemode integration shipped without an ADR; retroactively validates the three-layer pattern (it has Layer 3 MCP, partial Layer 2 skill, no Layer 1 community pack — gap noted for future cleanup).
- **upstream** `teng-lin/notebooklm-py` (MIT, Teng Lin 2026) — reference implementation.
- **ADR-008** Community Pack System — established the community-packs/ directory pattern this ADR formalizes for external tools.
- **ADR-017** Office-as-Dispatch-Boundary — established the MCP-as-specialist-surface principle that justifies Layer 3.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
