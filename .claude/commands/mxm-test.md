# /mxm-test

## Usage
- Claude Code: `/mxm-test`
- Claude CLI: `claude "/mxm-test"`
- Claude Desktop: type `/mxm-test` in chat

Activates the `tester` orchestrator and COO testing agents.

**Triggers:** "test this", "run tests", "write tests", "QA", "coverage"
**Office:** Orchestrators → `tester` · COO testing agents
**Reads:** `.claude/skills/testing/` · `task_plan.md`
**Chains to:** `/mxm-release` on pass

## Behavior

1. Activate `tester` — classify test type (unit · integration · E2E · load)
2. Apply `.claude/skills/testing/` behavioral layer
3. Route to specialist: `api-tester` · `load-tester` · `test-data-generator`
4. Append results to `progress.md`
5. Fail signals → back to `/mxm-implement` with findings
6. Pass signals → hand off to `release-manager` via `.mxm-skills/agents-handoff.md`
7. Tag output: 🟢 HIGH
