// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// v1.1.A — License middleware endpoints.
//
// Two new public endpoints per locked design (Session 15):
//   POST /issue     — anonymous Starter JWT issuer (no admin auth)
//   POST /validate  — daily-heartbeat validator returning tier + grants (no admin auth)
//
// These are SEPARATE from the existing /license/issue (admin-only paid issuer)
// and /license/validate (legacy shape) endpoints. Backward-compatible: old
// endpoints remain for Stripe/LemonSqueezy webhook flow + admin tooling.
//
// G1 schemas (locked Session 15):
//   POST /issue   { machine_fingerprint, client_version }
//                 → { jwt, tier, grants, expires_at }
//   POST /validate { jwt }
//                 → { valid, tier, grants, expires_at, refresh_url? }
//
// G2 KV schema (added to existing LICENSES namespace):
//   issuance:{fingerprint}:{ts}     30d TTL — issuance audit log
//   heartbeat:{fingerprint}:{date}  30d TTL — daily refresh tracking
//   license:{jwt_id}                permanent — revocation lookup
//
// G3 Rate limits (RATE_LIMIT KV namespace):
//   /issue:    ≤10/day per fingerprint, ≤100/h per IP
//   /validate: ≤50/day per fingerprint, ≤1000/h per IP

import jwt from "@tsndr/cloudflare-worker-jwt";
import grantsConfig from "../grants.json";
import type { Env } from "./index";

// Anonymous Starter JWT TTL: 30 days per locked design
const ANON_STARTER_TTL_DAYS = 30;
const ANON_STARTER_TTL_SECONDS = ANON_STARTER_TTL_DAYS * 24 * 3600;

// Rate-limit thresholds per locked design G3
const RATE_LIMITS = {
    issue: {
        per_fingerprint_per_day: 10,
        per_ip_per_hour: 100,
    },
    validate: {
        per_fingerprint_per_day: 50,
        per_ip_per_hour: 1000,
    },
} as const;

interface GrantsConfig {
    schema: string;
    version: string;
    tiers: Record<string, {
        display_name: string;
        jwt_ttl_days: number;
        anonymous?: boolean;
        grants: string[];
        rate_limits: { issue_per_machine_per_day: number; validate_per_machine_per_day: number };
    }>;
    grants_catalog: Record<string, string>;
}

const GRANTS = grantsConfig as unknown as GrantsConfig;

// =====================================================================
// POST /issue — anonymous Starter JWT issuer
// =====================================================================

export async function handleAnonymousIssue(request: Request, env: Env): Promise<Response> {
    if (request.method !== "POST") return jsonResp({ error: "method_not_allowed" }, 405);

    let body: { machine_fingerprint?: string; client_version?: string };
    try {
        body = await request.json();
    } catch {
        return jsonResp({ error: "invalid_json" }, 400);
    }

    const fp = body.machine_fingerprint;
    const clientVersion = body.client_version || "unknown";

    if (!fp || !/^[a-f0-9]{64}$/i.test(fp)) {
        return jsonResp({ error: "invalid_machine_fingerprint", expected: "sha256 hex (64 chars)" }, 400);
    }

    // Rate-limit check (per-fingerprint daily + per-IP hourly)
    const rlResult = await checkRateLimit({
        env,
        scope: "issue",
        fingerprint: fp,
        ip: ipFromRequest(request),
        per_fp_per_day: RATE_LIMITS.issue.per_fingerprint_per_day,
        per_ip_per_hour: RATE_LIMITS.issue.per_ip_per_hour,
    });
    if (!rlResult.allowed) {
        return jsonResp(
            { error: "rate_limited", scope: rlResult.scope, retry_after_seconds: rlResult.retry_after_seconds },
            429,
            { "Retry-After": String(rlResult.retry_after_seconds) },
        );
    }

    // Issue Starter JWT
    const starterTier = GRANTS.tiers["starter"];
    if (!starterTier) {
        console.error("grants.json missing starter tier");
        return jsonResp({ error: "internal_grants_error" }, 500);
    }

    const now = Math.floor(Date.now() / 1000);
    const expSeconds = now + ANON_STARTER_TTL_SECONDS;
    const expiresAtIso = new Date(expSeconds * 1000).toISOString();
    const jwtId = crypto.randomUUID();

    const payload = {
        // Standard JWT registered claims
        iss: env.JWT_ISSUER,
        aud: env.JWT_AUDIENCE,
        sub: `anon:${fp.slice(0, 16)}`,
        iat: now,
        exp: expSeconds,
        jti: jwtId,
        // v1.1.A claims
        tier: "starter",
        grants: starterTier.grants,
        machine_fingerprint: fp,
        client_version: clientVersion,
        // Legacy claims for pack-engine compatibility
        product_id: "starter",
        packs: [],
        billing: "free",
        order_id: jwtId,
        mxm_version_min: env.MXM_VERSION_MIN,
    };

    const signedJwt = await jwt.sign(payload, env.JWT_SIGNING_KEY_PRIVATE, { algorithm: "RS256" });

    // KV bookkeeping (fail-soft: never block issuance on KV write errors)
    if (env.LICENSES) {
        const issuanceKey = `issuance:${fp}:${now}`;
        const licenseKey = `license:${jwtId}`;
        const ttl30d = 30 * 24 * 3600;
        await Promise.allSettled([
            env.LICENSES.put(
                issuanceKey,
                JSON.stringify({ tier: "starter", jwt_id: jwtId, fingerprint: fp, client_version: clientVersion, ts: now }),
                { expirationTtl: ttl30d },
            ),
            env.LICENSES.put(
                licenseKey,
                JSON.stringify({
                    tier: "starter",
                    grants: starterTier.grants,
                    fingerprint: fp,
                    issued_at: new Date(now * 1000).toISOString(),
                    expires_at: expiresAtIso,
                    status: "active",
                    anonymous: true,
                }),
            ),
        ]);
    }

    return jsonResp({
        jwt: signedJwt,
        tier: "starter",
        grants: starterTier.grants,
        expires_at: expiresAtIso,
    });
}

// =====================================================================
// POST /validate — daily-heartbeat validator
// =====================================================================

export async function handleValidate(request: Request, env: Env): Promise<Response> {
    if (request.method !== "POST") return jsonResp({ error: "method_not_allowed" }, 405);

    let body: { jwt?: string };
    try {
        body = await request.json();
    } catch {
        return jsonResp({ error: "invalid_json" }, 400);
    }

    const token = body.jwt;
    if (!token || typeof token !== "string") {
        return jsonResp({ error: "missing_jwt" }, 400);
    }

    // Verify signature + decode
    let claims: any;
    try {
        const isValidSig = await jwt.verify(token, env.JWT_SIGNING_KEY_PUBLIC, { algorithm: "RS256" });
        if (!isValidSig) return jsonResp({ valid: false, error: "signature_invalid" }, 200);
        const decoded = jwt.decode(token);
        claims = decoded.payload || {};
    } catch (err: any) {
        return jsonResp({ valid: false, error: err.message || "decode_failed" }, 200);
    }

    // Rate-limit check (per-fingerprint daily + per-IP hourly)
    const fp = claims.machine_fingerprint;
    if (fp) {
        const rlResult = await checkRateLimit({
            env,
            scope: "validate",
            fingerprint: fp,
            ip: ipFromRequest(request),
            per_fp_per_day: RATE_LIMITS.validate.per_fingerprint_per_day,
            per_ip_per_hour: RATE_LIMITS.validate.per_ip_per_hour,
        });
        if (!rlResult.allowed) {
            return jsonResp(
                { valid: false, error: "rate_limited", scope: rlResult.scope, retry_after_seconds: rlResult.retry_after_seconds },
                429,
                { "Retry-After": String(rlResult.retry_after_seconds) },
            );
        }
    }

    // Application-level claim checks
    const now = Math.floor(Date.now() / 1000);
    if (claims.exp && claims.exp < now) {
        return jsonResp({
            valid: false,
            error: "expired",
            tier: claims.tier || "unknown",
            grants: [],
            expires_at: claims.exp ? new Date(claims.exp * 1000).toISOString() : null,
            refresh_url: env.JWT_ISSUER + "/issue",
        }, 200);
    }
    if (claims.iss !== env.JWT_ISSUER) {
        return jsonResp({ valid: false, error: "wrong_issuer" }, 200);
    }
    if (claims.aud !== env.JWT_AUDIENCE && !(Array.isArray(claims.aud) && claims.aud.includes(env.JWT_AUDIENCE))) {
        return jsonResp({ valid: false, error: "wrong_audience" }, 200);
    }

    // Revocation check (license:{jti} in KV)
    if (env.LICENSES && claims.jti) {
        const licenseRecord = await env.LICENSES.get(`license:${claims.jti}`);
        if (licenseRecord) {
            try {
                const record = JSON.parse(licenseRecord);
                if (record.status === "revoked" || record.status === "cancelled") {
                    return jsonResp({
                        valid: false,
                        error: "revoked",
                        revoked_at: record.revoked_at || record.cancelled_at || null,
                        revoked_reason: record.revoked_reason || null,
                    }, 200);
                }
            } catch {
                // KV parse failure — fail-soft, treat as valid (signature already verified)
            }
        }
    }

    // Heartbeat bookkeeping (fail-soft)
    if (env.LICENSES && fp) {
        const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
        const heartbeatKey = `heartbeat:${fp}:${today}`;
        const ttl30d = 30 * 24 * 3600;
        await env.LICENSES
            .put(heartbeatKey, JSON.stringify({ tier: claims.tier, jwt_id: claims.jti, ts: now }), { expirationTtl: ttl30d })
            .catch(() => {});
    }

    // Resolve current tier grants from grants.json (handles tier upgrades / grant additions
    // since JWT was issued — server-side source of truth wins, JWT claims are advisory).
    const tier = claims.tier || "starter";
    const tierConfig = GRANTS.tiers[tier];
    const grants = tierConfig?.grants || claims.grants || [];

    return jsonResp({
        valid: true,
        tier,
        grants,
        expires_at: claims.exp ? new Date(claims.exp * 1000).toISOString() : null,
    });
}

// =====================================================================
// Rate limiting (simple KV-backed, eventually consistent)
// =====================================================================

interface RateLimitArgs {
    env: Env;
    scope: "issue" | "validate";
    fingerprint: string;
    ip: string;
    per_fp_per_day: number;
    per_ip_per_hour: number;
}

interface RateLimitResult {
    allowed: boolean;
    scope?: "fingerprint_daily" | "ip_hourly";
    retry_after_seconds?: number;
}

async function checkRateLimit(args: RateLimitArgs): Promise<RateLimitResult> {
    if (!args.env.RATE_LIMIT) return { allowed: true }; // fail-open if KV missing

    const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
    const hour = new Date().toISOString().slice(0, 13); // YYYY-MM-DDTHH

    const fpKey = `rl:${args.scope}:fp:${args.fingerprint}:${today}`;
    const ipKey = `rl:${args.scope}:ip:${args.ip}:${hour}`;

    const [fpVal, ipVal] = await Promise.all([
        args.env.RATE_LIMIT.get(fpKey),
        args.env.RATE_LIMIT.get(ipKey),
    ]);
    const fpCount = fpVal ? parseInt(fpVal, 10) : 0;
    const ipCount = ipVal ? parseInt(ipVal, 10) : 0;

    if (fpCount >= args.per_fp_per_day) {
        // Compute retry — top of next UTC day
        const tomorrow = new Date();
        tomorrow.setUTCDate(tomorrow.getUTCDate() + 1);
        tomorrow.setUTCHours(0, 0, 0, 0);
        const retry = Math.max(60, Math.floor((tomorrow.getTime() - Date.now()) / 1000));
        return { allowed: false, scope: "fingerprint_daily", retry_after_seconds: retry };
    }
    if (ipCount >= args.per_ip_per_hour) {
        // Compute retry — top of next hour
        const nextHour = new Date();
        nextHour.setUTCHours(nextHour.getUTCHours() + 1, 0, 0, 0);
        const retry = Math.max(60, Math.floor((nextHour.getTime() - Date.now()) / 1000));
        return { allowed: false, scope: "ip_hourly", retry_after_seconds: retry };
    }

    // Increment both counters (fail-soft on errors)
    await Promise.allSettled([
        args.env.RATE_LIMIT.put(fpKey, String(fpCount + 1), { expirationTtl: 25 * 3600 }),
        args.env.RATE_LIMIT.put(ipKey, String(ipCount + 1), { expirationTtl: 65 * 60 }),
    ]);

    return { allowed: true };
}

// =====================================================================
// Helpers
// =====================================================================

function ipFromRequest(request: Request): string {
    return (
        request.headers.get("CF-Connecting-IP") ||
        request.headers.get("X-Forwarded-For")?.split(",")[0].trim() ||
        "unknown"
    );
}

function jsonResp(body: any, status: number = 200, extraHeaders: Record<string, string> = {}): Response {
    return new Response(JSON.stringify(body), {
        status,
        headers: { "Content-Type": "application/json", ...extraHeaders },
    });
}
