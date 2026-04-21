# Maxim Bootstrap — SaaS Platform
## Maps To: FixIt · DrivingTutors.ca
## Pattern: Multi-sided marketplace / subscription SaaS

---

## ✅ PRE-FLIGHT CHECKLIST

Complete every item before writing a single line of code.

### 1. Identity
- [ ] Replace `{{PROJECT_NAME}}` throughout this folder
- [ ] Replace `{{PROJECT_DESCRIPTION}}` with 1-sentence mission
- [ ] Replace `{{TARGET_MARKET}}` (e.g., Canadian homeowners, driving students)
- [ ] Replace `{{PRIMARY_REVENUE_MODEL}}` (subscription / lead-gen / marketplace fee)

### 2. Maxim Skill Activation
- [ ] Confirm `.claude/skills/product/` is active for roadmap and prioritization
- [ ] Confirm `.claude/skills/engineering/` is active for all code tasks
- [ ] Confirm `.claude/skills/marketing/` is active for GTM and growth
- [ ] Confirm `.claude/skills/design/` is active for UX/UI work
- [ ] Confirm `.claude/skills/security/` is active — mandatory for auth, payments, PII
- [ ] Confirm `.claude/skills/compliance/` is active — PIPEDA mandatory for Canadian SaaS
- [ ] Confirm `.claude/skills/behavior-science-persuasion/` is active for onboarding and conversion flows

### 3. External References (alirezarezvani)
- [ ] `community-packs/claude-skills-library/engineering-team/` — backend + API references
- [ ] `community-packs/claude-skills-library/product-team/` — product management references
- [ ] `community-packs/claude-skills-library/marketing-skill/` — GTM and growth references
- [ ] `community-packs/claude-skills-library/ra-qm-team/` — QA and testing references

### 4. Workflow Patterns (Superpowers)
- [ ] `writing-plans` — use for every new feature spec
- [ ] `subagent-driven-development` — activate for parallel feature streams
- [ ] `test-driven-development` — mandatory for payment flows and auth
- [ ] `verification-before-completion` — mandatory before every PR merge

### 5. Planning Files (Seed These Now)
- [ ] Create `task_plan.md` using template below
- [ ] Create `findings.md` — start with known risks and constraints
- [ ] Create `progress.md` — start with MVP milestone list

### 6. Maxim to Activate
- [ ] `planner.md` — requirement analysis and sprint planning
- [ ] `implementer.md` — code generation
- [ ] `tester.md` — QA and integration testing
- [ ] `reviewer.md` — code review and architecture validation
- [ ] `security-analyst.md` — PIPEDA + payment compliance audit

### 7. Frameworks (from documents/reference/FRAMEWORKS_MASTER.md)
- [ ] Select onboarding framework — recommended: Fogg Behavior Model
- [ ] Select pricing framework — recommended: Jobs-to-Be-Done + Van Westendorp
- [ ] Select GTM framework — recommended: AARRR Pirate Metrics
- [ ] Select architecture framework — recommended: TOGAF lite for SaaS

---

## 📄 TASK PLAN SEED

```markdown
# {{PROJECT_NAME}} — Task Plan
Created: {{DATE}}
Project Type: SaaS Platform
Maxim Bootstrap: saas-platform

## Mission
{{PROJECT_DESCRIPTION}}

## Target Market
{{TARGET_MARKET}}

## Revenue Model
{{PRIMARY_REVENUE_MODEL}}

## MVP Milestones
- [ ] M1: Core user auth + onboarding
- [ ] M2: Primary marketplace/service flow
- [ ] M3: Payment integration (Stripe)
- [ ] M4: Provider/seller side
- [ ] M5: Search and discovery
- [ ] M6: Notifications and communication
- [ ] M7: Analytics dashboard
- [ ] M8: Beta launch

## Active Maxim Skills
- product, engineering, design, marketing
- security (mandatory), compliance (PIPEDA)
- behavior-science-persuasion (onboarding + conversion)

## Known Risks
- PIPEDA compliance for Canadian user data
- Payment gateway PCI-DSS scope
- Two-sided marketplace cold start problem
```

---

## 🚨 Maxim DISPATCH REMINDER

All tasks in this project follow the Maxim dispatch in `CLAUDE.md`.
Maxim skills are Layer 1. External sources are Layer 2 and below.
`security-analyst.md` is auto-looped on ALL payment, auth, and PII tasks.
