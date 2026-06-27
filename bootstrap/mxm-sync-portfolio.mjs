#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// bootstrap/mxm-sync-portfolio.mjs — deterministic portfolio sync.
//
// Scans MXM_PROJECTS_ROOT for config/project-manifest.json recursively to
// MXM_SCAN_DEPTH folder levels (default 3, so deeply-nested + umbrella sub-projects
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

  // Recursive scan to MXM_SCAN_DEPTH folder levels (default 3) so deeply-nested
  // projects are caught — e.g. nabeelkhan/myBooks/The Prey at depth 3, not just
  // nabeelkhan/VAZIR at depth 2. Heavy/irrelevant dirs are pruned; dot-dirs skipped.
  const MAX_DEPTH = Number(process.env.MXM_SCAN_DEPTH) || 3;
  const PRUNE = new Set(["node_modules", "dist", "build", "out", "target", "venv", "env", "__pycache__", "coverage", "vendor", "archive", "community-packs", ".git"]);
  const rows = [];

  async function collect(dir, rel, depth) {
    const m = await readManifest(dir);
    if (m && rel) rows.push({ folder: rel, ...m, last: await lastActivity(dir) });
    if (depth >= MAX_DEPTH) return;
    let entries;
    try { entries = await readdir(dir, { withFileTypes: true }); } catch { return; }
    for (const e of entries) {
      if (!e.isDirectory() || e.name.startsWith(".") || PRUNE.has(e.name)) continue;
      await collect(join(dir, e.name), rel ? `${rel}/${e.name}` : e.name, depth + 1);
    }
  }
  try { await collect(PROJECTS_ROOT, "", 0); } catch { /* defensive — never throw */ }

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
