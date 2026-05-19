---
description: TIER 3 persona — enterprise architects (TOGAF / C4 / ArchiMate / Wardley practitioners). Dispatches to CEO enterprise-architect with native Wardley Mapping, C4 rendering, ADR authoring, tech-radar generation.
---

# /mxm-arch

The architect persona surface (TIER 3 added v1.2.0). For enterprise architects, solution architects, and anyone whose job is "make sure this system can evolve." Maxim ships **Wardley Mapping natively** — rare in AI tools — alongside the standard TOGAF / C4 / ADR toolkit.

## Usage

```
/mxm-arch <sub-command> <args>
```

Six sub-commands ship in v1.2.0. Each produces a concrete architecture artifact, not a generic explainer.

| Sub-command | What it produces | Primary agent | Frameworks |
|---|---|---|---|
| `capability-map <domain>` | TOGAF capability map with maturity levels + gaps + owners | CEO `enterprise-architect` | TOGAF 10 · Business Capability Modeling |
| `wardley-map <strategy>` | Wardley map: Genesis → Custom-Built → Product → Commodity | CEO `enterprise-architect` | Wardley Mapping (Simon Wardley) |
| `tech-radar` | ThoughtWorks-style radar: Adopt / Trial / Assess / Hold | CEO `enterprise-architect` + CTO `implementer` | ThoughtWorks Tech Radar |
| `c4-diagram <system>` | Context / Container / Component / Code level diagrams | CEO `enterprise-architect` + CTO specialist | C4 Model (Simon Brown) · arc42 |
| `adr <decision>` | Lightweight ADR per Maxim ADR-001 template | CEO `enterprise-architect` | ADR-001 template · Documents as Executable Contracts (ADR-002) |
| `vendor-eval <category>` | Vendor scorecard: cost · lock-in · compliance · performance · support | CEO + CSO + CINO `cost-analyst` | Wardley component classification + cost-analyst overlay |

---

## Sub-command details

### `/mxm-arch capability-map <domain>`

TOGAF-style business capability map. Output is the artifact architects actually present at steering committees — not a textbook explanation of TOGAF.

**Reads:** `config/project-manifest.json` (capabilities · org structure if declared) · `documents/architecture/` (any prior maps) · `documents/ledgers/MOAT_TRACKER.md` (capability claims)

**Output:**
```
Capability Map — <domain>
─────────────────────────
LEVEL 1 (strategic)
  Capability A      maturity: 3/5    owner: <role>    gap: <one-line>
    ↳ LEVEL 2 sub-cap A.1   maturity: 4/5   owner: <role>   gap: <one-line>
    ↳ LEVEL 2 sub-cap A.2   maturity: 2/5   owner: <role>   gap: 🔴 critical

  Capability B      maturity: 4/5    owner: <role>    gap: minor
    ↳ ...

LEVEL 1 (operational)
  ...

LEVEL 1 (enabling)
  ...

Gap-priority order: <ranked list>
Investment roadmap (8 quarters): <quarter-by-quarter capability uplift plan>
```

**Behavioral framing:** the capability lens forces strategic clarity before tactical action. Architects use this when leadership asks "what should we invest in next" — Maxim grounds the answer in maturity + gap analysis, not vendor evangelism.

---

### `/mxm-arch wardley-map <strategy>`

Wardley map of the value chain. Components classified Genesis → Custom-Built → Product → Commodity. **First-class output in Maxim — most AI tools don't ship Wardley.**

**Reads:** strategy spec or business context · `documents/ledgers/MOAT_TRACKER.md` (defensibility claims map directly to Wardley evolution stages)

**Output (ASCII map + analysis):**
```
Wardley Map — <strategy>
─────────────────────────
USER NEED ↑
          |
  visible | [End user]
          |    |
          | [Customer-facing UX]   ←  Product / Custom
          |    |
          | [Behavioral overlay]   ←  Custom-Built (Maxim's moat)
          |    |
          | [LLM API access]       ←  Product (Claude)
          |    |
          | [Compute infra]        ←  Commodity (AWS/Cloudflare)
  hidden  |
          |
          +───────────────────────────────────────→
          Genesis    Custom-Built    Product    Commodity
          (uncertain, evolving)              (well-defined, ubiquitous)

ANALYSIS:
  Inertia points: <where the organization resists movement>
  Climatic patterns: <commoditization pressure · Jevons paradox · co-evolution>
  Doctrine gaps: <where standard practice isn't being applied>
  Gameplay: <Innovate-Leverage-Commoditize · Sensing Engines · Pioneers-Settlers-Town Planners>

Strategic implications:
  - <implication 1 with evidence>
  - <implication 2 with evidence>
```

**Why Maxim ships this natively:** Wardley Mapping is the most underused strategic tool of the decade. Enterprise architects who use it have an unfair advantage. Maxim builds the map deterministically from the strategy description — operator doesn't have to remember the Genesis-Custom-Product-Commodity axis.

---

### `/mxm-arch tech-radar`

ThoughtWorks-style technology radar. Quarterly artifact useful for board-level "what tech are we using and why" conversations.

**Reads:** `config/project-manifest.json → tech_stack` · `package.json` / `go.mod` / `pom.xml` (whatever declares dependencies) · MCP server list · prior radar if archived

**Output:**
```
Tech Radar — <project> · <quarter>
─────────────────────────────────
QUADRANT: Languages & Frameworks
  ADOPT:      <tools you should standardize on>
  TRIAL:      <tools to use on real projects with caution>
  ASSESS:     <tools worth exploring>
  HOLD:       <tools to phase out or never adopt>

QUADRANT: Platforms
  ...

QUADRANT: Tools
  ...

QUADRANT: Techniques
  ...

CHANGES SINCE LAST RADAR:
  Moved IN to ADOPT:  <list>
  Moved IN to HOLD:   <list>
  ...

Quarterly review owner: <role>
Next review: <date>
```

---

### `/mxm-arch c4-diagram <system>`

C4 model diagrams. Auto-picks the right level (Context / Container / Component / Code) per task scope.

**Reads:** system spec · existing architecture docs · code structure (via `smart-explorer` for Component-level)

**Output:** Mermaid diagram source (Context + Container default; Component on request; Code via tree-sitter) + textual description suitable for arc42 documentation template.

**Confidence:** 🟢 if code-grounded (Component/Code levels). 🟡 if Container level inferred from architecture docs. 🔴 if no spec available and the diagram is operator-described only.

---

### `/mxm-arch adr <decision>`

Authors an ADR using Maxim's template. ADRs are first-class governance artifacts in Maxim (Documents as Executable Contracts per ADR-002).

**Reads:** `documents/ADRs/TEMPLATE.md` · `documents/ADRs/INDEX.md` (assigns next ADR number) · the decision context

**Output:** Full ADR file with mandatory 4 sections (Context · Decision · Consequences · Alternatives Considered) + frontmatter. Writes to `documents/ADRs/ADR-{NNN}-{slug}.md`. Updates `INDEX.md` automatically.

**Behavioral framing:** ADR authoring is a forcing function for decision rigor. The "Alternatives Considered" section is the highest-value forcing function — three alternatives minimum, each with rejection rationale.

---

### `/mxm-arch vendor-eval <category>`

Vendor scorecard pairing Wardley component classification with cost-analyst overlay. Useful when leadership asks "should we build, buy, or partner."

**Reads:** vendor list (operator-provided or scanned from manifest) · pricing pages · `cost-analyst` agent (CINO office) for cost-dimension analysis

**Output:**
```
Vendor Evaluation — <category>
─────────────────────────────
WARDLEY CLASSIFICATION:
  This capability is at: <Genesis | Custom | Product | Commodity>
  Implication: <build · partner · buy · use commodity>

VENDOR SCORECARD:
| Vendor | Cost | Lock-in | Compliance | Performance | Support | Wardley Fit | Score |
|---|---:|---:|---:|---:|---:|---:|---:|
| Vendor A | $$ | Medium | SOC2+GDPR | 4/5 | 4/5 | Product (fit) | 18/25 |
| Vendor B | $$$ | High | SOC2 only | 5/5 | 5/5 | Custom (mismatch) | 16/25 |
| Vendor C | $ | Low | None | 3/5 | 2/5 | Commodity (fit) | 12/25 |

RECOMMENDATION: <one vendor> because <reasoning>
RISK CALLOUTS: <2-3 risks specific to the recommendation>
```

---

## Behavioral Overlay

- **TOGAF / Wardley / C4 native:** Maxim treats these as first-class — not behind a "domain knowledge" prompt. The frameworks ARE the routing logic.
- **Framework citation requirement (per ADR-007):** every architecture artifact cites the framework producing it. A capability map without TOGAF reference, a tech radar without ThoughtWorks methodology — these get 🔴 LOW.
- **Specialist routing (WS5+):** today, all sub-commands route through CEO `enterprise-architect`. After WS5 expands the CEO office with `wardley-mapper`, `three-horizons-portfolio-planner`, `m-and-a-due-diligence-analyst`, and similar, each sub-command auto-routes to the specialist.
- **Confidence tag rubric:** 🟢 HIGH = artifact framework-grounded + sources cited + maturity scoring justified. 🟡 MEDIUM = artifact complete but maturity scoring or vendor data is operator-asserted (not independently verified). 🔴 LOW = generic architecture output without framework methodology.

## TIER 3 surface note

Architects think in artifacts (capability map · Wardley map · ADR · radar), not in "office routing." `/mxm-arch` speaks artifact-language and routes invisibly to the office that produces it.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 3 persona dispatcher shipped in WS3 of v1.2.0 sprint (2026-05-19) per AGENT_ROSTER_v1.2_PROPOSAL.md § TIER 3._
