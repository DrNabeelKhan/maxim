# Maxim Wrapper — Operator Profile

> This file makes this domain an Maxim-governed skill.

## Maxim Behavioral Layer — MANDATORY

1. **Confidence tagging:** 🟢 HIGH (profile loaded) / 🟡 MEDIUM (profile empty/new user)
2. **Proactive triggers:** Session start (read), session end (update), preference signal detected
3. **CSO auto-loop:** N/A — operator profile is personal, not security-sensitive
4. **Framework selection:** Honcho dialectic modeling (NousResearch/hermes-agent)
5. **Communication standard:** Silent application — never announce profile reads

## Merge Rules

- Maxim operator-profile → primary (personalization layer)
- MemPalace `maxim/operator` room → supplementary (cross-session recall)
- claude-mem → supplementary (persistent memory)
- Conflict → explicit session instructions ALWAYS override profile preferences

## Activation

This domain activates:
- On every session start (read profile)
- On every session end (update profile)
- When operator expresses a preference signal
- When operator corrects or rejects an approach
