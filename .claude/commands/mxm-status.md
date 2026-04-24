---
description: Current session status — active handoff state, open skill gaps, pending review queue, drift class alerts.
---

# /mxm-status

## Usage
- Claude Code: `/mxm-status`
- Claude CLI: `claude "/mxm-status"`
- Claude Desktop: type `/mxm-status` in chat

Project-level status check with **behavioral framework-driven output** (v1.0.0+).
Reads live state of the CURRENT project. Each section is engineered using a specific
behavioral framework to move the operator's mental state toward effective action.

**Triggers:** "maxim status", "project status", "what's active", "show gaps"
**Reads:** `config/agent-registry.json` · `config/project-manifest.json` ·
           `.mxm-skills/agents-skill-gaps.log` · `.claude-sessions-memory/` ·
           `task_plan.md` · `progress.md`

**For full 8-layer system health check:** use `/mxm-health` instead.

---

## Behavioral Framework Map (v1.0.0 — OB-11)

Seven frameworks drive seven output sections. Each applies science, not decoration.

| # | Section | Framework | Why |
|---|---|---|---|
| 1 | Identity Header | **SCARF** (Rock) | Reduce Status/Certainty threat — operator feels oriented, not ambushed |
| 2 | Autonomy Card | **SDT** (Deci & Ryan) | Show autonomy-supportive state (what you control, what Maxim handles) |
| 3 | Progress Panel | **Zeigarnik Effect** | Surface unfinished threads so operator re-engages naturally |
| 4 | Risk Card | **Prospect Theory** (Kahneman & Tversky) | Frame gaps as LOSSES to prevent, not gains to chase — higher activation |
| 5 | Pack Value Band | **Endowment Effect** (Thaler) | Show entitlements already owned → increase perceived value of upgrade |
| 6 | Fast/Slow Bar | **Dual Process** (Kahneman) | Give System 1 (quick glance) + System 2 (drill-down) paths |
| 7 | Stage Badge | **TTM Stage** (Prochaska) | Reflect operator's adoption stage; tailor upgrade prompts to stage |

---

## Behavior

### Step 1 — Detect + Read

1. **Install mode:** check CLAUDE.md presence (project root vs `%USERPROFILE%\.claude\`) → GLOBAL / LEGACY-LOCAL / MIXED
2. **Registry:** read `config/agent-registry.json` → version, agent count, categories
3. **Project identity:** read `config/project-manifest.json` → id, vertical, stage, super_user, gated flag
4. **Skills inventory:** count `.claude/skills/{domain}/` with SKILL.md + Maxim-WRAPPER.md present
5. **Skill gaps:** read `.mxm-skills/agents-skill-gaps.log`
6. **Review queue:** count PENDING in `.mxm-skills/review-queue.md`
7. **Session count:** count `session-*.md` files in `.claude-sessions-memory/` (see Session Milestones below)
8. **Active task:** check `task_plan.md` / `progress.md` for open threads

### Step 2 — TTM Stage Detection (NEW — Task 6.3)

Per `composable-skills/frameworks/ttm-stage-detection.md`, infer operator's adoption stage from session count + pack subscriptions:

| Session Count | Pack Subs | TTM Stage | What the operator needs |
|---|---|---|---|
| 1–3 | 0 | Precontemplation | Low-friction wins; DO NOT pitch packs |
| 4–9 | 0 | Contemplation | Show value proof; pack tease allowed |
| 10–24 | 0–1 | Preparation | Direct upgrade prompt; social proof |
| 25–49 | 1–2 | Action | Reinforce habits; introduce Pack 2 or L1.X |
| 50+ | 2+ | Maintenance | Advocate/certify; show operator status |

Emit TTM stage in output header as `Stage: [name]`.

### Step 3 — Session Milestones (NEW — Task 6.5)

Count sessions in `.claude-sessions-memory/` and emit milestone prompts:

- **Session 10:** "Milestone: MemPalace unlock eligible" → suggest `/mxm-wiki ingest` walk-through
- **Session 25:** "Milestone: Operator Status tier reached" → link to `.mxm-operator-profile/profile.md` review
- **Session 50:** "Milestone: Maxim Certification eligible" → link to certification flow (v6.5.0+)

Only emit once per milestone (check `.mxm-skills/milestone-log.md` before suggesting).

### Step 4 — Structured Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Maxim STATUS  ·  [project-id]  ·  [date]             [SCARF: status + certainty]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Install Mode: GLOBAL | LEGACY-LOCAL | MIXED
  Registry:     v[x.x.x] · [n] agents · [n] categories
  Project:      [name] · [vertical] · [lifecycle]
  Stage:        [TTM stage]                          [TTM: operator adoption state]

── Autonomy ──────────────────────────────────────    [SDT: autonomy-support]
  You control: project-manifest, task plans, ADRs
  Maxim handles: dispatch, framework selection, confidence tagging

── In Flight (unfinished) ─────────────────────────    [Zeigarnik: re-engagement]
  Active task:  [task_plan.md summary OR "none"]
  Open gaps:    [N] gaps — top 3: [...]
  Review queue: [N] PENDING items

── Risk (loss-framed) ─────────────────────────────    [Prospect Theory: loss aversion]
  • [N] skill gaps unresolved — each blocks one task domain
  • [CHANGELOG / handoff staleness > 7 days]
  • [any CRITICAL drift class from /mxm-watch]

── Entitlements (you already have) ────────────────    [Endowment: owned assets]
  ✓ [N] skills across [M] domains
  ✓ [N] MCP tools across 7 servers
  ✓ [N] behavioral frameworks in FRAMEWORKS_MASTER
  ✓ [N] ADRs ratified

── Fast Glance / Deep Drill ───────────────────────    [Dual Process: S1/S2 paths]
  Fast:  /mxm-tasks · /mxm-watch
  Deep:  /mxm-health · /mxm-review · /mxm-recall

── Milestone ──────────────────────────────────────    [TTM stage-matched prompt]
  [Session N reached — next unlock: ...]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟢 HIGH · Maxim behavioral layer fully active
```

### Step 5 — Tag Output

Always `🟢 HIGH` (command reads structured state, no ambiguity).
Add `🔵 SUPER USER` if `super_user.enabled=true`; add `🔐 GATED` if `status.gated=true`.
