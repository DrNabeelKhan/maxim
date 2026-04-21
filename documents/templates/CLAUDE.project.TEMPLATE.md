# Maxim Project Configuration
<!-- REQUIRED: Replace "Your Project Name" with the actual project name throughout this file. -->
<!-- Delete all instruction comments (lines starting with <!--) after filling in each section. -->

**Project:** <!-- REQUIRED: Your project name e.g. "Maxim Simplification" -->
**Type:** <!-- REQUIRED: e.g. SaaS platform | AI agent service | API backend | Mobile app -->
**Owner:** <!-- REQUIRED: Your GitHub username e.g. DrNabeelKhan -->
**Last Updated:** <!-- REQUIRED: YYYY-MM-DD -->

> Universal Maxim rules live in `CLAUDE.md` (global). This file only adds or overrides
> project-specific behavior. Source of truth for project identity: `config/project-manifest.json`.

---

## Product Identity

<!-- REQUIRED: Write 2-4 sentences describing what this product is, what problem it solves,
     who it serves, and what market it operates in. Be specific — agents use this to calibrate
     tone, security posture, and compliance checks.
     Example: "Maxim is a behavioral intelligence layer for AI agent systems. It gives development
     teams a governed, multi-agent workflow engine that applies behavioral science and compliance
     frameworks to every output. Built for founders and CTOs who need AI that reasons, not just
     responds." -->

[Your product description here]

---

## Target Market

<!-- REQUIRED: Define your customer segments. Add or remove rows as needed. -->
<!-- The Plan column should be one of: Free | Starter | Pro | Enterprise | Custom -->

| Segment | Description | Plan |
|---|---|---|
| <!-- e.g. Indie founders --> | <!-- e.g. Solo builders shipping SaaS MVPs --> | <!-- e.g. Starter --> |
| <!-- e.g. Scale-up CTOs --> | <!-- e.g. Engineering leads at Series A/B companies --> | <!-- e.g. Pro --> |
| <!-- e.g. Enterprise teams --> | <!-- e.g. 50+ person eng orgs needing governance --> | <!-- e.g. Enterprise --> |

---

## Tech Stack Preferences

<!-- REQUIRED: Fill in your actual tech choices. Agents use this to generate correct code,
     flag security issues specific to your stack, and avoid suggesting incompatible tools.
     Copy confirmed values from config/project-manifest.json → tech_stack. -->

### Backend
<!-- REQUIRED -->
- **Language / Framework:** <!-- e.g. Python 3.12 / FastAPI, Node.js 20 / Express, Go 1.22 / Gin -->
- **Database:** <!-- e.g. PostgreSQL 16 on AWS RDS -->
- **Cache:** <!-- e.g. Redis 7 on ElastiCache, or "none" -->
- **Task Queue:** <!-- e.g. Celery + Redis, BullMQ, or "none" -->
- **Auth Provider:** <!-- e.g. Clerk, Supabase Auth, Auth0, or "custom JWT" -->
- **Payments:** <!-- e.g. Stripe, or "none" -->
- **Storage:** <!-- e.g. AWS S3, Cloudflare R2, or "none" -->

### Frontend
<!-- REQUIRED if project has a frontend; mark OPTIONAL and leave blank if API-only -->
- **Framework:** <!-- e.g. Next.js 14 App Router, React 18 + Vite, Vue 3 -->
- **UI Library:** <!-- e.g. shadcn/ui + Tailwind CSS v4, Radix UI, Chakra UI -->
- **State Management:** <!-- e.g. Zustand, TanStack Query, Redux Toolkit, or "none" -->
- **Hosting:** <!-- e.g. Vercel, Netlify, or "AWS CloudFront" -->

### Infrastructure
<!-- REQUIRED -->
- **Cloud:** <!-- e.g. AWS, GCP, Azure, DigitalOcean, Hetzner -->
- **Compute:** <!-- e.g. ECS Fargate, Lambda, Railway, Fly.io -->
- **CI/CD:** <!-- e.g. GitHub Actions -->
- **Observability:** <!-- e.g. Sentry + Datadog, or Langfuse for LLM tracing -->
- **Secrets:** <!-- e.g. AWS Secrets Manager, Doppler, or ".env (local only)" -->

---

## Non-Negotiable Requirements

<!-- REQUIRED: List 4-8 hard constraints that agents must NEVER violate for this project.
     These override default Maxim behavior where relevant.
     Examples are given — replace with your actual requirements. -->

1. <!-- e.g. All API endpoints require authentication. No public endpoints without explicit approval. -->
2. <!-- e.g. PII must never be logged. Structured logs must redact email, phone, and user IDs. -->
3. <!-- e.g. All database migrations must be reversible. No destructive schema changes without a rollback script. -->
4. <!-- e.g. Response time SLA: p95 under 200ms for all user-facing API endpoints. -->
5. <!-- e.g. No third-party SDK added without security-analyst sign-off. -->

---

## Project-Specific Agent Rules

<!-- REQUIRED: At minimum fill in "All Work". Fill in other subsections if they apply. -->

### All Work
<!-- Rules that apply to every agent working on this project -->
- <!-- e.g. Read config/project-manifest.json before making any architectural decision. -->
- <!-- e.g. All commits follow Conventional Commits format: feat/fix/chore/documents/refactor. -->
- <!-- e.g. Never hardcode credentials, API keys, or environment-specific values. -->

### Security-Sensitive Tasks
<!-- Triggered for: auth, payments, PII handling, third-party integrations -->
- <!-- e.g. security-analyst must review any change to authentication or session management. -->
- <!-- e.g. All payment flows require PCI-DSS compliance check before merge. -->
- <!-- e.g. Penetration test coverage required before any new public endpoint goes live. -->

### Frontend Work
<!-- Triggered for: UI components, routing, form handling, state management -->
- <!-- e.g. All forms must have client-side and server-side validation. -->
- <!-- e.g. Accessibility: WCAG 2.1 AA minimum. Run axe-core before PR. -->
- <!-- e.g. No inline styles. All styling through Tailwind utility classes or design tokens. -->

### API Design
<!-- Triggered for: new endpoints, schema changes, versioning decisions -->
- <!-- e.g. All APIs follow RESTful conventions. No ad-hoc RPC-style endpoints. -->
- <!-- e.g. Every endpoint must have an OpenAPI 3.1 spec entry before implementation. -->
- <!-- e.g. Breaking changes require a new API version (v2, v3). No silent breaking changes. -->

---

## Brand Voice

<!-- REQUIRED for any project with customer-facing content. Used by content-strategist,
     copywriter, and CMO office agents. Fill in all 7 fields. -->

- **Tone:** <!-- e.g. Precise, confident, direct — never jargon-heavy or overly casual -->
- **Personality:** <!-- e.g. Expert guide, not a salesperson. Trusted peer, not a chatbot. -->
- **Audience:** <!-- e.g. Technical founders, senior engineers, CTOs -->
- **Core message:** <!-- One sentence: what you want every customer to understand -->
- **Tagline:** <!-- e.g. "AI that reasons, not just responds." -->
- **Avoid:** <!-- e.g. Hype language ("revolutionary", "game-changing"), vague claims, excessive exclamation marks -->
- **Emphasize:** <!-- e.g. Reliability, behavioral science depth, enterprise governance, time to value -->

---

## Build Phase Status

<!-- OPTIONAL: Track major build phases. Update Status as work progresses.
     Status values: Planned | In Progress | Complete | Blocked -->

| Phase | Days | Focus | Status |
|---|---|---|---|
| <!-- e.g. Phase 1: Foundation --> | <!-- e.g. 1-3 --> | <!-- e.g. Auth, database schema, core API skeleton --> | <!-- e.g. Complete --> |
| <!-- e.g. Phase 2: Core Features --> | <!-- e.g. 4-10 --> | <!-- e.g. Main product functionality, integrations --> | <!-- e.g. In Progress --> |
| <!-- e.g. Phase 3: Launch Hardening --> | <!-- e.g. 11-14 --> | <!-- e.g. Performance, security audit, observability --> | <!-- e.g. Planned --> |

---

## Domains

<!-- OPTIONAL: Declare all public-facing URLs. Used by security and devops agents.
     Copy confirmed values from config/project-manifest.json → domains. -->

| Domain | Purpose |
|---|---|
| <!-- e.g. yourapp.com --> | <!-- e.g. Marketing landing page --> |
| <!-- e.g. app.yourapp.com --> | <!-- e.g. Authenticated product UI --> |
| <!-- e.g. api.yourapp.com --> | <!-- e.g. REST API (public + authenticated) --> |

---

## Key Metrics

<!-- OPTIONAL: Define the numbers that matter for this project.
     Used by analytics-reporter and product-strategist agents to calibrate recommendations. -->

| Metric | Target |
|---|---|
| <!-- e.g. API p95 response time --> | <!-- e.g. < 200ms --> |
| <!-- e.g. Monthly active users (Month 3) --> | <!-- e.g. 500 MAU --> |
| <!-- e.g. Test coverage --> | <!-- e.g. > 80% --> |
| <!-- e.g. Error rate --> | <!-- e.g. < 0.5% of requests --> |
| <!-- e.g. Time to first value (onboarding) --> | <!-- e.g. < 5 minutes --> |

---

## Architecture Reference

<!-- Point agents to your architecture documents. All architecture docs live in documents/architecture/ (gitignored). -->
<!-- Tip: Declaring these here means agents will read them before making structural decisions. -->

| Document | Path | Purpose |
|---|---|---|
| System architecture | `documents/architecture/ARCHITECTURE.md` | Service map, data flow, decision log |
| Product requirements | `documents/architecture/PRD.md` | Product scope, features, acceptance criteria |
| Functional requirements | `documents/architecture/FRD.md` | Detailed functional specs per feature |
| System requirements | `documents/architecture/SRD.md` | Infrastructure, performance, security reqs |
| Build intake / secrets | `documents/architecture/.secrets/BUILD_INTAKE.md` | API keys, service URLs, env config (gitignored) |
| <!-- API reference --> | <!-- e.g. documents/API.md or openapi.yaml --> | <!-- All endpoint specs --> |
| <!-- Deployment guide --> | <!-- e.g. documents/DEPLOYMENT.md --> | <!-- Env setup, release procedure --> |

**Canonical folder structure:**
```
documents/
├── architecture/              ← PRD, FRD, SRD, ARCHITECTURE.md (gitignored)
│   └── .secrets/              ← build intakes, API keys, credentials (gitignored)
└── business/                  ← investor narrative, financial models
prototypes/                    ← v0 demos, POCs, throwaway builds
```

---

## Session Memory Storage

<!-- DO NOT REMOVE OR EDIT — required by CLAUDE.md session enforcement -->

- **Session files:** `.claude-sessions-memory/session-[YYYY-MM-DD].md`
- **Handoff state:** `.claude-sessions-memory/handoff.md`
- **Decision log:** `.claude-sessions-memory/decision-log.md`
- **Skill gaps:** `.claude-sessions-memory/skill-gaps.log`
- **Task plan:** `task_plan.md` (project root)
- **Progress:** `progress.md` (project root)

> All session writes go to `.claude-sessions-memory/` inside this project folder.
> Never write session or memory files to the global `%USERPROFILE%\.claude\` directory.

---

## Active Projects

<!-- REQUIRED: List all projects in this portfolio. One row per project.
     This must stay in sync with config/project-manifest.json → portfolio[]. -->

| ID | Project | Vertical | Compliance |
|---|---|---|---|
| `your-project-id` | Your Project Name | SaaS \| AI \| FinTech \| HealthTech \| Other | PIPEDA \| GDPR \| UAE-PDPL \| PCI-DSS \| HIPAA \| SOC2 |

**Source of truth:** `config/project-manifest.json`

---

## How to Complete This Setup

1. Fill in all `<!-- REQUIRED -->` sections above — delete instruction comments as you go
2. Fill in `config/project-manifest.json` (all fields marked `[REQUIRED]`)
3. Open this project in Claude Code
4. Run `/mxm-status` to confirm Maxim is loaded and compliance frameworks are detected
5. Run `/mxm-update` if your Maxim version is behind the registry version
6. Run `/mxm-behavior` if any agent rules need further customization
