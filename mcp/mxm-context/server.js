#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-context — MCP Server (v1.0.0+)
 *
 * Per-project intelligence + design references + drift detection.
 *
 * 13 tools:
 *   Project context (original v1.0.0):
 *     - get_manifest, get_session_memory, get_operator_profile,
 *       get_architecture_docs, get_skill_gaps, get_decision_log
 *   Design references (absorbed from maxim-design in v1.0.0):
 *     - get_brand_design, list_brands, get_design_template, get_design_reference
 *   Proactive Watch (new in v1.0.0):
 *     - watch_run, watch_report, watch_configure
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { readFile, readdir } from "node:fs/promises";
import { spawn } from "node:child_process";
import { join } from "node:path";
import { wrapServerWithLicenseGate } from "../_shared/license-gate.mjs";

const MXM_ROOT = process.env.MXM_ROOT || "E:/Projects/Maxim/maxim";
const DESIGN_MD_DIR = join(MXM_ROOT, "community-packs/design-templates/design-md");
const REFERENCES_DIR = join(MXM_ROOT, ".claude/skills/design-resources/references");

async function safeRead(filePath) {
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    return null;
  }
}

const server = new McpServer({
  name: "mxm-context",
  version: "1.1.0",
});

// v1.1.A — license gate (fail-closed at JWT expiry; owner.key bypass; first-run silent issue)
wrapServerWithLicenseGate(server, "mxm-context");

// --- Tool: get_manifest ---
server.tool(
  "get_manifest",
  "Get project identity, compliance scope, and tech stack from config/project-manifest.json",
  {
    project_path: z.string().describe("Absolute path to the project root (e.g., E:/Projects/FixIt)"),
  },
  async ({ project_path }) => {
    const content = await safeRead(join(project_path, "config/project-manifest.json"));
    if (!content) {
      return { content: [{ type: "text", text: `No project-manifest.json found at ${project_path}/config/` }] };
    }
    try {
      const manifest = JSON.parse(content);
      const summary = {
        project: manifest.project,
        mxm_version: manifest.mxm_version,
        compliance: manifest.compliance,
        tech_stack: manifest.tech_stack,
        build_target: manifest.build_target,
        super_user: manifest.super_user,
      };
      return { content: [{ type: "text", text: JSON.stringify(summary, null, 2) }] };
    } catch {
      return { content: [{ type: "text", text: content }] };
    }
  }
);

// --- Tool: get_session_memory ---
server.tool(
  "get_session_memory",
  "Get handoff state, open tasks, and last session summary from .claude-sessions-memory/",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const memDir = join(project_path, ".claude-sessions-memory");
    const parts = [];

    const handoff = await safeRead(join(memDir, "handoff.md"));
    if (handoff) parts.push("## Handoff\n" + handoff);

    const progress = await safeRead(join(memDir, "progress.md"));
    if (progress) parts.push("## Progress\n" + progress);

    const state = await safeRead(join(memDir, "project_current_state.md"));
    if (state) parts.push("## Current State\n" + state);

    // Find most recent session file
    try {
      const files = await readdir(memDir);
      const sessionFiles = files.filter((f) => f.startsWith("session-") && f.endsWith(".md")).sort().reverse();
      if (sessionFiles.length > 0) {
        const latest = await safeRead(join(memDir, sessionFiles[0]));
        if (latest) parts.push(`## Last Session (${sessionFiles[0]})\n` + latest);
      }
    } catch {
      // No session files
    }

    if (parts.length === 0) {
      return { content: [{ type: "text", text: `No session memory found at ${memDir}` }] };
    }

    return { content: [{ type: "text", text: parts.join("\n\n---\n\n") }] };
  }
);

// --- Tool: get_operator_profile ---
server.tool(
  "get_operator_profile",
  "Get operator identity, preferences, rejected patterns, and communication style from .mxm-operator-profile/",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const profDir = join(project_path, ".mxm-operator-profile");
    const parts = [];

    for (const file of ["OPERATOR.md", "preferences.md", "rejected-patterns.md", "communication-style.md"]) {
      const content = await safeRead(join(profDir, file));
      if (content) parts.push(`## ${file}\n` + content);
    }

    if (parts.length === 0) {
      return { content: [{ type: "text", text: `No operator profile found at ${profDir}` }] };
    }

    return { content: [{ type: "text", text: parts.join("\n\n---\n\n") }] };
  }
);

// --- Tool: get_architecture_docs ---
server.tool(
  "get_architecture_docs",
  "Get PRD, FRD, SRD summaries from documents/architecture/. Returns first 200 lines of each document.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const archDir = join(project_path, "documents/architecture");
    try {
      const files = await readdir(archDir);
      const mdFiles = files.filter((f) => f.endsWith(".md") && !f.startsWith("."));
      const parts = [];

      for (const file of mdFiles) {
        const content = await safeRead(join(archDir, file));
        if (content) {
          const truncated = content.split("\n").slice(0, 200).join("\n");
          parts.push(`## ${file}\n${truncated}`);
        }
      }

      if (parts.length === 0) {
        return { content: [{ type: "text", text: `No architecture docs found at ${archDir}` }] };
      }

      return { content: [{ type: "text", text: parts.join("\n\n---\n\n") }] };
    } catch {
      return { content: [{ type: "text", text: `documents/architecture/ not found at ${project_path}` }] };
    }
  }
);

// --- Tool: get_skill_gaps ---
server.tool(
  "get_skill_gaps",
  "Get unresolved capability gaps from .mxm-skills/agents-skill-gaps.log",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const content = await safeRead(join(project_path, ".mxm-skills/agents-skill-gaps.log"));
    if (!content || content.trim() === "") {
      return { content: [{ type: "text", text: "No skill gaps logged for this project." }] };
    }
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: get_decision_log ---
server.tool(
  "get_decision_log",
  "Get recent decisions with rationale from .claude-sessions-memory/decision-log.md",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    limit: z.number().optional().describe("Max number of decisions to return (default: 20)"),
  },
  async ({ project_path, limit = 20 }) => {
    const content = await safeRead(join(project_path, ".claude-sessions-memory/decision-log.md"));
    if (!content || content.trim() === "") {
      return { content: [{ type: "text", text: "No decision log found for this project." }] };
    }

    // Return last N decisions (sections separated by ---)
    const sections = content.split(/\n---\n/);
    const limited = sections.slice(-limit).join("\n---\n");
    return { content: [{ type: "text", text: limited }] };
  }
);

// ══════════════════════════════════════════════════════════════════════════════
// Design reference tools (absorbed from maxim-design in v1.0.0)
// ══════════════════════════════════════════════════════════════════════════════

// --- Tool: get_brand_design ---
server.tool(
  "get_brand_design",
  "Get the full DESIGN.md for a brand (colors, typography, components, spacing, animation). 59 brands available including Stripe, Linear, Tesla, Spotify, Apple, etc.",
  {
    brand: z.string().describe("Brand name (lowercase, e.g., 'stripe', 'linear', 'tesla', 'spotify')"),
  },
  async ({ brand }) => {
    const brandLower = brand.toLowerCase().replace(/\s+/g, "-").replace(/[^a-z0-9-]/g, "");
    let content = await safeRead(join(DESIGN_MD_DIR, brandLower, "README.md"));
    if (!content) content = await safeRead(join(DESIGN_MD_DIR, brandLower, "DESIGN.md"));
    if (!content) {
      const noHyphens = brandLower.replace(/-/g, "");
      content = await safeRead(join(DESIGN_MD_DIR, noHyphens, "README.md"));
      if (!content) content = await safeRead(join(DESIGN_MD_DIR, noHyphens, "DESIGN.md"));
    }
    if (!content) {
      try {
        const dirs = await readdir(DESIGN_MD_DIR);
        const matches = dirs.filter((d) => d.includes(brandLower) || brandLower.includes(d));
        const suggestion = matches.length > 0
          ? `Did you mean: ${matches.join(", ")}?`
          : `Available brands: ${dirs.slice(0, 20).join(", ")}... (${dirs.length} total)`;
        return { content: [{ type: "text", text: `Brand "${brand}" not found. ${suggestion}` }] };
      } catch {
        return { content: [{ type: "text", text: `Brand "${brand}" not found and design-md directory is not accessible.` }] };
      }
    }
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: list_brands ---
server.tool(
  "list_brands",
  "List all available brand DESIGN.md templates. Returns brand names sorted alphabetically.",
  {
    category: z.string().optional().describe("Filter by category keyword (e.g., 'tech', 'finance', 'automotive')"),
  },
  async ({ category }) => {
    try {
      const dirs = await readdir(DESIGN_MD_DIR);
      const brands = dirs.filter((d) => !d.startsWith(".")).sort();
      const categories = {
        tech: ["apple", "claude", "cursor", "figma", "framer", "linear", "notion", "stripe", "vercel", "github", "supabase", "planetscale", "railway", "hashicorp", "cohere", "openai"],
        finance: ["stripe", "coinbase", "mercury", "ramp"],
        automotive: ["bmw", "ferrari", "tesla", "rivian", "porsche"],
        design: ["figma", "framer", "canva", "webflow"],
        ai: ["claude", "cohere", "openai", "perplexity", "cursor"],
      };
      let filtered = brands;
      if (category) {
        const catLower = category.toLowerCase();
        const catBrands = categories[catLower];
        filtered = catBrands ? brands.filter((b) => catBrands.includes(b)) : brands.filter((b) => b.includes(catLower));
      }
      return {
        content: [{
          type: "text",
          text: JSON.stringify({ total: filtered.length, brands: filtered, available_categories: Object.keys(categories) }, null, 2),
        }],
      };
    } catch {
      return { content: [{ type: "text", text: "Design library not accessible." }] };
    }
  }
);

// --- Tool: get_design_template ---
server.tool(
  "get_design_template",
  "Get the 9-section DESIGN.md template for creating custom brand design systems.",
  {},
  async () => {
    const content = await safeRead(join(MXM_ROOT, ".claude/skills/design-resources/DESIGN.md"));
    if (!content) {
      const template = `# DESIGN.md Template\n\n## 1. Brand Identity\n## 2. Typography\n## 3. Color System\n## 4. Spacing & Layout\n## 5. Components\n## 6. Icons & Imagery\n## 7. Animation & Motion\n## 8. Accessibility\n## 9. Dark Mode`;
      return { content: [{ type: "text", text: template }] };
    }
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: get_design_reference ---
server.tool(
  "get_design_reference",
  "Get reference material for a specific design topic (typography, colors, components, animation, accessibility).",
  {
    type: z.enum(["typography", "colors", "components", "animation", "accessibility", "brand-library"]).describe("Type of design reference to retrieve"),
  },
  async ({ type }) => {
    const fileMap = {
      typography: "typography-reference.md",
      colors: "color-theory-reference.md",
      components: "component-reference.md",
      animation: "animation-reference.md",
      accessibility: "accessibility-reference.md",
      "brand-library": "brand-library.md",
    };
    const content = await safeRead(join(REFERENCES_DIR, fileMap[type]));
    if (!content) {
      return { content: [{ type: "text", text: `Reference "${type}" (${fileMap[type]}) not found at ${REFERENCES_DIR}` }] };
    }
    return { content: [{ type: "text", text: content }] };
  }
);

// ══════════════════════════════════════════════════════════════════════════════
// Proactive Watch tools (new in v1.0.0)
// ══════════════════════════════════════════════════════════════════════════════

function spawnWatch(projectPath, args) {
  return new Promise((resolve) => {
    const isWindows = process.platform === "win32";
    const script = isWindows
      ? join(projectPath, ".claude/skills/proactive-watch/watch.ps1")
      : join(projectPath, ".claude/skills/proactive-watch/watch.sh");
    const cmd = isWindows ? "pwsh" : "bash";
    const cmdArgs = isWindows ? ["-NoProfile", "-File", script, ...args] : [script, ...args];
    const child = spawn(cmd, cmdArgs, { cwd: projectPath });
    let stdout = "", stderr = "";
    child.stdout.on("data", (d) => stdout += d.toString());
    child.stderr.on("data", (d) => stderr += d.toString());
    child.on("close", (code) => resolve({ code, stdout, stderr }));
    child.on("error", (err) => resolve({ code: -1, stdout: "", stderr: String(err) }));
  });
}

// --- Tool: watch_run ---
server.tool(
  "watch_run",
  "Run Proactive Watch drift detection against a project. Returns drift summary + JSONL report path. LIGHT phase only in v1.0.0.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    checker: z.string().optional().describe("Single checker name (e.g., 'inventory-drift') or 'all' (default). Available: inventory-drift, version-drift, contract-drift, cross-doc-drift, orphan-refs, dependency-drift, git-hygiene, junction-drift, stale-handoff, compliance-drift"),
  },
  async ({ project_path, checker = "all" }) => {
    const result = await spawnWatch(project_path, [checker]);
    const summary = result.stderr || result.stdout || "(no output)";
    return { content: [{ type: "text", text: summary }] };
  }
);

// --- Tool: watch_report ---
server.tool(
  "watch_report",
  "Read the latest watch report JSONL from a project (.mxm-skills/watch-report.jsonl). Returns one JSON line per detected drift.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    limit: z.number().optional().describe("Max number of latest drift entries to return (default: 50)"),
  },
  async ({ project_path, limit = 50 }) => {
    const content = await safeRead(join(project_path, ".mxm-skills/watch-report.jsonl"));
    if (!content) return { content: [{ type: "text", text: "No watch report found. Run watch_run first." }] };
    const lines = content.trim().split("\n").filter(Boolean);
    const limited = lines.slice(-limit);
    return { content: [{ type: "text", text: limited.join("\n") }] };
  }
);

// --- Tool: watch_configure ---
server.tool(
  "watch_configure",
  "Read the project's watch profile (config/watch-profile.yml) — which checkers enabled, triage matrix, thresholds.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const content = await safeRead(join(project_path, "config/watch-profile.yml"));
    if (!content) {
      return { content: [{ type: "text", text: "No watch-profile.yml found. Project hasn't adopted Proactive Watch yet. Copy config/watch-profile.TEMPLATE.yml from the maxim repo." }] };
    }
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: get_watch_profile (v1.0.0) ---
server.tool(
  "get_watch_profile",
  "Return the project's config/watch-profile.yml contents (enabled checkers, intervals).",
  {
    project_path: z.string().describe("Absolute path to project root"),
  },
  async ({ project_path }) => {
    try {
      const content = await readFile(join(project_path, "config/watch-profile.yml"), "utf-8");
      return { content: [{ type: "text", text: content }] };
    } catch {
      return { content: [{ type: "text", text: JSON.stringify({ error: "no config/watch-profile.yml", suggestion: "copy from config/watch-profile.TEMPLATE.yml" }, null, 2) }] };
    }
  }
);

// --- Tool: list_bundled_skills (v1.0.0) ---
server.tool(
  "list_bundled_skills",
  "Enumerate .claude/skills/{domain}/ directories with SKILL.md presence + Maxim-WRAPPER.md presence flags.",
  {
    project_path: z.string().describe("Absolute path to project root"),
  },
  async ({ project_path }) => {
    const skillsDir = join(project_path, ".claude/skills");
    try {
      const domains = await readdir(skillsDir, { withFileTypes: true });
      const skills = [];
      for (const entry of domains) {
        if (!entry.isDirectory()) continue;
        const domain = entry.name;
        const domainPath = join(skillsDir, domain);
        let hasSkill = false, hasWrapper = false;
        try { await readFile(join(domainPath, "SKILL.md"), "utf-8"); hasSkill = true; } catch {}
        try { await readFile(join(domainPath, "Maxim-WRAPPER.md"), "utf-8"); hasWrapper = true; } catch {}
        skills.push({ domain, has_skill: hasSkill, has_mxm_wrapper: hasWrapper });
      }
      return { content: [{ type: "text", text: JSON.stringify({ count: skills.length, skills }, null, 2) }] };
    } catch (e) {
      return { content: [{ type: "text", text: JSON.stringify({ error: e.message }, null, 2) }] };
    }
  }
);

// --- Start ---
const transport = new StdioServerTransport();
await server.connect(transport);
