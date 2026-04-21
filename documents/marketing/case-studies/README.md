# case-studies/

> Customer success stories, before/after metrics, testimonials. Primary social-proof asset.

## Naming

`<customer-slug>-<year>.md`

Examples:
- `acme-corp-2026.md`
- `fixit-adoption-2026.md`
- `iqra-enterprise-2026.md`

## Artifact types

- Full-length case studies (1–3 pages)
- Customer quote cards
- Metric-only success snapshots
- Video transcript + embed references

## Template

```markdown
# <Customer Name> Case Study

**Industry:** <Healthcare | SaaS | E-comm | ...>
**Size:** <# employees | ARR | volume>
**Used since:** <month YYYY>
**Product tier:** <Starter | Pro | Enterprise>
**Status:** <Draft | Customer-Approved | Published>
**Published:** YYYY-MM-DD

## The challenge
<1–2 paragraphs. What pain brought them to us.>

## The solution
<1–2 paragraphs. How our product solved it. Plain language, outcomes over features.>

## Results
- <Metric>: <Before> → <After>  (<% improvement>)
- <Metric>: <Before> → <After>
- <Metric>: <Before> → <After>

## In their words
> "<Customer quote>" — <Name, Title, Company>

## Products referenced
<Tags for filtering on the website — maxim, voice-mode, compliance, etc.>

## Approval trail
- Draft sent: YYYY-MM-DD
- Customer approved: YYYY-MM-DD
- Legal cleared: YYYY-MM-DD
```

## Rules

- **No case study is published without written customer approval.** Track in the approval trail.
- Draft case studies live in `.secrets/` until approved, then move to this folder root.
- Metrics must be verifiable — prefer actual numbers over percentages when possible.
- Anonymized case studies are OK but labeled clearly (e.g., `anonymous-healthcare-company-2026.md`).
