// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Maxim License API — Cloudflare Worker (dual-processor: Stripe + LemonSqueezy)
//
// Issues RS256 JWT pack licenses in response to Stripe or LemonSqueezy purchase
// webhooks. Machine-binding per ADR-005 Layer 4. OWNER-1 bypass per ADR-005 § Layer 3.
//
// Stripe is the primary processor for Maxim v1.0.0 per D-037. LemonSqueezy endpoint
// stays wired but inactive until store approval lands (v1.0.1 or v1.1). Both paths
// produce identical JWT shape; pack-engine is processor-agnostic.
//
// Routes:
//   POST /webhook/stripe         — Stripe webhook handler (checkout.session.completed, customer.subscription.deleted)
//   POST /webhook/lemonsqueezy   — LemonSqueezy webhook handler (order_created, subscription_*)
//   POST /license/issue          — Manual license issuance (admin only — bearer auth)
//   POST /license/validate       — Validate JWT (optional; pack-engine does local validation too)
//   POST /license/revoke         — Admin revocation (bearer auth)
//   GET  /public-key             — Return JWT public key for pack-engine verification
//   GET  /health                 — Health check
//
// Env vars (bound at deploy time, NEVER in code):
//   STRIPE_API_KEY                — Stripe secret or restricted key (sk_test_ / sk_live_ / rk_live_)
//   STRIPE_WEBHOOK_SECRET         — Stripe webhook signing secret (whsec_...)
//   LEMONSQUEEZY_API_KEY          — LemonSqueezy account API key
//   LEMONSQUEEZY_WEBHOOK_SECRET   — LemonSqueezy webhook signing secret
//   JWT_SIGNING_KEY_PRIVATE       — RS256 private key PEM
//   JWT_SIGNING_KEY_PUBLIC        — RS256 public key PEM
//   ADMIN_API_KEY                 — Bearer token for admin endpoints
//   OWNER_PUBLIC_KEYS_JSON        — JSON array of owner .pub PEMs
//
// KV namespace LICENSES: license records keyed by license_id

// JWT library: @tsndr/cloudflare-worker-jwt v2 exports sign/verify/decode as top-level functions.
// Prior import pattern was incorrect (used jose-library identifiers); BUG-002 fixed 2026-04-21.
import jwt from "@tsndr/cloudflare-worker-jwt";
import { STRIPE_PRODUCT_MAP } from "./stripe-product-map";

export interface Env {
    // Vars
    MXM_VERSION_MIN: string;
    JWT_ISSUER: string;
    JWT_AUDIENCE: string;
    JWT_TTL_SECONDS: string;
    ENVIRONMENT: string;
    // Stripe secrets (primary processor per D-037)
    STRIPE_API_KEY: string;
    STRIPE_WEBHOOK_SECRET: string;
    // LemonSqueezy secrets (secondary processor; inactive at v1.0.0 launch, wired for v1.0.1+)
    LEMONSQUEEZY_API_KEY: string;
    LEMONSQUEEZY_WEBHOOK_SECRET: string;
    // JWT signing + admin secrets
    JWT_SIGNING_KEY_PRIVATE: string;
    JWT_SIGNING_KEY_PUBLIC: string;
    ADMIN_API_KEY: string;
    OWNER_PUBLIC_KEYS_JSON: string;
    // KV binding (add after `wrangler kv namespace create LICENSES`)
    LICENSES?: KVNamespace;
}

// ── Variant ID → pack capability grant map (mirrors lemonsqueezy-variant-map.json) ───
// Keep in sync with mxm-packs-source/config/lemonsqueezy-variant-map.json
const VARIANT_MAP: Record<string, { product_id: string; grants: string[]; billing: "monthly" | "annual" | "one_time" }> = {
    // Layer 1 — Capabilities
    "1551385": { product_id: "L1.1", billing: "monthly", grants: ["ai-governance", "audit-trail", "confidence-tagging", "ethical-guidelines", "eu-ai-act-basic"] },
    "1551380": { product_id: "L1.2", billing: "monthly", grants: ["mempalace-full", "wiki-ingest", "wiki-query", "wiki-lint", "wiki-explore", "cross-session-memory", "ttm-stage-detection", "session-milestones", "mxm-recall"] },
    "1551516": { product_id: "L1.3", billing: "monthly", grants: ["watch-class-5-mcp-health", "watch-class-6-skill-gap", "watch-class-7-moat-drift", "watch-class-8-brand-drift", "watch-class-9-compliance-drift", "watch-class-10-behavioral-framework-coverage", "watch-class-11-external-boundary-drift", "watch-class-12-behavioral-moat-drift"] },
    "1551370": { product_id: "L1.4", billing: "monthly", grants: ["compliance-gdpr", "compliance-pipeda", "compliance-pci-dss", "compliance-soc2", "compliance-hipaa", "compliance-uae-pdpl", "compliance-casl", "compliance-fintrac", "compliance-eu-ai-act", "compliance-iso-27001", "compliance-iso-13485", "compliance-iso-14971", "compliance-nist-csf", "compliance-wcag-21", "cso-auto-loop"] },
    "1551390": { product_id: "L1.5", billing: "monthly", grants: [".brand-foundation-personal", ".brand-foundation-startups", "design-system", "banner-design", "ai-media-generation-full", "cinematic-styles-15", "ui-ux", "design-resources"] },
    "1551379": { product_id: "L1.6", billing: "monthly", grants: ["behavioral-frameworks-78", "behavioral-audit", "nudge-design", "persuasion-system", "behavioral-moat-deep-integration"] },
    // Layer 2 — Persona Bundles
    "1551386": { product_id: "L2.1", billing: "monthly", grants: ["bundle:founder-os"] },
    "1551388": { product_id: "L2.2", billing: "monthly", grants: ["bundle:growth-stack"] },
    "1551393": { product_id: "L2.3", billing: "monthly", grants: ["bundle:professional-os", "super-user-mode", "voice-mode"] },
    "1551410": { product_id: "L2.4", billing: "monthly", grants: ["bundle:agency-all-in", "super-user-mode", "voice-mode", "multi-tenant", "future-packs-auto-included", "priority-support"] },
    // Layer 3 — Verticals
    "1551382": { product_id: "L3.1", billing: "one_time", grants: ["vertical:healthcare", "hipaa-deep", "iso-13485", "iso-14971", "fhir-hl7-interop", "clinical-decision-support", "patient-consent-flows", "medical-terminology"] },
    "1551406": { product_id: "L3.2", billing: "one_time", grants: ["vertical:legal", "attorney-client-privilege", "contract-templates", "ethics-walls", "conflict-checking", "legaltech-compliance"] },
    "1551383": { product_id: "L3.3", billing: "one_time", grants: ["vertical:fintech", "pci-dss-deep", "fintrac", "kyc-aml", "open-banking-fdx", "sox-controls", "financial-modeling"] },
    "1551384": { product_id: "L3.4", billing: "one_time", grants: ["vertical:govtech", "fedramp", "nist-800-53", "section-508-strict", "rfp-templates", "procurement-frameworks"] },
};

// ── Route dispatch ───────────────────────────────────────────────────────────
export default {
    async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
        const url = new URL(request.url);
        const path = url.pathname;

        try {
            if (path === "/health" && request.method === "GET") return health();
            if (path === "/public-key" && request.method === "GET") return publicKey(env);
            if (path === "/webhook/stripe" && request.method === "POST") return stripeWebhook(request, env);
            if (path === "/webhook/lemonsqueezy" && request.method === "POST") return lemonsqueezyWebhook(request, env);
            if (path === "/license/issue" && request.method === "POST") return licenseIssue(request, env);
            if (path === "/license/validate" && request.method === "POST") return licenseValidate(request, env);
            if (path === "/license/revoke" && request.method === "POST") return licenseRevoke(request, env);
            return new Response("Not Found", { status: 404 });
        } catch (err: any) {
            console.error("Unhandled error:", err);
            return json({ error: "internal_error", message: env.ENVIRONMENT === "development" ? err.message : "See logs" }, 500);
        }
    },
};

// ── Route handlers ───────────────────────────────────────────────────────────

function health(): Response {
    return json({ status: "ok", service: "maxim-license-api", version: "0.1.0-alpha.1" });
}

async function publicKey(env: Env): Promise<Response> {
    return new Response(env.JWT_SIGNING_KEY_PUBLIC, {
        status: 200,
        headers: { "Content-Type": "application/x-pem-file" },
    });
}

async function lemonsqueezyWebhook(request: Request, env: Env): Promise<Response> {
    // Verify HMAC signature per LemonSqueezy docs
    const signature = request.headers.get("X-Signature");
    if (!signature) return json({ error: "missing_signature" }, 401);

    const rawBody = await request.text();
    const valid = await verifyLemonSqueezySignature(rawBody, signature, env.LEMONSQUEEZY_WEBHOOK_SECRET);
    if (!valid) return json({ error: "invalid_signature" }, 401);

    const payload = JSON.parse(rawBody);
    const eventName = payload.meta?.event_name;

    // Events we care about
    if (eventName === "order_created" || eventName === "subscription_created") {
        return await handleOrderCreated(payload, env);
    }
    if (eventName === "subscription_cancelled" || eventName === "subscription_expired") {
        return await handleSubscriptionCancelled(payload, env);
    }

    // Other events: ack but no-op
    return json({ received: true, event: eventName });
}

async function handleOrderCreated(payload: any, env: Env): Promise<Response> {
    const variantId = String(payload.data?.attributes?.first_order_item?.variant_id || payload.data?.attributes?.variant_id || "");
    const customerEmail = payload.data?.attributes?.user_email || payload.data?.attributes?.customer_email;
    const orderId = payload.data?.id;

    const mapping = VARIANT_MAP[variantId];
    if (!mapping) {
        console.warn("Unknown variant_id:", variantId);
        return json({ error: "unknown_variant", variant_id: variantId }, 400);
    }

    // TODO (Sprint 2b): issue JWT, store in KV, email to customer via LemonSqueezy API
    const licenseJwt = await issueLicense({
        email: customerEmail,
        product_id: mapping.product_id,
        grants: mapping.grants,
        billing: mapping.billing,
        order_id: orderId,
    }, env);

    // Store license record in KV (if binding exists)
    if (env.LICENSES) {
        await env.LICENSES.put(`license:${orderId}`, JSON.stringify({
            email: customerEmail,
            product_id: mapping.product_id,
            variant_id: variantId,
            grants: mapping.grants,
            issued_at: new Date().toISOString(),
            status: "active",
        }));
    }

    return json({
        ok: true,
        license_id: orderId,
        product_id: mapping.product_id,
        jwt: licenseJwt,  // in production, email this instead of returning in webhook response
    });
}

async function handleSubscriptionCancelled(payload: any, env: Env): Promise<Response> {
    const orderId = payload.data?.id;
    if (env.LICENSES && orderId) {
        const existing = await env.LICENSES.get(`license:${orderId}`);
        if (existing) {
            const record = JSON.parse(existing);
            record.status = "cancelled";
            record.cancelled_at = new Date().toISOString();
            await env.LICENSES.put(`license:${orderId}`, JSON.stringify(record));
        }
    }
    return json({ ok: true, action: "license_cancelled", order_id: orderId });
}

// ── Stripe webhook (primary processor per D-037) ─────────────────────────────

async function stripeWebhook(request: Request, env: Env): Promise<Response> {
    const signatureHeader = request.headers.get("Stripe-Signature");
    if (!signatureHeader) return json({ error: "missing_signature" }, 401);

    const rawBody = await request.text();
    const valid = await verifyStripeSignature(rawBody, signatureHeader, env.STRIPE_WEBHOOK_SECRET);
    if (!valid) return json({ error: "invalid_signature" }, 401);

    const event = JSON.parse(rawBody);
    const type = event.type;

    if (type === "checkout.session.completed") {
        return await handleStripeCheckoutCompleted(event.data.object, env);
    }
    if (type === "customer.subscription.deleted") {
        return await handleStripeSubscriptionDeleted(event.data.object, env);
    }
    if (type === "invoice.payment_failed") {
        return await handleStripePaymentFailed(event.data.object, env);
    }

    // Other events: acknowledge but no-op
    return json({ received: true, event: type });
}

async function handleStripeCheckoutCompleted(session: any, env: Env): Promise<Response> {
    // Stripe session fields:
    //   id                 — Session ID (used as license_id)
    //   customer_email     — email (or customer_details.email)
    //   client_reference_id — optional caller-set ref
    //   metadata           — custom fields we set during session creation
    //   line_items         — items purchased (only if expanded; for MVP we use metadata.tier_id)
    //   mode               — "subscription" | "payment"
    //   subscription       — subscription ID if mode=subscription
    //   payment_status     — "paid" | "unpaid" | "no_payment_required"

    if (session.payment_status !== "paid") {
        return json({ received: true, ignored: "not_paid", payment_status: session.payment_status });
    }

    // Tier ID must be set as metadata.tier_id during checkout session creation.
    const tierId = session.metadata?.tier_id;
    if (!tierId) {
        console.warn("Stripe checkout missing metadata.tier_id:", session.id);
        return json({ error: "missing_tier_id", session_id: session.id }, 400);
    }

    const mapping = STRIPE_PRODUCT_MAP[tierId];
    if (!mapping) {
        console.warn("Unknown Stripe tier_id:", tierId);
        return json({ error: "unknown_tier", tier_id: tierId }, 400);
    }

    const customerEmail = session.customer_email || session.customer_details?.email;
    const licenseId = session.id; // stable across the session lifecycle

    const licenseJwt = await issueLicense({
        email: customerEmail,
        product_id: mapping.product_id,
        grants: mapping.grants,
        billing: mapping.billing,
        order_id: licenseId,
    }, env);

    if (env.LICENSES) {
        await env.LICENSES.put(`license:${licenseId}`, JSON.stringify({
            email: customerEmail,
            product_id: mapping.product_id,
            tier_id: tierId,
            stripe_session_id: session.id,
            stripe_subscription_id: session.subscription || null,
            stripe_customer_id: session.customer || null,
            grants: mapping.grants,
            billing: mapping.billing,
            processor: "stripe",
            issued_at: new Date().toISOString(),
            status: "active",
        }));
    }

    return json({
        ok: true,
        license_id: licenseId,
        product_id: mapping.product_id,
        jwt: licenseJwt, // in production, email this separately; webhook response is for Stripe ack only
    });
}

async function handleStripeSubscriptionDeleted(subscription: any, env: Env): Promise<Response> {
    const subscriptionId = subscription.id;
    if (!env.LICENSES || !subscriptionId) return json({ ok: true, action: "no_kv_binding" });

    // Find license by stripe_subscription_id via list (acceptable for low volume; optimize later)
    // For MVP, assume license_id == checkout session id, and subscription_id is stored in record.
    // Scan approach OK for launch-week volumes; Phase S6+ migrate to secondary index.
    const list = await env.LICENSES.list({ prefix: "license:" });
    for (const key of list.keys) {
        const value = await env.LICENSES.get(key.name);
        if (!value) continue;
        const record = JSON.parse(value);
        if (record.stripe_subscription_id === subscriptionId) {
            record.status = "cancelled";
            record.cancelled_at = new Date().toISOString();
            await env.LICENSES.put(key.name, JSON.stringify(record));
            return json({ ok: true, action: "license_cancelled", license_id: key.name.replace("license:", "") });
        }
    }
    return json({ ok: true, action: "license_not_found", subscription_id: subscriptionId });
}

async function handleStripePaymentFailed(invoice: any, env: Env): Promise<Response> {
    // For MVP: acknowledge + log. Grace period logic (dunning) in Phase S6+.
    console.warn("Stripe payment failed:", { invoice_id: invoice.id, subscription: invoice.subscription, customer: invoice.customer });
    return json({ received: true, action: "payment_failed_logged", invoice_id: invoice.id });
}

async function licenseIssue(request: Request, env: Env): Promise<Response> {
    if (!isAdminAuthorized(request, env)) return json({ error: "unauthorized" }, 401);
    const body: any = await request.json();
    const jwt = await issueLicense(body, env);
    return json({ jwt });
}

async function licenseValidate(request: Request, env: Env): Promise<Response> {
    const body: any = await request.json();
    const token = body.token;
    if (!token) return json({ error: "missing_token" }, 400);

    try {
        // @tsndr/cloudflare-worker-jwt v2 API: verify returns boolean, decode extracts payload.
        const isValid = await jwt.verify(token, env.JWT_SIGNING_KEY_PUBLIC, { algorithm: "RS256" });
        if (!isValid) return json({ valid: false, error: "signature_invalid" }, 200);

        const decoded = jwt.decode(token);
        const claims: any = decoded.payload || {};

        // Application-level claim checks
        const now = Math.floor(Date.now() / 1000);
        if (claims.exp && claims.exp < now) return json({ valid: false, error: "expired" }, 200);
        if (claims.iss !== env.JWT_ISSUER) return json({ valid: false, error: "wrong_issuer" }, 200);
        if (claims.aud !== env.JWT_AUDIENCE && !(Array.isArray(claims.aud) && claims.aud.includes(env.JWT_AUDIENCE))) {
            return json({ valid: false, error: "wrong_audience" }, 200);
        }

        return json({ valid: true, claims });
    } catch (err: any) {
        return json({ valid: false, error: err.message }, 200);
    }
}

async function licenseRevoke(request: Request, env: Env): Promise<Response> {
    if (!isAdminAuthorized(request, env)) return json({ error: "unauthorized" }, 401);
    const body: any = await request.json();
    const orderId = body.order_id;
    if (!orderId || !env.LICENSES) return json({ error: "missing_order_id_or_kv" }, 400);

    const existing = await env.LICENSES.get(`license:${orderId}`);
    if (!existing) return json({ error: "not_found" }, 404);

    const record = JSON.parse(existing);
    record.status = "revoked";
    record.revoked_at = new Date().toISOString();
    record.revoked_reason = body.reason || "admin_action";
    await env.LICENSES.put(`license:${orderId}`, JSON.stringify(record));

    return json({ ok: true, order_id: orderId, status: "revoked" });
}

// ── Helpers ──────────────────────────────────────────────────────────────────

async function issueLicense(input: {
    email?: string;
    product_id: string;
    grants: string[];
    billing: string;
    order_id: string;
    machine_fingerprint?: string;
}, env: Env): Promise<string> {
    const ttlSeconds = parseInt(env.JWT_TTL_SECONDS, 10);
    const now = Math.floor(Date.now() / 1000);
    const payload = {
        iss: env.JWT_ISSUER,
        aud: env.JWT_AUDIENCE,
        sub: input.email || "anonymous",
        iat: now,
        exp: now + ttlSeconds,
        product_id: input.product_id,
        grants: input.grants,
        billing: input.billing,
        order_id: input.order_id,
        machine_fingerprint: input.machine_fingerprint, // optional; pack-engine binds on first use
        mxm_version_min: env.MXM_VERSION_MIN,
    };
    // @tsndr/cloudflare-worker-jwt v2 accepts PEM string directly when RS256.
    return await jwt.sign(payload, env.JWT_SIGNING_KEY_PRIVATE, { algorithm: "RS256" });
}

async function verifyLemonSqueezySignature(rawBody: string, signatureHeader: string, secret: string): Promise<boolean> {
    // LemonSqueezy uses HMAC-SHA256 signature
    const encoder = new TextEncoder();
    const key = await crypto.subtle.importKey(
        "raw",
        encoder.encode(secret),
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["sign"],
    );
    const sig = await crypto.subtle.sign("HMAC", key, encoder.encode(rawBody));
    const expected = Array.from(new Uint8Array(sig))
        .map((b) => b.toString(16).padStart(2, "0"))
        .join("");
    // Constant-time comparison
    return constantTimeEquals(expected, signatureHeader);
}

// Stripe signature verification — manual Web Crypto HMAC per D-037 Option B.
// Stripe-Signature header format: `t=<timestamp>,v1=<sig>[,v0=<old-sig>]`
// Signature payload: `<timestamp>.<rawBody>` signed with webhook secret via HMAC-SHA256.
// Timestamp tolerance: 5 minutes (300s) to prevent replay attacks.
// Reference: https://stripe.com/docs/webhooks#verify-manually
async function verifyStripeSignature(rawBody: string, signatureHeader: string, secret: string): Promise<boolean> {
    const tolerance = 300; // 5 minutes

    // Parse `t=<timestamp>,v1=<sig>`
    const parts = signatureHeader.split(",").reduce<Record<string, string>>((acc, part) => {
        const [k, v] = part.split("=");
        if (k && v) acc[k.trim()] = v.trim();
        return acc;
    }, {});

    const timestampStr = parts["t"];
    const signatureV1 = parts["v1"];
    if (!timestampStr || !signatureV1) return false;

    const timestamp = parseInt(timestampStr, 10);
    if (isNaN(timestamp)) return false;

    // Replay protection: reject if outside tolerance window
    const now = Math.floor(Date.now() / 1000);
    if (Math.abs(now - timestamp) > tolerance) return false;

    // Compute expected signature: HMAC-SHA256 over `<timestamp>.<rawBody>`
    const encoder = new TextEncoder();
    const signedPayload = `${timestampStr}.${rawBody}`;
    const key = await crypto.subtle.importKey(
        "raw",
        encoder.encode(secret),
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["sign"],
    );
    const sig = await crypto.subtle.sign("HMAC", key, encoder.encode(signedPayload));
    const expected = Array.from(new Uint8Array(sig))
        .map((b) => b.toString(16).padStart(2, "0"))
        .join("");

    // Constant-time comparison to the v1 signature
    return constantTimeEquals(expected, signatureV1);
}

function constantTimeEquals(a: string, b: string): boolean {
    if (a.length !== b.length) return false;
    let result = 0;
    for (let i = 0; i < a.length; i++) result |= a.charCodeAt(i) ^ b.charCodeAt(i);
    return result === 0;
}

function isAdminAuthorized(request: Request, env: Env): boolean {
    const auth = request.headers.get("Authorization");
    if (!auth?.startsWith("Bearer ")) return false;
    const token = auth.slice("Bearer ".length);
    return constantTimeEquals(token, env.ADMIN_API_KEY);
}

function json(body: any, status: number = 200): Response {
    return new Response(JSON.stringify(body), {
        status,
        headers: { "Content-Type": "application/json" },
    });
}
