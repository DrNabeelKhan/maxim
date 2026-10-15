---
skill_id: design-systems
name: Design Systems
version: 2.0.0
category: design-ux
type: framework
frameworks: []
triggers:
  - design system
  - design tokens
  - component library governance
  - scale design consistency
  - design system adoption
collaborates_with:
  - ui-designer
  - frontend-developer
  - brand-guardian
  - documentation-writer
ethics_required: false
priority: high
tags: [design-ux, framework, design-tokens, components, governance]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Design Systems

## Purpose
Use a design system to give a product organisation one shared source of design decisions: **tokens** for values such as colour and spacing, **components** that implement them in code, **guidelines** for using them, and **governance** for how they change. A component library alone is not a design system; what makes it one is that it is maintained, documented and adopted. Its payoff is consistency and speed at scale, since teams stop re-solving the same problems.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `design-systems` |
| Category | Design and UX — Systems and Governance |
| Version | 2.0.0 |
| Key references | Kholmatova, *Design Systems* (2017) · Frost, *Atomic Design* (2016) |
| Token standard | W3C Design Tokens Community Group format (in development) |
| Public examples | Google Material Design · IBM Carbon · GOV.UK Design System |

## The Parts
- **Design tokens**: named values for colour, typography, spacing, radius and motion, often in tiers from raw values to semantic names to component-specific ones.
- **Components**: reusable, accessible UI built from tokens, in design files and in code.
- **Guidelines**: when and how to use each component, with examples.
- **Governance**: who owns the system, how contributions are made, and how changes are versioned and communicated.

**Team models**: a central team owns the system, a federated model shares ownership across product teams, or a hybrid of both.

## Core Principles
- **One source of truth for design decisions,** shared by design and code.
- **Semantic tokens over raw values.** Name what a colour is for, not what it is.
- **Adoption is the measure of success,** not the size of the library.
- **Version and communicate changes** like any software dependency.
- **Accessibility built in** once, in the components, rather than fixed repeatedly in products.

## Applications & Use Cases
| Use Case | Application | Part |
|---|---|---|
| Multiple products drifting apart | Shared tokens and components | Tokens, components |
| Rebrands | Change tokens once, cascade everywhere | Tokens |
| Dark mode and theming | Semantic token sets per theme | Tokens |
| Slow feature delivery | Reuse components instead of building new | Components |
| Inconsistent usage | Document usage with examples | Guidelines |
| Many contributors | Contribution and review process | Governance |

## Usage Guidelines
- **Start with an inventory** of existing UI and its inconsistencies.
- **Define tokens in tiers**, from primitive values to semantic names.
- **Build components accessibly** and test them before release.
- **Publish usage guidance with examples** of correct and incorrect use.
- **Set up governance early**: ownership, contribution, versioning and deprecation.

## Prompt Template
```
You are designing or auditing a design system.

TOKENS: primitives -> semantic -> component tiers; themes?
COMPONENTS: inventory, gaps, duplicates, accessibility status
GUIDELINES: documented usage with examples?
GOVERNANCE: owner · contribution model · versioning · deprecation
ADOPTION: which products use it, and where do they diverge?
```

## Ethical Guidelines
- **Accessibility is a requirement of the system**, so every product built on it inherits compliance.

## Testing Strategy
- Unit, accessibility and visual regression tests for every component.
- Track adoption and divergence across products.

## Success Metrics
- Adoption across products and screens.
- Share of UI built from system components.
- Accessibility issues traced to components versus products.
- Time to deliver common features.

## Collaboration Protocol
- Inbound from: `ui-designer` · `frontend-developer` · `brand-guardian`
- Outbound to: `documentation-writer` for guidelines
- Cross-framework: Atomic Design structures the components; brand guidelines supply the visual rules; WCAG sets accessibility requirements.

## Related Skills
- `composable-skills/frameworks/atomic-design/SKILL.md` — component hierarchy
- `composable-skills/frameworks/brand-guidelines/SKILL.md` — visual rules to encode
- `composable-skills/frameworks/wcag/SKILL.md` — accessibility requirements

## Reference Materials
- Kholmatova, A. (2017). *Design Systems: A Practical Guide to Creating Design Languages for Digital Products.* Smashing Magazine.
- Frost, B. (2016). *Atomic Design.*
- W3C Design Tokens Community Group. *Design Tokens Format Module* (draft).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
