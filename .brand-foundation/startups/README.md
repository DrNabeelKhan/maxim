# Per-Startup Voice Overlays

> Third voice layer — stacks on top of Maxim base + operator overlay.
> Each subdirectory here corresponds to one startup/brand the operator runs.
> Subdirectories are **gitignored** by default (they contain positioning IP).

---

## Purpose

Operators running multiple brands (personal + agency + product lines + client work) layer vertical-specific voice overlays on top of their operator overlay. This third layer handles industry positioning and compliance overrides without polluting the operator's base voice.

## Directory pattern

```
.brand-foundation/startups/
├── README.md                    (this file — committed)
├── .gitkeep                     (placeholder — committed)
├── {startup-name-a}/            (gitignored)
│   ├── positioning.md           (vertical-specific voice extension)
│   ├── audience.md              (who this startup speaks to)
│   └── compliance-rules.md      (industry-specific compliance)
├── {startup-name-b}/            (gitignored)
│   └── ...
```

## Template startup directories (example operator profile)

An operator might configure these five startups:

```
.brand-foundation/startups/
  nabeelkhan/       (personal brand hub at nabeelkhan.com)
  isystematic/      (agency at isystematic.inc)
  simplification/   (product at simplification.io)
  fixit/            (service at fixit.iservices.io)
  drivingtutor/     (application at drivingtutor.ca)
```

Each startup gets:
- `positioning.md` — how the startup describes itself (3-5 paragraphs, Philosophical or Friendly voice per context)
- `audience.md` — specific audience segments with their language, objections, pain points
- `compliance-rules.md` — industry compliance overlays (HIPAA for healthtech, PCI-DSS for fintech, etc.)

## How a startup gets detected

At session start, Maxim checks in order:

1. `config/project-manifest.json` → `brand.active_startup` field (explicit)
2. `cwd` match against known startup paths (e.g., cwd contains `simplification` → auto-load `simplification/` overlay)
3. Fallback: no startup overlay, operator overlay + Maxim base only

## How to author a new startup overlay

```
/mxm-brand-voice calibrate --startup {name}
```

Agent walks through positioning, audience, and compliance discovery, then proposes the three files for your approval.

## Gitignore behavior

The `.gitignore` rule `.brand-foundation/startups/*/` excludes all subdirectories. Only this `README.md` and `.gitkeep` are committed. To share a startup's public positioning (e.g., the one you want publicly visible), create a specific include exception in `.gitignore`:

```
# Example: share public startup positioning
!.brand-foundation/startups/nabeelkhan/positioning.md
```

## Load order reminder

```
Maxim base (personal/)
  ↓
operator overlay (personal.local/)
  ↓
startup overlay (startups/{active}/)   ← this layer
  ↓
output
```

Startup compliance overrides operator rules for regulated content. Personal rules override startup rules for voice and structure. This precedence is enforced at scan time by `/mxm-brand-voice scan`.
