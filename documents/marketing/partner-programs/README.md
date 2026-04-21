# partner-programs/

> Partner onboarding, co-marketing decks, integration guides for channel partners and resellers.

## Naming

`<partner-or-program-name>.md`

Examples:
- `channel-partner-program-v1.md`
- `<partner-name>-integration-guide.md`
- `reseller-onboarding.md`

## Artifact types

- Partner program overview (tiers, benefits, requirements)
- Channel partner onboarding checklist
- Co-marketing playbooks
- Integration guides (how partner products connect to this product)
- Partner-specific collateral (joint one-pagers, case studies)
- Revenue-share / commission structures
- Partner portal content

## Template

```markdown
# <Partner Program Name>

**Type:** <reseller | integration | referral | co-sell>
**As-of:** YYYY-MM-DD

## Program Summary
<What the partner gets, what we get, what the customer gets.>

## Tiers / Structure
| Tier | Requirements | Benefits |
|---|---|---|
| ... | ... | ... |

## Onboarding Steps
1. ...
2. ...

## Co-Marketing Assets
- Joint one-pager: one-pagers/<file>.md
- Joint deck: decks/<file>.md
- Joint case study: case-studies/<file>.md

## Technical Integration (if applicable)
<Link to documents/architecture/ integration spec — not here>

## Contacts
- Partner lead: <name@email>
- Technical contact: <name@email>
- Co-marketing: <name@email>
```

## Rules

- Partner NDA / embargoed content under `.secrets/` (gitignored)
- Integration guide BODIES live in `documents/architecture/`; this folder holds only the **program** docs
