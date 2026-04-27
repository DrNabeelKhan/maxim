# CLAUDE.d / Repo Structure (Authoritative Map)

> Loaded by `CLAUDE.md` as a reference module. Authoritative directory map of
> the Maxim repo as of v1.0.0. Updated whenever top-level structure changes.

```
maxim/
│
├── .claude/skills/                         ← LAYER 1: Maxim DOMAIN SKILLS (Supreme Authority) — 33 active (v1.0.0: +7 vs v6.3.0)
│   │
│   ├── ai-media-generation/                [Maxim] + higgsfield-claude-skills + higgsfield-ai-prompt-skill
│   ├── banner-design/                      [Maxim stub] + ui-ux-pro-max-skill: banner-design/
│   ├── behavior-science-persuasion/        [Maxim] + claude-skills: c-level-advisor + business-growth
│   ├── brand/                              [Maxim stub] + ui-ux-pro-max-skill: brand/
│   ├── ceo-automation/                     [Maxim] — startup operator workflow (33 templates)
│   ├── compliance/                         [Maxim] + claude-skills: ra-qm-team (GDPR, ISO 27001, CAPA, risk)
│   ├── content-creation/                   [Maxim] + claude-skills: marketing-skill
│   ├── design/                             [Maxim] + claude-skills: product-team + ui-ux-pro-max-skill: design
│   ├── design-resources/                   [Maxim] — DESIGN.md 9-section standard + 6 references
│   ├── design-system/                      [Maxim stub] + ui-ux-pro-max-skill: design-system/
│   ├── engineering/                        [Maxim] + claude-skills: engineering-team + POWERFUL
│   ├── enterprise-architecture/            [Maxim] + claude-skills: c-level-advisor + senior-architect + aws-solution-architect + orchestration
│   ├── marketing/                          [Maxim] + claude-skills: marketing-skill (17 sub-skills, hub-and-spoke)
│   ├── memory-palace/                      [Maxim] — MemPalace MCP integration (wings/rooms/drawers + KG)
│   ├── operator-profile/                   [Maxim] — Honcho-inspired personalization across sessions
│   ├── product/                            [Maxim] + claude-skills: product-team
│   ├── product-development-research/       [Maxim] + claude-skills: product-team + ra-qm-team
│   ├── project-management/                 [Maxim] + claude-skills: project-management
│   ├── search-visibility/                  [Maxim] + claude-skills: marketing-skill (full SEO/AEO)
│   ├── security/                           [Maxim] + claude-skills: senior-security + senior-secops + incident-commander + ra-qm-team
│   ├── session-memory/                     [Maxim] — auto-compact + auto-inventory + 3-tier memory
│   ├── slides/                             [Maxim stub] + ui-ux-pro-max-skill: slides/
│   ├── studio-operations/                  [Maxim] + claude-skills: google-workspace-cli + documentation + orchestration + finance — 🟡 Partial
│   ├── testing/                            [Maxim] + claude-skills: ra-qm-team + engineering-team
│   ├── ui-styling/                         [Maxim stub] + ui-ux-pro-max-skill: ui-styling/
│   ├── ui-ux-pro-max/                      [Maxim stub] + ui-ux-pro-max-skill: ui-ux-pro-max/ (orchestrates all 6 design sub-domains)
│   ├── wiki-ingest/                        [Maxim — v1.0.0+] — raw → structured wiki on MemPalace
│   ├── wiki-query/                         [Maxim — v1.0.0+] — answer with cited synthesis
│   ├── wiki-lint/                          [Maxim — v1.0.0+] — contradictions/staleness audit
│   ├── wiki-explore/                       [Maxim — v1.0.0+] — human review queue for explored:false pages
│   ├── voice/                              [Maxim — v1.0.0+] — voice routing intent layer
│   ├── junction-guard/                     [Maxim — v1.0.0+] — NK universe junction read-only enforcement
│   ├── usage-aware-scheduler/              [Maxim — v1.0.0+] — Anthropic OAuth usage limit awareness for /mxm-tasks
│   └── deprecated/                         ← archived skills
│
├── .claude/commands/                       ← 33+ /mxm-* slash commands
├── .claude/agents/                         ← 11 sub-agent definitions (orchestrators bridge)
├── .claude/hooks/                          ← Executable hooks (v1.0.0+): session-start/end, pre-commit
│   ├── README.md                           ← Hook event mapping + wiring instructions
│   ├── session-start.{sh,ps1}              ← Detects project root, surfaces handoff state
│   ├── session-end.{sh,ps1}                ← Touches session-YYYY-MM-DD.md placeholder
│   └── pre-commit.{sh,ps1}                 ← Blocks secrets, warns on PII, audit-logs every scan
├── .claude/shared-resources/               ← Maxim-SKILL-SPEC + SKILL-TEMPLATE
│
├── .brand-foundation/                       ← v1.0.0+ — ships as personal/ template; user populates startups/
│   └── personal/                           ← voice-profile, ai-tells, content-rules
│
├── CLAUDE.md                               ← Universal Maxim rules (~400 lines, modular)
├── CLAUDE.d/                               ← v1.0.0+ — modular includes for CLAUDE.md
│   ├── session-memory.md                   ← Session protocols, junction auto-heal, data flow
│   ├── protocols.md                        ← Commit/Build/Dedup/Skill Domain checklist
│   ├── dispatch.md                         ← Domain Dispatch Table + Conflict Resolution + Workflows
│   ├── office-catalog.md                   ← Full agent roster across 7 offices
│   └── repo-map.md                         ← THIS FILE
│
├── community-packs/                               ← LAYER 2: EXTERNAL KNOWLEDGE BASE (read-only, vendored via git subtree)
│   ├── claude-skills/                      alirezarezvani full library (536 SKILL.md files)
│   ├── ui-ux-pro-max-skill/                nextlevelbuilder UI/UX library (7 skills)
│   ├── higgsfield-claude-skills/           19 video/cinematic skills
│   ├── higgsfield-ai-prompt-skill/         21 prompt sub-skills
│   └── awesome-design-md/                  59 brand DESIGN.md/README.md templates (VoltAgent)
│
├── composable-skills/                      ← LAYER 3: WORKFLOW ENGINE
│   ├── superpowers/                        writing-plans, executing-plans, TDD, debugging, verification, subagent-driven
│   ├── planning-with-files/                multi-session task plans
│   └── frameworks/                         63 framework wrappers (AIDA, OKR, JTBD, COM-B, etc.)
│
├── agents/                                 ← AGENT CATALOG (Layer 4)
│   ├── Maxim/                               ← 90 Maxim agents
│   │   ├── orchestrators/                  ← planner, implementer, reviewer, tester, release-manager
│   │   ├── ceo/ (9) · cto/ (25) · cmo/ (15) · cso/ (9) · cpo/ (12) · coo/ (9) · cino/ (3)
│   │   ├── executive-router.md             ← meta-orchestrator
│   │   └── deprecated/                     ← archived agents
│   └── voltagent/                          ← 150 community specialists (10 categories)
│
├── tools/subagent-catalog/                 ← Proxy to community-packs/awesome-claude-code-subagents (4 commands: list/search/fetch/invalidate)
├── ide-adapters/                           ← 16 IDE adapter configs (.adal, .agent, .claude-plugin, .codebuddy, .codex, .continue, .cursor, .factory, .gemini, .github, .kilocode, .kiro, .mastracode, .openclaw, .opencode, .pi) — each adapts Maxim's planning-with-files skill for its IDE. Synced weekly via sync-sources.yml.
│
├── mcp/                                    ← 7 MCP SERVERS (47 tools total) — see mcp/README.md (consolidated v1.0.0)
│   ├── mxm-portfolio/              7 tools — sync_portfolio, portfolio metrics, tasks
│   ├── mxm-context/                13 tools — v1.0.0 absorbed design (4) + added watch_* (3); manifest, decision log, session memory, operator profile, brand design, drift detection
│   ├── mxm-catalog/                9 tools — v1.0.0 merged dispatch + skills; office routing, agent DNA, handoff chain, skill/command catalog
│   ├── mxm-compliance/             5 tools — 14 compliance frameworks
│   ├── mxm-behavioral/             5 tools — 64 behavioral frameworks (added proactive-watch v1.0.0)
│   ├── mxm-memory/                 4 tools — cross-session memory search
│   └── mxm-voice/                  4 tools — v1.0.0+ — voice-driven office routing (wraps mbailey/voicemode)
│
├── config/
│   ├── project-manifest.json               ← PROJECT IDENTITY (read by all agents)
│   ├── project-manifest.TEMPLATE.json      ← COPY THIS for new projects (v1.0.0+ schema with lifecycle/gated/market/ownership)
│   ├── agent-registry.json                 ← Agent catalog (single source of truth for version)
│   ├── dependency-registry.json            ← External subtrees + VoltAgent
│   ├── scheduler-thresholds.json           ← v1.0.0+ — usage-aware scheduling thresholds
│   ├── voice-phrases.yml                   ← v1.0.0+ — user-editable voice hotword config
│   └── framework-mapping.yaml
│
├── bootstrap/                              ← Project bootstrap scripts
│   ├── install-global.ps1                  ← Run once: global Maxim install (Windows)
│   ├── link-local-project.ps1              ← Run per project: per-project file seeding
│   ├── new-project-setup.sh                ← Interactive wizard (Linux/CI/Mac)
│   ├── update-maxim.{ps1,sh}                ← Version migration with intelligence scan
│   └── sync-version.{ps1,sh}               ← Zero version drift — propagates to 7+ files
│
├── .github/workflows/                      ← CI/CD
│   ├── mxm-validate.yml                   ← PR validation (JSON, counts, legacy refs, security)
│   └── sync-sources.yml                    ← Weekly/monthly external subtree sync
│
├── documents/                                   ← Reference archive
├── templates/                              ← Project templates (ceo-automation, session-memory, operator-profile, scaffold)
├── plugins/mxm-cowork/                    ← Cowork plugin v6.3.0+
│
├── LICENSE                                 ← v1.0.0+ — Apache 2.0
├── .mcp.json                               ← v1.0.0+ — root MCP server registry (auto-discovery)
├── .env.example                            ← v1.0.0+ — environment variable template
├── documents/reference/AGENTS.md                               ← v1.0.0+ — instructions for downstream agents on wiki use
├── CLAUDE.project.md                       ← Project-specific overrides (template at documents/templates/CLAUDE.project.TEMPLATE.md)
├── documents/guides/ABOUT.md                                ← Competitive positioning
├── CONTRIBUTING.md                         ← Skill/agent authoring guide + PR checklist
├── documents/reference/MXM-SKILL-SPEC.md                      ← Public skill format specification
├── documents/guides/HELP.md                                 ← Full user guide
├── README.md                               ← Public README (v1.0.0 badge)
├── CHANGELOG.md
├── documents/guides/GETTING_STARTED.md
├── documents/reference/MXM_INSTALL.md
├── documents/reference/MXM_COMMAND_MAP.md                     ← 33 commands quick reference
├── documents/reference/SKILLS_MAP.md                           ← 26 domains cross-reference
├── documents/reference/FRAMEWORKS_MASTER.md                    ← 63 frameworks
├── documents/governance/ETHICAL_GUIDELINES.md                   ← Governance boundaries
├── documents/ledgers/MOAT_TRACKER.md                         ← Defensibility tracking
├── documents/ledgers/SESSION_CONTINUITY.md                   ← Session bridge
├── documents/reference/MXM_HEALTHCHECK.md                     ← /mxm-health 8-layer diagnostic
└── FINAL_RELEASE_CHANGES/                  ← Release planning (upgrade-blueprint, V6.4.0 phases, NK universe)
```

---

## Per-Project Structure (created by bootstrap)

```
user-project/
├── config/project-manifest.json            ← project identity (committed)
├── CLAUDE.project.md                       ← project overrides (committed)
├── documents/
│   ├── architecture/                       ← PRD, FRD, SRD (gitignored)
│   │   └── .secrets/                       ← API keys, credentials (gitignored)
│   └── business/                           ← investor docs
├── prototypes/                             ← v0 demos, POCs
├── .brand-foundation/                       ← v1.0.0+ — personal voice + per-startup positioning
│   ├── personal/                           ← inherited from Maxim template
│   └── startups/{name}/                    ← positioning, audience, compliance-rules
├── .mxm-skills/                           ← runtime state (gitignored)
│   ├── agents-skill-gaps.log
│   ├── agents-handoff.md
│   ├── agents-background.log
│   └── compliance-audit.jsonl              ← v1.0.0+ — pre-commit hook audit trail
├── .claude-sessions-memory/                ← session persistence (gitignored)
│   ├── handoff.md
│   ├── decision-log.md
│   ├── session-YYYY-MM-DD.md
│   └── MEMORY.md
├── .mxm-operator-profile/                 ← operator model (gitignored)
│   ├── OPERATOR.md
│   ├── preferences.md
│   ├── rejected-patterns.md
│   └── communication-style.md
├── .claude.local/settings.local.json       ← local config (gitignored)
└── .gitignore                              ← Maxim entries
```