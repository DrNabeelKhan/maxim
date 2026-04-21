# Maxim Project-Specific Configuration

> **This file contains iSimplification.io-specific overrides.**
> Universal Maxim rules live in `CLAUDE.md`. This file only adds or overrides.
> When adopting Maxim for a new project, copy this file, rename it, and replace all content below.

**Project:** iSimplification.io
**Owner:** Dr. Nabeel Khan
**Last Updated:** March 2026

---

## Active Projects

All Maxim agents are aware of the following active projects under this portfolio:

| ID | Project | Vertical | Compliance |
|---|---|---|---|
| `isimplification` | iSimplification.io | AI / Enterprise SaaS | PIPEDA, SOC2 |
| `fixit` | FixIt | SaaS Marketplace | PCI-DSS, PIPEDA |
| `drivingtutors` | DrivingTutors.ca | EdTech / SaaS Marketplace | PIPEDA, PCI-DSS |
| `gulflaw` | GulfLaw.ai | LegalTech / AI | UAE-PDPL, GDPR |
| `sentinelflow` | SentinelFlow | Compliance / RegTech | PIPEDA, HIPAA, SOC2 |
| `qurangpt` | QuranGPT | AI / Islamic Tech | GDPR |

**Source of truth:** `config/project-manifest.json`

---

## Project Bootstrap Mapping

| Project Type | Template | Maps To |
|---|---|---|
| SaaS marketplace / platform | `bootstrap/saas-platform/` | FixIt, DrivingTutors.ca |
| AI agent service / LLM platform | `bootstrap/ai-agent-service/` | iSimplification |
| Regulatory compliance app | `bootstrap/compliance-app/` | SentinelFlow, GulfLaw.ai |
| API backend / microservice | `bootstrap/api-backend/` | Generic backend |

---

## Project-Specific Agent Rules

### Regulated Projects (SentinelFlow, GulfLaw.ai)
- All data access must be logged (who, what, when) — no exceptions
- Security Analyst `BLOCK` status requires human sign-off before any fix attempt
- Compliance loop is mandatory before any design or code handoff
- Planner must include compliance checkpoints in every `task_plan.md`

### Payment Projects (FixIt, DrivingTutors.ca)
- PCI-DSS scope reduction enforced: no card data in application layer
- Security Analyst must verify PCI compliance on every payment-related task
- Release Manager must include PCI scope note in every PR for payment features

### Mobile Projects (FixIt, DrivingTutors.ca, QuranGPT)
- Release Manager includes iOS/Android release notes in PR description
- Tester includes device compatibility in test summary

### AI/LLM Projects (iSimplification, QuranGPT)
- Prompt Engineer loops automatically on any LLM-facing feature
- AI Ethics Reviewer required on any model that processes personal data

---

## Brand Voice (iSimplification.io)

- Tone: Precise, confident, systems-thinking — never jargon-heavy
- Audience: Enterprise decision-makers, CTOs, compliance officers, regulators
- Core message: Complexity is not a barrier — it is an opportunity to streamline, optimize, and scale intelligence
- Avoid: Buzzwords without substance, vague claims, consumer-grade language

---

## How to Adopt This File for a New Project

1. Copy this file: `cp CLAUDE.project.md CLAUDE.project.YOUR-PROJECT.md`
2. Replace the Active Projects table with your project(s)
3. Remove iSimplification-specific sections
4. Add your project-specific agent rules, compliance requirements, and brand voice
5. Update `config/project-manifest.json` with your project data
6. Reference your project file in your repo's main `CLAUDE.md` or system prompt
