#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// Tests for spawn-with-deps.mjs completeness detection (BUG-014, v1.3.9.1).
// Run: node --test mcp/_shared/spawn-with-deps.test.mjs
//
// The bug: node_modules/ existed but a whole dependency dir was MISSING (the
// operator's `zod`), so the MCP server crashed on import. depsComplete() must
// catch that WITHOUT false-positiving a valid install — in particular a package
// whose "." export targets a file it doesn't publish (the real MCP SDK shape),
// which the first fix attempt wrongly flagged incomplete (pre-release audit).

import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { depInstalled, depsComplete } from "./spawn-with-deps.mjs";

const TMP = fs.mkdtempSync(path.join(os.tmpdir(), "mxm-swd-test-"));
process.on("exit", () => { try { fs.rmSync(TMP, { recursive: true, force: true }); } catch {} });

// Build a fake server dir. Each `installed` entry writes node_modules/<name>/package.json.
// Omit a declared dep from `installed` to simulate a whole dep dir missing.
// entryFile + entryPresent:false models a package.json entry whose target file
// is NOT shipped (proves depInstalled ignores entry files by design).
function mkServer({ deps, optionalDeps, installed = [], noPkg = false } = {}) {
  const dir = fs.mkdtempSync(path.join(TMP, "srv-"));
  if (!noPkg) {
    const pkg = { name: "test-server", version: "1.0.0" };
    if (deps) pkg.dependencies = deps;
    if (optionalDeps) pkg.optionalDependencies = optionalDeps;
    fs.writeFileSync(path.join(dir, "package.json"), JSON.stringify(pkg));
  }
  for (const inst of installed) {
    const depDir = path.join(dir, "node_modules", ...inst.name.split("/"));
    fs.mkdirSync(depDir, { recursive: true });
    const dp = { name: inst.name, version: "1.0.0" };
    if (inst.main) dp.main = inst.main;
    if (inst.exports) dp.exports = inst.exports;
    fs.writeFileSync(path.join(depDir, "package.json"), JSON.stringify(dp));
    if (inst.entryFile && inst.entryPresent !== false) {
      const f = path.join(depDir, inst.entryFile.replace(/^\.\//, ""));
      fs.mkdirSync(path.dirname(f), { recursive: true });
      fs.writeFileSync(f, "// entry");
    }
  }
  return dir;
}

test("no package.json → complete (nothing to manage)", () => {
  assert.equal(depsComplete(mkServer({ noPkg: true })), true);
});

test("empty dependencies → complete", () => {
  assert.equal(depsComplete(mkServer({ deps: {} })), true);
});

test("all declared deps installed → complete", () => {
  const dir = mkServer({
    deps: { "@modelcontextprotocol/sdk": "^1.29.0", zod: "^3.24.0" },
    installed: [{ name: "@modelcontextprotocol/sdk" }, { name: "zod" }],
  });
  assert.equal(depsComplete(dir), true);
});

test("node_modules missing entirely → incomplete", () => {
  assert.equal(depsComplete(mkServer({ deps: { zod: "^3.24.0" } })), false);
});

test("a whole dep dir missing (the operator's 'zod missing') → incomplete", () => {
  const dir = mkServer({
    deps: { "@modelcontextprotocol/sdk": "^1.29.0", zod: "^3.24.0" },
    installed: [{ name: "@modelcontextprotocol/sdk" }], // zod NOT installed
  });
  assert.equal(depsComplete(dir), false);
});

test("REGRESSION (BUG-014 audit): a dep whose '.' export targets a NON-shipped file is still complete", () => {
  // The real @modelcontextprotocol/sdk@1.29.0: "." → ./dist/esm/index.js is NOT
  // published (consumers import subpaths). Verifying the "." entry FILE would
  // false-positive this valid install and delete + reinstall on every spawn.
  const dir = mkServer({
    deps: { "@modelcontextprotocol/sdk": "^1.29.0" },
    installed: [{
      name: "@modelcontextprotocol/sdk",
      exports: { ".": { import: "./dist/esm/index.js" } },
      entryFile: "./dist/esm/index.js",
      entryPresent: false, // "." target intentionally absent on disk
    }],
  });
  assert.equal(depsComplete(dir), true);
});

test("scoped dep installed → complete", () => {
  const dir = mkServer({ deps: { "@hono/node-server": "^1" }, installed: [{ name: "@hono/node-server" }] });
  assert.equal(depsComplete(dir), true);
});

test("optionalDependencies absent do NOT force a rebuild", () => {
  const dir = mkServer({
    deps: { zod: "^3.24.0" },
    optionalDeps: { fsevents: "^2" }, // legitimately absent on non-macOS
    installed: [{ name: "zod" }],
  });
  assert.equal(depsComplete(dir), true);
});

test("depInstalled: package.json present → true; missing dir / corrupt json → false", () => {
  const base = fs.mkdtempSync(path.join(TMP, "dep-"));
  const good = path.join(base, "good"); fs.mkdirSync(good);
  fs.writeFileSync(path.join(good, "package.json"), JSON.stringify({ name: "good" }));
  assert.equal(depInstalled(good), true);
  assert.equal(depInstalled(path.join(base, "absent")), false); // dep dir missing
  const corrupt = path.join(base, "corrupt"); fs.mkdirSync(corrupt);
  fs.writeFileSync(path.join(corrupt, "package.json"), "{ not json");
  assert.equal(depInstalled(corrupt), false); // corrupt package.json
});
