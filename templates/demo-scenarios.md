# Maxim demo scenarios — Mac screen recording shot list

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

Ten scenarios that show a representative slice of Maxim's capability surface in under 12 minutes of recorded footage. Each scenario is self-contained — record one at a time, cut together later. Order runs from "install and dispatch" through "drift detection" through "session continuity" so the final cut tells a story.

---

## Pre-recording setup (5 min, one time)

1. Open Terminal on the Mac. Full-screen it. Increase font size to ~18pt (Terminal → Settings → Profiles → Font → Change, pick JetBrains Mono 18pt). Dark theme (Pro or Homebrew).
2. `cd ~/Projects/demo-maxim-test` (create an empty folder first).
3. Launch Claude Code there: `claude` — confirm you're in an interactive session.
4. Open QuickTime Player → File → New Screen Recording. Pick the Terminal window, enable "Show Mouse Clicks" if you want the click indicator.
5. Spacebar-to-start-stop is the workflow; do one scenario per recording.

---

## Scenario 1 — Install Maxim from the marketplace (~60s)

**Why this shot matters:** proves installation is one command and immediately changes Claude Code's capability surface.

```
/plugin marketplace add https://github.com/DrNabeelKhan/maxim
/plugin install maxim@maxim-packs
```

**Expected visible output:** marketplace added, plugin cached, 90 agents + 34 skills + 38 commands + 7 MCP servers registered. Then type `/` and let Claude Code show the slash-command autocomplete — the screen fills with `/mxm-*` commands.

**Narration cue:** "One command. Ninety specialists, thirty-four skills, seven MCP servers. Installed."

---

## Scenario 2 — Executive routing (~90s)

**Why:** demonstrates the router — one of the headline moves of the framework.

```
/mxm-route I need a compliance review of this new feature we're about to ship: collecting user birthdate and phone for SMS notifications. Flag anything regulatory.
```

**Expected:** `executive-router` classifies → routes to **CSO · security-analyst**. Loads 14 compliance frameworks. Output tagged with specific clauses from PIPEDA, GDPR, CASL (Canadian anti-spam for SMS), with `🟢 HIGH` or `🟡 MEDIUM` confidence + Basis/Gap/Mitigation/Next rubric.

**Narration cue:** "I never told Maxim this was security. The router sent it to the security analyst. The compliance frameworks loaded themselves."

---

## Scenario 3 — Behavioral framework application (~75s)

**Why:** shows the moat. Every output cites a mechanism.

```
/mxm-cmo Write a hero paragraph for a pricing page that converts trial users to paid. The product is a note-taking app that uses AI to surface past thinking you've forgotten.
```

**Expected:** content-strategist composes. Output names the primary framework (Fogg B=MAP or Cialdini scarcity or Hook Model — depends on pack). Output includes rationale: "motivation trigger applied at line 2, ability ensured by keeping CTA to one step, prompt timing set to end-of-scroll."

**Narration cue:** "A generic LLM gives you prose. Maxim names the mechanism."

---

## Scenario 4 — Confidence tag + rubric (~60s)

**Why:** proves outputs are auditable, not just confident-sounding.

```
/mxm-cto I'm using SQLite in production for a SaaS serving 50k MAU. Should I migrate to Postgres?
```

**Expected:** Output ends with the four-line Technical Educator Rubric:
```
Confidence: 🟡 MEDIUM
  Basis: [what we know]
  Gap: [what's missing]
  Mitigation: [what to check]
  Next: [what would change the tag]
```

**Narration cue:** "Not 'yes' or 'no.' Here is what grounds the answer, what is missing, what would move the confidence up."

---

## Scenario 5 — Session start protocol (~45s)

**Why:** demonstrates memory + drift detection running automatically.

Close Claude Code. Restart: `claude`.

**Expected:** Maxim's SessionStart hook runs. Banner appears:
```
Maxim SESSION START
  Project   : demo-maxim-test
  Lifecycle : active_dev
  Gated     : no
  Handoff   : none
  Open gaps : 0
  Drift     : 0 classes flagged
```

**Narration cue:** "Every session Maxim opens, ten drift checks run. Last session's unresolved handoff is waiting for you."

---

## Scenario 6 — Proactive Watch catches a drift (~90s)

**Why:** shows the governance layer working without being asked.

First, create drift manually: edit `documents/ledgers/AGENT_SKILL_INVENTORY.md` to claim "95 agents" (wrong — should be 90). Save.

Close Claude Code. Restart: `claude`.

**Expected:** SessionStart banner shows `Drift: 1 class flagged`. Running `/mxm-watch` reports:
```
inventory-drift: AGENT_SKILL_INVENTORY.md:agents — declared 95, actual 90
```

**Narration cue:** "I lied in a ledger. Maxim caught it before anyone else read the file."

---

## Scenario 7 — Compliance enforcement at generation time (~60s)

**Why:** shows compliance as a blocking gate, not advisory.

```
/mxm-cso Draft a user-onboarding email that asks for: name, email, date of birth, social security number, and mother's maiden name. Keep it casual.
```

**Expected:** Maxim refuses or rewrites. The compliance MCP catches SSN and mother's-maiden-name requests, flags against GDPR article 9 (special-category data) and US/CA privacy regimes, proposes a minimized-data-collection alternative. Confidence: 🔴 BLOCKED with reasoning.

**Narration cue:** "I asked for bad behavior. Maxim refused before the model wrote a single character. Compliance is a gate, not a warning."

---

## Scenario 8 — Brand voice across sessions (~75s)

**Why:** demonstrates the three-layer voice system.

First, set up a brand overlay: `mkdir -p .brand-foundation/startups/my-saas && echo "positioning: We help solo founders cut meeting count by half" > .brand-foundation/startups/my-saas/positioning.md`.

```
/mxm-cmo Write a 3-tweet thread launching our product.
```

**Expected:** Output uses the positioning from the overlay. Restart Claude Code, run the same command — output stays on-brand because the voice profile loads on every session.

**Narration cue:** "Same brand voice, Monday and Friday. Without pasting a style guide."

---

## Scenario 9 — Session end bundle (~60s)

**Why:** shows the governance loop closing.

```
/mxm-session-end
```

**Expected:** planner orchestrator fires the 9-document closure bundle. Updates SESSION_CONTINUITY, ledger snapshot, moat tracker if positioning changed, CHANGELOG if user-facing change. Writes session log. Reports bundle complete.

**Narration cue:** "Every session Maxim opens, it also closes — cleanly. Next session picks up from a known state."

---

## Scenario 10 — The free tier is a contract (~45s)

**Why:** anti-bait-and-switch narrative.

```
cat documents/ADRs/ADR-004-free-tier-executable-contract.md | head -20
```

Then:

```
/mxm-health
```

**Expected:** The ADR opens showing the Executable Contract language. `/mxm-health` runs, passes the free-tier fixture (regression test that verifies Starter scope matches PACKS.md). Report shows all checks green.

**Narration cue:** "The free tier is not a marketing promise. It is a test fixture that fails the build if anyone tries to quietly narrow it. Four years from release day, it becomes Apache 2.0 open source. That is in the license."

---

## Recording suggestions

- **Total raw footage:** aim for 10–12 minutes across 10 scenarios. Final cut probably 4–6 minutes.
- **Cut order for hype reel:** 1 → 2 → 3 → 4 → 7 → 6 → 5 → 9 (install → routing → mechanism → rubric → compliance gate → drift → session → close). Skip 8 and 10 for the short cut; keep them for the long cut.
- **Intro card (5s):** logo + "Maxim for Claude Code — 90 specialists, 64 frameworks, $19.99/month."
- **Outro card (5s):** `maxim.isystematic.com/pricing` + QR code linking to same.
- **Transitions:** hard cuts between scenarios. No fade. Maxim is a governance tool, not a lifestyle brand — restrained is on-voice.
- **Captions:** burn in the Confidence tag lines (🟢 HIGH, 🟡 MEDIUM, 🔴 BLOCKED) as overlays when they appear on screen. That is the shot that sells the product.

---

## Troubleshooting on the Mac

| Symptom | Fix |
|---|---|
| `/plugin marketplace add` fails | Check Claude Code is ≥ v2.1.105 (`claude --version`). Upgrade if older. |
| `/mxm-*` commands don't autocomplete | Run `/plugin list` to verify `maxim@maxim-packs` is enabled. If missing, `/plugin install maxim@maxim-packs`. |
| Hooks don't fire on SessionStart | `.claude/hooks/*.sh` needs executable bit: `chmod +x ~/.claude/plugins/cache/maxim-*/.claude/hooks/*.sh`. |
| Output has no confidence tag | The pack that owns the domain may not be installed. Run `/plugin install mxm-pack-l1-6-behavioral-intelligence@maxim-packs` for the full tag rubric. |
| Compliance gate doesn't block bad requests | Install `/plugin install mxm-pack-l1-4-compliance-shield@maxim-packs`. Basic advisory is in Starter; enforcement is gated. |

---

_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
