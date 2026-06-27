#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-commands — MCP Server (v1.2.0)
 *
 * Slash-command dispatcher. Exposes Maxim's 50 /mxm-* slash commands as a
 * callable MCP tool surface. Provides command parity in Claude Desktop /
 * Claude.ai Web where native slash commands don't exist.
 *
 * 2 tools:
 *   - mxm_command(command, args?)  Look up routing decision for a slash command
 *   - list_commands()              List all 50 commands grouped by tier
 *
 * This server is INFORMATIONAL — it returns the routing decision (which office,
 * which agents, which framework, which behavioral overlay) so the calling LLM
 * can execute the decision via its other tool surfaces. It does NOT directly
 * invoke other MCPs or hooks.
 *
 * Designed for v1.2.0.1 to close the slash-command gap in Desktop + Web.
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// ──────────────────────────────────────────────────────────────────────────────
// Command routing table — 50 commands per AGENT_SKILL_INVENTORY v1.3.8.4
// ──────────────────────────────────────────────────────────────────────────────

const COMMANDS = {
  // ─────────── TIER 1 — Verb-First (v1.2.0+) ───────────
  "mxm-build": {
    tier: 1,
    intent: "Build a feature, module, or capability",
    primary_office: "CTO",
    lead_agent: "implementer",
    auto_loops: [
      "CSO security-analyst (on regulated data signals)",
      "CPO product-strategist (on frontend signals)",
      "COO planner (on scope > 1 dev-day)",
    ],
    frameworks: ["Fogg B=MAP scope check (BLOCKING)", "TDD discipline", "ADR-010 confidence tag"],
    chains_to: ["/mxm-test", "/mxm-review"],
  },
  "mxm-fix": {
    tier: 1,
    intent: "Fix a bug, failing test, or regression",
    primary_office: "CTO",
    lead_agent: "implementer + tester + reviewer (coordinated parallel)",
    auto_loops: [
      "CSO security-analyst (auth/payment/credential/PII bugs)",
      "COO sre-analyst (prod incidents)",
      "CMO documentation-writer (doc-vs-code mismatch)",
    ],
    frameworks: ["Systematic Debugging (reproduce → bisect → isolate → hypothesize → fix → regression-guard)", "Root-cause discipline", "ADR-010 confidence tag"],
    writes: ["BUG_TRACKER.md", "DEBUGGING_PLAYBOOK.md (if new failure pattern)"],
  },
  "mxm-ship": {
    tier: 1,
    intent: "Cut a release, publish, or deploy",
    primary_office: "COO",
    lead_agent: "planner (coordinator) → release-manager",
    auto_loops: [
      "CSO security-analyst (SBOM, secret/PII scan, license-gate)",
      "Orchestrators reviewer (final pass)",
      "CMO documentation-writer (CHANGELOG draft)",
      "COO planner (session-end 9-doc bundle)",
    ],
    frameworks: ["Session-end 9-document closure bundle (ADR-002)", "SBOM check (per ADR-012)", "ADR-010 confidence tag"],
    chains_to: ["/mxm-release"],
  },
  "mxm-plan": {
    tier: 1,
    intent: "Plan a sprint, feature, or migration",
    primary_office: "COO",
    lead_agent: "planner",
    auto_loops: ["CPO product-strategist (feature planning)", "Framework selector (Fogg / COM-B / EAST / SCQA / Minto)"],
    frameworks: ["Planning-with-Files", "Coverage Matrix appendix (sprint plans)", "Fogg B=MAP scope check"],
    chains_to: ["/mxm-implement", "/mxm-build"],
  },
  "mxm-review": {
    tier: 1,
    intent: "Review code, PR, doc, or skill",
    primary_office: "Orchestrators",
    lead_agent: "reviewer",
    auto_loops: [
      "CSO security-analyst (security-adjacent code)",
      "Orchestrators tester (test code)",
      "CMO brand-guardian (SKILL/agent/doc)",
      "CSO compliance skill (regulated scope)",
    ],
    frameworks: ["ADR-007 framework citation requirement", "Root-cause discipline", "ADR-conformance check"],
  },
  "mxm-explain": {
    tier: 1,
    intent: "Explain code, concept, framework, or system",
    primary_office: "Router (smart-explorer + topic-owning office)",
    lead_agent: "smart-explorer (tree-sitter AST) + routed office expert",
    auto_loops: ["Topic-owning office (CEO/CTO/CMO/CSO/CPO/COO/CINO) per subject domain"],
    frameworks: ["ADR-010 plain-language confidence tag (grounding-depth rubric)", "Source citation requirement"],
  },
  "mxm-help": {
    tier: 1,
    intent: "What can I do here?",
    primary_office: "(meta) Help system dispatcher",
    lead_agent: "help-system skill",
    modes: [
      "(no-arg) auto-detect persona from project-manifest.json → quick-start",
      "<persona> persona quick-start (legal/arch/secure/founder/pm)",
      "commands — full 3-tier catalog",
      "agents — 91-agent roster",
      "frameworks [<id>] — catalog + deep-dive",
      "compliance — project-specific map",
      "moat — opinionated differentiation",
      "getting-started — 5-min onboarding",
    ],
    frameworks: ["Fogg B=MAP (reduce decision friction)", "COM-B (capability + opportunity)", "Persona cache at .mxm-skills/operator-persona.txt"],
  },

  // ─────────── TIER 2 — Office shortcuts ───────────
  "mxm-ceo": { tier: 2, intent: "Activate CEO office", primary_office: "CEO", lead_agent: "enterprise-architect", domain: "Strategy · finance · partnerships · enterprise architecture" },
  "mxm-cto": { tier: 2, intent: "Activate CTO office", primary_office: "CTO", lead_agent: "implementer", domain: "Engineering · infrastructure · AI · APIs · DevOps · cloud" },
  "mxm-cmo": { tier: 2, intent: "Activate CMO office", primary_office: "CMO", lead_agent: "content-strategist", domain: "Marketing · brand · content · SEO · conversion · voice-routed writing (nk-writer)" },
  "mxm-cso": { tier: 2, intent: "Activate CSO office", primary_office: "CSO", lead_agent: "security-analyst", domain: "Security · compliance · privacy · ethics · risk · incidents (auto-loop on regulated data)" },
  "mxm-cpo": { tier: 2, intent: "Activate CPO office", primary_office: "CPO", lead_agent: "product-strategist", domain: "Product strategy · UX · UI · research · pricing" },
  "mxm-coo": { tier: 2, intent: "Activate COO office", primary_office: "COO", lead_agent: "planner", domain: "Operations · delivery · sprints · support · experiments" },
  "mxm-cino": { tier: 2, intent: "Activate CINO office", primary_office: "CINO", lead_agent: "innovation-researcher", domain: "Innovation · R&D · emerging tech · horizon scanning" },
  "mxm-route": { tier: 2, intent: "Auto-route ambiguous task", primary_office: "Router", lead_agent: "executive-router", note: "Use when unsure which office owns the task" },
  "mxm-ceo-morning": { tier: 2, intent: "CEO morning cycle", primary_office: "CEO", lead_agent: "enterprise-architect", note: "Metrics · burn rate · pipeline · health scan" },
  "mxm-ceo-overnight": { tier: 2, intent: "CEO overnight cycle", primary_office: "CEO", lead_agent: "enterprise-architect", note: "Strategy · growth · content · bottlenecks" },
  "mxm-ceo-setup": { tier: 2, intent: "Set up CEO automation", primary_office: "CEO", lead_agent: "enterprise-architect", note: "30 templates + .mxm-executive-summary/" },

  // ─────────── TIER 3 — Persona dispatchers (v1.2.0+) ───────────
  "mxm-legal": {
    tier: 3,
    intent: "Legal / in-house counsel / GRC persona",
    primary_office: "CSO + compliance skill",
    lead_agent: "security-analyst (routes to gdpr-counsel · hipaa-counsel · soc2-auditor · iso27001-lead-auditor · dpia-specialist · etc.)",
    sub_commands: ["jurisdictional-map", "privacy-impact (full DPIA template)", "contract-review", "vendor-dpa", "regulatory-map"],
    frameworks: ["14 compliance frameworks with jurisdictional logic", "GDPR Article-grounded citations", "EDPB guidelines", "LINDDUN privacy threat modeling"],
  },
  "mxm-arch": {
    tier: 3,
    intent: "Enterprise architect persona",
    primary_office: "CEO",
    lead_agent: "enterprise-architect",
    sub_commands: ["capability-map (TOGAF)", "wardley-map (Wardley Mapping — native)", "tech-radar (ThoughtWorks)", "c4-diagram", "adr (Maxim ADR-001 template)", "vendor-eval"],
    frameworks: ["TOGAF 10", "Wardley Mapping", "C4 Model (Brown)", "arc42", "ThoughtWorks Tech Radar", "ADR-002 Executable Contracts"],
  },
  "mxm-secure": {
    tier: 3,
    intent: "CISO / AppSec / GRC / threat modeler persona",
    primary_office: "CSO",
    lead_agent: "security-analyst (routes to threat-modeler · owasp-specialist · appsec-engineer · sbom-analyst · ai-risk-auditor · etc.)",
    sub_commands: ["threat-model (STRIDE+LINDDUN+PASTA)", "owasp (Top 10 + LLM Top 10 + API Top 10 — triple coverage)", "sbom (SPDX 3.0 + CycloneDX + AIBOM for EU AI Act Art. 53)", "incident (NIST CSF + MITRE ATT&CK)", "compliance-posture", "ai-risk (NIST AI RMF + MITRE ATLAS)"],
    frameworks: ["STRIDE", "PASTA", "LINDDUN", "OWASP Top 10:2021 + LLM Top 10 + API Top 10", "NIST CSF", "NIST AI RMF", "MITRE ATLAS", "Constitutional AI"],
  },
  "mxm-founder": {
    tier: 3,
    intent: "Early-stage founder persona",
    primary_office: "CEO + CMO + CPO",
    lead_agent: "enterprise-architect + growth-hacker + product-strategist + (pricing-strategist after WS5)",
    sub_commands: ["pitch-deck (Duarte+Minto+McKinsey+Dual Coding)", "gtm-plan (AARRR + first-100 + JTBD)", "runway-model", "pricing (Prospect Theory + Van Westendorp PSM + Cialdini anchoring)", "business-model-canvas (Strategyzer)", "competitive-moat (reads MOAT_TRACKER.md live + 7 Powers framework)"],
    frameworks: ["Duarte Sparkline", "Minto Pyramid", "McKinsey Slide Logic", "Dual Coding Theory", "AARRR (Pirate Metrics)", "Prospect Theory", "Van Westendorp PSM", "Strategyzer BMC + VPC", "Hamilton Helmer 7 Powers"],
  },
  "mxm-pm": {
    tier: 3,
    intent: "Product manager persona",
    primary_office: "CPO",
    lead_agent: "product-strategist",
    sub_commands: ["prd (10-section PRD with leading+lagging+counter metrics)", "user-story (INVEST + Gherkin acceptance criteria + auto-split)", "okr (forces BOTH leading AND lagging KRs)", "prioritize (RICE + ICE + Kano + WSJF)", "jtbd (Tony Ulwick's Jobs Atlas + 8-step job map)"],
    frameworks: ["INVEST", "Gherkin BDD", "OKR with leading+lagging", "RICE", "ICE", "Kano Model", "WSJF", "Tony Ulwick's Jobs Atlas"],
  },

  // ─────────── Domain & workflow commands ───────────
  "mxm-behavior": { tier: "domain", intent: "Behavioral science / persuasion dispatch", primary_office: "CMO", lead_agent: "behavioral-designer", frameworks: ["64 behavioral frameworks via FRAMEWORKS_MASTER.md"] },
  "mxm-brand-voice": { tier: "domain", intent: "Brand voice management (3-layer)", primary_office: "CMO", lead_agent: "brand-guardian", note: "Maxim base + operator overlay + per-startup overlay" },
  "mxm-compliance": { tier: "domain", intent: "Compliance check across 14 frameworks", primary_office: "CSO", lead_agent: "security-analyst + compliance skill" },
  "mxm-context": { tier: "domain", intent: "Project context loader", primary_office: "Router", lead_agent: "executive-router", note: "Used by /mxm-status, /mxm-health, cross-surface packing" },
  "mxm-design": { tier: "domain", intent: "Full design team (UX + UI + brand + behavioral)", primary_office: "CPO + CMO", lead_agent: "ui-ux-designer + brand-guardian" },
  "mxm-health": { tier: "domain", intent: "Project health dashboard (11 drift classes scanned)", primary_office: "Router", lead_agent: "proactive-watch skill" },
  "mxm-implement": { tier: "domain", intent: "Implementation mode (test-first, TDD)", primary_office: "CTO", lead_agent: "implementer", frameworks: ["TDD", "Superpowers TDD integration", "Commit Protocol"] },
  "mxm-new-project": { tier: "domain", intent: "Bootstrap new Maxim project", primary_office: "Router", lead_agent: "new-project bootstrap skill", note: "11-file scaffold + manifest" },
  "mxm-organize": { tier: "domain", intent: "Reorganize project files + documents", primary_office: "COO", lead_agent: "planner", note: "Dedupe + canonical-path enforcement" },
  "mxm-portfolio": { tier: "domain", intent: "Portfolio view across projects", primary_office: "CEO", lead_agent: "enterprise-architect", note: "Reads config/project-manifest.json across all registered projects" },
  "mxm-recall": { tier: "domain", intent: "Cross-session memory recall (MemPalace)", primary_office: "Memory", lead_agent: "mempalace MCP" },
  "mxm-release": { tier: "domain", intent: "Ship a version (full /mxm-release flow)", primary_office: "Orchestrators", lead_agent: "release-manager", note: "8-bucket BLOCKING pre-release audit" },
  "mxm-remember": { tier: "domain", intent: "Write memory note to MemPalace", primary_office: "Memory", lead_agent: "mempalace MCP" },
  "mxm-security": { tier: "domain", intent: "Security audit (threat modeling + CSO auto-loop)", primary_office: "CSO", lead_agent: "security-analyst" },
  "mxm-self-update": { tier: "domain", intent: "Pull latest plugin version", primary_office: "Bootstrap", lead_agent: "bootstrap/mxm-self-update.{sh,ps1}" },
  "mxm-seo": { tier: "domain", intent: "Search visibility (Google + AI answers)", primary_office: "CMO", lead_agent: "seo-specialist" },
  "mxm-session-end": { tier: "domain", intent: "Named 9-document closure bundle", primary_office: "Orchestrators", lead_agent: "planner (COO)", note: "ADR-002 ratified ritual; offers /mxm-handoff at Phase 4" },
  "mxm-handoff": { tier: "domain", intent: "Generate a verify-first continuation handoff prompt (ADR-023)", primary_office: "COO", lead_agent: "planner (session-memory skill)", note: "Paste-into-a-fresh-window prompt; points to source-of-truth + forces verification (the files win) — never embeds stale counts/HEADs. Also Phase 4 of /mxm-session-end." },
  "mxm-status": { tier: "domain", intent: "Current session status (handoff + skill gaps + drift)", primary_office: "Router", lead_agent: "executive-router" },
  "mxm-superpowers": { tier: "domain", intent: "Advanced workflows (TDD + parallel agents + debugging)", primary_office: "Router", lead_agent: "superpowers community pack" },
  "mxm-tasks": { tier: "domain", intent: "Usage-aware scheduled tasks", primary_office: "COO", lead_agent: "planner", note: "Respects Claude usage limits per config/scheduler-thresholds.json" },
  "mxm-test": { tier: "domain", intent: "Testing mode (TDD + FIRST principles)", primary_office: "Orchestrators", lead_agent: "tester" },
  "mxm-update": { tier: "domain", intent: "Refresh AGENT_SKILL_INVENTORY.md (capability inventory only)", primary_office: "COO", lead_agent: "planner", note: "Narrower than /mxm-session-end" },
  "mxm-voice": { tier: "domain", intent: "Voice-driven office routing (Whisper STT + Kokoro TTS)", primary_office: "Router", lead_agent: "mxm-voice MCP", note: "Requires mbailey/voicemode plugin" },
  "mxm-watch": { tier: "domain", intent: "Proactive Watch (13 drift classes)", primary_office: "Router", lead_agent: "proactive-watch skill" },
  "mxm-wiki": { tier: "domain", intent: "Cross-project knowledge layer (MemPalace-backed)", primary_office: "Memory", lead_agent: "wiki-ingest + wiki-query + wiki-lint + wiki-explore skills" },
  "mxm-workflow": { tier: "domain", intent: "Autonomous workflow orchestration (ADR-022 Autonomous Workflow Standard)", primary_office: "Orchestrators", lead_agent: "orchestrator skill + orchestrator/engine.mjs", note: "Bounded autonomous multi-step runs — BudgetGuard hard-kill + StateStore + dead-letter + dry-run default" },
};

// ──────────────────────────────────────────────────────────────────────────────
// Server setup
// ──────────────────────────────────────────────────────────────────────────────

const server = new McpServer({
  name: "mxm-commands",
  version: "1.2.0",
});

server.tool(
  "mxm_command",
  "Look up the routing decision for a Maxim slash command. Returns office, lead agent, auto-loops, frameworks, behavioral overlay, and chaining info. Use to invoke Maxim's command surface from Claude Desktop / Claude.ai Web where native slash commands aren't available.",
  {
    command: z.string().describe("Slash command name with or without leading slash. Examples: 'mxm-build', '/mxm-legal', 'mxm-help'."),
    args: z.string().optional().describe("Arguments to the command. Example: 'a hello-world health check' for /mxm-build."),
  },
  async ({ command, args }) => {
    const key = command.replace(/^\//, "").toLowerCase();
    const route = COMMANDS[key];

    if (!route) {
      const suggestions = Object.keys(COMMANDS)
        .filter((c) => c.includes(key) || key.includes(c.replace("mxm-", "")))
        .slice(0, 5);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(
              {
                error: `Unknown Maxim command: ${command}`,
                hint: "Use list_commands to see all 50 commands.",
                did_you_mean: suggestions.length > 0 ? suggestions : undefined,
              },
              null,
              2
            ),
          },
        ],
      };
    }

    const response = {
      command: `/${key}`,
      args: args || null,
      tier: route.tier,
      intent: route.intent,
      routing: {
        primary_office: route.primary_office,
        lead_agent: route.lead_agent,
        auto_loops: route.auto_loops || [],
      },
      behavioral_overlay: {
        frameworks: route.frameworks || [],
        confidence_tag_rubric: "Every output must be tagged 🟢 HIGH | 🟡 MEDIUM | 🔴 LOW per ADR-010",
        framework_citation_requirement: "Every output must cite the framework justifying it per ADR-007",
      },
      sub_commands: route.sub_commands || null,
      modes: route.modes || null,
      chains_to: route.chains_to || null,
      writes: route.writes || null,
      note: route.note || null,
      domain: route.domain || null,
      execution_guidance:
        "This is a routing decision, not an execution. The calling LLM should now: (1) invoke the primary office's lead agent mentally, (2) fire any auto-loops by checking the corresponding signals in the task, (3) apply the listed behavioral frameworks to the output, (4) emit a confidence tag per ADR-010.",
    };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(response, null, 2),
        },
      ],
    };
  }
);

server.tool(
  "list_commands",
  "List all 50 Maxim slash commands grouped by tier (TIER 1 verb-first · TIER 2 office shortcuts · TIER 3 persona dispatchers · Domain & workflow). Returns each command's intent and primary office.",
  {
    tier: z.enum(["1", "2", "3", "domain", "all"]).optional().describe("Filter by tier. Default: 'all'."),
  },
  async ({ tier }) => {
    const filter = tier || "all";
    const grouped = { tier_1: [], tier_2: [], tier_3: [], domain: [] };

    for (const [name, route] of Object.entries(COMMANDS)) {
      const entry = {
        command: `/${name}`,
        intent: route.intent,
        primary_office: route.primary_office,
        lead_agent: route.lead_agent,
      };
      if (route.tier === 1) grouped.tier_1.push(entry);
      else if (route.tier === 2) grouped.tier_2.push(entry);
      else if (route.tier === 3) grouped.tier_3.push(entry);
      else grouped.domain.push(entry);
    }

    let output;
    if (filter === "all") output = grouped;
    else if (filter === "domain") output = { domain: grouped.domain };
    else output = { [`tier_${filter}`]: grouped[`tier_${filter}`] };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(
            {
              total:
                grouped.tier_1.length +
                grouped.tier_2.length +
                grouped.tier_3.length +
                grouped.domain.length,
              tier_1_verb_first: grouped.tier_1.length,
              tier_2_office: grouped.tier_2.length,
              tier_3_persona: grouped.tier_3.length,
              domain_workflow: grouped.domain.length,
              note:
                "TIER 1 commands are plain-English entry points. TIER 2 commands route directly to office leads. TIER 3 commands speak the persona's vocabulary (legal/arch/secure/founder/pm) and route invisibly to specialists. Domain commands are workflow utilities.",
              commands: output,
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

// ──────────────────────────────────────────────────────────────────────────────
// Start
// ──────────────────────────────────────────────────────────────────────────────

const transport = new StdioServerTransport();
await server.connect(transport);
