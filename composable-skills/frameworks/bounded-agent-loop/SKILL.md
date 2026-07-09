---
skill_id: bounded-agent-loop
name: Bounded Agent Loop
version: 1.0.0
category: operational
type: framework
frameworks: []
triggers:
  - apply bounded agent loop
  - use bounded-agent-loop framework
  - bounded agent loop analysis
collaborates_with:
  - planner
  - implementer
  - tester
  - reviewer
ethics_required: true
priority: medium
tags: [operational, framework]
created: 2026-07-08
updated: 2026-07-08
---

# Bounded Agent Loop

## Purpose
Run an agent task as a finite feedback loop with an explicit stop, not open-ended autonomy. Each iteration executes a bounded Observe → Choose → Act → Verify → Record → Repeat-or-stop cycle and exits into a named terminal state instead of drifting until "it looks good."

## Frameworks & Standards
| Item | Value |
|------|-------|
| Framework ID | `bounded-agent-loop` |
| Category | Operational |
| Version | 1.0.0 |
| Owner | Cybernetics / control theory (Wiener) — operationalized for agentic loops |
| Maturity | Emerging (2026) — codified into Maxim's `loops` skill v1.3.3 |
| Primary References | Explicit stopping conditions; named terminal states |

## Prompt Template
```
You are applying the Bounded Agent Loop framework.

CONTEXT:
- Current task: [[task_description]]
- Domain: operational
- Stakeholders: [[stakeholder_roles]]

FRAMEWORK APPLICATION:
1. **Define the cycle**: Frame the work as Observe → Choose → Act → Verify → Record → Repeat-or-stop.
2. **Set the stopping condition**: Pick a rubric, threshold, benchmark, reviewer decision, or finite scenario set — never "until it looks good"; no invented time/cost budgets.
3. **Run bounded iterations**: Each pass acts once, verifies, and records the result.
4. **Exit honestly**: Name the terminal state on exit — one of success · clean no-op · blocked · approval-required · exhausted · stagnated.

OUTPUT STRUCTURE:
- Loop Definition: The cycle and the explicit stopping condition
- Iterations: What each pass observed, chose, acted on, and verified
- Terminal State: The named exit condition and its evidence
- Limitations: Any constraints or assumptions in the application

QUALITY CHECKS:
□ A concrete stopping condition was defined before the loop ran
□ No time/cost budget was invented
□ The exit used one of the six named terminal states
□ Ethical considerations have been evaluated
```

## Core Principles
- **The cycle**: Every iteration runs Observe → Choose → Act → Verify → Record → Repeat-or-stop — a bounded feedback cycle, not open-ended autonomy.
- **Explicit stopping condition**: A rubric, threshold, benchmark, reviewer decision, or finite scenario set — never "until it looks good"; no invented time/cost budgets.
- **Named terminal states**: The loop exits into exactly one of `success` · `clean no-op` · `blocked` · `approval-required` · `exhausted` · `stagnated`, named honestly.
- **Documentation**: Record each iteration and the terminal state that ended the loop.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|----------|-------------|----------------|
| Loop composition (Planner) | Composes the loop + enforces the stop | Finite, auditable task execution |
| Per-iteration act (Implementer) | Executes the act step of each iteration | Incremental, verifiable progress |
| Coverage / quality streaks (Tester) | Coverage / quality-streak loops | Bounded testing to a defined threshold |
| Verification checkpoint (Reviewer) | Per-iteration verification checkpoint | Each pass validated before repeat-or-stop |

## Reference Materials
- [Forward-Future Loop Library](https://signals.forwardfuture.ai/loop-library/) - prior art, per ADR-007

## Usage Guidelines
- **Start with context**: Define the task and the stopping condition before the first iteration.
- **Adapt, don't adopt**: Choose the stopping-condition type (rubric/threshold/benchmark/reviewer/scenario set) that fits the task.
- **Document decisions**: Record what each iteration did and why the loop stopped.
- **Review outcomes**: Confirm the terminal state was named honestly, not forced to `success`.
- **Share learnings**: Contribute loop patterns back to the `loops` skill knowledge base.

## Collaboration Protocol
- Apply independently unless a task explicitly requires another skill or framework
- Use structured handoff format: [Context] -> [Framework Applied] -> [Open Questions] -> [Next Action]

## Ethical Guidelines
- ALWAYS name the true terminal state — never report `blocked` or `exhausted` as `success`
- NEVER invent a time or cost budget to justify stopping
- ALWAYS surface `approval-required` when a human decision is owed

## Success Metrics
- **Clarity**: The stopping condition is explicit and testable before the loop runs
- **Consistency**: Similar tasks use similar loop compositions
- **Stakeholder Alignment**: Terminal-state vocabulary improves cross-functional understanding
- **Outcome Quality**: Loops exit on real conditions, not vibes
- **Learning**: Loop patterns generate reusable stopping conditions

## Related Skills
- `loops` — the Maxim skill this framework was codified into (v1.3.3)
- `orchestrator` — composes bounded loops into autonomous workflows

## Testing Strategy
- Validate that a concrete stopping condition existed before the loop ran
- Review one real example and one edge case (e.g., a `stagnated` exit) before adopting the output
- Confirm the terminal state matches the evidence
- Document adjustments made when the framework needed adaptation for context

---
<sub>Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.  
SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years)  
See LICENSE at repo root. Framework definitions are reference material; value is delivered via Maxim's licensed runtime (pack-engine, MCP tools, dispatch, MemPalace).</sub>
