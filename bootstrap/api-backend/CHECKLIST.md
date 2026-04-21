# Maxim Bootstrap — API Backend / Microservice
## Maps To: Generic backend, standalone API, microservice
## Pattern: API-first backend service

---

## ✅ PRE-FLIGHT CHECKLIST

### 1. Identity
- [ ] Replace `{{PROJECT_NAME}}` throughout this folder
- [ ] Replace `{{PROJECT_DESCRIPTION}}` with 1-sentence mission
- [ ] Replace `{{API_TYPE}}` (REST / GraphQL / gRPC / WebSocket)
- [ ] Replace `{{DEPLOYMENT_TARGET}}` (Heroku / DigitalOcean / Vercel / AWS)
- [ ] Replace `{{PRIMARY_CONSUMERS}}` (internal / external / mobile / third-party)

### 2. Maxim Skill Activation
- [ ] Confirm `.claude/skills/engineering/` is active — PRIMARY skill for this template
- [ ] Confirm `.claude/skills/security/` is active — API auth, rate limiting, input validation
- [ ] Confirm `.claude/skills/testing/` is active — contract testing, integration testing
- [ ] Confirm `.claude/skills/enterprise-architecture/` is active — API design standards
- [ ] Confirm `.claude/skills/project-management/` is active — sprint and delivery planning

### 3. External References (alirezarezvani)
- [ ] `community-packs/claude-skills-library/engineering-team/` — PRIMARY reference for this template
- [ ] `community-packs/claude-skills-library/POWERFUL/` — advanced engineering patterns
- [ ] `community-packs/claude-skills-library/ra-qm-team/` — API testing and QA references

### 4. Workflow Patterns (Superpowers)
- [ ] `test-driven-development` — mandatory for all API endpoints
- [ ] `writing-plans` — for API design and contract specification
- [ ] `systematic-debugging` — for integration failures and edge cases
- [ ] `verification-before-completion` — before every deployment
- [ ] `finishing-a-development-branch` — before every PR merge

### 5. Planning Files (Seed These Now)
- [ ] Create `task_plan.md` using template below
- [ ] Create `findings.md` — start with API contract decisions and dependency list
- [ ] Create `progress.md` — start with endpoint delivery milestones

### 6. Maxim to Activate
- [ ] `implementer.md` — PRIMARY agent for this template
- [ ] `tester.md` — API contract and integration testing
- [ ] `reviewer.md` — code review and API design validation
- [ ] `security-analyst.md` — auth flows, rate limiting, injection prevention

### 7. Frameworks (from documents/reference/FRAMEWORKS_MASTER.md)
- [ ] Select API design framework — recommended: REST maturity model (Richardson)
- [ ] Select testing framework — recommended: Consumer-driven contract testing
- [ ] Select deployment framework — recommended: 12-factor app methodology

---

## 📄 TASK PLAN SEED

```markdown
# {{PROJECT_NAME}} — Task Plan
Created: {{DATE}}
Project Type: API Backend
Maxim Bootstrap: api-backend
API Type: {{API_TYPE}}
Deployment: {{DEPLOYMENT_TARGET}}

## Mission
{{PROJECT_DESCRIPTION}}

## Primary Consumers
{{PRIMARY_CONSUMERS}}

## MVP Milestones
- [ ] M1: Core data models and schema
- [ ] M2: Authentication and authorization
- [ ] M3: Primary resource endpoints (CRUD)
- [ ] M4: Input validation and error handling
- [ ] M5: Rate limiting and security hardening
- [ ] M6: Integration tests and contract tests
- [ ] M7: API documentation (OpenAPI/Swagger)
- [ ] M8: Deployment pipeline and monitoring

## Active Maxim Skills
- engineering (PRIMARY — full alirezarezvani match via engineering-team/ + POWERFUL/)
- security, testing, enterprise-architecture

## Known Risks
- API versioning strategy for breaking changes
- Auth token security and refresh flow
- Rate limiting bypass vectors
```

---

## 🚨 Maxim DISPATCH REMINDER

`engineering/` domain has FULL alirezarezvani match via `engineering-team/` + `POWERFUL/`.
This template benefits most from the Maxim + alirezarezvani merge — deepest external reference coverage.
`security-analyst.md` is auto-looped on ALL auth, rate limiting, and data access tasks.
