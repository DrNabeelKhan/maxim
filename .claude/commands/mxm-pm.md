---
description: TIER 3 persona — product managers, PRD authors, JTBD practitioners, OKR architects, RICE prioritization. Dispatches to CPO product-strategist with INVEST validation, Jobs-to-be-Done (Tony Ulwick's Jobs Atlas), OKR with leading + lagging indicators.
---

# /mxm-pm

The product manager persona surface (TIER 3 added v1.2.0). For PMs writing PRDs, breaking work into user stories, setting OKRs, prioritizing backlogs, and running JTBD discovery. Maxim ships INVEST validation + Jobs Atlas + OKR with leading+lagging discipline as default routing.

## Usage

```
/mxm-pm <sub-command> <args>
```

Five sub-commands ship in v1.2.0. Each produces a concrete PM artifact — not a "PM best practices" essay.

| Sub-command | What it produces | Primary agent | Frameworks |
|---|---|---|---|
| `prd <feature>` | PRD: problem · hypothesis · metrics · scope · risks | CPO `product-strategist` + (`prd-author` after WS5) | Standard PRD structure · ADR-002 (Executable Contracts) |
| `user-story <task>` | INVEST-validated user stories with acceptance criteria | CPO `product-strategist` | INVEST · Gherkin · acceptance criteria checklist |
| `okr <quarter>` | OKR draft with leading + lagging indicators | CPO + CEO `enterprise-architect` | OKR · KPI Trees · North Star Framework |
| `prioritize <backlog>` | RICE / ICE prioritization with reasoning | CPO `product-strategist` + (`growth-pm` after WS5) | RICE · ICE · Kano Model · WSJF |
| `jtbd <user>` | Jobs-to-be-Done: job statement · job map · outcome statements | CPO `product-strategist` + (`jtbd-analyst` after WS5) | Tony Ulwick's Jobs Atlas · Clayton Christensen JTBD |

---

## Sub-command details

### `/mxm-pm prd <feature>`

PRD with structure proven across hundreds of product launches. Not the "fill in this template" version — Maxim grounds each section against project compliance scope, MOAT_TRACKER, and existing ADRs.

**Reads:** feature description · `config/project-manifest.json` (compliance scope · stage · stack) · `documents/ledgers/MOAT_TRACKER.md` · `documents/ADRs/INDEX.md` (any ADRs constraining this feature)

**Output:**
```
PRD — <feature>
────────────────────────
1. SUMMARY (Minto top-of-pyramid)
   One sentence: <what we're shipping + why now>

2. PROBLEM
   Who has it:       <segment with size if known>
   How they handle today:  <current workaround>
   Why now:          <market/regulatory/competitive driver>
   Evidence:         <user research · analytics · support tickets · stakeholder asks>

3. HYPOTHESIS
   IF we ship <solution>
   THEN <leading indicator> improves by <delta> within <timeframe>
   BECAUSE <causal mechanism>

4. SUCCESS METRICS
   Leading indicators (visible in first 2 weeks):
     - <metric 1> · target: <number> · baseline: <number>
   Lagging indicators (visible in 30–90 days):
     - <metric 1> · target: <number> · baseline: <number>
   Counter-metrics (must NOT regress):
     - <metric 1> · guardrail: <threshold>

5. SCOPE
   IN scope:    <bulleted list of what ships>
   OUT of scope: <bulleted list of what's explicitly deferred>
   Open questions: <list with owner + due date>

6. SOLUTION OUTLINE
   <UI/UX wireframe or behavior description>
   <Data model changes>
   <API surface changes>
   <Notable backend logic>

7. RISKS & MITIGATIONS
   Technical: <risk · mitigation · owner>
   Compliance: <if regulated scope · CSO auto-loop confirms>
   Operational: <SLO impact · runbook updates needed>
   Product: <user pushback · churn risk · migration paths>

8. ROLLOUT PLAN
   Phase 1: <cohort · gating · success criteria for proceed-to-phase-2>
   Phase 2: <expansion · monitoring>
   Phase 3: <GA · sunset of any deprecated paths>

9. ADR LINKS (if architectural decisions involved)
   ADR-NNN: <decision> · status: <accepted/proposed>

10. APPROVAL
    Sign-offs: <PM · Eng Lead · CSO if regulated · CMO if customer-facing>
```

CSO auto-loop fires if compliance scope is touched. Output tagged 🟢 / 🟡 / 🔴 per ADR-010.

---

### `/mxm-pm user-story <task>`

INVEST-validated user stories with Gherkin acceptance criteria.

**Reads:** task description · existing user stories (if any) · PRD if available

**Output:**
```
User Story — <task>
────────────────────────
TITLE: <verb-first short title>

STORY:
  As a <persona>
  I want to <action / capability>
  So that <outcome / value>

ACCEPTANCE CRITERIA (Gherkin):
  Scenario 1: <happy path>
    Given <initial state>
    When <action>
    Then <expected outcome>

  Scenario 2: <edge case>
    Given <initial state>
    When <action>
    Then <expected outcome>

  Scenario 3: <error path>
    Given <initial state>
    When <action>
    Then <expected error handling>

INVEST CHECK:
  Independent:  ✅ / ⚠️ (depends on <story X>) / ❌
  Negotiable:   ✅ / ❌ (scope is fixed)
  Valuable:     ✅ (value: <one-line>) / ❌
  Estimable:    ✅ (estimate: <story points>) / ❌ (needs spike)
  Small:        ✅ (fits in one sprint) / ❌ (split needed → see SPLIT below)
  Testable:     ✅ (criteria above are executable) / ❌

[IF NOT SMALL] SPLIT RECOMMENDATION:
  Story 1: <split A>
  Story 2: <split B>

DONE WHEN: <one-line definition-of-done specific to this story>
```

---

### `/mxm-pm okr <quarter>`

OKR draft with leading + lagging indicators. Most OKR advice is lagging-only — Maxim forces leading-indicator declaration.

**Reads:** previous quarter OKRs if in MOAT_TRACKER or `documents/business/` · `config/project-manifest.json → project.stage` · cross-functional team list

**Output:**
```
OKRs — <quarter>
────────────────────
OBJECTIVE 1: <qualitative, inspirational>
  Why it matters: <ties to <metric · MOAT · annual goal>>

  KR1.1 — LAGGING:    <metric> from <baseline> to <target> by <date>
    Owner: <role>     Confidence: <0.0–1.0>
  KR1.2 — LEADING:    <metric visible weekly> from <baseline> to <target>
    Owner: <role>     Confidence: <0.0–1.0>
  KR1.3 — INPUT:      <activity volume> · <baseline> → <target>
    Owner: <role>

OBJECTIVE 2: <next qualitative goal>
  ... (KR1, KR2 with leading + lagging)

OBJECTIVE 3: <third — keep total to 3–5>
  ...

WEEKLY CHECK-IN CADENCE:
  Leading KRs reviewed every <day> at <time>
  Confidence updates every <week> via <mechanism>

ANTI-PATTERNS TO AVOID:
  - OKRs that are just task lists (set outcomes, not activities)
  - OKRs with confidence permanently at 1.0 (sandbagged) or 0.0 (impossible)
  - All-lagging KRs (no early signal to course-correct)
  - More than 5 objectives per team
```

---

### `/mxm-pm prioritize <backlog>`

RICE / ICE prioritization with reasoning. Outputs ranked list with explicit reach × impact × confidence ÷ effort math.

**Reads:** backlog items (operator-provided list or `documents/business/` board) · `config/project-manifest.json` · team capacity if known

**Output:**
```
Backlog Prioritization — <scope>
────────────────────────────────
RICE METHOD:
| Item | Reach | Impact | Confidence | Effort | RICE Score | Rank |
|---|---:|---:|---:|---:|---:|---:|
| Item A | 5000 users/qtr | 3 (high) | 80% | 4 wk | (5000*3*0.8)/4 = 3000 | 1 |
| Item B | 1000 users/qtr | 3 (high) | 90% | 2 wk | (1000*3*0.9)/2 = 1350 | 2 |
| Item C | 8000 users/qtr | 1 (low)  | 70% | 8 wk | (8000*1*0.7)/8 = 700  | 3 |
| ...

ICE SANITY-CHECK (faster):
| Item | Impact | Confidence | Ease | ICE Score | Agrees with RICE? |

KANO MODEL OVERLAY:
| Item | Category (Basic/Performance/Excitement/Indifferent/Reverse) |
| Item A | Performance — proportional satisfaction |
| Item B | Excitement — delights when present, indifferent when absent |
| ...

WSJF (Weighted Shortest Job First) — if SAFe / time-critical context:
| Item | Cost-of-Delay | Job Duration | WSJF |

RECOMMENDATION:
  Sprint 1 (P0 by RICE): <items>
  Sprint 2 (P1 by RICE): <items>
  Watchlist: <high-RICE but low-confidence items needing more discovery>

Confidence: 🟢 if numbers operator-supplied · 🟡 if RICE inputs estimated · 🔴 if no backlog context provided
```

---

### `/mxm-pm jtbd <user>`

Jobs-to-be-Done analysis via Tony Ulwick's Jobs Atlas (Tier 2 framework in FRAMEWORKS_MASTER). Surfaces the underlying job, the job map, and outcome statements that drive feature prioritization.

**Reads:** user/customer segment description · existing user research if any · operator-supplied interview transcripts if pasted

**Output:**
```
JTBD Analysis — <user segment>
──────────────────────────────
CORE JOB STATEMENT:
  When <situation>
  I want to <motivation>
  So that <outcome>

  (Ulwick format: action verb + object of action + contextual clarifier)

JOB MAP (8 universal steps):
  1. DEFINE:    <what user does to define the goal>
  2. LOCATE:    <how user finds resources/info>
  3. PREPARE:   <setup the user does>
  4. CONFIRM:   <verification user wants>
  5. EXECUTE:   <the core activity>
  6. MONITOR:   <how user tracks progress>
  7. MODIFY:    <how user adapts based on feedback>
  8. CONCLUDE:  <how user finishes/closes>

  Steps where current solutions UNDER-SERVE the job: <list>
  Steps where current solutions OVER-SERVE the job: <list>

OUTCOME STATEMENTS (Ulwick format: direction + metric + object of control + contextual clarifier):
  - Minimize the time it takes to <outcome>
  - Increase the likelihood that <outcome>
  - Minimize the number of <outcome>
  ... (10–20 outcome statements, ranked by importance × satisfaction gap)

RELATED JOBS (where to expand the product later):
  - Adjacent functional job: <one-line>
  - Emotional job: <one-line>
  - Social job: <one-line>

OPPORTUNITY MAP (outcome statements with high importance + low current satisfaction):
| Outcome | Importance (1–10) | Satisfaction (1–10) | Opportunity Score = I+max(I-S,0) |
| <outcome> | 9 | 3 | 9+6=15 (PRIME OPPORTUNITY) |
| ...

PRIORITY FEATURE BETS:
  Bet 1: <feature> → addresses outcomes <#X, #Y> · opportunity score sum: <N>
  Bet 2: <feature> → addresses outcomes <#Z, #W> · opportunity score sum: <N>
```

---

## Behavioral Overlay

- **Leading + lagging discipline:** OKR drafts force both. Lagging-only OKRs are 🔴 LOW.
- **INVEST is non-negotiable:** user stories failing INVEST get split recommendations, not a pass.
- **Jobs Atlas grounding:** Maxim treats JTBD as the upstream of feature prioritization. Outcome statements drive RICE inputs.
- **Specialist routing (WS5+):** today, sub-commands route through CPO `product-strategist` lead. After WS5 ships `prd-author` · `user-researcher` · `jtbd-analyst` · `growth-pm` · `platform-pm` · `pricing-strategist` · `outcome-strategist`, each sub-command routes to its specialist.
- **Confidence tag rubric:** 🟢 HIGH = artifact framework-grounded + manifest-grounded + numbers validated. 🟡 MEDIUM = artifact complete but inputs estimated. 🔴 LOW = generic PM output without framework citation.

## TIER 3 surface note

PMs think in PRDs · user stories · OKRs · prioritized backlogs · JTBD analyses. `/mxm-pm` speaks artifact-language. Power users can still type `/mxm-cpo` for direct CPO office routing.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 3 persona dispatcher shipped in WS3 of v1.2.0 sprint (2026-05-19) per AGENT_ROSTER_v1.2_PROPOSAL.md § TIER 3._
