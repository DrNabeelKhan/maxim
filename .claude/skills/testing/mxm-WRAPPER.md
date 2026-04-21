# Maxim Skill — Testing

> Layer 1 — Supreme Authority | Executive Office: COO

## Domain

API testing, load testing, test data generation, workflow optimization, tool evaluation, and QA validation. The COO's quality assurance domain — the `tester` orchestrator uses this skill for all cross-cutting QA workflows.

## Dispatch Rule

Maxim agents check this skill FIRST before community-packs/ or composable-skills/.
If this skill activates → Maxim behavioral layer wins all conflicts.
Confidence tag: 🟢 HIGH (Maxim skill matched + behavioral layer applied)

## Lead Agent

`tester` — COO Office (orchestrator for all QA workflows)

## Active Agents

- `api-tester` — API testing, endpoint validation, contract testing, API quality assurance
- `load-tester` — performance stress testing, concurrency testing, capacity planning, load simulation
- `test-data-generator` — synthetic test data creation, data masking, test fixture generation
- `workflow-optimizer` — workflow optimization, process improvement, bottleneck removal, efficiency analysis
- `tool-evaluator` — QA tool assessment, testing platform selection, automation framework evaluation
- `experiment-tracker` — A/B test management, experiment hypothesis tracking, result analysis

**Op-C Skill DNA mode (embedded in testing/SKILL.md):**
- Mode: Results Analysis — from `test-results-analyzer`

## Skill Modes

Sub-skill SKILL.md files per specialist. Key modes:
- `api-tester` → Functional · Contract · Integration · API Validation
- `load-tester` → Stress · Concurrency · Capacity · Spike Testing
- `test-data-generator` → Synthetic Data · Data Masking · Fixtures · Seed Data
- `workflow-optimizer` → Process Mapping · Bottleneck Analysis · Efficiency
- `tool-evaluator` → QA Tools · Automation Frameworks · Platform Selection
- `experiment-tracker` → Hypothesis · A/B Design · Result Analysis · Iteration
- testing/SKILL.md → Results Analysis (Op-C: absorbed from `test-results-analyzer`)

## Ethics Gate

None. Standard Maxim behavioral output quality applies.
Note: When test data involves real PII or production data — compliance skill auto-looped immediately (CSO auto-loop rule). `test-data-generator` must use synthetic/masked data by default; never real user PII.

## External Sources Consumed

Layer 2 (community-packs/):
- `community-packs/claude-skills-library/ra-qm-team/` — QA frameworks, test plan templates, quality management standards, validation methodologies
- `community-packs/claude-skills-library/engineering-team/` — engineering test patterns, unit/integration test conventions

Conflict resolution: Maxim ALWAYS WINS

## Triggers (auto-activation signals)

Any task matching these phrases activates the testing skill:

- `API testing`, `endpoint validation`, `contract testing`, `API quality`
- `load testing`, `stress testing`, `performance testing`, `concurrency testing`
- `test data`, `synthetic data`, `data masking`, `test fixtures`
- `workflow optimization`, `process improvement`, `bottleneck removal`, `efficiency`
- `tool evaluation`, `QA tools`, `automation framework`, `testing platform`
- `A/B testing`, `experiment tracking`, `experiment design`, `hypothesis testing`
- `QA`, `quality assurance`, `test coverage`, `regression testing`
- `test results`, `results analysis`, `test report`

## Cross-Agent Auto-Loops

When testing skill activates, the following agents are auto-notified:

- `tester` — COO lead orchestrator for all QA workflows
- `implementer` — CTO lead notified for engineering test implementation
- `engineering` skill — auto-looped when testing requires code changes or test scaffolding
- `release-manager` — auto-looped when testing gates a release or deployment
- `experiment-tracker` — auto-looped for A/B test and experiment management tasks
- `compliance` skill — auto-looped immediately if test data involves PII (CSO auto-loop rule)
- `security-analyst` — auto-looped for security testing tasks (CSO auto-loop rule)

## Skill Gap Logging

If this domain has NO matching Maxim skill for a sub-task:
→ Log to .mxm-skills/agents-skill-gaps.log format:
[YYYY-MM-DD HH:MM] | testing | {task-description} | {suggested-skill-name} | {project}

## Source of Truth

config/agent-registry.json v3.2.1 | documents/reference/SKILLS_MAP.md | CLAUDE.md
Maintained by: DrNabeelKhan | iSimplification.io
Last updated: 2026-03-18
