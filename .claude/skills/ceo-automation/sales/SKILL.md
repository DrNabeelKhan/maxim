# Sales -- Prompt Catalog

> Domain: ceo-automation/sales | Office: CEO/CMO
> Reference: `ceo-automation-prompts.md` lines 1767-1969

## Maxim MOAT — Behavioral Enforcement

Every sales output MUST apply:
- **SPIN Selling** — Situation, Problem, Implication, Need-payoff on discovery/outreach
- **Challenger Sale** — Teach, Tailor, Take Control on proposals and pitches
- **MEDDIC** — Metrics, Economic buyer, Decision criteria/process, Identify pain, Champion
- **Loss Aversion** — frame deal risk and churn signals with loss framing (Kahneman)
- **COM-B** — Capability, Opportunity, Motivation on prospect behavior analysis
- **Cialdini's Principles** — Reciprocity, Social proof, Authority on outreach sequences
- Auto-loop `financial-modeler` on ROI/pricing tasks
- Auto-loop `security-analyst` on regulated project customer data
- Confidence tag every output: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW

## Standard Prefix

```
Read .mxm-executive-summary/CONTEXT.md first.
Read config/project-manifest.json for compliance scope.
Save output to .mxm-executive-summary/logs/[task-name]-[date].md
```

## Prompt Index

### Pipeline Management

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Daily pipeline digest | morning | CRM-notes.md, OKRs.md | Every open deal: stage, size, last contact, next action, flags |
| Pipeline health score | overnight | CRM-notes.md, METRICS.md | Total pipeline, weighted, avg deal size, cycle length, coverage |
| Stale deal rescue plan | morning | CRM-notes.md, BRAND-VOICE.md | Deals 10+ days cold: hypothesis + re-engagement message |
| Weekly forecast | overnight | CRM-notes.md, METRICS.md, OKRs.md | Committed/best case/pipeline vs monthly target |
| Lost deal post-mortem | overnight | CRM-notes.md | 30-day losses grouped by root cause with recommendations |

### Prospecting and Outreach

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Prospect list builder | overnight | ICP.md, CRM-notes.md | Target research brief: titles, signals, channels |
| Personalised outreach batch | morning | CRM-notes.md, ICP.md, PRODUCT.md | Per [TO-OUTREACH] prospect: 100-word first-touch email |
| LinkedIn connection batch | morning | CRM-notes.md, ICP.md | Per [LINKEDIN-OUTREACH]: 300-char connection note |
| Follow-up sequence | afternoon | CRM-notes.md, BRAND-VOICE.md | 3 follow-ups (day 3/7/14): new angle, proof, breakup |
| Warm intro request drafts | morning | CRM-notes.md, TEAM.md | Per [NEEDS-INTRO]: double opt-in email to connector |
| Cold call script | morning | ICP.md, PRODUCT.md, OBJECTIONS.md | Permission opener, pain hook, pivot question, 3 branches |

### Closing and Negotiation

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Deal review and next step | morning | CRM-notes.md | Per [PROPOSAL]/[NEGOTIATION]: status, blocker, exact message |
| Negotiation prep brief | morning | CRM-notes.md, PRODUCT.md | Walk-away point, 3 concessions, opening move |
| Mutual action plan | midday | CRM-notes.md, PRODUCT.md | Shared timeline to signed contract as markdown table |
| Reference customer matcher | morning | CRM-notes.md, WINS.md | Match prospect to 2-3 similar customers; draft reference request |

### Proposals and Decks

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Proposal first draft | overnight | CRM-notes.md, PRODUCT.md, ICP.md | 4-page tailored proposal: summary, solution, timeline, pricing, ROI |
| ROI calculator narrative | midday | CRM-notes.md, METRICS.md, WINS.md | Current cost, our cost, net saving, payback, 3-year projection |
| Competitor displacement pitch | overnight | COMPETITORS.md, PRODUCT.md, CRM-notes.md | Validate original choice, name growing pain, show our gap-fill |

### Objections and Enablement

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Objection handler guide | overnight | CRM-notes.md, OBJECTIONS.md, PRODUCT.md | Top 8 objections clustered: acknowledge, reframe, evidence |
| Competitor battle cards | overnight | COMPETITORS.md, PRODUCT.md | Per competitor: where we win, they win, discovery questions |
| Security/compliance FAQ | overnight | PRODUCT.md | 15 enterprise buyer questions: SOC2, encryption, SSO, SCIM, etc |

### Retention and Expansion

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Customer health scan | morning | CRM-notes.md, METRICS.md | Per customer: health score (login, adoption, NPS, renewal) |
| Expansion opportunity finder | overnight | CRM-notes.md, PRODUCT.md, METRICS.md | Customers showing higher-tier usage; conversation starters |
| Renewal risk report | morning | CRM-notes.md, METRICS.md | Renewals in 60 days: value, health, risk level, action |
| Churn prevention playbook | overnight | CRM-notes.md, METRICS.md, USER-FEEDBACK.md | Top 3 early churn signals with intervention playbook |

### Sales Intelligence

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Win/loss analysis | overnight | CRM-notes.md | 90-day wins/losses: common factors, 3 hypotheses, qualification change |
| Sales velocity report | overnight | CRM-notes.md, METRICS.md | Opportunities x deal value x win rate x cycle; sensitivity analysis |
| Account research brief | morning | CRM-notes.md, ICP.md | Pre-call: company overview, priorities, 3 questions, 2 landmines |

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
