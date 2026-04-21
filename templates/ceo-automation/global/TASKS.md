---
name: Global Task List
description: Cross-project task registry for Maxim portfolio management. Read by /mxm-tasks and /mxm-portfolio.
type: global
updated: YYYY-MM-DD
---

# Global Task List — Maxim Portfolio

## Active Tasks

| # | Task | Project | Priority | Due | Status | Assigned To |
|---|------|---------|----------|-----|--------|-------------|
| 1 | Write Chapter 4: Market Positioning | book-writing | P1 | 2026-04-15 | In Progress | Claude Code |
| 2 | Migrate hosting from DigitalOcean to Hetzner | platform-v2 | P1 | 2026-04-20 | Not Started | Claude Code + DevOps |
| 3 | Publish April newsletter to 3,200 subscribers | mxm-marketing | P2 | 2026-04-12 | Not Started | Claude Desktop |
| 4 | Complete ISO 27001 gap analysis | compliance-ops | P2 | 2026-04-30 | In Progress | Claude Code |
| 5 | Finalize investor pitch deck (Series A) | mxm-core | P1 | 2026-04-18 | In Progress | Claude Desktop |
| 6 | Set up staging environment on Fly.io | platform-v2 | P2 | 2026-04-25 | Not Started | Claude CLI |
| 7 | Research EU AI Act obligations for Q3 | compliance-ops | P3 | 2026-05-01 | Backlog | Claude Code |
| 8 | Update onboarding flow based on user feedback | mxm-core | P2 | 2026-04-22 | Not Started | Claude Code |

---

## Completed Tasks

| # | Task | Project | Completed | Notes |
|---|------|---------|-----------|-------|
| — | Write Chapter 1–3: Foundations | book-writing | 2026-04-08 | All 3 chapters reviewed and approved |
| — | GDPR data mapping for EU users | compliance-ops | 2026-04-05 | Filed in .claude-sessions-memory/compliance/ |
| — | Launch Maxim v1.0.0 | maxim | 2026-04-06 | Tag pushed, release notes published |

---

## How Tasks Are Executed

| Execution Mode | When to Use | Claude Tool |
|----------------|-------------|-------------|
| Code | Writing code, editing files, running builds | Claude Code |
| Cowork | Long-form writing, analysis, strategy sessions | Claude Desktop |
| Dispatch | Autonomous background tasks, batch jobs | Claude Dispatch |
| CLI | One-shot terminal commands, script runs | Claude CLI |
| Desktop | Conversations, brainstorming, document review | Claude Desktop |

---

## Scheduling

Tasks can be scheduled using **Claude Scheduled Tasks** (available in Claude.ai Pro/Team/Enterprise).

To schedule a task:
1. Run `/mxm-tasks schedule TASK_NUMBER`
2. Maxim will generate a Scheduled Task prompt or Dispatch payload
3. Confirm and activate in Claude.ai → Scheduled Tasks

For recurring tasks (weekly reports, monthly newsletters, quarterly reviews):
- Use Claude Scheduled Tasks with a natural language schedule: "every Monday at 9am"
- Maxim will read this file at run time and execute the highest-priority due task

> Reference: Claude Scheduled Tasks — https://support.anthropic.com/scheduled-tasks
