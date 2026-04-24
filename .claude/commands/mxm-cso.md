---
description: Routes to the CSO Office. Lead: security-analyst. Scope: security, compliance, privacy, ethics, risk, incident response.
---

# /mxm-cso

## Usage
- Claude Code: `/mxm-cso`
- Claude CLI: `claude "/mxm-cso"`
- Claude Desktop: type `/mxm-cso` in chat

Routes to CSO Office. Lead: `security-analyst`.
Scope: security · compliance · privacy · risk · ethics · threat modeling · incident response
Ethics gate: active (suppressed if `super_user.enabled = true`)

## Behavior
1. Check `config/project-manifest.json → super_user.enabled`
2. If false: run ethics gate pre-check per `documents/governance/ETHICAL_GUIDELINES.md`
3. Activate `security-analyst` as lead
4. Read `.claude/skills/security/` · `.claude/skills/compliance/`
5. Apply CSO office roster (9 agents):
   `threat-modeler` · `penetration-tester` · `incident-responder` · `compliance-officer` ·
   `ai-ethics-reviewer` · `data-privacy-officer` · `legal-compliance-checker` ·
   `incident-post-mortem-writer`
6. CSO auto-loop: activates automatically on any security/compliance/PII signal
7. Log gaps to `.mxm-skills/agents-skill-gaps.log` with prefix `SECURITY-GAP:`
8. Tag output: 🟢 HIGH | 🔵 SUPER USER (if super_user active)
