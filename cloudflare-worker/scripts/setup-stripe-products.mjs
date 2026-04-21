// Maxim Stripe product setup — one-time setup script
// Creates 4 subscription products (Solo, Pro, Professional, Team) with monthly + annual prices,
// plus 4 one-time overlay products (Healthcare, Legal, Fintech, GovTech).
// Reads API key from secrets/stripe-api-key-test.txt (gitignored).
// Writes captured IDs to config/stripe-products-test.json.
//
// Maxim v1.0.0 pricing per D-026.5 in v6.4.4-session-decisions-log.md.
// Agency ($599/20 seats) and Enterprise (custom) deferred to v1.5+.
//
// Run: node scripts/setup-stripe-products.mjs [--env test|live] [--dry-run]
// Default: --env test --no-dry-run
//
// Safe to re-run: on name collision, Stripe creates duplicates rather than erroring.
// Clean up duplicates from Stripe dashboard if re-run needed.

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const WORKER_ROOT = path.resolve(__dirname, "..");

const args = process.argv.slice(2);
const envFlag = args.indexOf("--env") > -1 ? args[args.indexOf("--env") + 1] : "test";
const dryRun = args.includes("--dry-run");

if (envFlag !== "test" && envFlag !== "live") {
    console.error("ERROR: --env must be 'test' or 'live'. Got:", envFlag);
    process.exit(1);
}

const KEY_FILE = path.join(WORKER_ROOT, "secrets", `stripe-api-key-${envFlag}.txt`);
const OUTPUT_FILE = path.join(WORKER_ROOT, "..", "config", `stripe-products-${envFlag}.json`);
const STRIPE_API = "https://api.stripe.com/v1";

if (!fs.existsSync(KEY_FILE)) {
    console.error(`ERROR: Stripe key file not found: ${KEY_FILE}`);
    process.exit(1);
}

const stripeKey = fs.readFileSync(KEY_FILE, "utf8").trim();
if (!stripeKey.startsWith("sk_") && !stripeKey.startsWith("rk_")) {
    console.error("ERROR: key does not look like a Stripe key (expected sk_ or rk_ prefix).");
    process.exit(1);
}

// Confirm environment match (prevent accidental live-mode use with test script)
if (envFlag === "test" && !stripeKey.startsWith("sk_test_") && !stripeKey.startsWith("rk_test_")) {
    console.error("ERROR: --env test but key is not a test-mode key. Abort.");
    process.exit(1);
}
if (envFlag === "live" && !stripeKey.startsWith("sk_live_") && !stripeKey.startsWith("rk_live_")) {
    console.error("ERROR: --env live but key is not a live-mode key. Abort.");
    process.exit(1);
}

// ── Product definitions ──────────────────────────────────────────────────────

const SUBSCRIPTION_PRODUCTS = [
    {
        tier_base: "solo",
        name: "Maxim Solo",
        description: "The behavioral intelligence specialist for Claude. Unlimited behavioral_audit, all 64 behavioral frameworks, nudge design, persuasion tools. The MOAT tier.",
        seats: 1,
        prices: {
            month: 1999,  // $19.99
            year: 19999,  // $199.99 (~17% off)
        },
    },
    {
        tier_base: "pro",
        name: "Maxim Pro",
        description: "Individual generalist. Solo features plus 14 compliance frameworks, full Proactive Watch, MemPalace semantic memory, brand overlay.",
        seats: 1,
        prices: {
            month: 3900,  // $39
            year: 39000,  // $390 (~17% off)
        },
    },
    {
        tier_base: "professional",
        name: "Maxim Professional",
        description: "Everything-individual. Pro features plus full Brand & Design Pro, unlimited voice mode, priority support.",
        seats: 1,
        prices: {
            month: 9900,  // $99
            year: 99000,  // $990 (~17% off)
        },
    },
    {
        tier_base: "team",
        name: "Maxim Team",
        description: "Small-team tier. Everything in Professional × 5 seats. Shared MemPalace knowledge graph, team audit trails, cross-seat handoff coordination.",
        seats: 5,
        prices: {
            month: 24900,   // $249
            year: 249000,   // $2,490 (~17% off)
        },
    },
];

const OVERLAY_PRODUCTS = [
    {
        tier_id: "overlay-healthcare",
        name: "Maxim Healthcare Overlay",
        description: "HIPAA + ISO 13485 + ISO 14971 + FHIR/HL7. Clinical decision support and patient consent flows. Stackable on any Maxim paid subscription.",
        amount: 24900,  // $249
    },
    {
        tier_id: "overlay-legal",
        name: "Maxim Legal Overlay",
        description: "Attorney-client privilege, ethics walls, conflict checking, legaltech compliance. Stackable on any Maxim paid subscription.",
        amount: 19900,  // $199
    },
    {
        tier_id: "overlay-fintech",
        name: "Maxim Fintech Overlay",
        description: "PCI-DSS deep, FINTRAC, KYC/AML, SOX, FDX open banking. Stackable on any Maxim paid subscription.",
        amount: 19900,  // $199
    },
    {
        tier_id: "overlay-govtech",
        name: "Maxim GovTech Overlay",
        description: "FedRAMP, NIST 800-53, Section 508, RFP templates, procurement frameworks. Stackable on any Maxim paid subscription.",
        amount: 14900,  // $149
    },
];

// ── HTTP helpers ─────────────────────────────────────────────────────────────

async function stripePost(endpoint, body) {
    const res = await fetch(`${STRIPE_API}${endpoint}`, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${stripeKey}`,
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams(body).toString(),
    });
    const data = await res.json();
    if (!res.ok) {
        throw new Error(`Stripe ${endpoint} failed ${res.status}: ${JSON.stringify(data)}`);
    }
    return data;
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function main() {
    console.log(`\n🔧 Maxim Stripe Product Setup — env=${envFlag} ${dryRun ? "(DRY RUN)" : ""}`);
    console.log(`   Key prefix: ${stripeKey.slice(0, 8)}...`);
    console.log(`   Output:     ${OUTPUT_FILE}`);
    console.log();

    const result = {
        env: envFlag,
        created_at: new Date().toISOString(),
        subscription_products: [],
        overlay_products: [],
    };

    // Subscription products (each has monthly + annual price)
    for (const def of SUBSCRIPTION_PRODUCTS) {
        console.log(`→ Creating subscription product: ${def.name}`);
        if (dryRun) {
            result.subscription_products.push({ ...def, product_id: "DRY_RUN", prices: { month: "DRY_RUN", year: "DRY_RUN" } });
            continue;
        }

        const product = await stripePost("/products", {
            name: def.name,
            description: def.description,
            "metadata[tier_base]": def.tier_base,
            "metadata[seats]": def.seats.toString(),
            "metadata[source]": "maxim-v1.0.0-setup",
        });

        const priceMonth = await stripePost("/prices", {
            product: product.id,
            unit_amount: def.prices.month.toString(),
            currency: "usd",
            nickname: `${def.name} Monthly`,
            "recurring[interval]": "month",
            "recurring[interval_count]": "1",
            "metadata[tier_id]": def.tier_base,
        });

        const priceYear = await stripePost("/prices", {
            product: product.id,
            unit_amount: def.prices.year.toString(),
            currency: "usd",
            nickname: `${def.name} Annual`,
            "recurring[interval]": "year",
            "recurring[interval_count]": "1",
            "metadata[tier_id]": `${def.tier_base}-annual`,
        });

        result.subscription_products.push({
            tier_base: def.tier_base,
            name: def.name,
            seats: def.seats,
            product_id: product.id,
            prices: {
                month: { price_id: priceMonth.id, amount: def.prices.month, tier_id: def.tier_base },
                year: { price_id: priceYear.id, amount: def.prices.year, tier_id: `${def.tier_base}-annual` },
            },
        });

        console.log(`   ✓ product: ${product.id}`);
        console.log(`   ✓ price monthly: ${priceMonth.id} ($${def.prices.month / 100})`);
        console.log(`   ✓ price annual:  ${priceYear.id} ($${def.prices.year / 100})`);
    }

    console.log();

    // Overlay products (one-time price each)
    for (const def of OVERLAY_PRODUCTS) {
        console.log(`→ Creating overlay product: ${def.name}`);
        if (dryRun) {
            result.overlay_products.push({ ...def, product_id: "DRY_RUN", price_id: "DRY_RUN" });
            continue;
        }

        const product = await stripePost("/products", {
            name: def.name,
            description: def.description,
            "metadata[tier_id]": def.tier_id,
            "metadata[source]": "maxim-v1.0.0-setup",
        });

        const price = await stripePost("/prices", {
            product: product.id,
            unit_amount: def.amount.toString(),
            currency: "usd",
            nickname: `${def.name} One-time`,
            "metadata[tier_id]": def.tier_id,
        });

        result.overlay_products.push({
            tier_id: def.tier_id,
            name: def.name,
            product_id: product.id,
            price_id: price.id,
            amount: def.amount,
        });

        console.log(`   ✓ product: ${product.id}`);
        console.log(`   ✓ price:   ${price.id} ($${def.amount / 100})`);
    }

    // Write output file
    fs.mkdirSync(path.dirname(OUTPUT_FILE), { recursive: true });
    fs.writeFileSync(OUTPUT_FILE, JSON.stringify(result, null, 2));
    console.log();
    console.log(`✅ All products created. IDs saved to ${OUTPUT_FILE}`);
    console.log();
    console.log("Next: update src/stripe-product-map.ts with price_id references if needed,");
    console.log("and pass price_id in checkout session metadata.tier_id when creating sessions.");
}

main().catch((err) => {
    console.error("\n❌ Setup failed:", err.message);
    process.exit(1);
});
