#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-behavioral — MCP Server
 * Behavioral science framework selection engine. Query "which framework
 * for this task?" and get specific application guidance.
 *
 * Part of Maxim Framework v6.2.0
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// Domain → framework mapping (from documents/reference/FRAMEWORKS_MASTER.md 63 frameworks)
const DOMAIN_FRAMEWORKS = {
  "search-visibility": ["E-E-A-T", "Core Web Vitals", "Schema.org", "Google Search Central", "AEO Framework", "LLMO Framework"],
  security: ["STRIDE", "OWASP Top 10", "MITRE ATT&CK", "Zero Trust", "NIST CSF", "ISO 27001", "SOC 2", "CIS Controls", "FAIR", "Diamond Model", "Cyber Kill Chain", "PASTA"],
  "enterprise-architecture": ["TOGAF", "Zachman", "C4 Model", "ArchiMate", "SABSA", "Domain-Driven Design", "Wardley Mapping", "Business Model Canvas"],
  product: ["Jobs-to-be-Done", "Lean Canvas", "Design Thinking", "Kano Model", "RICE Scoring", "North Star", "OKRs", "Value Proposition Canvas"],
  content: ["StoryBrand", "AIDA", "PAS", "Hero's Journey", "Content Pillars", "Topic Clusters"],
  engineering: ["12-Factor App", "SOLID", "Clean Architecture", "Event-Driven Architecture", "Microservices Patterns", "CQRS"],
  design: ["Material Design", "Apple HIG", "Gestalt Principles", "Atomic Design", "Double Diamond"],
  "project-management": ["Agile/Scrum", "Kanban", "PRINCE2", "Critical Path Method"],
  "behavior-science": ["Fogg Behavior Model", "COM-B Model", "EAST Framework", "Hook Model", "Nudge Theory", "Cialdini's Principles", "Self-Determination Theory", "Prospect Theory"],
  marketing: ["AIDA", "STP", "4Ps/7Ps", "Growth Loops", "AARRR Pirate Metrics", "Hook Canvas"],
};

// Framework details (behavioral science core — the Maxim moat)
const FRAMEWORK_DETAILS = {
  "Fogg Behavior Model": {
    description: "Behavior = Motivation × Ability × Prompt. All three must converge at the same moment for behavior to occur.",
    when_to_use: "Designing user onboarding, feature adoption, habit formation, conversion optimization",
    components: ["Motivation (pleasure/pain, hope/fear, acceptance/rejection)", "Ability (time, money, physical effort, brain cycles, social deviance, non-routine)", "Prompt (spark, facilitator, signal)"],
    application_steps: ["1. Define the target behavior precisely", "2. Map current motivation level (high/medium/low)", "3. Identify ability barriers (simplify the action)", "4. Design the right prompt type for the motivation×ability intersection", "5. Test and iterate on the weakest element"],
  },
  "COM-B Model": {
    description: "Capability + Opportunity + Motivation → Behavior. From behavioral medicine, now applied broadly.",
    when_to_use: "Understanding why users don't complete desired actions, designing interventions",
    components: ["Capability (physical/psychological)", "Opportunity (physical/social)", "Motivation (reflective/automatic)"],
    application_steps: ["1. Identify target behavior", "2. Diagnose which COM-B component is deficient", "3. Select intervention function (education, persuasion, incentivisation, coercion, training, restriction, environmental restructuring, modelling, enablement)", "4. Choose policy category", "5. Implement and measure"],
  },
  "EAST Framework": {
    description: "Make it Easy, Attractive, Social, Timely. From UK Behavioural Insights Team.",
    when_to_use: "Government/enterprise nudge design, form optimization, policy design, UX improvements",
    components: ["Easy (reduce friction, simplify, use defaults)", "Attractive (draw attention, design rewards)", "Social (show social norms, leverage networks)", "Timely (prompt when receptive, consider present bias)"],
    application_steps: ["1. Define the desired behavior change", "2. Audit current friction points (Easy)", "3. Design attention-grabbing elements (Attractive)", "4. Add social proof/norms (Social)", "5. Identify optimal timing windows (Timely)", "6. A/B test each EAST dimension"],
  },
  "Hook Model": {
    description: "Trigger → Action → Variable Reward → Investment. Creates habit-forming products.",
    when_to_use: "Product design for engagement, retention optimization, feature stickiness",
    components: ["Trigger (external/internal)", "Action (simplest behavior in anticipation of reward)", "Variable Reward (tribe/hunt/self)", "Investment (user puts something in to improve next cycle)"],
    application_steps: ["1. Identify the internal trigger (emotion/situation)", "2. Design the simplest possible action", "3. Create variable rewards (not predictable)", "4. Design investment that loads the next trigger", "5. Map the complete hook cycle", "6. Test cycle time and completion rates"],
  },
  "Nudge Theory": {
    description: "Choice architecture that steers decisions without restricting options. Nobel-winning (Thaler).",
    when_to_use: "Default selection, opt-in/opt-out design, pricing page layout, onboarding flows",
    components: ["Default options", "Framing effects", "Social proof", "Anchoring", "Loss aversion", "Choice architecture"],
    application_steps: ["1. Map the decision environment", "2. Identify the desired outcome", "3. Design choice architecture (defaults, ordering, framing)", "4. Ensure libertarian paternalism (don't restrict, just nudge)", "5. Test for unintended consequences", "6. Measure behavior change vs. control"],
  },
  "Cialdini's Principles": {
    description: "6 (now 7) universal principles of persuasion backed by decades of social psychology research.",
    when_to_use: "Sales pages, email campaigns, negotiation, landing pages, CTAs",
    components: ["Reciprocity", "Commitment/Consistency", "Social Proof", "Authority", "Liking", "Scarcity", "Unity (7th)"],
    application_steps: ["1. Identify which principles apply to your context", "2. Audit current copy/UX for existing principle use", "3. Layer in missing principles authentically", "4. Ensure ethical application (real scarcity, genuine social proof)", "5. Test principle combinations", "6. Measure conversion impact per principle"],
  },
  "AIDA": {
    description: "Attention → Interest → Desire → Action. Classic marketing/sales funnel model.",
    when_to_use: "Ad copy, landing pages, email sequences, sales presentations",
    components: ["Attention (headline, hook, pattern interrupt)", "Interest (relevance, curiosity, benefit)", "Desire (emotional connection, social proof, visualization)", "Action (clear CTA, urgency, friction removal)"],
    application_steps: ["1. Craft an attention-grabbing headline/hook", "2. Build interest with relevant benefits", "3. Create desire with emotional triggers and proof", "4. Design a clear, low-friction call to action"],
  },
  "Jobs-to-be-Done": {
    description: "People 'hire' products to do a job. Focus on the job, not the product features.",
    when_to_use: "Product discovery, feature prioritization, competitive analysis, positioning",
    components: ["Functional job", "Emotional job", "Social job", "Job context (when, where, why)"],
    application_steps: ["1. Interview users about their 'hiring' and 'firing' moments", "2. Map the job story: When [situation], I want to [motivation], so I can [outcome]", "3. Identify underserved jobs", "4. Design solutions that nail the core job", "5. Test job satisfaction metrics"],
  },
};

const server = new McpServer({
  name: "mxm-behavioral",
  version: "1.0.0",
});

// --- Tool: recommend_frameworks ---
server.tool(
  "recommend_frameworks",
  "Recommend top 3 behavioral/industry frameworks for a task and domain. Returns framework names with application steps.",
  {
    task: z.string().describe("Description of the task (e.g., 'design onboarding flow', 'write landing page copy')"),
    domain: z.string().describe("Domain context (e.g., 'marketing', 'product', 'design', 'engineering', 'behavior-science')"),
  },
  async ({ task, domain }) => {
    const taskLower = task.toLowerCase();
    const domainFrameworks = DOMAIN_FRAMEWORKS[domain] || DOMAIN_FRAMEWORKS["behavior-science"];

    // Score frameworks by keyword relevance
    const scored = [];
    const allFrameworks = [...new Set([...domainFrameworks, ...Object.keys(FRAMEWORK_DETAILS)])];

    for (const fw of allFrameworks) {
      let score = domainFrameworks.includes(fw) ? 2 : 0;
      const detail = FRAMEWORK_DETAILS[fw];
      if (detail) {
        if (detail.when_to_use.toLowerCase().split(/\W+/).some((w) => taskLower.includes(w))) score += 3;
        if (detail.description.toLowerCase().split(/\W+/).some((w) => taskLower.includes(w))) score += 1;
      }
      if (score > 0) scored.push({ framework: fw, score, details: detail || null });
    }

    scored.sort((a, b) => b.score - a.score);
    const top3 = scored.slice(0, 3);

    if (top3.length === 0) {
      return { content: [{ type: "text", text: `No frameworks found for domain="${domain}", task="${task}". Try domains: ${Object.keys(DOMAIN_FRAMEWORKS).join(", ")}` }] };
    }

    const result = top3.map((r) => ({
      framework: r.framework,
      relevance_score: r.score,
      description: r.details?.description || "See documents/reference/FRAMEWORKS_MASTER.md for details",
      when_to_use: r.details?.when_to_use || "General application",
      application_steps: r.details?.application_steps || ["Consult documents/reference/FRAMEWORKS_MASTER.md"],
    }));

    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

// --- Tool: apply_framework ---
server.tool(
  "apply_framework",
  "Apply a specific behavioral framework to a given context. Returns structured output with components and steps.",
  {
    framework: z.string().describe("Framework name (e.g., 'Fogg Behavior Model', 'EAST Framework', 'AIDA')"),
    context: z.string().describe("The specific context to apply the framework to (e.g., 'SaaS onboarding for small business owners')"),
  },
  async ({ framework, context }) => {
    const detail = FRAMEWORK_DETAILS[framework];
    if (!detail) {
      const available = Object.keys(FRAMEWORK_DETAILS).join(", ");
      return { content: [{ type: "text", text: `Framework "${framework}" not found. Available: ${available}` }] };
    }

    const application = {
      framework,
      context,
      description: detail.description,
      components: detail.components,
      application_steps: detail.application_steps,
      prompt: `Apply the ${framework} to: ${context}\n\nComponents to address:\n${detail.components.map((c) => `- ${c}`).join("\n")}\n\nFollow these steps:\n${detail.application_steps.join("\n")}`,
    };

    return { content: [{ type: "text", text: JSON.stringify(application, null, 2) }] };
  }
);

// --- Tool: get_framework_details ---
server.tool(
  "get_framework_details",
  "Get full details for a specific framework including description, when to use, components, and application steps.",
  {
    framework: z.string().describe("Framework name"),
  },
  async ({ framework }) => {
    const detail = FRAMEWORK_DETAILS[framework];
    if (!detail) {
      // Try partial match
      const match = Object.keys(FRAMEWORK_DETAILS).find((k) => k.toLowerCase().includes(framework.toLowerCase()));
      if (match) {
        return { content: [{ type: "text", text: JSON.stringify({ name: match, ...FRAMEWORK_DETAILS[match] }, null, 2) }] };
      }
      return { content: [{ type: "text", text: `Framework "${framework}" not found. Available: ${Object.keys(FRAMEWORK_DETAILS).join(", ")}` }] };
    }
    return { content: [{ type: "text", text: JSON.stringify({ name: framework, ...detail }, null, 2) }] };
  }
);

// --- Tool: behavioral_audit ---
server.tool(
  "behavioral_audit",
  "Audit content for behavioral science effectiveness. Returns improvement suggestions using Fogg + COM-B + EAST + Hook Model.",
  {
    content: z.string().describe("The content to audit (landing page copy, email, onboarding text, ad copy)"),
    type: z.enum(["landing_page", "email", "onboarding", "ad"]).describe("Type of content being audited"),
  },
  async ({ content: auditContent, type }) => {
    const checks = {
      fogg: { motivation: false, ability: false, prompt: false },
      east: { easy: false, attractive: false, social: false, timely: false },
      hook: { trigger: false, action: false, reward: false, investment: false },
      cialdini: { reciprocity: false, social_proof: false, scarcity: false, authority: false },
    };

    const lower = auditContent.toLowerCase();

    // Fogg checks
    checks.fogg.motivation = /benefit|save|gain|protect|fear|miss|love|hate|hope/i.test(lower);
    checks.fogg.ability = /easy|simple|quick|free|one.?click|instant|no.?cost/i.test(lower);
    checks.fogg.prompt = /now|today|start|get|try|click|sign|join|download/i.test(lower);

    // EAST checks
    checks.east.easy = /simple|easy|step|quick|instant|free/i.test(lower);
    checks.east.attractive = /exclusive|new|discover|unlock|premium|special/i.test(lower);
    checks.east.social = /join.*others|people|team|community|trusted|used by/i.test(lower);
    checks.east.timely = /now|today|limited|deadline|before|hurry|while/i.test(lower);

    // Hook checks
    checks.hook.trigger = /when|every time|notice|feel|struggle/i.test(lower);
    checks.hook.action = /click|tap|swipe|enter|type|select/i.test(lower);
    checks.hook.reward = /discover|reveal|earn|win|unlock|see/i.test(lower);
    checks.hook.investment = /profile|save|customize|follow|invite|upload/i.test(lower);

    // Cialdini checks
    checks.cialdini.reciprocity = /free|bonus|gift|complimentary|trial/i.test(lower);
    checks.cialdini.social_proof = /\d+.*(?:users|customers|companies|teams|people)|trusted|rated|review/i.test(lower);
    checks.cialdini.scarcity = /limited|only.*left|expires|last.*chance|few.*remaining/i.test(lower);
    checks.cialdini.authority = /expert|award|certified|featured|backed|endorsed/i.test(lower);

    const suggestions = [];
    if (!checks.fogg.motivation) suggestions.push("ADD motivation triggers: connect to user's pain/gain (Fogg)");
    if (!checks.fogg.ability) suggestions.push("REDUCE friction: emphasize ease/simplicity (Fogg)");
    if (!checks.fogg.prompt) suggestions.push("ADD clear call-to-action prompt (Fogg)");
    if (!checks.east.social) suggestions.push("ADD social proof: numbers, testimonials, community (EAST)");
    if (!checks.east.timely) suggestions.push("ADD urgency/timing signals (EAST)");
    if (!checks.cialdini.social_proof) suggestions.push("ADD quantified social proof: 'Used by 10,000+ teams' (Cialdini)");
    if (!checks.cialdini.scarcity) suggestions.push("CONSIDER scarcity: limited time/spots if authentic (Cialdini)");
    if (!checks.cialdini.authority) suggestions.push("ADD authority signals: awards, certifications, expert endorsements (Cialdini)");

    const score = Object.values(checks).reduce((sum, group) => {
      return sum + Object.values(group).filter(Boolean).length;
    }, 0);
    const maxScore = Object.values(checks).reduce((sum, group) => sum + Object.keys(group).length, 0);

    return {
      content: [{
        type: "text",
        text: JSON.stringify({
          content_type: type,
          behavioral_score: `${score}/${maxScore}`,
          percentage: `${Math.round((score / maxScore) * 100)}%`,
          framework_checks: checks,
          suggestions,
          verdict: score >= maxScore * 0.7 ? "STRONG" : score >= maxScore * 0.4 ? "MODERATE" : "WEAK",
        }, null, 2),
      }],
    };
  }
);

// --- Tool: nudge_design ---
server.tool(
  "nudge_design",
  "Design a nudge architecture for a behavior change goal using EAST framework + Nudge Theory.",
  {
    goal: z.string().describe("The behavior change goal (e.g., 'increase premium plan upgrades')"),
    audience: z.string().describe("Target audience description (e.g., 'free-tier SaaS users who have been active for 30+ days')"),
  },
  async ({ goal, audience }) => {
    const design = {
      goal,
      audience,
      nudge_architecture: {
        easy: {
          principle: "Remove friction from the desired behavior",
          tactics: [
            "Pre-fill forms with known data",
            "Reduce steps to minimum viable",
            "Use smart defaults (opt-in to best option)",
            "One-click actions where possible",
          ],
        },
        attractive: {
          principle: "Make the desired option visually and emotionally appealing",
          tactics: [
            "Highlight the recommended option with visual emphasis",
            "Use loss framing ('You're missing X features')",
            "Show personalized benefit calculations",
            "Design rewards that feel immediate",
          ],
        },
        social: {
          principle: "Leverage social norms and peer behavior",
          tactics: [
            "Show what similar users chose ('Most popular')",
            "Display aggregate behavior ('87% of teams your size chose Pro')",
            "Add peer testimonials from same segment",
            "Create visible community membership tiers",
          ],
        },
        timely: {
          principle: "Intervene at moments of maximum receptivity",
          tactics: [
            "Trigger when user hits a feature limit",
            "Prompt after a success moment (positive emotion)",
            "Use anniversary/milestone moments",
            "Avoid prompting during frustration or busy flows",
          ],
        },
      },
      choice_architecture: {
        default_option: "Set the desired behavior as the default where ethical",
        ordering: "Place desired option first or in the middle (compromise effect)",
        framing: "Frame as gain vs. current state, not as cost",
        anchoring: "Show high anchor first to make target seem reasonable",
      },
      ethical_guardrails: [
        "Never use dark patterns (hidden costs, forced actions, misdirection)",
        "Ensure easy opt-out from any nudge",
        "Be transparent about nudge mechanics if asked",
        "Respect user autonomy — nudge, don't coerce",
      ],
    };

    return { content: [{ type: "text", text: JSON.stringify(design, null, 2) }] };
  }
);

// --- Tool: score_behavioral_moat (v1.0.0, ADR-007) ---
server.tool(
  "score_behavioral_moat",
  "Score a SKILL.md or Maxim-WRAPPER content against the 7-section behavioral-moat framing (ADR-007). Returns section presence + overall grade.",
  {
    content: z.string().describe("The full markdown content to evaluate"),
  },
  async ({ content }) => {
    const required = [
      { key: "business_outcome", pattern: /business_outcome:/i, where: "frontmatter" },
      { key: "primary_framework", pattern: /primary_framework:/i, where: "frontmatter" },
      { key: "mxm_moat", pattern: /##\s+The Maxim Moat/i, where: "section" },
      { key: "business_outcome_section", pattern: /##\s+Business Outcome/i, where: "section" },
      { key: "primary_framework_section", pattern: /##\s+Primary Behavioral Framework/i, where: "section" },
      { key: "translation", pattern: /##\s+Behavioral\s*→/i, where: "section" },
      { key: "anti_patterns", pattern: /##\s+Anti-Patterns/i, where: "section" },
      { key: "pack_integrations", pattern: /##\s+Pack Integrations/i, where: "section" },
    ];
    const results = required.map((r) => ({ ...r, present: r.pattern.test(content) }));
    const score = results.filter((r) => r.present).length;
    const total = results.length;
    const grade = score === total ? "A" : score >= total * 0.75 ? "B" : score >= total * 0.5 ? "C" : "F";
    return { content: [{ type: "text", text: JSON.stringify({ score: `${score}/${total}`, grade, sections: results }, null, 2) }] };
  }
);

// --- Tool: get_framework_coverage (v1.0.0) ---
server.tool(
  "get_framework_coverage",
  "List domains that include a given framework in DOMAIN_FRAMEWORKS. Returns the domains + sibling frameworks.",
  {
    framework: z.string().describe("Framework name (e.g., 'AIDA', 'TOGAF', 'Fogg Behavior Model')"),
  },
  async ({ framework }) => {
    const q = framework.toLowerCase();
    const coverage = [];
    for (const [domain, frameworks] of Object.entries(DOMAIN_FRAMEWORKS)) {
      if (frameworks.some((f) => f.toLowerCase().includes(q) || q.includes(f.toLowerCase()))) {
        coverage.push({ domain, frameworks });
      }
    }
    return { content: [{ type: "text", text: JSON.stringify({ framework, covered_in: coverage.length, domains: coverage }, null, 2) }] };
  }
);

// --- Start ---
const transport = new StdioServerTransport();
await server.connect(transport);
