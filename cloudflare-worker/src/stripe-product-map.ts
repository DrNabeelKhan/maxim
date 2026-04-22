// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Stripe product mapping — primary processor per D-037
//
// Populated by Phase S2 Stripe product creation script.
// Keys here are `tier_id` values set as `metadata.tier_id` on each Stripe Checkout Session.
// The same tier_id flows from landing page button click -> checkout session creation ->
// webhook receipt -> this map lookup -> JWT claims -> pack-engine grants.
//
// Maxim v1.0.0 pricing per D-026.5:
//   Solo $19.99/mo  Pro $39/mo  Professional $99/mo  Team $249/mo (5 seats)
//   Healthcare $249 once  Legal $199 once  Fintech $199 once  GovTech $149 once
// Annual variants add *-annual suffix (e.g., solo-annual).
//
// Deferred to v1.5+: Agency ($599/20 seats), Enterprise (custom).
//
// Grant strings match pack-engine capability flags. Do not rename grants without
// updating pack-engine's capability registry.

export interface StripeTierMapping {
    product_id: string; // Human label e.g. "Solo", "Pro", "Professional"
    billing: "monthly" | "annual" | "one_time";
    seats: number; // 1 for individual tiers, 5 for Team, 20 for Agency (v1.5+)
    grants: string[];
    stripe_price_id?: string; // Live-mode Stripe price ID for Checkout Session creation
    mode?: "subscription" | "payment"; // "subscription" for recurring tiers, "payment" for one-time overlays
}

/**
 * Live-mode Stripe price IDs, generated 2026-04-21 via:
 *   node cloudflare-worker/scripts/setup-stripe-products.mjs --env live
 * Source of truth: config/stripe-products-live.json (gitignored).
 * Products created with rk_live key (Products:Write, Prices:Write, Checkout:Write).
 */
export const TIER_PRICE_IDS: Record<string, { price_id: string; mode: "subscription" | "payment"; cadence: "month" | "year" | "one_time" }> = {
    "solo":                { price_id: "price_1TOpJFFQAVcq18td7OHUtWQ3", mode: "subscription", cadence: "month" },
    "solo-annual":         { price_id: "price_1TOpJGFQAVcq18tdABuNXq0O", mode: "subscription", cadence: "year" },
    "pro":                 { price_id: "price_1TOpJGFQAVcq18td4z0ieGSt", mode: "subscription", cadence: "month" },
    "pro-annual":          { price_id: "price_1TOpJGFQAVcq18tduGHzZQtE", mode: "subscription", cadence: "year" },
    "professional":        { price_id: "price_1TOpJHFQAVcq18td9EBq9PaS", mode: "subscription", cadence: "month" },
    "professional-annual": { price_id: "price_1TOpJHFQAVcq18tdGGpEJPf0", mode: "subscription", cadence: "year" },
    "team":                { price_id: "price_1TOpJHFQAVcq18td6Miqlg1b", mode: "subscription", cadence: "month" },
    "team-annual":         { price_id: "price_1TOpJHFQAVcq18tdBDRQk06j", mode: "subscription", cadence: "year" },
    "overlay-healthcare":  { price_id: "price_1TOpJIFQAVcq18tdKpqDD0AQ", mode: "payment",      cadence: "one_time" },
    "overlay-legal":       { price_id: "price_1TOpJIFQAVcq18tdHo367cYH", mode: "payment",      cadence: "one_time" },
    "overlay-fintech":     { price_id: "price_1TOpJJFQAVcq18tdsN6vbCS9", mode: "payment",      cadence: "one_time" },
    "overlay-govtech":     { price_id: "price_1TOpJJFQAVcq18tdMaKUQkue", mode: "payment",      cadence: "one_time" },
};

export const STRIPE_PRODUCT_MAP: Record<string, StripeTierMapping> = {
    // ── Monthly subscriptions ────────────────────────────────────────────────
    "solo": {
        product_id: "Solo",
        billing: "monthly",
        seats: 1,
        grants: [
            "behavioral-frameworks-64",
            "behavioral-audit-unlimited",
            "nudge-design",
            "persuasion-system",
            "ttm-stage-detection",
            "adr-010-technical-educator-rubric",
            "confidence-tagging",
        ],
    },
    "pro": {
        product_id: "Pro",
        billing: "monthly",
        seats: 1,
        grants: [
            // Solo grants
            "behavioral-frameworks-64",
            "behavioral-audit-unlimited",
            "nudge-design",
            "persuasion-system",
            "ttm-stage-detection",
            "adr-010-technical-educator-rubric",
            "confidence-tagging",
            // Pro additions
            "compliance-gdpr",
            "compliance-pipeda",
            "compliance-soc2",
            "compliance-hipaa",
            "compliance-pci-dss",
            "compliance-uae-pdpl",
            "compliance-casl",
            "compliance-fintrac",
            "compliance-eu-ai-act",
            "compliance-iso-27001",
            "compliance-iso-13485",
            "compliance-iso-14971",
            "compliance-nist-csf",
            "compliance-wcag-21",
            "cso-auto-loop",
            "watch-class-5-mcp-health",
            "watch-class-6-skill-gap",
            "watch-class-7-moat-drift",
            "watch-class-8-brand-drift",
            "watch-class-9-compliance-drift",
            "watch-class-10-behavioral-framework-coverage",
            "watch-class-11-external-boundary-drift",
            "watch-class-12-behavioral-moat-drift",
            "mempalace-full",
            "wiki-ingest",
            "wiki-query",
            "wiki-lint",
            "wiki-explore",
            "cross-session-memory",
            "session-milestones",
            "mxm-recall",
            "brand-overlay-20-per-month",
        ],
    },
    "professional": {
        product_id: "Professional",
        billing: "monthly",
        seats: 1,
        grants: [
            // Pro grants (inherited)
            "behavioral-frameworks-64",
            "behavioral-audit-unlimited",
            "nudge-design",
            "persuasion-system",
            "ttm-stage-detection",
            "adr-010-technical-educator-rubric",
            "confidence-tagging",
            "compliance-gdpr",
            "compliance-pipeda",
            "compliance-soc2",
            "compliance-hipaa",
            "compliance-pci-dss",
            "compliance-uae-pdpl",
            "compliance-casl",
            "compliance-fintrac",
            "compliance-eu-ai-act",
            "compliance-iso-27001",
            "compliance-iso-13485",
            "compliance-iso-14971",
            "compliance-nist-csf",
            "compliance-wcag-21",
            "cso-auto-loop",
            "watch-class-5-mcp-health",
            "watch-class-6-skill-gap",
            "watch-class-7-moat-drift",
            "watch-class-8-brand-drift",
            "watch-class-9-compliance-drift",
            "watch-class-10-behavioral-framework-coverage",
            "watch-class-11-external-boundary-drift",
            "watch-class-12-behavioral-moat-drift",
            "mempalace-full",
            "wiki-ingest",
            "wiki-query",
            "wiki-lint",
            "wiki-explore",
            "cross-session-memory",
            "session-milestones",
            "mxm-recall",
            // Professional additions
            ".brand-foundation-personal",
            ".brand-foundation-startups",
            "design-system",
            "banner-design",
            "ai-media-generation-full",
            "cinematic-styles-15",
            "ui-ux",
            "design-resources",
            "voice-mode-unlimited",
            "priority-support",
        ],
    },
    "team": {
        product_id: "Team",
        billing: "monthly",
        seats: 5,
        grants: [
            // Inherits all Professional grants
            "behavioral-frameworks-64",
            "behavioral-audit-unlimited",
            "nudge-design",
            "persuasion-system",
            "ttm-stage-detection",
            "adr-010-technical-educator-rubric",
            "confidence-tagging",
            "compliance-gdpr",
            "compliance-pipeda",
            "compliance-soc2",
            "compliance-hipaa",
            "compliance-pci-dss",
            "compliance-uae-pdpl",
            "compliance-casl",
            "compliance-fintrac",
            "compliance-eu-ai-act",
            "compliance-iso-27001",
            "compliance-iso-13485",
            "compliance-iso-14971",
            "compliance-nist-csf",
            "compliance-wcag-21",
            "cso-auto-loop",
            "watch-class-5-mcp-health",
            "watch-class-6-skill-gap",
            "watch-class-7-moat-drift",
            "watch-class-8-brand-drift",
            "watch-class-9-compliance-drift",
            "watch-class-10-behavioral-framework-coverage",
            "watch-class-11-external-boundary-drift",
            "watch-class-12-behavioral-moat-drift",
            "mempalace-full",
            "wiki-ingest",
            "wiki-query",
            "wiki-lint",
            "wiki-explore",
            "cross-session-memory",
            "session-milestones",
            "mxm-recall",
            ".brand-foundation-personal",
            ".brand-foundation-startups",
            "design-system",
            "banner-design",
            "ai-media-generation-full",
            "cinematic-styles-15",
            "ui-ux",
            "design-resources",
            "voice-mode-unlimited",
            "priority-support",
            // Team additions
            "mempalace-shared-kg",
            "team-audit-trails",
            "cross-seat-handoff",
            "team-seats-5",
        ],
    },

    // ── Annual subscriptions (same grants + discounted price) ────────────────
    "solo-annual": {
        product_id: "Solo (Annual)",
        billing: "annual",
        seats: 1,
        grants: [
            "behavioral-frameworks-64",
            "behavioral-audit-unlimited",
            "nudge-design",
            "persuasion-system",
            "ttm-stage-detection",
            "adr-010-technical-educator-rubric",
            "confidence-tagging",
        ],
    },
    "pro-annual": {
        product_id: "Pro (Annual)",
        billing: "annual",
        seats: 1,
        grants: [
            "behavioral-frameworks-64",
            "behavioral-audit-unlimited",
            "nudge-design",
            "persuasion-system",
            "ttm-stage-detection",
            "adr-010-technical-educator-rubric",
            "confidence-tagging",
            "compliance-gdpr", "compliance-pipeda", "compliance-soc2", "compliance-hipaa",
            "compliance-pci-dss", "compliance-uae-pdpl", "compliance-casl", "compliance-fintrac",
            "compliance-eu-ai-act", "compliance-iso-27001", "compliance-iso-13485",
            "compliance-iso-14971", "compliance-nist-csf", "compliance-wcag-21",
            "cso-auto-loop",
            "watch-class-5-mcp-health", "watch-class-6-skill-gap", "watch-class-7-moat-drift",
            "watch-class-8-brand-drift", "watch-class-9-compliance-drift",
            "watch-class-10-behavioral-framework-coverage", "watch-class-11-external-boundary-drift",
            "watch-class-12-behavioral-moat-drift",
            "mempalace-full", "wiki-ingest", "wiki-query", "wiki-lint", "wiki-explore",
            "cross-session-memory", "session-milestones", "mxm-recall",
            "brand-overlay-20-per-month",
        ],
    },
    "professional-annual": {
        product_id: "Professional (Annual)",
        billing: "annual",
        seats: 1,
        grants: [
            "behavioral-frameworks-64", "behavioral-audit-unlimited", "nudge-design",
            "persuasion-system", "ttm-stage-detection", "adr-010-technical-educator-rubric",
            "confidence-tagging",
            "compliance-gdpr", "compliance-pipeda", "compliance-soc2", "compliance-hipaa",
            "compliance-pci-dss", "compliance-uae-pdpl", "compliance-casl", "compliance-fintrac",
            "compliance-eu-ai-act", "compliance-iso-27001", "compliance-iso-13485",
            "compliance-iso-14971", "compliance-nist-csf", "compliance-wcag-21", "cso-auto-loop",
            "watch-class-5-mcp-health", "watch-class-6-skill-gap", "watch-class-7-moat-drift",
            "watch-class-8-brand-drift", "watch-class-9-compliance-drift",
            "watch-class-10-behavioral-framework-coverage", "watch-class-11-external-boundary-drift",
            "watch-class-12-behavioral-moat-drift",
            "mempalace-full", "wiki-ingest", "wiki-query", "wiki-lint", "wiki-explore",
            "cross-session-memory", "session-milestones", "mxm-recall",
            ".brand-foundation-personal", ".brand-foundation-startups", "design-system",
            "banner-design", "ai-media-generation-full", "cinematic-styles-15",
            "ui-ux", "design-resources", "voice-mode-unlimited", "priority-support",
        ],
    },
    "team-annual": {
        product_id: "Team (Annual)",
        billing: "annual",
        seats: 5,
        grants: [
            "behavioral-frameworks-64", "behavioral-audit-unlimited", "nudge-design",
            "persuasion-system", "ttm-stage-detection", "adr-010-technical-educator-rubric",
            "confidence-tagging",
            "compliance-gdpr", "compliance-pipeda", "compliance-soc2", "compliance-hipaa",
            "compliance-pci-dss", "compliance-uae-pdpl", "compliance-casl", "compliance-fintrac",
            "compliance-eu-ai-act", "compliance-iso-27001", "compliance-iso-13485",
            "compliance-iso-14971", "compliance-nist-csf", "compliance-wcag-21", "cso-auto-loop",
            "watch-class-5-mcp-health", "watch-class-6-skill-gap", "watch-class-7-moat-drift",
            "watch-class-8-brand-drift", "watch-class-9-compliance-drift",
            "watch-class-10-behavioral-framework-coverage", "watch-class-11-external-boundary-drift",
            "watch-class-12-behavioral-moat-drift",
            "mempalace-full", "wiki-ingest", "wiki-query", "wiki-lint", "wiki-explore",
            "cross-session-memory", "session-milestones", "mxm-recall",
            ".brand-foundation-personal", ".brand-foundation-startups", "design-system",
            "banner-design", "ai-media-generation-full", "cinematic-styles-15",
            "ui-ux", "design-resources", "voice-mode-unlimited", "priority-support",
            "mempalace-shared-kg", "team-audit-trails", "cross-seat-handoff", "team-seats-5",
        ],
    },

    // ── Vertical overlays (one-time, stackable on any paid subscription) ─────
    "overlay-healthcare": {
        product_id: "Healthcare Overlay",
        billing: "one_time",
        seats: 1,
        grants: [
            "vertical:healthcare",
            "hipaa-deep",
            "iso-13485",
            "iso-14971",
            "fhir-hl7-interop",
            "clinical-decision-support",
            "patient-consent-flows",
            "medical-terminology",
        ],
    },
    "overlay-legal": {
        product_id: "Legal Overlay",
        billing: "one_time",
        seats: 1,
        grants: [
            "vertical:legal",
            "attorney-client-privilege",
            "contract-templates",
            "ethics-walls",
            "conflict-checking",
            "legaltech-compliance",
        ],
    },
    "overlay-fintech": {
        product_id: "Fintech Overlay",
        billing: "one_time",
        seats: 1,
        grants: [
            "vertical:fintech",
            "pci-dss-deep",
            "fintrac",
            "kyc-aml",
            "open-banking-fdx",
            "sox-controls",
            "financial-modeling",
        ],
    },
    "overlay-govtech": {
        product_id: "GovTech Overlay",
        billing: "one_time",
        seats: 1,
        grants: [
            "vertical:govtech",
            "fedramp",
            "nist-800-53",
            "section-508-strict",
            "rfp-templates",
            "procurement-frameworks",
        ],
    },

    // ── Deferred to v1.5+ (declared here for forward-compat, not active) ─────
    // "agency": { product_id: "Agency", billing: "monthly", seats: 20, grants: [...] },
    // "agency-annual": { product_id: "Agency (Annual)", billing: "annual", seats: 20, grants: [...] },
    // "enterprise": { product_id: "Enterprise", billing: "monthly", seats: -1 /* custom */, grants: [...] },
};
