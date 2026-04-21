# ADR-011 — Stripe-primary payment processor

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** ADR-009 (pack architecture)

---

## Context

Maxim v1.0.0 ships with a paid tier. A payment processor is required. Two candidates were evaluated:

- **Stripe.** Market-leading, SCA-compliant, global, native webhook architecture, Canadian support for iSystematic Inc. (Manitoba). Higher per-transaction fees than some alternatives.
- **LemonSqueezy.** Merchant-of-record model (handles VAT / sales tax globally for the merchant), lower operational burden for a solo-operator product, but smaller brand recognition and fewer integrations.

The initial plan favored LemonSqueezy for tax-handling simplicity. A sprint (Sprint 2b, 2026-04-21) evaluated Stripe's webhook and JWT-issuance path end-to-end on a live Cloudflare Worker and confirmed the integration was production-ready for v1.0.0 launch.

---

## Decision

**Stripe is the primary payment processor for Maxim v1.0.0.** All 4 subscription tiers and 4 vertical overlays are configured in Stripe (test mode live; live mode key held for launch-day switchover). The Cloudflare Worker's `/webhook/stripe` route validates Stripe signatures via manual HMAC verification (Web Crypto, 5-minute timestamp tolerance) and issues RS256 JWTs on `checkout.session.completed` events.

LemonSqueezy integration code stays in the Worker codebase but is **dormant** until at least v1.0.1. The dual-processor architecture preserves the option to activate LemonSqueezy for specific tax jurisdictions without re-architecting the Worker.

---

## Rationale

Stripe clears two hurdles LemonSqueezy did not at decision time: (1) the $1 live smoke test validated the full chain (checkout → webhook → JWT → KV record → local verification) end-to-end in one session, and (2) iSystematic's existing Stripe account and tax setup for Manitoba made onboarding zero-effort. LemonSqueezy's merchant-of-record tax handling is genuinely useful, but at v1.0.0 revenue scale the simpler integration path wins.

The alternative — ship with both processors live on day one — doubles the support surface for no immediate revenue benefit. Keeping LemonSqueezy code in place but dormant preserves the option cheaply.

---

## Consequences

**Easier:** billing support (Stripe dashboard is familiar territory). Tax reporting for Manitoba (Stripe 1099-K equivalent is clean). Refund handling (one-click in the dashboard).

**Harder:** VAT collection in EU jurisdictions is iSystematic's responsibility at v1.0.0 (Stripe Tax can be toggled on later). Merchant-of-record benefits are deferred.

**Locks us into:** Stripe's fee structure for the BSL lifetime of v1.0.0 licenses unless the dual-processor architecture is activated. Migrating existing subscribers to a new processor is disruptive; new subscribers can be routed to an alternative processor without migration.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
