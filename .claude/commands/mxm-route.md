---
description: Executive router — classifies unknown-intent tasks and routes to the correct office. First stop when you are not sure which /mxm-{office} to invoke.
---

# /mxm-route

## Usage
- Claude Code: `/mxm-route`
- Claude CLI: `claude "/mxm-route"`
- Claude Desktop: type `/mxm-route` in chat

Activates the Executive Router. Use when intent is unclear or spans multiple offices.
The router classifies and routes — it never executes directly.

## Routing Table

| Signal | Routes To | Lead |
|---|---|---|
| Engineering · APIs · DevOps · AI · infra | CTO | `implementer` |
| Strategy · finance · enterprise · M&A | CEO | `enterprise-architect` |
| Marketing · brand · SEO · content · GTM | CMO | `content-strategist` |
| Security · compliance · privacy · risk | CSO | `security-analyst` |
| Product · UX · roadmap · research | CPO | `product-strategist` |
| Operations · delivery · sprints · support | COO | `planner` |
| Innovation · R&D · emerging tech | CINO | `innovation-researcher` |
| Unknown intent | All offices | log to `.mxm-skills/agents-skill-gaps.log` |

## Behavior
1. Read `config/project-manifest.json` for project context
2. Classify task intent against routing table
3. Write routing decision to `.mxm-skills/agents-handoff.md`
4. Transfer to correct office lead
5. Never executes task directly — routes only
6. Unroutable: log to `.mxm-skills/agents-skill-gaps.log` with prefix `UNROUTABLE:`
