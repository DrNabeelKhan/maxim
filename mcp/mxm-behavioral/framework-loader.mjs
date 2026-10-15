// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * framework-loader — wires the on-disk framework definitions into mxm-behavioral.
 *
 * Every framework Maxim defines lives at composable-skills/frameworks/<slug>/SKILL.md,
 * all on one 12-section template. Before this module the MCP ignored them and served
 * a hardcoded map of 8, so recommend_frameworks would offer a framework and
 * apply_framework would then answer `Framework "Prospect Theory" not found`.
 *
 * Template sections are mapped onto the detail shape the tools already consume:
 *   ## Purpose                  -> description       (first paragraph)
 *   ## Applications & Use Cases -> when_to_use       (first column of the table)
 *   ## Core Principles          -> components        (bullets)
 *   ## Usage Guidelines         -> application_steps (bullets, numbered)
 *
 * Deliberately dependency-free: this MCP's install path has broken twice (BUG-014,
 * BUG-015), so the loader adds no runtime package. Frontmatter is read for `name`
 * only, with the directory slug as the fallback, and the test suite proves that
 * extraction against a real YAML parser (DEBUGGING_PLAYBOOK section 12).
 *
 * Loading is lazy and happens once: startup time is what failed when every MCP
 * server hit CONNECT_TIMEOUT, so constructing a resolver touches no files.
 */

import fs from "node:fs";
import path from "node:path";

/**
 * Explicit, reviewed aliases from names recommend_frameworks uses to the definition
 * or curated entry they actually mean. Deliberately NOT fuzzy: a fuzzy matcher
 * would answer "Hero's Journey" with User Journey Mapping and "Lean Canvas" with
 * Lean Startup, which are different frameworks. Add an alias only when the two
 * names refer to the same thing.
 */
export const ALIASES = {
  "nist csf": "nist-cybersecurity-framework",   // CSF is the Cybersecurity Framework
  "microservices patterns": "microservices-architecture",
  "hook canvas": "Hook Model",                    // Eyal's worksheet for the Hook Model
};

const FIELDS = ["description", "when_to_use", "components", "application_steps"];

/** Lowercase, drop parentheticals and punctuation, collapse whitespace. */
export function normalize(s) {
  return String(s ?? "")
    .toLowerCase()
    .replace(/\([^)]*\)/g, " ")
    .replace(/['’]/g, "")
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

/** Strip markdown emphasis and code ticks, collapse whitespace. */
function clean(s) {
  return s.replace(/\*\*/g, "").replace(/`/g, "").replace(/\s+/g, " ").trim();
}

/** Read `name:` from the frontmatter block. Fallback is the caller's slug. */
function frontmatterName(fm) {
  const m = fm.match(/^name:[ \t]*(.+)$/m);
  if (!m) return null;
  let v = m[1].trim();
  if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'"))) {
    v = v.slice(1, -1);
  }
  return v.trim() || null;
}

/** Split a markdown body into { heading: text } by `## ` headings. */
function sections(body) {
  const out = {};
  let key = null;
  let buf = [];
  for (const line of body.split("\n")) {
    const h = line.match(/^##[ \t]+(.+?)\s*$/);
    if (h) {
      if (key) out[key] = buf.join("\n");
      key = h[1];
      buf = [];
    } else if (key) {
      buf.push(line);
    }
  }
  if (key) out[key] = buf.join("\n");
  return out;
}

/** Find a section by heading prefix (headings may carry suffixes after a dash). */
function section(secs, prefix) {
  const k = Object.keys(secs).find((h) => h.toLowerCase().startsWith(prefix.toLowerCase()));
  return k ? secs[k] : "";
}

function firstParagraph(text) {
  for (const para of text.split(/\n\s*\n/)) {
    const lines = para.split("\n").filter((l) => l.trim() && !l.trim().startsWith("|") && !l.trim().startsWith("#"));
    if (lines.length) return clean(lines.join(" "));
  }
  return "";
}

function bullets(text) {
  return text
    .split("\n")
    .map((l) => l.match(/^\s*(?:[-*+]|\d+[.)])\s+(.*)$/))
    .filter(Boolean)
    .map((m) => clean(m[1]))
    .filter(Boolean);
}

/** First column of a markdown table, minus header and separator rows. */
function firstColumn(text) {
  const rows = text.split("\n").map((l) => l.trim()).filter((l) => l.startsWith("|"));
  if (rows.length < 3) return [];
  return rows
    .slice(2) // header + |---| separator
    .map((r) => clean(r.split("|")[1] ?? ""))
    .filter(Boolean);
}

/** Parse one SKILL.md into { name, detail }. Pure. */
export function parseDefinition(raw, slug) {
  const src = String(raw).replace(/\r\n/g, "\n");
  const fm = src.match(/^---\n([\s\S]*?)\n---/);
  const name = (fm && frontmatterName(fm[1])) || slug;
  const secs = sections(fm ? src.slice(fm[0].length) : src);

  const apps = section(secs, "Applications");
  const useCases = firstColumn(apps);
  const when = useCases.length ? useCases.join(", ") : bullets(apps).join("; ");

  return {
    name,
    detail: {
      description: firstParagraph(section(secs, "Purpose")),
      when_to_use: when,
      components: bullets(section(secs, "Core Principles")),
      application_steps: bullets(section(secs, "Usage Guidelines")).map((s, i) => `${i + 1}. ${s}`),
    },
  };
}

/** Load every <dir>/<slug>/SKILL.md. Returns Map<slug, { slug, name, path, detail }>. */
export function loadDefinitions(dir) {
  const defs = new Map();
  let entries;
  try {
    entries = fs.readdirSync(dir, { withFileTypes: true });
  } catch {
    return defs; // missing directory -> empty, never throw into a tool call
  }
  for (const e of entries) {
    if (!e.isDirectory()) continue;
    const p = path.join(dir, e.name, "SKILL.md");
    let raw;
    try {
      raw = fs.readFileSync(p, "utf8");
    } catch {
      continue;
    }
    const { name, detail } = parseDefinition(raw, e.name);
    defs.set(e.name, { slug: e.name, name, path: p, detail });
  }
  classify(defs);
  return defs;
}

/**
 * Mark which fields are generated template text rather than authored content.
 *
 * 63 of the 85 definitions were generated from one template: every field is the
 * same sentence with only the framework's name swapped in. A field counts as
 * templated when, after the framework's own name is replaced by a placeholder, its
 * text is identical to that field in some other definition.
 *
 * Why not a per-file marker such as the "**Foundation**" heading: four hand-written
 * definitions (cis-controls, eu-ai-act, iso-42001, sox) reuse the template's
 * headings with real, specific content. A heading marker flags them as stubs and
 * hides real material. Cross-definition identity does not.
 *
 * status: "authored" (no templated fields) | "partial" (some) | "stub" (all four).
 */
function classify(defs) {
  const shape = (d, f) => {
    const raw = Array.isArray(d.detail[f]) ? d.detail[f].join(" | ") : String(d.detail[f] ?? "");
    let t = raw;
    for (const v of [d.name, d.name.replace(/\s*\(.*$/, "")]) if (v) t = t.split(v).join("<NAME>");
    return normalize(t);
  };
  const seen = new Map();
  for (const d of defs.values()) {
    for (const f of FIELDS) {
      const k = f + "::" + shape(d, f);
      seen.set(k, (seen.get(k) || 0) + 1);
    }
  }
  for (const d of defs.values()) {
    d.templated = FIELDS.filter((f) => seen.get(f + "::" + shape(d, f)) > 1);
    d.status = d.templated.length === 0 ? "authored" : d.templated.length === FIELDS.length ? "stub" : "partial";
  }
}

/**
 * Resolver over curated details (which win) plus on-disk definitions.
 * Returns { name, detail, source: "curated" | "definition", path? } or null.
 */
export function createResolver({ curated = {}, dir, onLoad } = {}) {
  let defs = null;
  let index = null;

  function ensure() {
    if (defs) return;
    defs = loadDefinitions(dir);
    index = new Map();
    for (const d of defs.values()) {
      for (const k of [normalize(d.slug), normalize(d.name)]) {
        if (k && !index.has(k)) index.set(k, d.slug);
      }
    }
    if (onLoad) onLoad(defs.size);
  }

  const fromCurated = (k) => ({ name: k, detail: curated[k], source: "curated", status: "authored", generic_fields: [] });
  const fromDef = (slug) => {
    const d = defs.get(slug);
    return { name: d.name, detail: d.detail, source: "definition", status: d.status, generic_fields: d.templated, path: d.path };
  };

  /** Curated entry k, unless an authored definition of the same framework exists. */
  function preferAuthored(k) {
    ensure();
    const slug = index.get(normalize(k));
    if (slug && defs.get(slug).status === "authored") return fromDef(slug);
    return fromCurated(k);
  }

  function resolve(query) {
    const q = String(query ?? "").trim();
    if (!q) return null;

    // 1. Curated, exact then case-insensitive. An AUTHORED definition of the same
    //    framework outranks its curated entry, so authoring a definition is what
    //    changes the tool's answer. A curated entry still beats a stub or partial.
    const ck = curated[q] ? q : Object.keys(curated).find((k) => k.toLowerCase() === q.toLowerCase());
    if (ck) return preferAuthored(ck);

    ensure();
    const nq = normalize(q);

    // 2. Reviewed aliases, which may point at a curated name or a definition slug.
    if (ALIASES[nq]) {
      const target = ALIASES[nq];
      if (curated[target]) return preferAuthored(target);
      if (defs.has(target)) return fromDef(target);
    }

    // 3. Definitions, by normalized slug or name.
    if (index.has(nq)) return fromDef(index.get(nq));

    // 4. Partial match. Short queries would match the first name containing them
    //    and return a confident wrong answer, so require a real token.
    if (nq.length < 4) return null;
    const cp = Object.keys(curated).find((k) => normalize(k).includes(nq));
    if (cp) return fromCurated(cp);
    for (const [k, slug] of index) {
      if (k.includes(nq)) return fromDef(slug);
    }
    return null;
  }

  return {
    resolve,
    get definitionCount() {
      ensure();
      return defs.size;
    },
  };
}
