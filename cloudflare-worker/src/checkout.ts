// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)
//
// Stripe Checkout Session creation.
//
// Flow:
//   1. Landing page /checkout/[tier] POSTs {tier_id, email?} to /checkout/session
//   2. Worker looks up the Stripe price ID for that tier
//   3. Worker calls Stripe API /v1/checkout/sessions with metadata.tier_id
//   4. Worker returns {url} — the Stripe-hosted checkout URL
//   5. Landing page redirects to that URL
//   6. User pays on Stripe; Stripe fires checkout.session.completed webhook
//   7. Existing handleStripeCheckoutCompleted issues JWT + emails sales
//
// CORS origin matches the landing-page domain. Rate-limit by IP to prevent abuse.

import { TIER_PRICE_IDS } from "./stripe-product-map";

type CheckoutEnv = {
    STRIPE_API_KEY: string;
    RATE_LIMIT?: KVNamespace;
    ENVIRONMENT?: string;
};

const SUCCESS_URL = "https://maxim.isystematic.com/checkout/success?session_id={CHECKOUT_SESSION_ID}";
const CANCEL_URL = "https://maxim.isystematic.com/pricing";
const RATE_LIMIT_WINDOW = 3600;
const RATE_LIMIT_MAX = 20; // more generous than /contact; legitimate users click multiple times

type CheckoutBody = { tier_id?: string; email?: string };

export async function handleCheckoutSession(request: Request, env: CheckoutEnv): Promise<Response> {
    if (request.method !== "POST") return cors({ error: "method_not_allowed" }, 405, request);

    const ip = request.headers.get("cf-connecting-ip") || "0.0.0.0";

    // Rate-limit (separate counter from /contact)
    if (env.RATE_LIMIT) {
        const key = `checkout:${ip}`;
        const raw = await env.RATE_LIMIT.get(key);
        const count = raw ? parseInt(raw, 10) : 0;
        if (count >= RATE_LIMIT_MAX) {
            return cors({ error: "rate_limited", retry_after_seconds: RATE_LIMIT_WINDOW }, 429, request);
        }
        await env.RATE_LIMIT.put(key, String(count + 1), { expirationTtl: RATE_LIMIT_WINDOW });
    }

    let body: CheckoutBody;
    try {
        body = await request.json();
    } catch {
        return cors({ error: "invalid_json" }, 400, request);
    }

    const tierId = (body.tier_id || "").trim();
    if (!tierId || !TIER_PRICE_IDS[tierId]) {
        return cors({ error: "invalid_tier", allowed: Object.keys(TIER_PRICE_IDS) }, 400, request);
    }

    const { price_id, mode } = TIER_PRICE_IDS[tierId];

    // Build Stripe Checkout Session via the REST API (no SDK needed)
    const params = new URLSearchParams();
    params.set("mode", mode);
    params.set("line_items[0][price]", price_id);
    params.set("line_items[0][quantity]", "1");
    params.set("success_url", SUCCESS_URL);
    params.set("cancel_url", CANCEL_URL);
    params.set("metadata[tier_id]", tierId);
    params.set("client_reference_id", `${ip}:${Date.now()}`);
    if (body.email) {
        params.set("customer_email", body.email);
    }
    if (mode === "subscription") {
        params.set("subscription_data[metadata][tier_id]", tierId);
        params.set("allow_promotion_codes", "true");
    }

    try {
        const stripeRes = await fetch("https://api.stripe.com/v1/checkout/sessions", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${env.STRIPE_API_KEY}`,
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: params.toString(),
        });
        const data: any = await stripeRes.json();

        if (!stripeRes.ok) {
            console.error("Stripe checkout create failed:", { status: stripeRes.status, error: data?.error });
            return cors({
                error: "stripe_error",
                message: data?.error?.message || "Could not create checkout session",
                type: data?.error?.type,
            }, 502, request);
        }

        return cors({ ok: true, url: data.url, session_id: data.id }, 200, request);
    } catch (err: any) {
        console.error("Checkout network error:", err);
        return cors({ error: "network_error", message: String(err) }, 502, request);
    }
}

export function handleCheckoutPreflight(request: Request): Response {
    return new Response(null, {
        status: 204,
        headers: {
            "Access-Control-Allow-Origin": corsOrigin(request),
            "Access-Control-Allow-Methods": "POST, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Max-Age": "86400",
        },
    });
}

function cors(body: unknown, status: number, request?: Request): Response {
    return new Response(JSON.stringify(body), {
        status,
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": corsOrigin(request),
            "Access-Control-Allow-Methods": "POST, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
        },
    });
}

function corsOrigin(request?: Request): string {
    if (!request) return "https://maxim.isystematic.com";
    const origin = request.headers.get("origin") || "";
    const allowed = new Set([
        "https://maxim.isystematic.com",
        "https://www.maxim.isystematic.com",
        "http://localhost:3000",
    ]);
    return allowed.has(origin) ? origin : "https://maxim.isystematic.com";
}
