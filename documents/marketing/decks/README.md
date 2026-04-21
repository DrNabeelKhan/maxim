# decks/

> Pitch decks, investor decks, sales decks, executive briefings.

## Naming

`<audience>-<YYYY-MM-DD>.md` (source) + binary exports alongside (`.pptx`, `.pdf`, `.key`).

Examples:
- `seed-investor-2026-04-17.md` + `seed-investor-2026-04-17.pptx`
- `enterprise-sales-2026-Q2.md` + `.pdf`
- `board-update-2026-04.md` + `.pptx`

## Artifact types

- Investor decks (seed / Series A / update decks)
- Sales decks (enterprise pitch, SMB pitch)
- Executive briefings (customer-facing, 10–15 slides)
- Conference talks / keynote decks
- Internal all-hands decks
- Board updates

## Template (source markdown mirrors slide structure)

```markdown
# <Deck Title>

**Audience:** <investor | enterprise buyer | SMB | board | conference>
**Date:** YYYY-MM-DD
**Speaker:** <name>
**Duration:** <N min>
**Exports:** <.pptx | .pdf | .key alongside>

---

## Slide 1 — Title
<Visual description + speaker note>

## Slide 2 — <Section>
<Bullet copy + speaker note>

## Slide N — Close / CTA
<Ask + next step>

---

## Speaker Notes
<Any extended notes not on-slide>

## Q&A preparation
- Q: ...
- A: ...

## Related artifacts
- Catalogue: catalogues/<relevant>.md
- Case studies: case-studies/<relevant>.md
- One-pager: one-pagers/<relevant>.md
```

## Rules

- Apply Duarte Sparkline + McKinsey Slide Logic (Maxim `slides` skill)
- Apply Minto Pyramid + Dual Coding Theory
- Embargoed decks (pre-announce) go under `.secrets/` until release
- Binary exports (`.pptx`, `.pdf`) committed alongside source `.md` where possible
- For large binary assets, use Git LFS or reference an S3/Drive link
