---
skill_id: marketing-referral-program
name: Referral & Advocacy
version: 1.0.0
parent: marketing
office: CMO
reads_first: MARKETING-CONTEXT.md
triggers:
  - referral program
  - advocacy
  - word of mouth
  - viral loop
  - ambassador
  - refer a friend
  - affiliate
  - viral coefficient
  - NPS program
---

# Referral & Advocacy

> **Before starting:** Read `MARKETING-CONTEXT.md` in this domain for product, ICP, and positioning context.

## What This Skill Does

Designs referral programs, ambassador initiatives, and viral mechanics that turn satisfied customers into a scalable acquisition channel. Goes beyond "give $10, get $10" to build systematic advocacy programs grounded in behavioral science -- social proof, reciprocity, identity signaling, and network effects. Measures viral coefficient and optimizes the referral funnel like any other acquisition channel.

## Key Questions to Ask

1. What is the current NPS score? (referral programs work when NPS > 40)
2. Are customers already referring organically? (if yes, systematize it; if no, fix the product first)
3. What does the referrer get? (monetary, status, access, recognition)
4. What does the referred person get? (discount, trial extension, exclusive content)
5. Is the product inherently shareable? (collaborative features, public output, social identity)
6. What is the current viral coefficient (k-factor)?

## Framework / Approach

### Viral Coefficient Design

The viral coefficient (k) = invitations sent per user x conversion rate of invitations

- k < 1: Referrals supplement growth but don't drive it alone
- k = 1: Each user brings one new user (sustainable but flat)
- k > 1: Exponential growth (rare, requires product-level virality)

**To increase k:**
1. Increase invitations sent -- Make sharing frictionless, embed in product flow
2. Increase conversion rate -- Make the referral compelling to the recipient
3. Decrease cycle time -- Shorten the time between referral and activation

### Referral Program Architecture

1. **Incentive Structure**:
   | Model | Best For | Example |
   |---|---|---|
   | Two-sided reward | B2C, self-serve | "Give $20, get $20" |
   | Status/access | Communities, premium products | "Unlock beta features by referring 3 friends" |
   | Tiered rewards | Power users, advocates | "Bronze (1 ref) → Silver (5) → Gold (10)" |
   | Charitable | Mission-driven brands | "We donate $10 per referral" |
   | Credit/usage | Usage-based products | "Get 1 month free per referral" |

2. **Referral Flow Design**:
   - **Trigger moment** -- When to ask (after positive experience, milestone, NPS 9-10)
   - **Sharing mechanism** -- How to share (unique link, email invite, social share, in-app)
   - **Landing experience** -- What the referred person sees (personalized, social proof from referrer)
   - **Attribution** -- How to track (unique codes, UTM, cookies, account linking)
   - **Reward fulfillment** -- When and how rewards are delivered (instant vs. after activation)

3. **Anti-Fraud Measures**:
   - Require referred user to complete a meaningful action (not just signup)
   - Cap rewards per referrer per period
   - Detect self-referral patterns
   - Validate unique users (email domain, device fingerprint)

### NPS-to-Referral Pipeline

1. Survey customers with NPS
2. Segment by score:
   - **Promoters (9-10)** -- Immediately offer referral opportunity
   - **Passives (7-8)** -- Ask what would make them a 9-10, then re-survey
   - **Detractors (0-6)** -- Route to customer success for recovery
3. Automate the promoter → referral ask with personalized messaging
4. Track referral conversion by NPS segment

### Ambassador / Advocate Program

For high-touch or community-driven products:

1. **Identify champions** -- Power users, frequent contributors, vocal supporters
2. **Formalize the relationship** -- Named program with clear benefits and expectations
3. **Equip them** -- Swag, exclusive content, early access, co-marketing opportunities
4. **Recognize them** -- Public acknowledgment, leaderboards, featured stories
5. **Measure impact** -- Referrals generated, content created, community engagement

## Output Format

```markdown
## Referral Program Design: [Product Name]

### Program Overview
- Type: [two-sided / tiered / status / charitable]
- Goal: [target referral rate, k-factor target]
- Budget: [reward cost per referral, monthly cap]

### Incentive Structure
| Party | Reward | Condition | Fulfillment |
|---|---|---|---|
| Referrer | [reward] | [when triggered] | [how delivered] |
| Referred | [reward] | [when triggered] | [how delivered] |

### Referral Flow
1. Trigger: [when the ask happens]
2. Sharing: [mechanism]
3. Landing: [what referred person sees]
4. Attribution: [tracking method]
5. Reward: [fulfillment timing]

### Referral Funnel Metrics
| Stage | Metric | Target |
|---|---|---|
| Impressions (see the ask) | [% of eligible users] | [X%] |
| Shares (send a referral) | [% of impressions] | [X%] |
| Clicks (referred visits) | [% of shares] | [X%] |
| Signups (referred converts) | [% of clicks] | [X%] |
| Activated (referred activates) | [% of signups] | [X%] |

### Viral Coefficient
- Current k-factor: [X]
- Target k-factor: [Y]
- Levers to improve: [specific actions]

### Anti-Fraud Rules
- [rule 1]
- [rule 2]
- [rule 3]
```

## Related Skills
- `growth-retention` -- referral as part of the full growth loop
- `email-sequences` -- referral ask and follow-up sequences
- `customer-research` -- NPS data and advocate identification
- `copywriting` -- referral messaging and share copy

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
