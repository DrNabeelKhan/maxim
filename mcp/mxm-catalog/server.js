#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-catalog — MCP Server (v1.0.0+)
 *
 * Unified catalog: agents, offices, skills, commands. Merges the former
 * maxim-dispatch + maxim-skills servers (ADR-002 consolidation).
 *
 * 9 tools:
 *   Agent/office routing (ex-dispatch):
 *     - route_task          Route a task to the correct office + lead agent
 *     - list_agents         List all Maxim agents (optionally filtered by office)
 *     - get_agent_dna       Get the full markdown of a specific agent
 *     - list_offices        List all 7 executive offices
 *     - get_handoff_chain   Get the planner→implementer→reviewer→tester→release chain
 *   Skill/command catalog (ex-skills):
 *     - list_skills         List all .claude/skills/ domains
 *     - search_skills       Search skills by trigger / tag / framework keywords
 *     - get_skill_detail    Get a skill's full SKILL.md
 *     - list_commands       List all /mxm-* slash commands
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { readFile, readdir } from "node:fs/promises";
import { join } from "node:path";

const MXM_ROOT = process.env.MXM_ROOT || "E:/Projects/Maxim/maxim";

async function safeRead(filePath) {
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    return null;
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Office routing table (ex-dispatch)
// ──────────────────────────────────────────────────────────────────────────────

const OFFICES = {
  ceo: {
    name: "CEO Office",
    lead: "enterprise-architect",
    keywords: ["strategy", "vision", "finance", "partnerships", "enterprise", "architecture", "investor", "business model", "governance", "negotiation"],
    agents: ["enterprise-architect", "business-architect", "influence-strategist", "negotiation-specialist", "financial-modeler", "studio-producer", "investor-pitch-writer", "partnership-manager", "governance-specialist"],
    skill_domains: ["enterprise-architecture", "studio-operations"],
  },
  cto: {
    name: "CTO Office",
    lead: "implementer",
    keywords: ["engineering", "code", "build", "deploy", "api", "database", "infrastructure", "devops", "cloud", "backend", "frontend", "ai", "ml", "data", "test", "performance", "security architecture", "schema", "auth", "docker", "rls", "mvp", "scaffold", "migrate", "pipeline", "supabase", "fastapi", "nextjs", "react", "typescript", "python", "node"],
    agents: ["ai-engineer", "backend-architect", "frontend-developer", "devops-automator", "infrastructure-maintainer", "security-architect", "solution-architect", "rapid-prototyper", "rag-specialist", "prompt-engineer", "api-integrator", "cloud-cost-optimizer", "dependency-auditor", "mobile-app-builder", "support-agent-builder", "performance-engineer", "api-tester", "data-architect", "data-scientist", "analytics-reporter", "training-data-curator", "database-optimizer", "load-tester", "technology-architect", "test-data-generator"],
    skill_domains: ["engineering", "testing", "ai-media-generation"],
  },
  cmo: {
    name: "CMO Office",
    lead: "content-strategist",
    keywords: ["marketing", "brand", "content", "seo", "conversion", "copy", "email", "growth", "campaign", "landing page", "social media", "ads", "persuasion", "behavioral", "video", "animation", "cinematic"],
    agents: ["seo-specialist", "brand-guardian", "conversion-optimizer", "persuasion-specialist", "behavioral-designer", "decision-architect", "habit-formation-coach", "nudge-architect", "localization-specialist", "documentation-writer", "email-campaign-writer", "growth-hacker", "gtm-strategist", "landing-page-optimizer"],
    skill_domains: ["marketing", "content-creation", "search-visibility", "behavior-science-persuasion", "brand", "banner-design", "ai-media-generation"],
  },
  cso: {
    name: "CSO Office",
    lead: "security-analyst",
    keywords: ["security", "compliance", "privacy", "ethics", "threat", "vulnerability", "incident", "audit", "gdpr", "pipeda", "pci", "penetration", "risk"],
    agents: ["threat-modeler", "penetration-tester", "incident-responder", "compliance-officer", "ai-ethics-reviewer", "data-privacy-officer", "legal-compliance-checker", "incident-post-mortem-writer"],
    skill_domains: ["security", "compliance"],
  },
  cpo: {
    name: "CPO Office",
    lead: "product-strategist",
    keywords: ["product", "ux", "ui", "user research", "feedback", "roadmap", "feature", "persona", "competitive", "pricing", "accessibility", "onboarding", "design"],
    agents: ["ux-researcher", "ui-designer", "ui-ux-designer", "feedback-synthesizer", "trend-researcher", "competitive-analyst", "market-analyst", "pricing-strategist", "accessibility-auditor", "onboarding-designer", "product-manager"],
    skill_domains: ["product", "design", "design-system", "ui-styling", "slides", "ui-ux-pro-max", "design-resources"],
  },
  coo: {
    name: "COO Office",
    lead: "planner",
    keywords: ["operations", "delivery", "support", "sprint", "project", "plan", "schedule", "workflow", "experiment", "changelog", "knowledge base", "phase", "milestone", "release", "organize", "cleanup", "watch", "drift", "audit", "health"],
    agents: ["project-shipper", "support-responder", "customer-success-manager", "workflow-optimizer", "sprint-prioritizer", "experiment-tracker", "knowledge-base-curator", "tool-evaluator", "changelog-writer"],
    skill_domains: ["project-management", "studio-operations", "proactive-watch"],
  },
  cino: {
    name: "CINO Office",
    lead: "innovation-researcher",
    keywords: ["innovation", "r&d", "emerging", "horizon", "research", "prototype", "experiment", "novel"],
    agents: ["rd-coordinator"],
    skill_domains: ["product-development-research"],
  },
};

function routeTask(task) {
  const taskLower = task.toLowerCase();
  const scores = {};
  for (const [office, config] of Object.entries(OFFICES)) {
    let score = 0;
    for (const keyword of config.keywords) {
      if (taskLower.includes(keyword)) score += 2;
    }
    for (const agent of config.agents) {
      const words = agent.replace(/-/g, " ").split(" ");
      for (const w of words) {
        if (w.length > 3 && taskLower.includes(w)) score += 1;
      }
    }
    scores[office] = score;
  }
  const sorted = Object.entries(scores).sort((a, b) => b[1] - a[1]);
  const best = sorted[0];
  if (best[1] === 0) {
    return { office: "unroutable", confidence: "LOW", suggestion: "Use /mxm-route for manual classification" };
  }
  const officeConfig = OFFICES[best[0]];
  const confidence = best[1] >= 6 ? "HIGH" : best[1] >= 3 ? "MEDIUM" : "LOW";
  return {
    office: best[0],
    office_name: officeConfig.name,
    lead_agent: officeConfig.lead,
    skill_domains: officeConfig.skill_domains,
    confidence,
    score: best[1],
    all_scores: Object.fromEntries(sorted),
  };
}

// ──────────────────────────────────────────────────────────────────────────────
// Skill catalog loader (ex-skills)
// ──────────────────────────────────────────────────────────────────────────────

function parseYamlFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return {};
  const yaml = match[1];
  const result = {};
  let currentKey = null;
  for (const line of yaml.split("\n")) {
    if (/^\s+-\s+/.test(line) && currentKey) {
      if (!Array.isArray(result[currentKey])) result[currentKey] = [];
      result[currentKey].push(line.replace(/^\s+-\s+/, "").trim());
      continue;
    }
    const colonIdx = line.indexOf(":");
    if (colonIdx === -1) continue;
    const key = line.substring(0, colonIdx).trim();
    let value = line.substring(colonIdx + 1).trim();
    currentKey = key;
    if (value.startsWith("[") && value.endsWith("]")) {
      value = value.slice(1, -1).split(",").map((s) => s.trim().replace(/^['"]|['"]$/g, ""));
    }
    result[key] = value;
  }
  return result;
}

async function loadSkillCatalog() {
  const skillsDir = join(MXM_ROOT, ".claude/skills");
  const domains = [];
  try {
    const dirs = await readdir(skillsDir, { withFileTypes: true });
    for (const dir of dirs) {
      if (!dir.isDirectory() || dir.name === "deprecated") continue;
      const content = await safeRead(join(skillsDir, dir.name, "SKILL.md"));
      if (!content) continue;
      const meta = parseYamlFrontmatter(content);
      domains.push({
        domain: dir.name,
        skill_id: meta.skill_id || dir.name,
        name: meta.name || dir.name,
        version: meta.version || "1.0.0",
        category: meta.category || dir.name,
        triggers: Array.isArray(meta.triggers) ? meta.triggers : [],
        frameworks: Array.isArray(meta.frameworks) ? meta.frameworks : [],
        tags: Array.isArray(meta.tags) ? meta.tags : [],
      });
    }
  } catch {
    // skills dir not found
  }
  return domains;
}

// ──────────────────────────────────────────────────────────────────────────────
// MCP server
// ──────────────────────────────────────────────────────────────────────────────

const server = new McpServer({
  name: "mxm-catalog",
  version: "1.1.0",
});

// ——— Agent routing (ex-dispatch) ———

server.tool(
  "route_task",
  "Route a task to the correct Maxim office, agent, and skill domain. Returns office, lead agent, applicable skills, and confidence level.",
  {
    task: z.string().describe("Description of the task to route"),
    project_id: z.string().optional().describe("Project identifier for context"),
  },
  async ({ task, project_id }) => {
    const routing = routeTask(task);
    if (project_id) routing.project_id = project_id;
    return { content: [{ type: "text", text: JSON.stringify(routing, null, 2) }] };
  }
);

server.tool(
  "list_agents",
  "List all Maxim agents, optionally filtered by office (ceo, cto, cmo, cso, cpo, coo, cino).",
  {
    office: z.enum(["ceo", "cto", "cmo", "cso", "cpo", "coo", "cino"]).optional().describe("Filter by office"),
  },
  async ({ office }) => {
    if (office) {
      const config = OFFICES[office];
      return { content: [{ type: "text", text: JSON.stringify({ office, name: config.name, lead: config.lead, agents: config.agents, skill_domains: config.skill_domains }, null, 2) }] };
    }
    const all = Object.entries(OFFICES).map(([key, config]) => ({
      office: key,
      name: config.name,
      lead: config.lead,
      agent_count: config.agents.length,
      agents: config.agents,
    }));
    return { content: [{ type: "text", text: JSON.stringify(all, null, 2) }] };
  }
);

server.tool(
  "get_agent_dna",
  "Get full agent DNA (role, triggers, collaboration, frameworks) from the agent's markdown file.",
  {
    agent_name: z.string().describe("Agent name (e.g., 'enterprise-architect', 'security-analyst', 'content-strategist')"),
  },
  async ({ agent_name }) => {
    const agentDirs = ["orchestrators", "ceo", "cto", "cmo", "cso", "cpo", "coo", "cino"];
    for (const dir of agentDirs) {
      const content = await safeRead(join(MXM_ROOT, "agents/Maxim", dir, `${agent_name}.md`));
      if (content) return { content: [{ type: "text", text: content }] };
    }
    const rootContent = await safeRead(join(MXM_ROOT, "agents/Maxim", `${agent_name}.md`));
    if (rootContent) return { content: [{ type: "text", text: rootContent }] };
    return { content: [{ type: "text", text: `Agent "${agent_name}" not found in agents/MXM/` }] };
  }
);

server.tool(
  "list_offices",
  "List all 7 Maxim executive offices with leads, agent counts, and skill domains.",
  {},
  async () => {
    const offices = Object.entries(OFFICES).map(([key, config]) => ({
      office: key,
      name: config.name,
      lead: config.lead,
      agent_count: config.agents.length,
      skill_domains: config.skill_domains,
    }));
    return { content: [{ type: "text", text: JSON.stringify(offices, null, 2) }] };
  }
);

server.tool(
  "get_handoff_chain",
  "Get the full agent handoff chain for a task: planner → implementer → reviewer → tester → release-manager.",
  {
    task: z.string().describe("Description of the task to plan the handoff chain for"),
  },
  async ({ task }) => {
    const routing = routeTask(task);
    const chain = {
      task,
      routing,
      handoff_chain: [
        { phase: "Planning", agent: "planner", role: "Break down task, create plan, identify risks" },
        { phase: "Implementation", agent: routing.lead_agent || "implementer", role: "Execute the plan, write code/content" },
        { phase: "Review", agent: "reviewer", role: "Quality check, code review, standards compliance" },
        { phase: "Testing", agent: "tester", role: "Verify correctness, edge cases, regression" },
        { phase: "Release", agent: "release-manager", role: "Version bump, changelog, deploy" },
      ],
      specialist_agents: routing.office ? OFFICES[routing.office]?.agents || [] : [],
    };
    return { content: [{ type: "text", text: JSON.stringify(chain, null, 2) }] };
  }
);

// ——— Skill / command catalog (ex-skills) ———

server.tool(
  "list_skills",
  "List all Maxim skill domains with metadata. Optionally filter by domain name.",
  {
    domain: z.string().optional().describe("Filter by domain name (substring match)"),
  },
  async ({ domain }) => {
    const catalog = await loadSkillCatalog();
    const filtered = domain
      ? catalog.filter((s) => s.domain.includes(domain) || s.name.toLowerCase().includes(domain.toLowerCase()))
      : catalog;
    return {
      content: [{ type: "text", text: JSON.stringify({ total_domains: filtered.length, skills: filtered }, null, 2) }],
    };
  }
);

server.tool(
  "search_skills",
  "Search skills by trigger keywords. Returns skills that match the query against their trigger words, tags, and frameworks.",
  {
    query: z.string().describe("Search query to match against skill triggers, tags, and frameworks"),
  },
  async ({ query }) => {
    const catalog = await loadSkillCatalog();
    const queryLower = query.toLowerCase();
    const matches = catalog
      .map((skill) => {
        let score = 0;
        for (const t of skill.triggers || []) if (typeof t === "string" && t.toLowerCase().includes(queryLower)) score += 3;
        for (const t of skill.tags || []) if (typeof t === "string" && t.toLowerCase().includes(queryLower)) score += 2;
        for (const f of skill.frameworks || []) if (typeof f === "string" && f.toLowerCase().includes(queryLower)) score += 1;
        if (skill.name.toLowerCase().includes(queryLower)) score += 2;
        if (skill.domain.includes(queryLower)) score += 2;
        return { ...skill, relevance: score };
      })
      .filter((s) => s.relevance > 0)
      .sort((a, b) => b.relevance - a.relevance);
    return {
      content: [{ type: "text", text: JSON.stringify({ query, matches: matches.length, skills: matches }, null, 2) }],
    };
  }
);

server.tool(
  "get_skill_detail",
  "Get full SKILL.md content for a specific skill domain.",
  {
    skill_id: z.string().describe("Skill domain name (e.g., 'marketing', 'compliance', 'engineering', 'proactive-watch')"),
  },
  async ({ skill_id }) => {
    const content = await safeRead(join(MXM_ROOT, ".claude/skills", skill_id, "SKILL.md"));
    if (!content) {
      return { content: [{ type: "text", text: `Skill "${skill_id}" not found. Use list_skills to see available domains.` }] };
    }
    return { content: [{ type: "text", text: content }] };
  }
);

server.tool(
  "list_commands",
  "List all Maxim slash commands (/mxm-*) with their descriptions.",
  {},
  async () => {
    const cmdDir = join(MXM_ROOT, ".claude/commands");
    try {
      const files = await readdir(cmdDir);
      const commands = [];
      for (const file of files.filter((f) => f.endsWith(".md"))) {
        const content = await safeRead(join(cmdDir, file));
        const name = "/" + file.replace(".md", "");
        let description = "";
        if (content) {
          const lines = content.split("\n");
          for (const line of lines) {
            const trimmed = line.trim();
            if (trimmed && !trimmed.startsWith("#") && !trimmed.startsWith("---") && !trimmed.startsWith(">")) {
              description = trimmed.substring(0, 120);
              break;
            }
          }
        }
        commands.push({ command: name, description });
      }
      return { content: [{ type: "text", text: JSON.stringify({ total: commands.length, commands }, null, 2) }] };
    } catch {
      return { content: [{ type: "text", text: "Commands directory not found." }] };
    }
  }
);

// ——— Start ———

const transport = new StdioServerTransport();
await server.connect(transport);
