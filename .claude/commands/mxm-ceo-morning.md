---
description: CEO morning cycle — overnight-delta summary, priority queue, finance + partnerships scan, blockers surfaced, next-24h plan generated from portfolio state.
---

# /mxm-ceo-morning

## Usage
- Claude Code: `/mxm-ceo-morning`
- Claude CLI: `claude "/mxm-ceo-morning"`
- Claude Desktop: type `/mxm-ceo-morning` in chat

Runs the morning CEO cycle for the current project. Executes 5 high-priority tasks using `.mxm-executive-summary/` data.

## Prerequisites

- `config/project-manifest.json` exists (Maxim bootstrapped)
- `.mxm-executive-summary/` exists (run `/mxm-ceo-setup` first)
- `.mxm-executive-summary/CONTEXT.md` has been filled in

## Behavior

1. Read `config/project-manifest.json` for project identity and compliance scope
2. Verify `.mxm-executive-summary/` exists. If not: "Run `/mxm-ceo-setup` first."
3. Read `.mxm-executive-summary/CONTEXT.md` for startup context
4. Read `.mxm-executive-summary/sessions/tasks.md` for queued tasks
5. Read `.claude/skills/ceo-automation/Maxim-WRAPPER.md`
6. Execute morning tasks in sequence:

### Task 0 — Review Queue Triage (runs first, every morning)

Read `config/project-manifest.json` → `review_queue.backend`:

**If backend is `local`:**
1. Read `.mxm-skills/review-queue.md`
2. Count items with status PENDING
3. If 0 items: skip to Task 1
4. If items exist: display summary table and for each item:
   - SKILL items: show skill name, target domain, confidence, date generated
   - GAP items: show domain, hit count, suggested fix
   - STALE items: show what's stale and recommended action
5. Ask: "Review these now, defer to tonight, or skip?"

**If backend is `github_pr`:**
1. Run: `gh pr list --repo {review_queue.github_pr.repo} --label mxm-review --state open`
2. If 0 PRs: skip to Task 1
3. If PRs exist: display summary with PR number, title, date, CI status
4. For each PR: show one-line summary of what changed and why
5. Ask: "Merge any of these? Or defer to sprint?"

**If no review_queue field in manifest:** skip to Task 1 (backwards compatible).

### Task 1 — Daily Metrics Digest
Read `METRICS.md`. Summarise key numbers in 5 bullets. Flag any metric that moved 10%+ in either direction with a hypothesis.

### Task 2 — Burn Rate Alert
Read `RUNWAY.md`. Calculate current monthly burn, runway in months, and revenue milestone for default alive. Alert if runway under 9 months.

### Task 3 — Team Capacity Check
Read `TEAM.md` and `SPRINT.md`. Per person: current focus, capacity, blockers. Flag overloaded or underutilized.

### Task 4 — Daily Pipeline Digest
Read `CRM-notes.md`. Every open deal: company, stage, deal size, last contact, next action, due date. Flag 7+ days no activity as at-risk. Flag 14-day close dates as urgent.

### Task 5 — Customer Health Scan
Read `CRM-notes.md` and `METRICS.md`. Score each active customer on health index (login recency, adoption, support tickets, NPS, renewal proximity). Flag below 6/10 as churn risk. Draft outreach for at-risk accounts.

7. Save combined output to `.mxm-executive-summary/logs/morning-[YYYY-MM-DD].md`
8. Update `.mxm-executive-summary/sessions/progress.md` with completed tasks
9. Write `.mxm-skills/agents-handoff.md` on completion
10. Tag output: `HIGH`

## Timing

Best run: 6:00-8:00 AM local time, weekdays.
Can be scheduled via Claude Scheduled Tasks: `ceo-morning-{project-id}`, cron `0 6 * * 1-5`.
