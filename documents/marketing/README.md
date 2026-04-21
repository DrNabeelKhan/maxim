# Maxim — Marketing

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

Public marketing collateral for Maxim. These files are source material for the landing page at https://maxim.isystematic.com, the GitHub repository social page, partner-facing one-pagers, and press/media kits. Everything in this folder is intended to be externally visible.

Private sales internals (launch drafts, allocation models, landing-design development specs) live in `documents/sales/` and are gitignored.

---

## Contents

| Folder | Purpose |
|---|---|
| [`one-pagers/`](one-pagers/) | Single-page product summaries for media kits and partner meetings |
| [`catalogues/`](catalogues/) | Full Maxim product catalog — all capabilities, tiers, and verticals |
| [`packs-catalog/`](packs-catalog/) | Detailed pack-level catalog — L1 capabilities, L2 bundles, L3 vertical overlays with pricing and target segment per pack |
| [`case-studies/`](case-studies/) | Customer stories and deployment outcomes |
| [`comparisons/`](comparisons/) | Maxim vs generic LLM wrappers, Maxim vs competitor frameworks |
| [`decks/`](decks/) | Investor decks, partner decks, and conference-talk material |
| [`video-scripts/`](video-scripts/) | Scripts for demo videos and launch announcements |
| [`github-repo-page/`](github-repo-page/) | GitHub repository social-preview, badges, bio, and README hero design spec |
| [`partner-programs/`](partner-programs/) | Partner-facing collateral — co-marketing guidelines, reseller enablement |

---

## How these files are used

- **Landing page** (`maxim.isystematic.com`): content editors and AI crawlers pull from this folder into MDX routes at `/pricing`, `/why-maxim`, `/compare`, `/one-pager`, and related pages. When the landing page needs source material for a new page, it comes from here, not from scratch.
- **Sales enablement**: partners, resellers, and the sales team reference the catalogues and pack-catalog as the canonical pricing + positioning source. The one-pagers are the attachable PDF-ready summary for press and early buyers.
- **Social + press**: the video-scripts, comparisons, and case-studies are starting points for blog posts, Twitter/X threads, and LinkedIn articles. Adapt, don't copy verbatim.
- **Partner programs**: the partner-programs folder is the source for any external partner or reseller rollout.

---

## What stays private

Content about Maxim's commercial strategy that would reveal internal decisions (pricing elasticity testing, customer allocation models, launch-day ordering, or specific investor-deck financials) lives in `documents/sales/` and is gitignored. If a new marketing asset draws on private material, author a public-facing version here and leave the private source where it is.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
