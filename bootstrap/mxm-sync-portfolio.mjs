#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// bootstrap/mxm-sync-portfolio.mjs — deterministic portfolio sync.
//
// Scans MXM_PROJECTS_ROOT for config/project-manifest.json (2 levels deep, so
// umbrella sub-projects are caught) + merges <global>/portfolio-registry/
// manual-includes.json, then rewrites <global>/PORTFOLIO-METRICS.md with the
// live matrix. The curated tree in portfolio-registry/project_state.md is NOT
// touched (it is hand-maintained).
//
// Called by the SessionEnd hook so .mxm-global refreshes after every Claude Code
// CLI session-end. SAFE NO-OP if the global cache is absent (the common case for
// users who have not set up a portfolio) — never throws, always exits 0, must
// never block a session from ending.
//
// Path resolution matches the mxm-portfolio MCP:
//   global  = $MXM_GLOBAL_PATH || ($MXM_PROJECTS_ROOT || "E:/Projects") + "/.mxm-global"
//   projects= $MXM_PROJECTS_ROOT || "E:/Projects"

import { readdir, stat, readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";

const PROJECTS_ROOT = process.env.MXM_PROJECTS_ROOT || "E:/Projects";
const MXM_GLOBAL = process.env.MXM_GLOBAL_PATH || join(PROJECTS_ROOT, ".mxm-global");

const exists = async (p) => { try { await stat(p); return true; } catch { return false; } };

// Sanitize a manifest value for a markdown table cell: kill newlines, neutralize
// pipes (would break the table), trim, cap length (some manifests stuff a verbose
// status blob into mxm_version — this keeps the matrix readable).
const clean = (v, n) => (String(v ?? "—").replace(/[\r\n]+/g, " ").replace(/\|/g, "/").trim().slice(0, n) || "—");

async function readManifest(dir) {
  try {
    const m = JSON.parse(await readFile(join(dir, "config/project-manifest.json"), "utf-8"));
    return {
      id: clean(m.project?.id || m.id || "?", 30),
      version: clean(m.mxm_version || m.project?.version || m.version || "—", 24),
      stage: clean(m.project?.stage || m.status?.lifecycle || "—", 18),
      compliance: clean((m.compliance?.frameworks || []).join(", ") || "—", 70),
    };
  } catch { return null; }
}

async function lastActivity(dir) {
  for (const f of [".claude-sessions-memory/handoff.md", ".mxm-skills/agents-handoff.md"]) {
    try { return (await stat(join(dir, f))).mtime.toISOString().split("T")[0]; } catch { /* next */ }
  }
  return "—";
}

async function main() {
  if (!(await exists(MXM_GLOBAL)) || !(await exists(PROJECTS_ROOT))) process.exit(0);

  const rows = [];
  let top = [];
  try { top = await readdir(PROJECTS_ROOT, { withFileTypes: true }); } catch { process.exit(0); }

  for (const d of top) {
    if (!d.isDirectory() || d.name.startsWith(".")) continue;
    const dp = join(PROJECTS_ROOT, d.name);
    const m = await readManifest(dp);
    if (m) rows.push({ folder: d.name, ...m, last: await lastActivity(dp) });
    let subs = [];
    try { subs = await readdir(dp, { withFileTypes: true }); } catch { /* skip */ }
    for (const s of subs) {
      if (!s.isDirectory() || s.name.startsWith(".") || s.name === "node_modules") continue;
      const sp = join(dp, s.name);
      const sm = await readManifest(sp);
      if (sm) rows.push({ folder: `${d.name}/${s.name}`, ...sm, last: await lastActivity(sp) });
    }
  }

  // manifest-less active projects (kept in manual-includes.json)
  try {
    const inc = JSON.parse(await readFile(join(MXM_GLOBAL, "portfolio-registry/manual-includes.json"), "utf-8"));
    for (const e of (inc.projects || [])) {
      const rel = String(e.rel || "?").replace(/\\/g, "/");
      if (!rows.some((r) => r.folder.toLowerCase() === rel.toLowerCase())) {
        rows.push({ folder: rel, id: e.id || "?", version: clean(e.version || "—", 24), stage: e.lifecycle || "—", compliance: "—", last: "—", manual: true });
      }
    }
  } catch { /* no manual includes */ }

  rows.sort((a, b) => a.folder.localeCompare(b.folder));
  const today = new Date().toISOString().split("T")[0];
  const withC = rows.filter((r) => r.compliance && r.compliance !== "—").length;
  const matrix = rows
    .map((r) => `| ${r.folder}${r.manual ? " (manual)" : ""} | ${r.stage} | ${r.version} | ${r.compliance} | ${r.last} |`)
    .join("\n");

  const out = `# Portfolio Metrics

Last synced: ${today} — auto, by the SessionEnd hook (\`bootstrap/mxm-sync-portfolio.mjs\`).

## Portfolio health
| Metric | Value |
|---|---|
| Tracked projects | ${rows.length} |
| With compliance scope | ${withC} |

## Project status matrix
| Project | Stage / Lifecycle | Version | Compliance | Last activity |
|---|---|---|---|---|
${matrix}

> Auto-generated from each project's \`config/project-manifest.json\` + \`portfolio-registry/manual-includes.json\`. Source of truth = the manifests. The curated tree is \`portfolio-registry/project_state.md\` (not rewritten by sync).
`;
  await writeFile(join(MXM_GLOBAL, "PORTFOLIO-METRICS.md"), out, "utf-8");
  process.exit(0);
}

main().catch(() => process.exit(0));
