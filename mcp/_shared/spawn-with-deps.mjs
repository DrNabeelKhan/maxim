#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// mcp/_shared/spawn-with-deps.mjs — synchronous dep-install wrapper for MCP servers.
//
// BUG-007 follow-up (v1.1.0.3): collapses 2-restart upgrade to 1-restart.
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
if (!serverPath) {
  console.error("mxm-spawn-with-deps: missing server path argument (argv[2])");
  process.exit(1);
}

// PLUGIN_ROOT = parent of mcp/ dir.
// server.js lives at <PLUGIN_ROOT>/mcp/<name>/server.js, so two dirname-ups.
const PLUGIN_ROOT = path.resolve(path.dirname(serverPath), "..", "..");
const MCP_DIR = path.join(PLUGIN_ROOT, "mcp");
const SENTINEL = path.join(PLUGIN_ROOT, ".mcp-deps-installed");
const LOCK_FILE = path.join(PLUGIN_ROOT, ".mcp-install-lock");

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

function depsAllPresent() {
  const servers = listMcpServers();
  if (servers.length === 0) return false;
  return servers.every((s) => {
    const pkgJson = path.join(MCP_DIR, s, "package.json");
    if (!fs.existsSync(pkgJson)) return true; // server has no deps to install
    return fs.existsSync(path.join(MCP_DIR, s, "node_modules"));
  });
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
    console.error("Maxim: installing MCP server dependencies (first run, ~30–60 sec)…");
    console.error("──────────────────────────────────────────────────────");

    const servers = listMcpServers();
    let installed = 0;
    let skipped = 0;
    let failed = 0;

    for (const srv of servers) {
      const srvDir = path.join(MCP_DIR, srv);
      const pkgPath = path.join(srvDir, "package.json");
      const nmPath = path.join(srvDir, "node_modules");
      if (!fs.existsSync(pkgPath)) { skipped++; continue; }
      if (fs.existsSync(nmPath)) { skipped++; continue; }
      try {
        console.error(`  installing ${srv}…`);
        execSync("npm install --omit=dev --no-audit --no-fund --silent", {
          cwd: srvDir,
          stdio: ["ignore", "ignore", "inherit"],
          timeout: PER_SERVER_INSTALL_TIMEOUT_MS,
        });
        installed++;
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
            skipped_count: skipped,
            plugin_root: PLUGIN_ROOT,
            installer: "spawn-with-deps.mjs",
          },
          null,
          2
        ),
      );
      console.error(`Maxim: MCP deps ready (installed: ${installed}, already-present: ${skipped}).`);
    } else {
      console.error(`Maxim: MCP install partial (installed: ${installed}, failed: ${failed}). The current server may not start cleanly.`);
    }
  } finally {
    if (acquired) releaseLock();
  }
}

// ──────────────────── Main flow ────────────────────

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
