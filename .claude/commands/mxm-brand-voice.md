---
description: Three-layer brand foundation voice system. Subcommands: calibrate / update / scan / reset. Loads ARIA base + operator overlay + startup overlay, scans drafts for AI-tells.
---

# /mxm-brand-voice

## Usage
- Claude Code: `/mxm-brand-voice [subcommand] [args]`
- Claude CLI: `claude "/mxm-brand-voice [subcommand] [args]"`
- Claude Desktop: type `/mxm-brand-voice` in chat

Manages the Maxim brand voice files under `.brand-foundation/`. Governed by `.brand-foundation/VOICE-MANAGEMENT.md`.

## Subcommands

### calibrate — rebuild voice from source material

```
/mxm-brand-voice calibrate
/mxm-brand-voice calibrate --startup isystematic
/mxm-brand-voice calibrate --source E:\Projects\nabeelkhan\myVoiceDNA
```

Re-derives `voice-profile.md`, `ai-tells.md`, `content-rules.md` from source writing samples. Archives current versions to `.brand-foundation/personal/versions/vX.Y.Z/`. STOPS for user approval before writing.

### update — targeted incremental change

```
/mxm-brand-voice update --file ai-tells.md --reason "Discovered new AI tell: 'it is imperative'"
/mxm-brand-voice update --file voice-profile.md --reason "Tightened Philosophical sentence target to 20-28 words"
/mxm-brand-voice update --startup simplification --file positioning.md --reason "..."
```

Patches a single file. Archives the pre-change version. Scans sibling files for coherence impact; may propose cascading updates.

### scan — validate text against current voice (read-only)

```
/mxm-brand-voice scan path/to/draft.md
/mxm-brand-voice scan --stdin
echo "Some candidate copy" | /mxm-brand-voice scan --stdin
```

Runs full voice-validation checklist + ai-tells banned-phrase scanner. Returns PASS / FAIL with line-level annotations. No file modification.

### reset — full voice pivot (rare, major-version bump)

```
/mxm-brand-voice reset --confirm
```

Archives all current voice files as `vX.Y.Z-archived/`. Wizards through new voice creation. Bumps major version.

## Behavior

1. Activate `content-strategist` + `brand-guardian` as leads (CMO office)
2. Load current voice files:
   - `.brand-foundation/personal/voice-profile.md`
   - `.brand-foundation/personal/ai-tells.md`
   - `.brand-foundation/personal/content-rules.md`
   - Plus per-startup files if `--startup <name>` passed
3. Load protocol: `.brand-foundation/VOICE-MANAGEMENT.md`
4. Execute subcommand-specific flow
5. For calibrate/update/reset: STOP for user approval before writing
6. Archive affected file(s) to `.brand-foundation/personal/versions/vX.Y.Z/`
7. Update frontmatter `version` + `last_calibrated` on modified files
8. Append entry to `.brand-foundation/personal/CHANGELOG-voice.md`
9. Run coherence check (3-sample validation + internal consistency)
10. Write `.mxm-skills/agents-handoff.md` on completion
11. Tag output: 🟢 HIGH (voice itself is tagged against its own rules — bootstrapping test)

## Version bump rules

- Patch (1.1.0 → 1.1.1): new banned phrase, new signature pattern, new vocabulary item
- Minor (1.1.0 → 1.2.0): new voice added, new section in content-rules
- Major (1.x.x → 2.0.0): identity pivot, voice-profile rewrite, ai-tells category overhaul

## Related

- `.brand-foundation/VOICE-MANAGEMENT.md` — full protocol
- `/mxm-cmo` — CMO office (content authoring uses current voice)
- `/mxm-brand` — (future) broader brand management command
- `.claude/hooks/pre-commit.sh` — blocks voice-violating commits
- ADR-007 — Behavioral-Moat Framing Doctrine (voice is part of the moat)
