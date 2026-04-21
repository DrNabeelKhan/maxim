# catalogues/

> Product catalogues, feature matrices, capability lists for prospects and enterprise buyers.

## Naming

`<product-or-platform>-catalogue-vN.md`

Examples:
- `mxm-catalogue-v6.md`
- `enterprise-compliance-matrix-v2.md`
- `mcp-server-catalogue-v1.md`

## Artifact types to put here

- Master feature matrices (tier × capability tables)
- Capability catalogues (what the product can do, in buyer language)
- Integration catalogues (what the product connects to)
- Comparison matrices (us vs. alternatives)
- Module/add-on catalogues

## Template

```markdown
# <Product> Catalogue vN

**Audience:** <enterprise buyer | channel partner | analyst>
**As-of:** YYYY-MM-DD
**Product version:** vX.Y.Z

## Overview
<One-paragraph positioning. What this product is, for whom.>

## Capability Matrix

| Capability | Starter | Pro | Enterprise |
|---|---|---|---|
| <Capability> | ✅ | ✅ | ✅ |
| <Capability> |    | ✅ | ✅ |
| <Capability> |    |    | ✅ |

## Detailed Capability Descriptions

### <Capability Name>
<2–4 sentence buyer-language description. No jargon.>

## Integrations
<List of supported connectors, SDKs, APIs>

## Compliance / Certifications
<GDPR, SOC2, HIPAA, etc. from compliance frameworks the product actually covers>

## Pricing / Tiers
<Reference the pricing page; do not hard-code prices that may change>

## Related artifacts
- Decks: decks/<relevant>.md
- One-pager: one-pagers/<relevant>.md
- Case studies: case-studies/<relevant>.md
```

## Rules

- Catalogues must match actual product capability (contract with customer). Drift = bug.
- Update version number on every material change
- Cross-link to case studies and one-pagers
