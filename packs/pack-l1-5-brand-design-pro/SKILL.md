---
name: L1.5 Brand & Design Pro
description: "Your brand voice locked across AI outputs. 15 cinematic styles. Design that does not read as AI."
business_outcome: "Brand-voice scan first-pass rate >=90% post-calibration; mechanism tracked in documents/ledgers/MOAT_TRACKER.md § MOAT-05."
primary_framework: "Dual Process Theory (System 1 / System 2)"
product_id: L1.5
lemonsqueezy_variant_id: 1551390
pack_tier: L1
ships_with: v1.0.0
license: proprietary
---

# L1.5 Brand & Design Pro

## The Maxim Moat

A brand is not a style guide. It is the speed at which a reader recognizes you. L1.5 Brand & Design Pro is the pack that makes that speed measurable and defensible across every AI-generated surface.

Most AI design tools produce outputs that read as AI. Fonts drift. Colors shift. Voice dilutes across sessions. Brands do not fail because their logos are wrong. They fail because consistency is assumed, not enforced.

The replication barrier is the three-layer .brand-foundation load (Maxim base, operator overlay, startup overlay), plus the `/mxm-brand-voice scan` pre-commit hook, plus the VOICE-MANAGEMENT protocol that archives every voice revision with a coherence check against prior samples. Competitors can copy a color palette. They cannot copy the load order, the scan hook, and the archived ruleset that compound over months of operator calibration. Brand integrity is not a design deliverable. Brand integrity is an enforcement hook that fires every time an output ships.

## Business Outcome

Brand & Design Pro applies Dual Process Theory (Daniel Kahneman, 2011) as the recognition scaffold across every generated brand surface. System 1 completes visual recognition in under 200 milliseconds; System 2 verifies trust signals against the operator's voice profile and startup positioning. Outcome claims accumulate in the living ledger at `documents/ledgers/MOAT_TRACKER.md` § MOAT-05.

Primary metric: brand-voice scan first-pass rate, the percentage of outputs that pass `/mxm-brand-voice scan` without rewrite on the first attempt. Target post-calibration: ≥90%. Cold-start range during week one: 60–75%, expected to rise as the `personal.local/` overlay converges on the operator's real samples. Rolling window: 30 days per operator per startup. Secondary metrics: operator-reported brand confidence on a 1-to-5 scale, AI-tell detection rate per 1000 words, and cross-surface consistency score across Claude Web, Cowork, and CLI.

## Primary Behavioral Framework

**Framework:** Dual Process Theory (System 1 / System 2).

**Mechanism:** human cognition runs two parallel paths. System 1 is fast, automatic, pattern-matching; it processes visual cues (color, shape, typography, rhythm) in under 200 milliseconds without conscious attention. System 2 is slow, deliberate, rule-checking; it verifies trust signals, reads messaging, and decides whether the surface earns continued attention. Brand is the discipline of making System 1 recognize you instantly and System 2 find nothing that contradicts the first impression.

**Source:** Daniel Kahneman, *Thinking, Fast and Slow* (2011); foundations in Evans (1984) and Stanovich & West (2000).

**Application:** every brand-producing Maxim output is composed against both systems. System 1 is served by pre-attentive cues: color hierarchy, grid stability, typography consistency, figure-ground control. System 2 is served by voice discipline: the three-layer .brand-foundation load, the ai-tells scanner, the content-rules checklist. Dual Process is the scaffold within which Cialdini's Consistency operates. First exposure fires System 1 recognition. Returning exposure activates the Consistency commitment via System 2. Recognition creates familiarity. Familiarity creates trust. Trust creates loyalty.

**Critique:** the dual-process dichotomy is often oversimplified. Evans (2014) critiqued the binary framing as too clean for real cognition, which runs on multiple interacting processes. Maxim treats the two systems as useful abstractions for design decisions, not as strict cognitive boundaries.

## Behavioral → Brand Translation

The five frameworks below operate on one or both systems. None of them replaces Dual Process. Each defines where in the recognition loop the framework fires.

| Framework | Mechanism | Maxim positive | Maxim anti-pattern | Boundary |
|---|---|---|---|---|
| Dual Process Theory (Kahneman, 2011) | System 1 / System 2 | System 1 cues plus System 2 voice discipline | slow copy where fast decision is needed | dichotomy oversimplified (Evans, 2014) |
| Pre-attentive Attribute Theory (Colin Ware, 2004) | visual processing under 200ms | `banner-design` color hierarchy as System 1 signal | decorative color without semantic hierarchy | attributes interact non-linearly at high density |
| Cialdini's Consistency (Robert Cialdini, 1984) | commitment once adopted | voice-profile version archive enforces commitment | rigid rules across mismatched verticals | breaks when brand must evolve quickly |
| SCARF — Certainty (David Rock, 2008) | certainty as reward or threat | grid stability signals Certainty to enterprise buyers | scarcity urgency destroys Certainty on B2B | SCARF not peer-reviewed at aggregate |
| Aesthetic-Usability Effect (Noam Tractinsky & Katz, 1997) | beautiful reads as more usable | cinematic-styles apply visual polish as trust signal | beautiful surface over broken UX | halo decays under task friction |

Where others see a design system, I see a recognition loop. The five frameworks above feed one decision: does the reader's System 1 know you in under 200 milliseconds, and does System 2 find nothing that contradicts the first impression. Concrete invocations follow.

**1. Run `/mxm-brand-voice scan` against a draft (PASS report):**

```
$ /mxm-brand-voice scan documents/blog-post.md
  voice-profile v1.1.0 loaded
  ai-tells v1.1.0 loaded
  content-rules v1.1.0 loaded
  personal.local overlay detected; startup: isystematic
Scan complete:
  em-dashes in prose     : 0
  banned phrases         : 0
  filler adverbs         : 2 (line 34: "actually"; line 58: "just")
  reframings             : 2 of 2 target
  sentence avg           : 24.1 words (Philosophical target 22-32)
  Flesch-Kincaid grade   : 10.3 (target 10-12)
Verdict: FAIL — remove 2 filler adverbs, rescan.
```

**2. Per-startup positioning overlay (`.brand-foundation/startups/<name>/positioning.md`):**

```yaml
---
name: isystematic-positioning
version: 1.0.0
extends: .brand-foundation/personal.local/voice-profile.md
vertical: enterprise-systems
audience:
  - Fortune 500 CIOs
  - enterprise architects with 15+ years experience
compliance_overlay: compliance-rules.md
additional_banned:
  - "digital transformation"
  - "journey"
voice_shifts:
  sentence_avg: 26   # slightly longer than personal base
  authority_source: "25+ years, TOGAF, PhD in Neuro-marketing"
---
```

**3. Cinematic-style invocation with Pre-attentive annotations in the output:**

```bash
/mxm-design cinematic \
  --style "product-360" \
  --subject "mxm-pack-engine dashboard hero" \
  --.brand-foundation isystematic \
  --emit-annotations
# Output shape:
#   cinematic_style: product-360
#   pre_attentive_attributes (System 1):
#     color_hierarchy: ["brand-primary", "brand-secondary", "neutral-900"]
#     figure_ground:   "high-contrast subject / blur background ratio 3.8"
#     motion_vector:   "slow-pan 14s, eye-track preserved"
#   trust_signals (System 2):
#     voice_consistency: PASS
#     compliance_scan:   PASS (SOC2, GDPR applicable)
```

## Anti-Patterns

Five failures catalogued from real Maxim brand and design work, documented so the recognition loop is not silently eroded.

**1. Brand theater.** A logo dropped onto generic design with no token system underneath. No Consistency mechanism fires. The reader's System 1 pattern-matches to "generic startup," and System 2 stops verifying because nothing in the surface rewards the effort.

**2. Aesthetic-usability masquerade.** Beautiful surface on broken UX. Tractinsky himself warned about overreliance on the halo. When a task fails inside a gorgeous interface, the aesthetic effect inverts, and trust collapses faster than it would on a plain-but-working surface.

**3. Color without semantics.** Decorative color that carries no System 1 signal. Violates pre-attentive hierarchy: the reader detects no figure-ground, no priority, no rhythm. The surface reads as "expensively decorated" rather than "professionally designed." Color must encode meaning or it encodes noise.

**4. Rigid Consistency.** Brand rules applied across mismatched verticals. Consistency without contextual adaptation activates SCARF Certainty in the wrong direction: the reader feels the surface is stable but irrelevant. Mechanism intact, deployment context wrong.

**5. Over-design.** Too many pre-attentive cues competing for System 1 attention. The reader cannot identify a focal point; default behavior is "skip." Four cues applied deliberately beat nine cues applied at once (MINDSPACE salience guidance, Dolan, 2012).

## Pack Integrations

Three sibling packs deepen Brand & Design Pro in specific ways. Pack L1.1 through L1.6 are the live ecosystem; no future packs referenced.

- **L1.6 Behavioral Intelligence:** behavioral frameworks apply to the copy that lives inside the brand frame. Cialdini Authority becomes typography hierarchy; SCARF Certainty becomes grid stability; Fogg Prompt placement serves System 2 decision moments.
- **L1.2 MemPalace Pro:** per-project brand memory across months. The knowledge graph stores voice drift over time; when a new Maxim session opens on an ongoing project, the brand state loads where the last session left it, not where the generic base voice assumes.
- **L1.1 AI Governance:** every brand-voice scan result is logged to the audit trail. Brand compliance becomes defensible; which outputs passed, which required rewrite, and when the voice profile last updated are queryable facts rather than claims.

Brand is not a deliverable. Brand is what survives the next ten thousand outputs. Build the enforcement hook, and the brand builds itself.

*Team-tier operators get L1.5 Brand & Design Pro inside Founder OS, Professional OS, or Agency All-In at 47% off individual L1 pricing; the [pack catalog](../../../maxim/documents/business/sales-marketing/packs-catalog/mxm-pack-catalog-v1.0.0.md) has the full matrix.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
