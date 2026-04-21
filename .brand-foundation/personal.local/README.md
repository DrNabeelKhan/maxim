# Operator Voice Overlay (personal.local/)

> **GITIGNORED.** This folder contains your personal identity and writing overlay.
> Never committed. Per-machine. Lives on top of the Maxim base voice at `.brand-foundation/personal/`.

---

## Purpose

`.brand-foundation/personal/` ships with Maxim as the public, reusable base voice (Maxim product brand). Every operator who installs Maxim starts with that baseline.

`.brand-foundation/personal.local/` is where **you** layer your identity on top — your name, your credentials, your signature patterns, your calibration against your own writing samples. Because this folder is gitignored, your personal information never leaks into the Maxim public repository.

## File layout

```
.brand-foundation/personal.local/
├── README.md              (this file, also gitignored)
├── voice-profile.md       (your identity + signature patterns extending the Maxim base)
├── ai-tells.md            (your operator-specific banned phrases beyond the Maxim base)
└── content-rules.md       (your structural rule extensions beyond the Maxim base)
```

## Precedence (layered voice load)

At session start, Maxim loads voice in this order:

1. **Maxim base** (`.brand-foundation/personal/`) — 3-voice architecture, signature patterns, em-dash prohibition, universal banned phrases. Non-overridable.
2. **Operator overlay** (`.brand-foundation/personal.local/`) — YOUR identity, YOUR additions. Extends the base. Can add patterns and bans. Cannot remove base bans.
3. **Startup overlay** (`.brand-foundation/startups/{active}/`) — vertical-specific positioning. Compliance rules here override operator rules for regulated content.

## What to put in each file

### `voice-profile.md` (your operator overlay)

- **Identity:** who you are, credentials, years of experience, what makes your voice distinct
- **Universal constants:** the 5-8 things that always appear in your long-form writing
- **Never true:** what you are NOT (defensive positioning)
- **Signature pattern extensions:** additional patterns beyond Maxim's 6 per voice
- **Calibration source:** path to your writing samples folder (whatever you call it — `myVoiceDNA/`, `voice-samples/`, etc.)

### `ai-tells.md` (your operator-specific bans)

- Phrases YOU find grating that Maxim base does not explicitly ban
- Industry-specific AI tells (e.g., specific fintech or healthtech clichés)
- Your personal pet peeves

Maxim base bans always apply on top of these. Your overlay ADDS, never removes.

### `content-rules.md` (your operator-specific structural rules)

- Citation format preferences (inline vs footnote, etc.)
- Sentence length adjustments for specific contexts
- Opening/closing discipline variations you prefer

## How to populate this overlay

Use the Maxim-provided command:

```
/mxm-brand-voice calibrate --target personal.local
```

This reads your writing samples folder (you specify the path), cross-references with the Maxim base, and proposes the three overlay files. Review, approve, and the files are written here.

Or author manually — the files are plain Markdown. The system detects your overlay automatically on next session start if the files exist.

## When overlay files are missing

If `.brand-foundation/personal.local/` does not exist or has no files, Maxim uses the base voice at `.brand-foundation/personal/` unmodified. No errors; no degraded experience. The overlay is strictly additive.

## See also

- `.brand-foundation/personal/` — Maxim base voice (public)
- `.brand-foundation/VOICE-MANAGEMENT.md` — full protocol
- `.claude/commands/mxm-brand-voice.md` — command surface
- `.brand-foundation/personal/CHANGELOG-voice.md` — voice version history

---

*This file is gitignored along with everything else in `personal.local/`. Safe to store personal information here.*
