# Maxim Skill — Engineering

> Layer 1 — Supreme Authority | Executive Office: CTO

## Domain

Software engineering across backend, frontend, AI/ML, mobile, DevOps, infrastructure, databases, APIs, and cloud. The broadest Maxim skill domain — 19 active agents spanning the full software delivery lifecycle.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`implementer` — CTO Office

## Active Agents

- `backend-architect` — API design, database design, system scalability
- `frontend-developer` — UI implementation, component development, responsive design
- `ai-engineer` — ML models, LLM integration, embeddings, AI features
- `mobile-app-builder` — cross-platform and React Native mobile development
- `devops-automator` — CI/CD pipelines, infrastructure automation, deployment, monitoring
- `api-integrator` — third-party API integration and orchestration
- `rag-specialist` — retrieval-augmented generation systems
- `rapid-prototyper` — fast iteration, MVP scaffolding
- `prompt-engineer` — LLM prompt design and optimization
- `database-optimizer` — query optimization, schema design, indexing
- `dependency-auditor` — package security, version management, supply chain
- `training-data-curator` — ML dataset preparation and governance
- `support-agent-builder` — automated support and chatbot systems
- `performance-engineer` — benchmarking, load testing, latency optimization (absorbs `performance-benchmarker`)
- `cloud-cost-optimizer` — cloud spend analysis and right-sizing
- `security-architect` — auth, payment, and PII code path security (CTO office, ethics gate active)
- `solution-architect` — end-to-end system integration design
- `api-tester` — API validation and contract testing
- `load-tester` — performance and stress testing

## Skill Modes

Sub-skill SKILL.md files per specialist. Each agent operates in its own mode.
Key specialist modes:
- `backend-architect` → REST · GraphQL · Microservices · Database · Scalability
- `frontend-developer` → Component · Responsive · PWA · Accessibility · Performance
- `ai-engineer` → LLM · RAG · Embeddings · Fine-tuning · Ethics
- `devops-automator` → CI/CD · IaC · Monitoring · Containerization · Cloud
- `performance-engineer` → Benchmark · Load Test (absorbs `performance-benchmarker`)

## Ethics Gate

`security-architect` has ethics gate active — enforced on all auth, payment, and PII code paths.
`ai-engineer` has `ethics_required: true` — AI ethics compliance checked on every ML/AI output.
OWASP Top 10 applied as minimum security baseline on all code generation.

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/engineering-team/` — full engineering team library (backend, frontend, fullstack, senior architects)
- `community-packs/claude-skills-library/engineering-team/senior-architect` — consumed by `enterprise-architect` · `solution-architect` · `technology-architect` · `backend-architect`
- `community-packs/claude-skills-library/engineering-team/senior-ml-engineer` — consumed by `ai-engineer` · `data-scientist` · `rag-specialist`
- `community-packs/claude-skills-library/engineering-team/senior-prompt-engineer` — consumed by `ai-engineer` · `prompt-engineer`
- `community-packs/claude-skills-library/engineering-team/senior-computer-vision` — consumed by `ai-engineer`
- `community-packs/claude-skills-library/POWERFUL/` — power-user engineering patterns

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the engineering skill:

- `backend architecture`, `API design`, `database design`, `system scalability`
- `frontend development`, `UI implementation`, `component development`, `responsive design`
- `AI implementation`, `machine learning`, `LLM integration`, `AI features`, `embeddings`
- `CI/CD pipeline`, `infrastructure automation`, `deployment`, `monitoring`
- `API testing`, `endpoint validation`, `contract testing`, `API quality`
- `build`, `code`, `implement`, `develop`, `refactor`, `debug`, `optimize`
- `performance`, `load test`, `benchmark`, `latency`

## Cross-Agent Auto-Loops

When engineering skill activates, the following agents are auto-notified:

- `implementer` — lead orchestrator for all CTO office tasks
- `reviewer` — code review loop on all generated code
- `security-analyst` — auto-looped on auth, payment, PII code paths (CSO auto-loop rule)
- `tester` — pre-deployment testing loop
- `performance-engineer` — auto-looped when performance or scalability signals detected
- `compliance` skill — auto-looped when regulated industry or PII signals present

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | engineering | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
