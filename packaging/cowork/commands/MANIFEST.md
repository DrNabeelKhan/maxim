# Commands Bundled in maxim.plugin (Cowork)

> **14 of 37 commands** included. Hook-dependent and scheduler-dependent commands excluded.

**Version:** v1.0.0

---

## Included (14)

### Executive office shortcuts (8)

One per office, plus the router.

| Command | Source | Purpose |
|---|---|---|
| `/mxm-ceo` | `../../.claude/commands/mxm-ceo.md` | CEO office routing |
| `/mxm-cto` | `../../.claude/commands/mxm-cto.md` | CTO office routing |
| `/mxm-cmo` | `../../.claude/commands/mxm-cmo.md` | CMO office routing |
| `/mxm-cso` | `../../.claude/commands/mxm-cso.md` | CSO office routing |
| `/mxm-cpo` | `../../.claude/commands/mxm-cpo.md` | CPO office routing |
| `/mxm-coo` | `../../.claude/commands/mxm-coo.md` | COO office routing |
| `/mxm-cino` | `../../.claude/commands/mxm-cino.md` | CINO office routing |
| `/mxm-route` | `../../.claude/commands/mxm-route.md` | Executive router — unknown-intent classification |

### Discipline / governance (4)

| Command | Source | Purpose | Cowork Notes |
|---|---|---|---|
| `/mxm-watch` | `../../.claude/commands/mxm-watch.md` | Drift detection (all 10 classes) | Manual invoke only — no SessionStart hook |
| `/mxm-session-end` | `../../.claude/commands/mxm-session-end.md` | 9-doc closure bundle | Advisory — user runs real updates in their CLI repo |
| `/mxm-update` | `../../.claude/commands/mxm-update.md` | Capability inventory sync | Advisory |
| `/mxm-release` | `../../.claude/commands/mxm-release.md` | Release flow | Advisory only — actual release happens in CLI |

### Introspection (2)

| Command | Source | Purpose |
|---|---|---|
| `/mxm-help` | `../../.claude/commands/mxm-help.md` | List available commands + usage |
| `/mxm-status` | `../../.claude/commands/mxm-status.md` | Snapshot current project state |

---

## Excluded (23)

### Hook-dependent (0)

Actually — all hook-dependent behavior is in `.claude/hooks/`, not `.claude/commands/`. Commands themselves mostly work cross-surface.

### Scheduler-dependent (3)

| Command | Blocker |
|---|---|
| `/mxm-ceo-morning` | Requires scheduled-tasks MCP + local cron |
| `/mxm-ceo-overnight` | Same |
| `/mxm-ceo-setup` | Configures local scheduler |
| `/mxm-tasks` | OAuth usage API + scheduler |

### Voice-dependent (1)

| Command | Blocker |
|---|---|
| `/mxm-voice` | Requires local voicemode binary |

### MCP-dependent (5) — Wiki + MemPalace

| Command | Blocker |
|---|---|
| `/mxm-wiki` (+ 4 subcommands implicitly) | MemPalace MCP not in Cowork runtime |

### Narrow-utility (14)

These work fine but didn't make the 14-cap for initial plugin release; will be added in future plugin releases based on user demand.

| Command | Source | Will ship in |
|---|---|---|
| `/mxm-behavior` | `mxm-behavior.md` | v7.0 plugin |
| `/mxm-compliance` | `mxm-compliance.md` | v7.0 plugin |
| `/mxm-context` | `mxm-context.md` | v7.0 plugin |
| `/mxm-design` | `mxm-design.md` | v7.0 plugin |
| `/mxm-health` | `mxm-health.md` | v7.0 plugin |
| `/mxm-implement` | `mxm-implement.md` | v7.0 plugin |
| `/mxm-new-project` | `mxm-new-project.md` | v7.0 plugin |
| `/mxm-organize` | `mxm-organize.md` | v7.0 plugin |
| `/mxm-plan` | `mxm-plan.md` | v7.0 plugin |
| `/mxm-portfolio` | `mxm-portfolio.md` | v7.0 plugin |
| `/mxm-recall` | `mxm-recall.md` | v7.0 plugin |
| `/mxm-remember` | `mxm-remember.md` | v7.0 plugin |
| `/mxm-review` | `mxm-review.md` | v7.0 plugin |
| `/mxm-security` | `mxm-security.md` | v7.0 plugin |
| `/mxm-seo` | `mxm-seo.md` | v7.0 plugin |
| `/mxm-superpowers` | `mxm-superpowers.md` | v7.0 plugin |
| `/mxm-test` | `mxm-test.md` | v7.0 plugin |

---

## Updates

When adding commands to future plugin releases:
1. Add to the Included table above
2. Remove from the appropriate Excluded section
3. Bump plugin version
4. Re-run assembly

The `inventory-drift` checker in Proactive Watch flags when repo command count exceeds plugin command count by more than 20 (indicating plugin is falling behind).
