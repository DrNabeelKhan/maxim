---
name: content-rules
version: 1.1.0
status: active
last_calibrated: 2026-04-20
calibration_source: E:\Projects\nabeelkhan\myVoiceDNA\
owner: DrNabeelKhan
managed_by: /mxm-brand-voice
see_also:
  - .brand-foundation/VOICE-MANAGEMENT.md
  - .brand-foundation/personal/voice-profile.md
  - .brand-foundation/personal/ai-tells.md
---

# Personal Content Rules

> Hard dos and don'ts that apply across every startup voice. Per-startup
> positioning may add additional rules but cannot override the rules below.
> Pair with `voice-profile.md` (identity + patterns) and `ai-tells.md`
> (banned language).
>
> **Updates governed by:** `/mxm-brand-voice` command + `.brand-foundation/VOICE-MANAGEMENT.md` protocol.
> **Version history:** `.brand-foundation/personal/versions/`.

---

## Always

- Lead with data or a specific claim. Never lead with a bare question.
- Cite the source of every statistic inline (not in footnotes).
- End every post with an implication or open question. Never with a summary.
- Use first person "I" freely. Not "one." Not passive constructions.
- Attribute ideas to their origin when building on someone else's work.
- Flesch-Kincaid target: Grade 8–10 for public content. Grade 12+ for technical or regulatory content. Overridable per startup.
- Pick a voice before drafting. Philosophical Architect for strategy, moat, positioning, governance. Friendly Educator for explainers, onboarding, LinkedIn long-form. Technical Educator for specs, compliance, API docs.
- Run the `ai-tells.md` scan before tagging output 🟢.
- Run the voice-validation checklist in `voice-profile.md` before tagging 🟢.

---

## Never

- Publish anything with `explored: false` wiki pages as the only source.
- Use AI-generated images for professional content.
- Make performance claims without citing data.
- Write in third person about myself.
- Start a sentence with "But" or "And" in formal documents.
- Use the word "just" to minimize complexity ("just deploy this" is dishonest).
- Use em-dashes in prose (see `ai-tells.md` for the replacement protocol).
- Blend more than 2 voices in a single piece.
- Write more than 20% of a piece in the secondary voice.
- Reproduce song lyrics, copyrighted text over 15 words, or anyone's writing without attribution.
- Open with "In today's [anything]...", "As an AI language model...", or "Great question!"
- Close with "To your success," "That's a wrap," or any emoji-based sign-off.

---

## Voice Selection Matrix

Pick the voice at the top of the draft. Lock it before writing a single sentence.

| Context | Primary Voice | Secondary (≤20%) |
|---|---|---|
| Maxim moat copy, positioning, landing page | Philosophical Architect | Friendly Educator (1 analogy max) |
| Sprint plan, documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md | Technical Educator | none |
| ADR, architecture decision | Philosophical Architect | Technical Educator (spec sections) |
| Book chapter, long-form white paper | Philosophical Architect | Friendly Educator (myth-busting openers) |
| Blog post (public) | Friendly Educator | Philosophical (1–2 reframings) |
| LinkedIn long-form | Friendly Educator | Philosophical (closing line only) |
| X / thread | Friendly Educator | none |
| Investor memo | Philosophical Architect | Technical Educator (metrics) |
| API reference, DEPLOY_CHECKLIST.md, SRD | Technical Educator | none |
| Compliance spec, security audit | Technical Educator | Philosophical (opening principle only) |
| Onboarding guide | Friendly Educator | Technical (setup steps) |
| Email (external) | Friendly Educator | none |
| Slack / internal | None required | Functional prose |

---

## Sentence Length Targets (by voice)

Rolling average across the paragraph, not individual sentences.

| Voice | Avg words | Paragraph length |
|---|---|---|
| Philosophical Architect | 22–32 words | 3–5 sentences |
| Friendly Educator | 15–18 words | 3–5 sentences |
| Technical Educator | 15–20 words | 3–4 sentences |

Vary sentence length inside each paragraph for rhythm. A long explanatory sentence followed by a short declarative carries weight. Three identical-length sentences in a row flatten the reader.

---

## Signature Pattern Requirements (per voice)

### Philosophical Architect (per 1500-word piece)

- 2–3 reframings ("X is not Y. It is Z.")
- 1–2 contrast revelations ("Where others see X, I see Y.")
- 1–2 metaphysical triads (three-step cascades)
- 1 stillness anchor ("Alignment is...")
- Vertical reasoning applied to the core concept (Surface → Structure → Essence → Strategic)
- 1 identity-level diagnosis if the piece discusses failure

### Friendly Educator (per 1500–2500 word piece)

- 3–7 analogies
- 1–2 myth-busting blocks
- Opening hook from the four approved templates
- Business reality anchoring: answer "so what, what do I do, what happens if I get it wrong"
- Three-part close: summary + takeaway + CTA

### Technical Educator (per spec)

- Scope + audience + assumed knowledge in the first paragraph
- Numbered requirements where applicable
- Explicit versioning and date stamps
- Rollback plan if the spec changes running systems

---

## Opening Discipline

| Voice | Approved opening patterns |
|---|---|
| Philosophical | Principle. Reframing. Identity-level observation. Never a definition. |
| Friendly | Relatable question with ground. Pain acknowledgment. Industry observation. Bold declaration. |
| Technical | Scope statement. Version statement. Audience statement. |

Never open with: "In today's...", "As an AI...", "Great question!", a bare question with no ground, a definition pulled from a dictionary, or any banned opener from `ai-tells.md`.

---

## Closing Discipline

| Voice | Approved closing patterns |
|---|---|
| Philosophical | Destiny framing. Strategic imperative. Open question that reframes. |
| Friendly | Summary bullets. Actionable takeaway. Community CTA (invite discussion). |
| Technical | Compliance checklist. Rollback plan. Version stamp. |

Never close with: "That's a wrap," "To your success," "I hope this helps," any emoji, or a restatement of the opener.

---

## Content Tiers (Review Requirements)

| Tier | Human Review | Wiki Confidence Required |
|---|---|---|
| Investor memo | Full review | `confidence: high` only |
| LinkedIn long-form | Light edit | `medium` or above |
| X / thread | Skim review | `medium` or above |
| Pack catalog / moat copy | Full review | `confidence: high` only |
| Product landing page | Full review | `confidence: high` only |
| Internal docs | None | any |
| Slack / email | None | any |

---

## Citation Format

Inline links preferred over footnotes.

```
According to [a 2026 IDC report](https://example.com), AI infrastructure spend
crossed $200B globally, up 47% year-over-year.
```

NOT:

```
According to a recent IDC report¹, AI infrastructure spend crossed $200B globally.
[1] IDC AI Infrastructure Report 2026
```

Every statistic carries a citation. Every framework citation names the originator (Fogg, Cialdini, Kahneman, Ryan and Deci, etc.) inline on first mention.

---

## Quote Format

- Block-quote anything 20+ words.
- Inline-quote 5–19 words.
- Never quote 1–4 words. Paraphrase and attribute.

---

## Bulletpoint Format

- Use hyphens (`-`). Never arrows (`→`). Never asterisks (`*`).
- One idea per bullet.
- Parallel grammar. All nouns, or all verbs. Not mixed.
- Max 7 bullets per list. Split into sub-headers if more are needed.
- Lead every bullet with the strongest word, not a filler article.

---

## Number and Claim Discipline

- Numbers without citations are banned outside internal docs.
- "47%" beats "nearly half."
- "N=47 professionals in an A/B test" beats "our research shows."
- If the claim is directional, say so: "trending toward."
- Never use round numbers (100%, 50%) as proxies for real data.

---

## Brand Foundation Loading Protocol

For any external-facing content, agents apply in order:

1. Load `.brand-foundation/personal/voice-profile.md` (identity + patterns)
2. Load `.brand-foundation/personal/ai-tells.md` (banned language)
3. Load `.brand-foundation/personal/content-rules.md` (this file: structural rules)
4. Detect active startup from `cwd` or `config/project-manifest.json`
5. Load matching `.brand-foundation/startups/{detected}/positioning.md + audience.md + compliance-rules.md` if present
6. Apply precedence: personal rules override startup rules for voice and structure. Startup compliance overrides personal for regulated content.
7. Before output: run the voice-validation checklist from `voice-profile.md`.
8. Before output: run the `ai-tells.md` banned-phrase scanner.
9. Tag 🟢 HIGH only after both pass clean.

---

> **How agents use this file:** Apply rules in priority order. ALWAYS rules are non-negotiable. NEVER rules trigger immediate rewrite. Voice selection matrix locks before drafting. Content tier determines review queue routing. Every external output is tagged 🟢 HIGH only after voice + ai-tells + content-rules all pass clean.
