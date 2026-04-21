# Voice Management Protocol

> **The governed way to rewrite, recreate, update, or reset Maxim brand voice files.**
> **Command surface:** `/mxm-brand-voice` (4 subcommands: calibrate / update / scan / reset)
> **Governs:** every file in `.brand-foundation/personal/` and `.brand-foundation/startups/*/`
> **Version:** 1.0.0 · Established: 2026-04-20

---

## Why this protocol exists

Brand voice is a commercial asset. Maxim's entire moat rests on the voice being consistent, calibrated, and defensible. Direct edits to voice files without versioning or audit trail erode that asset quietly. This protocol ensures every voice change is deliberate, traceable, and reversible.

Three rules the protocol enforces:

1. **Nothing is edited in place without a versioned copy of the prior state.**
2. **Every change declares its trigger** (new voice sample ingested, ai-tell discovered, content-rule refined) and its author.
3. **The `voice-profile → ai-tells → content-rules` trinity is always coherent.** You cannot update one without scanning the others for consequent changes.

---

## The 4 verbs

### 1. Calibrate — rebuild voice profile from source material

```
/mxm-brand-voice calibrate
```

**When:** after ingesting new writing samples into `myVoiceDNA/`, after a major identity pivot (new book, new positioning), or at the start of a new startup under `.brand-foundation/startups/<name>/`.

**What happens:**
1. Archive current `voice-profile.md`, `ai-tells.md`, `content-rules.md` → `personal/versions/vX.Y.Z/`
2. Read `myVoiceDNA/` fully (or the specified source folder)
3. Re-derive: identity statement, signature patterns, sentence architecture, vocabulary lists
4. Re-propose: voice-profile + ai-tells + content-rules aligned to new samples
5. STOP for user review before writing
6. User approves → bump minor version (1.1.0 → 1.2.0) and commit

**Outputs:** 3 updated files + 1 archived version + 1 `CHANGELOG-voice.md` entry.

### 2. Update — incremental change, not full recalibration

```
/mxm-brand-voice update --file ai-tells.md --reason "Discovered new AI tell: 'it is imperative'"
```

**When:** a single rule changes (new banned phrase found, new signature pattern emerges, sentence length target shifts for one voice).

**What happens:**
1. Archive only the affected file → `personal/versions/vX.Y.Z/`
2. Apply the proposed patch (user describes or provides edit)
3. Scan the OTHER two files for coherence impact (e.g., a new banned phrase may require content-rules update)
4. STOP if incoherence detected; explain + propose sibling updates
5. User approves → bump patch version (1.1.0 → 1.1.1) and commit

**Outputs:** 1 updated file (or more if cascading) + archive + CHANGELOG entry.

### 3. Scan — validate text against current voice (non-destructive)

```
/mxm-brand-voice scan path/to/draft.md
# OR pipe text
echo "some text to check" | /mxm-brand-voice scan --stdin
```

**When:** before tagging any external-facing output 🟢 HIGH. Runs the full voice-validation checklist + ai-tells banned-phrase scan programmatically.

**What happens:**
1. Load current `voice-profile.md` + `ai-tells.md` + `content-rules.md`
2. Detect voice (Philosophical Architect / Friendly Educator / Technical Educator) from first 3 sentences
3. Scan for em-dashes in prose (not in code), banned phrases, cliché openers, hedges
4. Count sentence length averages; verify rolling average matches voice target
5. Verify signature pattern density (e.g., Philosophical piece needs ≥2 reframings per 1500 words)
6. Output: PASS / FAIL with line-level annotations for each violation

**Outputs:** Console report + optional `.voice-scan.json` artifact (gitignored). No file modification.

### 4. Reset — archive current voice, start fresh

```
/mxm-brand-voice reset --confirm
```

**When:** complete voice pivot (rare — once every 2-5 years). Old voice stops being the reference; new voice built from scratch.

**What happens:**
1. Archive ALL current voice files → `personal/versions/vX.Y.Z-archived/` with `status: archived` frontmatter
2. Prompt user through wizard: identity / positioning / 3-voice architecture from scratch
3. Generate fresh `voice-profile.md` + `ai-tells.md` + `content-rules.md` from wizard answers
4. Bump major version (1.x.x → 2.0.0)
5. Append `CHANGELOG-voice.md` with "MAJOR PIVOT" entry + reason
6. All agents detect version bump; loaded voice reloads on next session start

**Outputs:** 3 fresh files + full archive + CHANGELOG entry.

---

## Version numbering

Semantic versioning, adapted for voice files:

| Change type | Bump | Example |
|---|---|---|
| New banned phrase, new signature pattern, new vocabulary item | Patch | 1.1.0 → 1.1.1 |
| New voice added (e.g., adding 4th voice), new section in content-rules | Minor | 1.1.0 → 1.2.0 |
| Identity pivot, voice-profile rewrite, ai-tells category overhaul | Major | 1.x.x → 2.0.0 |

Version is stamped in each file's YAML frontmatter. The frontmatter is the canonical source of voice version; not the repo tag.

---

## Version archive layout

```
.brand-foundation/personal/
├── voice-profile.md            (current, v1.1.0)
├── ai-tells.md                 (current, v1.1.0)
├── content-rules.md            (current, v1.1.0)
├── CHANGELOG-voice.md          (append-only log of every voice change)
└── versions/
    ├── v1.0.0/
    │   ├── voice-profile.md
    │   ├── ai-tells.md
    │   ├── content-rules.md
    │   └── META.md             (reason for version, trigger, approver, date)
    ├── v1.0.1/
    │   └── ai-tells.md         (only the changed file archived)
    └── vX.Y.Z-archived/        (reset-created full archives)
```

`versions/` is git-tracked. Audit trail matters.

---

## Coherence check (enforced on every update)

Any voice change must pass:

1. **Internal consistency** — voice-profile sentence-length targets match content-rules sentence-length targets; ai-tells banned-phrase list does not contradict voice-profile positive vocabulary
2. **Sample application** — pick 3 past outputs from the repo (ADRs, sprint reports, pack catalog); scan against the updated rules; all 3 still pass
3. **Delta clarity** — CHANGELOG-voice entry explains what changed + why + who approved + date

If any check fails, the update is blocked. Fix the incoherence or revert.

---

## Three-Layer Voice Architecture (v2.0.0+)

Maxim voice loads in three layers, each overlaying the previous:

```
┌────────────────────────────────────────────────────────────────┐
│  Layer 1: Maxim Base (public, committed)                        │
│  .brand-foundation/personal/                                    │
│  - voice-profile.md       (Maxim product brand voice)    │
│  - ai-tells.md            (universal banned phrases)           │
│  - content-rules.md       (structural discipline)              │
│  Ships with repo. Non-overridable. Any Maxim installer sees.    │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼ extends with
┌────────────────────────────────────────────────────────────────┐
│  Layer 2: Operator Overlay (private, gitignored)               │
│  .brand-foundation/personal.local/                              │
│  - voice-profile.md       (your identity + signature patterns) │
│  - ai-tells.md            (your operator-specific bans)        │
│  - content-rules.md       (your structural extensions)         │
│  Per-machine. Never committed. Additive to Layer 1 only.       │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼ extends with (if startup detected)
┌────────────────────────────────────────────────────────────────┐
│  Layer 3: Startup Overlay (gitignored unless public)           │
│  .brand-foundation/startups/{active-startup}/                   │
│  - positioning.md         (vertical-specific voice extension)  │
│  - audience.md            (who this startup speaks to)         │
│  - compliance-rules.md    (industry-specific compliance)       │
│  Startup compliance overrides operator for regulated content.  │
└────────────────────────────────────────────────────────────────┘
```

### Precedence rules

- Maxim base defines the 3-voice architecture, signature patterns, em-dash prohibition, and universal banned phrases — these are **non-overridable**
- Operator overlay **adds** identity, patterns, bans, and vocabulary — never removes from base
- Startup overlay **adds** positioning, audience, and compliance — compliance rules override operator for regulated content
- Scanning uses the **union** of base + operator + startup banned phrases

## Per-startup voice management

Each startup under `.brand-foundation/startups/<name>/` has its own voice files:

- `positioning.md` (extends voice-profile for this vertical)
- `audience.md` (who the startup speaks to)
- `compliance-rules.md` (industry-specific compliance overlays)

The `/mxm-brand-voice` command accepts a `--startup <name>` flag to operate on startup-specific files instead of personal:

```
/mxm-brand-voice calibrate --startup isystematic
/mxm-brand-voice update --startup simplification --file positioning.md --reason "..."
/mxm-brand-voice scan path/to/draft.md --startup isystematic
```

Personal rules always override startup rules for voice and structure. Startup compliance overrides personal for regulated content. This precedence is enforced at scan time.

---

## CHANGELOG-voice.md format

Every change appends an entry. Append-only, no edits to past entries.

```markdown
## v1.1.1 — 2026-05-03

**Trigger:** Discovered new AI tell during LinkedIn post review
**Author:** DrNabeelKhan
**Changed:** ai-tells.md
**Diff summary:** Added "it is imperative" and "a paradigm shift" to Generic AI Filler Words section
**Coherence check:** PASS (3/3 sample scans passed; no content-rules update needed)
**Commit:** abc1234

## v1.1.0 — 2026-04-20

**Trigger:** Initial post-megasprint polish — added YAML frontmatter + version management
**Author:** DrNabeelKhan + Maxim
**Changed:** voice-profile.md, ai-tells.md, content-rules.md
**Diff summary:** Added frontmatter blocks (version, last_calibrated, owner, managed_by); created version management protocol
**Coherence check:** PASS (no semantic changes)
**Commit:** (this commit)
```

---

## Integration with Maxim skills + agents

1. **On session start:** `.claude/hooks/session-start` reads frontmatter `version` from each voice file. If any changed since last session, announces "Voice vN.N.N active" in banner.

2. **Before any 🟢 HIGH output:** every Maxim skill that produces external-facing content runs `/mxm-brand-voice scan` internally. Failure → rewrite + rescan before tag.

3. **New-skill SKILL.md files** (per ADR-007 behavioral-moat framing) are scanned at commit time — voice violations block commit via `pre-commit.{sh,ps1}` hook.

4. **ADRs that affect voice:** `related_adrs` field in voice file frontmatter (future extension) links to any ADR shifting voice doctrine.

---

## When NOT to use this protocol

- Personal journal / diary entries (voice rules don't apply)
- Internal Slack messages (friction > benefit)
- Scratch notes / TODOs / local-only drafts
- Experiments in `prototypes/` (sandbox zone)

If the output is never reaching an external audience and never getting tagged 🟢, skip the protocol. Save the cycles for content that matters.

---

## References

- `.brand-foundation/personal/voice-profile.md` — identity + signature patterns
- `.brand-foundation/personal/ai-tells.md` — banned language
- `.brand-foundation/personal/content-rules.md` — structural rules
- `.claude/commands/mxm-brand-voice.md` — slash command implementation
- `.claude/hooks/pre-commit.sh` — blocks voice-violating commits (v1.0.0+)
- `CLAUDE.md` § Brand Foundation Loading Protocol — how voice files load at session start

---

*Protocol version 1.0.0 · Established 2026-04-20 · Owner: DrNabeelKhan*
