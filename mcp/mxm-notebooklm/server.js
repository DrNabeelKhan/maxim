#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
//
// Wraps teng-lin/notebooklm-py (MIT) — see ADR-018 External Tool Integration Pattern.

/**
 * mxm-notebooklm — MCP Server (v1.2.1.0+)
 *
 * 38 tools across 8 domains wrapping the notebooklm CLI. Every tool shells out
 * to `notebooklm <command> --json` and returns the parsed JSON envelope.
 *
 * Domains:
 *   notebook (6)  — create · list · get · rename · delete · share
 *   source   (8)  — add_url · add_youtube · add_drive · add_text · add_file · list · wait · delete
 *   chat     (2)  — ask · history
 *   research (3)  — web · drive · wait
 *   generate (9)  — audio · video · slides · infographic · quiz · flashcards · report · datatable · mindmap
 *   artifact (4)  — list · wait · download · get
 *   auth     (4)  — check · refresh · inspect · login
 *   profile  (2)  — list · switch
 *
 * Pre-flight: every tool except auth_* runs auth_check first; on failure
 * returns a structured error with install + login instructions rather than
 * surfacing a cryptic CLI exit code.
 *
 * Long-running ops (generate_*, research_web, research_drive, source_add_file
 * with audio/video) return { task_id, status: "PROCESSING" } immediately.
 * Operator polls via artifact_wait / source_wait / research_wait.
 *
 * Free-tier per ADR-018 — no license gate. MIT upstream stays unrestricted.
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { spawn } from "node:child_process";

// ──────────────────────────────────────────────────────────────────────────────
// CLI invocation helper
// ──────────────────────────────────────────────────────────────────────────────

const NOTEBOOKLM_BIN = process.env.NOTEBOOKLM_BIN || "notebooklm";
const CLI_TIMEOUT_MS = Number(process.env.NOTEBOOKLM_CLI_TIMEOUT_MS || 120_000);

/**
 * Invoke the notebooklm CLI with --json flag and parse the JSON envelope.
 * @param {string[]} args
 * @returns {Promise<{ok: boolean, data?: any, error?: string, stderr?: string, exit_code?: number}>}
 */
function invokeCli(args) {
  return new Promise((resolve) => {
    const argsWithJson = [...args];
    if (!argsWithJson.includes("--json")) argsWithJson.push("--json");

    const child = spawn(NOTEBOOKLM_BIN, argsWithJson, {
      stdio: ["ignore", "pipe", "pipe"],
      timeout: CLI_TIMEOUT_MS,
      shell: false,
    });

    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (chunk) => { stdout += chunk.toString("utf8"); });
    child.stderr.on("data", (chunk) => { stderr += chunk.toString("utf8"); });

    child.on("error", (err) => {
      resolve({
        ok: false,
        error: err.code === "ENOENT"
          ? `notebooklm CLI not found on PATH. Install: pip install "notebooklm-py[browser]" && playwright install chromium && notebooklm login`
          : `Failed to spawn notebooklm: ${err.message}`,
        stderr,
      });
    });

    child.on("close", (code) => {
      if (code !== 0) {
        resolve({ ok: false, error: stderr.trim() || `notebooklm exited ${code}`, stderr, exit_code: code });
        return;
      }
      try {
        const data = stdout.trim() ? JSON.parse(stdout) : {};
        resolve({ ok: true, data });
      } catch (err) {
        resolve({ ok: false, error: `Failed to parse JSON: ${err.message}`, stderr: stdout });
      }
    });
  });
}

/** Render an MCP-shaped response from a CLI result. */
function asMcp(result) {
  return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
}

/** Pre-flight auth check (cached for session). Returns null if OK, error MCP response if not. */
let authCachedAt = 0;
let authCachedOk = false;
async function preflightAuth() {
  const now = Date.now();
  if (authCachedOk && now - authCachedAt < 300_000) return null; // 5 min cache

  const r = await invokeCli(["auth", "check"]);
  if (!r.ok) {
    authCachedOk = false;
    return asMcp({
      ok: false,
      stage: "auth_preflight",
      error: r.error,
      action_required: [
        'pip install "notebooklm-py[browser]"',
        'playwright install chromium',
        'notebooklm login',
        'then retry your task',
      ],
      docs: "https://github.com/teng-lin/notebooklm-py#installation",
    });
  }
  authCachedOk = true;
  authCachedAt = now;
  return null;
}

// ──────────────────────────────────────────────────────────────────────────────
// MCP server
// ──────────────────────────────────────────────────────────────────────────────

const server = new McpServer({
  name: "mxm-notebooklm",
  version: "1.0.0",
});

// NOTE: ADR-018 ratifies free-tier for this MCP. No license-gate wrapping.
// Upstream is MIT; Maxim's wrapper is BSL-1.1 but the capability surface
// stays unrestricted to honor "implement by default" operator directive.

// ──────────────────────────────────────────────────────────────────────────────
// AUTH domain (4 tools) — runs BEFORE preflight check
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "auth_check",
  "Verify the notebooklm CLI is authenticated to Google. Returns auth status, expiry, and profile.",
  {},
  async () => asMcp(await invokeCli(["auth", "check"])),
);

server.tool(
  "auth_refresh",
  "Refresh the current authentication token. Runs without browser interaction if refresh-token is still valid.",
  {},
  async () => asMcp(await invokeCli(["auth", "refresh"])),
);

server.tool(
  "auth_inspect",
  "Inspect the current auth state: profile email, permissions, token expiry, cookie source. Useful for debugging auth issues.",
  {},
  async () => asMcp(await invokeCli(["auth", "inspect"])),
);

server.tool(
  "auth_login",
  "Initiate browser-based Google sign-in. Returns informational guidance — actual browser launch must be run from operator terminal, not MCP context. Use the returned command on the operator machine.",
  {},
  async () => ({
    content: [{
      type: "text",
      text: JSON.stringify({
        ok: true,
        action_required: "Run `notebooklm login` from operator terminal (opens browser for Google sign-in)",
        alternatives: [
          "Import existing browser cookies: `notebooklm login --cookies-from-browser chrome`",
          "Use `notebooklm login --cookies-from-browser edge` for Edge",
        ],
        docs: "https://github.com/teng-lin/notebooklm-py#authentication",
      }, null, 2),
    }],
  }),
);

// ──────────────────────────────────────────────────────────────────────────────
// NOTEBOOK domain (6 tools)
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "notebook_create",
  "Create a new NotebookLM notebook. Returns notebook_id and metadata.",
  {
    name: z.string().describe("Notebook display name"),
    description: z.string().optional().describe("Optional notebook description"),
  },
  async ({ name, description }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["create", name];
    if (description) args.push("--description", description);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "notebook_list",
  "List all notebooks accessible to the current authenticated user.",
  {},
  async () => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["list"]));
  },
);

server.tool(
  "notebook_get",
  "Get full metadata for a notebook including source count, sharing permissions, last activity.",
  {
    notebook_id: z.string().describe("Notebook ID (from notebook_list or notebook_create)"),
  },
  async ({ notebook_id }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["status", "-n", notebook_id]));
  },
);

server.tool(
  "notebook_rename",
  "Rename an existing notebook.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    new_name: z.string().describe("New display name"),
  },
  async ({ notebook_id, new_name }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["rename", "-n", notebook_id, new_name]));
  },
);

server.tool(
  "notebook_delete",
  "Delete a notebook. DESTRUCTIVE — requires explicit confirm=true. All sources and artifacts are removed.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    confirm: z.boolean().describe("Must be true to proceed. Safety guard against accidental delete."),
  },
  async ({ notebook_id, confirm }) => {
    if (!confirm) {
      return asMcp({ ok: false, error: "Confirmation required. Pass confirm=true to proceed with delete." });
    }
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["delete", "-n", notebook_id, "--yes"]));
  },
);

server.tool(
  "notebook_share",
  "Share a notebook with another Google account. Permissions: viewer | commenter | editor.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    email: z.string().describe("Recipient Google account email"),
    permission: z.enum(["viewer", "commenter", "editor"]).describe("Permission level"),
  },
  async ({ notebook_id, email, permission }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["share", "-n", notebook_id, "--email", email, "--permission", permission]));
  },
);

// ──────────────────────────────────────────────────────────────────────────────
// SOURCE domain (8 tools)
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "source_add_url",
  "Add a web URL as a source to a notebook. NotebookLM crawls and ingests the page content. Returns source_id; ingest may take 30s–10min — use source_wait to poll.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    url: z.string().describe("Web URL to ingest"),
  },
  async ({ notebook_id, url }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["source", "add", "-n", notebook_id, "--url", url]));
  },
);

server.tool(
  "source_add_youtube",
  "Add a YouTube video as a source. NotebookLM ingests the video transcript.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    youtube_url: z.string().describe("YouTube video URL"),
  },
  async ({ notebook_id, youtube_url }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["source", "add", "-n", notebook_id, "--youtube", youtube_url]));
  },
);

server.tool(
  "source_add_drive",
  "Add a Google Drive file or folder as a source. Drive file ID or share URL accepted.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    drive_ref: z.string().describe("Drive file ID OR full Drive share URL"),
  },
  async ({ notebook_id, drive_ref }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["source", "add", "-n", notebook_id, "--drive", drive_ref]));
  },
);

server.tool(
  "source_add_text",
  "Add raw text as a source. Useful for pasting research notes, meeting transcripts, or excerpts.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    text: z.string().describe("Source text content"),
    title: z.string().optional().describe("Optional source title (defaults to first 50 chars)"),
  },
  async ({ notebook_id, text, title }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["source", "add", "-n", notebook_id, "--text", text];
    if (title) args.push("--title", title);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "source_add_file",
  "Add a local file as a source. Supports PDF, DOCX, TXT, MD, audio (mp3/m4a/wav), video (mp4/mov), images (jpg/png).",
  {
    notebook_id: z.string().describe("Notebook ID"),
    file_path: z.string().describe("Absolute path to local file"),
  },
  async ({ notebook_id, file_path }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["source", "add", "-n", notebook_id, "--file", file_path]));
  },
);

server.tool(
  "source_list",
  "List all sources in a notebook with processing status and metadata.",
  {
    notebook_id: z.string().describe("Notebook ID"),
  },
  async ({ notebook_id }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["source", "list", "-n", notebook_id]));
  },
);

server.tool(
  "source_wait",
  "Block until a source finishes processing. Returns final status (READY / FAILED) and any error messages. Polls with backoff up to timeout.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    source_id: z.string().describe("Source ID returned by source_add_*"),
    timeout_seconds: z.number().optional().describe("Max wait in seconds (default 600 = 10min)"),
  },
  async ({ notebook_id, source_id, timeout_seconds }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["source", "wait", "-n", notebook_id, "--source-id", source_id];
    if (timeout_seconds) args.push("--timeout", String(timeout_seconds));
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "source_delete",
  "Remove a source from a notebook. The source is removed but other artifacts that were generated from it remain.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    source_id: z.string().describe("Source ID"),
  },
  async ({ notebook_id, source_id }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["source", "delete", "-n", notebook_id, "--source-id", source_id, "--yes"]));
  },
);

// ──────────────────────────────────────────────────────────────────────────────
// CHAT domain (2 tools)
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "chat_ask",
  "Ask a question of the notebook's sources. Returns an answer with citations to source passages. Optionally save the Q+A as a note.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    question: z.string().describe("Question to ask"),
    save_as_note: z.boolean().optional().describe("Save the answer as a note in the notebook (default false)"),
  },
  async ({ notebook_id, question, save_as_note }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["ask", "-n", notebook_id, question];
    if (save_as_note) args.push("--save-as-note");
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "chat_history",
  "Retrieve conversation history for a notebook. Optionally save to a file.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    save_to: z.string().optional().describe("Optional file path to save history (markdown)"),
  },
  async ({ notebook_id, save_to }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["history", "-n", notebook_id];
    if (save_to) args.push("--save", save_to);
    return asMcp(await invokeCli(args));
  },
);

// ──────────────────────────────────────────────────────────────────────────────
// RESEARCH domain (3 tools)
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "research_web",
  "Run a deep web research agent on a query. Optionally auto-import findings as sources. Long-running (15–30min); returns research_id — use research_wait to poll.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    query: z.string().describe("Research query"),
    auto_import: z.boolean().optional().describe("Auto-import found sources to notebook (default true)"),
  },
  async ({ notebook_id, query, auto_import }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["research", "web", "-n", notebook_id, query];
    if (auto_import === false) args.push("--no-auto-import");
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "research_drive",
  "Run research over the operator's Google Drive. Optionally auto-import.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    query: z.string().describe("Research query"),
    auto_import: z.boolean().optional().describe("Auto-import (default true)"),
  },
  async ({ notebook_id, query, auto_import }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["research", "drive", "-n", notebook_id, query];
    if (auto_import === false) args.push("--no-auto-import");
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "research_wait",
  "Block until a research run completes. Returns the final report with cited sources.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    research_id: z.string().describe("Research ID from research_web / research_drive"),
    timeout_seconds: z.number().optional().describe("Max wait (default 2400 = 40min)"),
  },
  async ({ notebook_id, research_id, timeout_seconds }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["research", "wait", "-n", notebook_id, "--research-id", research_id];
    if (timeout_seconds) args.push("--timeout", String(timeout_seconds));
    return asMcp(await invokeCli(args));
  },
);

// ──────────────────────────────────────────────────────────────────────────────
// GENERATE domain (9 tools) — long-running, return task_id
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "generate_audio_overview",
  "Generate an audio overview (podcast-style). Returns task_id; use artifact_wait to poll. Generation takes 10–20 minutes.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    format: z.enum(["deep-dive", "brief", "critique", "debate"]).optional().describe("Audio format (default deep-dive)"),
    length: z.enum(["short", "default", "long"]).optional().describe("Length preset (default 'default')"),
    language: z.string().optional().describe("ISO language code (e.g., en, es, fr, hi, ar). 50+ supported. Default: en"),
  },
  async ({ notebook_id, format, length, language }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["generate", "audio", "-n", notebook_id];
    if (format) args.push("--format", format);
    if (length) args.push("--length", length);
    if (language) args.push("--language", language);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_video_overview",
  "Generate a video overview. Returns task_id. Generation takes 15–45 minutes.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    format: z.enum(["explainer", "narrative", "summary"]).optional().describe("Video format"),
    style: z.enum(["whiteboard", "infographic", "documentary", "tutorial", "presentation", "cinematic", "minimalist", "vibrant", "professional"]).optional().describe("Visual style (9 options)"),
  },
  async ({ notebook_id, format, style }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["generate", "video", "-n", notebook_id];
    if (format) args.push("--format", format);
    if (style) args.push("--style", style);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_slides",
  "Generate a slide deck from the notebook's sources. Returns task_id.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    description: z.string().optional().describe("Optional description focus (default: synthesizes all sources). CLI takes this as positional DESCRIPTION arg."),
  },
  async ({ notebook_id, description }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    // BUG-009 fix (v1.3.2.2): CLI subcommand is `slide-deck`, not `slides`.
    // BUG-009 fix (v1.3.2.2): description is positional DESCRIPTION arg, not --topic flag.
    const args = ["generate", "slide-deck", "-n", notebook_id];
    if (description) args.push(description);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_infographic",
  "Generate an infographic from the notebook's sources.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    description: z.string().optional().describe("Optional description focus. CLI takes this as positional DESCRIPTION arg."),
  },
  async ({ notebook_id, description }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    // BUG-009 fix (v1.3.2.2): description is positional DESCRIPTION arg, not --topic flag.
    const args = ["generate", "infographic", "-n", notebook_id];
    if (description) args.push(description);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_quiz",
  "Generate a quiz from the notebook's sources. Exportable as JSON/Markdown/HTML via artifact_download.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    num_questions: z.number().optional().describe("Number of questions (default 10)"),
  },
  async ({ notebook_id, num_questions }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["generate", "quiz", "-n", notebook_id];
    if (num_questions) args.push("--num-questions", String(num_questions));
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_flashcards",
  "Generate flashcards. Exportable as JSON/Markdown/HTML.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    num_cards: z.number().optional().describe("Number of cards (default 20)"),
  },
  async ({ notebook_id, num_cards }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["generate", "flashcards", "-n", notebook_id];
    if (num_cards) args.push("--num-cards", String(num_cards));
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_report",
  "Generate a written report synthesizing the notebook's sources. Optional template.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    template: z.string().optional().describe("Optional template name (e.g., 'executive-summary', 'literature-review', 'product-brief')"),
  },
  async ({ notebook_id, template }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["generate", "report", "-n", notebook_id];
    if (template) args.push("--template", template);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_data_table",
  "Generate a structured data table extracted from the notebook's sources. Useful for comparison matrices.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    description: z.string().describe("Required description specifying the data shape (e.g., 'compare features across products'). CLI takes this as REQUIRED positional DESCRIPTION arg."),
  },
  async ({ notebook_id, description }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    // BUG-009 fix (v1.3.2.2): CLI subcommand is `data-table`, not `datatable`.
    // BUG-009 fix (v1.3.2.2): description is REQUIRED positional, not --query flag.
    const args = ["generate", "data-table", "-n", notebook_id, description];
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "generate_mindmap",
  "Generate a mind map of concepts from the notebook's sources. Downloadable as JSON for downstream visualization.",
  {
    notebook_id: z.string().describe("Notebook ID"),
  },
  async ({ notebook_id }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    // BUG-009 fix (v1.3.2.2): CLI subcommand is `mind-map`, not `mindmap`.
    return asMcp(await invokeCli(["generate", "mind-map", "-n", notebook_id]));
  },
);

// ──────────────────────────────────────────────────────────────────────────────
// ARTIFACT domain (4 tools)
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "artifact_list",
  "List all artifacts (audio/video/slides/quiz/etc.) generated in a notebook with their status.",
  {
    notebook_id: z.string().describe("Notebook ID"),
  },
  async ({ notebook_id }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["artifact", "list", "-n", notebook_id]));
  },
);

server.tool(
  "artifact_wait",
  "Block until an artifact finishes generating. Polls with backoff.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    task_id: z.string().describe("Task ID returned by any generate_* tool"),
    timeout_seconds: z.number().optional().describe("Max wait in seconds (default 2700 = 45min for video)"),
  },
  async ({ notebook_id, task_id, timeout_seconds }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["artifact", "wait", "-n", notebook_id, "--task-id", task_id];
    if (timeout_seconds) args.push("--timeout", String(timeout_seconds));
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "artifact_download",
  "Download a completed artifact to local filesystem. Format depends on artifact type — quiz/flashcards support json/markdown/html; audio is m4a; video is mp4.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    artifact_id: z.string().describe("Artifact ID (from artifact_list or artifact_wait)"),
    destination: z.string().optional().describe("Optional output path. Default: ./<artifact-name>.<format>"),
    format: z.string().optional().describe("Optional format override (json|markdown|html for structured artifacts)"),
  },
  async ({ notebook_id, artifact_id, destination, format }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    const args = ["download", "-n", notebook_id, "--artifact-id", artifact_id];
    if (destination) args.push("--output", destination);
    if (format) args.push("--format", format);
    return asMcp(await invokeCli(args));
  },
);

server.tool(
  "artifact_get",
  "Get artifact metadata: status, type, generation params, download URL, size.",
  {
    notebook_id: z.string().describe("Notebook ID"),
    artifact_id: z.string().describe("Artifact ID"),
  },
  async ({ notebook_id, artifact_id }) => {
    const auth = await preflightAuth(); if (auth) return auth;
    return asMcp(await invokeCli(["artifact", "get", "-n", notebook_id, "--artifact-id", artifact_id]));
  },
);

// ──────────────────────────────────────────────────────────────────────────────
// PROFILE domain (2 tools)
// ──────────────────────────────────────────────────────────────────────────────

server.tool(
  "profile_list",
  "List configured notebooklm profiles (different Google accounts).",
  {},
  async () => asMcp(await invokeCli(["profile", "list"])),
);

server.tool(
  "profile_switch",
  "Switch the active profile (changes which Google account is used).",
  {
    profile_name: z.string().describe("Profile name (from profile_list)"),
  },
  async ({ profile_name }) => asMcp(await invokeCli(["profile", "switch", profile_name])),
);

// ──────────────────────────────────────────────────────────────────────────────
// Start
// ──────────────────────────────────────────────────────────────────────────────

const transport = new StdioServerTransport();
await server.connect(transport);
