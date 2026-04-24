---
description: CEO overnight cycle — scheduled automation that runs while the operator sleeps, processes portfolio signals, and prepares the morning brief.
---

# /mxm-ceo-overnight

## Usage
- Claude Code: `/mxm-ceo-overnight`
- Claude CLI: `claude "/mxm-ceo-overnight"`
- Claude Desktop: type `/mxm-ceo-overnight` in chat

Runs the overnight CEO cycle for the current project. Executes deep analysis tasks using `.mxm-executive-summary/` data. Best run during off-hours when heavy computation is acceptable.

## Prerequisites

- `config/project-manifest.json` exists (Maxim bootstrapped)
- `.mxm-executive-summary/` exists (run `/mxm-ceo-setup` first)
- `.mxm-executive-summary/CONTEXT.md` has been filled in

## Behavior

1. Read `config/project-manifest.json` for project identity and compliance scope
2. Verify `.mxm-executive-summary/` exists. If not: "Run `/mxm-ceo-setup` first."
3. Read `.mxm-executive-summary/CONTEXT.md` for startup context
4. Read `.mxm-executive-summary/sessions/progress.md` for recent session state
5. Read `.claude/skills/ceo-automation/Maxim-WRAPPER.md`
6. Execute overnight tasks in sequence:

### Task 0 — Gap Triage & Review Item Generation

Analyze accumulated skill gaps and generate review items for morning sprint.

1. Read `.mxm-skills/agents-skill-gaps.log`
2. Group gaps by domain — count how many times each domain was hit
3. For domains hit >= 3 times (recurring gap): generate a review item:

   **If backend is `local`:**
   - Append to `.mxm-skills/review-queue.md`:
     ```
     | {next_number} | GAP | {domain} — hit {count}x | gap-triage | {YYYY-MM-DD} | PENDING |
     ```
   - Include suggested action: "Create stub skill for {domain}" or "Extend existing {nearest-skill}"

   **If backend is `github_pr`:**
   - Create branch: `mxm-review/gap/{domain}-{date}`
   - Generate a stub SKILL.md for the missing domain with trigger keywords from the gap log entries
   - Create PR with label `mxm-review` + `gap-fix`:
     - Title: `[Maxim Review] Gap fix: {domain} (hit {count}x)`
     - Body: list of gap log entries that triggered this, suggested skill structure

4. For domains hit only 1-2 times: leave in gap log, do not escalate (may be one-off)
5. Report: "Generated {n} review items from {m} gap entries. {k} gaps below threshold — monitoring."

### Task 1 — Weekly Strategy Check
Read `OKRs.md`, `METRICS.md`, `COMPETITORS.md`. Evaluate whether top 3 priorities still make sense given last week's data. Flag strategic drift and suggest one pivot to consider.

### Task 2 — Competitive Moat Audit
Read `PRODUCT.md` and `COMPETITORS.md`. Per competitor: one thing they do better, one thing we do better, one gap neither is winning. Output as table.

### Task 3 — Weekly Growth Report
Read `METRICS.md` for last 4 weeks. Calculate WoW growth for revenue, active users, churn, CAC. Show ASCII trend. Flag if off track for monthly targets.

### Task 4 — Content Gap Analysis
Read `published-posts.md` and `COMPETITORS.md`. List topics competitors published that we haven't. Rank by estimated traffic opportunity. Flag top 3 gaps to close next sprint.

### Task 5 — Weekly Plan Generator
Read `OKRs.md`, `METRICS.md`, `BACKLOG.md`. Generate next week's plan: top 3 goals, key risks, one thing to stop doing. Output as structured markdown.

### Task 6 — Bottleneck Finder
Read `BLOCKERS.md` and `TEAM.md`. Top 3 recurring bottlenecks: how long persisted, root cause, one concrete fix within our control this week.

7. Save combined output to `.mxm-executive-summary/logs/overnight-[YYYY-MM-DD].md`
8. Update `.mxm-executive-summary/sessions/progress.md`
9. Write `.mxm-skills/agents-handoff.md` on completion
10. Tag output: `HIGH`

## Timing

Best run: 2:00-4:00 AM local time, weekdays.
Can be scheduled via Claude Scheduled Tasks: `ceo-overnight-{project-id}`, cron `0 2 * * 1-5`.
