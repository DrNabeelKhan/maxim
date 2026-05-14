# ADR-015 — Maxim Studio v0.2+ Surface Roadmap

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-14
- **Deciders:** DrNabeelKhan
- **Related:** ADR-014 (Maxim Studio AGPL shell + 15 v0.1 surfaces)

---

## Context

ADR-014 ratifies 15 UI surfaces for Maxim Studio v0.1.0 (11 original + 4 TIER 1
additions from the post-design audit). The v0.1.0 sprint is 8 weeks, ~24.5 dev-days,
and ships the core capability-coverage layer: Executive Dispatch, Agent Roster,
Framework Library, Pack Catalog, License Bar with Worker Diagnostic, Proactive Watch,
MOAT Tracker, MemPalace, Confidence Tags, Voice Config, Studio cinematic, Mission
Control, Command Launcher, Compliance Posture, and MCP Health.

The capability-coverage audit (2026-05-14) identified an additional 22 surfaces
spanning Maxim's full feature inventory. Shipping all 37 surfaces in v0.1.0 would
push the sprint to 16+ weeks and dilute the v0.1.0 acquisition story. This ADR
formalizes the deferred surfaces as a tiered v0.2+ roadmap so engineering can
defer them with intent rather than discover them by accident in v0.1 reviews.

The driving question this ADR answers: **what surfaces does Maxim Studio ship
in v0.2.0, v0.3.0, and v0.4.0+, and on what schedule?**

---

## Decision

Defer 22 surfaces across three tiered post-v0.1.0 releases. Each tier corresponds
to a release with a coherent theme and a target dev-day budget. Surfaces within a
tier may ship in any order during the release sprint.

### TIER 2 — v0.2.0 "Full Maxim Surface" (~Q4 2026, ~15–20 dev-days)

Theme: surface every Maxim capability Studio doesn't show in v0.1. Every Maxim
artifact gets a viewer; every ledger gets a panel. After v0.2 Studio is the
complete visual representation of a Maxim project.

| Surface | Data source | What it shows |
|---|---|---|
| **Multi-Project Topology View** | `topology` block in manifest (ADR-013) | Parent → children tree; each child's last handoff status + summary; drill-into-child opens that project |
| **Session History Timeline** | `.claude-sessions-memory/session-YYYY-MM-DD.md` | Daily cards: date, agents used, files changed, decisions made, confidence-tag breakdown |
| **Skill Gap Tracker** | `.mxm-skills/agents-skill-gaps.log` | Tasks Maxim could not route, frequency counts, suggested skill names |
| **Review Queue** | `.mxm-skills/review-queue.md` | PENDING items awaiting human triage; approve/reject inline |
| **ADR Ledger Viewer** | `documents/ADRs/*.md` + INDEX | All ratified ADRs with status badges; PROPOSED → ACCEPTED → SUPERSEDED lifecycle visible |
| **Bug Tracker** | `BUG_TRACKER.md` + Recurring Pattern Registry | Open / Resolved / WontFix; severity counts; pattern frequency |
| **Changelog / What's New** | `CHANGELOG.md` | Release notes for the just-installed version, highlighted; older releases collapsible |
| **Portfolio Dashboard** | `mxm-portfolio.sync_portfolio()` MCP | All projects under MXM_PROJECTS_ROOT with lifecycle, gated flag, last activity, staleness warnings |
| **CEO Automation Panel** | `/mxm-ceo-morning` + `/mxm-ceo-overnight` config + queue | Next-fire times for scheduled tasks; preview of next morning brief; pause/resume |

**Sprint estimate:** ~15–20 dev-days. Parallel-safe: most surfaces are read-only
viewers, can be split among contributors.

### TIER 3 — v0.3.0 "Configuration + Power User" (~Q1 2027, ~10–14 dev-days)

Theme: editors for every Maxim config file. After v0.3 power users never need to
hand-edit JSON or YAML; everything has a guided UI with validation.

| Surface | Data source | What it shows |
|---|---|---|
| **Hotword Phrase Editor** | `config/voice-phrases.yml` | Add/remove voice triggers; pattern + dispatch pair; test-trigger button |
| **Scheduler Config** | `config/scheduler-thresholds.json` | 5h pause %, 7d pause %, Opus 7d %, min sleep, API retry — sliders for the four thresholds |
| **Watch Profile Editor** | `config/watch-profile.yml` | Per-class enable/disable; polling intervals; sync-counts surface list |
| **Operator Profile Editor** | `.mxm-operator-profile/{OPERATOR,preferences,rejected-patterns,communication-style}.md` | Guided editor; identity, expertise, working style, rejected patterns |
| **Brand Foundation Viewer** | `.brand-foundation/{personal,personal.local,startups/*}/` | 3-layer voice stack: Maxim base + operator overlay + per-startup; active layer indicator per project |
| **Topology Configurator** | `topology` block in manifest (ADR-013) | Switch project between standalone/parent/child without editing JSON; folder picker for children paths |
| **Custom Marketplaces** | `~/.claude/plugins/known_marketplaces.json` | Add additional plugin marketplace URLs beyond DrNabeelKhan/maxim |

**Sprint estimate:** ~10–14 dev-days. Each editor needs validation logic +
file-write Tauri command + reload trigger.

### TIER 4 — v0.4+ "Analytics + Observability" (~Q2 2027+, ~12–18 dev-days)

Theme: surface what Maxim is actually *doing* over time, not just current state.
After v0.4 Studio provides the operator-grade observability that compliance
auditors and enterprise buyers expect.

| Surface | Data source | What it shows |
|---|---|---|
| **Confidence Tag Analytics** | Per-output confidence tags + session memory | % 🟢 / 🟡 / 🔴 over time; trend per agent / per office; flag agents with high 🟡 rates |
| **MCP Tool Invocation Log** | `.mxm-skills/mcp-invocations.log` (new file from license-gate.mjs) | Live tail of tool calls with arg signatures + return previews; filter by server / tool / time |
| **DEBUGGING_PLAYBOOK Viewer** | `documents/ledgers/DEBUGGING_PLAYBOOK.md` | Searchable journal of resolved failure patterns; "I'm seeing X" lookup |
| **Community Pack Browser** | `community-packs/*/` filesystem scan | What upstream packs are installed: VoltAgent 150 specialists, Higgsfield 40 cinematic, alirezarezvani 536 skills, etc.; adoption depth metrics |
| **Cross-Surface Deployment Status** | `packaging/cowork/` + `documents/cross-surface/` | Tier 1 (Cowork) / Tier 2 (CLAUDE.project.md) / Tier 3 (Web Projects) deployment status per project |
| **Design Template Browser** | `community-packs/awesome-design-md/` | 59 brand `DESIGN.md` templates; preview + apply to current project |

**Sprint estimate:** ~12–18 dev-days. Analytics surfaces require data-collection
infrastructure first; MCP Tool Invocation Log requires the license-gate.mjs to
emit structured logs.

---

## Rationale

**Why three tiers, not one big v0.2?**

A single 50-day v0.2 sprint would be 10+ weeks — long enough that the v0.1 launch
loses momentum before v0.2 reaches users. The three-tier split:
- **v0.2 ships Q4 2026** (within 3 months of v0.1 launch)
- **v0.3 ships Q1 2027** (within 6 months)
- **v0.4 ships Q2+ 2027** (analytics requires real usage data to be meaningful)

This matches the Maxim plugin's own release cadence (v1.0 Apr → v1.1.0 Apr → v1.1.1
Apr → v1.1.2 upcoming) and keeps Studio shipping continuously rather than in
discrete annual releases.

**Why these tier boundaries (Surface coverage → Editors → Analytics)?**

The tier boundaries follow buyer psychology:
- **v0.2 (Surface coverage)** answers "does Studio show me everything Maxim does?"
  This is the credibility tier. Buyers evaluating Maxim look for hidden capabilities;
  v0.2 surfaces them all.
- **v0.3 (Editors)** answers "can I configure Maxim without reading docs?"
  This is the retention tier. Power users churn when they have to hand-edit YAML.
- **v0.4 (Analytics)** answers "is Maxim actually working for me?"
  This is the expansion tier. Analytics drives upgrades from L1 → L2 → L3 packs.

**Why these surfaces, not others?**

Every surface listed maps to an existing Maxim capability (ledger, config file,
MCP tool, or agent surface). No speculative surfaces. The full inventory came
from the 2026-05-14 capability-coverage audit; surfaces with no underlying
capability were rejected.

---

## Consequences

**Easier:**
- v0.1 sprint stays at 8 weeks / ~24.5 dev-days; doesn't bloat
- Engineering has a deferred backlog rather than discovering surfaces ad-hoc
- Marketing has a clear "what's coming" story for v0.2, v0.3, v0.4
- v0.2 surfaces (especially Multi-Project Topology View, ADR Ledger) are
  high-value to enterprise buyers; deferring them to v0.2 means v0.2 has a
  strong commercial story rather than being a maintenance release

**Harder:**
- Each tier needs its own sprint plan ADR addendum or release ADR
- TIER 4 analytics require data-collection infrastructure (mcp-invocations.log,
  confidence-tag aggregation) that doesn't exist yet — v0.4 sprint has to build
  the data layer first
- The 22 deferred surfaces accumulate; reviewers must check this ADR before
  proposing a "small" addition to v0.1

**Locks us into:**
- The tier-and-release structure. Adding a v0.1.x surface mid-cycle requires
  amending ADR-014 + this ADR.
- The named release themes (Surface coverage / Editors / Analytics). Themes can
  shift but renaming a release requires an ADR amendment.
- Q4 2026 / Q1 2027 / Q2 2027 timing. Slippage requires CHANGELOG SKIPPED entries
  per the v1.0.0+ skipped-version protocol.

---

## Alternatives Considered

**Alternative 1 — Ship all 37 surfaces in v0.1.0**

Single fat release covering everything Maxim does.

Rejected because: pushes v0.1 to ~16 weeks (vs 8), dilutes acquisition story
("here are 37 features" lands weaker than "here are the 15 you'll use daily"),
and increases test surface area beyond what one v0.1.0 QA pass can validate.
The 4-week extension would also push v0.1 past the v1.1.2 plugin release window,
breaking the parallel-track distribution model.

**Alternative 2 — Ship v0.2 as a single 50-day release**

One v0.2 covering TIER 2 + TIER 3 + TIER 4.

Rejected because: 50-day sprint = 10+ weeks. Maxim plugin ships patch releases
every 1–2 weeks. A 10-week Studio release means Studio falls behind plugin
versions by 5+ patches. The split-bundle update model handles small plugin updates
without Studio releases, but Studio itself needs to ship more often than every
10 weeks to stay credible.

**Alternative 3 — Two tiers (v0.2 + v0.3) instead of three**

Combine TIER 3 (Editors) and TIER 4 (Analytics) into v0.3.

Rejected because: TIER 4 analytics requires data-collection infrastructure
(mcp-invocations.log, confidence-tag aggregation) that needs months of real usage
to produce meaningful data. Shipping analytics in v0.3 means shipping empty
charts. TIER 3 editors are valuable immediately; TIER 4 analytics are valuable
only after the data is there. Separating them lets v0.3 ship usable editors in
Q1 2027 while v0.4 waits for data to mature.

**Alternative 4 — Ship the audit gaps but defer the priority decision**

Add all 22 surfaces to the v0.1 backlog without tier assignment; let engineering
pick what fits.

Rejected because: "engineering picks" without strategic constraint produces a
random subset of features, not a coherent release. The tier assignments here
are strategic (acquisition / retention / expansion), not just effort-based.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
