// Event ownership for a SHARED Stripe account.
//
// Maxim and nabeelkhan.com bill through the same Stripe account (same merchant
// of record, iSystematic Inc.). Stripe filters webhook deliveries by event TYPE
// only, never by product or price, so this Worker receives every
// checkout.session.completed in the account, book sales included.
//
// Why this module exists rather than a price-id lookup: `line_items` is not
// expanded in the webhook payload (see the field notes in index.ts), so deciding
// ownership from the price would cost an extra Stripe API round-trip on every
// foreign event. Stamping a marker at session creation is free and synchronous.
//
// The failure that motivated this: an unmarked session hit `missing_tier_id` and
// returned 400. Stripe reads non-2xx as failed delivery, retries with backoff for
// ~3 days, and disables endpoints that keep failing. A nabeelkhan.com book sale
// could therefore disable Maxim license issuance, and the first symptom would be
// a support email, not an alert.

import { STRIPE_PRODUCT_MAP } from "./stripe-product-map";

/** Metadata key stamped on every Maxim-originated Stripe object. */
export const MXM_MARKER_KEY = "mxm";

/** Metadata value stamped on every Maxim-originated Stripe object. */
export const MXM_MARKER_VALUE = "1";

/**
 * - `maxim`   — ours, process normally.
 * - `foreign` — definitely not ours: acknowledge with 200 and do nothing. A 200
 *               stops Stripe retrying, which is the whole point.
 * - `unknown` — shape we cannot judge. Fail loud rather than silently drop a
 *               real Maxim purchase; a 400 on a genuinely broken Maxim event is
 *               the alert we want.
 */
export type Ownership = "maxim" | "foreign" | "unknown";

/**
 * Every place a Maxim marker can legitimately live, for the object shapes this
 * endpoint receives.
 *
 * This returns ALL candidates rather than the first match, and that is
 * load-bearing. A real invoice carries its OWN `metadata` (almost always `{}`)
 * alongside `subscription_details.metadata`, where the marker actually is. A
 * first-match lookup reads the empty one, calls a genuine Maxim invoice foreign,
 * and silently stops dunning alerts. Pinned by regression tests.
 */
function candidateMetadata(obj: any): Array<Record<string, unknown>> {
    if (!obj || typeof obj !== "object") return [];
    const out: Array<Record<string, unknown>> = [];
    const push = (m: unknown) => {
        if (m && typeof m === "object") out.push(m as Record<string, unknown>);
    };
    push(obj.metadata);                       // checkout.session, charge, invoice's own
    push(obj.subscription_details?.metadata); // invoice → subscription metadata
    push(obj.lines?.data?.[0]?.metadata);     // invoice line item
    return out;
}

/** True when the object has a metadata field at all, even an empty one. */
function hasAnyMetadataField(obj: any): boolean {
    if (!obj || typeof obj !== "object") return false;
    if ("metadata" in obj && obj.metadata !== null && typeof obj.metadata === "object") return true;
    if (obj.subscription_details?.metadata) return true;
    if (obj.lines?.data?.[0]?.metadata) return true;
    return false;
}

/**
 * Decide whether a Stripe webhook object originated from Maxim checkout.
 * Pure: inspects only the object passed in, mutates nothing, no I/O.
 */
export function classifyOwnership(obj: any): Ownership {
    const candidates = candidateMetadata(obj);

    // No metadata anywhere — not a shape we stamped or recognise. Fail loud.
    if (!hasAnyMetadataField(obj)) return "unknown";

    // Marker on ANY candidate wins.
    for (const m of candidates) {
        if (m[MXM_MARKER_KEY] === MXM_MARKER_VALUE) return "maxim";
    }

    // Grandfather clause. Sessions created before the marker shipped carry
    // `tier_id` and nothing else, and the subscriptions they created keep
    // billing (and cancelling, and failing) for months afterwards. A KNOWN tier
    // is proof enough. An unknown tier is not: a foreign event that happens to
    // use a `tier_id` key must not be adopted.
    for (const m of candidates) {
        const legacyTier = m.tier_id;
        if (typeof legacyTier === "string" && Object.prototype.hasOwnProperty.call(STRIPE_PRODUCT_MAP, legacyTier)) {
            return "maxim";
        }
    }

    // Metadata is present and carries no Maxim signal anywhere. This is the
    // nabeelkhan.com book sale, and `{}` counts: Stripe always sends metadata,
    // empty when unset.
    return "foreign";
}

/**
 * Stripe Checkout Session params that stamp the marker, as [key, value] pairs.
 *
 * The marker has to land on three objects, because the events that reference it
 * arrive at different times and carry different shapes:
 *   - session          → checkout.session.completed, immediately
 *   - subscription     → customer.subscription.deleted / invoice.payment_failed,
 *                        potentially months later
 *   - payment intent   → charge.refunded (a charge inherits payment-intent
 *                        metadata, NOT session metadata)
 *
 * Mode matters: Stripe rejects `payment_intent_data` on subscription-mode
 * sessions and `subscription_data` on payment-mode sessions.
 */
export function markerParams(mode: "payment" | "subscription"): Array<[string, string]> {
    const pairs: Array<[string, string]> = [[`metadata[${MXM_MARKER_KEY}]`, MXM_MARKER_VALUE]];
    if (mode === "subscription") {
        pairs.push([`subscription_data[metadata][${MXM_MARKER_KEY}]`, MXM_MARKER_VALUE]);
    } else {
        pairs.push([`payment_intent_data[metadata][${MXM_MARKER_KEY}]`, MXM_MARKER_VALUE]);
    }
    return pairs;
}
