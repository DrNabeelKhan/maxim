---
name: ttm-stage-detection
description: Detects operator's Transtheoretical Model (TTM) adoption stage from session count + pack subscriptions so upgrade prompts match readiness.
business_outcome: "Convert aware → active users faster by stage-matching messaging (higher conversion, lower churn)"
primary_framework: "Transtheoretical Model (Prochaska & DiClemente, 1977)"
type: composable-skill
domain: operator-intelligence
ships_in: free-tier
since: v1.0.0
---

# TTM Stage Detection (framework skill)

## The Maxim Moat

Most tools blast the same upgrade pitch at every user. Maxim reads the operator's
adoption stage and matches messaging to readiness. A Precontemplation-stage user
sees zero pack pitches; a Maintenance-stage user sees certification prompts.

The moat: stage-matched messaging raises conversion and reduces churn. Replicating
requires (1) TTM stage classifier, (2) session-memory signal, (3) pack gate
integration, (4) 7-framework behavioral library — each one alone does nothing.

## Business Outcome

**Metric:** % of operators who cross from Contemplation → Preparation → Action
within 30 days.
**Target (v1.0.0 launch baseline):** 15% Contemplation → Action conversion; < 8%
Action → Precontemplation backslide (churn).

## Primary Behavioral Framework

**Transtheoretical Model (TTM), Prochaska & DiClemente (1977).**

Five stages:
1. **Precontemplation** — no awareness of change need
2. **Contemplation** — aware but not committed
3. **Preparation** — intent + small actions
4. **Action** — active behavior change (< 6 months)
5. **Maintenance** — sustained behavior (> 6 months)

Each stage demands different intervention: education (Precontemp), social proof
(Contemp), concrete next-step (Prep), reinforcement (Action), advocacy (Maint).

Source: Prochaska, J. O., & DiClemente, C. C. (1982). Transtheoretical therapy:
Toward a more integrative model of change. Psychotherapy.

## Behavioral → /mxm-status Translation

| TTM mechanism | /mxm-status output element |
|---|---|
| Precontemp: no awareness | Hide all pack references; show free-tier wins |
| Contemp: wavering | Surface social-proof + "entitlements you already have" band |
| Prep: intent + small action | Direct upgrade prompt with specific pack CTA |
| Action: active change | Reinforce habit loops; new Pack L1.X offer |
| Maintenance: sustained | Operator Status tier badge; certification prompt |

## Detection Heuristic

```
def detect_stage(session_count: int, pack_subs: int) -> str:
    if session_count <= 3 and pack_subs == 0: return "precontemplation"
    if session_count <= 9 and pack_subs == 0: return "contemplation"
    if session_count <= 24 and pack_subs <= 1: return "preparation"
    if session_count <= 49 and pack_subs <= 2: return "action"
    return "maintenance"
```

Session count = `ls .claude-sessions-memory/session-*.md | wc -l`.
Pack subs = read `.mxm-operator-profile/profile.md` → `packs.active[]`.

## Anti-Patterns (what breaks TTM matching)

1. **Stage-blind pitches** — blasting Pack 6 ($499) at a Precontemp user (session 2)
   violates stage matching, creates reactance, poisons the upgrade funnel.
2. **Over-pitching Maintenance users** — they are already paying; additional pitches
   feel disrespectful and trigger downgrade/cancel.
3. **Ignoring pack_subs signal** — a user with 2 active packs at session 10 is
   further along than session count alone implies; weight pack_subs equally.

## Pack Integrations

- **Free tier:** stage detection + 5-stage output
- **Pack L1.6 (Behavioral Intelligence):** deeper intervention library per stage
  (SCARF/SDT/Prospect framing variants; A/B-tested copy per stage)
- **Pack L1.1 (AI Governance):** logs stage transitions in `operator-profile.md`
  for cohort analysis
- **Cross-project (Pack L1.2 MemPalace):** aggregate stage distribution across all
  operator's projects for portfolio-level adoption health

## Implementation Notes

- Used by `/mxm-status` (v1.0.0+) — see `.claude/commands/mxm-status.md` Step 2
- Milestone triggers at sessions 10/25/50 layer ON TOP of stage detection:
  stage gates what message shows; milestone gates WHEN a new section unlocks.
