# /mxm-behavior

## Usage
- Claude Code: `/mxm-behavior`
- Claude CLI: `claude "/mxm-behavior"`
- Claude Desktop: type `/mxm-behavior` in chat

Activates the CMO behavior-science cluster. Applies Fogg, COM-B, EAST, Hook Model.

**Triggers:** "behavioral design", "persuasion", "nudge", "conversion", "habit",
              "decision architecture", "reduce friction"
**Office:** CMO → `behavioral-designer` (lead)
**Reads:** `.claude/skills/behavior-science-persuasion/`
**Ethics gate:** active for manipulation-risk signals (suppressed if super_user active)

## Behavior

1. Classify behavioral intent: persuasion · nudge · habit · conversion · decision
2. Activate `behavioral-designer` → routes to specialist agents
3. Apply `.claude/skills/behavior-science-persuasion/` — Fogg + COM-B + EAST + Hook Model
4. Ethics gate: flag manipulation-risk patterns → escalate to CSO
5. Tag output: 🟢 HIGH | 🔵 SUPER USER (if super_user active)
