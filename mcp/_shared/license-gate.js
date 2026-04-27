// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// mcp/_shared/license-gate.js — Maxim MCP license middleware (v1.1.A)
//
// Single helper: requireValidLicense(toolName, requiredGrants[])
//
// Per locked v1.1.A design (ADR-013, pending):
//   - Cache file at ~/.mxm-packs/license-state.json is the source of truth
//   - 99% of calls are local file I/O (no network)
//   - Worker hit only on: install/first-run, JWT expiry, daily heartbeat, manual refresh
//   - Owner-key bypass continues entirely (no JWT, no heartbeat) — tagged via SUPER_USER
//   - Anonymous Starter JWT auto-issued on first run; 30-day TTL; silent reissue on heartbeat
//
// Sprint scope (this file):
//   - PHASE B-1: cache-file logic + owner-key bypass + grant verification (THIS COMMIT)
//   - PHASE B-2: Worker /issue and /validate calls (NEXT SESSION)
//   - PHASE B-3: 7 MCP server wiring (NEXT SESSION)
//   - PHASE B-4: E2E test fixtures (NEXT SESSION)

"use strict";

const fs = require("fs");
const path = require("path");
const os = require("os");
const { execFileSync } = require("child_process");

// =====================================================================
// Constants
// =====================================================================

const MXM_PACKS_DIR = path.join(os.homedir(), ".mxm-packs");
const LICENSE_STATE_PATH = path.join(MXM_PACKS_DIR, "license-state.json");
const OWNER_KEY_PATH = path.join(MXM_PACKS_DIR, "owner.key");
const HEARTBEAT_INTERVAL_MS = 24 * 60 * 60 * 1000; // 24h

// Daily-cadence model: only hit Worker on install / expiry / heartbeat / manual.
// Tool calls never hit network — they read this cache.
const SCHEMA_VERSION = "maxim-license-state-v1";

// =====================================================================
// Public API — only export
// =====================================================================

/**
 * Gate any MCP tool call. Throws on denial; returns license context on success.
 *
 * @param {string} toolName — e.g. "mxm-behavioral.apply_framework". For audit log.
 * @param {string[]} requiredGrants — grants that must be present. Empty = any tier OK.
 * @returns {{ tier: string, grants: string[], superUser: boolean, jwtExp: string }}
 *
 * Throws:
 *   - LicenseError("OWNER_BYPASS_FAILED")      — owner key present but unreadable
 *   - LicenseError("FIRST_RUN_REQUIRED")       — no cache file; needs Worker /issue (Phase B-2)
 *   - LicenseError("JWT_EXPIRED")              — cache exists but expires_at passed
 *   - LicenseError("GRANTS_INSUFFICIENT")      — tier/pack does not include required grants
 *   - LicenseError("CACHE_CORRUPT")            — JSON parse failure
 */
async function requireValidLicense(toolName, requiredGrants = []) {
  // 1. Owner-key bypass — wins before anything else (per G6: full bypass, no JWT, no heartbeat)
  if (hasOwnerKey()) {
    return {
      tier: "owner",
      grants: ["*"], // wildcard
      superUser: true, // every output tags 🔵 SUPER USER per G6
      jwtExp: null,
    };
  }

  // 2. Read cache
  let state;
  try {
    state = readLicenseState();
  } catch (err) {
    if (err.code === "ENOENT") {
      // First-run flow — needs Worker /issue. Phase B-2 will wire this.
      throw new LicenseError(
        "FIRST_RUN_REQUIRED",
        "No license-state.json found. First-run flow not yet implemented (v1.1.A Phase B-2). " +
          "Manual workaround: run /mxm-license activate <jwt> once Phase B-2 ships."
      );
    }
    throw err;
  }

  // 3. JWT expiry check (hard gate — fail-closed)
  const now = Date.now();
  const expiresAt = Date.parse(state.expires_at);
  if (Number.isNaN(expiresAt) || now >= expiresAt) {
    throw new LicenseError(
      "JWT_EXPIRED",
      `License JWT expired at ${state.expires_at}. ` +
        `Run /mxm-license refresh to renew (requires online connectivity).`
    );
  }

  // 4. Heartbeat check (soft gate — never blocks tool call)
  // If 24h has elapsed since last_validated_at, fire-and-forget background refresh.
  // Tool call proceeds with cached state regardless of refresh outcome.
  const lastValidated = Date.parse(state.last_validated_at);
  if (Number.isNaN(lastValidated) || now - lastValidated > HEARTBEAT_INTERVAL_MS) {
    triggerBackgroundHeartbeat(state); // never throws, never awaited
  }

  // 5. Grant verification
  const missing = requiredGrants.filter(
    (g) => !state.grants.includes(g) && !state.grants.includes("*")
  );
  if (missing.length > 0) {
    throw new LicenseError(
      "GRANTS_INSUFFICIENT",
      `Tool ${toolName} requires grants [${missing.join(", ")}] not present in tier ${state.tier}. ` +
        `Upgrade or purchase the relevant vertical overlay. See /mxm-license tiers.`
    );
  }

  // 6. Success
  return {
    tier: state.tier,
    grants: state.grants,
    superUser: false,
    jwtExp: state.expires_at,
  };
}

// =====================================================================
// Internal helpers
// =====================================================================

/**
 * Owner-key bypass. Mirrors pack-engine/internal/owner/bypass.go semantics:
 * if ~/.mxm-packs/owner.key exists, license checks are bypassed entirely.
 */
function hasOwnerKey() {
  try {
    fs.accessSync(OWNER_KEY_PATH, fs.constants.R_OK);
    return true;
  } catch {
    return false;
  }
}

/**
 * Read and parse the license-state cache.
 * Throws ENOENT if file is missing (caller distinguishes first-run case).
 * Throws LicenseError("CACHE_CORRUPT") on JSON parse failure.
 */
function readLicenseState() {
  let raw;
  try {
    raw = fs.readFileSync(LICENSE_STATE_PATH, "utf8");
  } catch (err) {
    throw err; // propagate ENOENT
  }
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (err) {
    throw new LicenseError(
      "CACHE_CORRUPT",
      `license-state.json failed to parse: ${err.message}. ` +
        `Run /mxm-license refresh to re-issue (requires online connectivity).`
    );
  }
  // Schema version check — future-proofing
  if (parsed.schema && parsed.schema !== SCHEMA_VERSION) {
    throw new LicenseError(
      "CACHE_SCHEMA_MISMATCH",
      `license-state.json schema ${parsed.schema} not supported by this client (expected ${SCHEMA_VERSION}). ` +
        `Run /mxm-license refresh.`
    );
  }
  return parsed;
}

/**
 * Fire-and-forget heartbeat refresh. Never blocks tool calls. Never throws.
 *
 * Phase B-1 (this commit): no-op stub. Logs intent only.
 * Phase B-2 (next session): POST /validate to Worker, update last_validated_at + grants.
 */
function triggerBackgroundHeartbeat(state) {
  // Detached — never await. Errors swallowed deliberately so tool calls
  // proceed with cached state when Worker is unreachable.
  setImmediate(() => {
    try {
      // Phase B-2: replace this no-op with Worker /validate POST.
      // Until then, just bump last_validated_at locally so we don't spam every call.
      // (This is a degraded mode that keeps Phase B-1 functional without Worker.)
      const next = { ...state, last_validated_at: new Date().toISOString() };
      fs.writeFileSync(LICENSE_STATE_PATH, JSON.stringify(next, null, 2), "utf8");
    } catch {
      // Swallow. Heartbeat retry happens on next tool call > 24h later.
    }
  });
}

/**
 * Get machine fingerprint by spawning pack-engine binary.
 * Reuses the canonical algorithm (sha256(cpu_id|disk_serial|primary_mac))
 * to avoid Node-vs-Go drift. Per locked design: zero algorithm duplication.
 *
 * Phase B-1: helper exposed for first-run flow (Phase B-2) to call.
 * Returns null if pack-engine binary not found — first-run will degrade gracefully.
 */
function getMachineFingerprint() {
  const candidates = [
    path.join(MXM_PACKS_DIR, "mxm-pack-engine"),
    path.join(MXM_PACKS_DIR, "mxm-pack-engine.exe"),
    "mxm-pack-engine", // PATH fallback
  ];
  for (const bin of candidates) {
    try {
      const out = execFileSync(bin, ["--fingerprint"], {
        encoding: "utf8",
        timeout: 10_000,
        stdio: ["ignore", "pipe", "ignore"],
      });
      const fp = out.trim();
      if (/^[a-f0-9]{64}$/i.test(fp)) return fp;
    } catch {
      // try next candidate
    }
  }
  return null;
}

// =====================================================================
// Error class
// =====================================================================

class LicenseError extends Error {
  constructor(code, message) {
    super(message);
    this.name = "LicenseError";
    this.code = code;
  }
}

// =====================================================================
// Exports
// =====================================================================

module.exports = {
  requireValidLicense,
  LicenseError,
  // exposed for Phase B-2 first-run flow + tests
  _internal: {
    hasOwnerKey,
    readLicenseState,
    getMachineFingerprint,
    LICENSE_STATE_PATH,
    OWNER_KEY_PATH,
    SCHEMA_VERSION,
    HEARTBEAT_INTERVAL_MS,
  },
};
