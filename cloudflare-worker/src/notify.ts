// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// Outbound-email notification helper for the Maxim License API Worker.
//
// Uses MailChannels (free for Cloudflare Workers with proper DNS verification)
// as the default transport. To deploy on a new domain:
//   1. Add SPF record: `v=spf1 a mx include:relay.mailchannels.net ~all`
//   2. Add DKIM key (generate via MailChannels console)
//   3. Add _mailchannels TXT record: `v=mc1 cfid=maxim-license-api.isystematic.workers.dev`
//
// All notifications fail-soft: an email-send failure never blocks the webhook
// acknowledgment path. Errors are logged; the sales team sees them via
// Cloudflare observability, not via missed webhook retries.

export type NotifyEvent =
    | "contact-form"
    | "sale-completed"
    | "subscription-cancelled"
    | "payment-failed"
    | "refund-issued"
    | "worker-error";

export type NotifyPayload = {
    event: NotifyEvent;
    subject: string;
    body: string;
    metadata?: Record<string, unknown>;
};

/**
 * Send a notification email to the sales inbox.
 * Fail-soft: any error is logged; never throws to caller.
 */
export async function notifySales(payload: NotifyPayload, env: { SALES_NOTIFY_EMAIL?: string; FROM_EMAIL?: string }): Promise<void> {
    const to = env.SALES_NOTIFY_EMAIL || "sales@isystematic.com";
    const from = env.FROM_EMAIL || "noreply@isystematic.com";
    try {
        const metadataBlock = payload.metadata
            ? "\n\n---\nMetadata:\n" + JSON.stringify(payload.metadata, null, 2)
            : "";
        const plainBody = `${payload.body}${metadataBlock}\n\n---\nEvent: ${payload.event}\nTimestamp: ${new Date().toISOString()}\nSource: maxim-license-api Worker`;

        const res = await fetch("https://api.mailchannels.net/tx/v1/send", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                personalizations: [{ to: [{ email: to, name: "Maxim Sales" }] }],
                from: { email: from, name: "Maxim Notifications" },
                subject: `[Maxim] ${payload.subject}`,
                content: [
                    { type: "text/plain", value: plainBody },
                ],
            }),
        });
        if (!res.ok) {
            const text = await res.text();
            console.error("notify: mailchannels non-2xx", { status: res.status, body: text.slice(0, 500), event: payload.event });
        }
    } catch (err) {
        console.error("notify: send failed", { event: payload.event, err: String(err) });
    }
}

/** Format currency amounts (Stripe gives cents). */
export function fmtMoney(cents: number | null | undefined, currency = "USD"): string {
    if (cents == null) return "N/A";
    const amount = cents / 100;
    return new Intl.NumberFormat("en-US", { style: "currency", currency }).format(amount);
}
