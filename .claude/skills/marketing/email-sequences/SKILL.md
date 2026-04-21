---
skill_id: marketing-email-sequences
name: Email Sequence Writer
version: 1.0.0
parent: marketing
office: CMO
reads_first: MARKETING-CONTEXT.md
triggers:
  - email campaign
  - drip sequence
  - onboarding email
  - retention email
  - nurture
  - welcome sequence
  - re-engagement
  - lifecycle email
  - email automation
---

# Email Sequence Writer

> **Before starting:** Read `MARKETING-CONTEXT.md` in this domain for product, ICP, and positioning context.

## What This Skill Does

Designs and writes complete email sequences -- from trigger event through final CTA -- with precise cadence, subject lines, body copy, and measurement criteria. Covers onboarding, nurture, re-engagement, upsell, and retention sequences. Every email is grounded in behavioral psychology: reciprocity in value-first emails, commitment escalation across the sequence, and scarcity/urgency only when authentic.

## Key Questions to Ask

1. What triggers this sequence? (signup, trial start, purchase, inactivity, event)
2. What is the sequence goal? (activate, convert, retain, upsell, win back)
3. How many emails and over what time period?
4. What value can we provide before asking? (content, tools, insights)
5. What email platform/ESP is in use? (affects personalization and dynamic content capability)
6. What compliance requirements apply? (CAN-SPAM, CASL, GDPR opt-in -- check MARKETING-CONTEXT.md)

## Framework / Approach

### Sequence Architecture

1. **Define the trigger event** -- What user action or time-based event starts the sequence?
2. **Map the journey** -- What does the user need to believe/do at each step to reach the goal?
3. **Set cadence** -- Frequency based on urgency and sequence type:
   - Onboarding: Day 0, 1, 3, 5, 7, 14
   - Nurture: Weekly or bi-weekly
   - Re-engagement: Day 30, 37, 44 (post-inactivity)
   - Upsell: Triggered by usage milestones
4. **Write each email** using this structure:
   - **Subject line** -- 6-10 words, curiosity or benefit-driven, no spam triggers
   - **Preview text** -- Complements (not repeats) the subject line
   - **Opening line** -- Acknowledge context (why they're getting this email)
   - **Body** -- One idea, one value, one ask
   - **CTA** -- Single action, button or text link, outcome-focused copy
   - **PS line** -- Optional secondary hook or social proof
5. **Define exit conditions** -- When does the user leave this sequence? (goal achieved, unsubscribe, enters different sequence)
6. **Set measurement** -- Open rate, click rate, conversion rate, unsubscribe rate per email

### Sequence Types

| Type | Goal | Typical Length | Key Principle |
|---|---|---|---|
| Welcome/Onboarding | Activate | 5-7 emails | Value-first, teach product |
| Nurture | Build trust | 8-12 emails | Educate, don't sell |
| Trial-to-Paid | Convert | 5-7 emails | Show ROI, create urgency |
| Re-engagement | Win back | 3-4 emails | Remind value, offer incentive |
| Post-Purchase | Retain | 4-6 emails | Reduce buyer's remorse, teach |
| Upsell/Cross-sell | Expand | 3-4 emails | Usage-triggered, show next level |

## Output Format

```markdown
## Email Sequence: [Sequence Name]

### Overview
- Trigger: [what starts it]
- Goal: [desired outcome]
- Length: [N emails over N days]
- Exit condition: [when user leaves sequence]

### Sequence Map

| # | Day | Subject Line | Goal | CTA |
|---|---|---|---|---|
| 1 | 0 | [subject] | [email goal] | [action] |
| 2 | 1 | [subject] | [email goal] | [action] |
| ... | ... | ... | ... | ... |

### Email 1: [Internal Name]
- **Send:** Day 0, immediately after [trigger]
- **Subject:** [subject line]
- **Preview:** [preview text]
- **Body:**

[Full email copy]

- **CTA:** [button text] → [destination URL]
- **Success metric:** [what to measure]

[Repeat for each email]

### Measurement Plan
| Metric | Target | Alert Threshold |
|---|---|---|
| Open rate | [X%] | Below [Y%] |
| Click rate | [X%] | Below [Y%] |
| Sequence completion | [X%] | Below [Y%] |
| Unsubscribe rate | Below [X%] | Above [Y%] |
```

## Related Skills
- `copywriting` -- email body copy frameworks (PAS, AIDA)
- `cro` -- landing page optimization for email CTAs
- `growth-retention` -- lifecycle strategy that sequences support
- `customer-research` -- voice-of-customer data for email personalization

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
