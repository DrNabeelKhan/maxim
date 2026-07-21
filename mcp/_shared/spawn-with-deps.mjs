#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// mcp/_shared/spawn-with-deps.mjs — synchronous dep-install wrapper for MCP servers.
//
// BUG-007 follow-up (v1.1.0.3): collapses 2-restart upgrade to 1-restart.
//
// Donor reuse (v1.3.7): the native `claude plugin update` installs a new
// version dir WITHOUT node_modules, so a first spawn used to npm-install all
// servers (slow, online-only). On any UPDATE a prior version dir still sits
// beside this one with valid node_modules; when its deps match we copy them in
// offline instead of installing — making updates invisible for all users on
// every surface that runs MCPs. Fresh installs (no donor) still npm-install.
//
// Without this wrapper, the SessionStart hook (.claude/hooks/session-start.{sh,ps1})
// runs AFTER Claude Code has already tried to spawn the 7 MCP servers (and failed
// with ERR_MODULE_NOT_FOUND because node_modules are absent). User has to restart
// twice: first to trigger the hook's install, second to spawn with deps present.
//
// With this wrapper, each MCP server spawn:
//   1. Resolves PLUGIN_ROOT from the server.js path (argv[2])
//   2. Quick-checks if all 7 mcp/mxm-*/node_modules + sentinel exist
//   3. If missing: acquires a file-lock, runs npm install for any missing
//      server, writes the plugin-scoped sentinel, releases lock
//   4. Dynamically imports the requested server.js (stdio is inherited)
//
// File-lock prevents concurrent installs from parallel MCP server spawns —
// Claude Code spawns all 7 in parallel at session start. Stale-lock detection
// (>5 min mtime) recovers from crashed installs without manual cleanup.
//
// Usage in .mcp.json:
//   "command": "node",
//   "args": [
//     "${CLAUDE_PLUGIN_ROOT}/mcp/_shared/spawn-with-deps.mjs",
//     "${CLAUDE_PLUGIN_ROOT}/mcp/<server-name>/server.js"
//   ]
//
// Diagnostic output goes to stderr only — stdout is reserved for MCP JSON-RPC
// traffic owned by the imported server.js.

import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";
import { setTimeout as sleep } from "node:timers/promises";
import { pathToFileURL } from "node:url";

const serverPath = process.argv[2];

// PLUGIN_ROOT = parent of mcp/ dir. server.js lives at
// <PLUGIN_ROOT>/mcp/<name>/server.js, so two dirname-ups. Computed defensively
// (null when no server path) so this module can be IMPORTED by tests without
// argv[2] and without throwing — the argv guard lives in the main block below.
const PLUGIN_ROOT = serverPath ? path.resolve(path.dirname(serverPath), "..", "..") : null;
const MCP_DIR = PLUGIN_ROOT ? path.join(PLUGIN_ROOT, "mcp") : null;
const SENTINEL = PLUGIN_ROOT ? path.join(PLUGIN_ROOT, ".mcp-deps-installed") : null;
const LOCK_FILE = PLUGIN_ROOT ? path.join(PLUGIN_ROOT, ".mcp-install-lock") : null;

const LOCK_TIMEOUT_MS = 120_000; // 2 min — npm install can be slow on cold cache + slow disks
const LOCK_POLL_MS = 500;
const STALE_LOCK_AGE_MS = 300_000; // 5 min — recovery threshold for crashed installer
const PER_SERVER_INSTALL_TIMEOUT_MS = 90_000;

function listMcpServers() {
  if (!fs.existsSync(MCP_DIR)) return [];
  return fs.readdirSync(MCP_DIR).filter((d) => {
    if (!d.startsWith("mxm-")) return false;
    try {
      return fs.statSync(path.join(MCP_DIR, d)).isDirectory();
    } catch {
      return false;
    }
  });
}

// A declared dependency is "installed" when its package dir has a READABLE
// package.json. We deliberately do NOT verify a specific entry FILE: a package
// may legitimately publish subpath exports while its "." entry points at a file
// it does not ship — e.g. @modelcontextprotocol/sdk's "." → ./dist/esm/index.js,
// which is absent, while ./server/mcp.js (what the servers actually import) IS
// present. Checking the "." entry file FALSE-POSITIVES a valid install and would
// delete + reinstall a working tree on every spawn (BUG-014 audit, 2026-07-10).
// package.json presence reliably catches the real failure — a whole dependency
// dir missing (the operator's missing `zod`) and every interrupted/partial
// install — without ever flagging a valid tree. Pure fn — unit-testable.
export function depInstalled(depDir) {
  try {
    const meta = JSON.parse(fs.readFileSync(path.join(depDir, "package.json"), "utf8"));
    return meta !== null && typeof meta === "object";
  } catch {
    return false; // dep dir missing, or package.json missing/corrupt
  }
}

// node_modules is COMPLETE for a server when every *required* dependency is
// installed (readable package.json). Replaces the old existsSync(node_modules)
// check, which passed on a tree with whole deps missing (BUG-014). Only
// `dependencies` are gated; `optionalDependencies` may legitimately be absent.
// Pure fn (takes the server dir) — testable.
export function depsComplete(srvDir) {
  const pkgPath = path.join(srvDir, "package.json");
  if (!fs.existsSync(pkgPath)) return true; // no package.json → no deps to manage
  let pkg;
  try {
    pkg = JSON.parse(fs.readFileSync(pkgPath, "utf8"));
  } catch {
    return false; // corrupt package.json → force a rebuild
  }
  const deps = Object.keys(pkg.dependencies || {});
  if (deps.length === 0) return true;
  const nm = path.join(srvDir, "node_modules");
  if (!fs.existsSync(nm)) return false;
  for (const d of deps) {
    if (!depInstalled(path.join(nm, ...d.split("/")))) return false;
  }
  return true;
}

function depsAllPresent() {
  // Sentinel gate (v1.2.0.3): the sentinel is written ONLY after the install
  // loop completes for all servers — a fast negative when nothing is installed
  // yet. depsComplete() below is the real authority: it re-verifies each
  // server's node_modules is not just present but complete (BUG-014 fix).
  if (!fs.existsSync(SENTINEL)) return false;
  const servers = listMcpServers();
  if (servers.length === 0) return false;
  return servers.every((s) => depsComplete(path.join(MCP_DIR, s)));
}

function isLockStale() {
  if (!fs.existsSync(LOCK_FILE)) return false;
  try {
    const stat = fs.statSync(LOCK_FILE);
    return Date.now() - stat.mtimeMs > STALE_LOCK_AGE_MS;
  } catch {
    return false;
  }
}

function tryAcquireLock() {
  try {
    fs.writeFileSync(LOCK_FILE, JSON.stringify({ pid: process.pid, ts: Date.now() }), { flag: "wx" });
    return true;
  } catch {
    if (isLockStale()) {
      try {
        fs.unlinkSync(LOCK_FILE);
        // Single retry after stale-lock cleanup
        try {
          fs.writeFileSync(LOCK_FILE, JSON.stringify({ pid: process.pid, ts: Date.now() }), { flag: "wx" });
          return true;
        } catch {
          return false;
        }
      } catch {
        return false;
      }
    }
    return false;
  }
}

function releaseLock() {
  try {
    fs.unlinkSync(LOCK_FILE);
  } catch {}
}

// Deps signature = the dependency sets only (ignores name/version/scripts), so
// a matching prior-version server is a safe donor even across plugin versions.
function readDepsSignature(pkgPath) {
  try {
    const pkg = JSON.parse(fs.readFileSync(pkgPath, "utf8"));
    return JSON.stringify({ d: pkg.dependencies || {}, o: pkg.optionalDependencies || {} });
  } catch {
    return null;
  }
}

// Find a sibling installed version of THIS plugin that already has this
// server's node_modules with an identical dependency signature. The plugin
// cache layout is <marketplace>/<plugin>/<version>/, so sibling versions live
// in PLUGIN_ROOT's parent dir. Returns the donor node_modules path or null.
function findDonorNodeModules(srv) {
  const wantSig = readDepsSignature(path.join(MCP_DIR, srv, "package.json"));
  if (!wantSig) return null;
  const versionsDir = path.dirname(PLUGIN_ROOT);
  const current = path.basename(PLUGIN_ROOT);
  let siblings;
  try {
    siblings = fs.readdirSync(versionsDir);
  } catch {
    return null;
  }
  for (const v of siblings) {
    if (v === current) continue;
    const donorSrv = path.join(versionsDir, v, "mcp", srv);
    const donorNm = path.join(donorSrv, "node_modules");
    if (!fs.existsSync(donorNm)) continue;
    if (readDepsSignature(path.join(donorSrv, "package.json")) !== wantSig) continue;
    // Only reuse a donor whose node_modules is COMPLETE. Copying a truncated
    // donor is precisely how one broken install propagated across every version
    // dir on the operator's machine (BUG-014) — a bad donor must be skipped, not
    // copied forward. A later sibling (or npm install) provides the clean tree.
    if (depsComplete(donorSrv)) return donorNm;
  }
  return null;
}

async function installMissingDeps() {
  // Try to acquire the lock; another spawn-with-deps may already be installing.
  const start = Date.now();
  let acquired = tryAcquireLock();
  let announcedWait = false;

  while (!acquired && Date.now() - start < LOCK_TIMEOUT_MS) {
    if (!announcedWait) {
      console.error("mxm-spawn-with-deps: another install in progress, waiting…");
      announcedWait = true;
    }
    // While waiting, the other process may have completed — short-circuit if so.
    if (depsAllPresent() && fs.existsSync(SENTINEL)) {
      return;
    }
    await sleep(LOCK_POLL_MS);
    acquired = tryAcquireLock();
  }

  if (!acquired) {
    console.error("mxm-spawn-with-deps: lock timeout (2 min). Proceeding without lock — concurrent installs may race.");
  }

  try {
    // Re-verify under the lock — another process may have just finished.
    if (depsAllPresent() && fs.existsSync(SENTINEL)) {
      return;
    }

    console.error("──────────────────────────────────────────────────────");
    console.error("Maxim: preparing MCP server dependencies (first run)…");
    console.error("──────────────────────────────────────────────────────");

    const servers = listMcpServers();
    let installed = 0;
    let reused = 0;
    let skipped = 0;
    let failed = 0;

    for (const srv of servers) {
      const srvDir = path.join(MCP_DIR, srv);
      const pkgPath = path.join(srvDir, "package.json");
      const nmPath = path.join(srvDir, "node_modules");
      if (!fs.existsSync(pkgPath)) { skipped++; continue; }
      if (depsComplete(srvDir)) { skipped++; continue; }
      // node_modules present but INCOMPLETE (partial/truncated) — remove it so a
      // fresh donor-copy or install starts from a clean slate (BUG-014).
      if (fs.existsSync(nmPath)) {
        console.error(`  ${srv} node_modules incomplete — rebuilding…`);
        try { fs.rmSync(nmPath, { recursive: true, force: true }); } catch {}
      }
      // Prefer reusing a matching prior-version node_modules (offline, fast) —
      // this makes plugin updates invisible. Fall back to npm install on any failure.
      const donor = findDonorNodeModules(srv);
      if (donor) {
        try {
          console.error(`  reusing ${srv} deps from prior version…`);
          fs.cpSync(donor, nmPath, { recursive: true });
          // Verify the COPY landed complete — cpSync can be interrupted, and
          // Windows Defender has been observed truncating large copies.
          if (depsComplete(srvDir)) { reused++; continue; }
          console.error(`  reuse incomplete for ${srv}; installing instead`);
          try { fs.rmSync(nmPath, { recursive: true, force: true }); } catch {}
        } catch (err) {
          const msg = (err?.message || "copy error").split("\n")[0];
          console.error(`  reuse failed for ${srv} (${msg}); installing instead`);
          try { fs.rmSync(nmPath, { recursive: true, force: true }); } catch {}
        }
      }
      try {
        console.error(`  installing ${srv}…`);
        execSync("npm install --omit=dev --no-audit --no-fund --silent", {
          cwd: srvDir,
          stdio: ["ignore", "ignore", "inherit"],
          timeout: PER_SERVER_INSTALL_TIMEOUT_MS,
        });
        // Guard against a "green" npm exit that still left deps incomplete —
        // the sentinel must only be written when the tree is genuinely usable.
        if (depsComplete(srvDir)) {
          installed++;
        } else {
          console.error(`  FAIL ${srv}: install exited 0 but deps still incomplete`);
          failed++;
        }
      } catch (err) {
        const msg = (err?.message || "unknown error").split("\n")[0];
        console.error(`  FAIL ${srv}: ${msg}`);
        failed++;
      }
    }

    if (failed === 0) {
      fs.writeFileSync(
        SENTINEL,
        JSON.stringify(
          {
            installed_at: new Date().toISOString(),
            installed_count: installed,
            reused_count: reused,
            skipped_count: skipped,
            plugin_root: PLUGIN_ROOT,
            installer: "spawn-with-deps.mjs",
          },
          null,
          2
        ),
      );
      console.error(`Maxim: MCP deps ready (reused: ${reused}, installed: ${installed}, already-present: ${skipped}).`);
    } else {
      console.error(`Maxim: MCP install partial (reused: ${reused}, installed: ${installed}, failed: ${failed}). The current server may not start cleanly.`);
    }
  } finally {
    if (acquired) releaseLock();
  }
}

// ──────────────────── Main flow (only when run directly) ────────────────────
// Guarded so `import`-ing this module (e.g. from spawn-with-deps.test.mjs) does
// NOT trigger dep installation or spawn a server — it just exposes the helpers.
const isMain = Boolean(process.argv[1]) && pathToFileURL(process.argv[1]).href === import.meta.url;

if (isMain) {
  if (!serverPath) {
    console.error("mxm-spawn-with-deps: missing server path argument (argv[2])");
    process.exit(1);
  }

  if (!depsAllPresent()) {
    await installMissingDeps();
  }

  // Validate the requested server.js exists before importing.
  if (!fs.existsSync(serverPath)) {
    console.error(`mxm-spawn-with-deps: server file not found at ${serverPath}`);
    process.exit(1);
  }

  // Dynamic import — the imported module runs in this process and owns
  // stdin/stdout for MCP JSON-RPC. The wrapper has only written to stderr.
  // Use file:// URL form for cross-platform compatibility (especially Windows
  // drive-letter paths which break bare-string imports).
  try {
    await import(pathToFileURL(serverPath).href);
  } catch (err) {
    console.error(`mxm-spawn-with-deps: failed to load ${serverPath}: ${err?.message ?? err}`);
    process.exit(1);
  }
}
