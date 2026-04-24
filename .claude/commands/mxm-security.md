---
description: Security review — dispatches to CSO office security-analyst with threat modeling, OWASP checklist, and compliance cross-reference.
---

# /mxm-security

## Usage
- Claude Code: `/mxm-security`
- Claude CLI: `claude "/mxm-security"`
- Claude Desktop: type `/mxm-security` in chat

Activates the CSO office. `security-analyst` leads. Ethics gate active unless super_user mode.

**Triggers:** "security audit", "pentest", "threat model", "compliance check", "vulnerability"
**Office:** CSO → `security-analyst` (lead)
**Reads:** `.claude/skills/security/` · `.claude/skills/compliance/`
**Ethics gate:** active (suppressed if `super_user.enabled = true`)

## Behavior

1. Check `config/project-manifest.json → super_user.enabled`
2. If false: run ethics gate pre-check per `documents/governance/ETHICAL_GUIDELINES.md`
3. Activate `security-analyst` → routes to: `threat-modeler` · `penetration-tester` ·
   `incident-responder` · `compliance-officer` · `data-privacy-officer`
4. Apply `.claude/skills/security/` + `.claude/skills/compliance/` behavioral layers
5. Log any gaps to `.mxm-skills/agents-skill-gaps.log` with prefix `SECURITY-GAP:`
6. Tag output: 🟢 HIGH | 🔵 SUPER USER (if super_user active)
