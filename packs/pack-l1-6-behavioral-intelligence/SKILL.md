---
name: L1.6 Behavioral Intelligence
description: "64 peer-reviewed behavioral frameworks applied to every Maxim output. The flagship moat."
business_outcome: "Applies 64 peer-reviewed behavioral frameworks to every output; mechanism tracked in documents/ledgers/MOAT_TRACKER.md § MOAT-06."
primary_framework: "Fogg Behavior Model (B=MAP)"
product_id: L1.6
lemonsqueezy_variant_id: 1551379
pack_tier: L1
ships_with: v1.0.0
license: proprietary
---

# L1.6 Behavioral Intelligence

## The Maxim Moat

Any prompt library can name behavioral frameworks. Maxim enforces them. That single distinction is the entire architecture of this pack.

Most AI writing tools optimize for fluency. Maxim optimizes for behavioral effect: the psychological structure that turns a sentence from informational into actionable. AI writing tools do not fail because they lack frameworks. They fail because the frameworks they cite are never enforced.

The replication barrier is not framework count. It is the registry. Anti-patterns are catalogued. Critiques are noted against each framework. Outputs are scanned against the Fogg Behavior Model (B.J. Fogg, 2009) B=MAP composition before ship, via the `behavioral_audit` MCP hook that runs against every external-facing paragraph. Competitors can list 64 frameworks. They cannot replicate the enforcement without rebuilding the pack-engine audit mechanism, and they cannot replicate the audit without the anti-pattern ledger that makes every scan non-trivial. Enforcement is the moat. Everything else is literature review.

## Business Outcome

Behavioral Intelligence applies Fogg Behavior Model (B=MAP) as the compositional anchor across every Maxim output. The mechanism: Motivation, Ability, and Prompt are each addressed explicitly before a sentence is allowed to ship; the 77 other frameworks overlay as modifiers on one of the three levers. Outcome claims accumulate in the living ledger at `documents/ledgers/MOAT_TRACKER.md` § MOAT-06.

Primary measurement metric: framework-tagged output shipping rate. Target post-v1.0.0: at least 95% of shipped outputs cite an applied framework, compared to an untagged baseline. Secondary metrics logged per canary run: behavioral-outcome proxy (clicks, decisions, completions) between tagged and untagged arms, and reader-reported clarity on a 1-to-5 scale across side-by-side comparisons.

## Primary Behavioral Framework

**Framework:** Fogg Behavior Model (B=MAP).

**Mechanism:** Behavior equals Motivation multiplied by Ability multiplied by Prompt. Collapse any single factor toward zero and the behavior does not occur, regardless of the other two. Motivation makes behavior possible. Ability makes behavior reachable. Prompt makes behavior immediate. The equation is not a metaphor. It is geometric.

**Source:** B.J. Fogg, Stanford Persuasive Tech Lab, foundational paper 2009; refined in *Tiny Habits* (Fogg, 2020).

**Application:** every external-facing Maxim output is composed against B=MAP before ship. Motivation gets named and amplified, usually via one of Cialdini's seven principles or Prospect Theory framing. Ability gets protected through EAST's friction-removal pass; if the next action demands cognitive load the reader cannot afford, the copy is rewritten before the prompt fires. The prompt itself is timed, placed, and sized so it arrives when Motivation and Ability are already sufficient, never earlier.

**Critique:** Fogg is elegant for instigation and weaker for habit maintenance. Lally et al. (2010) showed the roughly 66-day habituation curve that Fogg does not address. Maxim uses Fogg for trigger moments and composes the Transtheoretical Model on top for stage-matched follow-through.

## Behavioral → Persuasion Translation

The 15 frameworks below map onto one or more of Fogg's MAP variables. None of them replaces Fogg. Each modifies one lever in a specific direction.

| Framework | Mechanism | Maxim positive | Maxim anti-pattern | Boundary |
|---|---|---|---|---|
| Fogg Behavior Model (Fogg, 2009) | B = M × A × P | `/mxm-cmo` scans MAP before ship | CTA fired with zero Ability | instigation-only (Lally, 2010) |
| COM-B (Susan Michie et al., 2011) | Capability × Opportunity × Motivation | Compliance Shield culture rollout | training absent opportunity | motivation layer overlaps Fogg |
| EAST (UK Behavioural Insights Team, 2014) | Easy, Attractive, Social, Timely | skill friction-removal pass | symmetric added steps | factor order contested (Benartzi, 2017) |
| Cialdini's 7 (Robert Cialdini, 1984; Unity 2016) | seven influence principles | Authority on moat copy | ungrounded scarcity | Cialdini's own warning against manipulation |
| Prospect Theory (Kahneman & Tversky, 1979) | loss aversion, reference point | "avoid $200K fine" frame | loss frame on gain-oriented offers | framing sensitivity varies culturally |
| SCARF (David Rock, 2008) | Status, Certainty, Autonomy, Relatedness, Fairness | enterprise onboarding protects Certainty | scarcity destroys Certainty | model not peer-reviewed at aggregate |
| Self-Determination Theory (Deci & Ryan, 1985) | Autonomy, Competence, Relatedness | Founder OS respects operator autonomy | gamification without competence signal | workplace application contested |
| Hook Model (Nir Eyal, 2014) | trigger, action, reward, investment cycle | Proactive Watch investment loop | hook without user-consented reward | Eyal's 2019 dark-pattern critique |
| Nudge Theory (Thaler & Sunstein, 2008) | default plus salience plus framing | safe defaults in `project-manifest.json` | hidden opt-outs | paternalism critique (Glaeser, 2006) |
| Transtheoretical Model (Prochaska & DiClemente, 1983) | six stages of change | operator-stage detection in MemPalace | stage assumed, not detected | crisp-boundary critique (Sutton, 2001) |
| Dual Process Theory (Kahneman, 2011) | System 1 vs System 2 | pre-commit friction triggers System 2 | slow copy where fast decision is needed | dichotomy oversimplified (Evans, 2014) |
| Jobs-to-be-Done (Christensen & Moesta, 2016) | functional, emotional, social job | persona-tier naming (Founder OS) | feature list without job named | quantitative validation disputed |
| MINDSPACE (UK Cabinet Office, 2010) | nine behavioral levers checklist | voice-profile messenger calibration | applying all nine simultaneously | empirical support uneven (Dolan, 2012) |
| Anchoring (Tversky & Kahneman, 1974) | reference-point bias | $79.99 anchors bundle discount | anchor unrelated to the decision | weak under expertise (Mussweiler, 2002) |
| Endowment Effect (Richard Thaler, 1980) | owned outweighs unowned | free-tier ownership feel | forcing forfeiture of "owned" features | fades with experience (List, 2003) |

Where others see a prompt library, I see an enforcement hook. The frameworks above are catalogued. The anti-patterns are registered. The outputs are scanned. Concrete invocations follow.

**1. Apply Fogg to a landing-page hero via `/mxm-cmo`:**

```bash
/mxm-cmo draft-hero \
  --framework fogg \
  --target "Founder OS waiting list" \
  --variant-id 1551386
# Output: hero copy where Motivation, Ability, and Prompt are each
# addressed in three sentences before the CTA fires.
```

**2. Declare the moat in an Maxim skill's frontmatter (ADR-007):**

```yaml
---
name: "Example Maxim skill"
business_outcome: "Reduces CTA abandonment; tracked in MOAT_TRACKER § MOAT-06"
primary_framework: "Fogg Behavior Model (B=MAP)"
---
```

**3. Enforce the moat via the `behavioral_audit` MCP call:**

```json
{
  "tool": "mcp__mxm-behavioral__behavioral_audit",
  "args": {
    "text": "Your landing copy here.",
    "required_frameworks": ["Fogg", "Cialdini", "Prospect Theory"]
  }
}
// Returns: { "pass": false, "missing": ["Ability lever"],
//            "suggestion": "..." }
```

## Anti-Patterns

Five failures catalogued from real Maxim pack development, documented so the mechanism is not silently eroded.

**1. Framework theater.** Naming a framework without applying its mechanism. Violates mechanism visibility per ADR-007 § 8.2. The reader detects the surface citation and trust collapses across the entire output.

**2. Over-stacking.** Three or more persuasion layers trigger psychological reactance (Brehm, 1966). Cialdini Authority plus Fogg Prompt plus Nudge Salience applied simultaneously read as manipulation. Two frameworks applied deliberately beat five applied at once.

**3. Context mismatch.** B2C scarcity urgency deployed in enterprise procurement violates SCARF's Certainty signal. Enterprise buyers need stability markers, not countdown timers. The framework itself is correct; the deployment context was wrong.

**4. Ungrounded scarcity.** "Only three left" without a real constraint. Cialdini himself warns that scarcity without truth produces trust collapse. Readers detect the hollow claim and discount every downstream signal from the same source.

**5. Friction-stripping where friction protects.** Removing confirmation on irreversible actions inverts the nudge. Thaler and Sunstein's core rule is "preserve freedom." Stripping the pause that lets a user undo a mistake is the nudge turned into a trap: same mechanism, opposite ethics.

## Pack Integrations

Three sibling packs deepen Behavioral Intelligence in specific ways. Pack L1.1 through L1.5 are the live ecosystem; no future packs referenced.

- **L1.5 Brand & Design Pro:** framework-tagged visual application. Cialdini Authority becomes typography hierarchy; SCARF Certainty becomes grid stability; Dual Process System 1 recognition is encoded in color semantics.
- **L1.3 Proactive Watch:** the `behavioral-moat-drift` checker (drift class 12) fails commits where Maxim skills stop citing frameworks. Behavioral Intelligence without continuous enforcement drifts toward generic prompt-library output within weeks.
- **L1.2 MemPalace Pro:** per-audience framework memory across sessions. Transtheoretical Model stage is tracked per operator in the knowledge graph; the next session resumes at the correct behavioral stage instead of defaulting to pre-contemplation.

Persuasion is not style. It is architecture. Behavioral Intelligence makes that architecture visible. Visible means auditable. Auditable means defensible.

*Team-tier operators get L1.6 Behavioral Intelligence inside Founder OS, Growth Stack, Professional OS, or Agency All-In at 47% off individual L1 pricing; the [pack catalog](../../../maxim/documents/business/sales-marketing/packs-catalog/mxm-pack-catalog-v1.0.0.md) has the full matrix.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
