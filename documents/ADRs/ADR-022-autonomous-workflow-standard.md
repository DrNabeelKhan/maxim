# ADR-022 — Autonomous Workflow Standard (Unattended Workflow Contract + `mxm-orchestrator`)

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-06-26
- **Deciders:** Mr. Khan (operator) · CEO office / enterprise-architect · COO office / planner (owns `loops` + scheduling)
- **Related:** ADR-002 (executable contracts) · ADR-007 (framework citation) · ADR-010 (confidence tagging) · ADR-017 (office-as-dispatch-boundary) · ADR-018 (external-tool integration) · ADR-021 (default-on router) · ADR-020 (PaaS governed-autonomy direction, confidential) · `loops` skill (v1.3.3) · `usage-aware-scheduler` skill (v1.0.0)

---

## Context

Maxim governs **interactive** work well — the dispatch sequence, the office routing, the `loops` skill, the confidence/framework/CSO overlay all assume an operator is present and watching. But Maxim's **unattended** automation grew piecemeal: the `usage-aware-scheduler` + `/mxm-tasks`, `/mxm-ceo-morning`, Proactive Watch, the `scheduled-tasks` MCP, and the `loops` catalog each invented their own trigger mechanism, their own state file, and their own log shape (`scheduler-events.jsonl`, `handoff-history.jsonl`, `watch-report.jsonl`, …). There is **no single contract** an unattended workflow conforms to, and therefore no shared guarantees: a scheduled run can over-spend, double-send, or fail silently, and nothing structurally prevents it.

This is the dangerous case. An interactive loop that misbehaves gets caught by the human in the chair — which is exactly why the `loops` skill is deliberately permissive about budgets ("if the operator gave no limit, use a no-progress stop; **do NOT invent time/iteration/cost budgets**"). An *unattended* workflow has no human in the chair. The one place Maxim is least bounded is the one place a runaway, a duplicate publish, or a swallowed error does the most damage.

The **50-Autonomous-Workflows build standard** (operator's internal reference) codifies the discipline the industry converged on for Opus-4.8-class unattended agents: every workflow is exactly three layers (**Trigger → Capable Agent(s) → Verification**), every workflow carries mandatory budget guards + persistent state + error handling + idempotency + a `--dry-run` default, and all workflows plug into **one central orchestrator** built first. An audit of Maxim against that standard (2026-06-26) found Maxim already satisfies ~65% of it — the three-layer dispatch (ADR-017), maker-checker verification (`pre-release-audit` + `reviewer` + `tester` + Proactive Watch), triggers/scheduling (`usage-aware-scheduler`), escalation (`handoff-coordinator`), and a registry (`mxm-catalog`). The missing ~35% is the part that makes the rest *trustworthy unattended*: a **formal Workflow contract** and the **orchestrator** that owns per-run budget guards, a unified run-log, a state store, a dead-letter path, and dry-run enforcement.

This decision is also load-bearing for the governed-autonomy product direction (ADR-020, confidential): "autonomy a regulated buyer can trust" *is* bounded-budget + audit-log + dry-run + independent verification. The standard below is the engineering substrate of that thesis.

---

## Decision

Maxim adopts an **Autonomous Workflow Standard**. Any **unattended** workflow — one a trigger fires without a human present (schedule, file drop, webhook, queue/event, or a `loops` run launched to completion without supervision) — MUST conform to the standard. Interactive, operator-present loops remain governed by the `loops` skill and are explicitly **out of scope** (they keep the no-invent-budget rule).

The standard has five parts:

**1. The three-layer shape (non-negotiable).** Every unattended workflow is exactly: **Trigger → Capable Agent(s) → Verification**, where Verification is a *separate* gate (second-agent checker, rule validator, test suite, or human-review queue). **No unattended output reaches a human or goes live without passing the verification layer.** A workflow whose verification spec is missing is **rejected** (an Executable Contract per ADR-002 — the checker is written before the maker).

**2. The `Workflow` contract.** Every workflow implements a single interface the orchestrator understands:

```
Workflow {
  id                          # stable, unique — the registry key
  trigger()                   # schedule | file | webhook | queue | manual
  run(context) -> output      # the maker (router→maker→checker model tiers)
  verify(output) -> pass | fail | escalate
  budget                      # BudgetGuard limits (see part 3)
  idempotency_key(context)    # dedup key — re-firing must not double-act
  on_fail(error)              # retry policy → dead-letter on exhaustion
  dry_run = true              # default ON until operator approves go-live
}
```

**3. Mandatory per-run guards.** Regardless of workflow size, the orchestrator enforces:
- **BudgetGuard** — `max_tokens`, `max_tool_calls`, `max_runtime_s`, `max_cost_usd`. **Hard-kill on breach**, terminal state `exhausted`, dead-letter the run. (Composes with — does not replace — the `usage-aware-scheduler` OAuth usage gate, which throttles *when* work runs; BudgetGuard bounds *how much* a single run may consume.)
- **StateStore** — run/step persistence + idempotency keys under `.mxm-skills/workflows/runs/`. Re-firing a trigger with a seen idempotency key is a no-op (no double-send / double-publish / double-charge).
- **Unified RunLog** — one structured JSON record per step appended to `.mxm-skills/runlog.jsonl`: `{run_id, workflow_id, ts, step, model, tokens, cost_usd, tool_calls, verdict, output_ref, terminal_state}`. This supersedes the per-automation ad-hoc `.jsonl` shapes (which migrate to it).
- **Dead-letter** — on repeated failure, the run lands in `.mxm-skills/workflows/dead-letter/` with full context; the `handoff-coordinator` / executive-router routes it to the human review queue (`.mxm-skills/review-queue.md`).
- **Dry-run default ON** — every side-effectful (🟡/🔴) workflow ships `dry_run = true` until the operator explicitly approves go-live. No sends/trades/publishes/destructive writes unattended without an explicit human-approval gate.

**4. The central `mxm-orchestrator`** (extends the `loops` skill; COO `planner` owns it). One orchestrator all workflows register with. It: registers workflows (Registry), fires triggers, runs Trigger→Agent→Verify, enforces the guards in part 3, persists state, handles retries/dead-letter, routes escalations to the existing `handoff-coordinator`, and writes the unified RunLog. Implementation follows the `usage-aware-scheduler` precedent — a SKILL-governed contract driving dispatch, with helper scripts where determinism is required — **not** an external workflow engine. Its **acceptance test** (per the standard): a no-op workflow that intentionally breaches each guard (token, call, runtime, cost) → confirm clean hard-stop + dead-letter + log, **nothing sent externally**.

**5. The behavioral + governance overlay is layered on top, non-negotiable.** Every workflow inherits Maxim's overlay: confidence tagging on each step + terminal state (ADR-010), framework citation for the pattern it embodies (ADR-007), **CSO auto-loop** on any regulated/PII/data workflow (`security-analyst` gates every step; no secrets/PII into logs), the **no-fabrication** rule (every rate carries its sample size), and the `loops` cardinal rule: **never report `error`, `blocked`, `exhausted`, or `stagnated` as `success`.**

Authoring is governed by the standard's **10-section build template** (wrong-output spec · trigger spec · agent design · budget guards · verification logic · state/logging schema · error & recovery · runnable code · deployment · safety guardrails), surfaced by a `/mxm-workflow` scaffolding skill. A workflow missing any section — the verification spec first — is not registrable.

---

## Rationale

- **Unattended is the case that needs the guards — interactive is the case that doesn't.** The `loops` skill's "don't invent budgets" rule is correct *because a human is watching*. This ADR inverts it for the unattended case for the same reason: the human is gone, so the budget, the verification gate, and the dry-run are the only things standing between a scheduled run and an expensive or irreversible mistake. The two contracts are complementary, not contradictory — and naming the boundary (operator-present → `loops`; unattended → this standard) is itself the clarifying decision. 🟢
- **Extend, don't reinvent.** Maxim is ~65% there. `mxm-orchestrator` is a thin unifying layer over `loops` (terminal-state taxonomy, independent verification), `usage-aware-scheduler` (throttle), `handoff-coordinator` (escalation), `mxm-catalog` (registry), and Proactive Watch (a standing verification workflow). The standard converges the scattered automations onto one contract; it does not import a foreign framework. 🟢
- **Ratify the contract first — Maxim's discipline.** The source standard says "build the orchestrator FIRST." Maxim's meta-rule is stronger: *ratify the architecture as an ADR, then build*. The contract is the load-bearing artifact; once accepted it governs the orchestrator, the `/mxm-workflow` scaffolder, and every workflow — and `pre-release-audit` can check conformance (ADR-002). Drafting it as `proposed` is cheap and fully reversible. 🟢
- **Executable Contract, not aspiration.** The 10-section template + the guard-breach acceptance test make the standard *enforceable*: a workflow without a verification spec is rejected at authoring time, and the orchestrator's hard-kill is testable. This is ADR-002 applied to automation. 🟢
- **Same conservative posture as the router (ADR-021).** Dry-run default ON + explicit human-approval gate for side-effects mirrors the router's "inject only on a confident match, opt-out always available." Maxim's default for any autonomous action is the safe one; the operator opts *into* live side-effects, never out of safety. 🟢
- **It is the PaaS on-ramp.** Governed autonomy — bounded budget, full audit trail, dry-run, independent verification — is exactly the regulated-buyer thesis (ADR-020). The `champion-challenger` loop is already flagged as the self-improvement flywheel; the orchestrator is the substrate that makes such a loop safe to run unattended. 🟡

---

## Consequences

**Makes easier:**
- Every *new* automation inherits budget guards, idempotency, state, dry-run, and structured logging for free by implementing one contract — instead of re-deriving them ad-hoc.
- Unattended runs become **auditable and bounded**: one queryable RunLog, one dead-letter path, one place escalations land. A buyer/auditor question ("what does your autonomy do unsupervised?") has a one-line answer: bounded, logged, dry-runnable, independently verified.
- The 50-workflow catalog becomes addressable — each one is a `Workflow` the orchestrator runs, packaged per office.
- The `loops` ↔ unattended boundary is finally explicit, removing a real ambiguity about when budgets apply.

**Makes harder / costs:**
- Every unattended workflow now MUST ship the verification layer + all 10 template sections — more upfront work. This is intentional friction (the standard rejects the un-verified workflow on purpose).
- A new orchestrator surface to build and maintain, plus a `/mxm-workflow` scaffolder and the unified RunLog schema.
- The existing automations need migration onto the contract (see below) — not free, but incremental.

**Migration shape (incremental, one at a time, prove ~7 days each):**
- `usage-aware-scheduler` → stays as the throttle layer; gains a thin `Workflow`-conformant wrapper so scheduled tasks carry a BudgetGuard + idempotency key and log to the unified RunLog.
- Proactive Watch → re-expressed as a standing read-only (🟢) `Workflow` (it already has a verification model — the 12 drift classes — and is the canonical migration exemplar).
- `/mxm-ceo-morning` → a scheduled 🟢 `Workflow` (daily-brief; verification = the review-queue triage it already does).
- Per-automation `.jsonl` logs → fold into `.mxm-skills/runlog.jsonl` (keep the old files until readers migrate).

**Locks in:** the `Workflow` contract as the interface for all unattended automation, and `mxm-orchestrator` as the single enforcement point. **Reversal shape:** workflows are plain dispatch functions under the contract, so the standard can be *loosened* by relaxing the orchestrator's guard enforcement (config), and *removed* by retiring the orchestrator and letting automations run standalone again — no data migration, only a governance downgrade. The contract is additive; nothing it wraps stops working without it.

**Rollout phases (post-ratification; v1.3.8 candidate):**
- **Phase 0** — this ADR `proposed` → `accepted`.
- **Phase 1** — `mxm-orchestrator` MVP: contract + BudgetGuard + StateStore + unified RunLog + Registry + dead-letter, dry-run default ON, **plus the guard-breach acceptance test** (the gate that proves the orchestrator before any real workflow runs on it). ✅ **BUILT + PROVEN 2026-06-26 — acceptance test 29/29 PASS** (`orchestrator/engine.mjs` · `orchestrator/acceptance-test.mjs` · skill `.claude/skills/orchestrator/SKILL.md` · command `/mxm-workflow`).
- **Phase 2** — first 🟢 workflow end-to-end through the 10-section template (candidate: formalize Proactive Watch, #50 brand-consistency, or #2 competitor-monitor — read-only, instant before/after, easy verification). Prove 7 days reliable.
- **Phase 3** — migrate the existing automations (above), one at a time; ship `/mxm-workflow` scaffolder.

---

## Alternatives considered

- **Status quo — keep each automation ad-hoc.** Rejected: no shared guards, every new automation re-derives state/logging, no unified audit trail, and unattended runs stay structurally unbounded — the exact risk this ADR exists to close.
- **Adopt an external orchestration engine (Temporal / Airflow / n8n / Prefect).** Rejected: heavy non-model-native infrastructure, an operational dependency that contradicts the "runs inside Claude Code, model-agnostic" thesis, and none of them carry Maxim's behavioral/governance overlay (confidence, framework citation, CSO auto-loop). The orchestrator is a thin Maxim-native layer over the existing offices, not a new runtime.
- **Fold unattended workflows into the `loops` skill (no new ADR/orchestrator).** Rejected: `loops` is deliberately interactive and no-invent-budget. Conflating it with budgeted unattended workflows would corrupt the interactive contract. They compose (`mxm-orchestrator` *extends* `loops`) but stay distinct.
- **Build the orchestrator first, document later (the source standard's literal sequencing).** Rejected as the *primary* path: Maxim ratifies architecture before building it (ADR discipline). The orchestrator MVP is Phase 1, immediately after acceptance — the gap from the source standard is one ratification step, deliberately taken.

---

## References

- **Source standard:** the 50-Autonomous-Workflows build standard (operator's internal reference) — §2 non-negotiable architecture, §3 the 10-section per-workflow template, §4 reusable multi-agent patterns (maker-checker, researcher-writer split, triage-escalation, debate panel, self-auditing loop — Maxim already implements four of the five), §5 central orchestrator interfaces, §7 build sequence, §8 guardrails. Adapted, not copied, into Maxim terms (cf. how the `loops` skill cites `loop-library` as prior art per ADR-007).
- **Existing Maxim infra this extends:** `loops` skill (`.claude/skills/loops/SKILL.md`, terminal-state taxonomy + independent verification) · `usage-aware-scheduler` (`.claude/skills/usage-aware-scheduler/SKILL.md` + `config/scheduler-thresholds.json`, OAuth throttle) · `handoff-coordinator` + `.mxm-skills/agents-handoff.md` (escalation) · Proactive Watch (`composable-skills/frameworks/proactive-watch.md`, 12 drift classes — the verification exemplar) · `mxm-catalog` MCP (registry) · `pre-release-audit` (`.claude/agents/pre-release-audit.md`, 8-bucket checker) · `scheduled-tasks` MCP + `mxm-portfolio.get_tasks`/`update_task`.
- **Cross-links:** ADR-002 (the 10-section template + acceptance test as live contracts) · ADR-007 (per-workflow framework citation) · ADR-010 (confidence on every step + terminal state) · ADR-017 (router→maker→checker tiering = office dispatch) · ADR-018 (external renderers/tools wrapped per the three-layer pattern) · ADR-021 (dry-run-default mirrors conservative routing) · ADR-020 (governed-autonomy product direction, confidential).
- **Numbering note:** ADR-021's reference note earmarked ADR-022 for a still-unwritten "cross-language path-resolution discipline" candidate (and ADR-021 itself for "pre-release-audit discipline"). Per the operator's 2026-06-26 direction, **ADR-022 is claimed here for the Autonomous Workflow Standard**; the path-resolution candidate reassigns to the next free id (ADR-023). Per the ADR README, numbers are allocated on file creation and never recycled.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
