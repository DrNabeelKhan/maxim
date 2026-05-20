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
import { join, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { wrapServerWithLicenseGate } from "../_shared/license-gate.mjs";

// MXM_ROOT auto-detection (v1.2.0.5 fix for catalog drift):
// server.js lives at <plugin_root>/mcp/mxm-catalog/server.js, so the plugin
// root is two directories up. Precedence:
//   1. explicit MXM_ROOT env var (operator override)
//   2. CLAUDE_PLUGIN_ROOT env var (Claude Code sets this automatically)
//   3. derived from this file's location (always works regardless of CWD)
const __dirname = dirname(fileURLToPath(import.meta.url));
const MXM_ROOT = process.env.MXM_ROOT
  || process.env.CLAUDE_PLUGIN_ROOT
  || resolve(__dirname, "..", "..");

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

// OFFICES roster — synced to agents/MXM/ filesystem at v1.2.0 GA reorganization
// (WS1 nk-writer · WS5 deprecations + CSO 9→19 · CINO +4 · orchestrators +5).
// Updated v1.2.0.5 to fix pre-existing catalog drift documented in ADR-017.
// Lead agents are listed in agents[] explicitly (was implicit before — get_agent_dna
// would fail on leads if MCP roster diverged from filesystem).
const OFFICES = {
  ceo: {
    name: "CEO Office",
    lead: "enterprise-architect",
    keywords: ["strategy", "vision", "finance", "partnerships", "enterprise", "architecture", "investor", "business model", "governance", "negotiation", "pitch", "deck", "wardley", "togaf", "c4", "adr", "moat", "competitive"],
    agents: ["enterprise-architect", "business-architect", "financial-modeler", "governance-specialist", "influence-strategist", "investor-pitch-writer", "negotiation-specialist", "partnership-manager", "studio-producer"],
    skill_domains: ["enterprise-architecture", "studio-operations"],
  },
  cto: {
    name: "CTO Office",
    lead: "implementer",
    keywords: ["engineering", "code", "build", "deploy", "api", "database", "infrastructure", "devops", "cloud", "backend", "frontend", "ai", "ml", "data", "test", "performance", "security architecture", "schema", "auth", "docker", "rls", "mvp", "scaffold", "migrate", "pipeline", "supabase", "fastapi", "nextjs", "react", "typescript", "python", "node", "rag", "prompt"],
    agents: ["implementer", "ai-engineer", "api-integrator", "backend-architect", "data-architect", "data-scientist", "database-optimizer", "dependency-auditor", "devops-automator", "frontend-developer", "infrastructure-maintainer", "mobile-app-builder", "performance-engineer", "prompt-engineer", "rag-specialist", "security-architect", "technology-architect", "training-data-curator"],
    skill_domains: ["engineering", "testing", "ai-media-generation"],
  },
  cmo: {
    name: "CMO Office",
    lead: "content-strategist",
    keywords: ["marketing", "brand", "content", "seo", "conversion", "copy", "email", "growth", "campaign", "landing page", "social media", "ads", "persuasion", "behavioral", "video", "animation", "cinematic", "draft", "write", "compose", "post", "blog", "memo", "message", "whatsapp", "slack", "linkedin", "twitter", "newsletter", "tutorial", "doc", "readme", "proposal", "summary", "status report", "voice", "tone"],
    agents: ["content-strategist", "nk-writer", "behavioral-designer", "brand-guardian", "conversion-optimizer", "documentation-writer", "email-campaign-writer", "growth-hacker", "gtm-strategist", "persuasion-specialist", "seo-specialist"],
    skill_domains: ["marketing", "content-creation", "search-visibility", "behavior-science-persuasion", "brand", "banner-design", "ai-media-generation"],
  },
  cso: {
    name: "CSO Office",
    lead: "security-analyst",
    keywords: ["security", "compliance", "privacy", "ethics", "threat", "vulnerability", "incident", "audit", "gdpr", "pipeda", "pci", "hipaa", "soc2", "iso 27001", "nist", "owasp", "stride", "pasta", "linddun", "penetration", "risk", "dpia", "sbom", "aibom", "ai risk", "regulated", "phi", "pii", "payment"],
    agents: ["security-analyst", "ai-ethics-reviewer", "appsec-engineer", "compliance-officer", "data-privacy-officer", "dpia-specialist", "gdpr-counsel", "hipaa-counsel", "incident-post-mortem-writer", "incident-responder", "iso27001-lead-auditor", "legal-compliance-checker", "llm-security-specialist", "owasp-specialist", "penetration-tester", "sbom-analyst", "secure-code-reviewer", "soc2-auditor", "threat-modeler"],
    skill_domains: ["security", "compliance"],
  },
  cpo: {
    name: "CPO Office",
    lead: "product-strategist",
    keywords: ["product", "ux", "ui", "user research", "feedback", "roadmap", "feature", "persona", "pricing", "accessibility", "onboarding", "design", "prd", "user story", "okr", "rice", "jtbd", "jobs to be done", "wcag"],
    agents: ["product-strategist", "accessibility-auditor", "feedback-synthesizer", "onboarding-designer", "pricing-strategist", "product-manager", "ui-ux-designer", "ux-researcher"],
    skill_domains: ["product", "design", "design-system", "ui-styling", "slides", "ui-ux-pro-max", "design-resources"],
  },
  coo: {
    name: "COO Office",
    lead: "planner",
    keywords: ["operations", "delivery", "support", "sprint", "project", "plan", "schedule", "workflow", "experiment", "changelog", "phase", "milestone", "release", "organize", "cleanup", "watch", "drift", "audit", "health", "sre", "slo", "sli", "error budget", "post-mortem"],
    agents: ["planner", "changelog-writer", "customer-success-manager", "experiment-tracker", "project-shipper", "sprint-prioritizer", "sre-analyst", "support-responder", "workflow-optimizer"],
    skill_domains: ["project-management", "studio-operations", "proactive-watch"],
  },
  cino: {
    name: "CINO Office",
    lead: "innovation-researcher",
    keywords: ["innovation", "r&d", "emerging", "horizon", "research", "prototype", "experiment", "novel", "tech radar", "competitive intel", "patent", "ip landscape", "cost analysis", "weak signal"],
    agents: ["innovation-researcher", "competitive-intel-analyst", "cost-analyst", "horizon-scanner", "patent-researcher", "rd-coordinator", "skill-synthesizer", "tech-radar-author"],
    skill_domains: ["product-development-research"],
  },
};

// ──────────────────────────────────────────────────────────────────────────────
// L2 specialist descent (v1.2.0.6) — per-specialist trigger keywords
// ──────────────────────────────────────────────────────────────────────────────
//
// route_task previously stopped at the office level and returned the lead_agent
// as the default specialist. That collapses delegation chains documented in
// each specialist's DNA (e.g., ADR-016: content-strategist delegates writing
// production to nk-writer).
//
// SPECIALISTS maps each specialist to its own trigger keywords. After office
// classification wins, we score specialists within that office. The highest-
// scoring specialist becomes the dispatch target; office lead is the fallback
// if no specialist signal beats the lead's baseline.
//
// requires_specialist_classification: true marks specialists that have their
// own internal classification step beyond keyword matching (e.g., nk-writer
// classifies against VOICE_SELECTION.md's 22 content types). Downstream
// callers should not treat HIGH route_task confidence as final — they must
// invoke the specialist for L3 classification.

const SPECIALISTS = {
  cmo: {
    "nk-writer": {
      keywords: ["draft", "write", "compose", "post", "blog", "memo", "message", "whatsapp", "slack", "email", "linkedin", "twitter", "newsletter", "tutorial", "doc", "readme", "proposal", "summary", "status report", "voice"],
      priority: 2, // higher priority than email-campaign-writer for ambiguous "email"
      requires_specialist_classification: true,
      classification_authority: "myVoiceDNA/VOICE_SELECTION.md",
      negative_trigger: "active_startup + customer-facing → routes to {active_startup}-brand-writer instead",
      adr: "ADR-016",
    },
    "brand-guardian": {
      keywords: ["brand consistency", "brand drift", "voice audit", "brand check", "brand guardian"],
      priority: 1,
    },
    "seo-specialist": {
      keywords: ["seo", "aeo", "keyword", "search visibility", "search intent"],
      priority: 1,
    },
    "conversion-optimizer": {
      keywords: ["conversion", "cro", "landing page", "funnel"],
      priority: 1,
    },
    "persuasion-specialist": {
      keywords: ["persuasion", "cialdini", "scarcity", "social proof", "reciprocity"],
      priority: 1,
    },
    "behavioral-designer": {
      keywords: ["behavioral overlay", "fogg", "com-b", "east", "hook model", "nudge"],
      priority: 1,
    },
    "email-campaign-writer": {
      keywords: ["email campaign", "email sequence", "nurture sequence", "drip campaign"],
      priority: 1,
    },
    "gtm-strategist": {
      keywords: ["gtm", "go to market", "launch plan", "positioning"],
      priority: 1,
    },
    "growth-hacker": {
      keywords: ["growth hack", "viral", "growth experiment", "k-factor"],
      priority: 1,
    },
    "documentation-writer": {
      keywords: ["technical writing", "developer doc", "api reference"],
      priority: 1,
    },
    // notebooklm-py for CMO content production (v1.2.1.0 · ADR-018)
    "notebooklm-content-production": {
      keywords: ["create a podcast", "generate audio overview", "video explainer about", "generate infographic", "audio overview for our team", "video overview about", "team podcast"],
      priority: 2,
      requires_specialist_classification: true,
      mcp_server: "mxm-notebooklm",
      adr: "ADR-018",
      skill: ".claude/skills/notebooklm-py",
    },
  },
  cso: {
    "threat-modeler": { keywords: ["threat model", "stride", "pasta", "linddun"], priority: 1 },
    "penetration-tester": { keywords: ["pen test", "penetration test", "red team", "vuln scan"], priority: 1 },
    "owasp-specialist": { keywords: ["owasp", "top 10", "llm top 10", "api top 10"], priority: 1 },
    "llm-security-specialist": { keywords: ["prompt injection", "jailbreak", "llm security", "ai risk"], priority: 1 },
    "appsec-engineer": { keywords: ["appsec", "application security", "auth", "session"], priority: 1 },
    "secure-code-reviewer": { keywords: ["secure code review", "code review security"], priority: 1 },
    "sbom-analyst": { keywords: ["sbom", "cyclonedx", "spdx", "aibom", "ai bom"], priority: 1 },
    "dpia-specialist": { keywords: ["dpia", "privacy impact"], priority: 1 },
    "gdpr-counsel": { keywords: ["gdpr"], priority: 1 },
    "hipaa-counsel": { keywords: ["hipaa", "phi"], priority: 1 },
    "soc2-auditor": { keywords: ["soc2", "soc 2"], priority: 1 },
    "iso27001-lead-auditor": { keywords: ["iso 27001", "iso27001"], priority: 1 },
    "ai-ethics-reviewer": { keywords: ["ai ethics", "nist ai rmf", "mitre atlas"], priority: 1 },
    "incident-responder": { keywords: ["incident response", "live incident", "containment"], priority: 1 },
    "incident-post-mortem-writer": { keywords: ["post-mortem", "post mortem", "blameless retro"], priority: 1 },
    "compliance-officer": { keywords: ["compliance posture", "compliance officer"], priority: 1 },
    "data-privacy-officer": { keywords: ["data privacy officer", "dpo"], priority: 1 },
    "legal-compliance-checker": { keywords: ["legal compliance", "contract clause", "regulatory"], priority: 1 },
  },
  ceo: {
    "investor-pitch-writer": { keywords: ["pitch deck", "investor deck", "fundraising", "raise"], priority: 1 },
    "financial-modeler": { keywords: ["financial model", "runway", "pricing math", "cap table"], priority: 1 },
    "partnership-manager": { keywords: ["partnership", "channel deal", "alliance"], priority: 1 },
    "negotiation-specialist": { keywords: ["negotiation", "term sheet", "counter offer"], priority: 1 },
    "governance-specialist": { keywords: ["governance", "board", "compliance posture board"], priority: 1 },
    "influence-strategist": { keywords: ["influence", "executive comm", "positioning ceo"], priority: 1 },
    "business-architect": { keywords: ["business architecture", "org design", "operating model"], priority: 1 },
    "studio-producer": { keywords: ["studio producer", "agency coordination"], priority: 1 },
  },
  cto: {
    "frontend-developer": { keywords: ["frontend", "react", "css", "ui component"], priority: 1 },
    "backend-architect": { keywords: ["backend", "api design", "service architecture"], priority: 1 },
    "database-optimizer": { keywords: ["database", "sql", "index", "query optimization"], priority: 1 },
    "data-architect": { keywords: ["data architecture", "pipeline", "warehouse", "etl"], priority: 1 },
    "data-scientist": { keywords: ["data science", "ml training", "model eval"], priority: 1 },
    "ai-engineer": { keywords: ["ai engineering", "agent framework", "inference"], priority: 1 },
    "prompt-engineer": { keywords: ["prompt engineering", "system prompt"], priority: 1 },
    "rag-specialist": { keywords: ["rag", "retrieval", "embedding store", "vector store"], priority: 1 },
    "devops-automator": { keywords: ["devops", "ci/cd", "deploy automation"], priority: 1 },
    "infrastructure-maintainer": { keywords: ["infrastructure", "cloud iam", "cost optimization"], priority: 1 },
    "performance-engineer": { keywords: ["performance profiling", "latency", "throughput"], priority: 1 },
    "mobile-app-builder": { keywords: ["mobile app", "ios", "android"], priority: 1 },
    "dependency-auditor": { keywords: ["dependency audit", "supply chain"], priority: 1 },
    "security-architect": { keywords: ["security architecture", "secure by design"], priority: 1 },
    "api-integrator": { keywords: ["api integration", "webhook", "sdk integration"], priority: 1 },
    "technology-architect": { keywords: ["tech stack architecture", "framework choice"], priority: 1 },
    "training-data-curator": { keywords: ["training data", "dataset prep"], priority: 1 },
  },
  cpo: {
    "pricing-strategist": { keywords: ["pricing strategy", "van westendorp", "tier design"], priority: 1 },
    "product-manager": { keywords: ["prd", "user story", "okr", "rice", "backlog"], priority: 1 },
    "ux-researcher": { keywords: ["ux research", "user interview", "survey synthesis"], priority: 1 },
    "feedback-synthesizer": { keywords: ["feedback synthesis", "nps", "theme extraction"], priority: 1 },
    "onboarding-designer": { keywords: ["onboarding", "activation", "aha moment"], priority: 1 },
    "ui-ux-designer": { keywords: ["ui ux design", "fitts", "hick", "gestalt"], priority: 1 },
    "accessibility-auditor": { keywords: ["accessibility", "wcag", "a11y"], priority: 1 },
    // notebooklm-py for CPO learning artifacts (v1.2.1.0 · ADR-018)
    "notebooklm-learning-artifacts": {
      keywords: ["quiz from these sources", "flashcards for", "study guide from", "training material from", "onboarding quiz", "interactive learning module"],
      priority: 2,
      requires_specialist_classification: true,
      mcp_server: "mxm-notebooklm",
      adr: "ADR-018",
      skill: ".claude/skills/notebooklm-py",
    },
  },
  coo: {
    "sprint-prioritizer": { keywords: ["sprint", "backlog grooming"], priority: 1 },
    "project-shipper": { keywords: ["ship", "release", "deploy coordination"], priority: 1 },
    "sre-analyst": { keywords: ["sre", "slo", "sli", "error budget"], priority: 1 },
    "support-responder": { keywords: ["support", "ticket", "runbook"], priority: 1 },
    "customer-success-manager": { keywords: ["customer success", "retention", "health score"], priority: 1 },
    "experiment-tracker": { keywords: ["experiment design", "a/b test", "hypothesis"], priority: 1 },
    "workflow-optimizer": { keywords: ["workflow optimization", "process redesign"], priority: 1 },
    "changelog-writer": { keywords: ["changelog", "release note"], priority: 1 },
  },
  cino: {
    "tech-radar-author": { keywords: ["tech radar", "technology radar", "adoption matrix"], priority: 1 },
    "competitive-intel-analyst": { keywords: ["competitive intel", "competitor teardown", "moat analysis"], priority: 1 },
    "patent-researcher": { keywords: ["patent research", "ip landscape", "patent search"], priority: 1 },
    "horizon-scanner": { keywords: ["horizon scan", "weak signal", "emerging tech"], priority: 1 },
    "cost-analyst": { keywords: ["cost analysis", "vendor pricing", "tco"], priority: 1 },
    "rd-coordinator": { keywords: ["r&d coordination", "experiment portfolio"], priority: 1 },
    "skill-synthesizer": { keywords: ["skill domain creation", "framework synthesis"], priority: 1 },
    // notebooklm-py integration (v1.2.1.0 · ADR-018) — research synthesis via mxm-notebooklm MCP
    "notebooklm-research": {
      keywords: ["notebooklm", "notebook lm", "summarize these urls", "summarize these sources", "synthesize these papers", "knowledge synthesis", "research synthesis", "deep research", "audio overview", "podcast about", "audio podcast", "mind map of", "knowledge map"],
      priority: 2,
      requires_specialist_classification: true,
      classification_authority: "mxm-notebooklm MCP (38 tools)",
      mcp_server: "mxm-notebooklm",
      adr: "ADR-018",
      skill: ".claude/skills/notebooklm-py",
      upstream: "teng-lin/notebooklm-py (MIT)",
      fragility_disclosure: "wraps undocumented Google API; see ADR-018 § Mandatory Disclosure",
    },
  },
};

// Descend from office → specialist using SPECIALISTS keyword scoring.
// Returns { specialist, specialist_score, requires_specialist_classification, ... }
function descendToSpecialist(office, taskLower) {
  const officeSpecialists = SPECIALISTS[office] || {};
  let best = null;
  let bestScore = 0;
  for (const [name, config] of Object.entries(officeSpecialists)) {
    let score = 0;
    for (const kw of config.keywords) {
      if (taskLower.includes(kw)) score += 2 * (config.priority || 1);
    }
    if (score > bestScore) {
      bestScore = score;
      best = { name, ...config, score };
    }
  }
  return best; // may be null if no specialist signal — caller defaults to office lead
}

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

  // L2 descent — try to identify a more specific specialist than the office lead
  const specialistMatch = descendToSpecialist(best[0], taskLower);
  const specialist = specialistMatch?.name || officeConfig.lead;
  const isLead = specialist === officeConfig.lead;

  // Confidence rubric:
  // HIGH = strong office signal AND clear specialist match (descent succeeded with score >= 2)
  // MEDIUM = office signal but specialist defaulted to lead OR descent score < 2
  // LOW = weak office signal (< 3)
  let confidence;
  if (best[1] >= 6 && specialistMatch && specialistMatch.score >= 2) confidence = "HIGH";
  else if (best[1] >= 3) confidence = "MEDIUM";
  else confidence = "LOW";

  return {
    office: best[0],
    office_name: officeConfig.name,
    lead_agent: officeConfig.lead,
    specialist,
    specialist_is_lead: isLead,
    requires_specialist_classification: specialistMatch?.requires_specialist_classification || false,
    classification_authority: specialistMatch?.classification_authority || null,
    negative_trigger: specialistMatch?.negative_trigger || null,
    adr: specialistMatch?.adr || null,
    skill_domains: officeConfig.skill_domains,
    confidence,
    score: best[1],
    specialist_score: specialistMatch?.score || 0,
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

// v1.1.A — license gate (fail-closed at JWT expiry; owner.key bypass; first-run silent issue)
wrapServerWithLicenseGate(server, "mxm-catalog");

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
      const content = await safeRead(join(MXM_ROOT, "agents/MXM", dir, `${agent_name}.md`));
      if (content) return { content: [{ type: "text", text: content }] };
    }
    const rootContent = await safeRead(join(MXM_ROOT, "agents/MXM", `${agent_name}.md`));
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
