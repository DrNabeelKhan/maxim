# Maxim — Full Capabilities Demo with Real Tasks

> **Usage:** Paste this into Claude Cowork or Claude Desktop.
> This exercises all 8 MCP servers using REAL tasks from your portfolio.
> Each example maps to an actual project task using proper /mxm-* commands.

---

## Prompt

You have Maxim Framework v1.0.1 with 7 MCP servers (47 tools), 90 agents, 34 skill domains, and 38 commands. Run through every capability using real portfolio tasks. After each, show the result and the /mxm-* command that would handle it in a project session.

---

### 1. Portfolio Awareness — "What should I work on today?"

Call `mxm-portfolio.get_tasks` with priority `P1`.
Then call `mxm-portfolio.get_portfolio_metrics`.

**Real task this serves:** Daily morning prioritization across 21 projects.
**Maxim command equivalent:** `/mxm-tasks next` — surfaces the single highest-impact task.

---

### 2. Project Context — "What's the state of FixIt?"

Call `mxm-context.get_manifest` with project_path `E:/Projects/FixIt`.
Then call `mxm-context.get_session_memory` with the same path.

**Real task this serves:** [FX-01] Check live server operations — generate full status report.
**Maxim command equivalent:** `/mxm-status` when inside the FixIt project folder.

---

### 3. Compliance Check — "Can GulfLaw store UAE legal documents with user PII?"

Call `mxm-compliance.check_compliance` with:
- project_path: `E:/Projects/GulfLaw.AI`
- action: "store UAE legal case documents containing client personal data for RAG retrieval"
- data_type: "PII"

**Real task this serves:** [GL-02] Define UAE-PDPL + GDPR BLOCK status governance workflow.
**Maxim command equivalent:** `/mxm-compliance` — CSO office auto-loops security-analyst + data-privacy-officer.

---

### 4. Agent Routing — "Who handles building a mobile scheduling UI?"

Call `maxim-dispatch.route_task` with task: "Build DrivingTutors mobile-first scheduling UI with province selector, instructor search, and Stripe booking flow"

Then call `maxim-dispatch.get_handoff_chain` with the same task.

**Real task this serves:** [DT-03] Scaffold Next.js + Supabase + Stripe for DrivingTutors.
**Maxim command equivalent:** `/mxm-route "Build mobile scheduling UI"` → routes to CTO → `/mxm-plan` → `/mxm-implement`.

---

### 5. Behavioral Science — "How do I design Maxim platform onboarding?"

Call `mxm-behavioral.recommend_frameworks` with:
- task: "design self-serve onboarding for new entrepreneurs using conversational commerce platform"
- domain: "product"

Then call `mxm-behavioral.nudge_design` with:
- goal: "increase onboarding completion rate from signup to first WhatsApp integration"
- audience: "small business owners who signed up for free tier and have not connected WhatsApp after 48 hours"

**Real task this serves:** [AS-05] Redesign onboarding — Setup Packs with demo data.
**Maxim command equivalent:** `/mxm-cpo` → product-strategist activates with behavioral science layer.

---

### 6. Behavioral Audit — "Is this landing page copy persuasive enough?"

Call `mxm-behavioral.behavioral_audit` with:
- content: "Maxim by Simplification — Your AI team that never sleeps. Connect WhatsApp, get intelligent responses in minutes. Start free, upgrade when you grow. Join 150+ businesses already using Maxim."
- type: "landing_page"

**Real task this serves:** [AS-27] Publish Maxim landing page with vertical-specific hero copy.
**Maxim command equivalent:** `/mxm-cmo` → content-strategist + conversion-optimizer + persuasion-specialist auto-loop.

---

### 7. Brand Design — "Show me design inspiration for the personal site"

Call `maxim-design.list_brands` with category: "tech".
Then call `maxim-design.get_brand_design` with brand: "linear".

**Real task this serves:** [NK-03] Design nabeelkhan.com using ELARA warm design language.
**Maxim command equivalent:** `/mxm-design` → CPO office activates ui-ux-designer with design-resources skill.

---

### 8. Skill Discovery — "What Maxim skills help with security?"

Call `maxim-skills.search_skills` with query: "security".
Then call `maxim-skills.get_skill_detail` with skill_id: "security".

**Real task this serves:** [AI-22] Set up Tailscale network — security architecture for multi-node infrastructure.
**Maxim command equivalent:** `/mxm-cso` → security-analyst + threat-modeler activated.

---

### 9. Compliance Frameworks — "What does FINTRAC require for KD Coin?"

Call `mxm-compliance.get_jurisdiction_requirements` with framework: "FINTRAC".
Then call `mxm-compliance.audit_data_handling` with:
- project_path: `E:/Projects/KD Coin`
- data_fields: ["wallet_address", "transaction_amount", "name", "date_of_birth", "government_id"]

**Real task this serves:** [KC-01] KD Coin FINTRAC/AML compliance architecture.
**Maxim command equivalent:** `/mxm-compliance` → compliance-officer + legal-compliance-checker.

---

### 10. Memory — "What decisions have we made about Maxim?"

Call `mxm-memory.search_memory` with:
- query: "organizational structure"
- project_path: `E:/Projects/Maxim/maxim`

Then call `mxm-memory.get_session_history` with:
- project_path: `E:/Projects/Maxim/maxim`
- limit: 3

**Real task this serves:** Cross-session continuity — any new session reads prior decisions.
**Maxim command equivalent:** `/mxm-recall "organizational structure"` via MemPalace.

---

### 11. Portfolio Sync — "Update global context from all projects"

Call `mxm-portfolio.sync_portfolio`.

**Real task this serves:** Daily staleness prevention — global context stays fresh.
**Maxim command equivalent:** Runs automatically at 5:27 AM via `mxm-global-sync` scheduled task + at session end.

---

### 12. CEO Automation — "Set up morning/overnight cycles for a startup"

Call `maxim-dispatch.route_task` with task: "set up CEO morning briefing with metrics digest, burn rate alert, team capacity check, pipeline digest, and customer health scan"

**Real task this serves:** [FX-02] Automate CEO daily status report for FixIt.
**Maxim command equivalent:** `/mxm-ceo-setup` on the project → schedules `/mxm-ceo-morning` (6 AM) + `/mxm-ceo-overnight` (2 AM).

---

### 13. Personal AI — "Route the ELARA/RIVA build"

Call `maxim-dispatch.route_task` with task: "Build dual-personality AI interface with ElevenLabs voice, Tailscale networking, and Claude MCP integration for ai.nabeelkhan.com"

Then call `mxm-behavioral.apply_framework` with:
- framework: "Hook Model"
- context: "Personal AI assistant that users interact with daily via voice — needs to become habitual"

**Real task this serves:** [AI-01 through AI-27] Full ELARA/RIVA build.
**Maxim command equivalent:** `/mxm-cto` for engineering + `/mxm-cpo` for UX + `/mxm-cmo` for brand voice.

---

## Summary

After all 13 steps, produce:

```
Maxim AGENTS v6.3.0 — CAPABILITIES VERIFICATION

MCP Servers: [N/8 responding]
Tools exercised: [count]/42
Real tasks mapped: 13 portfolio tasks
Offices activated: CEO, CTO, CMO, CSO, CPO, COO
Frameworks applied: [list]
Compliance frameworks checked: [list]
Brand designs accessed: [list]
Memory layers tested: [list]

STATUS: [ALL OPERATIONAL / PARTIAL / ISSUES FOUND]
```
