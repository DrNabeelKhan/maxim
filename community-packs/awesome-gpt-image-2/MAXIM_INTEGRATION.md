# awesome-gpt-image-2 — Maxim Integration

> Community pack (ADR-008). Source: [`freestylefly/awesome-gpt-image-2`](https://github.com/freestylefly/awesome-gpt-image-2) · **MIT** · ~8.3k★.
> Consumed by the `ai-media-generation` skill under the three-layer external-tool pattern (ADR-018).

## What this is

A **"Prompt-as-Code"** engine and template library for **GPT-Image-2** (OpenAI's image model): 500+ reverse-engineered case prompts and **21 industrial prompt templates** distilled into a structured **atomic schema** (subject · composition/layout · style/materials · lighting · info-hierarchy), designed to be reused by agents rather than hand-written each time. Upstream also ships a Claude **Agent Skill** (`agents/skills/gpt-image-2-style-library/`) and a `.claude-plugin/`.

## Why Maxim consumes it (and how)

Image generation is the missing sibling to Maxim's design skills (`banner-design`, `logo-concepts`, `slides`, `design-system`) and the future `/mxm-video`. Rather than rebuild a prompt library, Maxim **consumes this MIT one** and adds the moat on top:

| Layer (ADR-018) | What | Where |
|---|---|---|
| **1 — Community pack** | The MIT template library + atomic schema (this pack) | `community-packs/awesome-gpt-image-2/` |
| **2 — Maxim skill (the overlay)** | Behavioral framing (ADR-007: pre-attentive attributes, visual hierarchy, color psychology, Fitts' Law for UI mockups) + brand-foundation voice (on-brand image prompts) + confidence tagging (ADR-010) | `.claude/skills/ai-media-generation/SKILL.md` § Image Generation (GPT-Image-2) |
| **3 — Generation MCP** *(future, gated)* | Actually call the image API (OpenAI images / aggregator) to produce pixels | not built — key in Doppler; Maxim is model-agnostic (`Maxim_MODEL_PROVIDER=openai`) |

**Dispatch rule (ADR-008):** used raw (templates only, no overlay) → flag output `🔴 Maxim-UNENHANCED`. Used through the `ai-media-generation` skill → the full behavioral + brand + confidence overlay applies (`🟢 HIGH`).

## What's vendored vs referenced

- **Vendored here:** this integration note + the upstream `LICENSE` (MIT).
- **Referenced upstream (MIT, not copied — avoids bloating the repo with 500+ case files):**
  - Agent Skill: `agents/skills/gpt-image-2-style-library/SKILL.md` — intent → production-ready prompt via categories / style tags / scene tags / pitfalls.
  - `docs/templates.md` — the 21 industrial fill-in-the-blank templates (UI · charts/infographics · posters · brand · product · character · scene · document) + JSON "advanced" templates for agent calls + per-template pitfall guides.
  - `docs/gallery*.md` — the 500+ reverse-engineered case prompts (browse for a visual direction, then apply the matching template).

When a task needs the actual templates, pull the specific upstream file on demand (it's MIT); do not mirror the whole gallery into this repo.

## Positioning

**"Maxim governs the prompt, the brand, and the generation"** — not a raw model wrapper. The atomic schema gives controllability; the Maxim overlay gives on-brand, framework-justified, confidence-tagged image prompts that read as intentional design, not slot-machine output.

## Attribution

Prompt templates and the style-library skill are © 2026 freestylefly, MIT. This pack and the `ai-media-generation` overlay are © 2026 iSystematic Inc.; the overlay is BSL 1.1 and is not part of the MIT material.
