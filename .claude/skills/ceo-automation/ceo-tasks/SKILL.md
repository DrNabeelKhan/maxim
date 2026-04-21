# CEO Tasks -- Prompt Catalog

> Domain: ceo-automation/ceo-tasks | Office: CEO
> Reference: `ceo-automation-prompts.md` lines 1412-1599

## Maxim MOAT — Behavioral Enforcement

Every CEO task output MUST apply:
- **Fogg Behavior Model** on all recommendations (Motivation + Ability + Prompt)
- **Loss Aversion framing** on burn rate alerts, churn signals, competitive threats
- **EAST** — make every action item Easy, Attractive, Social, Timely
- Frameworks: Porter's Five Forces (strategy), Jobs-to-be-Done (ICP), SaaS Unit Economics (metrics)
- Auto-loop `financial-modeler` on RUNWAY/METRICS tasks, `security-analyst` on regulated project data
- Confidence tag every output: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW

## Standard Prefix

```
Read .mxm-executive-summary/CONTEXT.md first.
Read .mxm-executive-summary/sessions/CLAUDE.md for session instructions.
Read config/project-manifest.json for compliance scope.
Save output to .mxm-executive-summary/logs/[task-name]-[date].md
```

## Prompt Index

### Strategy and Vision

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Weekly strategy check | overnight | OKRs.md, METRICS.md, COMPETITORS.md | Evaluate top 3 priorities against last week's data |
| Competitive moat audit | overnight | PRODUCT.md, COMPETITORS.md | Per-competitor: what they do better, what we do better, market gaps |
| ICP sharpening | midday | CRM-notes.md, ICP.md | Rewrite ICP based on last 10 closed-won deal traits |
| Startup health scorecard | morning | METRICS.md, OKRs.md, RUNWAY.md | 1-10 score across traction, PMF, team, burn efficiency |
| North star metric review | overnight | METRICS.md, OKRs.md | Correlation analysis -- is our north star still the right one? |

### Metrics and Performance

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Daily metrics digest | morning | METRICS.md | 5 bullet summary, flag 10%+ movements |
| Weekly growth report | overnight | METRICS.md | WoW growth for revenue, users, churn, CAC with ASCII trend |
| Burn rate alert | morning | RUNWAY.md | Monthly burn, runway months, default-alive milestone |
| Revenue breakdown | morning | METRICS.md | MRR by: new, expansion, contraction, churn; NRR calculation |

### People and Team

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Team capacity check | morning | TEAM.md, SPRINT.md | Per-person workload, blockers, over/underutilization |
| Hiring brief generator | midday | TEAM.md, OKRs.md | One-page brief for most impactful next hire |
| Performance signal scan | overnight | TEAM.md, BLOCKERS.md | 30-day patterns: who ships, who blocks, recurring issues |
| Culture and values audit | overnight | VALUES.md, TEAM.md | Gap between stated values and actual team behavior |

### Investors and Fundraising

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Monthly investor update | overnight | METRICS.md, OKRs.md, WINS.md | 400-word email: headline metric, win, challenge, ask |
| Fundraising narrative | overnight | PRODUCT.md, METRICS.md, MARKET.md | 200-word Series A narrative |
| VC meeting prep | morning | METRICS.md, COMPETITORS.md | 10 hardest VC questions with honest answers |
| Cap table health check | overnight | RUNWAY.md | Founder ownership, option pool, projected dilution |

### Decisions and Prioritization

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Daily priority stack rank | morning | OKRs.md, BACKLOG.md, BLOCKERS.md | Top 7 tasks ranked by revenue impact x urgency |
| Opportunity cost scanner | overnight | OKRs.md, BACKLOG.md | Top 3 time sinks vs higher-leverage alternatives |
| Shut down vs pivot signal | overnight | METRICS.md, OKRs.md | 90-day distress signal analysis: double down, pivot, or shut down |
| Feature prioritization | midday | BACKLOG.md, USER-FEEDBACK.md | Score by demand x impact x effort; flag high-impact low-effort |

### Communications and Planning

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Board meeting prep | overnight | METRICS.md, OKRs.md | Agenda + 1-page pre-read |
| All-hands script | midday | WINS.md, METRICS.md, TEAM.md | 5-minute script: shipped, celebrate, challenge, focus |
| EOD summary | evening | OKRs.md, BLOCKERS.md | 5-bullet end-of-day: moved, open, decided, needed, hard |
| Weekly plan generator | overnight | OKRs.md, METRICS.md, BACKLOG.md | Per-startup: top 3 goals, risks, one thing to stop |
| Bottleneck finder | overnight | BLOCKERS.md, TEAM.md | Top 3 recurring bottlenecks with root cause and fix |

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
