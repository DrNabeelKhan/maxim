#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// mxm-desktop-launcher.mjs — stable-path Desktop MCP launcher (BUG-015 fix).
//
// Claude Desktop's MCP config (claude_desktop_config.json) is NOT managed by
// `claude plugin update`. When the config hard-codes a version dir
// (…/maxim/1.3.9/mcp/…), the next native update writes a NEW version dir and
// orphans the config → every mxm-* server shows "failed / Server disconnected".
//
// This launcher removes the version from the config entirely. It is installed
// ONCE at a stable user path (~/.claude/.mxm/desktop-launcher.mjs by the
// mxm-desktop-config helper) and the config points at it with just a server
// NAME. At spawn time it resolves the LATEST installed Maxim version and
// delegates to that version's spawn-with-deps.mjs — so updates are picked up
// automatically and the Desktop config never needs re-pointing again.
//
// Usage (written into claude_desktop_config.json by mxm-desktop-config):
//   "command": "node",
//   "args": ["<home>/.claude/.mxm/desktop-launcher.mjs", "mxm-context"]
//
// Diagnostics → stderr only; stdout is the server's MCP JSON-RPC channel.

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const serverName = process.argv[2];
if (!serverName) {
  console.error("mxm-desktop-launcher: missing server name argument (argv[2])");
  process.exit(1);
}

const cacheDir = path.join(os.homedir(), ".claude", "plugins", "cache", "maxim-packs", "maxim");

let candidates;
try {
  candidates = fs
    .readdirSync(cacheDir, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    // Only versions that actually ship the wrapper — skips orphaned/empty dirs
    // (e.g. the old cosmetic 1.1.0 dir that native updates left behind).
    .filter((d) => fs.existsSync(path.join(cacheDir, d.name, "mcp", "_shared", "spawn-with-deps.mjs")))
    .map((d) => ({ name: d.name, mtime: fs.statSync(path.join(cacheDir, d.name)).mtimeMs }))
    .sort((a, b) => b.mtime - a.mtime); // newest install first (matches the helper)
} catch (err) {
  console.error(`mxm-desktop-launcher: cannot read plugin cache at ${cacheDir}: ${err?.message ?? err}`);
  process.exit(1);
}

if (candidates.length === 0) {
  console.error("mxm-desktop-launcher: no installed Maxim version with mcp/_shared/spawn-with-deps.mjs found.");
  console.error("  Run '/plugin install maxim@maxim-packs' in Claude Code, then re-run bootstrap/mxm-desktop-config.");
  process.exit(1);
}

const root = path.join(cacheDir, candidates[0].name);
const wrapper = path.join(root, "mcp", "_shared", "spawn-with-deps.mjs");
const serverJs = path.join(root, "mcp", serverName, "server.js");

if (!fs.existsSync(serverJs)) {
  console.error(`mxm-desktop-launcher: server not found for "${serverName}" in ${root} (${serverJs}).`);
  process.exit(1);
}

// Rewrite argv so spawn-with-deps.mjs sees the resolved server.js as argv[2] and
// runs its main flow (its guard requires argv[1] === its own module path). The
// wrapper then completeness-checks / rebuilds deps and imports the server.
process.argv = [process.argv[0], wrapper, serverJs];
try {
  await import(pathToFileURL(wrapper).href);
} catch (err) {
  console.error(`mxm-desktop-launcher: failed to delegate to ${wrapper}: ${err?.message ?? err}`);
  process.exit(1);
}
