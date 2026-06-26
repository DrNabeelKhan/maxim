---
name: L1.3 Proactive Watch
description: "Eight drift classes scanned continuously. Catches regressions before they ship."
business_outcome: "Drift-detection precision >=85% with mean-time-to-detect under 24 hours; tracked in documents/ledgers/MOAT_TRACKER.md § MOAT-03."
primary_framework: "Signal Detection Theory (Green & Swets, 1966)"
product_id: L1.3
lemonsqueezy_variant_id: 1551516
pack_tier: L1
ships_with: v1.0.0
license: proprietary
---

# L1.3 Proactive Watch

## The Maxim Moat

Drift is not a bug. Drift is the default state of any system under load. L1.3 Proactive Watch is the pack that treats drift detection as continuous infrastructure rather than a periodic audit.

Most codebases ship with drift already in flight. Declared reality (docs, inventories, ADRs, compliance claims) and actual reality (filesystem, git, dependencies) diverge silently between commits. Teams do not fail audits because drift exists. They fail because drift was assumed to fix itself.

The replication barrier is the checker registry. Eight drift classes run against every Maxim repo, gated to this pack: MCP health, skill-gap accumulation, moat drift, brand drift, compliance drift, behavioral-framework coverage, external-boundary drift, and behavioral-moat drift. Each class is a named checker with a false-alarm budget, a hit-rate target, and a remediation path. Competitors can write one-off lint scripts. They cannot produce a signal-theoretic registry that distinguishes true drift from measurement noise with documented precision. Watch is not a script. Watch is a signal-processing discipline applied to repo state.

## Business Outcome

L1.3 Proactive Watch applies Signal Detection Theory (Wilson P. Tanner, John Swets, and David Green, 1954; consolidated in Green & Swets, 1966) as the statistical substrate for the entire pack. Every checker is calibrated for hit rate against false-alarm rate; miss rate is measured, not ignored. Outcome claims accumulate in the living ledger at `documents/ledgers/MOAT_TRACKER.md` § MOAT-03.

Primary metric: drift-detection precision rate. Computed as true-positive alerts divided by total alerts (true positives plus false positives). Target post-v1.0.0: ≥85%. Secondary metrics: false-alarm rate under 15% per rolling 30-day window, missed-signal rate under 5% (measured via quarterly audit spot-checks), mean-time-to-detect in hours from drift introduction to first alert (target under 24 hours for repo-local classes).

## Primary Behavioral Framework

**Framework:** Signal Detection Theory.

**Mechanism:** every detector faces two orthogonal errors. Hits and misses track whether real signal was recognized. False alarms and correct rejections track whether noise was resisted. The detector's position on the Receiver Operating Characteristic curve is a design choice: a checker tuned for maximum hit rate will produce false alarms; a checker tuned for low false-alarm rate will miss real drift. There is no free lunch at the operating point; only a deliberate trade-off.

**Source:** W.P. Tanner, J.A. Swets, and D.M. Green, perceptual-decision research at the University of Michigan (1954); consolidated in Green & Swets, *Signal Detection Theory and Psychophysics* (1966).

**Application:** each of the eight gated drift classes ships with a documented operating point. The `behavioral-moat-drift` class runs hot (maximum hit rate; false alarms tolerated because the cost of a missed moat-regression is compounding). The `brand-drift` class runs cool (low false-alarm rate; operators flag and review only high-confidence drift so alert fatigue does not erode trust). Every class logs its actual hit and false-alarm rates; calibration is continuous, not one-time.

**Critique:** Signal Detection Theory assumes a fixed signal distribution, which real repos do not provide. Drift types evolve as codebases evolve; today's false-alarm pattern is tomorrow's signal. Maxim handles this by versioning checker thresholds per release and re-tuning them when the ROC curve shifts materially.

## Behavioral → Proactive Watch Translation

The five frameworks below operate on one of three surfaces: detection accuracy, alert-handling behavior, or remediation behavior. Signal Detection Theory governs detection. The others govern what happens after a signal fires.

| Framework | Mechanism | Maxim positive | Maxim anti-pattern | Boundary |
|---|---|---|---|---|
| Signal Detection Theory (Green & Swets, 1966) | hit rate vs false-alarm rate trade-off | per-class operating point documented in `watch-profile.yml` | one threshold across all 8 classes | stationary-distribution assumption violated in evolving repos |
| Dual Process Theory (Daniel Kahneman, 2011) | System 1 / System 2 | LIGHT scan fires System 1 awareness; DEEP scan demands System 2 review | DEEP scan on every commit causes alert fatigue | dichotomy oversimplified (Evans, 2014) |
| SCARF — Certainty (David Rock, 2008) | certainty as reward signal | non-disruptive signaling preserves operator flow | pop-up-style alerts on LIGHT scan violations | SCARF not peer-reviewed at aggregate |
| Broken Windows Theory (James Q. Wilson & George L. Kelling, 1982) | small unfixed signals escalate | first drift fixed within 48 hours prevents cascade | first drift ignored; second drift unreviewed | disputed in criminology (Harcourt, 2001), retained here for software drift by analogy |
| Zeigarnik Effect (Bluma Zeigarnik, 1927) | open loops consume attention | `.mxm-skills/review-queue.md` closes loops via human triage | review queue grows unbounded | effect size contested in modern replications |

Where others see alert fatigue, I see an untuned operating point. The fix is calibration, not silencing. Concrete invocations follow.

**1. Run `/mxm-watch light` for fast pre-commit drift scan:**

```
$ /mxm-watch light
  [class-01 inventory-drift]            PASS
  [class-02 session-memory-staleness]   PASS
  [class-03 version-drift]              PASS
  [class-04 changelog-gap]              WARN (CHANGELOG.md missing v1.0.0 entry)
  [class-08 compliance-drift]           PASS
  [class-12 behavioral-moat-drift]      FAIL (pack-l1-6 SKILL.md missing §6)
Scan complete: 4 PASS, 1 WARN, 1 FAIL. Next action: review FAIL before commit.
```

**2. Tune checker operating points in `config/watch-profile.yml`:**

```yaml
version: 1.0
repo: maxim
classes:
  behavioral-moat-drift:
    operating_point: hot       # max hit rate; false alarms tolerated
    fail_on: [missing_section, missing_frontmatter_field]
    warn_on: [section_word_count_below_target]
  brand-drift:
    operating_point: cool      # low false-alarm rate
    sample_rate: 0.1           # scan 10% of outputs per run
    fail_on: [voice_scan_failure_repeated_3x]
```

**3. `behavioral-moat-drift` checker output (class 12) against a single SKILL.md:**

```json
{
  "class": "behavioral-moat-drift",
  "target": "packs/pack-l1-6-behavioral-intelligence/SKILL.md",
  "verdict": "FAIL",
  "findings": [
    { "field": "frontmatter.business_outcome", "status": "present" },
    { "field": "frontmatter.primary_framework", "status": "present" },
    { "section": "The Maxim Moat", "status": "present", "word_count": 204 },
    { "section": "Anti-Patterns", "status": "present", "count": 5 },
    { "section": "Pack Integrations", "status": "missing" }
  ],
  "remediation": "Add Pack Integrations section per ADR-007."
}
```

## Anti-Patterns

Five failures catalogued from drift-detection deployments, documented so the signal-to-noise ratio is not silently eroded.

**1. Alert fatigue.** Every drift fires at the same severity. Operators mute everything, including the real signal. Dual Process overload converts a useful alarm system into background noise.

**2. False-alarm dominance.** A checker tuned too hot on a noisy corpus. Operators learn to ignore the class. Signal Detection Theory warns that a detector trusted below its actual hit rate is worse than no detector at all.

**3. Missed-signal dominance.** A checker tuned too cool. Real drift slips through. The operator learns to trust the green light, and by the time the drift surfaces, it has compounded. Broken Windows cascade begins.

**4. Silent mode.** All alerts disabled to "unblock shipping." Drift continues unobserved. Zeigarnik's open loops accumulate in the review queue but never fire for attention. Nothing fails; everything erodes.

**5. Manual re-check.** Trusting humans to catch what automation should detect. Human vigilance is Dual Process System 2; sustained System 2 attention is expensive and fragile. Automation is continuous; humans are episodic.

## Pack Integrations

Three sibling packs deepen Proactive Watch in specific ways. Pack L1.1 through L1.6 are the live ecosystem; no future packs referenced.

- **L1.4 Compliance Shield:** the `compliance-drift` class (drift class 8) gets teeth. Fourteen regulated frameworks checked continuously rather than at audit time. Certainty returns to regulated-industry operators.
- **L1.1 AI Governance:** audit-trail-drift detection prevents silent governance erosion. When an AI decision ships without the confidence tag, the class fails the commit and the operator sees which skill regressed.
- **L1.6 Behavioral Intelligence:** the `behavioral-moat-drift` class (drift class 12) enforces the 7-section ADR-007 structure on every skill. Behavioral Intelligence without continuous enforcement drifts toward generic prompt-library output within weeks.

Drift is inevitable. Detection is calibrated. Remediation is fast. Those three sentences describe every mature engineering culture; Proactive Watch is the pack that makes them load-bearing instead of aspirational.

*Team-tier operators get L1.3 Proactive Watch inside Founder OS, Growth Stack, Professional OS, or Agency All-In at 47% off individual L1 pricing; the [pack catalog](../../../maxim/documents/business/sales-marketing/packs-catalog/mxm-pack-catalog-v1.0.0.md) has the full matrix.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
