#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-compliance — MCP Server
 * Compliance checking as a service. Any Claude surface can ask
 * "is this GDPR compliant?" and get a structured verdict.
 *
 * Part of Maxim Framework v6.2.0
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { readFile } from "node:fs/promises";
import { join } from "node:path";

const MXM_ROOT = process.env.MXM_ROOT || "E:/Projects/Maxim/maxim";

async function safeRead(filePath) {
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    return null;
  }
}

async function loadProjectCompliance(projectPath) {
  const raw = await safeRead(join(projectPath, "config/project-manifest.json"));
  if (!raw) return null;
  try {
    const m = JSON.parse(raw);
    return m.compliance || null;
  } catch {
    return null;
  }
}

// Framework knowledge base — structured from compliance SKILL.md
const FRAMEWORK_DB = {
  GDPR: {
    name: "General Data Protection Regulation",
    jurisdiction: "EU/EEA",
    key_requirements: ["Lawful basis for processing", "Data minimization", "Right to erasure", "Data portability", "DPO appointment", "72-hour breach notification", "Privacy by design", "DPIA for high-risk processing"],
    data_categories: { PII: "high", PHI: "critical", financial: "high", public: "low" },
  },
  PIPEDA: {
    name: "Personal Information Protection and Electronic Documents Act",
    jurisdiction: "Canada",
    key_requirements: ["Meaningful consent", "Limiting collection", "Limiting use/disclosure", "Accuracy", "Safeguards", "Openness", "Individual access", "Challenging compliance"],
    data_categories: { PII: "high", PHI: "high", financial: "high", public: "low" },
  },
  "PCI-DSS": {
    name: "Payment Card Industry Data Security Standard",
    jurisdiction: "Global (payments)",
    key_requirements: ["Secure network", "Protect cardholder data", "Vulnerability management", "Access control", "Monitor/test networks", "Security policy"],
    data_categories: { PII: "medium", PHI: "low", financial: "critical", public: "low" },
  },
  SOC2: {
    name: "SOC 2 Type II",
    jurisdiction: "US/Global (enterprise SaaS)",
    key_requirements: ["Security", "Availability", "Processing integrity", "Confidentiality", "Privacy"],
    data_categories: { PII: "high", PHI: "high", financial: "high", public: "low" },
  },
  HIPAA: {
    name: "Health Insurance Portability and Accountability Act",
    jurisdiction: "US",
    key_requirements: ["Privacy Rule", "Security Rule", "Breach Notification Rule", "Minimum necessary standard", "BAA with vendors"],
    data_categories: { PII: "high", PHI: "critical", financial: "medium", public: "low" },
  },
  "UAE-PDPL": {
    name: "UAE Personal Data Protection Law",
    jurisdiction: "UAE",
    key_requirements: ["Lawful processing basis", "Purpose limitation", "Data minimization", "Cross-border transfer restrictions", "Data breach notification", "DPO for certain controllers"],
    data_categories: { PII: "high", PHI: "critical", financial: "high", public: "low" },
  },
  CASL: {
    name: "Canada Anti-Spam Legislation",
    jurisdiction: "Canada",
    key_requirements: ["Express/implied consent for CEMs", "Unsubscribe mechanism", "Sender identification", "Record keeping"],
    data_categories: { PII: "medium", PHI: "low", financial: "low", public: "low" },
  },
  FINTRAC: {
    name: "Financial Transactions and Reports Analysis Centre",
    jurisdiction: "Canada",
    key_requirements: ["KYC/CDD", "Suspicious transaction reporting", "Large cash transaction reporting", "Record keeping (5 years)", "Compliance program"],
    data_categories: { PII: "critical", PHI: "low", financial: "critical", public: "low" },
  },
  "EU AI Act": {
    name: "EU Artificial Intelligence Act",
    jurisdiction: "EU",
    key_requirements: ["Risk classification (unacceptable/high/limited/minimal)", "Conformity assessment for high-risk AI", "Transparency obligations", "Human oversight requirements", "Data governance for training sets", "Technical documentation", "Post-market monitoring"],
    data_categories: { PII: "high", PHI: "critical", financial: "high", public: "medium" },
  },
  "ISO 27001": {
    name: "ISO/IEC 27001 Information Security Management",
    jurisdiction: "Global",
    key_requirements: ["ISMS establishment", "Risk assessment methodology", "Statement of Applicability", "Access control policy", "Asset management", "Incident management", "Business continuity", "Compliance monitoring"],
    data_categories: { PII: "high", PHI: "high", financial: "high", public: "low" },
  },
  "ISO 13485": {
    name: "ISO 13485 Medical Devices Quality Management",
    jurisdiction: "Global (medical devices)",
    key_requirements: ["QMS for medical devices", "Design and development controls", "Risk management (ISO 14971)", "Traceability", "CAPA process", "Validation of processes", "Regulatory reporting"],
    data_categories: { PII: "high", PHI: "critical", financial: "medium", public: "low" },
  },
  "ISO 14971": {
    name: "ISO 14971 Medical Device Risk Management",
    jurisdiction: "Global (medical devices)",
    key_requirements: ["Risk management plan", "Hazard identification", "Risk estimation and evaluation", "Risk control measures", "Residual risk evaluation", "Risk management report", "Production and post-production monitoring"],
    data_categories: { PII: "medium", PHI: "critical", financial: "low", public: "low" },
  },
  "NIST CSF": {
    name: "NIST Cybersecurity Framework",
    jurisdiction: "US/Global",
    key_requirements: ["Identify (asset management, risk assessment)", "Protect (access control, training, data security)", "Detect (anomaly detection, monitoring)", "Respond (response planning, communications)", "Recover (recovery planning, improvements)"],
    data_categories: { PII: "high", PHI: "high", financial: "high", public: "low" },
  },
  "WCAG 2.1": {
    name: "Web Content Accessibility Guidelines 2.1",
    jurisdiction: "Global (web accessibility)",
    key_requirements: ["Perceivable (text alternatives, captions, contrast)", "Operable (keyboard access, timing, seizures, navigation)", "Understandable (readable, predictable, input assistance)", "Robust (compatible with assistive tech)"],
    data_categories: { PII: "low", PHI: "low", financial: "low", public: "low" },
  },
};

// Normalize framework names — handle "SOC 2" vs "SOC2" etc.
function lookupFramework(name) {
  if (FRAMEWORK_DB[name]) return FRAMEWORK_DB[name];
  const normalized = name.replace(/\s+/g, "").toUpperCase();
  for (const [key, value] of Object.entries(FRAMEWORK_DB)) {
    if (key.replace(/\s+/g, "").toUpperCase() === normalized) return value;
  }
  return null;
}

const server = new McpServer({
  name: "mxm-compliance",
  version: "1.0.0",
});

// --- Tool: check_compliance ---
server.tool(
  "check_compliance",
  "Check if an action is compliant for a given project. Returns verdict (COMPLIANT/REVIEW/BLOCK), applicable frameworks, and specific requirements.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    action: z.string().describe("Description of the action to check (e.g., 'store user email for marketing', 'process payment')"),
    data_type: z.enum(["PII", "PHI", "financial", "public"]).optional().describe("Type of data involved"),
  },
  async ({ project_path, action, data_type }) => {
    const compliance = await loadProjectCompliance(project_path);
    if (!compliance) {
      return { content: [{ type: "text", text: JSON.stringify({ verdict: "REVIEW", reason: "No project-manifest.json or compliance section found. Cannot determine applicable frameworks.", action }, null, 2) }] };
    }

    const frameworks = compliance.frameworks || [];
    const actionLower = action.toLowerCase();
    const results = [];

    for (const fw of frameworks) {
      const info = lookupFramework(fw);
      if (!info) {
        results.push({ framework: fw, verdict: "REVIEW", reason: `Framework ${fw} not in knowledge base` });
        continue;
      }

      let verdict = "COMPLIANT";
      const flags = [];

      // Data sensitivity check
      if (data_type && info.data_categories[data_type] === "critical") {
        verdict = "REVIEW";
        flags.push(`${data_type} data is CRITICAL under ${fw} — requires explicit safeguards`);
      }

      // Keyword-based risk detection
      if (actionLower.includes("store") || actionLower.includes("collect")) {
        flags.push(`${fw}: Verify lawful basis/consent for data collection`);
        if (verdict === "COMPLIANT") verdict = "REVIEW";
      }
      if (actionLower.includes("transfer") || actionLower.includes("share") || actionLower.includes("third-party")) {
        flags.push(`${fw}: Cross-border/third-party transfer requires assessment`);
        verdict = "REVIEW";
      }
      if (actionLower.includes("delete") || actionLower.includes("erase")) {
        flags.push(`${fw}: Verify retention period compliance before deletion`);
      }
      if (actionLower.includes("payment") || actionLower.includes("card") || actionLower.includes("transaction")) {
        if (fw === "PCI-DSS") {
          flags.push("PCI-DSS: Cardholder data must be encrypted in transit and at rest");
          verdict = "REVIEW";
        }
      }
      if (actionLower.includes("email") || actionLower.includes("marketing") || actionLower.includes("newsletter")) {
        if (fw === "CASL") {
          flags.push("CASL: Express consent required for commercial electronic messages");
          verdict = "REVIEW";
        }
      }

      results.push({
        framework: fw,
        full_name: info.name,
        jurisdiction: info.jurisdiction,
        verdict,
        flags,
        requirements: info.key_requirements,
      });
    }

    const overallVerdict = results.some((r) => r.verdict === "BLOCK")
      ? "BLOCK"
      : results.some((r) => r.verdict === "REVIEW")
        ? "REVIEW"
        : "COMPLIANT";

    return {
      content: [{
        type: "text",
        text: JSON.stringify({ overall_verdict: overallVerdict, action, data_type: data_type || "unspecified", frameworks_checked: results }, null, 2),
      }],
    };
  }
);

// --- Tool: get_frameworks ---
server.tool(
  "get_frameworks",
  "Get all compliance frameworks applicable to a project from its manifest.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
  },
  async ({ project_path }) => {
    const compliance = await loadProjectCompliance(project_path);
    if (!compliance) {
      return { content: [{ type: "text", text: "No compliance section in project manifest." }] };
    }
    const frameworks = (compliance.frameworks || []).map((fw) => ({
      id: fw,
      ...(FRAMEWORK_DB[fw] || { name: fw, jurisdiction: "Unknown" }),
    }));
    return { content: [{ type: "text", text: JSON.stringify(frameworks, null, 2) }] };
  }
);

// --- Tool: get_jurisdiction_requirements ---
server.tool(
  "get_jurisdiction_requirements",
  "Get specific requirements for a compliance framework (GDPR, PIPEDA, PCI-DSS, SOC2, HIPAA, UAE-PDPL, CASL, FINTRAC).",
  {
    framework: z.string().describe("Framework identifier (e.g., GDPR, PIPEDA, PCI-DSS)"),
  },
  async ({ framework }) => {
    const info = lookupFramework(framework);
    if (!info) {
      return { content: [{ type: "text", text: `Framework "${framework}" not found. Available: ${Object.keys(FRAMEWORK_DB).join(", ")}` }] };
    }
    return { content: [{ type: "text", text: JSON.stringify({ id: framework, ...info }, null, 2) }] };
  }
);

// --- Tool: audit_data_handling ---
server.tool(
  "audit_data_handling",
  "Classify data fields by sensitivity (PII/PHI/financial/public) and check against project compliance requirements.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    data_fields: z.array(z.string()).describe("List of data field names to classify (e.g., ['email', 'credit_card', 'name', 'diagnosis'])"),
  },
  async ({ project_path, data_fields }) => {
    const compliance = await loadProjectCompliance(project_path);
    const frameworks = compliance?.frameworks || [];

    const classifications = {
      // PII
      email: "PII", name: "PII", phone: "PII", address: "PII", ip_address: "PII",
      date_of_birth: "PII", ssn: "PII", passport: "PII", driver_license: "PII",
      // PHI
      diagnosis: "PHI", medication: "PHI", medical_record: "PHI", health_condition: "PHI",
      treatment: "PHI", lab_result: "PHI", insurance_id: "PHI",
      // Financial
      credit_card: "financial", bank_account: "financial", routing_number: "financial",
      transaction: "financial", payment: "financial", salary: "financial", sin: "financial",
      // Public
      username: "public", display_name: "public", avatar: "public", bio: "public",
    };

    const results = data_fields.map((field) => {
      const normalized = field.toLowerCase().replace(/[\s-]/g, "_");
      const category = classifications[normalized] || "PII"; // default to PII for safety
      const sensitivity = {};
      for (const fw of frameworks) {
        const info = FRAMEWORK_DB[fw];
        if (info) sensitivity[fw] = info.data_categories[category] || "medium";
      }
      return { field, classification: category, sensitivity_by_framework: sensitivity };
    });

    return { content: [{ type: "text", text: JSON.stringify(results, null, 2) }] };
  }
);

// --- Tool: generate_ropa_entry ---
server.tool(
  "generate_ropa_entry",
  "Generate a GDPR Record of Processing Activities (RoPA) entry template for a processing activity.",
  {
    project_path: z.string().describe("Absolute path to the project root"),
    processing_activity: z.string().describe("Description of the processing activity (e.g., 'User registration and account creation')"),
  },
  async ({ project_path, processing_activity }) => {
    const compliance = await loadProjectCompliance(project_path);
    const manifest = await safeRead(join(project_path, "config/project-manifest.json"));
    let projectName = "Unknown Project";
    try {
      const m = JSON.parse(manifest);
      projectName = m.project?.name || projectName;
    } catch { /* ignore */ }

    const entry = {
      controller: projectName,
      processing_activity: processing_activity,
      purpose: "[Fill: specific purpose for this processing]",
      lawful_basis: "[Select: consent | contract | legal_obligation | vital_interests | public_task | legitimate_interests]",
      data_categories: "[Fill: e.g., name, email, IP address]",
      data_subjects: "[Fill: e.g., customers, employees, website visitors]",
      recipients: "[Fill: internal teams, processors, third parties]",
      cross_border_transfers: "[Fill: countries/regions, safeguards (SCCs, adequacy)]",
      retention_period: "[Fill: duration or criteria for determining duration]",
      security_measures: "[Fill: encryption, access control, pseudonymization]",
      dpia_required: "[Assess: yes/no based on risk level]",
      last_reviewed: new Date().toISOString().split("T")[0],
      applicable_frameworks: compliance?.frameworks || [],
    };

    return { content: [{ type: "text", text: JSON.stringify(entry, null, 2) }] };
  }
);

// --- Start ---
const transport = new StdioServerTransport();
await server.connect(transport);
