You are performing a full Maxim repository health check.
Read every file listed below in sequence, then produce
a structured verification report against the Maxim dispatch
flow and architecture requirements.

Do not modify anything. Read and report only.

---

## STEP 1 — READ ALL FILES IN THIS ORDER

### Config / Architecture (read first — establishes authority)

1. CLAUDE.md
2. CLAUDE.project.md
3. config/project-manifest.json
4. config/agent-registry.json
5. documents/ledgers/SESSION_CONTINUITY.md
6. documents/reference/SKILLS_MAP.md
7. documents/reference/FRAMEWORKS_MASTER.md

### Skill Layer (read all domain roots)

For each domain folder in .claude/skills/ read:

- .claude/skills/{domain}/SKILL.md
- .claude/skills/{domain}/Maxim-WRAPPER.md (if exists)

Domains to cover:
behavior-science-persuasion
brand
banner-design
compliance
content-creation
design
design-system
engineering
enterprise-architecture
marketing
product
product-development-research
project-management
search-visibility
security
slides
studio-operations
testing
ui-styling
ui-ux-pro-max

### Agent Layer (read these specific files)

- agents/MXM/planner.md
- agents/MXM/implementer.md
- agents/MXM/reviewer.md
- agents/MXM/tester.md
- agents/MXM/release-manager.md
- agents/MXM/studio-producer.md
- agents/MXM/security-analyst.md
- agents/MXM/ui-ux-designer.md
- agents/MXM/enterprise-architect.md
- agents/MXM/seo-specialist.md
- agents/MXM/behavioral-designer.md
- agents/MXM/content-strategist.md
- agents/MXM/performance-engineer.md
- agents/MXM/financial-modeler.md
- agents/MXM/ux-researcher.md
- agents/MXM/threat-modeler.md
- agents/MXM/penetration-tester.md

### Composable Skills (read these specific files)

- community-packs/superpowers/writing-plans/SKILL.md
- community-packs/superpowers/executing-plans/SKILL.md
- community-packs/superpowers/subagent-driven-development/SKILL.md
- community-packs/superpowers/test-driven-development/SKILL.md
- community-packs/superpowers/systematic-debugging/SKILL.md
- community-packs/superpowers/verification-before-completion/SKILL.md
- community-packs/planning-with-files/SKILL.md

### Deprecated inventory (list only — do not read content)

- List all files present in agents/MXM/deprecated/
- List all folders present in .claude/skills/deprecated/

---

## STEP 2 — THE Maxim DISPATCH FLOW

(this is the authoritative standard to verify against)

Every task in Maxim must follow this exact path:

```
TASK RECEIVED
     │
     ▼
STEP 1 — Does .claude/skills/{domain}/ have an Maxim skill?
     │
     ├── YES → Activate Maxim skill
     │         Check community-packs/ for matching domain skill
     │         Merge: Maxim behavioral layer wins all conflicts
     │         ONE unified output
     │         Confidence tag: 🟢🟡🔴
     │
     └── NO  → Log to .mxm-skills/agents-skill-gaps.log
               │
               ▼
STEP 2 — Does community-packs/ have a matching skill?
     │
     ├── YES → Use raw. Flag: 🔴 Maxim-UNENHANCED
     │
     └── NO  → Steps 3-5 below
               │
               ▼
STEP 3 — Workflow pattern needed?
     │   YES → community-packs/superpowers/
               │
               ▼
STEP 4 — Task state tracking needed?
     │   YES → community-packs/planning-with-files/
               │
               ▼
STEP 5 — Maxim behavioral layer (only if Step 1 active):
         - Behavioral science framing
         - Framework selection from documents/reference/FRAMEWORKS_MASTER.md
         - Cross-agent collaboration triggers
         - 🟢🟡🔴 confidence tagging
```

4-LAYER ARCHITECTURE:
Layer 1: .claude/skills/ ← Maxim Domain Skills (Supreme)
Layer 2: community-packs/ ← External knowledge (read-only)
Layer 3: composable-skills/ ← Workflow engine
Layer 4: agents/ ← Agent catalog

TIER MODEL:
Tier 1 Orchestrators: planner, implementer, reviewer,
tester, release-manager, studio-producer
→ Phase-of-work agents, domain-agnostic
→ Each consumes community-packs/superpowers/

Tier 2 Domain Orchestrators: enterprise-architect,
security-analyst, seo-specialist, ui-ux-designer
→ Domain-level routing, sub-agent dispatch
→ Each has a sub-domain dispatch matrix

Tier 3 Specialists: all remaining active agents
→ Consume domain skills, produce structured output
→ Handoff to other specialists or Tier 1/2

Maxim MOAT — non-negotiable on every active skill/agent:

- Behavioral science layer (Fogg, COM-B, EAST)
- Framework selection from documents/reference/FRAMEWORKS_MASTER.md
- Confidence tagging 🟢🟡🔴
- Ethics gate (if ethics_required: true)
- Proactive cross-agent triggers (active agents only)

SKILL.md STANDARD:

- version: 2.0.0 minimum
- YAML frontmatter complete
- Frameworks table with real application descriptions
- Maxim Behavioral Framing section present
- Output Modes section present
- No deprecated agent references
- Source attribution footer

AGENT .md STANDARD:

- Role (coherent, scope-accurate)
- Responsibilities (minimum 5, registry-aligned)
- Frameworks Used
- Triggers
- Maxim Behavioral Framing (if ethics_required or Tier 2+)
- Output Format (structured block)
- Handoff (active agents only)
- Model Routing (MXM_MODEL_PROVIDER)
- Skills Consumed (.claude/skills/ paths)

Maxim-WRAPPER.md STANDARD:

- Maxim Identity (confidence level declared)
- Dispatch Path (Maxim path + external path + merge rule)
- Domain Scope
- Maxim Behavioral Framing
- External Reference Integration (4-step merge sequence)
- Skill Authoring Status checklist

---

## STEP 3 — VERIFICATION CHECKS

After reading all files, verify each of the following.
Score each: ✅ PASS | ⚠️ PARTIAL | ❌ FAIL | ➖ NOT APPLICABLE

### CHECK 1 — Dispatch Flow Integrity

For each .claude/skills/ domain:
1a. Does a SKILL.md exist at the domain root?
1b. Does an Maxim-WRAPPER.md exist?
1c. Does the SKILL.md have version 2.0.0 or higher?
1d. Does the SKILL.md have Maxim Behavioral Framing?
1e. Does the Maxim-WRAPPER.md declare the external merge path?

### CHECK 2 — Agent Tier Alignment

For each agent file read:
2a. Is the agent in the correct tier
(Tier 1 / Tier 2 / Tier 3)?
2b. Does the agent reference the correct
.claude/skills/ domain path in Skills Consumed?
2c. Does the agent's Handoff contain only active agents?
2d. For Tier 1: does it reference community-packs/superpowers/?
2e. For Tier 2: does it have a sub-domain dispatch matrix?

### CHECK 3 — Maxim MOAT Compliance

For each SKILL.md and active agent .md read:
3a. Is Maxim Behavioral Framing section present?
3b. Is at least one framework from documents/reference/FRAMEWORKS_MASTER.md
referenced and applied?
3c. Is confidence tagging 🟢🟡🔴 defined?
3d. If ethics_required: true in registry —
is an Ethics Gate present?

### CHECK 4 — Deprecated Reference Cleanliness

Scan every active file read (SKILL.md + agent .md):
4a. Do any active files reference deprecated agent IDs?

Deprecated list to scan against:
article-writer, newsletter-writer, video-script-writer,
technology-book-writer, whitepaper-writer,
social-media-strategist, instagram-curator,
tiktok-strategist, twitter-engager,
reddit-community-builder, whimsy-injector,
test-results-analyzer, aeo-strategist, geo-optimizer,
technical-seo-auditor, keyword-intent-researcher,
authority-builder, security-auditor, vulnerability-scanner,
threat-analyst, ethical-hacker, user-researcher,
usability-tester, visual-storyteller, content-creator,
performance-benchmarker, finance-tracker

### CHECK 5 — Registry Alignment

5a. Does every active agent .md file have a
corresponding entry in agent-registry.json?
5b. Does every agent with status: pending-authoring
have a real .md file or is the file missing?
5c. Are the 27 deprecated agents marked correctly
in the registry with status: deprecated
and absorbed_by populated?

### CHECK 6 — documents/ledgers/SESSION_CONTINUITY.md Integrity

6a. Is active agent count = 87?
6b. Is the pending cross-batch fix logged?
(rapid-prototyper.collaborates_with:
user-researcher → ux-researcher)
6c. Are all 7 completed batches logged?

### CHECK 7 — Composable Skills Routing

7a. Do Tier 1 orchestrator agents reference
the correct superpowers/ paths?
7b. Does planning-with-files/SKILL.md exist
and is it readable?

---

## STEP 4 — OUTPUT FORMAT

Produce this exact report. No abbreviation.

═══════════════════════════════════════════════
Maxim REPOSITORY HEALTH CHECK
Date: {today}
Branch: main
Files read: {total count}
═══════════════════════════════════════════════

CHECK 1 — DISPATCH FLOW INTEGRITY
───────────────────────────────────────
{for each domain, one row:}
{domain} | SKILL.md {✅/❌} | WRAPPER {✅/❌} |
v2.0.0 {✅/⚠️/❌} | Maxim MOAT {✅/❌} |
External path {✅/❌}

Domains missing Maxim-WRAPPER.md: {list}
Domains missing SKILL.md: {list}
Domains on v1.0.0 still: {list}

CHECK 2 — AGENT TIER ALIGNMENT
───────────────────────────────────────
{for each agent read:}
{agent} | Tier {1/2/3} {✅/❌} |
Skills Consumed {✅/❌} | Handoff clean {✅/❌} |
Superpower ref {✅/❌/➖} | Dispatch matrix {✅/❌/➖}

Issues found: {list any failures}

CHECK 3 — Maxim MOAT COMPLIANCE
───────────────────────────────────────
{for each file read:}
{file} | Behavioral Framing {✅/❌} |
Framework ref {✅/❌} | Confidence tag {✅/❌} |
Ethics gate {✅/❌/➖}

Files missing Maxim MOAT entirely: {list}
Files with ethics_required:true but no ethics gate: {list}

CHECK 4 — DEPRECATED REFERENCE CLEANLINESS
───────────────────────────────────────
Active files with deprecated refs: {count}
{if any:}
{file} — deprecated ID found: {id} — line: {N}
Required fix: replace {id} with {replacement}

CHECK 5 — REGISTRY ALIGNMENT
───────────────────────────────────────
Active agents with no registry entry: {list or NONE}
pending-authoring agents with missing .md file: {list or NONE}
Deprecated agents missing status field: {list or NONE}
Deprecated agents missing absorbed_by field: {list or NONE}

CHECK 6 — documents/ledgers/SESSION_CONTINUITY.md
───────────────────────────────────────
Active agent count: {value found} | Expected: 87 | {✅/❌}
Pending cross-batch fix logged: {✅/❌}
{if ✅ — paste the exact lines found}
{if ❌ — MISSING — needs patch commit}
All 7 batches logged: {✅/❌}
{list any missing batch entries}

CHECK 7 — COMPOSABLE SKILLS ROUTING
───────────────────────────────────────
Tier 1 agents with superpower refs: {count} / 6
planning-with-files/SKILL.md: {EXISTS/MISSING}
Superpowers missing from agents: {list}

───────────────────────────────────────
DEPRECATED INVENTORY
───────────────────────────────────────
agents/MXM/deprecated/ ({count} files):
{list all filenames}

.claude/skills/deprecated/ ({count} folders):
{list all folder names}

═══════════════════════════════════════════════
OVERALL HEALTH SCORE
───────────────────────────────────────
Check 1 — Dispatch Flow: {N}/{total} PASS
Check 2 — Tier Alignment: {N}/{total} PASS
Check 3 — Maxim MOAT: {N}/{total} PASS
Check 4 — Deprecated Refs: {CLEAN / N issues}
Check 5 — Registry: {N}/{total} PASS
Check 6 — Continuity: {N}/3 PASS
Check 7 — Composable Skills: {N}/{total} PASS

CRITICAL ISSUES (block next sprint): {list or NONE}
HIGH ISSUES (fix before new work): {list or NONE}
MEDIUM ISSUES (fix in next sprint): {list or NONE}
LOW ISSUES (backlog): {list or NONE}

RECOMMENDED NEXT ACTION: {one clear sentence}
═══════════════════════════════════════════════

---

### Check — Super User Mode

```bash
node -e "
const fs = require('fs');
const d = JSON.parse(fs.readFileSync('config/project-manifest.json'));
const su = d.super_user || {};
console.log('super_user.enabled:', su.enabled ?? false);
console.log('identity:', su.identity || 'not set');
const bypass = su.bypass || {};
const active = Object.entries(bypass).filter(([k,v]) => v).map(([k]) => k);
console.log('Gates suppressed:', active.length ? active.join(', ') : 'none');
"
```

**Expected (super user active):** `enabled: true`, identity set, gates listed
**Expected (default mode):** `enabled: false`
