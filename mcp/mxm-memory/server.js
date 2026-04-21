#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-memory — MCP Server
 * Unified memory search across file-based session memory.
 * Searches .claude-sessions-memory/ files for decisions, sessions, and context.
 *
 * Part of Maxim Framework v6.2.0
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { readFile, readdir, writeFile, appendFile } from "node:fs/promises";
import { join } from "node:path";

async function safeRead(filePath) {
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    return null;
  }
}

const server = new McpServer({
  name: "mxm-memory",
  version: "1.0.0",
});

// --- Tool: search_memory ---
server.tool(
  "search_memory",
  "Search across session memory files (.claude-sessions-memory/) for a query string. Returns matching lines with file context.",
  {
    query: z.string().describe("Search query (case-insensitive substring match)"),
    project_path: z.string().describe("Absolute path to the project root"),
    limit: z.number().optional().describe("Max results to return (default: 10)"),
  },
  async ({ query, project_path, limit = 10 }) => {
    const memDir = join(project_path, ".claude-sessions-memory");
    const queryLower = query.toLowerCase();
    const results = [];

    try {
      const files = await readdir(memDir);
      const mdFiles = files.filter((f) => f.endsWith(".md") || f.endsWith(".log"));

      for (const file of mdFiles) {
        const content = await safeRead(join(memDir, file));
        if (!content) continue;

        const lines = content.split("\n");
        for (let i = 0; i < lines.length; i++) {
          if (lines[i].toLowerCase().includes(queryLower)) {
            results.push({
              file,
              line: i + 1,
              text: lines[i].trim(),
              context: lines.slice(Math.max(0, i - 1), i + 2).join("\n"),
            });
            if (results.length >= limit) break;
          }
        }
        if (results.length >= limit) break;
      }
    } catch {
      return { content: [{ type: "text", text: `No .claude-sessions-memory/ found at ${project_path}` }] };
    }

    if (results.length === 0) {
      return { content: [{ type: "text", text: `No matches for "${query}" in session memory.` }] };
    }

    return { content: [{ type: "text", text: JSON.stringify(results, null, 2) }] };
  }
);

// --- Tool: get_recent_decisions ---
server.tool(
  "get_recent_decisions",
  "Get decisions from the decision log, optionally filtered by recency.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    days: z.number().optional().describe("Only return decisions from the last N days (default: 30)"),
  },
  async ({ project_path, days = 30 }) => {
    const content = await safeRead(join(project_path, ".claude-sessions-memory/decision-log.md"));
    if (!content || content.trim() === "") {
      return { content: [{ type: "text", text: "No decision log found." }] };
    }

    // Try to filter by date if dates are present in the content
    const cutoff = new Date();
    cutoff.setDate(cutoff.getDate() - days);
    const cutoffStr = cutoff.toISOString().split("T")[0];

    const sections = content.split(/\n---\n/);
    const recent = sections.filter((s) => {
      const dateMatch = s.match(/\d{4}-\d{2}-\d{2}/);
      if (!dateMatch) return true; // Include if no date found
      return dateMatch[0] >= cutoffStr;
    });

    return { content: [{ type: "text", text: recent.join("\n---\n") || "No recent decisions found." }] };
  }
);

// --- Tool: get_session_history ---
server.tool(
  "get_session_history",
  "Get session summaries sorted by date from .claude-sessions-memory/session-*.md files.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    limit: z.number().optional().describe("Max number of sessions to return (default: 5)"),
  },
  async ({ project_path, limit = 5 }) => {
    const memDir = join(project_path, ".claude-sessions-memory");
    try {
      const files = await readdir(memDir);
      const sessionFiles = files
        .filter((f) => f.startsWith("session-") && f.endsWith(".md"))
        .sort()
        .reverse()
        .slice(0, limit);

      if (sessionFiles.length === 0) {
        return { content: [{ type: "text", text: "No session files found." }] };
      }

      const sessions = [];
      for (const file of sessionFiles) {
        const content = await safeRead(join(memDir, file));
        if (content) {
          // Take first 50 lines as summary
          const summary = content.split("\n").slice(0, 50).join("\n");
          sessions.push(`## ${file}\n${summary}`);
        }
      }

      return { content: [{ type: "text", text: sessions.join("\n\n---\n\n") }] };
    } catch {
      return { content: [{ type: "text", text: `No .claude-sessions-memory/ found at ${project_path}` }] };
    }
  }
);

// --- Tool: store_memory ---
server.tool(
  "store_memory",
  "Store a fact/decision/observation to the project's session memory (appends to decision-log.md).",
  {
    fact: z.string().describe("The fact, decision, or observation to store"),
    project_path: z.string().describe("Absolute path to the project root"),
    office: z.string().optional().describe("Which Maxim office this relates to (e.g., 'cto', 'cmo')"),
  },
  async ({ fact, project_path, office }) => {
    const logPath = join(project_path, ".claude-sessions-memory/decision-log.md");
    const date = new Date().toISOString().split("T")[0];
    const entry = `\n---\n\n### ${date}${office ? ` [${office.toUpperCase()}]` : ""}\n\n${fact}\n`;

    try {
      await appendFile(logPath, entry, "utf-8");
      return { content: [{ type: "text", text: `Stored to ${logPath}` }] };
    } catch {
      // Try to create the file if it doesn't exist
      try {
        const header = `# Decision Log\n\nAutomatically maintained by mxm-memory MCP server.\n${entry}`;
        await writeFile(logPath, header, "utf-8");
        return { content: [{ type: "text", text: `Created and stored to ${logPath}` }] };
      } catch (e) {
        return { content: [{ type: "text", text: `Error storing memory: ${e.message}. Ensure .claude-sessions-memory/ exists at ${project_path}` }] };
      }
    }
  }
);

// --- Tool: list_memory_topics (v1.0.0) ---
server.tool(
  "list_memory_topics",
  "Enumerate auto-memory topic files (user_*, feedback_*, project_*, reference_*) with descriptions.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const memDir = join(project_path, "memory");
    try {
      const files = await readdir(memDir);
      const topics = [];
      for (const f of files) {
        if (!f.endsWith(".md") || f === "MEMORY.md") continue;
        const content = await safeRead(join(memDir, f));
        if (!content) continue;
        const nameMatch = content.match(/^name:\s*(.+)$/m);
        const typeMatch = content.match(/^type:\s*(.+)$/m);
        const descMatch = content.match(/^description:\s*(.+)$/m);
        topics.push({
          file: f,
          name: nameMatch ? nameMatch[1].trim() : f.replace(/\.md$/, ""),
          type: typeMatch ? typeMatch[1].trim() : "unknown",
          description: descMatch ? descMatch[1].trim() : "",
        });
      }
      return { content: [{ type: "text", text: JSON.stringify(topics, null, 2) }] };
    } catch {
      return { content: [{ type: "text", text: `No memory/ dir at ${project_path}` }] };
    }
  }
);

// --- Tool: archive_session_memory (v1.0.0) ---
server.tool(
  "archive_session_memory",
  "Archive session-YYYY-MM-DD.md files older than N days (default 90) to .mxm-skills/archive/. Returns list of archived files.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    days: z.number().optional().describe("Age threshold in days (default: 90)"),
  },
  async ({ project_path, days = 90 }) => {
    const { rename, mkdir } = await import("node:fs/promises");
    const memDir = join(project_path, ".claude-sessions-memory");
    const archiveDir = join(project_path, ".mxm-skills/archive");
    try {
      await mkdir(archiveDir, { recursive: true });
      const files = await readdir(memDir);
      const cutoff = new Date();
      cutoff.setDate(cutoff.getDate() - days);
      const cutoffStr = cutoff.toISOString().split("T")[0];
      const archived = [];
      for (const f of files) {
        const m = f.match(/^session-(\d{4}-\d{2}-\d{2})\.md$/);
        if (!m) continue;
        if (m[1] < cutoffStr) {
          await rename(join(memDir, f), join(archiveDir, f));
          archived.push(f);
        }
      }
      return { content: [{ type: "text", text: JSON.stringify({ archived, count: archived.length, cutoff: cutoffStr }, null, 2) }] };
    } catch (e) {
      return { content: [{ type: "text", text: `Archive failed: ${e.message}` }] };
    }
  }
);

// --- Start ---
const transport = new StdioServerTransport();
await server.connect(transport);
