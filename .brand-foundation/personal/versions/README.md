# Voice File Version Archive

> Every prior version of voice-profile.md, ai-tells.md, and content-rules.md.
> Governed by `.brand-foundation/VOICE-MANAGEMENT.md`.
> Written by `/mxm-brand-voice` on every calibrate / update / reset.

---

## Layout

```
versions/
├── README.md                   (this file)
├── v1.0.0/
│   ├── voice-profile.md
│   ├── ai-tells.md
│   ├── content-rules.md
│   └── META.md                 (reason, trigger, approver, date)
├── v1.0.1/
│   └── ai-tells.md             (only the changed file archived for patch versions)
└── vX.Y.Z-archived/            (reset-created archives with status: archived frontmatter)
```

## META.md format (per-version)

```markdown
# Version vX.Y.Z

**Trigger:** <what caused this version>
**Author:** <who approved>
**Date:** YYYY-MM-DD
**Files archived:** <list>
**Coherence check:** PASS | FAIL
**Linked commit:** <sha>
**Reason to preserve:** <why this snapshot matters for audit>
```

## Retention policy

- All versions retained indefinitely (audit trail value)
- `-archived` suffixed versions = after a reset; voice no longer reference
- Diffs generated on-demand via `git diff versions/vA/voice-profile.md versions/vB/voice-profile.md`

## First version recorded

No pre-v1.1.0 archive exists. Voice files v1.0.0 → v1.1.0 transition was purely metadata (frontmatter addition). Starting v1.1.1 onward, every change archives the prior state here.
