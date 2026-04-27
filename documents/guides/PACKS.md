# Maxim Packs — the commercial catalog

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

---

## Free core, forever

The Maxim core framework is licensed under Business Source License 1.1 with a 4-year conversion to Apache 2.0. The core is free for non-pack production use today, and fully open-source in four years regardless of anything the Licensor decides later. Use it internally, use it with clients, fork it, ship it inside your own product. The only restriction is that you cannot resell a competing commercial pack catalog. That restriction is ratified by ADR-005.

**The free Starter tier is an Executable Contract (ADR-004).** It is not crippleware. It is the complete Maxim governance substrate with 90 agents, 34 skill domains, 37 slash commands, 64 behavioral frameworks, 47 MCP tools, and 4 free drift-detection watch classes. Packs layer specific enforcement and compounding intelligence on top of that substrate.

---

## Subscription tiers (monthly)

| Tier | Price | Position |
|---|---|---|
| **Starter** | $0 forever | Acquisition floor — 90 agents, 34 domains, 37 commands, 4 watch classes, CEO Automation, 10 framework stubs, MemPalace local file mode, basic compliance advisory. |
| **Pro Trial** | $0, 90 days auto-activated on install | Activation bridge — Starter + full 10 watch classes + 50 behavioral_audit/mo + 3 compliance frameworks (GDPR, SOC2, PIPEDA) + MemPalace semantic + ADR-010 rubric + 10 min/day voice + 20 brand overlays/mo. |
| **Solo (MOAT anchor)** | **$19.99/mo** | The behavioral intelligence specialist. Unlimited behavioral_audit, all 64 behavioral frameworks, nudge design, persuasion tools, TTM stage detection. No compliance depth, no brand/design tools, no team features, no overlays. |
| **Pro** | $39/mo | Solo + 14 compliance frameworks + full Proactive Watch + MemPalace semantic + brand overlay (20/mo). |
| **Professional** | $99/mo | Pro + full Brand & Design Pro (unlimited) + unlimited voice + priority support. |
| **Team** | $249/mo (5 seats) | Professional × 5 + shared MemPalace KG + team audit trails + cross-seat handoff. |

Annual billing on any paid tier: **2 months free** (17% effective discount).

---

## Vertical overlays (one-time, stackable on any paid tier)

| Overlay | Price | Regulatory scope |
|---|---|---|
| Healthcare | $249 | HIPAA + ISO 13485 + ISO 14971 + FHIR/HL7 |
| Legal | $199 | Attorney-client privilege + ethics walls |
| Fintech | $199 | PCI-DSS deep + FINTRAC + SOX + FDX |
| GovTech | $149 | FedRAMP + NIST 800-53 + Section 508 |

**Bundle discount:** any 2 overlays 20% off, any 3+ overlays 35% off. Applied at checkout.

Overlays are perpetually licensed for the version released at purchase. Updates within a major version are free. A major version upgrade is an operator decision, not an automatic charge.

---

## L1 capability packs (ADR-009 architecture layer)

The atomic moat layer. Each L1 pack anchors one behavioral framework and one mechanism. L1s are accessed through the subscription tiers above — buyers do not purchase L1s individually at v1.0.0.

| L1 pack | Primary framework | Unlocked at |
|---|---|---|
| L1.1 AI Governance | Prospect Theory (Kahneman & Tversky, 1979) | Pro+ |
| L1.2 MemPalace Pro | Cognitive Load Theory (Sweller, 1988) | Pro+ |
| L1.3 Proactive Watch | Signal Detection Theory (Green & Swets, 1966) | Pro+ |
| L1.4 Compliance Shield | COM-B (Michie et al., 2011) | Pro+ |
| L1.5 Brand & Design Pro | Dual Process Theory (Kahneman, 2011) | Professional+ |
| L1.6 Behavioral Intelligence | Fogg Behavior Model B=MAP (Fogg, 2009) | Solo+ |

Each pack ships with a SKILL.md authored against ADR-007 Behavioral Moat Framing Doctrine. The framework is named, its mechanism is stated, anti-patterns are catalogued, and scholarly critiques are acknowledged. The citation is the enforcement surface, not decoration.

---

## Deferred to v1.5+

- **Agency** — $599/mo, 20 seats, multi-tenant, priority support, overlay discount.
- **Enterprise** — custom pricing, SSO, SLA, on-prem option.

Large teams between v1.0.0 and v1.5 can engage via **`https://maxim.isystematic.com/contact`** for manual contracts.

---

## How to purchase

Pricing, catalog, and one-click purchase at https://maxim.isystematic.com. Purchase triggers a Stripe checkout. Successful payment triggers the Cloudflare Worker webhook, which issues an RS256 JWT that arrives in your inbox within sixty seconds. Activation is one command:

```
mxm-pack-engine activate --license <JWT-from-email>
```

The free core keeps running regardless of whether you purchase a pack. Packs extend the substrate. The substrate itself stays free forever.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
