import { describe, it, expect } from "vitest";
import {
    MXM_MARKER_KEY,
    MXM_MARKER_VALUE,
    classifyOwnership,
    markerParams,
} from "./event-ownership";

// Context: Maxim and nabeelkhan.com share one Stripe account (same merchant of
// record, iSystematic Inc.). Stripe filters webhook deliveries by event TYPE
// only, never by product or price, so the Maxim endpoint receives every
// checkout.session.completed in the account, including book sales.
//
// Before this module, a foreign session hit `missing_tier_id` and returned 400.
// Stripe reads non-2xx as failed delivery, retries with backoff for ~3 days, and
// disables endpoints that keep failing. A nabeelkhan.com sale could therefore
// disable Maxim license issuance. These tests pin the classification that
// prevents it.

const marker = { [MXM_MARKER_KEY]: MXM_MARKER_VALUE };

describe("classifyOwnership", () => {
    describe("maxim — events we must process", () => {
        it("classifies a marked session as maxim", () => {
            expect(classifyOwnership({ metadata: { ...marker, tier_id: "solo" } })).toBe("maxim");
        });

        it("classifies a marked object as maxim even with no tier_id", () => {
            // charge.refunded carries the marker via payment_intent_data but no tier
            expect(classifyOwnership({ metadata: marker })).toBe("maxim");
        });

        it("grandfathers a pre-marker session carrying a known tier_id", () => {
            // Sessions created before this change have tier_id but no marker.
            // Subscriptions from those sessions keep billing for months.
            expect(classifyOwnership({ metadata: { tier_id: "pro-annual" } })).toBe("maxim");
        });

        it("reads the marker from subscription_details.metadata (invoice shape)", () => {
            expect(classifyOwnership({ subscription_details: { metadata: marker } })).toBe("maxim");
        });

        it("finds the marker on a REAL invoice, which also has its own empty metadata", () => {
            // Regression: a real invoice carries BOTH `metadata: {}` (the invoice's
            // own, almost always empty) AND `subscription_details.metadata` (the
            // subscription's, where our marker lives). A first-match lookup returns
            // {} and drops a genuine Maxim payment failure as foreign, silently
            // killing dunning alerts. Every candidate location must be checked.
            expect(
                classifyOwnership({
                    object: "invoice",
                    metadata: {},
                    subscription_details: { metadata: { ...marker, tier_id: "solo" } },
                }),
            ).toBe("maxim");
        });

        it("finds the marker on an invoice line when invoice metadata is empty", () => {
            expect(
                classifyOwnership({
                    object: "invoice",
                    metadata: {},
                    lines: { data: [{ metadata: marker }] },
                }),
            ).toBe("maxim");
        });

        it("reads the marker from lines.data[0].metadata (invoice line shape)", () => {
            expect(classifyOwnership({ lines: { data: [{ metadata: marker }] } })).toBe("maxim");
        });
    });

    describe("foreign — events we must acknowledge and ignore", () => {
        it("classifies an unmarked session with empty metadata as foreign", () => {
            // A nabeelkhan.com book sale. Stripe always sends metadata, {} when unset.
            expect(classifyOwnership({ metadata: {} })).toBe("foreign");
        });

        it("classifies an unmarked session with unrelated metadata as foreign", () => {
            expect(classifyOwnership({ metadata: { book_sku: "governed-agents-hardcover" } })).toBe("foreign");
        });

        it("does NOT grandfather an unknown tier_id", () => {
            // A foreign event that happens to carry a tier_id key must not be
            // mistaken for a legacy Maxim session.
            expect(classifyOwnership({ metadata: { tier_id: "not-a-maxim-tier" } })).toBe("foreign");
        });

        it("classifies a foreign invoice with empty metadata everywhere as foreign", () => {
            expect(
                classifyOwnership({
                    object: "invoice",
                    metadata: {},
                    subscription_details: { metadata: {} },
                    lines: { data: [{ metadata: {} }] },
                }),
            ).toBe("foreign");
        });

        it("treats a wrong marker value as foreign", () => {
            expect(classifyOwnership({ metadata: { [MXM_MARKER_KEY]: "0" } })).toBe("foreign");
        });
    });

    describe("unknown — shape we cannot judge, must fail loud", () => {
        it("classifies an object with no metadata field at all as unknown", () => {
            expect(classifyOwnership({ id: "evt_1" })).toBe("unknown");
        });

        it("classifies null metadata as unknown", () => {
            expect(classifyOwnership({ metadata: null })).toBe("unknown");
        });

        it("classifies a null object as unknown", () => {
            expect(classifyOwnership(null)).toBe("unknown");
        });

        it("classifies undefined as unknown", () => {
            expect(classifyOwnership(undefined)).toBe("unknown");
        });
    });

    describe("precedence", () => {
        it("marker wins over an unknown tier_id", () => {
            expect(classifyOwnership({ metadata: { ...marker, tier_id: "bogus" } })).toBe("maxim");
        });

        it("an empty metadata object is foreign, not unknown", () => {
            // The distinction matters: foreign returns 200 (ignore), unknown
            // returns 400 (fail loud). {} is a definite "not stamped".
            expect(classifyOwnership({ metadata: {} })).not.toBe("unknown");
        });
    });

    describe("purity", () => {
        it("does not mutate the object it inspects", () => {
            const obj = { metadata: { ...marker, tier_id: "solo" } };
            const before = JSON.stringify(obj);
            classifyOwnership(obj);
            expect(JSON.stringify(obj)).toBe(before);
        });
    });
});

describe("markerParams", () => {
    it("stamps the session metadata for every mode", () => {
        expect(markerParams("payment")).toContainEqual([`metadata[${MXM_MARKER_KEY}]`, MXM_MARKER_VALUE]);
        expect(markerParams("subscription")).toContainEqual([`metadata[${MXM_MARKER_KEY}]`, MXM_MARKER_VALUE]);
    });

    it("propagates the marker to the subscription in subscription mode", () => {
        // Needed so customer.subscription.deleted and invoice.payment_failed can
        // be attributed months after checkout.
        expect(markerParams("subscription")).toContainEqual([
            `subscription_data[metadata][${MXM_MARKER_KEY}]`,
            MXM_MARKER_VALUE,
        ]);
    });

    it("propagates the marker to the payment intent in payment mode", () => {
        // Needed so charge.refunded can be attributed: charge metadata is
        // inherited from the payment intent, not from the session.
        expect(markerParams("payment")).toContainEqual([
            `payment_intent_data[metadata][${MXM_MARKER_KEY}]`,
            MXM_MARKER_VALUE,
        ]);
    });

    it("does not set payment_intent_data in subscription mode", () => {
        // Stripe rejects payment_intent_data on subscription-mode sessions.
        const keys = markerParams("subscription").map(([k]) => k);
        expect(keys.some((k) => k.startsWith("payment_intent_data"))).toBe(false);
    });

    it("does not set subscription_data in payment mode", () => {
        const keys = markerParams("payment").map(([k]) => k);
        expect(keys.some((k) => k.startsWith("subscription_data"))).toBe(false);
    });
});
