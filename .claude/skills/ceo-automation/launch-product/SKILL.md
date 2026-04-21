# Launch and Product -- Prompt Catalog

> Domain: ceo-automation/launch-product | Office: CPO/CTO
> Reference: `ceo-automation-prompts.md` lines 1972-2128

## Maxim MOAT — Behavioral Enforcement

Every launch/product output MUST apply:
- **RICE** (Reach, Impact, Confidence, Effort) on all prioritization tasks
- **Kano Model** — Must-be, One-dimensional, Attractive, Indifferent on feature scoring
- **Design Thinking** — Empathize, Define, Ideate, Prototype, Test on user story generation
- **Jobs-to-be-Done** — what job is the customer hiring this feature for?
- **COM-B** — Capability, Opportunity, Motivation on launch readiness assessment
- Auto-loop `product-strategist` on roadmap and feature tasks
- Auto-loop `tester` on code quality and CI/CD audit tasks
- Auto-loop `security-analyst` on security surface scan tasks
- Confidence tag every output: 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW

## Standard Prefix

```
Read .mxm-executive-summary/CONTEXT.md first.
Read config/project-manifest.json for compliance scope.
Save output to .mxm-executive-summary/logs/[task-name]-[date].md
```

## Prompt Index

### Launch Readiness

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Launch readiness checklist | midday | PRODUCT.md, BACKLOG.md, LAUNCH-PLAN.md | Score 1-5: stability, onboarding, pricing, legal, support, analytics, content |
| MVP scope lock | overnight | BACKLOG.md, OKRs.md, ICP.md | Must-have vs nice-to-have with one-sentence cut justifications |
| Public release notes | overnight | CHANGELOG.md, BRAND-VOICE.md | User-facing notes: lead with benefit, group by type, 300 words max |
| Go-to-market one-pager | overnight | ICP.md, PRODUCT.md, COMPETITORS.md, METRICS.md | Segment, problem, solution, 3 channels, week 1/2/4 sequence, success metric |
| Launch day war room plan | overnight | LAUNCH-PLAN.md, TEAM.md | Checklist (T-24h, T-2h, T-30min), go-live sequence, monitoring, debrief |

### Roadmap and Prioritisation

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Quarterly roadmap draft | overnight | OKRs.md, BACKLOG.md, METRICS.md | 90-day roadmap by month, mapped to key results |
| Feature prioritisation (RICE) | midday | BACKLOG.md, USER-FEEDBACK.md, METRICS.md | RICE score per item; highlight top 3 high-score under-2-weeks |
| Now/next/later map | overnight | BACKLOG.md, OKRs.md, TEAM.md | Sort backlog by immediacy; flag unowned or blocked Now items |
| User story generator | midday | BACKLOG.md, ICP.md | Per sprint feature: As a [role] I want [action] so that [outcome] + 3 ACs |

### Code Quality and Technical Health

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Technical debt audit | overnight | src/ | Top 5 by severity: what, where, what breaks, fix time, risk type |
| Security surface scan | overnight | src/, package.json | Hardcoded secrets, unvalidated inputs, exposed endpoints, CVEs |
| Dependency health check | overnight | package.json | Per dependency: current vs latest, advisories, alternatives |
| Performance bottleneck report | overnight | src/, METRICS.md | N+1 queries, missing pagination, sync-should-be-async, bundle size |

### Documentation

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| README audit and rewrite | overnight | README.md, PRODUCT.md, ICP.md | Score each section 1-5; rewrite below 4 |
| Changelog auto-draft | overnight | git log | 7-day commits grouped: features, improvements, fixes, internal |

### User Feedback and Research

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Feedback synthesis report | overnight | USER-FEEDBACK.md | Themes clustered: count, quotes, severity, segment, action |
| Feature request pattern scan | overnight | USER-FEEDBACK.md, BACKLOG.md | Requests mentioned 2+ times; cross-reference backlog; generate items |
| Support ticket triage | morning | USER-FEEDBACK.md, PRODUCT.md | Categorise: bug, UX, missing feature, billing, user error |

### DevOps and Reliability

| Prompt | Timing | Input Files | Description |
|---|---|---|---|
| Incident post-mortem | morning | logs/ | Blameless: timeline, 5 whys, impact, fix, 3 action items |
| CI/CD pipeline audit | overnight | .github/workflows/, src/ | Tests, linting, staging, secrets, duration, parallelisation |
| Monitoring coverage check | overnight | src/, METRICS.md | Critical flows without error rate/latency/alerting |

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
