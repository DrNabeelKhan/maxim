// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// Contact form submission handler for maxim.isystematic.com/contact.
//
// Captures user-entered fields plus request-scoped metadata from Cloudflare's
// cf-* request headers (geolocation, timezone) and User-Agent string (browser,
// OS). Writes submission to KV, emails the sales inbox. Honeypot defeats
// simple bots; per-IP rate limit defeats spam floods.

import { notifySales } from "./notify";

type ContactEnv = {
    CONTACT_SUBMISSIONS?: KVNamespace;
    RATE_LIMIT?: KVNamespace;
    SALES_NOTIFY_EMAIL?: string;
    FROM_EMAIL?: string;
    ENVIRONMENT?: string;
};

const RATE_LIMIT_WINDOW_SECONDS = 3600; // 1 hour
const RATE_LIMIT_MAX_SUBMISSIONS = 5;
const SUBMISSION_TTL_SECONDS = 60 * 60 * 24 * 90; // 90 days

// Subject options MUST match the <option value="..."> list in the landing-page form.
const ALLOWED_SUBJECTS = new Set([
    "early-adopter-application",
    "early-adopter-inquiry",
    "sales",
    "compliance-audit",
    "partnership",
    "bug-report",
    "feature-request",
    "media-press",
    "security-disclosure",
    "general",
]);

// Subjects that are routed to the separate Early Adopter Program triage queue.
// Keeps application / eligibility traffic out of the general sales inbox noise
// and lets the operator review them as a batch on the published SLA (7 days).
const EARLY_ADOPTER_SUBJECTS = new Set([
    "early-adopter-application",
    "early-adopter-inquiry",
]);

type SubmissionBody = {
    firstName?: string;
    lastName?: string;
    email?: string;
    subject?: string;
    message?: string;
    // Honeypot — must be empty. Bots fill it. The field name should match the
    // hidden <input name="website"> on the landing-page form exactly.
    website?: string;
};

export async function handleContact(request: Request, env: ContactEnv): Promise<Response> {
    // Enforce POST + JSON content type
    if (request.method !== "POST") {
        return jsonCors({ error: "method_not_allowed" }, 405, request);
    }

    const clientIp = request.headers.get("cf-connecting-ip") || "0.0.0.0";

    // ── Rate limit by IP (KV counter, 1h window) ────────────────────────────
    if (env.RATE_LIMIT) {
        const rlKey = `contact:${clientIp}`;
        const currentRaw = await env.RATE_LIMIT.get(rlKey);
        const count = currentRaw ? parseInt(currentRaw, 10) : 0;
        if (count >= RATE_LIMIT_MAX_SUBMISSIONS) {
            return jsonCors(
                { error: "rate_limited", retry_after_seconds: RATE_LIMIT_WINDOW_SECONDS },
                429,
                request,
            );
        }
        await env.RATE_LIMIT.put(rlKey, String(count + 1), { expirationTtl: RATE_LIMIT_WINDOW_SECONDS });
    }

    // ── Parse + validate body ───────────────────────────────────────────────
    let body: SubmissionBody;
    try {
        body = await request.json();
    } catch {
        return jsonCors({ error: "invalid_json" }, 400, request);
    }

    // Honeypot — silently accept to avoid signaling to bots that they were caught
    if (body.website && body.website.length > 0) {
        // Return success without processing anything
        return jsonCors({ ok: true, submission_id: "ignored" }, 200, request);
    }

    // Required fields
    const errors: string[] = [];
    const firstName = cleanString(body.firstName, 100);
    const lastName = cleanString(body.lastName, 100);
    const email = cleanString(body.email, 254);
    const subject = cleanString(body.subject, 50);
    const message = cleanString(body.message, 5000);

    if (!firstName) errors.push("firstName is required");
    if (!lastName) errors.push("lastName is required");
    if (!email || !isEmail(email)) errors.push("valid email is required");
    if (!subject || !ALLOWED_SUBJECTS.has(subject)) errors.push("subject must be one of the allowed values");
    if (!message || message.length < 10) errors.push("message must be at least 10 characters");
    if (errors.length > 0) {
        return jsonCors({ error: "validation_failed", details: errors }, 400, request);
    }

    // ── Auto-capture request-scoped metadata ────────────────────────────────
    // Cloudflare exposes rich geolocation via `request.cf` (IncomingRequestCfProperties),
    // not via HTTP headers. The cf-* headers exist for edge compatibility but are
    // sparse on workers.dev; request.cf is populated on every Workers request.
    const cf = (request as Request & { cf?: IncomingRequestCfProperties }).cf;
    const userAgent = request.headers.get("user-agent") || "unknown";
    const ua = parseUserAgent(userAgent);

    const countryCode = (cf?.country as string | undefined) || request.headers.get("cf-ipcountry") || null;
    const geo = {
        ip: clientIp,
        continent: (cf?.continent as string | undefined) || null,
        country_code: countryCode,
        country_name: lookupCountryName(countryCode || ""),
        region_code: (cf?.regionCode as string | undefined) || null,
        region_name: (cf?.region as string | undefined) || null,
        city: (cf?.city as string | undefined) || null,
        latitude: (cf?.latitude as string | undefined) || null,
        longitude: (cf?.longitude as string | undefined) || null,
        timezone: (cf?.timezone as string | undefined) || null,
        postal_code: (cf?.postalCode as string | undefined) || null,
        isp: (cf?.asOrganization as string | undefined) || null,
        asn: (cf?.asn as number | undefined) || null,
        currency: guessCurrencyFromCountry(countryCode || ""),
    };

    const submissionId = crypto.randomUUID();
    const submittedAt = new Date().toISOString();

    const record = {
        submission_id: submissionId,
        submitted_at: submittedAt,
        contact: { first_name: firstName, last_name: lastName, email, subject, message },
        geo,
        client: { browser: ua.browser, os: ua.os, user_agent: userAgent },
    };

    // ── Persist to KV — route Early Adopter applications to a dedicated prefix ─
    const isEarlyAdopter = EARLY_ADOPTER_SUBJECTS.has(subject!);
    const kvKey = isEarlyAdopter
        ? `early-adopter:${submittedAt}:${submissionId}`
        : `submission:${submissionId}`;
    if (env.CONTACT_SUBMISSIONS) {
        await env.CONTACT_SUBMISSIONS.put(kvKey, JSON.stringify(record), {
            expirationTtl: SUBMISSION_TTL_SECONDS,
        });
    }

    // ── Email the triage inbox (fail-soft) ──────────────────────────────────
    // Early-adopter labels already start with "Early Adopter Program — ...", so
    // the email subject is just "<label> from <name>" in that case. Other
    // subjects get the "Contact form — " prefix for inbox filtering.
    const subjectLabel = subjectToLabel(subject!);
    const emailSubject = isEarlyAdopter
        ? `${subjectLabel} from ${firstName} ${lastName}`
        : `Contact form — ${subjectLabel} from ${firstName} ${lastName}`;
    await notifySales(
        {
            event: isEarlyAdopter ? "early-adopter-submission" : "contact-form",
            subject: emailSubject,
            body: [
                `New contact-form submission`,
                ``,
                `From: ${firstName} ${lastName} <${email}>`,
                `Subject: ${subjectLabel}`,
                ``,
                `Message:`,
                `${message}`,
                ``,
                `---`,
                `Location: ${geo.city ?? "?"}, ${geo.region_name ?? "?"}, ${geo.country_name ?? geo.country_code ?? "?"} (${geo.continent ?? "?"})`,
                `Timezone: ${geo.timezone ?? "?"} · Currency: ${geo.currency ?? "?"}`,
                `IP: ${geo.ip} · ISP: ${geo.isp ?? "unknown"}`,
                `Browser: ${ua.browser} on ${ua.os}`,
                `Submission ID: ${submissionId}`,
            ].join("\n"),
            metadata: record,
        },
        env,
    );

    return jsonCors({ ok: true, submission_id: submissionId }, 200, request);
}

// ── Helpers ─────────────────────────────────────────────────────────────────

function cleanString(v: unknown, maxLen: number): string | null {
    if (typeof v !== "string") return null;
    const trimmed = v.trim();
    if (trimmed.length === 0 || trimmed.length > maxLen) return null;
    return trimmed;
}

function isEmail(s: string): boolean {
    // RFC-ish but pragmatic; no catastrophic backtracking
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(s);
}

function subjectToLabel(key: string): string {
    const map: Record<string, string> = {
        "early-adopter-application": "Early Adopter Program — application",
        "early-adopter-inquiry": "Early Adopter Program — eligibility question",
        sales: "Sales / commercial licensing",
        "compliance-audit": "Compliance audit request",
        partnership: "Partnership / reseller inquiry",
        "bug-report": "Bug report",
        "feature-request": "Feature request",
        "media-press": "Media / press",
        "security-disclosure": "Security disclosure",
        general: "General question",
    };
    return map[key] ?? key;
}

type UserAgentInfo = { browser: string; os: string };

function parseUserAgent(ua: string): UserAgentInfo {
    const browser =
        /Edg\//i.test(ua) ? "Microsoft Edge" :
        /OPR\/|Opera/i.test(ua) ? "Opera" :
        /Chrome\//i.test(ua) ? "Chrome" :
        /Safari\//i.test(ua) ? "Safari" :
        /Firefox\//i.test(ua) ? "Firefox" :
        /MSIE|Trident\//i.test(ua) ? "Internet Explorer" :
        "Unknown browser";

    const os =
        /Windows NT 10/i.test(ua) ? "Windows 10/11" :
        /Windows NT/i.test(ua) ? "Windows (older)" :
        /Mac OS X|Macintosh/i.test(ua) ? "macOS" :
        /Android/i.test(ua) ? "Android" :
        /iPhone|iPad|iPod/i.test(ua) ? "iOS" :
        /Linux/i.test(ua) ? "Linux" :
        "Unknown OS";

    return { browser, os };
}

/** Minimal ISO-3166 alpha-2 → name map. Expand as needed. */
function lookupCountryName(code: string): string | null {
    if (!code) return null;
    const map: Record<string, string> = {
        US: "United States", CA: "Canada", GB: "United Kingdom", AU: "Australia",
        DE: "Germany", FR: "France", IN: "India", PK: "Pakistan", AE: "UAE",
        SA: "Saudi Arabia", NG: "Nigeria", BR: "Brazil", MX: "Mexico", JP: "Japan",
        SG: "Singapore", NL: "Netherlands", IE: "Ireland", ES: "Spain", IT: "Italy",
        SE: "Sweden", NO: "Norway", FI: "Finland", DK: "Denmark", CH: "Switzerland",
        AT: "Austria", BE: "Belgium", PT: "Portugal", NZ: "New Zealand",
    };
    return map[code.toUpperCase()] ?? code.toUpperCase();
}

/** Best-effort guess — a country-to-currency lookup for the most common cases. */
function guessCurrencyFromCountry(code: string): string | null {
    if (!code) return null;
    const map: Record<string, string> = {
        US: "USD", CA: "CAD", GB: "GBP", AU: "AUD", NZ: "NZD",
        DE: "EUR", FR: "EUR", IE: "EUR", NL: "EUR", BE: "EUR", ES: "EUR", IT: "EUR", PT: "EUR", AT: "EUR", FI: "EUR",
        IN: "INR", PK: "PKR", AE: "AED", SA: "SAR", JP: "JPY", SG: "SGD",
        BR: "BRL", MX: "MXN", NG: "NGN", SE: "SEK", NO: "NOK", DK: "DKK", CH: "CHF",
    };
    return map[code.toUpperCase()] ?? null;
}

/** CORS-aware JSON response that the browser fetch on maxim.isystematic.com can consume. */
function jsonCors(body: unknown, status = 200, request?: Request): Response {
    const headers: Record<string, string> = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": corsOrigin(request),
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Max-Age": "86400",
    };
    return new Response(JSON.stringify(body), { status, headers });
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

export function handleContactPreflight(request: Request): Response {
    // 204 No Content cannot carry a body per HTTP/1.1; Workers enforce this.
    // Return the CORS headers alone.
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
