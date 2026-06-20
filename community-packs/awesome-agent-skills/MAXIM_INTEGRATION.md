# awesome-agent-skills — Maxim Integration Notes

> Vendored per ADR-008 (Community Pack System). Role: **the STEP-1-miss fallback skill registry** — when Maxim has no native skill for a task, search this catalog for an external candidate *before* logging a genuine skill gap. Added 2026-06-19 (Session 23).

## Source

| | |
|---|---|
| Upstream | [`VoltAgent/awesome-agent-skills`](https://github.com/VoltAgent/awesome-agent-skills) |
| License | **MIT** (Copyright (c) 2025 VoltAgent) — clean inside BSL-1.1 |
| Content | a curated **index of 1000+ agent skills** from official dev teams (Stripe, Figma, OpenAI, HashiCorp, Supabase, Vercel, Cloudflare, …) + community, organized by team/domain/language |
| Shape | a single 226 KB `README.md` catalog → vendored verbatim as `SKILLS_CATALOG.md` |
| Nature | an **index of pointers** — entries link to skills hosted at `officialskills.sh` / GitHub. The catalog tells Maxim *that a skill exists and where to get it*, not the skill body. |

## Files

- `SKILLS_CATALOG.md` — the upstream README, verbatim (DO NOT EDIT; re-fetch on update).
- `LICENSE` — upstream MIT.
- This file — Maxim integration notes (not upstream).

## Role in Maxim's dispatch (the fallback)

Maxim's dispatch (CLAUDE.md) STEP 1 = "does `.claude/skills/{domain}/` have a native Maxim skill?" Today STEP-1-NO logs a gap. This pack inserts a search **between** "no native skill" and "log a gap":

```
STEP 1  native Maxim skill?  ── YES → use it (full behavioral layer)
   │ NO
   ▼
STEP 1b  search awesome-agent-skills:  bash bootstrap/mxm-find-skill.sh "<intent>"
   │  match? → fetch the linked skill → apply Maxim overlay (confidence tag + framework
   │            citation per ADR-007/010) → use, flagged 🔴 Maxim-UNENHANCED (ADR-008)
   │  no match → log a genuine gap (.mxm-skills/agents-skill-gaps.log)
```

So Maxim stops saying "I don't have that" for 1000+ tasks it can now *find* a skill for.

## How to search

```bash
bash bootstrap/mxm-find-skill.sh "stripe billing"     # → stripe/stripe-best-practices + link
bash bootstrap/mxm-find-skill.sh "figma design system" # → openai/figma-create-design-system-rules
bash bootstrap/mxm-find-skill.sh "terraform provider"  # → hashicorp/new-terraform-provider
```

The finder greps `SKILLS_CATALOG.md`, returns matching entries with their section + source link, and reminds the caller these are external (apply the overlay, flag UNENHANCED). *Known refinement: it also matches the Table-of-Contents links — skip the `## Table of Contents` block to de-noise.*

## Surfacing discipline (non-negotiable, per ADR-008)

A skill pulled from here is **external, not Maxim-authored.** It MUST be flagged `🔴 Maxim-UNENHANCED` until the Maxim behavioral overlay (confidence tagging, framework citation, CSO auto-loop on regulated tasks) is applied on top. Never present an external skill as Maxim-native.

## The auto-use end state (connects to the always-on-router)

Today the finder is **invoked manually**. The goal (per the Session-23 simplification brainstorm) is for the **always-on router** to call it automatically: when intent classification finds no native Maxim skill, the router runs `mxm-find-skill` and offers the candidate — so "Maxim auto-uses a skill when it doesn't have one" happens without you remembering. That's the wiring step (candidate ADR: "Maxim default-on" + STEP-1b fallback). Until then, the searchable place exists and the finder proves it works.

## Tracking & shipping

- **Shipped (committed) in v1.3.4** — un-ignored via `.gitignore: !community-packs/awesome-agent-skills` so every operator has the fallback. Qualifies under the small-pack committed exception (a single 226 KB catalog, not a multi-thousand-file pack).
- **No version pin yet** — this is the PATTERN-02 gap. Record it in the proposed `community-packs/SOURCES.lock` (upstream URL · synced SHA/date · MIT).

## Update protocol

```bash
curl -sL https://raw.githubusercontent.com/VoltAgent/awesome-agent-skills/main/README.md \
  -o community-packs/awesome-agent-skills/SKILLS_CATALOG.md
git diff   # review what skills were added/removed upstream
```

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Integration notes only — `SKILLS_CATALOG.md` + `LICENSE` are MIT (VoltAgent). Per ADR-008._
