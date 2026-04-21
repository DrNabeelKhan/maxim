# Maxim Skill — Compliance

> Layer 1 — Supreme Authority | Executive Office: CSO

## Domain

GDPR, PIPEDA, CASL, EU AI Act, ISO 27001, ISO 14971, ISO 13485, SOC 2, HIPAA, WCAG 2.1, Bill 96, and full regulatory compliance lifecycle. Activates automatically — no explicit request needed — whenever output touches PII, regulated data, AI ethics, or localization law.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`security-analyst` — CSO Office (compliance arbitration role)

## Active Agents

- `compliance-officer` — regulatory compliance, audit preparation, policy enforcement, COMPLIANT/REMEDIATE/BLOCK status outputs
- `data-privacy-officer` — GDPR, PIPEDA, CASL, HIPAA data privacy enforcement and RoPA management
- `ai-ethics-reviewer` — EU AI Act, responsible AI governance, bias detection
- `legal-compliance-checker` — contract review, localization law (Bill 96), regulatory affairs

**Absorbed into this skill (fully merged, not separate agents):**
`gdpr-dsgvo-expert` · `iso27001` · `isms-audit` · `capa` · `risk-management` · `regulatory-affairs-head` · `fda-consultant` · `qms-iso13485`

## Skill Modes

- `COMPLIANT` — output meets all applicable regulatory requirements; cleared for deployment
- `REMEDIATE` — output has compliance gaps; remediation steps provided before deployment
- `BLOCK` — output violates compliance requirements; human review mandatory before any action

## Ethics Gate

`ethics_required: true` — BLOCK-status features require human review before deployment.
`ai-ethics-reviewer` has `ethics_required: true` — every AI system recommendation passes ethics gate.
CSO auto-loop: compliance skill activates on ANY task with security, compliance, PII, or regulated industry signals — regardless of which office initiated the task.
ISO 27001, GDPR Article 25 (privacy by design), and WCAG 2.1 AA applied as minimum baseline on all outputs.

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/ra-qm-team/` — GDPR, ISO 27001, ISMS audit, CAPA, risk management, regulatory affairs, FDA consultation, ISO 13485/QMS (fully absorbed)

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the compliance skill (auto-activation — no explicit request needed):

- `compliance review`, `regulatory compliance`, `audit preparation`, `policy enforcement`
- `GDPR`, `PIPEDA`, `CASL`, `HIPAA`, `SOC 2`, `ISO 27001`, `ISO 13485`, `EU AI Act`
- `PII`, `personal data`, `data subject rights`, `data processing agreement`
- `privacy policy`, `terms of service`, `data retention`, `right to erasure`
- `localization law`, `Bill 96`, `language compliance`
- `AI ethics`, `bias review`, `responsible AI`, `AI governance`
- `RoPA`, `audit trail`, `incident report`, `post-mortem`
- `FDA`, `medical device`, `regulated industry`, `healthcare compliance`

## Cross-Agent Auto-Loops

When compliance skill activates, the following agents are auto-notified:

- `security-analyst` — CSO lead, arbitrates compliance conflicts
- `data-privacy-officer` — auto-looped on all PII and data processing tasks
- `ai-ethics-reviewer` — auto-looped on all AI/ML outputs
- `legal-compliance-checker` — auto-looped on contract and regulatory affairs tasks
- `governance-specialist` — maintains RoPA and audit trails (CEO office)
- CEO arbitration via `enterprise-architect` — if compliance conflicts with strategic direction

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | compliance | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
