// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// mcp/_shared/license-gate.mjs — Maxim MCP license middleware (v1.1.A, ESM)
//
// Single helper: requireValidLicense(toolName, requiredGrants[])
//
// PHASE B-2 — wired to Worker /issue + /validate. JWT signature verified locally
// via mcp/_shared/license-pubkey.pem (mirror of pack-engine/internal/jwt/keys/public.pem).
// PHASE B-3 — imported by 7 MCP servers; called at start of every @tool handler.

import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import crypto from "node:crypto";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import https from "node:https";
import http from "node:http";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// =====================================================================
// Constants
// =====================================================================

const MXM_PACKS_DIR = path.join(os.homedir(), ".mxm-packs");
const LICENSE_STATE_PATH = path.join(MXM_PACKS_DIR, "license-state.json");
const OWNER_KEY_PATH = path.join(MXM_PACKS_DIR, "owner.key");
const PUBLIC_KEY_PATH = path.join(__dirname, "license-pubkey.pem");
const HEARTBEAT_INTERVAL_MS = 24 * 60 * 60 * 1000; // 24h

const WORKER_URL = process.env.MXM_LICENSE_WORKER_URL || "https://maxim-license-api.isystematic.workers.dev";
const WORKER_TIMEOUT_MS = 10_000;

const SCHEMA_VERSION = "maxim-license-state-v1";
const CLIENT_VERSION = "1.1.0-rc.1";

let _cachedPublicKey = null;

// =====================================================================
// Public API — Phase B-3 monkey-patch wrapper
// =====================================================================

/**
 * Wrap an MCP server's `tool()` method so every registered tool is automatically
 * license-gated. Call once after `new McpServer({...})`, before registering tools.
 *
 * @param {object} server         — MCP server instance (must have `.tool()` method)
 * @param {string} serverName     — e.g. "mxm-portfolio" (used in audit log + grant lookup)
 * @param {Object<string,string[]>} grantMap — optional tool-name → required-grants map.
 *                                              Tools not listed default to no grants required (any tier OK).
 */
export function wrapServerWithLicenseGate(server, serverName, grantMap = {}) {
  const originalTool = server.tool.bind(server);
  server.tool = function gatedTool(name, ...rest) {
    // The MCP SDK's tool() signature varies by SDK version; the handler is always
    // the LAST arg. Wrap it; pass everything else through unchanged.
    const handler = rest.pop();
    if (typeof handler !== "function") {
      // Defensive: if last arg isn't a function, register as-is and skip gating.
      return originalTool(name, ...rest, handler);
    }
    const requiredGrants = grantMap[name] || [];
    const fullToolName = `${serverName}.${name}`;
    const gatedHandler = async (...args) => {
      try {
        await requireValidLicense(fullToolName, requiredGrants);
      } catch (err) {
        const isLicenseErr = err instanceof LicenseError;
        return {
          content: [{
            type: "text",
            text: isLicenseErr
              ? `Maxim license check failed: ${err.code} — ${err.message}`
              : `License gate error: ${err.message}`,
          }],
          isError: true,
        };
      }
      return await handler(...args);
    };
    return originalTool(name, ...rest, gatedHandler);
  };
}

// =====================================================================
// Public API — direct call (Phase B-3 alternative for non-McpServer surfaces)
// =====================================================================

export async function requireValidLicense(toolName, requiredGrants = []) {
  // 1. Owner-key bypass — wins before anything else (per G6: full bypass)
  if (hasOwnerKey()) {
    return {
      tier: "owner",
      grants: ["*"],
      superUser: true,
      jwtExp: null,
    };
  }

  // 2. Read cache (with first-run bootstrap if missing)
  let state;
  try {
    state = readLicenseState();
  } catch (err) {
    if (err.code === "ENOENT") {
      state = await firstRunFlow();
    } else {
      throw err;
    }
  }

  // 3. Verify JWT signature locally (defense-in-depth against cache tampering)
  if (fs.existsSync(PUBLIC_KEY_PATH)) {
    try {
      verifyJwtSignature(state.jwt);
    } catch (err) {
      throw new LicenseError(
        "JWT_INVALID",
        `License JWT failed local signature verification: ${err.message}. Run /mxm-license refresh to re-issue.`,
      );
    }
  }

  // 4. JWT expiry hard gate
  const now = Date.now();
  const expiresAt = Date.parse(state.expires_at);
  if (Number.isNaN(expiresAt) || now >= expiresAt) {
    throw new LicenseError(
      "JWT_EXPIRED",
      `License JWT expired at ${state.expires_at}. Run /mxm-license refresh to renew (requires online connectivity).`,
    );
  }

  // 5. Heartbeat soft gate — fire-and-forget; never blocks tool call
  const lastValidated = Date.parse(state.last_validated_at);
  if (Number.isNaN(lastValidated) || now - lastValidated > HEARTBEAT_INTERVAL_MS) {
    triggerBackgroundHeartbeat(state);
  }

  // 6. Grant verification
  const missing = requiredGrants.filter(
    (g) => !state.grants.includes(g) && !state.grants.includes("*"),
  );
  if (missing.length > 0) {
    throw new LicenseError(
      "GRANTS_INSUFFICIENT",
      `Tool ${toolName} requires grants [${missing.join(", ")}] not present in tier ${state.tier}. ` +
        `Upgrade or purchase the relevant vertical overlay. See /mxm-license tiers.`,
    );
  }

  return {
    tier: state.tier,
    grants: state.grants,
    superUser: false,
    jwtExp: state.expires_at,
  };
}

// =====================================================================
// First-run flow — issue anonymous Starter JWT
// =====================================================================

async function firstRunFlow() {
  const fingerprint = getMachineFingerprint();
  if (!fingerprint) {
    throw new LicenseError(
      "FIRST_RUN_FAILED",
      "Cannot derive machine fingerprint (mxm-pack-engine binary not found). " +
        "Ensure pack-engine is installed at ~/.mxm-packs/mxm-pack-engine[.exe] or on PATH.",
    );
  }

  let response;
  try {
    response = await postJson(`${WORKER_URL}/issue`, {
      machine_fingerprint: fingerprint,
      client_version: CLIENT_VERSION,
    });
  } catch (err) {
    throw new LicenseError(
      "FIRST_RUN_FAILED",
      `Worker /issue unreachable: ${err.message}. Maxim cannot bootstrap a license without network on first run. ` +
        `Connect to the internet and retry, or run /mxm-license activate <jwt> manually.`,
    );
  }

  if (!response.jwt || !response.tier || !response.grants || !response.expires_at) {
    throw new LicenseError(
      "FIRST_RUN_FAILED",
      `Worker /issue returned malformed response. Got keys: ${Object.keys(response).join(", ")}`,
    );
  }

  const nowIso = new Date().toISOString();
  const newState = {
    schema: SCHEMA_VERSION,
    jwt: response.jwt,
    tier: response.tier,
    grants: response.grants,
    machine_fingerprint: fingerprint,
    issued_at: nowIso,
    expires_at: response.expires_at,
    last_validated_at: nowIso,
  };

  if (!fs.existsSync(MXM_PACKS_DIR)) fs.mkdirSync(MXM_PACKS_DIR, { recursive: true });
  const tmpPath = LICENSE_STATE_PATH + ".tmp." + process.pid;
  fs.writeFileSync(tmpPath, JSON.stringify(newState, null, 2), "utf8");
  fs.renameSync(tmpPath, LICENSE_STATE_PATH);

  return newState;
}

// =====================================================================
// Heartbeat — fire-and-forget validation
// =====================================================================

function triggerBackgroundHeartbeat(state) {
  setImmediate(async () => {
    try {
      const response = await postJson(`${WORKER_URL}/validate`, { jwt: state.jwt });

      if (response.valid === false) {
        process.stderr.write(
          `[mxm-license] Worker reports JWT invalid (${response.error || "unknown"}); ` +
            `cache will continue working until expiry at ${state.expires_at}\n`,
        );
        return;
      }

      const updated = {
        ...state,
        last_validated_at: new Date().toISOString(),
        tier: response.tier || state.tier,
        grants: response.grants || state.grants,
        expires_at: response.expires_at || state.expires_at,
      };

      const tmpPath = LICENSE_STATE_PATH + ".tmp." + process.pid;
      fs.writeFileSync(tmpPath, JSON.stringify(updated, null, 2), "utf8");
      fs.renameSync(tmpPath, LICENSE_STATE_PATH);
    } catch {
      // Swallow. Heartbeat retries on next tool call > 24h later.
    }
  });
}

// =====================================================================
// JWT signature verification (RS256, local public key)
// =====================================================================

function verifyJwtSignature(token) {
  if (!_cachedPublicKey) {
    _cachedPublicKey = fs.readFileSync(PUBLIC_KEY_PATH, "utf8");
  }

  const parts = token.split(".");
  if (parts.length !== 3) throw new Error("malformed JWT (expected 3 parts)");

  const [headerB64, payloadB64, sigB64] = parts;
  const signedInput = Buffer.from(`${headerB64}.${payloadB64}`, "utf8");
  const sig = Buffer.from(b64UrlToB64(sigB64), "base64");

  const verifier = crypto.createVerify("RSA-SHA256");
  verifier.update(signedInput);
  const ok = verifier.verify(_cachedPublicKey, sig);
  if (!ok) throw new Error("RSA-SHA256 signature mismatch");
}

function b64UrlToB64(s) {
  return s.replace(/-/g, "+").replace(/_/g, "/") + "=".repeat((4 - (s.length % 4)) % 4);
}

// =====================================================================
// HTTPS POST helper
// =====================================================================

function postJson(url, body) {
  return new Promise((resolve, reject) => {
    const u = new URL(url);
    const isHttps = u.protocol === "https:";
    const lib = isHttps ? https : http;
    const data = JSON.stringify(body);

    const req = lib.request(
      {
        method: "POST",
        hostname: u.hostname,
        port: u.port || (isHttps ? 443 : 80),
        path: u.pathname + u.search,
        headers: {
          "Content-Type": "application/json",
          "Content-Length": Buffer.byteLength(data),
          "User-Agent": `mxm-license-gate/${CLIENT_VERSION}`,
        },
        timeout: WORKER_TIMEOUT_MS,
      },
      (res) => {
        let chunks = "";
        res.on("data", (c) => (chunks += c));
        res.on("end", () => {
          try {
            const parsed = JSON.parse(chunks);
            if (res.statusCode >= 400 && parsed.error !== "expired") {
              const err = new Error(`Worker ${url} returned ${res.statusCode}: ${parsed.error || chunks}`);
              err.statusCode = res.statusCode;
              err.body = parsed;
              return reject(err);
            }
            resolve(parsed);
          } catch (e) {
            reject(new Error(`Worker returned non-JSON (status ${res.statusCode}): ${chunks.slice(0, 200)}`));
          }
        });
      },
    );

    req.on("error", reject);
    req.on("timeout", () => {
      req.destroy();
      reject(new Error(`Worker request timed out after ${WORKER_TIMEOUT_MS}ms`));
    });
    req.write(data);
    req.end();
  });
}

// =====================================================================
// Internal helpers
// =====================================================================

function hasOwnerKey() {
  try {
    fs.accessSync(OWNER_KEY_PATH, fs.constants.R_OK);
    return true;
  } catch {
    return false;
  }
}

function readLicenseState() {
  let raw;
  try {
    raw = fs.readFileSync(LICENSE_STATE_PATH, "utf8");
  } catch (err) {
    throw err;
  }
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (err) {
    throw new LicenseError(
      "CACHE_CORRUPT",
      `license-state.json failed to parse: ${err.message}. Run /mxm-license refresh.`,
    );
  }
  if (parsed.schema && parsed.schema !== SCHEMA_VERSION) {
    throw new LicenseError(
      "CACHE_SCHEMA_MISMATCH",
      `license-state.json schema ${parsed.schema} not supported (expected ${SCHEMA_VERSION}). Run /mxm-license refresh.`,
    );
  }
  return parsed;
}

function getMachineFingerprint() {
  const candidates = [
    path.join(MXM_PACKS_DIR, "mxm-pack-engine"),
    path.join(MXM_PACKS_DIR, "mxm-pack-engine.exe"),
    "mxm-pack-engine",
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

export class LicenseError extends Error {
  constructor(code, message) {
    super(message);
    this.name = "LicenseError";
    this.code = code;
  }
}

// Internal (test) exports
export const _internal = {
  hasOwnerKey,
  readLicenseState,
  getMachineFingerprint,
  verifyJwtSignature,
  firstRunFlow,
  triggerBackgroundHeartbeat,
  postJson,
  LICENSE_STATE_PATH,
  OWNER_KEY_PATH,
  PUBLIC_KEY_PATH,
  SCHEMA_VERSION,
  HEARTBEAT_INTERVAL_MS,
  WORKER_URL,
};
