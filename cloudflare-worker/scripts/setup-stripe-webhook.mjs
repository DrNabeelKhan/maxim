// Maxim Stripe webhook setup — one-time setup script
// Creates a Stripe webhook endpoint pointing to the deployed Worker URL.
// Subscribes to events needed by stripeWebhook handler.
// Captures the signing secret and writes it to secrets/stripe-webhook-secret.txt.
//
// Run: node scripts/setup-stripe-webhook.mjs --env test --url <workers-dev-url>

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const WORKER_ROOT = path.resolve(__dirname, "..");

const args = process.argv.slice(2);
const envFlag = args.indexOf("--env") > -1 ? args[args.indexOf("--env") + 1] : "test";
const urlFlag = args.indexOf("--url") > -1 ? args[args.indexOf("--url") + 1] : null;

if (envFlag !== "test" && envFlag !== "live") {
    console.error("ERROR: --env must be 'test' or 'live'.");
    process.exit(1);
}
if (!urlFlag) {
    console.error("ERROR: --url required. Example: --url https://mxm-license-api.isystematic.workers.dev");
    process.exit(1);
}

const webhookPath = "/webhook/stripe";
const webhookUrl = urlFlag.replace(/\/+$/, "") + webhookPath;

const KEY_FILE = path.join(WORKER_ROOT, "secrets", `stripe-api-key-${envFlag}.txt`);
const OUTPUT_FILE = path.join(WORKER_ROOT, "secrets", "stripe-webhook-secret.txt");
const LOG_FILE = path.join(WORKER_ROOT, "..", "config", `stripe-webhook-${envFlag}.json`);

const stripeKey = fs.readFileSync(KEY_FILE, "utf8").trim();

// Events handled by the Worker's stripeWebhook function
const EVENTS = [
    "checkout.session.completed",
    "customer.subscription.deleted",
    "customer.subscription.updated",
    "invoice.payment_failed",
];

async function main() {
    console.log(`\n🔧 Maxim Stripe Webhook Setup — env=${envFlag}`);
    console.log(`   Webhook URL:  ${webhookUrl}`);
    console.log(`   Events:       ${EVENTS.length} subscribed`);
    console.log();

    const params = new URLSearchParams();
    params.append("url", webhookUrl);
    params.append("description", "Maxim license issuance via Cloudflare Worker (D-037 primary processor)");
    for (const event of EVENTS) {
        params.append("enabled_events[]", event);
    }
    params.append("metadata[source]", "maxim-v1.0.0-setup");
    params.append("metadata[env]", envFlag);

    const res = await fetch("https://api.stripe.com/v1/webhook_endpoints", {
        method: "POST",
        headers: {
            Authorization: `Bearer ${stripeKey}`,
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: params.toString(),
    });

    const data = await res.json();
    if (!res.ok) {
        console.error("❌ Stripe webhook creation failed:", JSON.stringify(data, null, 2));
        process.exit(1);
    }

    // Write secret to secrets file (this is the ONE moment Stripe returns it)
    fs.writeFileSync(OUTPUT_FILE, data.secret);

    // Write webhook metadata to config (no secret in here)
    fs.mkdirSync(path.dirname(LOG_FILE), { recursive: true });
    fs.writeFileSync(
        LOG_FILE,
        JSON.stringify(
            {
                env: envFlag,
                webhook_id: data.id,
                url: data.url,
                enabled_events: data.enabled_events,
                api_version: data.api_version,
                status: data.status,
                created: data.created,
                created_at: new Date().toISOString(),
            },
            null,
            2,
        ),
    );

    console.log(`✓ Webhook created: ${data.id}`);
    console.log(`✓ Status:          ${data.status}`);
    console.log(`✓ Signing secret:  whsec_... (written to ${OUTPUT_FILE})`);
    console.log(`✓ Metadata log:    ${LOG_FILE}`);
    console.log();
    console.log("Next: push the secret to the Worker:");
    console.log(`  cat secrets/stripe-webhook-secret.txt | pnpm wrangler secret put STRIPE_WEBHOOK_SECRET`);
}

main().catch((err) => {
    console.error("\n❌ Setup failed:", err.message);
    process.exit(1);
});
