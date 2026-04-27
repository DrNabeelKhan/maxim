#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-portfolio — MCP Server
 * Serves .mxm-global/ context to any Claude surface.
 * Enables cross-project portfolio awareness on Desktop, Cowork, claude.ai.
 *
 * Part of Maxim Framework v6.2.0
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { readFile, writeFile, stat } from "node:fs/promises";
import { join } from "node:path";
import { wrapServerWithLicenseGate } from "../_shared/license-gate.mjs";

const MXM_GLOBAL = process.env.MXM_GLOBAL_PATH || "E:/Projects/.mxm-global";

async function readMd(filename) {
  try {
    return await readFile(join(MXM_GLOBAL, filename), "utf-8");
  } catch {
    return `Error: ${filename} not found at ${MXM_GLOBAL}`;
  }
}

const server = new McpServer({
  name: "mxm-portfolio",
  version: "1.0.0",
});

// v1.1.A — license gate (fail-closed at JWT expiry; owner.key bypass; first-run silent issue)
wrapServerWithLicenseGate(server, "mxm-portfolio");

// --- Tool: get_portfolio_overview ---
server.tool(
  "get_portfolio_overview",
  "Get founder, company, project count, compliance summary, and core platform details from .mxm-global/GLOBAL-CONTEXT.md",
  {},
  async () => {
    const content = await readMd("GLOBAL-CONTEXT.md");
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: get_portfolio_metrics ---
server.tool(
  "get_portfolio_metrics",
  "Get project status matrix, compliance coverage, and portfolio health metrics from .mxm-global/PORTFOLIO-METRICS.md",
  {},
  async () => {
    const content = await readMd("PORTFOLIO-METRICS.md");
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: get_tasks ---
server.tool(
  "get_tasks",
  "Get filtered task list from .mxm-global/TASKS.md. Filter by priority (P1/P2/P3) and/or project name.",
  {
    priority: z.enum(["P1", "P2", "P3"]).optional().describe("Filter by priority level"),
    project: z.string().optional().describe("Filter by project name (case-insensitive substring match)"),
  },
  async ({ priority, project }) => {
    const content = await readMd("TASKS.md");
    if (!priority && !project) {
      return { content: [{ type: "text", text: content }] };
    }

    const lines = content.split("\n");
    const filtered = lines.filter((line) => {
      if (!line.startsWith("|") || line.includes("---") || line.includes("Task")) return false;
      const matchPriority = !priority || line.includes(priority);
      const matchProject = !project || line.toLowerCase().includes(project.toLowerCase());
      return matchPriority && matchProject;
    });

    const header = "| # | Task | Project | Priority | Due | Status | Assigned To |\n|---|---|---|---|---|---|---|";
    const result = filtered.length > 0
      ? `${header}\n${filtered.join("\n")}`
      : `No tasks found matching priority=${priority || "any"}, project=${project || "any"}`;

    return { content: [{ type: "text", text: result }] };
  }
);

// --- Tool: update_task ---
server.tool(
  "update_task",
  "Update the status of a task in .mxm-global/TASKS.md by task number.",
  {
    task_number: z.number().describe("Task number to update"),
    status: z.string().describe("New status value (e.g., 'In Progress', 'Complete', 'Not Started')"),
  },
  async ({ task_number, status }) => {
    const filePath = join(MXM_GLOBAL, "TASKS.md");
    let content;
    try {
      content = await readFile(filePath, "utf-8");
    } catch {
      return { content: [{ type: "text", text: "Error: TASKS.md not found" }] };
    }

    const lines = content.split("\n");
    let updated = false;
    for (let i = 0; i < lines.length; i++) {
      const match = lines[i].match(/^\|\s*(\d+)\s*\|/);
      if (match && parseInt(match[1]) === task_number) {
        const cells = lines[i].split("|").map((c) => c.trim());
        // cells: ['', '#', 'Task', 'Project', 'Priority', 'Due', 'Status', 'Assigned To', '']
        if (cells.length >= 8) {
          cells[6] = ` ${status} `;
          lines[i] = `|${cells.slice(1, -1).join("|")}|`;
          updated = true;
        }
        break;
      }
    }

    if (!updated) {
      return { content: [{ type: "text", text: `Task #${task_number} not found` }] };
    }

    await writeFile(filePath, lines.join("\n"), "utf-8");
    return { content: [{ type: "text", text: `Task #${task_number} status updated to "${status}"` }] };
  }
);

// --- Tool: get_project_registry ---
server.tool(
  "get_project_registry",
  "Get full project tree with Maxim versions from .mxm-global/portfolio-registry/project_state.md",
  {},
  async () => {
    const content = await readMd("portfolio-registry/project_state.md");
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: get_investor_profile ---
server.tool(
  "get_investor_profile",
  "Get investment stage, revenue model, key differentiators from .mxm-global/INVESTOR-PROFILE.md",
  {},
  async () => {
    const content = await readMd("INVESTOR-PROFILE.md");
    return { content: [{ type: "text", text: content }] };
  }
);

// --- Tool: sync_portfolio ---
server.tool(
  "sync_portfolio",
  "Scan all registered projects, read their manifests and session memory, update .mxm-global/ with fresh data. Run daily before CEO morning cycle. Returns sync report.",
  {},
  async () => {
    const registryPath = join(MXM_GLOBAL, "portfolio-registry/project_state.md");
    let registryContent;
    try {
      registryContent = await readFile(registryPath, "utf-8");
    } catch {
      return { content: [{ type: "text", text: "Error: portfolio-registry/project_state.md not found" }] };
    }

    // Parse project paths from registry — extract paths between [version] tags
    // Use filesystem scan: find all config/project-manifest.json under PROJECTS_ROOT
    const projectsRoot = process.env.MXM_PROJECTS_ROOT || "E:/Projects";
    const projectEntries = [];

    // Scan 2 levels deep for project manifests
    const { readdir: readdirAsync } = await import("node:fs/promises");
    try {
      const topDirs = await readdirAsync(projectsRoot, { withFileTypes: true });
      for (const dir of topDirs) {
        if (!dir.isDirectory() || dir.name.startsWith(".")) continue;
        const dirPath = join(projectsRoot, dir.name);

        // Check if this folder has a manifest (direct project)
        const manifestPath = join(dirPath, "config/project-manifest.json");
        try {
          await stat(manifestPath);
          // Skip maxim itself
          if (dirPath.replace(/\\/g, "/").includes("maxim")) continue;
          projectEntries.push({ folder: dir.name, fullPath: dirPath.replace(/\\/g, "/") });
        } catch {
          // Not a direct project — check sub-folders (1 level deeper)
          try {
            const subDirs = await readdirAsync(dirPath, { withFileTypes: true });
            for (const sub of subDirs) {
              if (!sub.isDirectory() || sub.name.startsWith(".")) continue;
              const subPath = join(dirPath, sub.name);
              const subManifest = join(subPath, "config/project-manifest.json");
              try {
                await stat(subManifest);
                if (subPath.replace(/\\/g, "/").includes("maxim")) continue;
                projectEntries.push({ folder: `${dir.name}/${sub.name}`, fullPath: subPath.replace(/\\/g, "/") });
              } catch { /* no manifest */ }
            }
          } catch { /* can't read subdir */ }
        }
      }
    } catch {
      return { content: [{ type: "text", text: `Error: cannot scan ${projectsRoot}` }] };
    }

    // Scan each project
    const report = [];
    const metricsRows = [];
    const today = new Date().toISOString().split("T")[0];
    let totalProjects = 0;
    let atLatestVersion = 0;
    let withCompliance = 0;
    let latestariaVersion = "0.0.0";

    for (const entry of projectEntries) {
      totalProjects++;
      const manifestPath = join(entry.fullPath, "config/project-manifest.json");
      let manifest = null;
      let manifestVersion = entry.version;
      let stage = "unknown";
      let compliance = "—";
      let lastActivity = today;
      let status = "OK";

      try {
        await stat(manifestPath);
        const raw = await readFile(manifestPath, "utf-8");
        manifest = JSON.parse(raw);
        manifestVersion = manifest.mxm_version || entry.version;
        stage = manifest.project?.stage || "unknown";

        // Extract compliance
        const frameworks = manifest.compliance?.frameworks || [];
        if (frameworks.length > 0) {
          compliance = frameworks.join(", ");
          withCompliance++;
        }
      } catch {
        status = "MANIFEST_MISSING";
      }

      // Check session memory for last activity
      const handoffPath = join(entry.fullPath, ".claude-sessions-memory/handoff.md");
      try {
        const handoffStat = await stat(handoffPath);
        lastActivity = handoffStat.mtime.toISOString().split("T")[0];
      } catch {
        // No handoff file — use today as fallback
      }

      // Track latest Maxim version
      if (manifestVersion.localeCompare(latestariaVersion, undefined, { numeric: true }) > 0) {
        latestariaVersion = manifestVersion;
      }
      if (manifestVersion === latestariaVersion || entry.version === latestariaVersion) {
        atLatestVersion++;
      }

      metricsRows.push(`| ${entry.folder} | ${stage} | ${manifestVersion} | ${compliance} | ${lastActivity} |`);
      report.push({ project: entry.folder, version: manifestVersion, stage, compliance, lastActivity, status });
    }

    // Build updated PORTFOLIO-METRICS.md
    const stageCount = (s) => report.filter((r) => r.stage === s).length;
    const metricsContent = `# Portfolio Metrics — iSystematic

Last updated: ${today}

## Portfolio Health

| Metric | Value |
|---|---|
| Total Maxim-managed projects | ${totalProjects} |
| Maxim version (current) | ${latestariaVersion} |
| Projects at latest version | ${atLatestVersion}/${totalProjects} |
| Projects with compliance scope | ${withCompliance} |
| Active/scaling projects | ${stageCount("active") + stageCount("scaling")} |
| Development stage projects | ${stageCount("development") + stageCount("early-stage")} |
| Testing/experimental | ${stageCount("testing")} |
| Maintenance | ${stageCount("maintenance") + stageCount("mature")} |

## Project Status Matrix

| Project | Stage | Maxim Ver | Compliance | Last Activity |
|---|---|---|---|---|
${metricsRows.join("\n")}

## Compliance Coverage

_Auto-generated by sync_portfolio. See individual project manifests for details._

## Sync Report

- Scanned: ${totalProjects} projects
- At latest version (${latestariaVersion}): ${atLatestVersion}/${totalProjects}
- With compliance scope: ${withCompliance}
- Sync timestamp: ${new Date().toISOString()}
`;

    // Write updated metrics
    await writeFile(join(MXM_GLOBAL, "PORTFOLIO-METRICS.md"), metricsContent, "utf-8");

    // Update version in project_state.md header
    const updatedRegistry = registryContent
      .replace(/^Maxim version: .*$/m, `Maxim version: ${latestariaVersion}`)
      .replace(/^Last updated: .*$/m, `Last updated: ${today}`);
    await writeFile(registryPath, updatedRegistry, "utf-8");

    // Build sync report
    const staleProjects = report.filter((r) => r.version !== latestariaVersion);
    const missingManifests = report.filter((r) => r.status === "MANIFEST_MISSING");

    const syncReport = {
      timestamp: new Date().toISOString(),
      total_projects: totalProjects,
      latest_version: latestariaVersion,
      at_latest: atLatestVersion,
      with_compliance: withCompliance,
      stale_projects: staleProjects.map((p) => `${p.project} (${p.version})`),
      missing_manifests: missingManifests.map((p) => p.project),
      files_updated: ["PORTFOLIO-METRICS.md", "portfolio-registry/project_state.md"],
    };

    return { content: [{ type: "text", text: JSON.stringify(syncReport, null, 2) }] };
  }
);

// --- Tool: get_portfolio_health (v1.0.0) ---
server.tool(
  "get_portfolio_health",
  "Rollup health summary across portfolio projects — counts by lifecycle state (active/paused/archived/gated). v1.0.0 minimal-viable.",
  {},
  async () => {
    const content = await readMd("portfolio-overview.md");
    if (!content || content.startsWith("Error:")) {
      return { content: [{ type: "text", text: JSON.stringify({ error: "no portfolio-overview.md in .mxm-global/", note: "v1.0.0 minimal-viable tool — flag for Sprint 4 review" }, null, 2) }] };
    }
    const counts = { active: 0, paused: 0, archived: 0, gated: 0, total: 0 };
    const lines = content.split("\n");
    for (const line of lines) {
      const m = line.match(/lifecycle:\s*(\w+)/i);
      if (m) {
        counts.total++;
        const k = m[1].toLowerCase();
        if (counts[k] !== undefined) counts[k]++;
      }
      if (/gated:\s*true/i.test(line)) counts.gated++;
    }
    return { content: [{ type: "text", text: JSON.stringify(counts, null, 2) }] };
  }
);

// --- Tool: flag_stale_projects (v1.0.0) ---
server.tool(
  "flag_stale_projects",
  "Flag projects with last_activity older than N days (default 30). v1.0.0 minimal-viable.",
  {
    days: z.number().optional().describe("Staleness threshold in days (default: 30)"),
  },
  async ({ days = 30 }) => {
    const content = await readMd("portfolio-overview.md");
    if (!content || content.startsWith("Error:")) {
      return { content: [{ type: "text", text: JSON.stringify({ error: "no portfolio-overview.md", note: "v1.0.0 minimal-viable tool" }, null, 2) }] };
    }
    const cutoff = new Date();
    cutoff.setDate(cutoff.getDate() - days);
    const cutoffStr = cutoff.toISOString().split("T")[0];
    const stale = [];
    const blocks = content.split(/\n## /);
    for (const block of blocks) {
      const nameMatch = block.match(/^([A-Za-z0-9._-]+)/);
      const actMatch = block.match(/last_activity:\s*(\d{4}-\d{2}-\d{2})/);
      if (nameMatch && actMatch && actMatch[1] < cutoffStr) {
        stale.push({ project: nameMatch[1], last_activity: actMatch[1] });
      }
    }
    return { content: [{ type: "text", text: JSON.stringify({ cutoff: cutoffStr, threshold_days: days, stale_projects: stale }, null, 2) }] };
  }
);

// --- Start ---
const transport = new StdioServerTransport();
await server.connect(transport);
