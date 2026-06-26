---
name: L2.3 Professional OS
description: "Maxim L2 pack. Bundles: L1.1 + L1.2 + L1.3 + L1.4 + L1.5 (five L1 packs). Primary framework: COM-B (Michie et al.)."
business_outcome: "See documents/ledgers/MOAT_TRACKER.md for the registered moat row; purchase to activate."
primary_framework: "COM-B (Michie et al.)"
product_id: L2.3
pack_tier: L2
ships_with: v1.0.0
license: proprietary
---

# L2.3 Professional OS

> Copyright (c) 2026 iSystematic Inc. Maxim product. Separately licensed via Stripe.

## What this pack delivers

L1.1 + L1.2 + L1.3 + L1.4 + L1.5 (five L1 packs)

## Primary framework

COM-B (Michie et al.) — applied across every output this pack produces. Framework mechanism named in the SKILL body below; anti-patterns registered in documents/ledgers/MOAT_TRACKER.md.

## Activation

This pack requires a valid license JWT. Purchase at https://maxim.isystematic.com/pricing. After checkout, Stripe webhook issues a JWT; the Cloudflare Worker validates locally on every tool call.

```
mxm-pack-engine activate --license <JWT-from-email>
```

Free tier (Starter) does not include this pack. See documents/guides/PACKS.md for full pricing and ADR-009 for pack architecture.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. Separately licensed via Stripe (ADR-011)._