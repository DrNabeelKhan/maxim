# /mxm-compliance

## Usage
- Claude Code: `/mxm-compliance`
- Claude CLI: `claude "/mxm-compliance"`
- Claude Desktop: type `/mxm-compliance` in chat

Activates the CSO compliance cluster. Ethics gate active unless super_user mode.

**Triggers:** "compliance", "GDPR", "HIPAA", "SOC 2", "ISO 27001", "privacy", "regulatory"
**Office:** CSO → `security-analyst` (lead) → `compliance-officer` · `data-privacy-officer`
**Reads:** `.claude/skills/compliance/` · `config/project-manifest.json → compliance`
**Ethics gate:** active (suppressed if `super_user.enabled = true`)

## Behavior

1. Check `config/project-manifest.json → super_user.enabled`
2. If false: run ethics gate pre-check
3. Read declared compliance frameworks from `project-manifest.json → compliance`
4. Activate `compliance-officer` + `data-privacy-officer` + `ai-ethics-reviewer`
5. Apply `.claude/skills/compliance/` behavioral layer
6. Log any gaps to `.mxm-skills/agents-skill-gaps.log` with prefix `COMPLIANCE-GAP:`
7. Tag output: 🟢 HIGH | 🔵 SUPER USER (if super_user active)
