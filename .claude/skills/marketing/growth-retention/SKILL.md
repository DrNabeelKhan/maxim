---
skill_id: marketing-growth-retention
name: Growth & Retention
version: 1.0.0
parent: marketing
office: CMO
reads_first: MARKETING-CONTEXT.md
triggers:
  - growth
  - retention
  - churn
  - activation
  - engagement
  - user lifecycle
  - cohort analysis
  - LTV
  - growth loop
  - onboarding
  - AARRR
---

# Growth & Retention

> **Before starting:** Read `MARKETING-CONTEXT.md` in this domain for product, ICP, and positioning context.

## What This Skill Does

Designs and optimizes the full user lifecycle -- from first touch through long-term retention and expansion. Identifies growth loops (not just funnels), diagnoses churn causes, and builds retention mechanisms grounded in habit formation science (Hook Model, Fogg Behavior Model). Focuses on sustainable, compounding growth rather than one-time acquisition spikes.

## Key Questions to Ask

1. What does "activated" mean for your product? (the aha moment)
2. What is your current retention curve? (Day 1, 7, 30, 90)
3. Where is the biggest drop-off in the user journey?
4. What is your primary growth motion? (product-led, sales-led, community-led)
5. What existing growth loops are working? (referral, content, paid, viral)
6. What is your current LTV:CAC ratio?

## Framework / Approach

### AARRR Pirate Metrics (Diagnostic)

Audit each stage to find the highest-leverage bottleneck:

| Stage | Question | Key Metrics |
|---|---|---|
| **Acquisition** | How do users find us? | Channel mix, CAC by channel, volume |
| **Activation** | Do they experience the core value? | Time-to-value, activation rate, setup completion |
| **Retention** | Do they come back? | D1/D7/D30 retention, DAU/MAU ratio, churn rate |
| **Revenue** | Do they pay? | Conversion to paid, ARPU, LTV, expansion revenue |
| **Referral** | Do they tell others? | Referral rate, viral coefficient, NPS |

### Growth Loops (Strategic)

Identify and strengthen loops that compound:

1. **Viral Loop** -- User invites others as part of using the product (e.g., shared workspaces, collaborative features)
2. **Content Loop** -- Usage creates content that attracts new users via search/social (e.g., public profiles, generated reports)
3. **Paid Loop** -- Revenue funds acquisition spend that generates more revenue (unit economics must work)
4. **Sales Loop** -- Happy customers become references that shorten sales cycles

### Retention Mechanics (Tactical)

Apply the Hook Model (Nir Eyal) to build habitual engagement:

1. **Trigger** -- External (notification, email) → Internal (emotion, routine)
2. **Action** -- Simplest behavior in anticipation of reward (Fogg: motivation + ability + trigger)
3. **Variable Reward** -- Social, hunt (information), or self (mastery/completion)
4. **Investment** -- User puts something in that makes the product better over time (data, content, connections)

### Churn Diagnosis Protocol

1. Segment churned users (by cohort, plan, feature usage, acquisition channel)
2. Identify pre-churn signals (declining usage, support tickets, feature non-adoption)
3. Map churn reasons (survey data, exit interviews, support ticket analysis)
4. Prioritize interventions by recoverable revenue impact
5. Design win-back sequences (see `email-sequences` skill)

## Output Format

```markdown
## Growth & Retention Audit: [Product Name]

### AARRR Scorecard
| Stage | Current Metric | Benchmark | Gap | Priority |
|---|---|---|---|---|
| Acquisition | [value] | [industry avg] | [delta] | [H/M/L] |
| Activation | [value] | [target] | [delta] | [H/M/L] |
| Retention | [value] | [target] | [delta] | [H/M/L] |
| Revenue | [value] | [target] | [delta] | [H/M/L] |
| Referral | [value] | [target] | [delta] | [H/M/L] |

### Primary Bottleneck
[Which stage, why, and what data supports this]

### Growth Loop Design
[Diagram or description of the primary loop to strengthen]

### Retention Interventions
| Intervention | Target Segment | Expected Impact | Effort |
|---|---|---|---|
| [action] | [who] | [metric improvement] | [S/M/L] |

### 90-Day Growth Plan
| Week | Focus | Key Action | Success Metric |
|---|---|---|---|
| 1-2 | [stage] | [action] | [metric] |
| 3-4 | [stage] | [action] | [metric] |
| ... | ... | ... | ... |
```

## Related Skills
- `email-sequences` -- lifecycle email sequences for activation and retention
- `cro` -- conversion optimization at each funnel stage
- `paid-measurement` -- acquisition channel measurement and ROI
- `referral-program` -- designing and optimizing referral loops
- `customer-research` -- understanding churn reasons and user motivations

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
