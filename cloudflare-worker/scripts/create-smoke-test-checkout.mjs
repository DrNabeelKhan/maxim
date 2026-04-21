// Phase S4 smoke test — create a Stripe Checkout session for Solo monthly.
// Operator pays with test card 4242 4242 4242 4242 to trigger webhook.
// Worker issues JWT license and stores record in KV.
//
// Run: node scripts/create-smoke-test-checkout.mjs --env test --tier solo

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const WORKER_ROOT = path.resolve(__dirname, "..");

const args = process.argv.slice(2);
const envFlag = args.indexOf("--env") > -1 ? args[args.indexOf("--env") + 1] : "test";
const tierFlag = args.indexOf("--tier") > -1 ? args[args.indexOf("--tier") + 1] : "solo";
const intervalFlag = args.indexOf("--interval") > -1 ? args[args.indexOf("--interval") + 1] : "month";

const KEY_FILE = path.join(WORKER_ROOT, "secrets", `stripe-api-key-${envFlag}.txt`);
const PRODUCT_FILE = path.join(WORKER_ROOT, "..", "config", `stripe-products-${envFlag}.json`);

const stripeKey = fs.readFileSync(KEY_FILE, "utf8").trim();
const productCatalog = JSON.parse(fs.readFileSync(PRODUCT_FILE, "utf8"));

// Find price_id for the requested tier + interval
const sub = productCatalog.subscription_products.find((p) => p.tier_base === tierFlag);
if (!sub) {
    console.error(`ERROR: no subscription product for tier '${tierFlag}'`);
    process.exit(1);
}
const priceInfo = sub.prices[intervalFlag === "year" ? "year" : "month"];
const priceId = priceInfo.price_id;
const tierId = priceInfo.tier_id;

const SUCCESS_URL = "https://maxim-license-api.isystematic.workers.dev/health?checkout=success";
const CANCEL_URL = "https://maxim-license-api.isystematic.workers.dev/health?checkout=cancel";

async function main() {
    console.log(`\n🔧 Phase S4 smoke test — Checkout session`);
    console.log(`   Tier:     ${sub.name} (${tierFlag}, ${intervalFlag})`);
    console.log(`   Price ID: ${priceId}`);
    console.log(`   Tier ID:  ${tierId}`);
    console.log();

    const params = new URLSearchParams();
    params.append("mode", "subscription");
    params.append("line_items[0][price]", priceId);
    params.append("line_items[0][quantity]", "1");
    params.append("success_url", SUCCESS_URL);
    params.append("cancel_url", CANCEL_URL);
    params.append("metadata[tier_id]", tierId);
    params.append("metadata[source]", "maxim-v1.0.0-smoke-test");
    // customer_creation only valid in payment mode; subscription mode auto-creates customers.
    params.append("allow_promotion_codes", "true");

    const res = await fetch("https://api.stripe.com/v1/checkout/sessions", {
        method: "POST",
        headers: {
            Authorization: `Bearer ${stripeKey}`,
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: params.toString(),
    });

    const session = await res.json();
    if (!res.ok) {
        console.error("❌ Stripe Checkout session creation failed:", JSON.stringify(session, null, 2));
        process.exit(1);
    }

    console.log(`✓ Session created: ${session.id}`);
    console.log(`✓ Status:          ${session.status}`);
    console.log(`✓ Expires:         ${new Date(session.expires_at * 1000).toISOString()}`);
    console.log();
    console.log(`👉 Open this URL in a browser to complete the payment:`);
    console.log();
    console.log(`   ${session.url}`);
    console.log();
    console.log(`Use Stripe test card: 4242 4242 4242 4242`);
    console.log(`   Any future expiry, any CVC (e.g. 123), any ZIP.`);
    console.log();
    console.log(`After payment, the Worker receives a checkout.session.completed webhook,`);
    console.log(`issues a JWT, and stores a license record in KV at key license:${session.id}`);
}

main().catch((err) => {
    console.error("\n❌ Session creation failed:", err.message);
    process.exit(1);
});
