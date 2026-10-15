---
skill_id: atomic-design
name: Atomic Design
version: 2.0.0
category: design-ux
type: framework
frameworks: []
triggers:
  - atomic design
  - atoms molecules organisms
  - component hierarchy
  - build a component library
  - pattern library structure
collaborates_with:
  - ui-designer
  - frontend-developer
  - design-system-lead
ethics_required: false
priority: medium
tags: [design-ux, framework, components, design-systems, ui-architecture]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Atomic Design

## Purpose
Use Atomic Design to build interfaces as a hierarchy of reusable parts, from the smallest elements up to complete pages. Brad Frost introduced it in 2013 and expanded it in his 2016 book, borrowing a chemistry metaphor. Its value is a shared vocabulary between designers and developers and a structure that makes consistency the default: pages are assembled from components rather than designed one by one.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `atomic-design` |
| Category | Design and UX — Interface Architecture |
| Version | 2.0.0 |
| Originator | Brad Frost |
| First published | 2013 (article); 2016 (book) |
| Primary reference | Frost, *Atomic Design* (2016) |

## The Five Stages
1. **Atoms**: basic elements that cannot be broken down usefully, such as a label, an input or a button.
2. **Molecules**: small groups of atoms working as a unit, such as a search field with its label and button.
3. **Organisms**: complex sections made of molecules and atoms, such as a site header.
4. **Templates**: page-level layouts that place organisms in a structure, using placeholder content.
5. **Pages**: templates filled with real content, which test whether the system holds up.

## Core Principles
- **Build from small to large**, but design with the whole page in view.
- **Reuse before you create.** A new component is a deliberate decision, not a default.
- **Templates show structure; pages test reality.** Real content exposes edge cases placeholders hide.
- **The metaphor is a guide, not a rule.** Teams adapt the level names to what works for them.
- **A shared vocabulary reduces handoff friction.**

## Applications & Use Cases
| Use Case | Application | Stage |
|---|---|---|
| Starting a component library | Inventory and group existing UI | Atoms, molecules |
| Reducing inconsistency | Replace one-off elements with shared components | All |
| Designer–developer handoff | Name components the same way in design and code | All |
| New page design | Compose from existing organisms first | Templates |
| Content stress-testing | Test pages with real, extreme content | Pages |
| Design system documentation | Organise docs by level | All |

## Usage Guidelines
- **Run an interface inventory** of existing UI before building anything new.
- **Define atoms with design tokens** for colour, type and spacing, so changes cascade.
- **Name components consistently** across design files and code.
- **Test with real content at the page level**, including long names and empty states.
- **Document each component's purpose and variants.**

## Prompt Template
```
You are structuring an interface with Atomic Design (Frost 2016).

SCREEN OR FEATURE: [[...]]
ATOMS:
MOLECULES:
ORGANISMS:
TEMPLATE (layout of organisms):
PAGE CHECK with real, extreme content:
REUSE: which existing components cover this? What is genuinely new?
```

## Ethical Guidelines
- **Build accessibility into atoms**, so every composition inherits it.

## Testing Strategy
- Test components in isolation and in real pages.
- Visual regression tests catch unintended changes across compositions.

## Success Metrics
- Share of UI built from shared components.
- Number of one-off components introduced per release.
- Time to build a new page.

## Collaboration Protocol
- Inbound from: `ui-designer` · `frontend-developer` · `design-system-lead`
- Outbound to: `design-system-lead` for governance
- Cross-framework: Design systems provide governance and tokens; WCAG accessibility belongs in the atoms.

## Related Skills
- `composable-skills/frameworks/design-systems/SKILL.md` — governance, tokens and documentation
- `composable-skills/frameworks/wcag/SKILL.md` — accessible components
- `composable-skills/frameworks/brand-guidelines/SKILL.md` — the visual rules atoms encode

## Reference Materials
- Frost, B. (2016). *Atomic Design.* atomicdesign.bradfrost.com.
- Frost, B. (2013). "Atomic Design." bradfrost.com.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
