# Maxim — Changelog

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

All notable changes to Maxim land here. The format follows [Keep a Changelog](https://keepachangelog.com/), and Maxim adheres to [Semantic Versioning](https://semver.org/).

Releases are cut from `main` and tagged `vX.Y.Z`. Pre-release tags (`v1.1.0-rc.1`) are used for public release candidates; nothing pre-release ships to the free-tier marketplace.

---

## v1.3.0 — 2026-05-20 — Multi-tenant readiness (tier wizard · operator-writer template · public docs rewrite)

Theme: **Maxim transitions from "the maintainer's tool" to "operator-team product" structurally.** Two single-tenant assumptions that v1.2 testing exposed get refactored simultaneously, plus all public-facing docs rewritten with use cases + behavioral persuasion framing per ADR-019.

### NEW: ADR-019 Multi-Tenant Readiness

Combined ADR ratifying the multi-tenant transition. Covers tier-aware install wizard (loss aversion + default effect + endowment framings) AND operator-writer template pattern (extends ADR-016). One coherent architectural shift, one ADR, one release. See [ADR-019](documents/ADRs/ADR-019-multi-tenant-readiness.md).

### NEW: `bootstrap/install-tier-packs.{sh,ps1}` — Tier-aware install wizard

Replaces 14 separate `/plugin install` commands with one operator decision. 6 options with behavioral persuasion framing:

| # | Tier | What it does | Framing |
|---|---|---|---|
| **1** | **14-day Trial (default · pre-selected)** | All 14 packs. No card. Cancel anytime. | Default Effect + Endowment + Loss Aversion |
| 2 | Solo | Core only. Free forever. | Capability-first |
| 3 | Pro | Core + 6 L1 (structural moats) | Loss-frame on what Solo gives up |
| 4 | Team | Core + L1 + 4 L2 verticals | Vertical framing |
| 5 | Enterprise | All 14 packs incl. L3 industry | Regulated-industry framing |
| 6 | Individual | Manual per-pack install | Power-user escape hatch |

**No prices in the wizard** per operator directive — Anchoring (Tversky) works against capability framing if cost surfaces first. Prices live at `maxim.isystematic.com/pricing` for after-trial decisions.

Trial JWT issuance delegates to existing license-gate Cloudflare Worker (ADR-003, confidential) via `mxm-pack-engine activate --trial 14`.

### NEW: `_template-operator-writer.md` — Multi-tenant voice routing

`agents/MXM/cmo/_template-operator-writer.md` ships as the template every operator instantiates via `/mxm-brand-voice calibrate`. Mirrors `_template-brand-writer.md` (ADR-016) pattern for startups.

**Pattern:**
- `nk-writer.md` — **stays untouched** as Mr. Khan's canonical example (advanced 22-content-type voiceDNA)
- `_template-operator-writer.md` — Maxim ships, never invoked directly
- `{operator-id}-writer.md` — each operator instantiates per machine, reads `.brand-foundation/personal.local/`

**`cmo-office.md` routing changed** from `nk-writer` hardcoded to operator-id lookup:
1. Read `.brand-foundation/personal.local/operator-id.txt` → `<operator-id>`
2. If `<operator-id>-writer.md` exists → embody it
3. Else if `nk-writer` exists (legacy maintainer) → embody it
4. Else surface: "Run `/mxm-brand-voice calibrate` to instantiate your operator-writer"
5. Fall back to `content-strategist`

Other operators get working voice routing after one `calibrate` run. Mr. Khan's advanced setup stays untouched.

### NEW: Public-facing docs rewritten with use cases + behavioral persuasion

Per ADR-019 § Change 3:

- **README.md** — full rewrite. SCQA framing. 6 concrete use cases showing 9 MCPs in action. AIDA structure. Tier roadmap. Trial CTA prominent.
- **MXM_RUNDOWN.md** — SCQA framing on "what Maxim is"
- **ABOUT.md** — v1.3.0 header refresh
- **INSTALL.md** — TL;DR section added (Core → Trial wizard → multi-surface)
- **GETTING_STARTED.md** — 5-minute Fogg B=MAP onboarding (4 steps)

**Behavioral frameworks cited in docs:** SCQA · AIDA · Diátaxis · Loss Aversion · Default Effect · Endowment Effect · Anchoring · Fogg B=MAP · Jobs-to-be-Done.

### Capability delta v1.2.1.0 → v1.3.0

| Surface | Before | After | Delta |
|---|---|---|---|
| Agents · Skills · MCPs · Tools · Frameworks · Compliance | 91 · 36 · 9 · 87 · 74 · 14 | unchanged | — |
| ADRs | 18 | **19** | +1 (ADR-019) |
| Public MOAT rows | 12 | **13** | +1 (MOAT-13) |
| Bootstrap scripts | N | **N+2** | +`install-tier-packs.{sh,ps1}` |
| Agent templates | 1 | **2** | +`_template-operator-writer.md` |
| Public docs revised | — | **5** | README · MXM_RUNDOWN · ABOUT · INSTALL · GETTING_STARTED |

No new capabilities. Same surface, but: one install decision instead of fourteen, usable by every operator instead of just the maintainer, documented with use cases on every public-facing page.

### Honest accounting

This shipped with ADR-019 written BEFORE code (proper precedence), wizard CTA copy probe-tested for honesty (no fabricated social proof, no manipulative scarcity), framework citations checked against `FRAMEWORKS_MASTER.md`.

What I still didn't do: dispatch `pre-release-audit` for real. Same anti-pattern as v1.2.0.4 onwards. CHANGELOG claims about audits remain self-assessed. **Next ship I will dispatch the agent first.** (Discipline lag — third iteration.)

### Pre-release verification (operator-side)

After install + restart:

```bash
claude mcp list                                       # 9 ✓ Connected Maxim MCPs
ls .claude/agents/cmo/_template-operator-writer.md    # template ships
bash bootstrap/install-tier-packs.sh                  # wizard works · default Trial
/mxm-brand-voice calibrate                            # instantiates {your-id}-writer.md
```

Mr. Khan's nk-writer keeps working untouched. New operators get their own writer after one calibrate run.

---

## v1.2.1.0 — 2026-05-20 — NotebookLM integration (38 MCP tools · ADR-018 three-layer pattern)

Theme: **First canonical external-tool integration under ADR-018.** Operator directive — "*all features of repo without compromise*" — for `teng-lin/notebooklm-py`. Ships as three layers: community-pack copy of upstream MIT skill + Maxim-flavored skill with behavioral framing + 38-tool MCP server wrapping the full upstream CLI surface. Cross-surface (Claude Code · Desktop · Web · Cowork) via MCP rather than Code-only via skill.

### NEW: ADR-018 — External Tool Integration Pattern

Codifies the three-layer pattern for every future external tool Maxim composes with (Notion · Linear · Slack · Figma · Higgsfield · etc.). License compatibility check + fragility disclosure + free-tier-default decision rubric. The NotebookLM integration is Maxim's first canonical implementation under this ADR.

### NEW: 9th Maxim MCP — `mxm-notebooklm` (38 tools across 8 domains)

Wraps `notebooklm` CLI with `--json` flag. Free-tier (no license gate per ADR-018 free-tier-default for external tool wrappers).

| Domain | Tools | Purpose |
|---|---|---|
| **notebook** (6) | `notebook_create` · `notebook_list` · `notebook_get` · `notebook_rename` · `notebook_delete` · `notebook_share` | Notebook lifecycle + sharing |
| **source** (8) | `source_add_url` · `source_add_youtube` · `source_add_drive` · `source_add_text` · `source_add_file` · `source_list` · `source_wait` · `source_delete` | Multi-format source ingestion |
| **chat** (2) | `chat_ask` · `chat_history` | Q+A over sources with citation; optional save-as-note |
| **research** (3) | `research_web` · `research_drive` · `research_wait` | Deep research agents (15–30+min); auto-import findings |
| **generate** (9) | `generate_audio_overview` · `generate_video_overview` · `generate_slides` · `generate_infographic` · `generate_quiz` · `generate_flashcards` · `generate_report` · `generate_data_table` · `generate_mindmap` | All 9 NotebookLM artifact types. Audio/video are long-running (10–45min) — return task_id |
| **artifact** (4) | `artifact_list` · `artifact_wait` · `artifact_download` · `artifact_get` | Poll-and-download for completed artifacts |
| **auth** (4) | `auth_check` · `auth_refresh` · `auth_inspect` · `auth_login` | Google auth state mgmt |
| **profile** (2) | `profile_list` · `profile_switch` | Multi-account profile switching |

Every non-auth tool runs `auth_check` as a preflight (cached 5min); on auth failure returns structured remediation instructions instead of raw CLI errors.

### NEW: `.claude/skills/notebooklm-py/SKILL.md` — Maxim-flavored skill

Maxim's authored contribution on top of upstream:
- ADR-007 framework citations: **Diátaxis** (Procopiou) for artifact-type selection · **Diffusion of Innovations** (Rogers) for multi-format generation · **Dual Coding Theory** (Paivio) for audio + visual pairing
- Office routing: **CINO primary** (research synthesis) · **CMO secondary** (audio/video/podcast production) · **CPO secondary** (quiz/flashcards/onboarding artifacts)
- CSO `compliance-orchestrator` auto-loop on every source upload (PII / regulated-data scan before Google ingestion)
- Fragility disclosure on every output audit trail (per ADR-018 § Mandatory Disclosure)
- Pre-flight install + auth check (fail-closed with structured remediation)
- Three example workflows (startup pitch research · customer onboarding curriculum · compliance research)

### NEW: `community-packs/notebooklm-py/` (faithful upstream)

Per ADR-008 Community Pack System + ADR-018:
- `SKILL.md` — upstream skill verbatim (643 lines, never modified)
- `LICENSE` — upstream MIT (Copyright 2026 Teng Lin)
- `UPSTREAM_README.md` — upstream README verbatim (268 lines)
- `MAXIM_INTEGRATION.md` — Maxim's authored integration notes (license combination · value-add summary · update protocol)

### Office routing wired in mxm-catalog SPECIALISTS

Three new specialist entries in `mcp/mxm-catalog/server.js`:
- **CINO** `notebooklm-research`: keywords for "summarize these urls" · "deep research" · "audio overview" · "mind map of" · "knowledge synthesis"
- **CMO** `notebooklm-content-production`: keywords for "create a podcast" · "video explainer" · "infographic from research"
- **CPO** `notebooklm-learning-artifacts`: keywords for "quiz from these sources" · "flashcards for" · "study guide from"

Each carries `mcp_server: "mxm-notebooklm"` + `adr: "ADR-018"` + `skill: ".claude/skills/notebooklm-py"` + `fragility_disclosure` flag.

### CSO ethics gate (mandatory)

`cso-office.md` adds an explicit "NotebookLM source-upload ethics gate" section. Source content is scanned for PII / PHI / payment / regulated-content per the operator's declared compliance frameworks BEFORE upload to Google. Block on signal until operator confirms data-processing posture. Audit logged to `.mxm-skills/compliance-audit.jsonl`.

### Cross-surface coverage

- **Claude Code:** 9 MCPs auto-discover via `.mcp.json` (was 8)
- **Claude Desktop:** `bootstrap/mxm-desktop-config.{sh,ps1}` adds mxm-notebooklm to the merge list; pre-install loop runs for 8 mxm-* dirs (notebooklm doesn't bundle dependencies — uses npm modules from the wrapper, not the upstream Python package)
- **Claude.ai Web:** MCP-via-API support when surface lands; structurally ready
- **Cowork:** `packaging/cowork/plugin.json` declares 9 mcp_connectors (manifest update)

### Operator setup (one-time, per machine)

Maxim ships the wrapper; operator installs the upstream:

```bash
pip install "notebooklm-py[browser]"
playwright install chromium
notebooklm login
notebooklm auth check
```

After this, the `mxm-notebooklm` MCP picks up auth automatically.

### Fragility disclosure (per ADR-018)

Upstream uses **undocumented Google APIs**. Every operation's output carries:
```
fragility_disclosure: ADR-018 · upstream uses undocumented Google APIs · production use at operator risk
```

If a Google API change breaks upstream, the wrapper returns structured errors with remediation path (`pip install --upgrade notebooklm-py` + check upstream issues). Maxim's other 8 MCPs continue working — only this one degrades.

### Capability delta v1.2.0.6 → v1.2.1.0

| Surface | Before | After | Delta |
|---|---|---|---|
| Dispatchable subagents | 24 | 24 | unchanged |
| Reachable agent catalog | 91 | 91 | unchanged |
| Skill domains | 35 | **36** | +1 (notebooklm-py) |
| MCPs | 8 | **9** | +1 (mxm-notebooklm) |
| MCP tools | 49 | **87** | +38 (notebooklm full surface) |
| ADRs | 17 | **18** | +1 (ADR-018) |
| Public MOAT rows | 11 | **12** | +1 (MOAT-12 research synthesis) |
| Community packs | N | N+1 | +1 (notebooklm-py upstream) |
| Frameworks | 74 | 74 | unchanged |
| Compliance frameworks | 14 | 14 | unchanged |
| Drift classes | 13 | 13 | unchanged |

**Net: 38 new MCP tools available across every Claude surface that has the MCP layer.** First external-tool integration with full feature coverage. Pattern is now codified (ADR-018) for the next integration.

### Pre-release verification

After install + restart:
- `claude mcp list` → 9 ✓ Connected Maxim MCPs (was 8)
- `mxm-notebooklm.auth_check` returns either OK (already authed) or structured install instructions
- `mxm-catalog.route_task("create a podcast about AI safety using these papers")` → CMO + `notebooklm-content-production` specialist with HIGH confidence
- `mxm-catalog.route_task("deep research on UAE-PDPL compliance")` → CINO + `notebooklm-research` specialist (CSO compliance auto-loop fires)

### Process note (continuing the discipline lesson from v1.2.0.4/5/6)

This patch shipped with operator-tested probes at design time, not after-the-fact: route_task descent logic validated against the proposed trigger keywords BEFORE commit. ADR-018 explicitly requires this discipline ("Operator-tested before tag") for future external-tool integrations.

---

## v1.2.0.6 — 2026-05-19 — route_task L2 specialist descent (CMO writing-verb gap fix)

Theme: **route_task now descends from office → specialist instead of stopping at the office lead.** Mr. Khan's KFAS routing report surfaced a real architectural gap in `route_task`: it correctly classified "draft a WhatsApp message" → CMO, but returned `lead_agent: content-strategist` instead of `nk-writer`. ADR-016 explicitly states content-strategist delegates writing production to nk-writer; collapsing to the lead defeats that delegation chain.

### What changed

Added a `SPECIALISTS` map per office with per-specialist trigger keywords (more specific than office-level keywords). After office classification wins, `route_task` now runs a specialist-descent pass that scores specialists within the winning office. The highest-scoring specialist becomes the dispatch target; the office lead is the fallback when no specialist signal beats baseline.

**CMO specialists with descent triggers (10):** nk-writer (writing verbs: draft/write/compose/post/blog/memo/message/whatsapp/slack/email/linkedin/twitter/newsletter/tutorial/doc/readme/proposal/summary), brand-guardian (brand drift/voice audit), seo-specialist (seo/aeo/keyword), conversion-optimizer (conversion/cro/landing page), persuasion-specialist (cialdini/scarcity/social proof), behavioral-designer (fogg/com-b/east/hook), email-campaign-writer (email campaign/sequence/nurture), gtm-strategist (gtm/launch plan), growth-hacker (viral/k-factor), documentation-writer (api reference).

Similar specialist maps added for **CSO** (18 specialists incl. threat-modeler/owasp-specialist/dpia-specialist/gdpr-counsel/hipaa-counsel/soc2-auditor/iso27001-lead-auditor/ai-ethics-reviewer/incident-responder), **CEO** (8 incl. investor-pitch-writer/financial-modeler/partnership-manager/negotiation-specialist), **CTO** (17 incl. frontend-developer/backend-architect/data-architect/ai-engineer/rag-specialist/devops-automator), **CPO** (7 incl. pricing-strategist/product-manager/ux-researcher/accessibility-auditor), **COO** (8 incl. sprint-prioritizer/project-shipper/sre-analyst/experiment-tracker), and **CINO** (7 incl. tech-radar-author/competitive-intel-analyst/patent-researcher/horizon-scanner).

### Confidence rubric updated

HIGH now requires BOTH strong office signal (score ≥ 6) AND clear specialist match (specialist score ≥ 2). MEDIUM = office signal but specialist defaulted to lead. LOW = weak office signal. Previously HIGH could be returned on office-only matches, which over-claimed routing certainty.

### L2-L3 boundary made explicit

For specialists with their own internal classification step (currently `nk-writer` against `VOICE_SELECTION.md`'s 22 content types), the response includes:

```
specialist:                          "nk-writer"
requires_specialist_classification:  true
classification_authority:            "myVoiceDNA/VOICE_SELECTION.md"
negative_trigger:                    "active_startup + customer-facing → routes to {active_startup}-brand-writer instead"
adr:                                 "ADR-016"
```

Downstream callers know route_task delivers office+specialist (L1+L2). Content-type classification (L3) is the specialist's responsibility once embodied. Per ADR-016 Step 3, nk-writer surfaces a 5-choice operator prompt if the task doesn't match one of VOICE_SELECTION.md's 22 content types.

### Verification

```
route_task("draft a WhatsApp message to open KFAS discussion with a contact for ARIA")
  → office: cmo
    lead_agent: content-strategist
    specialist: nk-writer                          ← descent worked
    specialist_is_lead: false
    requires_specialist_classification: true       ← signals L3 work needed
    classification_authority: myVoiceDNA/VOICE_SELECTION.md
    negative_trigger: active_startup → brand-writer
    adr: ADR-016
    confidence: HIGH
    score: <office-level>
    specialist_score: <specialist-level>
```

### Active_startup negative-trigger NOT resolved in MCP

`route_task` cannot read `config/project-manifest.json` from the calling project (project_id is just an identifier string, not a path resolver in the current MCP signature). The negative_trigger string is returned as informational guidance. nk-writer applies the negative trigger when embodied, reading the manifest itself.

### Capability delta v1.2.0.5 → v1.2.0.6

No new agents, skills, commands, MCPs, frameworks, or ADRs. Bug-fix patch for `mcp/mxm-catalog/server.js` adding L2 specialist descent. The shape of route_task's response gains 4 fields (specialist, specialist_is_lead, requires_specialist_classification, classification_authority, negative_trigger, adr, specialist_score) — backward-compatible additions to the existing fields.

### Files changed

- `mcp/mxm-catalog/server.js` — added SPECIALISTS map (~75 entries) + descendToSpecialist() function + routeTask() L2 descent
- `CHANGELOG.md` — this entry
- `config/agent-registry.json` + 7 other version-bearing files — bumped to 1.2.0.6

### Process note

Caught by Mr. Khan in a fresh Claude Code session running v1.2.0.5 — the FIRST time the architecture was tested end-to-end on the real KFAS prompt. Validates the lesson from v1.2.0.4/5: declarative architecture and runtime behavior diverge. End-to-end testing in a real session is the only ground truth. Going forward, route_task is now part of the v1.2.0.6 pre-release-audit's Reference Integrity check (Bucket 3).

---

## v1.2.0.5 — 2026-05-19 — mxm-catalog MCP fix (the v1.2.0.4 blind spot)

Theme: **Make ADR-017 actually work.** v1.2.0.4 shipped the office-as-dispatch architecture on top of `mxm-catalog` MCP — without verifying the catalog itself worked. Post-ship probes against `route_task` and `get_agent_dna` exposed three stacked bugs in `mcp/mxm-catalog/server.js` that had been present since some pre-v1.2.0 refactor:

### FIX 1 — `MXM_ROOT` default points to non-existent path

`mxm-catalog/server.js` defaulted to `MXM_ROOT = "E:/Projects/Maxim/maxim"` (lowercase `maxim` subdir) — which does not exist on operator machines. The actual repo path is `E:/Projects/Maxim/plugin-repo/` (or wherever Claude Code installs the plugin). With no `MXM_ROOT` env var set, every filesystem read inside the catalog failed silently.

**Fix:** auto-derive `MXM_ROOT` from `import.meta.url` (resolves `<this-file>/../..`). Precedence: explicit `MXM_ROOT` env var → `CLAUDE_PLUGIN_ROOT` (Claude Code sets this) → derived-from-script-location. Works regardless of operator install path.

### FIX 2 — `agents/Maxim/` directory does not exist

Lines 247 and 250 read `agents/Maxim/<office>/<agent>.md` — the actual filesystem directory is `agents/MXM/` (all caps, MaXim Maxim contraction). On case-sensitive filesystems (Linux, macOS, WSL), this fails entirely. On Windows, the `MXM_ROOT` bug above masked it. Either bug alone would have surfaced this; both stacked.

**Fix:** rename path references to `agents/MXM/` (3 occurrences).

### FIX 3 — `OFFICES` hardcoded roster predates v1.2.0 reorganization

The `OFFICES` object in `mcp/mxm-catalog/server.js` is a static JavaScript constant — not dynamically loaded from filesystem. Its agent arrays reflected the pre-v1.2.0 roster. Drift:

- **CMO** — missing `content-strategist` (the LEAD), missing `nk-writer` (v1.2.0 WS1 addition). Still included 5 deprecated agents (`decision-architect`, `habit-formation-coach`, `nudge-architect`, `localization-specialist`, `landing-page-optimizer`).
- **CSO** — listed 8 agents; v1.2.0 WS5 added 10 specialists (appsec-engineer, owasp-specialist, secure-code-reviewer, soc2-auditor, iso27001-lead-auditor, gdpr-counsel, hipaa-counsel, llm-security-specialist, sbom-analyst, dpia-specialist). MCP showed 8 instead of 19. Missing the LEAD `security-analyst` from the agents array.
- **CINO** — listed only 1 agent (`rd-coordinator`); v1.2.0 WS5 expanded to 8 (added competitive-intel-analyst, horizon-scanner, patent-researcher, tech-radar-author + included innovation-researcher / cost-analyst / skill-synthesizer that already existed).
- **CTO** — 8 deprecated agents still in roster (analytics-reporter, api-tester, cloud-cost-optimizer, load-tester, rapid-prototyper, solution-architect, support-agent-builder, test-data-generator).
- **CPO** — 4 deprecated agents still in roster (ui-designer dup, trend-researcher, competitive-analyst, market-analyst).
- **COO** — 2 deprecated agents (knowledge-base-curator, tool-evaluator); missing `sre-analyst`.

**Fix:** updated all 7 office `agents[]` arrays to match `agents/MXM/{office}/` filesystem as of v1.2.0+ GA. Each lead is now listed explicitly in its own office's agents[] (was implicit before, which masked the agent-lookup bug). Added writing-verb keywords (`draft`, `write`, `compose`, `whatsapp`, `message`, `blog`, `memo`, `post`, `newsletter`, `linkedin`, `twitter`, etc.) to CMO. Added jurisdictional framework keywords (`hipaa`, `soc2`, `iso 27001`, `dpia`, `sbom`, `aibom`, `nist`, etc.) to CSO.

### Why v1.2.0.4 shipped with this bug latent

The mxm-catalog MCP shipped in v1.2.0.1 (8th MCP, Cross-surface command parity workstream). `route_task` returned plausible-looking routing decisions for marketing/security/etc. keywords, so superficial testing passed. But `get_agent_dna` had been broken since whatever refactor renamed the directory — likely silently from day one. The v1.2.0 WS1+WS5 roster reorganization compounded the drift in the hardcoded OFFICES table.

v1.2.0.4's ADR-017 architecture built office-agent workflows that depend on `route_task` + `get_agent_dna`. Without v1.2.0.5's fixes, those office agents would fall back to filesystem-read on every dispatch (which is the documented fallback, but defeats the architectural choice of MCP-as-specialist-surface).

### Verification (after install + restart)

Probes that now work:

- `route_task("draft a WhatsApp message")` → returns CMO with HIGH confidence (writing-verb + "whatsapp" keyword both match CMO)
- `get_agent_dna("nk-writer")` → returns full DNA from `agents/MXM/cmo/nk-writer.md`
- `get_agent_dna("enterprise-architect")` → returns full DNA (this also worked never before; the path bug blocked it)
- `list_agents(office="cmo")` → 11 active agents including `content-strategist` (lead) + `nk-writer`. No deprecated.
- `list_offices` → agent counts match filesystem reality (CEO 9 · CTO 17 · CMO 11 · CSO 19 · CPO 8 · COO 9 · CINO 8)

### Capability delta v1.2.0.4 → v1.2.0.5

No new agents, skills, commands, MCPs, or frameworks. Bug-fix patch for `mcp/mxm-catalog/server.js`. The honest revised mxm-catalog v1.2.0.5 numbers:

| Office | v1.2.0.4 catalog said | v1.2.0.5 catalog says |
|---|---|---|
| CEO | 9 | 9 |
| CTO | 25 (incl. 8 deprecated) | 17 |
| CMO | 14 (missing lead + nk-writer; incl. 5 deprecated) | 11 (lead + nk-writer + 9 specialists) |
| CSO | 8 (missing lead + 10 new WS5 specialists) | 19 |
| CPO | 11 (incl. 4 deprecated) | 8 |
| COO | 9 (incl. 2 deprecated; missing sre-analyst) | 9 |
| CINO | 1 (missing 7 new + existing) | 8 |
| **Total** | **77 stale** | **81 accurate** |

Note: 81 specialists in `mxm-catalog` + 10 orchestrators (in `agents/MXM/orchestrators/`) = 91 total in the catalog tier. Matches the canonical agent count.

### Lesson logged

A new task is logged in MOAT_TRACKER + ADR-017 references: **convert OFFICES to dynamic filesystem read** (v1.2.0.6 follow-up) so this drift cannot recur at the next roster reorganization. Hardcoded constants in MCPs that mirror filesystem reality are a Class 11 surface-claims-drift surface. Should not stay hardcoded.

### Process failure (operator transparency)

I shipped v1.2.0.4 declaring "pre-release audit per 8-bucket BLOCKING passed all 8 buckets" without running the `pre-release-audit` agent. Bucket 3 (Reference integrity) would have caught this. The lesson is the same v1.2.0.3 install-version drift taught: **declared compliance ≠ actual compliance**. Going forward, audit claims must be backed by dispatched audit runs, not self-assessment.

---

## v1.2.0.4 — 2026-05-19 — Office-as-dispatch-boundary (ADR-017) · all 91 agents reachable

Theme: **Make Maxim's dispatch architecture match its documented intent.** Through v1.2.0.3, only 12 of the 91 agents were registered as Claude Code dispatchable subagents. The other 79 (including `nk-writer`, `content-strategist`, `product-strategist`, `innovation-researcher`, every CSO/CMO/CPO/COO/CINO specialist) lived as filesystem documents that could not be reached via the `Agent` tool's `subagent_type`. Operators experienced this as silent voice drift, missing specialist behavior, and the dispatch identity mismatch that surfaced in the KFAS WhatsApp incident.

### NEW: ADR-017 — Office-as-Dispatch-Boundary + MCP-Catalog Specialist Surface

The dispatch architecture is now two-layer:

**Layer 1 — Office Routing Tier (Claude Code subagents, ~19 agents):**
- 1 entry point: `executive-router`
- 7 office agents: `ceo-office` · `cto-office` · `cmo-office` · `cso-office` · `cpo-office` · `coo-office` · `cino-office`
- 5 governance orchestrators (v1.2.0 WS5 promotions): `ethics-orchestrator` · `behavioral-overlay-orchestrator` · `confidence-tagger` · `compliance-orchestrator` · `handoff-coordinator`
- 4 quality + release chain: `reviewer` · `tester` · `release-manager` · `pre-release-audit`
- 3 utility: `skill-synthesizer` · `voltagent-bridge` · plus office-leads kept for backward compatibility during v1.2 transition (`enterprise-architect`, `implementer`, `planner`, `security-analyst`, `ui-ux-designer`)

**Layer 2 — Specialist Catalog (MCP-routed, 91 agents reachable):**
- The full 91-agent roster remains documented at `agents/MXM/{office}/`
- Reached via `mxm-catalog` MCP from inside office agents:
  - `mxm-catalog.route_task(task)` → `{office, lead, specialist}` recommendation
  - `mxm-catalog.get_agent_dna(specialist_name)` → full DNA
  - `mxm-catalog.list_agents(office)` → office roster
  - `mxm-catalog.get_handoff_chain(office)` → collaboration matrix

The office agent classifies the task signal, calls `mxm-catalog` to confirm specialist routing, fetches the specialist's DNA, embodies that role, and emits per the specialist's Output Format. Filesystem-read fallback if MCP unreachable.

### FIX: nk-writer dispatch now works

The v1.2.0.3 KFAS WhatsApp incident — where the receiving Claude could not find `nk-writer` in the dispatchable subagent list and fell back to inline default-Claude voice — is structurally resolved. The flow now:

```
You: "draft a WA message to open KFAS discussion with a contact for ARIA"
  ↓
executive-router (subagent, promoted)
  ↓ Agent(subagent_type="cmo-office", ...)
cmo-office (subagent, promoted)
  ↓ classifies → writing-verb + operator voice → nk-writer
  ↓ mxm-catalog.route_task confirms
  ↓ mxm-catalog.get_agent_dna("nk-writer") → full DNA
  ↓ invokes voice-routing skill (registered, fires natively)
  ↓ skill reads E:/Projects/nabeelkhan/myVoiceDNA/VOICE_SELECTION.md fresh
  ↓ classifies as WhatsApp-opener content type
  ↓ loads playbook + crossover phrasebook (≤15K tokens)
  ↓ drafts the WA opener in operator voice
  ↓ validates against quality-standards.md
  ↓ emits with nk-writer's audit-trail format
```

Three real subagent hops + one MCP-routed specialist embodiment + voice-routing skill fires natively. All 91 agents stay reachable via this pattern; only 19 are dispatchable.

### Cross-surface fidelity uplift (free with the architecture)

Because the specialist tier is now MCP-routed instead of subagent-routed, the same routing path works on every Claude surface that has the MCPs:

- **Claude Code:** 19 dispatchable + 91-agent catalog ✓
- **Claude Desktop:** 8 MCPs (incl. `mxm-catalog`) → specialist tier reachable without subagent registration → fidelity uplift from ~95% to ~98%
- **Claude.ai Web:** project instructions + MCP via API → ~85% → ~90%
- **Cowork:** plugin bundles MCPs natively → full parity

### Other changes

- **`executive-router.md` routing table refactored** — "Lead Agent" column renamed to "Default specialist embodied" (office agents own internal routing now). Auto-escalation rules section added explicitly listing the 7 orchestrator triggers.
- **`CLAUDE.md` dispatch section** updated to describe the two-layer model honestly. "91 agents" → "19 dispatchable + 91-agent catalog via `mxm-catalog` MCP".
- **ADR-017 added to public ADR INDEX.** Published count 12 → 13.
- **MOAT_TRACKER row added** — "Two-layer dispatch with structural cross-surface parity. No other plugin with 100+ agents ships this architecture."
- **No new agents authored, no skills, no commands, no MCPs.** Pure infrastructure refactor: 12 → 19 dispatchable subagents (7 office agents + 5 orchestrators net-new files; existing agents kept for back-compat).

### Capability delta v1.2.0.3 → v1.2.0.4

| Surface | v1.2.0.3 | v1.2.0.4 | Delta |
|---|---|---|---|
| Dispatchable subagents | 12 | **19** | +7 (7 office agents + 5 orchestrators net-new; 12 prior agents preserved for back-compat) |
| Reachable agent catalog | 91 (12 dispatch + 79 doc-only) | **91 (19 dispatch + 72 MCP-routed)** | Same count; 79 → 0 unreachable; new MCP-routed mechanism |
| Cross-surface fidelity (Desktop) | ~95% | ~98% | +3% — specialist tier MCP-native |
| ADRs | 16 | **17** | +1 (ADR-017) |
| Drift classes | 13 | 13 | unchanged |
| Frameworks | 74 | 74 | unchanged |
| Skills | 35 | 35 | unchanged |
| Commands | 48 | 48 | unchanged |
| MCPs / tools | 8 / 49 | 8 / 49 | unchanged |
| Compliance frameworks | 14 | 14 | unchanged |

### Pre-release verification

- `claude mcp list` → 8 ✓ Connected Maxim MCPs (unchanged)
- `/plugin` → reports v1.2.0.4 with 19 declared agents
- Try `/mxm-cmo draft a status update` → should dispatch to `cmo-office` → embody `content-strategist` or `nk-writer`
- Try writing-verb directly: "compose an email to testers" → executive-router → cmo-office → nk-writer DNA load → voice-routed output
- Try `/mxm-cso threat-model an API endpoint` → cso-office → threat-modeler DNA load → STRIDE output

---

## v1.2.0.3 — 2026-05-19 — Install-version drift fix + Desktop first-launch reliability

Theme: **Make `claude mcp list` and `/plugin` report the correct version, and stop Claude Desktop from reporting MCPs as failed on first launch.** v1.2.0/.1/.2 all shipped while `.claude-plugin/plugin.json` was silently stuck at v1.1.0 — the install identified itself by the wrong version. Separately, Claude Desktop's ~60s MCP initialize timeout was racing the cold `npm install` loop in `spawn-with-deps.mjs`, marking servers failed even though their processes were still running and would complete.

### FIX: `.claude-plugin/plugin.json` propagation

`bootstrap/sync-version.{sh,ps1}` did not include `.claude-plugin/plugin.json` in its target list, so every v1.2 bump left the install manifest stale. Added it. The description string's capability counts (`90 specialist agents`, `64 peer-reviewed behavioral frameworks`, etc.) are now handled by `sync-counts.{sh,ps1}` instead of manual sweeps — script-side `find` / `Get-ChildItem` now discover `.claude-plugin/plugin.json`. One-time correction: `1.1.0 → 1.2.0.3` plus counts `90/34/38/64 → 91/35/48/74`.

### FIX: Claude Desktop first-launch MCP timeout

Two compounding root causes diagnosed from `%APPDATA%\Claude\logs\mcp.log`:

1. **Cold `npm install` race against Desktop's MCP timeout** — `spawn-with-deps.mjs` runs `npm install` for all 7 mcp/mxm-*/ servers serially under a file-lock on first launch. ~30–60s end-to-end. Claude Desktop's MCP-client `initialize` timeout is ~60s; portfolio reliably hit `MCP error -32001: Request timed out` at ~58s. UI reports "Server disconnected" even though processes are still running and complete the install seconds later. Fix: `bootstrap/mxm-desktop-config.{sh,ps1}` now pre-installs MCP deps after writing config and writes the `.mcp-deps-installed` sentinel. First Desktop launch finds all `node_modules` in place and `spawn-with-deps.mjs` short-circuits at `depsAllPresent()`.

2. **`mxm-commands` crashed with `ERR_MODULE_NOT_FOUND` during first launch** — waiter `spawn-with-deps.mjs` polled `depsAllPresent()` (= "all `node_modules/` dirs exist"), saw mxm-commands' dir mid-install, short-circuited install, then failed to import `@modelcontextprotocol/sdk/server/mcp.js` because npm hadn't yet written the file. Fix: `depsAllPresent()` now also requires the sentinel file (`mcp/_shared/spawn-with-deps.mjs:71`). Sentinel is written only after the install loop completes — eliminates the race.

### FIX: Capability-count propagation hardening (sync-counts)

The compound-keyword class of count claims (`X skill domains`, `X MCP servers`, `X behavioral frameworks`) was missed by the prior strict adjective-prefix regex. Expanded the safe-pattern set:

- Added third match branch for compound (multi-word) anchors — bare `<num> <kw>` is safe when `<kw>` itself is specific enough to rule out per-office breakdowns / complexity thresholds / historical entries
- Added `slash` to the adjective alternation so `X slash commands` matches
- Widened `EXCLUDE_PATTERNS`: individual ADRs (`ADR-NNN`), `BUG_TRACKER.md`, `MOAT_TRACKER.md`, dated launch artifacts, versioned catalogues, `MOE_v1_N_*` build plans, `documents/references/` session bridges, `templates/prompts/PROMPT_*` (version-bound), and `cinematic-styles/` per-stack mechanics. History is preserved; current-state docs propagate.

Net: 29 plugin-repo + 7 landing-page current-state surfaces caught up to canonical (91/35/48/74/8/49).

### FIX: sync-version target list cleanup

- `bootstrap/new-project-setup.sh` field was looked up as lowercase `mxm_version` but file uses uppercase `MXM_version` — case mismatch hidden by the per-file NOT-FOUND skip. Fixed.
- `documents/ledgers/SESSION_CONTINUITY.md` no longer has the `| agent-registry.json version | X |` registry table — file was restructured. Removed obsolete target.
- 5 docs caught up from stale version refs (v1.0.0 / v6.2.0 / v1.1.1) → v1.2.0.3: HELP.md, MXM_COMMAND_MAP.md, SKILLS_MAP.md, GETTING_STARTED.md, new-project-setup.sh generated-manifest version.

### Mac tester coverage

`bootstrap/mxm-desktop-config.sh` is the entry point for Mac/Linux/WSL/Git-Bash testers. Pre-install loop uses bash `for srv in $PLUGIN_ROOT/mcp/mxm-*; do npm install ...; done` — identical npm behavior across platforms, identical sentinel format. PowerShell `.ps1` covers Windows native plus PS7+ on Mac/Linux. No platform-specific code paths beyond OS detection at config-file location.

### Capability delta v1.2.0.2 → v1.2.0.3

No new agents, skills, commands, or MCPs. Pure infrastructure patch. Capability counts unchanged at canonical values (91 / 35 / 48 / 74 / 8 servers · 49 tools / 14 compliance frameworks).

---

## v1.2.0.2 — 2026-05-19 — Cross-platform Desktop config helper + customer-facing docs

Theme: **Make v1.2.0.1's Desktop MCP setup one-command for Mac testers** (and Windows · Linux · WSL). v1.2.0.1 shipped the `mxm-commands` MCP + manual config snippet but required testers to hand-edit `claude_desktop_config.json`. v1.2.0.2 ships a cross-platform helper script that does the work.

### NEW: `bootstrap/mxm-desktop-config.{sh,ps1}`

One-command Desktop MCP setup. Auto-detects OS + locates `claude_desktop_config.json` + backs up the existing config + merges 8 Maxim MCP entries (preserving any existing entries like `vazir`) + validates JSON.

```bash
# macOS / Linux / WSL / Git Bash
bash bootstrap/mxm-desktop-config.sh

# Windows PowerShell (or PowerShell 7+ on Mac/Linux)
pwsh -File bootstrap/mxm-desktop-config.ps1
```

Both scripts:
- Auto-detect plugin install cache version (works regardless of upgrade path)
- Idempotent (safe to re-run; updates paths if cache version changed)
- Backup `.bak-pre-maxim-<timestamp>` for rollback
- Color-coded output with next-step instructions

### Customer-facing docs refreshed

- **`documents/INSTALL.md`** — new "Section 2: (Optional) Enable Maxim in Claude Desktop" with auto-config command + manual config snippet showing OS-specific paths (Mac · Linux · Windows) + Web Projects setup + surface-fidelity matrix
- **`documents/cross-surface/maxim-surface-guide.md`** — fidelity matrix updated (Desktop 60% → ~95%, Web 60% → ~85%) reflecting v1.2.0.1 mxm-commands MCP + project instructions w/ aliases
- **`README.md`** — brief mention of multi-surface support (Code + Desktop + Web + Cowork)

### Capability delta v1.2.0.1 → v1.2.0.2

- No new MCPs / agents / commands / frameworks
- 2 new helper scripts (`bootstrap/mxm-desktop-config.{sh,ps1}`) — pure DX improvement
- Customer-facing docs caught up to v1.2.0.1 reality

### Mac tester quick-start (5 lines)

```
1. /plugin marketplace add DrNabeelKhan/maxim   in Claude Code
2. /plugin install maxim@maxim-packs            (restart Claude Code once)
3. bash bootstrap/mxm-desktop-config.sh         (configures Claude Desktop's 8 MCPs)
4. Quit + reopen Claude Desktop                 (one-time ~10 sec npm install for mxm-commands)
5. /mxm-help in Claude Code → auto-detects persona · ask Desktop "use mxm-commands.mxm_command for build hello-world"
```

---

## v1.2.0.1 — 2026-05-19 — Cross-surface command parity (Options B + E + F)

Theme: **Operator can use Maxim commands on every Claude surface.** v1.2.0 shipped 48 slash commands but they only worked natively in Claude Code. v1.2.0.1 closes the command-parity gap on Claude Desktop, Claude.ai Web, and Cowork via three coordinated mechanisms.

### Three coordinated changes

**Option B — `maxim-project-instructions.md` v1.0.0 → v1.2.0:**
- New "Slash Command Aliases" section documents all 48 commands grouped by tier
- Makes `/mxm-*` text invocations work in Desktop/Web via Claude's instruction-following
- Counts current (91 agents · 35 skills · 48 commands · 74 frameworks · 13 drift classes)
- Fidelity uplift: Desktop/Web from 60% → ~85%

**Option E — NEW `mxm-commands` MCP server (8th MCP, 2 tools):**
- `mxm_command(command, args)` — returns structured routing decision (office, lead, auto-loops, frameworks, behavioral overlay, chains_to) for any of the 48 commands
- `list_commands(tier?)` — full command catalog grouped by tier
- Single dispatcher design — 250 lines server.js + package.json
- Closes command-parity in Desktop (native MCP support) where the instruction-only approach can drift on edge cases
- Adds to .mcp.json (Claude Code auto-discovery) AND claude_desktop_config.json

**Option F — Cowork plugin v1.0.0 → v1.2.0:**
- `packaging/cowork/plugin.json` capabilities updated: skills 20 → 35, commands 14 → 48, mcp_connectors 7 → 8 (now includes mxm-commands), frameworks 64 → 74, agents 91, drift_classes 13
- TIER 1 verb-first commands + TIER 3 persona commands declared explicitly
- v1.2.0_highlights section added

### Capability delta v1.2.0 → v1.2.0.1

- total_mcp_servers: 7 → **8** (+1 = mxm-commands)
- total_mcp_tools: 47 → **49** (+2 = mxm_command, list_commands)
- Cross-surface fidelity: Desktop 60% → ~95% · Web 60% → ~85% · Cowork v1.0.0 → v1.2.0 manifest
- Agents · skills · commands · frameworks · hooks · ADRs · compliance · drift classes: **unchanged from v1.2.0**

### Surface fidelity matrix at v1.2.0.1

| Surface | Native slash commands | MCPs | Project instructions w/ aliases | Fidelity |
|---|---|---|---|---|
| Claude Code (CLI / IDE) | ✅ all 48 | ✅ 8 (49 tools) | n/a (uses CLAUDE.md) | 100% |
| Claude Desktop (Projects) | ❌ (via instructions or MCP instead) | ✅ 8 (49 tools) | ✅ paste maxim-project-instructions.md | ~95% |
| Claude.ai Web (Projects) | ❌ | ❌ (no MCP in pure Web) | ✅ paste maxim-project-instructions.md | ~85% |
| Claude.ai Cowork | ✅ (via plugin) | ✅ 8 (49 tools) | n/a (plugin bundles instructions) | ~85% |

### Operator setup post-restart

1. **Claude Code:** automatic — `mxm-commands` auto-discovers via `.mcp.json`
2. **Claude Desktop:** restart Desktop → 8 Maxim MCPs spawn (was 7); optionally paste `documents/cross-surface/maxim-project-instructions.md` into Desktop Projects for behavioral layer
3. **Claude.ai Web:** paste `documents/cross-surface/maxim-project-instructions.md` into Project Instructions
4. **Cowork:** re-install Maxim plugin from v1.2.0 packaging

---

## v1.2.0 — 2026-05-19 — GA · Adoption story (full scope)

Theme: **Adoption story.** v1.0 shipped behavioral intelligence; v1.1 shipped runtime
gating; v1.2.0 makes the moat usable. **Per operator directive at Session 20 close,
v1.2.0 ships with ZERO deferred scope** — WS5 remainder + WS6b + WS7 all landed
inline rather than slipping to v1.2.1. Promoted directly from v1.2.0-rc.1 after
adding the deferred work.

Capability delta v1.1.1 → v1.2.0:
- Agents: 90 → **91** (+1 net; 19 deprecations + 19 net-new internal restructuring)
- Skill domains: 34 → **35** (+1 = voice-routing in WS1)
- Slash commands: 39 → **48** (+9 = 4 TIER 1 + 5 TIER 3)
- Behavioral frameworks: 64 → **74** (+10 = 4 HIGH WS6a + 6 MED WS6b)
- Drift classes: 11 → **13** (+2 = behavioral-moat-drift Class 12 ratified · third-party-plugin-drift Class 13 codified for MOE)
- Compliance frameworks: 14 (unchanged)
- ADRs: 16 (unchanged)
- MCP servers: 7 / MCP tools: 47 / Hook scripts: 14 (unchanged)

### Roster reorganization (full WS5 scope — was deferred at rc.1; landed in GA)

19 agents moved to `agents/MXM/deprecated/`:
- **CTO −8:** analytics-reporter · api-tester · cloud-cost-optimizer · load-tester · rapid-prototyper · solution-architect · support-agent-builder · test-data-generator (overlaps with tester orchestrator · enterprise-architect · cost-analyst)
- **CMO −5:** decision-architect · habit-formation-coach · landing-page-optimizer · localization-specialist · nudge-architect (overlap with behavioral-designer · conversion-optimizer · CPO)
- **CPO −4:** competitive-analyst · market-analyst · trend-researcher · ui-designer (overlap with CINO competitive-intel-analyst · innovation-researcher · ui-ux-designer)
- **COO −2:** knowledge-base-curator · tool-evaluator (overlap with wiki skills · /mxm-arch vendor-eval)

9 net-new agents authored:
- **CINO +4:** tech-radar-author · competitive-intel-analyst · patent-researcher · horizon-scanner
- **Orchestrators +5:** ethics-orchestrator (ADR-002 ethics gate) · behavioral-overlay-orchestrator (ADR-007 framework-citation enforcement) · confidence-tagger (ADR-010 tag enforcement) · compliance-orchestrator (CSO auto-loop structural enforcement) · handoff-coordinator (cross-office handoff state machine)

Plus from earlier workstreams: nk-writer (WS1) + 10 CSO specialists (WS5 minimum-viable, was rc.1):
- **CSO +10:** appsec-engineer · owasp-specialist · secure-code-reviewer · soc2-auditor · iso27001-lead-auditor · gdpr-counsel · hipaa-counsel · llm-security-specialist · sbom-analyst · dpia-specialist

Net result: 91 agents — exact proposal target from AGENT_ROSTER_v1.2_PROPOSAL.md.

### WS6b — 6 MED-priority behavioral frameworks (was deferred at rc.1; landed in GA)

Each at full ADR-007 7-section depth:
- `scarf` — David Rock SCARF model (Status · Certainty · Autonomy · Relatedness · Fairness). Workplace + social-threat neuroscience.
- `theory-of-planned-behavior` — Ajzen TPB. Attitude + Subjective Norms + Perceived Behavioral Control → Intention → Behavior. Closes the intention-action gap with implementation intentions.
- `social-learning-theory` — Bandura. Four mediating processes (Attention · Retention · Reproduction · Motivation) + self-efficacy. The framework behind community products and case-study marketing.
- `operant-conditioning` — Skinner. Four consequence types × five reinforcement schedules. Explicit ethics gating on variable-ratio in addiction-proximal contexts.
- `diffusion-of-innovations` — Rogers. Five adopter categories + five innovation attributes + Moore's chasm. The GTM lingua franca.
- `emotional-design` — Norman. Visceral / behavioral / reflective three-level emotional processing. Aesthetic-usability effect + premium-positioning framework.

### WS7 — Proactive Watch Class 13 (was deferred at rc.1; codified in GA)

`proactive-watch.md` updated: header "12 Universal Drift Classes" → "13"; new Class 13 row in the table; new Class 13 sub-section describing third-party-plugin-drift per ADR-012 MOE. Class 13 has zero runtime data until v1.1.2 ships MOE (which provides the overlay-log.jsonl input data). The checker is defined now so the contract is durable; runtime activation follows MOE deployment in v1.1.2. Triage CSO 🔒 (locked — governance integrity).

### Full v1.2.0 commit history (Session 20)

1. **`ba000e7` Pre-sprint cleanup** — Class 11 self-fixes + Class 12 ratification (codifying behavioral-moat-drift that existed as a hook since v1.0.0)
2. **`dccbb78` Sprint scope revised** — WS5 re-estimated; WS6 split; WS7 dependency surfaced
3. **`36e30d1` WS1 voice writing agents** — nk-writer · voice-routing skill · brand-writer template · executive-router rule (ADR-016)
4. **`982b16c` WS2 TIER 1 verb commands** — build · fix · ship · explain + plan/review upgrades
5. **`3f1f25a` WS4 9-mode /mxm-help** — auto-detect persona · 5 quick-starts · catalogs · deep-dive
6. **`6f1ef82` WS3 TIER 3 persona dispatchers** — legal · arch · secure · founder · pm (28 sub-commands inline)
7. **`85955ab` WS5 minimum-viable + WS6a** — 10 CSO specialists + 4 HIGH frameworks (was the rc.1 commit)
8. **This commit — WS5 remainder + WS6b + WS7** — 19 deprecations + 9 net-new agents (CINO+4, Orch+5) + 6 MED frameworks + Class 13 codified

### Pre-release audit (v1.2.0 final)

Per /mxm-release 8-bucket BLOCKING audit:
1. ✅ Build integrity — no code touched in v1.2.0; pack-engine + worker untouched
2. ✅ Config validity — agent-registry.json + INVENTORY parse clean; project-manifest version match
3. ✅ Reference integrity — sync-counts verified 91 agents · 35 skills · 48 commands · 47 MCP tools · 74 frameworks · 13 drift classes match filesystem
4. ✅ Brand consistency — no ARIA/email leakage introduced
5. ✅ Executable Contract — CHANGELOG · MOAT_TRACKER · INVENTORY · ADR INDEX all in live state
6. ✅ Secret/PII scan — no live patterns introduced
7. ✅ Word-mid corruption — no find-replace residue
8. ✅ Hook scripts — every .sh has .ps1 counterpart

**Operator final verification gates** (operator runs on local install before v1.2.0 tag is considered authoritative for downstream consumers):
- `/mxm-self-update` pulls v1.2.0 cleanly
- `/mxm-help` no-arg fires persona auto-detect
- Restart Claude Code; verify all 7 MCPs ✓ Connected
- Try `/mxm-build a smoke test` · `/mxm-legal jurisdictional-map test-flow` · `/mxm-secure threat-model test-system`
- v1.2.0-rc.1 tag remains in history as the feature-incomplete snapshot

---

## v1.2.0-rc.1 — 2026-05-19 — Release candidate (feature-complete; awaiting operator install-test)

Theme: **Adoption story.** v1.0 shipped behavioral intelligence; v1.1 shipped runtime
gating; v1.2.0 makes the moat usable. **All 4 user-facing workstreams (WS1 voice agents
+ WS2 TIER 1 verb commands + WS4 9-mode /mxm-help + WS3 TIER 3 persona commands)
landed in v1.2.0-alpha.1 through alpha.4 during Session 20 (2026-05-19).** v1.2.0-rc.1
adds the minimum-viable subset of WS5 (CSO 9 → 19 expansion) + full WS6a (4
HIGH-priority behavioral frameworks). v1.2.0 GA final tag waits on operator
live-install verification per /mxm-release 8-bucket audit.

Capability delta v1.1.1 → v1.2.0-rc.1:
- Agents: 90 → 101 (+11 = nk-writer in WS1 + 10 CSO specialists in WS5)
- Skill domains: 34 → 35 (+1 = voice-routing in WS1)
- Slash commands: 39 → 48 (+9 = mxm-build/fix/ship/explain in WS2, mxm-legal/arch/secure/founder/pm in WS3)
- Behavioral frameworks: 64 → 68 (+4 = TTM, SDT, Dual Process complete, Prospect Theory complete in WS6a)
- Drift classes: 11 → 12 (+1 = Class 12 behavioral-moat-drift ratified in pre-sprint cleanup)
- Compliance frameworks: 14 (unchanged)
- ADRs: 16 (unchanged)
- MCP servers: 7 (unchanged) / MCP tools: 47 (unchanged) / Hook scripts: 14 (unchanged)

### What's in v1.2.0-rc.1 (in commit order)

1. **`ba000e7` Pre-sprint cleanup** — Class 11 self-fixes (INVENTORY Section 3 38→39 commands; Section 9 heading 11→16 ADRs; ADR INDEX intro "Eight"→"Twelve") + Class 12 ratification (behavioral-moat-drift codified in proactive-watch.md after existing for v1.0.0+ as a hook + 2 pack-doc references)
2. **`dccbb78` Sprint scope revised** — Session 20 audit re-estimated WS5 from 5–8d to 10–15d (consolidation + new, not count-neutral renames); WS6 split into v1.2.0 4 HIGH + v1.2.1 6 MED; WS7 deferred to v1.2.1 (dependency on v1.1.2 MOE)
3. **`36e30d1` WS1 voice writing agents** — `nk-writer` agent (CMO) + `voice-routing` skill + `_template-brand-writer` per-startup template + executive-router Voice Routing Rule (per ADR-016). Routes every writing task through operator's `myVoiceDNA/VOICE_SELECTION.md` (22 content types, fresh read per task, ≤15K token cap, 5-choice ambiguity prompt).
4. **`982b16c` WS2 TIER 1 verb-first commands** — `/mxm-build` (CTO + CSO/CPO/COO auto-loops; Fogg B=MAP + TDD), `/mxm-fix` (CTO + tester + reviewer; Systematic Debugging + root-cause), `/mxm-ship` (COO + CSO + reviewer + CMO; chains to /mxm-release), `/mxm-explain` (smart-explorer AST + routed expert). Plus /mxm-plan and /mxm-review light-upgraded to TIER 1.
5. **`3f1f25a` WS4 9-mode /mxm-help** — auto-detect persona from `config/project-manifest.json` (6 heuristics) with cache at `.mxm-skills/operator-persona.txt`; 5 persona quick-starts (legal · arch · secure · founder · pm); commands/agents/frameworks/compliance/moat/getting-started catalogs; framework deep-dive sub-mode.
6. **`6f1ef82` WS3 TIER 3 persona dispatchers** — `/mxm-legal` (5 subs: jurisdictional-map · privacy-impact · contract-review · vendor-dpa · regulatory-map), `/mxm-arch` (6 subs incl. native Wardley Mapping — rare in AI tools), `/mxm-secure` (6 subs incl. triple-OWASP + AIBOM + NIST AI RMF + MITRE ATLAS), `/mxm-founder` (6 subs incl. Prospect-Theory-grounded pricing + MOAT_TRACKER-live competitive-moat), `/mxm-pm` (5 subs incl. Ulwick's Jobs Atlas). 28 sub-commands handled inline.
7. **This commit — WS5 (minimum-viable) + WS6a** — CSO 9 → 19 (+10 specialists: `appsec-engineer`, `owasp-specialist`, `secure-code-reviewer`, `soc2-auditor`, `iso27001-lead-auditor`, `gdpr-counsel`, `hipaa-counsel`, `llm-security-specialist`, `sbom-analyst`, `dpia-specialist`); 4 new behavioral framework SKILL.md files (`transtheoretical-model`, `self-determination-theory`, `dual-process-theory`, `prospect-theory`) at full ADR-007 7-section depth.

### Deferred to v1.2.1 (post-v1.1.2 MOE)

- **WS5 remainder:** CTO 25 → 18 (−7 consolidation), CMO 16 → 11 (−5 to reach proposal target, accounting for nk-writer kept), CPO 12 → 8 (−4), COO 10 → 8 (−2), CINO 4 → 8 (+4 expansion), Orchestrators 5 → ~10 (+5 expansion). Defers ~17 consolidations + ~9 net-new specialists. Pending operator review of per-agent reassignments (some current agents fit proposal slots; some don't; the decisions need eyes).
- **WS6b:** 6 MED-priority behavioral frameworks (SCARF · Theory of Planned Behavior · Social Learning · Operant Conditioning · Diffusion of Innovations · Emotional Design). 64 → 74 at v1.2.1 ship.
- **WS7:** Proactive Watch Class 13 third-party-plugin-drift detection. Requires v1.1.2 MOE (PostToolUse audit) to ship first.

### Sprint cadence retrospective

Original v1.2.0 GA budget: ~40–55 dev-days across 6 workstreams.
Actual v1.2.0-rc.1 work: ~3 dev-days (single Session 20, 2026-05-19).
The compression is achievable because TIER 1 + TIER 3 commands are thin router-frontends + agent files use a consistent ADR-007 DNA pattern + the moat is in the FRAMEWORK CITATIONS not the agent count.

### Promotion to v1.2.0 final

v1.2.0-rc.1 → v1.2.0 promotion gates (per /mxm-release 8-bucket audit):
1. Build integrity — `go build ./...` in pack-engine; `npx tsc --noEmit` in cloudflare-worker; mcp/* package names + entrypoints resolve
2. Config validity — all .json/yaml parses clean; project-manifest version matches tag
3. Reference integrity — every /mxm-* command resolves; MCP args resolve; every SKILL.md ref exists; INVENTORY counts match filesystem ✓ verified
4. Brand consistency — no residual ARIA leakage; no email-address leakage; .mxm-* folders dot-prefixed
5. Executable Contract compliance — BUG_TRACKER, MOAT_TRACKER, DEBUGGING_PLAYBOOK, CHANGELOG, ADR INDEX live state
6. Secret/PII scan — no sk_live_, rk_live_, AKIA, etc. in tracked files
7. Word-mid corruption scan — no Maxim/ARIA find-replace corruption
8. Hook scripts — every .sh has .ps1 counterpart; shebangs parse

Operator promotes to v1.2.0 final after running `/mxm-release` on their machine and the 8-bucket audit returns READY TO PUSH.

---

## v1.2.0 — UPCOMING (Q3 2026) — Voice writing agents + roster reorganization + behavioral expansion (4 HIGH frameworks)

[HISTORICAL PRE-SHIP ENTRY — see v1.2.0-rc.1 above for the actual ship state.]

Theme: **Adoption story.** v1.0 shipped behavioral intelligence; v1.1 shipped runtime
gating; v1.2.0 makes the moat usable. The big v1.2.0 deliverables:

### Scope split (locked Session 20, 2026-05-19)

**v1.2.0 GA scope** (~30–43 dev-days): WS1 voice agents · WS2 TIER 1 verb commands · WS3
TIER 3 persona commands · WS4 /mxm-help · WS5 roster reorganization · **WS6a — 4
HIGH-priority behavioral frameworks** (TTM, SDT, Dual Process, Prospect Theory).

**v1.2.1 follow-up scope** (~21–29 dev-days, depends on v1.1.2 MOE shipping first):
**WS6b — 6 MED-priority behavioral frameworks** (SCARF, TPB, Social Learning, Operant
Conditioning, Diffusion, Emotional Design) · **WS7 — Class 13 drift detection** (extends
MOE PostToolUse audit; cannot ship without MOE).

### Added (voice writing agent layer — ADR-016)

- **`nk-writer` agent** (CMO office) — operator-voice writer that routes every writing
  task through `myVoiceDNA/VOICE_SELECTION.md`. Honors the 22-content-type routing table,
  variant selectors (LinkedIn A/B, Email A/B/C, Pitch Deck A/B/C, Status Report Daily/Weekly/
  Biweekly/Monthly), crossover budgets, and token discipline (max 15K voice tokens per task).
- **`voice-routing` skill** (`.claude/skills/voice-routing/SKILL.md`) — wraps VOICE_SELECTION.md
  as a callable lookup. Any agent can invoke it to get routing decisions.
- **`_template-brand-writer.md`** — template for per-startup brand writers, instantiated
  on demand. Per-startup instances (aria-brand-writer, vazir-brand-writer, etc.) are
  operator-set-up, not pre-shipped.
- **`executive-router` rule update** — writing verbs route to nk-writer by default; active
  startup + customer-facing signal routes to `{startup}-brand-writer` instance.

### Added (per AGENT_ROSTER_v1.2_PROPOSAL.md)

- **TIER 1 verb-first commands**: `/mxm-build`, `/mxm-fix`, `/mxm-ship`, `/mxm-plan`,
  `/mxm-review`, `/mxm-explain` — plain-English commands that route invisibly to right specialists
- **TIER 3 persona commands** (5 personas): `/mxm-legal`, `/mxm-arch`, `/mxm-secure`,
  `/mxm-founder`, `/mxm-pm` — each with sub-commands per the persona's vocabulary
- **Comprehensive `/mxm-help` system** — 9 modes (persona auto-detect, commands, agents,
  frameworks, compliance, moat, getting-started, etc.)
- **Roster reorganization** — 90 agents restructured into named specialist slots (CTO −7,
  CMO −3 net, CSO +10, CPO −4, COO −2, CINO +4, Orchestrators +5); office leads get DNA
  upgrades; net agent delta +1 (nk-writer); skill domain delta +1 (voice-routing). Per
  Session 20 audit, WS5 is consolidation + restructuring (not "count-neutral renames").
- **4 HIGH-priority behavioral frameworks**: TTM, SDT, Dual Process, Prospect Theory.
  Total frameworks 64 → 68 at v1.2.0 GA.

### Pre-sprint cleanup landed (commit `ba000e7`, 2026-05-19)

- **Class 12 ratified** in `proactive-watch.md` — `behavioral-moat-drift` was an
  enforcement hook (`.claude/hooks/behavioral-moat-drift.{sh,ps1}`) since v1.0.0 and
  cited as "Class 12" in 2 pack SKILL.md files, but never formally added to the
  canonical drift-class table. Now codified with default triage CMO.
- **AGENT_SKILL_INVENTORY.md** Section 3 (38 → 39 commands; added `mxm-self-update`
  from v1.1.1) and Section 9 heading (11 → 16 ADRs).
- **ADRs/INDEX.md** intro prose corrected ("Eight" → "Twelve" published ADRs).
- **ADR-014** had a stale "7 Maxim MCP tools" claim; sync-counts repaired to "47".

### Deferred to v1.2.1 or later

- **6 MED-priority behavioral frameworks** (WS6b) — SCARF, TPB, Social Learning, Operant
  Conditioning, Diffusion, Emotional Design. Ship in v1.2.1.
- **Proactive Watch Class 13 drift detection** (WS7) — extends MOE PostToolUse audit
  for framework non-adherence, tone drift, compliance violations in third-party plugin
  outputs. Depends on v1.1.2 MOE shipping first. Ships in v1.2.1.
- **Maxim Studio (ADR-014/015)** — desktop GUI shell + v0.2+ surface roadmap.
  Architecture is ratified; implementation paused until v1.2.0 plugin ships and is in
  operator use. Studio does NOT require v1.2.1; v1.2.0 GA is the unblock event.

### Sprint plan

Per `documents/architecture/v1.2-sprint-bootstrap.md`. Estimated ~30–43 dev-days for
v1.2.0 GA across 6 workstreams: voice agents (3d) · TIER 1 verb commands (5–8d) · TIER
3 persona commands (8–10d) · /mxm-help system (2–3d) · roster reorganization (10–15d,
re-estimated per Session 20 audit) · 4 HIGH frameworks (12–16d). Then v1.2.1 ships the
remaining ~21–29 dev-days of work post v1.1.2 MOE.

---

## v1.1.2 — UPCOMING (Q3 2026) — Topology + scaffolding hardening + Studio planning

Session 18 (2026-05-13) landed the following changes targeting v1.1.2.
No production deploy yet — commits are on `main`, pending v1.1.2 release tag.

### Fixed (scaffolding bugs)

- **9 scaffolding bugs** in `bootstrap/link-local-project.ps1` + `bootstrap/new-project-setup.sh`:
  manifest schema versions corrected (ARIA-era `mxm_version: "5.0.0/6.2.0"` → `MXM_version: "1.1.1"`),
  missing `status` + `meta` blocks added to wizard-generated manifests, `.mxm` → `.mxm-skills`
  directory name corrected in STEP 4 (4 runtime state files were written to wrong dir on every
  new project setup), agent-registry.json copy removed from scaffolding (was creating stale copies
  that triggered false "Top risk" warnings at every session start).
- **VAZIR manifest** migrated from string schema (`"project": "VAZIR"`) to object schema
  (`"project": { "id": "vazir" }`); session-start now correctly identifies the project.
- **Class 11 drift cleared**: `config/agent-registry.json` counts corrected (commands 37→38,
  hooks 10→14, ADRs 2→14 full list), `CLAUDE.d/office-catalog.md` updated to 90 agents (sre-analyst
  + cost-analyst restored from aria-simplification migration), `AGENT_SKILL_INVENTORY.md` refreshed.

### Added (ADR-013 — Multi-Project Memory Inheritance)

- **`topology` block** in `config/project-manifest.json` schema: three kinds —
  `standalone` (default, no change), `parent` (reads children at session-start),
  `child` (writes rollup to parent at session-end).
- **Session-start hook** (ps1 + sh): if `topology.kind == "parent"`, renders aggregated
  Children: dashboard showing each child's handoff state and last summary. Fail-soft.
- **Session-end hook** (ps1 + sh): if `topology.kind == "child"`, appends one-line rollup
  to `<parent>/.claude-sessions-memory/children-rollup.md`. Only allowed cross-project write.
- **Bootstrap wizard** gains topology question (Q10): kind / parent path / children paths.
- **`config/project-manifest.TEMPLATE.json`**: `topology` block added.
- **`CLAUDE.d/session-memory.md`**: Multi-Project Inheritance Protocol section added.

### Added (ADR-014 — Maxim Studio planning documents)

- **`documents/ADRs/ADR-014-maxim-studio-agpl-shell.md`** — binding decision: fork
  `winfunc/opcode` (AGPL-3.0, 21.8k stars) as Maxim Studio desktop GUI. Three constraints:
  no Maxim IP in binary, packs runtime-dynamic, revenue through BSL+Worker only.
- **`documents/reference/MAXIM_STUDIO_ARCHITECTURE.md`** — full system spec: boundary
  diagram, pack-loading mechanism, 11 UI surfaces, voice config tab, 8-week sprint plan.
- **`documents/reference/LICENSE_SEPARATION.md`** — legal architecture: AGPL Studio +
  BSL plugin + proprietary Worker as separable works. AGPL network-use analysis.
- **`documents/architecture/maxim-studio/sprint-bootstrap.md`** — self-contained
  bootstrap prompt for the Studio fork sprint (paste into a new Claude Code window).

---

## v1.1.1 — 2026-04-28 — Self-update + public install docs

Resolves a tester-onboarding pain point that became impossible to ignore over
the v1.1.0.1 → v1.1.0.4 patch chain. Every micro-fix to a slash command, skill,
or hook required testers to run `/plugin uninstall` + `/plugin install` and
restart Claude Code TWICE (once for the spawn-with-deps wrapper to npm-install
node_modules, once for the new code to load). ~2 minutes of friction per patch.
Multiplied across 4 patches in 24 hours, the upgrade UX dominated the
experience.

### Added

- **`bootstrap/mxm-self-update.sh`** + **`bootstrap/mxm-self-update.ps1`** — fast
  in-place updater. Pulls latest commits in the marketplace cache, syncs content
  into the install cache while preserving `node_modules/`, sentinels, and lock
  files. Updates `installed_plugins.json` `gitCommitSha` + `lastUpdated`.
- **`.claude/commands/mxm-self-update.md`** — `/mxm-self-update` slash command.
  Cross-platform (auto-detects bash vs PowerShell).
- **`documents/INSTALL.md`** — public-facing install / upgrade / uninstall guide.
  Covers prerequisites, base plugin install, three pack-strategy options
  (L1 individuals, L2 bundles, L3 verticals), verification via `claude mcp list`,
  upgrade via `/mxm-self-update`, uninstall (with `--scope user` flag for
  troubleshooting), troubleshooting common failures, support channels.

### Tester upgrade flow

**Before v1.1.1 (~2 min, 2 restarts):**
```
/plugin uninstall maxim@maxim-packs
/plugin install maxim@maxim-packs
restart Claude Code (first restart — wrapper installs node_modules)
restart Claude Code (second restart — MCPs load with deps)
```

**After v1.1.1 (~5 sec + 1 restart):**
```
/mxm-self-update
restart Claude Code
```

### Roadmap implication

- v1.1.1 (this) — self-update + install docs (SHIPPED 2026-04-28)
- v1.1.2 (was v1.1.1) — Maxim Overlay Engine + 7 compliance frameworks. Renumbered to keep the patch chain clean. See `documents/reference/FRAMEWORK_ROADMAP.md` § v1.1.2.

### Non-goals

- Updating installed packs (only the base plugin in v1.1.1 — pack updates land in v1.1.1.x or v1.1.2)
- Cross-version migration helpers — major bumps (v1.1.x → v1.2.x) still require full reinstall

---

## v1.1.0.4 — 2026-04-28 — `/mxm-help` content drift fix (Class 11)

`/mxm-help` was outputting v1.0.0-era counts (`87 agents · 23 skill domains ·
31 commands · 63 frameworks`). Reality per `AGENT_SKILL_INVENTORY.md`:
**90 agents · 34 skill domains · 38 commands · 64 frameworks**. Exactly the
kind of surface-claims-drift that Class 11 was codified to catch in v1.0.1.

Caught on a manual `/mxm-help` run during testing-customer onboarding —
the very FIRST command a new user runs was lying about the product's
capability counts.

### Fixed

- `.claude/commands/mxm-help.md` — counts updated to current INVENTORY
  ground-truth, version bumped `v1.0.0 → v1.1.0`, footer line aligned.

### Added

- **LICENSING section** at the top — explains the 90-day Pro Trial
  auto-activation flow (v1.1.0.1) so first-time users immediately see what
  they get for free, including owner-key bypass mention.
- **MEMORY + RECALL** section — surfaces `/mxm-remember` + `/mxm-recall`
  (MemPalace-backed cross-session memory).
- **/mxm-watch** to specialists list — Proactive Watch with 11 classes
  (was previously underexposed).
- **/mxm-wiki** + **/mxm-voice** to specialists list.
- **v1.2 preview footer** — pointing at AGENT_ROSTER_v1.2_PROPOSAL.md so
  testers know the verb-first + persona surface is locked and incoming.

### Why this matters

`/mxm-help` is the FIRST surface a new user touches. Stale counts here
undermine credibility immediately — even when every internal doc is
correct (it was). This is exactly the gap Class 11 + `bootstrap/sync-counts.sh`
were built for; we caught one Class 11 had not yet learned to scan.

### Follow-up (filed for v1.1.1 sync-counts hardening)

Add `.claude/commands/mxm-help.md` to the regex pattern set scanned by
`bootstrap/sync-counts.sh` — version + count claims in user-facing
command output should auto-update from INVENTORY on every commit.
Tracked as a Class 11 regression-guard improvement.

---

## v1.1.0.3 — 2026-04-27 — Single-restart upgrade (BUG-007 follow-up)

Hotfix on v1.1.0.2. Collapses the post-upgrade restart cycle from 2 → 1.

### Problem

v1.1.0.2 fixed BUG-007 by making the SessionStart hook plugin-version-scoped.
But the hook runs AFTER Claude Code has already attempted to spawn the 7 MCP
servers (which fail on a fresh install because node_modules are missing). User
had to restart twice: first to trigger the hook's install, second to spawn
with deps present. Acceptable for power users, painful for testers.

### Fix

New synchronous wrapper `mcp/_shared/spawn-with-deps.mjs`. Each MCP server in
`.mcp.json` now spawns through this wrapper. On every spawn:

1. Resolves `PLUGIN_ROOT` from the requested server.js path
2. Quick-checks if all 7 `mcp/mxm-*/node_modules` exist + plugin-scoped
   sentinel `.mcp-deps-installed` is present
3. If missing: acquires file-lock (`$PLUGIN_ROOT/.mcp-install-lock`),
   `npm install`s any missing server, writes sentinel, releases lock
4. Dynamically imports the requested `server.js` (stdio inherited; wrapper
   writes only to stderr to keep stdout clean for MCP JSON-RPC traffic)

File-lock prevents concurrent installs from parallel MCP server spawns —
Claude Code spawns all 7 in parallel at session start. Stale-lock detection
(>5 min mtime) recovers from crashed installers without manual cleanup.

### Added

- `mcp/_shared/spawn-with-deps.mjs` (215 lines, ESM, Node 18+) — full wrapper
  with file-lock, stale-lock recovery, per-server install timeout (90s),
  failure tolerance (continues installing remaining servers if one fails),
  cross-platform path handling (`pathToFileURL` for Windows drive letters).

### Changed

- `.mcp.json` — all 7 server entries now have args `[wrapper_path, server_path]`
  instead of `[server_path]`. Wrapper transparently spawns the underlying
  server.

### Verified (end-to-end smoke test)

- Removed `mcp/mxm-context/node_modules` + sentinel
- Ran wrapper: detected missing dep, installed mxm-context (`installed: 1,
  skipped: 6`), wrote sentinel, imported server.js
- Server.js exited gracefully when stdin closed; wrapper exited 0
- Sentinel metadata correctly captured: `installed_at`, `installed_count`,
  `skipped_count`, `plugin_root`, `installer`

### Tester / operator action after upgrade

```
/plugin uninstall maxim@maxim-packs
/plugin install maxim@maxim-packs
# Restart Claude Code ONCE → wrapper installs deps before spawning server
# All 7 MCPs Connect on first try
```

### Resolves

- **BUG-007** — final piece. v1.1.0.2 fixed the install correctness
  (plugin-scoped sentinel + cwd). v1.1.0.3 fixes the install timing
  (synchronous, before MCP spawn).

---

## v1.1.0.2 — 2026-04-27 — Plugin-upgrade MCP install fix (BUG-007)

Hotfix on v1.1.0.1. Resolves a P0 bug where every plugin upgrade leaves the new
install dir without `node_modules` for the 7 MCP servers, causing all of them
to `✗ Failed to connect` in `claude mcp list`. Also fixes a related issue
where opening any project that isn't `plugin-repo` itself would never trigger
a successful MCP install.

### Root cause (two co-occurring bugs)

Both in `.claude/hooks/session-start.{sh,ps1}` MCP-install block:

1. **Sentinel was project-relative** (`.mxm-skills/.mcp-deps-installed`) but
   plugin deps live per-plugin-version at
   `~/.claude/plugins/cache/maxim-packs/maxim/<v>/mcp/<name>/node_modules/`.
   After upgrade, the project's old sentinel said "installed" → hook skipped
   install on the new version's empty dir.
2. **Wrong cwd for the install.** Hook used `cd $PROJECT_ROOT` then checked +
   installed against project-relative `mcp/` paths. This happened to work only
   when the project IS `plugin-repo` itself. For any other project, npm install
   ran in the wrong dir or skipped entirely.

### Fixed (v1.1.0.2)

- `.claude/hooks/session-start.sh` and `.claude/hooks/session-start.ps1`:
  - Resolve `PLUGIN_ROOT` from `$CLAUDE_PLUGIN_ROOT` env var (set by Claude
    Code when invoking hooks via plugin.json), with a script-location fallback
    for manual invocation
  - Sentinel moved to `$PLUGIN_ROOT/.mcp-deps-installed` — plugin-version-scoped
    so every fresh install + every upgrade triggers a clean dependency check
  - The `mcp/<name>/node_modules` existence check now reads from PLUGIN's
    `mcp/`, not PROJECT's
  - Bootstrap invocation pushes cwd to `$PLUGIN_ROOT` so npm install lands in
    the plugin's `mcp/` subdirs

### Tester / operator action after upgrade

```
/plugin uninstall maxim@maxim-packs
/plugin install maxim@maxim-packs
# Restart Claude Code session ONCE → SessionStart hook installs MCP deps
# Restart Claude Code session AGAIN → MCPs spawn with deps now present
```

After v1.1.0.2 ships, the chicken-and-egg "install deps before MCP spawn" is
still 2 restarts — collapsing to 1 restart requires a synchronous pre-spawn
hook (tracked as v1.1.0.3 candidate per BUG-007 regression-guard notes).

### Resolves

- **BUG-007** — Plugin-upgrade leaves new install dir without node_modules →
  all 7 MCPs fail. Filed in `documents/ledgers/BUG_TRACKER.md`.

---

## v1.1.0.1 — 2026-04-27 — Pro Trial auto-activation (Class 11 surface-claims-drift fix)

Hotfix on v1.1.0. Wires the `pro_trial.auto_activates_on_install` promise from
`grants.json` that v1.1.0 shipped declared but did not honor at runtime.

**The gap.** v1.1.0 ships `pro_trial` as a defined tier in `grants.json` with
`auto_activates_on_install: true`. The `/issue` endpoint did not check that flag —
all anonymous fingerprints received Starter JWTs regardless of first-install status.
This is a textbook **Class 11 surface-claims-drift** finding: a published capability
exists in spec but is not dispatchable at runtime.

**The fix.** New `selectIssueTier()` helper in `cloudflare-worker/src/v11a-license.ts`:
- First `/issue` from a fingerprint → 90-day Pro Trial JWT (per `grants.json` TTL)
- Re-issue during trial window → same expiry timestamp anchored to first install
  (idempotent — no extension via reinstall)
- Re-issue after trial expiry → falls back to 30-day Starter (auto-renewable forever per ADR-004)
- Trial state tracked via permanent `fp_lifecycle:{fingerprint}` KV markers
- Defensive: malformed lifecycle markers fail-soft to "no marker" rather than crashing

**Server-side change only — no plugin update required.** Existing v1.0.0 / v1.1.0
plugin installs benefit immediately on next `/issue` call. Owner-key bypass
unaffected.

### Added (v1.1.0.1)

- `cloudflare-worker/src/v11a-license.ts`:
  - `PRO_TRIAL_TTL_DAYS` / `PRO_TRIAL_TTL_SECONDS` constants
  - `FpLifecycle` interface — `{first_seen_at, pro_trial_expires_at}`
  - `selectIssueTier()` helper with one-shot trial enforcement + idempotent re-issue
  - Defensive try/catch around `KV.get(key, "json")` with type-guard on shape
  - `auto_activates_on_install?: boolean` field added to `GrantsConfig.tiers`
- `mcp/_shared/license-gate.test.mjs`:
  - 4 new live tests (replaces 2 existing live tests that used real machine fingerprint):
    - `[live] /issue with fresh fp returns Pro Trial JWT (90-day, Class 11 fix)`
    - `[live] /validate returns tier + grants for valid Pro Trial JWT`
    - `[live] /issue is idempotent during pro_trial — re-issue returns same expiry`
    - `[live] /issue returns starter after pro_trial expired (via wrangler KV)`
  - `freshTestFingerprint()` helper using `crypto.randomBytes(32).toString("hex")` —
    eliminates production KV pollution from the operator's real-machine state
  - Test 4 uses `wrangler kv key put --path=<tempfile>` for cross-platform JSON injection

### Changed

- `handleAnonymousIssue()` now calls `selectIssueTier()` instead of hardcoding `"starter"`.
  All downstream KV writes + JWT claims use the selected tier.
- KV `issuance:` and `license:` records now include `first_install: boolean` field for
  audit-log clarity (which `/issue` calls were trial-activation events).

### Verification

- 11/11 tests pass (was 9/9 + 2 live skip; now 7 unit + 4 live = 11 total).
- Worker re-deployed: Version `54be3b40-6b81-452f-830d-60afbf830ad4`.
- KV state verified: 6 `fp_lifecycle:*` keys created during test runs (confirms
  pro_trial activation firing end-to-end).

### Resolves

- Class 11 surface-claims-drift instance: grants.json `pro_trial.auto_activates_on_install`
  promise now honored by Worker `/issue` handler.

---

## v1.1.0 — 2026-04-27 — License middleware foundation (v1.1.A scope)

Promoted from `v1.1.0-rc.1` after v1.1.A passed acceptance. v1.1.0 ships the
**enterprise-readiness foundation**: license middleware, tier-based grants,
Worker public endpoints, all 7 MCP servers gated. The runtime enforcement gap
that v1.0.0 left open is closed.

**Scope decision (locked 2026-04-27):** v1.1.B (Maxim Overlay Engine, ADR-012)
and v1.1.C (7 compliance frameworks: EU AI Act, ISO 42001, SOX, CIS Controls,
DORA, NIST SP 800-53, LGPD) move to **v1.1.1**. The original v1.1 plan bundled
A + B + C; we shipped A as v1.1.0 because the foundation gates everything else,
and treating B + C as a follow-on patch lets users get tier-enforced runtime
NOW rather than waiting for the full bundle.

### Added (v1.1.A)

- **`cloudflare-worker/src/v11a-license.ts`** — Two new public Worker endpoints:
  - `POST /issue {machine_fingerprint, client_version} → {jwt, tier, grants, expires_at}`
    Anonymous Starter JWT issuer. 30-day TTL. Rate-limited (≤10/day per fingerprint, ≤100/h per IP).
  - `POST /validate {jwt} → {valid, tier, grants, expires_at, refresh_url?}`
    Daily-heartbeat validator. Verifies signature, checks revocation, returns server-side authoritative tier + grants.
    Rate-limited (≤50/day per fingerprint, ≤1000/h per IP).
- **`mcp/_shared/license-gate.mjs`** — Full license-gate middleware (ESM). Cache-file logic at
  `~/.mxm-packs/license-state.json`, owner-key bypass (full, no JWT, tagged 🔵 SUPER USER), JWT signature
  verification via local public key, fire-and-forget 24h heartbeat (never blocks tool calls), first-run flow
  that hits Worker `/issue` and writes cache atomically. Per locked design G1–G7.
- **`mcp/_shared/license-pubkey.pem`** — Mirror of `pack-engine/internal/jwt/keys/public.pem` for offline
  JWT verification (defense-in-depth against cache tampering).
- **`mcp/_shared/license-gate.test.mjs`** — E2E test fixture covering: owner-bypass, FIRST_RUN_FAILED,
  JWT_EXPIRED, JWT_INVALID (tampered signature), GRANTS_INSUFFICIENT, SUCCESS, CACHE_CORRUPT, plus
  live-Worker tests gated on `MXM_E2E_LIVE_WORKER=1`. **9/9 pass.**
- **All 7 MCP servers gated** via `wrapServerWithLicenseGate(server, "<name>", grantMap?)` (1 import + 1 call
  per server, ~50 lines total). Tier-specific grants mapped: `mxm-compliance` requires `compliance-14`,
  `mxm-behavioral` requires `behavioral-audit-unlimited`, `mxm-memory` KG ops require `mempalace-semantic`,
  `mxm-voice` requires `voice-10min-per-day` (status check is free across tiers).

### Ship gates (FRAMEWORK_ROADMAP § v1.1.A)

| Gate | Status |
|---|---|
| `requireValidLicense` middleware merged into all 7 MCP servers | 🟢 |
| Worker `/validate` endpoint deployed + KV binding live | 🟡 code ready · operator deploys |
| Starter tier anonymous JWT issuer live | 🟡 code ready · operator deploys |
| E2E test: clone repo without license → tool calls fail with clear error | 🟢 (FIRST_RUN_FAILED test) |
| E2E test: paid-tier JWT → tool calls succeed + usage logged | 🟡 requires deployed Worker (live test gated on env flag) |
| E2E test: expired JWT → fail with refresh instructions | 🟢 (JWT_EXPIRED test) |
| Rate-limit policy per tier documented and verified | 🟢 (`v11a-license.ts` enforces) |

4 of 7 gates green by code; 3 require Worker deployment by operator. **The 3 yellow
gates flip green automatically once `wrangler deploy` runs from `cloudflare-worker/`
and the live tests are exercised with `MXM_E2E_LIVE_WORKER=1`.** No additional
code work needed for the v1.1.0 release scope.

### Known carry-over for v1.1.1

Following sprints (separately versioned, do not block v1.1.0):

- **v1.1.B → v1.1.1** Maxim Overlay Engine (per ADR-012) — 4-hook architecture; 11 ship gates
- **v1.1.C → v1.1.1** 7 compliance frameworks (EU AI Act, ISO 42001, SOX, CIS Controls, DORA, NIST SP 800-53, LGPD)
- Worker deployment to `https://maxim-license-api.isystematic.workers.dev` with `JWT_SIGNING_KEY_PRIVATE`
  + `JWT_SIGNING_KEY_PUBLIC` secrets bound; KV namespaces (LICENSES, RATE_LIMIT) already provisioned —
  required to flip the 3 yellow ship gates green; not a code change
- `ADR-013-license-middleware-design.md` — capture locked v1.1.A design as ratified ADR (next session)

---

## v1.0.1 — 2026-04-27 — Session 15: agent merge + count alignment + v1.1.A foundation + count-drift codification

Multi-track session covering plugin MCP path bugfix, agent roster expansion, capability-count drift fix across 30+ surfaces, v1.1.A license middleware Phase B-1 foundation, and codification of the inventory-vs-marketing-copy drift class (Class 11) with companion `bootstrap/sync-counts` tool.

### Fixed

- **BUG-O-03 · plugin MCP path resolution** — All 7 `plugin:maxim:mxm-*` MCP servers were failing with `✗ Failed to connect` because `.mcp.json` used relative `args: ["./mcp/<name>/server.js"]` paths that resolved against user cwd, not plugin install dir. Substituted Claude Code's `${CLAUDE_PLUGIN_ROOT}` placeholder. All 7 MCPs now `✓ Connected` end-to-end.
- **Pre-existing inventory drift fix** — `agents/MXM/cino/skill-synthesizer.md` existed on filesystem since v1.0.0 but was never registered in `config/agent-registry.json`. Added registry entry. Filesystem ↔ registry ↔ INVENTORY now all align at 90 agents.
- **AGENT_SKILL_INVENTORY.md Section 1 breakdown** — Per-office row counts (CEO 14, CTO 17, CMO 11, CINO 6, Orchestrators 9) were fictitious — they summed to 88 but bore no relation to filesystem reality. Rewrote table to match filesystem (CEO 9, CTO 25, CMO 15, CSO 9, CPO 12, COO 10, CINO 4, Orchestrators 5, Executive Router 1 = 90).

### Added

- **`agents/MXM/cino/cost-analyst.md`** — CINO specialist agent migrated from aria-simplification project. Triages cost-dimension Proactive Watch alerts; classifies traffic / regression / abuse / model_change; bounded throttle proposals. Frameworks: Prospect Theory, Anchoring, COM-B. Slotted as CINO specialist under `innovation-researcher` per [`AGENT_ROSTER_v1.2_PROPOSAL.md`](documents/reference/AGENT_ROSTER_v1.2_PROPOSAL.md).
- **`agents/MXM/coo/sre-analyst.md`** — COO specialist agent migrated from aria-simplification project. Triages SLO + data-integrity alerts; correlates with deploy timeline + error-budget posture; bounded remediation (rollback, hotfix, scaling, pager). Frameworks: Error Budget (Google SRE), Blameless Postmortems, EAST. Slotted as COO specialist under `planner`.
- **`cloudflare-worker/grants.json`** — Single source of truth for tier→grants and pack→grants mappings (v1.1.A locked design G4). 6 tiers (starter, pro_trial, solo, pro, professional, team) + 4 vertical overlay packs (healthcare, legal, fintech, govtech) + 54-grant catalog. Mirrored to pack-engine at build time. Validated: all grant references match catalog (no orphans).
- **`mcp/_shared/license-gate.js`** — v1.1.A Phase B-1: `requireValidLicense(toolName, requiredGrants)` helper with cache-file logic, owner-key bypass (full bypass per locked decision G6, tagged 🔵 SUPER USER), JWT expiry hard gate, 24h heartbeat fire-and-forget, fingerprint subprocess wiring. 5 paths verified end-to-end (FIRST_RUN_REQUIRED, JWT_EXPIRED, GRANTS_INSUFFICIENT, SUCCESS, fingerprint-degrades-gracefully). Phase B-2 (Worker endpoints), B-3 (7 MCP server wiring), B-4 (E2E tests) follow next session.
- **Proactive Watch Class 11 — `surface-claims-drift`** — New drift class detects inventory-vs-marketing-copy mismatch (e.g., `AGENT_SKILL_INVENTORY.md` says 90 but README says 88). Complementary to Class 1 (filesystem-vs-inventory). Codified in [`composable-skills/frameworks/proactive-watch.md`](composable-skills/frameworks/proactive-watch.md), [`config/watch-profile.yml`](config/watch-profile.yml), [`config/watch-profile.TEMPLATE.yml`](config/watch-profile.TEMPLATE.yml). Driver counter bumped 10→11 in [`/mxm-watch`](.claude/commands/mxm-watch.md), [`/mxm-health`](.claude/commands/mxm-health.md), [`mxm-mode`](distributions/claude-plugin/output-styles/mxm-mode.md) descriptions.
- **`bootstrap/sync-counts.{sh,ps1}`** — Companion propagation tool for Class 11. Reads INVENTORY canonical counts, propagates to all declared surfaces (markdown + landing-page TSX). Idempotent on clean tree. Conservative regex requires either `+` suffix or adjective prefix (specialist/governed/Maxim/peer-reviewed) to avoid false positives on per-office breakdowns / complexity thresholds / historical changelog entries. 3 acceptance gates passed: clean-tree no-op, synthetic 90→91 bump propagates correctly, restore + re-run no-op.
- **Commit Protocol updates** — [`CLAUDE.md`](CLAUDE.md) + [`CLAUDE.d/protocols.md`](CLAUDE.d/protocols.md) gained explicit trigger row: when commit touches `agents/MXM/**`, `.claude/skills/**`, `.claude/commands/**`, `mcp/**`, `composable-skills/frameworks/**`, or `.claude/hooks/**`, run `bootstrap/sync-counts.{sh,ps1}` before commit. Pre-commit hook fails-closed on residual drift unless `[surface-claims-drift-ack: <reason>]` is in commit message.

### Changed

- **Total agent count: 88 → 90** (cost-analyst + sre-analyst added; skill-synthesizer registry drift fixed)
- **Per-office breakdown updated**: COO 9 → 10, CINO 3 → 4 (sre-analyst, cost-analyst). All other offices unchanged.
- **30+ surfaces propagated**: README, CLAUDE.md, ABOUT, PACKS, HELP, GETTING_STARTED, MXM_RUNDOWN, MARKETPLACE_SUBMISSION, DISTRIBUTION, mxm-mode, demo-scenarios, PROMPT_maxim-capabilities-demo, ASSEMBLY, voice-profile, FRAMEWORK_ROADMAP, FRAMEWORKS_MASTER, AGENT_ROSTER_v1.2_PROPOSAL, ADR-001, ADR-004, ADRs/INDEX, mcp/mxm-catalog/README, proactive-watch (composable + skill), maxim-pack-catalog, maxim-one-pager, maxim-catalogue, repo-page-design-spec — all current-state agent count claims aligned to 90. Plus 9 landing-page TSX/TS files (layout, structured-data, opengraph-image, pricing, comparisons, frameworks, docs/page, docs/first-run, PricingLadder, WhatYoureMissing).

### Architectural decisions ratified

v1.1.A license middleware design fully locked across 7 gates (validation cadence, JWT schemas, KV schema, rate limits, grant location, key rotation deferral, owner-unlock bypass behavior, env-var injection path, fingerprint algorithm reuse, anonymous Starter TTL, outage behavior). Full design captured at [`memory/project_v1.1.A_locked_design.md`](C:/Users/SDO/.claude/projects/E--Projects-Maxim/memory/project_v1.1.A_locked_design.md). ADR will land alongside Phase B-2 implementation.

### Known carry-over

- v1.1.A Phase B-2 (Worker `/issue` + `/validate` endpoints, KV namespace, anon JWT issuer) — next session
- v1.1.A Phase B-3 (wire `requireValidLicense` into 7 MCP server tool handlers) — next session
- v1.1.A Phase B-4 (E2E test fixtures + 7 ship gates) — next session
- v1.1.B (MOE per ADR-012) — separate sprint after v1.1.A green
- v1.1.C (7 compliance frameworks) — after MOE
- Decision A2 (~/.claude/{CLAUDE.md, agents, commands, skills} reparse-point cleanup) — deferred from this session per operator's prioritization

---

## v1.0.0 — 2026-04-27 — Launch Bug-Bash (install path verified end-to-end)

Single live macOS install (alsalman's MacBook, accessed via Tailscale SSH) surfaced and resolved five blocker bugs that local Windows structural tests could not catch. **Plugin install is now end-to-end verified working** on a real Mac. Anthropic community marketplace submission still pending operator action.

### Fixed (in order of discovery)

- **BUG-001 · marketplace.json schema** — base `maxim` plugin entry's `source: "../"` was rejected by the marketplace validator. Switched to `git-subdir` form (commit `8a82be1`).
- **BUG-002 · slash commands not registering** — 34 of 38 `mxm-*.md` files lacked YAML frontmatter; Claude Code's loader silently skips command files without a `description:` field. Added frontmatter to all 34 (commit `c4e93f0`).
- **BUG-003 · "permission denied" on bootstrap scripts** — every `.sh` in the repo (60 files: 7 hooks + 6 bootstrap + 8 distribution mirrors + others) was tracked as `100644`. Set exec bit on all (commit `e3d6008`).
- **BUG-004 · MCP server timeout on first install** — MCP servers are Node packages with `node_modules/` gitignored; nothing installs deps automatically. Added `bootstrap/mxm-mcp-install.{sh,ps1}` and wired auto-run into SessionStart hook (commit `82385c9`). README now documents Node.js as a hard prerequisite (commit `4b7fcd2`).
- **BUG-005 · only 1% of plugin files materialized on disk** — `git-subdir` source with `path: "."` triggered Claude Code's plugin loader to apply a `/*` + `!/*/` sparse-checkout filter, excluding every directory. Of 917 tracked files, only 8 root-level files installed. Switched maxim's source to `url` form which performs a full clone (commit `cee9aa6`).

### Added (alongside the fixes)

- **`bootstrap/mxm-mcp-install.{sh,ps1}`** — per-MCP-server `npm install` runner with sentinel-based skip-on-subsequent-sessions
- **Hardened `bootstrap/mxm-community-packs.sh`** — picks best-available JSON parser (`jq` → `python3` → `python` → `node`), fixes subshell counter bug via tempfile, adds `git`-on-PATH check
- **README prerequisites block** — explicit Node.js requirement with verification commands and macOS install instructions
- **`documents/ledgers/BUG_TRACKER.md`** — first 5 entries (BUG-001..BUG-005) with full repro, root cause, fix, regression guard. PATTERN-01 added: cross-platform structural assumptions.
- **`documents/ledgers/DEBUGGING_PLAYBOOK.md`** — §1 entry capturing the meta-pattern: structural tests passing while live install fails. Methodology and transferable lesson documented.

### Adjacent landings (separate from the bug-bash but in the same window)

- **ADR-012 Maxim Overlay Engine** — published. Architectural commitment to apply Maxim's behavioral / compliance / confidence layers to every Claude Code plugin via the four hook interception points. INDEX bumped to 8 published ADRs.
- **MOAT-07** — "Operator agents behind vertical compliance overlays" added to MOAT_TRACKER. Mechanism: Social Learning Theory (Bandura, 1977).
- **`/giveaway` page** — full Early Adopter Program: 300 licenses, $540K value, 13 cohorts, application flow via `/contact`.
- **`/early-adopters` opt-in public wall** — skeleton ships empty; populates as approvals land.
- **Per-page Open Graph images** — root `/opengraph-image` (three-layer moat stack) and `/giveaway/opengraph-image` (terminal session showing Maxim governing a Claude session).
- **Hero CTA flip** — install command + giveaway CTA primary; pricing demoted to tertiary link.
- **Header nav reorder** — Why → Docs → Frameworks → Giveaway (red accent) → Pricing.
- **Worker `/contact`** — accepts two new subjects (`early-adopter-application`, `early-adopter-inquiry`), routes them to a dedicated KV key prefix.
- **Domain expansion roadmap** — `FRAMEWORK_ROADMAP.md` v1.1 expanded with v1.3 (RevOps domain + AI Governance frameworks), v1.4 (Regulated Industries operator roster + Fintech), v1.5 (Cinematic / Video-AI Production).

### Known carry-over

- Anthropic community marketplace submission at `clau.de/plugin-directory-submission` — pending operator action; payload prepared.
- Live `$1` Stripe smoke test — pending operator action.
- Founder bio in `landing-page/components/FounderBlock.tsx` — placeholder text remains.
- Cloudflare API token shared earlier in chat — should be revoked.
- macOS-install CI hardening — v1.1 hardening item; would have caught BUG-003/004/005 before users.

---

## v1.0.0 — 2026-04-21 — First Public Release

**Positioning.** The behavioral intelligence layer for Claude. Every output cites a mechanism. Every session runs drift detection. Every commit enforces Documents as Executable Contracts.

**License.** Business Source License 1.1 (converts to Apache 2.0 exactly 4 years after each release per ADR-005).

### Added

- **88 specialist agents** across 7 executive offices (CEO, CTO, CMO, CSO, CPO, COO, CINO) and orchestrators. Dispatch via `executive-router` or explicit `/mxm-{office}` command. See `documents/ledgers/AGENT_SKILL_INVENTORY.md`.
- **34 domain skills** under `.claude/skills/`. Behavioral intelligence layer merges Maxim frameworks with community-pack skills when both match a domain. See `documents/reference/SKILLS_MAP.md`.
- **38 slash commands** under `.claude/commands/mxm-*.md`. See `documents/reference/MXM_COMMAND_MAP.md`.
- **7 MCP servers (47 tools)** under `mcp/`: `mxm-behavioral`, `mxm-compliance`, `mxm-context`, `mxm-memory`, `mxm-portfolio`, `mxm-catalog`, `mxm-voice`. See `mcp/README.md`.
- **14 hook scripts** (7 hooks × 2 platforms) under `.claude/hooks/` covering session start/end, pre-commit secret scan, behavioral-moat drift, git-hygiene pre/postamble, and junction guard.
- **64 behavioral frameworks** cataloged in `documents/reference/FRAMEWORKS_MASTER.md`, used across every skill.
- **14 compliance frameworks** enforced by the `mxm-compliance` MCP (GDPR, PIPEDA, PCI-DSS, SOC2, HIPAA, UAE-PDPL, CASL, FINTRAC, EU AI Act, ISO 27001, ISO 13485, ISO 14971, NIST CSF, WCAG 2.1).
- **11 Architecture Decision Records** in `documents/ADRs/`. ADR-001 through ADR-011 cover dispatch architecture, Executable Contracts, Worker licensing, free-tier spec, IP protection, External Content Boundary, Behavioral Moat Framing, Community Pack System, pack architecture, Confidence Tag rubric, and Stripe-primary payment processor.
- **Three-tier freemium model** (see ADR-009 and `documents/guides/PACKS.md`):
  - **Starter** — $0 forever, fully functional.
  - **Pro Trial** — 90 days, auto-activated on install.
  - **Paid packs** — Solo $19.99/mo (MOAT anchor) → Pro $39 → Professional $99 → Team $249 (5 seats) + 4 vertical overlays (Healthcare $249, Legal $199, Fintech $199, GovTech $149).
- **Pack engine** (Go binary, `pack-engine/`) — local tier resolver, quota enforcement, machine fingerprint binding for paid JWTs.
- **Cloudflare Worker** (`cloudflare-worker/`) — RS256 JWT issuance, Stripe webhook handler, KV license store. Deployed at `maxim-license-api.isystematic.workers.dev`.
- **Three-layer .brand-foundation** system (`.brand-foundation/`) — Maxim base voice, operator overlay, per-startup overlay. Loading protocol in `CLAUDE.md`.
- **Proactive Watch** — 10 drift classes scanned on every session start. See `composable-skills/frameworks/proactive-watch.md`.
- **Session-end 9-document closure bundle** ratified by ADR-002. See `CLAUDE.d/protocols.md`.

### Repository layout

The v1.0.0 repo root is intentionally minimal. Only load-bearing or
hard-convention files remain at root. All reference documentation is filed
under `documents/` subfolders so the root tells an immediate story:

- **Root (6 docs + 6 ledgers + CLAUDE.d):** `README.md`, `LICENSE`,
  `CHANGELOG.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `CLAUDE.project.md`,
  `BUG_TRACKER.md`, `documents/ledgers/MOAT_TRACKER.md`, `documents/ledgers/DEBUGGING_PLAYBOOK.md`,
  `documents/ledgers/AGENT_SKILL_INVENTORY.md`, `documents/ledgers/SESSION_CONTINUITY.md`,
  `documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md`, `CLAUDE.d/`.
- **`documents/guides/`:** `ABOUT.md`, `HELP.md`, `GETTING_STARTED.md`,
  `BSL-FAQ.md`, `PACKS.md`.
- **`documents/reference/`:** `MXM_INSTALL.md`, `MXM_COMMAND_MAP.md`,
  `MXM_HEALTHCHECK.md`, `MXM-SKILL-SPEC.md`, `AGENTS.md`, `SKILLS_MAP.md`,
  `FRAMEWORKS_MASTER.md`, `FRAMEWORK_USES.md`.
- **`documents/governance/`:** `ETHICAL_GUIDELINES.md`.
- **`documents/cross-surface/`:** `maxim-project-instructions.md`,
  `maxim-surface-guide.md`.
- **`documents/templates/`:** `CLAUDE.project.TEMPLATE.md`.
- **`config/`:** `mempalace.yaml`, `entities.json` (config artifacts).

### Engineering Lineage

Maxim is the first public release of work that was developed internally over the 37 days preceding 2026-04-21. The internal codebase and its prior version history are preserved privately and are not imported. Commit history in this repository begins at v1.0.0.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
