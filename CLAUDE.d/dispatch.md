# CLAUDE.d / Dispatch

> Loaded by `CLAUDE.md` as a reference module. Contains: Domain Dispatch Table,
> Conflict Resolution Rules, Cross-Agent Collaboration Triggers, Confidence
> Tagging legend, and Workflow Patterns.

---

## 🧩 DOMAIN DISPATCH TABLE

| Task Domain | Maxim Skill Path | External Reference(s) | Gap Status |
|---|---|---|---|
| Behavioral science / persuasion | `.claude/skills/behavior-science-persuasion/` | `community-packs/claude-skills-library/c-level-advisor/` + `business-growth/` | ✅ Full |
| Content / copywriting / docs | `.claude/skills/content-creation/` | `community-packs/claude-skills-library/marketing-skill/` | ✅ Full |
| UX / UI / visual design | `.claude/skills/design/` | `community-packs/claude-skills-library/product-team/` + `community-packs/ui-ux-pro-max/.claude/skills/design/` | ✅ Full |
| Engineering / backend / frontend / AI | `.claude/skills/engineering/` | `community-packs/claude-skills-library/engineering-team/` + `POWERFUL/` | ✅ Full |
| Architecture / system design | `.claude/skills/enterprise-architecture/` | `community-packs/claude-skills-library/c-level-advisor/` + `engineering-team/senior-architect` + `engineering-team/aws-solution-architect` + `orchestration/` | ✅ Full |
| Marketing / GTM / growth | `.claude/skills/marketing/` | `community-packs/claude-skills-library/marketing-skill/` | ✅ Full |
| Product strategy / roadmap | `.claude/skills/product/` | `community-packs/claude-skills-library/product-team/` | ✅ Full |
| Research / discovery / validation | `.claude/skills/product-development-research/` | `community-packs/claude-skills-library/product-team/` + `ra-qm-team/` | ✅ Full |
| Project management / delivery | `.claude/skills/project-management/` | `community-packs/claude-skills-library/project-management/` | ✅ Full |
| SEO / AEO / search visibility | `.claude/skills/search-visibility/` | `community-packs/claude-skills-library/marketing-skill/` (full SEO/AEO confirmed) | ✅ Full |
| Security / threat modeling / SecOps | `.claude/skills/security/` | `community-packs/claude-skills-library/engineering-team/senior-security` + `senior-secops` + `incident-commander` + `ra-qm-team/` (ISMS) | ✅ Full |
| Agency ops / studio | `.claude/skills/studio-operations/` | `community-packs/claude-skills-library/engineering-team/google-workspace-cli` + `documentation/` + `orchestration/` + `finance/` | 🟡 Partial |
| QA / testing / coverage | `.claude/skills/testing/` | `community-packs/claude-skills-library/ra-qm-team/` + `engineering-team/` | ✅ Full |
| Regulatory / privacy / AI ethics | `.claude/skills/compliance/` | `community-packs/claude-skills-library/ra-qm-team/` (GDPR, ISO 27001, CAPA, risk) | ✅ Full |
| Brand identity / brand strategy | `.claude/skills/brand/` | `community-packs/ui-ux-pro-max/.claude/skills/brand/` | 🟡 Stub |
| Digital banner / ad creative | `.claude/skills/banner-design/` | `community-packs/ui-ux-pro-max/.claude/skills/banner-design/` | 🟡 Stub |
| Design system / component library | `.claude/skills/design-system/` | `community-packs/ui-ux-pro-max/.claude/skills/design-system/` | 🟡 Stub |
| Pitch decks / presentations | `.claude/skills/slides/` | `community-packs/ui-ux-pro-max/.claude/skills/slides/` | 🟡 Stub |
| CSS / Tailwind / UI styling | `.claude/skills/ui-styling/` | `community-packs/ui-ux-pro-max/.claude/skills/ui-styling/` | 🟡 Stub |
| Full-spectrum UI/UX intelligence | `.claude/skills/ui-ux-pro-max/` | `community-packs/ui-ux-pro-max/.claude/skills/ui-ux-pro-max/` | 🟡 Stub |
| AI video / image generation | `.claude/skills/ai-media-generation/` | `community-packs/higgsfield-ai-prompts/` (19 skills) + `community-packs/higgsfield-ai-prompts/` (21 skills) | ✅ Full |
| Knowledge wiki / brand voice (v1.0.0) | `.claude/skills/wiki-ingest/` + `wiki-query/` + `wiki-lint/` + `wiki-explore/` + `.brand-foundation/` | MemPalace-backed | 🆕 Active in v1.0.0 |
| Voice interaction (v1.0.0) | `.claude/skills/voice/` (via `mxm-voice` MCP) | mbailey/voicemode (Whisper + Kokoro) | 🆕 Active in v1.0.0 |

**🟡 Partial** = Maxim skill active, external tools absorbed for ops/tooling layer; full native coverage pending.
**🟡 Stub** = Maxim wrapper active, behavioral framing applied, full authoring sprint pending.
**🆕** = Newly added in this release.

---

## 🔄 Conflict Resolution Rules

| Conflict Type | Winner |
|---|---|
| Same topic, different framing | **Maxim** |
| Script exists in both | **Maxim** |
| Script only in external | **External** (absorbed) |
| Reference exists in both | **Merge** (Maxim framing leads) |
| Reference only in external | **External** (absorbed) |
| Workflow / mode conflict | **Maxim** |
| Communication style | **Maxim** |

---

## 🤝 Cross-Agent Collaboration

| Trigger | Auto-Loop Agent |
|---|---|
| Code writing or review | `implementer.md` + `reviewer.md` |
| Security-sensitive (auth, payments, PII) | `security-analyst.md` |
| Regulated domain (healthcare, finance, legal) | `security-analyst.md` + `compliance` skill |
| New feature planning | `planner.md` |
| Pre-deployment | `tester.md` + `release-manager.md` |
| Full-spectrum UI/UX task | `ui-ux-pro-max` skill (orchestrates all 6 design sub-domains) |
| Brand + design + marketing alignment | `brand/` + `design/` + `marketing/` skills in parallel |
| Knowledge ingestion / cross-project query | `wiki-ingest` / `wiki-query` skills (v1.0.0+) |
| Voice utterance | `mxm-voice` MCP server (v1.0.0+) |
| Explicit `/mxm-ceo` command | `enterprise-architect` |
| Explicit `/mxm-cto` command | `implementer` |
| Explicit `/mxm-cmo` command | `content-strategist` |
| Explicit `/mxm-cso` command | `security-analyst` |
| Explicit `/mxm-cpo` command | `product-strategist` |
| Explicit `/mxm-coo` command | `planner` |
| Explicit `/mxm-cino` command | `innovation-researcher` |
| No office specified (ambiguous) | `executive-router` |

---

## 📊 Confidence Tagging

| Tag | Meaning |
|---|---|
| 🟢 HIGH | Maxim skill matched, behavioral layer fully applied |
| 🟡 MEDIUM | Maxim stub active OR partial external match |
| 🔴 LOW / Maxim-UNENHANCED | No Maxim skill matched, raw external used |
| 🔵 SUPER USER | Maxim governance suppressed (project-manifest.super_user.enabled = true) |
| 🔐 GATED | Project requires explicit approval before any work (project-manifest.status.gated = true) |

---

## 🔄 Workflow Patterns

| Pattern | When | Location |
|---|---|---|
| `writing-plans` | New feature / new project | `community-packs/superpowers/writing-plans/` |
| `executing-plans` | Plan exists, now implementing | `community-packs/superpowers/executing-plans/` |
| `subagent-driven-development` | Parallel specialist agents needed | `community-packs/superpowers/subagent-driven-development/` |
| `test-driven-development` | Any code requiring test coverage | `community-packs/superpowers/test-driven-development/` |
| `systematic-debugging` | Bug or regression | `community-packs/superpowers/systematic-debugging/` |
| `verification-before-completion` | Before marking any task done | `community-packs/superpowers/verification-before-completion/` |
| `planning-with-files` | Multi-session tasks | `community-packs/planning-with-files/` |
