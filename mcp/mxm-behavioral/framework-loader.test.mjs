// Tests for framework-loader.mjs — wiring the on-disk framework definitions
// (composable-skills/frameworks/*/SKILL.md) into mxm-behavioral.
//
// Context: recommend_frameworks offered 68 frameworks, but apply_framework and
// get_framework_details read a hardcoded map of 8. Asked for a framework the tool
// had just recommended, it answered `Framework "Prospect Theory" not found`. The
// 85 definitions already existed on disk; the MCP never read them.
//
// Run: node --test mcp/mxm-behavioral/framework-loader.test.mjs

import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";
import {
  normalize,
  parseDefinition,
  loadDefinitions,
  createResolver,
} from "./framework-loader.mjs";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const DIR = path.resolve(HERE, "../../composable-skills/frameworks");

const CURATED = {
  "Fogg Behavior Model": {
    description: "curated fogg",
    when_to_use: "curated",
    components: ["Motivation", "Ability", "Prompt"],
    application_steps: ["1. curated step"],
  },
};

// ---------------------------------------------------------------- loading

test("loads every definition directory on disk", () => {
  const dirs = fs.readdirSync(DIR).filter((d) => fs.existsSync(path.join(DIR, d, "SKILL.md")));
  const defs = loadDefinitions(DIR);
  assert.equal(defs.size, dirs.length);
  assert.ok(defs.size >= 85, `expected at least 85 definitions, got ${defs.size}`);
});

test("every definition yields the full detail shape the tools consume", () => {
  // apply_framework does detail.components.map(...) and application_steps.join(...),
  // and recommend_frameworks reads description and when_to_use. An empty field
  // would either throw or return a hollow answer.
  for (const [slug, def] of loadDefinitions(DIR)) {
    const d = def.detail;
    assert.ok(d.description && d.description.length > 20, `${slug}: description`);
    assert.ok(d.when_to_use && d.when_to_use.length > 5, `${slug}: when_to_use`);
    assert.ok(Array.isArray(d.components) && d.components.length > 0, `${slug}: components`);
    assert.ok(Array.isArray(d.application_steps) && d.application_steps.length > 0, `${slug}: application_steps`);
    for (const c of d.components) assert.ok(!c.includes("**"), `${slug}: markdown bold leaked into a component`);
  }
});

// ------------------------------------------------- the reported defect

test("Prospect Theory resolves, with real content from its definition", () => {
  const r = createResolver({ curated: CURATED, dir: DIR });
  const hit = r.resolve("Prospect Theory");
  assert.ok(hit, "Prospect Theory must resolve");
  assert.equal(hit.source, "definition");
  assert.match(hit.detail.description, /decision|risk|framing|pricing/i);
  assert.ok(hit.detail.components.some((c) => /loss|reference|probability/i.test(c)));
});

test("resolves by slug, lowercase name, and full parenthetical name", () => {
  const r = createResolver({ curated: CURATED, dir: DIR });
  const a = r.resolve("prospect-theory");
  const b = r.resolve("prospect theory");
  const c = r.resolve("Prospect Theory (Loss Aversion · Reference Dependence · Probability Weighting)");
  assert.ok(a && b && c);
  assert.equal(a.name, b.name);
  assert.equal(b.name, c.name);
});

// ------------------------------------------------- backwards compatibility

test("a curated framework still wins over a same-named definition", () => {
  const r = createResolver({ curated: CURATED, dir: DIR });
  const hit = r.resolve("Fogg Behavior Model");
  assert.equal(hit.source, "curated");
  assert.equal(hit.detail.description, "curated fogg");
});

test("unknown framework returns null rather than a wrong guess", () => {
  const r = createResolver({ curated: CURATED, dir: DIR });
  assert.equal(r.resolve("Definitely Not A Real Framework Xyzzy"), null);
});

test("very short queries do not partial-match everything", () => {
  // A one- or two-letter query would otherwise match the first name containing
  // it and return a confident, wrong framework.
  const r = createResolver({ curated: CURATED, dir: DIR });
  assert.equal(r.resolve("a"), null);
  assert.equal(r.resolve("to"), null);
});

// ------------------------------------------------- performance contract

test("does not touch the filesystem until the first lookup", () => {
  // Startup time is what failed when every MCP server hit CONNECT_TIMEOUT.
  // Construction must stay free; loading happens lazily, once.
  let reads = 0;
  const r = createResolver({ curated: CURATED, dir: DIR, onLoad: () => { reads++; } });
  assert.equal(reads, 0);
  r.resolve("Prospect Theory");
  r.resolve("COM-B");
  assert.equal(reads, 1);
});

// ------------------------------------------------- stub classification
//
// 63 of the 85 definitions are generated template text: every field is the same
// sentence with only the name swapped. Serving them through apply_framework would
// return filler presented as a real framework, from a paid-tier tool.

test("classifies the corpus into authored, partial and stub", () => {
  const defs = [...loadDefinitions(DIR).values()];
  const count = (s) => defs.filter((d) => d.status === s).length;
  // Pinned on purpose. If someone authors a stub, these numbers move and this
  // test fails loudly, which is the signal to update them deliberately.
  assert.equal(count("stub"), 63);
  assert.equal(count("partial"), 4);
  assert.equal(count("authored"), 18);
});

test("known stubs are stubs and known authored definitions are authored", () => {
  const defs = loadDefinitions(DIR);
  for (const s of ["togaf", "owasp-top-10", "fogg-behavior-model", "nist-cybersecurity-framework"]) {
    assert.equal(defs.get(s).status, "stub", `${s} should be a stub`);
  }
  for (const s of ["prospect-theory", "self-determination-theory", "no-fabrication"]) {
    assert.equal(defs.get(s).status, "authored", `${s} should be authored`);
  }
});

test("hand-written definitions that reuse the template headings are NOT stubs", () => {
  // These four use the template's **Foundation** / **Application** / **Adaptation**
  // headings with real, specific content. A heading-based marker would hide them.
  const defs = loadDefinitions(DIR);
  for (const s of ["cis-controls", "eu-ai-act", "iso-42001", "sox"]) {
    assert.equal(defs.get(s).status, "authored", `${s} has real content`);
  }
});

test("a partial definition reports exactly which fields are generic", () => {
  const d = loadDefinitions(DIR).get("dora");
  assert.equal(d.status, "partial");
  assert.deepEqual(d.templated, ["application_steps"]);
});

// ------------------------------------------------- reviewed aliases

test("reviewed aliases resolve to the framework they mean", () => {
  const curated = { ...CURATED, "Hook Model": { description: "hook", when_to_use: "x", components: ["a"], application_steps: ["1. b"] } };
  const r = createResolver({ curated, dir: DIR });
  assert.equal(r.resolve("NIST CSF").name, "NIST Cybersecurity Framework");
  assert.equal(r.resolve("Hook Canvas").name, "Hook Model");
  assert.equal(r.resolve("Hook Canvas").source, "curated");
});

test("frameworks that merely share a word are NOT aliased", () => {
  // Fuzzy matching would return a confident wrong framework for each of these.
  const r = createResolver({ curated: CURATED, dir: DIR });
  assert.equal(r.resolve("Hero's Journey"), null);
  assert.equal(r.resolve("Lean Canvas"), null);
  assert.equal(r.resolve("Growth Loops"), null);
});

// ------------------------------------------------- parser correctness

test("normalize strips parentheticals, punctuation and case", () => {
  assert.equal(normalize("Prospect Theory (Loss Aversion)"), "prospect theory");
  assert.equal(normalize("prospect-theory"), "prospect theory");
  assert.equal(normalize("  OWASP  Top 10 "), "owasp top 10");
});

test("CRLF definitions parse the same as LF", () => {
  const lf = "---\nname: Demo Framework\n---\n\n## Purpose\nA demo purpose sentence that is long enough.\n\n## Core Principles\n- **One.** first\n\n## Applications & Use Cases\n| Use Case | App | Out |\n|---|---|---|\n| Pricing | x | y |\n\n## Usage Guidelines\n- **Do it.** carefully\n";
  const a = parseDefinition(lf, "demo");
  const b = parseDefinition(lf.replace(/\n/g, "\r\n"), "demo");
  assert.deepEqual(a, b);
  assert.equal(a.name, "Demo Framework");
  assert.equal(a.detail.when_to_use, "Pricing");
  assert.deepEqual(a.detail.components, ["One. first"]);
  assert.deepEqual(a.detail.application_steps, ["1. Do it. carefully"]);
});

test("frontmatter name extraction agrees with a real YAML parser for every definition", () => {
  // DEBUGGING_PLAYBOOK section 12: a checker weaker than the runtime parser
  // produced a false PASS. The loader stays dependency-free (this MCP's install
  // path has broken twice), so prove its extraction against a real parser here.
  let YAML;
  try {
    const require = createRequire(import.meta.url);
    YAML = require("../mxm-voice/node_modules/yaml");
  } catch {
    return; // oracle unavailable in this checkout; other tests still run
  }
  for (const [slug, def] of loadDefinitions(DIR)) {
    const raw = fs.readFileSync(path.join(DIR, slug, "SKILL.md"), "utf8").replace(/\r\n/g, "\n");
    const m = raw.match(/^---\n([\s\S]*?)\n---/);
    if (!m) continue;
    let expected;
    try { expected = YAML.parse(m[1])?.name; } catch { continue; }
    if (typeof expected === "string") assert.equal(def.name, expected.trim(), `${slug}: name mismatch`);
  }
});
