// Tests for framework-loader.mjs — wiring the on-disk framework definitions
// (composable-skills/frameworks/*/SKILL.md) into mxm-behavioral.
//
// Context: recommend_frameworks offered 68 frameworks, but apply_framework and
// get_framework_details read a hardcoded map of 8. Asked for a framework the tool
// had just recommended, it answered `Framework "Prospect Theory" not found`. The
// definitions existed on disk; the MCP never read them. 63 of the 85 then turned
// out to be generated template stubs, which are being authored in batches.
//
// Two kinds of test live here, deliberately separate:
//   - LOGIC tests run against a small synthetic corpus written to a temp dir, so
//     stub detection stays tested even once the real corpus has no stubs left.
//   - CORPUS tests pin the state of the real definitions, so progress is visible.
//
// Run: node --test mcp/mxm-behavioral/framework-loader.test.mjs

import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";
import {
  normalize,
  parseDefinition,
  loadDefinitions,
  createResolver,
  templateFingerprints,
} from "./framework-loader.mjs";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const DIR = path.resolve(HERE, "../../composable-skills/frameworks");

// ---------------------------------------------------------------- fixture

const TPL = {
  purpose: "Apply <NAME> to guide decision-making, structure analysis and improve outcomes.",
  principles: ["**Foundation**: <NAME> provides a structured approach", "**Application**: Use when facing decisions requiring <NAME>"],
  uses: ["Strategic planning", "Process improvement"],
  steps: ["**Assess** the context before applying <NAME>.", "**Adapt** <NAME> to the situation."],
};

function definition(name, parts) {
  const sub = (s) => s.split("<NAME>").join(name);
  return [
    "---", `name: ${name}`, "---", "",
    "## Purpose", sub(parts.purpose), "",
    "## Core Principles", ...parts.principles.map((p) => `- ${sub(p)}`), "",
    "## Applications & Use Cases", "| Use Case | Application | Outcome |", "|---|---|---|",
    ...parts.uses.map((u) => `| ${sub(u)} | x | y |`), "",
    "## Usage Guidelines", ...parts.steps.map((s) => `- ${sub(s)}`), "",
  ].join("\n");
}

function fixture() {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "mxm-fw-"));
  const write = (slug, name, parts) => {
    fs.mkdirSync(path.join(dir, slug));
    fs.writeFileSync(path.join(dir, slug, "SKILL.md"), definition(name, parts));
  };
  // Two stubs share every templated field, with only the name differing.
  write("alpha-method", "Alpha Method", TPL);
  write("beta-method", "Beta Method", TPL);
  // Partial: real content everywhere except the usage steps.
  write("gamma-method", "Gamma Method", {
    purpose: "Gamma decomposes a decision into reversible and irreversible parts before committing.",
    principles: ["Reversible decisions should be made quickly", "Irreversible decisions deserve deliberate review"],
    uses: ["Release planning", "Vendor selection"],
    steps: TPL.steps,
  });
  // Authored: every field distinct.
  write("delta-method", "Delta Method", {
    purpose: "Delta compares the expected value of acting now against the option value of waiting.",
    principles: ["Waiting has a measurable value", "Information decays, so delay has a cost too"],
    uses: ["Hiring decisions", "Capacity investment"],
    steps: ["Estimate the value of new information.", "Compare it with the cost of delay."],
  });
  return dir;
}

const FX = fixture();
const CURATED = {
  "Alpha Method": { description: "curated alpha", when_to_use: "x", components: ["a"], application_steps: ["1. b"] },
  "Delta Method": { description: "curated delta", when_to_use: "x", components: ["a"], application_steps: ["1. b"] },
};

// ================================================================== LOGIC

test("classification: shared template text is a stub; distinct content is authored", () => {
  const defs = loadDefinitions(FX);
  assert.equal(defs.get("alpha-method").status, "stub");
  assert.equal(defs.get("beta-method").status, "stub");
  assert.equal(defs.get("delta-method").status, "authored");
});

test("classification: a partial definition names exactly which fields are generic", () => {
  const d = loadDefinitions(FX).get("gamma-method");
  assert.equal(d.status, "partial");
  assert.deepEqual(d.templated, ["application_steps"]);
});

test("frozen fingerprints: the last stub of a template group is still a stub", () => {
  // Regression: "shared with another definition" shrinks as stubs get authored.
  // Authoring every other behaviour-science stub turned cognitive-biases into a
  // "partial" with nobody touching it, and the last stub of any group would
  // eventually read as authored. Freeze the template fingerprints instead.
  const frozen = new Set(templateFingerprints(loadDefinitions(FX, { fingerprints: new Set() })));
  const solo = fs.mkdtempSync(path.join(os.tmpdir(), "mxm-fw-solo-"));
  fs.mkdirSync(path.join(solo, "beta-method"));
  fs.writeFileSync(path.join(solo, "beta-method", "SKILL.md"), definition("Beta Method", TPL));
  assert.equal(loadDefinitions(solo, { fingerprints: new Set() }).get("beta-method").status, "authored",
    "without the frozen set a lone stub looks authored: the bug this guards against");
  assert.equal(loadDefinitions(solo, { fingerprints: frozen }).get("beta-method").status, "stub");
});

test("frozen fingerprints: the bundled set reproduces the original corpus split", () => {
  // The bundled template-fingerprints.json was frozen from commit 633e3fa. Its
  // recorded split must match what the classifier says about that corpus.
  const json = JSON.parse(fs.readFileSync(path.join(HERE, "template-fingerprints.json"), "utf8"));
  assert.deepEqual(json.source_split, { authored: 18, partial: 4, stub: 63 });
  assert.ok(json.fingerprints.length > 0);
});

test("precedence: a curated entry wins over a stub definition", () => {
  const hit = createResolver({ curated: CURATED, dir: FX }).resolve("Alpha Method");
  assert.equal(hit.source, "curated");
  assert.equal(hit.detail.description, "curated alpha");
});

test("precedence: an authored definition outranks the curated entry", () => {
  // Authoring a definition must be what changes the tool's answer; otherwise the
  // curated map silently shadows every definition that gets written.
  const hit = createResolver({ curated: CURATED, dir: FX }).resolve("Delta Method");
  assert.equal(hit.source, "definition");
  assert.equal(hit.status, "authored");
});

test("a stub with no curated entry resolves with status stub, not as guidance", () => {
  const hit = createResolver({ curated: {}, dir: FX }).resolve("Beta Method");
  assert.equal(hit.status, "stub");
});

test("unknown framework returns null rather than a wrong guess", () => {
  const r = createResolver({ curated: CURATED, dir: FX });
  assert.equal(r.resolve("Definitely Not A Real Framework Xyzzy"), null);
});

test("very short queries do not partial-match everything", () => {
  const r = createResolver({ curated: CURATED, dir: FX });
  assert.equal(r.resolve("a"), null);
  assert.equal(r.resolve("to"), null);
});

test("does not touch the filesystem until the first lookup", () => {
  // Startup time is what failed when every MCP server hit CONNECT_TIMEOUT.
  let reads = 0;
  const r = createResolver({ curated: CURATED, dir: FX, onLoad: () => { reads++; } });
  assert.equal(reads, 0);
  r.resolve("Delta Method");
  r.resolve("Gamma Method");
  assert.equal(reads, 1);
});

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

// ================================================================== CORPUS

test("corpus: loads every definition directory on disk", () => {
  const dirs = fs.readdirSync(DIR).filter((d) => fs.existsSync(path.join(DIR, d, "SKILL.md")));
  const defs = loadDefinitions(DIR);
  assert.equal(defs.size, dirs.length);
  assert.ok(defs.size >= 85, `expected at least 85 definitions, got ${defs.size}`);
});

test("corpus: every definition yields the full detail shape the tools consume", () => {
  for (const [slug, def] of loadDefinitions(DIR)) {
    const d = def.detail;
    assert.ok(d.description && d.description.length > 20, `${slug}: description`);
    assert.ok(d.when_to_use && d.when_to_use.length > 5, `${slug}: when_to_use`);
    assert.ok(Array.isArray(d.components) && d.components.length > 0, `${slug}: components`);
    assert.ok(Array.isArray(d.application_steps) && d.application_steps.length > 0, `${slug}: application_steps`);
    for (const c of d.components) assert.ok(!c.includes("**"), `${slug}: markdown bold leaked into a component`);
  }
});

test("corpus: authoring progress (update deliberately as batches land)", () => {
  // Pinned so that every change to the corpus is a visible, deliberate edit here.
  //   2026-10-14  18 authored / 4 partial / 63 stub   (initial wiring)
  //   2026-10-14  22 / 4 / 59                         (Fogg, COM-B, EAST, Hook)
  //   2026-10-15  26 / 4 / 55                         (Nudge, Cialdini, AIDA, JTBD)
  const defs = [...loadDefinitions(DIR).values()];
  const count = (s) => defs.filter((d) => d.status === s).length;
  assert.deepEqual(
    { authored: count("authored"), partial: count("partial"), stub: count("stub") },
    { authored: 26, partial: 4, stub: 55 },
  );
});

test("corpus: every authored framework so far classifies as authored", () => {
  const defs = loadDefinitions(DIR);
  const authored = [
    "prospect-theory", "self-determination-theory", "no-fabrication",
    "fogg-behavior-model", "com-b-model", "east-framework", "hook-model",
    "nudge-theory", "cialdinis-6-principles", "aida", "jobs-to-be-done",
  ];
  for (const s of authored) assert.equal(defs.get(s).status, "authored", `${s} should be authored`);
});

test("corpus: hand-written definitions that reuse the template headings are NOT stubs", () => {
  // These use the template's **Foundation** / **Application** / **Adaptation**
  // headings with real, specific content. A heading-based marker would hide them.
  const defs = loadDefinitions(DIR);
  for (const s of ["cis-controls", "eu-ai-act", "iso-42001", "sox"]) {
    assert.equal(defs.get(s).status, "authored", `${s} has real content`);
  }
});

test("corpus: reviewed aliases resolve to the framework they mean", () => {
  const curated = { "Hook Model": { description: "h", when_to_use: "x", components: ["a"], application_steps: ["1. b"] },
                    "Cialdini's Principles": { description: "c", when_to_use: "x", components: ["a"], application_steps: ["1. b"] } };
  const r = createResolver({ curated, dir: DIR });
  assert.equal(r.resolve("NIST CSF").name, "NIST Cybersecurity Framework");
  assert.equal(r.resolve("Hook Canvas").name, "Hook Model");
  // The curated key "Cialdini's Principles" must reach the authored definition,
  // even though its slug and name carry the principle count.
  const c = r.resolve("Cialdini's Principles");
  assert.equal(c.source, "definition");
  assert.equal(c.status, "authored");
});

test("corpus: frameworks that merely share a word are NOT aliased", () => {
  const r = createResolver({ curated: {}, dir: DIR });
  assert.equal(r.resolve("Hero's Journey"), null);
  assert.equal(r.resolve("Lean Canvas"), null);
  assert.equal(r.resolve("Growth Loops"), null);
});

test("corpus: Prospect Theory resolves by name, slug and full parenthetical name", () => {
  const r = createResolver({ curated: {}, dir: DIR });
  const a = r.resolve("Prospect Theory");
  assert.ok(a);
  assert.equal(a.status, "authored");
  assert.match(a.detail.description, /decision|risk|framing|pricing/i);
  assert.equal(r.resolve("prospect-theory").name, a.name);
  assert.equal(r.resolve("Prospect Theory (Loss Aversion · Reference Dependence · Probability Weighting)").name, a.name);
});

test("corpus: frontmatter name extraction agrees with a real YAML parser", () => {
  // DEBUGGING_PLAYBOOK section 12: a checker weaker than the runtime produced a
  // false PASS. Fail rather than skip if the oracle cannot load, so this test
  // cannot pass vacuously.
  const require = createRequire(import.meta.url);
  const YAML = require("../mxm-voice/node_modules/yaml");
  let compared = 0;
  for (const [slug, def] of loadDefinitions(DIR)) {
    const raw = fs.readFileSync(path.join(DIR, slug, "SKILL.md"), "utf8").replace(/\r\n/g, "\n");
    const m = raw.match(/^---\n([\s\S]*?)\n---/);
    if (!m) continue;
    const expected = YAML.parse(m[1])?.name;  // throws on invalid YAML, failing the test
    if (typeof expected === "string") { assert.equal(def.name, expected.trim(), `${slug}: name mismatch`); compared++; }
  }
  assert.ok(compared >= 85, `only ${compared} names were compared`);
});
