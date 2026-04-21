# Maxim Bootstrap — Compliance App
## Maps To: SentinelFlow · GulfLaw.ai
## Pattern: Regulated-industry application (legal, healthcare, finance, government)

---

## ✅ PRE-FLIGHT CHECKLIST

### 1. Identity
- [ ] Replace `{{PROJECT_NAME}}` throughout this folder
- [ ] Replace `{{PROJECT_DESCRIPTION}}` with 1-sentence mission
- [ ] Replace `{{REGULATORY_FRAMEWORK}}` (e.g., GDPR, HIPAA, PCI-DSS, UAE PDPL, Canadian PIPEDA)
- [ ] Replace `{{JURISDICTION}}` (e.g., Canada, UAE/MENA, USA)
- [ ] Replace `{{PRIMARY_REVENUE_MODEL}}` (SaaS / managed service / licensing)

### 2. Maxim Skill Activation
- [ ] Confirm `.claude/skills/compliance/` is active — PRIMARY skill ⚠️ PARTIAL alirezarezvani match
- [ ] Confirm `.claude/skills/security/` is active — mandatory for all regulated data
- [ ] Confirm `.claude/skills/enterprise-architecture/` is active — audit trail and data architecture
- [ ] Confirm `.claude/skills/engineering/` is active — backend and API
- [ ] Confirm `.claude/skills/product-development-research/` is active — regulatory research
- [ ] Confirm `.claude/skills/behavior-science-persuasion/` is active — compliance UX friction reduction

### 3. External References (alirezarezvani)
- [ ] `community-packs/claude-skills-library/ra-qm-team/` — QA/QM checklists (partial compliance match)
- [ ] `community-packs/claude-skills-library/engineering-team/` — security and backend references
- [ ] `community-packs/claude-skills-library/c-level-advisor/` — enterprise risk and governance references
- [ ] NOTE: Regulatory compliance framing (GDPR, HIPAA, PDPL) is Maxim-only — ra-qm-team covers QA only

### 4. Workflow Patterns (Superpowers)
- [ ] `writing-plans` — mandatory for every compliance feature spec
- [ ] `test-driven-development` — mandatory for all compliance logic
- [ ] `systematic-debugging` — for compliance rule validation and edge cases
- [ ] `verification-before-completion` — double-mandatory: legal liability at stake
- [ ] `subagent-driven-development` — for parallel legal research + implementation streams

### 5. Planning Files (Seed These Now)
- [ ] Create `task_plan.md` using template below
- [ ] Create `findings.md` — start with regulatory framework analysis and jurisdiction map
- [ ] Create `progress.md` — start with compliance milestone list (not feature list)

### 6. Maxim to Activate
- [ ] `planner.md` — compliance roadmap and regulatory milestone planning
- [ ] `implementer.md` — compliance rule engine implementation
- [ ] `tester.md` — regulatory edge case testing + audit trail verification
- [ ] `security-analyst.md` — PRIMARY agent for this template — every output reviewed
- [ ] `reviewer.md` — architecture review for data residency and audit compliance

### 7. Frameworks (from documents/reference/FRAMEWORKS_MASTER.md)
- [ ] Select compliance framework — required: match to `{{REGULATORY_FRAMEWORK}}`
- [ ] Select risk framework — recommended: ISO 31000 or NIST CSF
- [ ] Select UX framework — recommended: EAST (Easy, Attractive, Social, Timely) for compliance UX
- [ ] Select architecture framework — recommended: Zero-trust + audit-by-default

---

## 📄 TASK PLAN SEED

```markdown
# {{PROJECT_NAME}} — Task Plan
Created: {{DATE}}
Project Type: Compliance Application
Maxim Bootstrap: compliance-app
Regulatory Framework: {{REGULATORY_FRAMEWORK}}
Jurisdiction: {{JURISDICTION}}

## Mission
{{PROJECT_DESCRIPTION}}

## Revenue Model
{{PRIMARY_REVENUE_MODEL}}

## Compliance Milestones (not feature milestones)
- [ ] C1: Regulatory framework analysis and gap assessment
- [ ] C2: Data classification and residency architecture
- [ ] C3: Audit trail design and implementation
- [ ] C4: Consent management and data subject rights
- [ ] C5: Automated compliance monitoring engine
- [ ] C6: Reporting and evidence generation
- [ ] C7: Penetration testing and security audit
- [ ] C8: Legal review and certification readiness

## Active Maxim Skills
- compliance (PARTIAL alirezarezvani — regulatory framing is Maxim-only)
- security (mandatory — security-analyst auto-loops on every output)
- enterprise-architecture, engineering
- behavior-science-persuasion (compliance UX — reducing friction without reducing rigor)

## Known Risks
- Jurisdiction conflicts (multi-region data residency)
- Regulatory interpretation gaps (Maxim-only — no alirezarezvani backup)
- Audit trail tampering vectors
- Legal liability from incorrect compliance classification
```

---

## 🚨 Maxim DISPATCH REMINDER

`compliance/` domain has PARTIAL alirezarezvani match only.
Regulatory framing (GDPR, HIPAA, PDPL, PIPEDA) is Maxim-authored exclusively.
`security-analyst.md` is auto-looped on EVERY output in this project type.
Do NOT mark any compliance task 🟢 HIGH confidence without `security-analyst.md` sign-off.
