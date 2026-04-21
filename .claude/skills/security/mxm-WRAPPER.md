# Maxim Skill — Security

> Layer 1 — Supreme Authority | Executive Office: CSO

## Domain

Security analysis, threat modeling, penetration testing, incident response, compliance enforcement, data privacy, and AI ethics. The CSO auto-loop domain — activates automatically on any task containing security, compliance, PII, or regulated industry signals.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`security-analyst` — CSO Office

## Active Agents

- `security-analyst` — security audit, risk assessment, vulnerability scanning (absorbs `security-auditor` · `vulnerability-scanner` via Op-D)
- `threat-modeler` — threat analysis, threat intelligence, attack pattern mapping (absorbs `threat-analyst` via Op-D)
- `penetration-tester` — ethical penetration testing, bug bounty, vulnerability disclosure (absorbs `ethical-hacker` via Op-D)
- `incident-responder` — incident management, containment, post-incident review
- `compliance-officer` — regulatory compliance, audit preparation, policy enforcement
- `data-privacy-officer` — GDPR, PIPEDA, CASL, HIPAA privacy enforcement
- `ai-ethics-reviewer` — AI ethics review, bias detection, responsible AI governance
- `incident-post-mortem-writer` — post-incident documentation and learning capture
- `security-architect` — secure system design (CTO office, routes here for security architecture tasks)

## Skill Modes

Sub-skill SKILL.md files per specialist. Key modes:
- `security-analyst` → Audit · Scan (Op-D absorbed modes from `security-auditor` · `vulnerability-scanner`)
- `threat-modeler` → Analysis · Modeling (Op-D absorbed from `threat-analyst`)
- `penetration-tester` → Standard · Ethics-Framed (Op-D absorbed from `ethical-hacker`)
- `compliance-officer` → COMPLIANT · REMEDIATE · BLOCK

## Ethics Gate

`ethics_required: true` for `penetration-tester` and `ai-ethics-reviewer` — authorized context required.
`penetration-tester` — engagement authorization must be confirmed before any offensive testing output.
`ai-ethics-reviewer` — every AI system output must pass ethics review before deployment recommendation.
OWASP Top 10, NIST Cybersecurity Framework, and ISO 27001 enforced as baseline standards.
BLOCK-status outputs require human review before any deployment action.

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/engineering-team/senior-security` — consumed by `security-architect` · `threat-modeler` · `compliance-officer` · `data-privacy-officer`
- `community-packs/claude-skills-library/engineering-team/senior-secops` — consumed by `incident-responder` · `security-analyst` · `incident-post-mortem-writer`
- `community-packs/claude-skills-library/engineering-team/incident-commander` — consumed by `incident-responder` · `infrastructure-maintainer`
- `community-packs/claude-skills-library/ra-qm-team/` — ISMS, ISO 27001, risk management, audit frameworks

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the security skill (CSO auto-loop — no explicit request needed):

- `security audit`, `compliance assessment`, `security review`, `risk assessment`
- `vulnerability scan`, `dependency check`, `CVE monitoring`, `security scanning`
- `penetration test`, `ethical hacking`, `vulnerability testing`, `security testing`
- `bug bounty`, `vulnerability disclosure`, `security research`
- `threat analysis`, `threat intelligence`, `threat hunting`, `attack patterns`
- `compliance review`, `regulatory compliance`, `audit preparation`, `policy enforcement`
- `PII`, `personal data`, `data privacy`, `GDPR`, `HIPAA`, `regulated industry`
- `auth`, `authentication`, `authorization`, `payment`, `encryption`

## Cross-Agent Auto-Loops

When security skill activates, the following agents are auto-notified:

- `security-analyst` — CSO lead, notified on ALL tasks with security/PII signals (auto-loop rule)
- `compliance-officer` — auto-looped on regulated industry tasks
- `data-privacy-officer` — auto-looped when PII or data privacy signals present
- `ai-ethics-reviewer` — auto-looped on all AI/ML system outputs
- `incident-responder` — auto-looped on active incident signals
- CEO arbitration via `enterprise-architect` — if security conflicts with strategic direction

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | security | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
