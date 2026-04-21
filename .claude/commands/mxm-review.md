# /mxm-review

## Usage
- Claude Code: `/mxm-review`
- Claude CLI: `claude "/mxm-review"`
- Claude Desktop: type `/mxm-review` in chat

Activates the `reviewer` orchestrator. Reads `findings.md` and implementation output.

**Triggers:** "review this", "check my code", "review before merge", "code review"
**Office:** Orchestrators → `reviewer`
**Reads:** `findings.md` · `.claude/skills/engineering/` · `.claude/skills/testing/`
**Chains to:** `/mxm-test` on approval

## Behavior

1. Read `findings.md` for accumulated context
2. Activate `reviewer` — apply Maxim review standards
3. Check against frameworks in `documents/reference/FRAMEWORKS_MASTER.md`
4. Flag security signals → notify `security-analyst` (CSO auto-loop)
5. Write review findings to `findings.md`
6. On approval: hand off to `tester` via `.mxm-skills/agents-handoff.md`
7. Tag output: 🟢 HIGH
