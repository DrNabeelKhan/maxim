---
name: L3.1 Healthcare Vertical
description: "Maxim L3 pack. Bundles: HIPAA + ISO 13485 + ISO 14971 + FHIR/HL7. Primary framework: ISO 14971 (medical-device risk management)."
business_outcome: "See documents/ledgers/MOAT_TRACKER.md for the registered moat row; purchase to activate."
primary_framework: "ISO 14971 (medical-device risk management)"
product_id: L3.1
pack_tier: L3
ships_with: v1.0.0
license: proprietary
---

# L3.1 Healthcare Vertical

> Copyright (c) 2026 iSystematic Inc. Maxim product. Separately licensed via Stripe.

## What this pack delivers

HIPAA + ISO 13485 + ISO 14971 + FHIR/HL7

## Primary framework

ISO 14971 (medical-device risk management) — applied across every output this pack produces. Framework mechanism named in the SKILL body below; anti-patterns registered in documents/ledgers/MOAT_TRACKER.md.

## Activation

This pack requires a valid license JWT. Purchase at https://maxim.isystematic.com/pricing. After checkout, Stripe webhook issues a JWT; the Cloudflare Worker validates locally on every tool call.

```
mxm-pack-engine activate --license <JWT-from-email>
```

Free tier (Starter) does not include this pack. See documents/guides/PACKS.md for full pricing and ADR-009 for pack architecture.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. Separately licensed via Stripe (ADR-011)._