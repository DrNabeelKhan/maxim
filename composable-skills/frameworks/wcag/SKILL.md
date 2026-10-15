---
skill_id: wcag
name: WCAG
version: 2.0.0
category: design-ux
type: framework
frameworks: []
triggers:
  - wcag
  - accessibility audit
  - web content accessibility guidelines
  - colour contrast check
  - accessible design
collaborates_with:
  - ui-designer
  - frontend-developer
  - ux-researcher
  - compliance-officer
ethics_required: true
priority: high
tags: [design-ux, framework, accessibility, compliance, inclusive-design]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# WCAG

## Purpose
Use the Web Content Accessibility Guidelines to make web content usable by people with disabilities, including those who are blind or have low vision, are deaf or hard of hearing, or have motor, cognitive or speech disabilities. WCAG is a W3C standard, and it is referenced by accessibility law in many jurisdictions, so it is both a design standard and, frequently, a legal obligation. The current version is **WCAG 2.2**, a W3C Recommendation since 5 October 2023.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `wcag` |
| Category | Design and UX — Accessibility |
| Version | 2.0.0 (this definition) · WCAG 2.2 (the standard) |
| Owner | W3C Web Accessibility Initiative |
| Current version | WCAG 2.2, Recommendation, 5 October 2023 (previous: 2.1, 2018) |
| Conformance levels | A · AA · AAA. AA is the usual legal and contractual target |
| Next generation | WCAG 3.0 is a working draft, not yet a standard |

## Structure
**Four principles (POUR)**
- **Perceivable**: information can be perceived, for example text alternatives, captions and sufficient contrast.
- **Operable**: everything works by keyboard, users have enough time, and nothing causes seizures.
- **Understandable**: content and operation are predictable and readable, with help avoiding errors.
- **Robust**: content works with assistive technologies.

Each principle has guidelines, and each guideline has testable **success criteria** at levels A, AA or AAA.

### Thresholds worth knowing (WCAG 2.2)
- **Contrast**: at least 4.5:1 for normal text and 3:1 for large text at AA; 7:1 for normal text at AAA.
- **Non-text contrast**: 3:1 for UI components and meaningful graphics.
- **Target size (minimum)**: 24 by 24 CSS pixels at AA, new in 2.2, with exceptions.
- WCAG 2.2 added nine success criteria and removed 4.1.1 Parsing.

## Core Principles
- **Accessibility is designed in, not bolted on.**
- **Automated tools catch only a portion of failures.** Manual and assistive-technology testing are essential.
- **Keyboard access is fundamental.** If it cannot be done by keyboard, many users cannot do it.
- **Semantic HTML first;** ARIA only where native elements cannot do the job.
- **Test with disabled people** where possible; conformance and usability are not the same.

## Applications & Use Cases
| Use Case | Application | Principle |
|---|---|---|
| Design systems | Accessible components and contrast-safe tokens | All |
| Forms | Labels, error identification and suggestions | Understandable |
| Media | Captions, transcripts and audio description | Perceivable |
| Navigation | Keyboard operation and visible focus | Operable |
| Procurement and contracts | Require WCAG 2.2 AA conformance | Compliance |
| Legal risk reviews | Audit against the standard the law references | Compliance |

## Usage Guidelines
- **Target WCAG 2.2 AA** unless a law or contract specifies otherwise, and check which version applies.
- **Combine automated scanning, manual review and assistive-technology testing.**
- **Test every flow by keyboard alone.**
- **Check contrast for text, components and focus indicators.**
- **Document conformance**, for example in an accessibility statement, and track remediation.

## Prompt Template
```
You are auditing against WCAG 2.2 (W3C, 2023). Target level: [[AA]]

SCOPE: [[pages and flows]]
PERCEIVABLE: alt text · captions · contrast (4.5:1 / 3:1) · non-text contrast (3:1)
OPERABLE: keyboard · focus visible · timing · target size (24x24 CSS px)
UNDERSTANDABLE: labels · errors identified with suggestions · predictable behavior
ROBUST: semantics · name, role, value for assistive tech
FOR EACH FAILURE: success criterion · level · location · fix
METHOD: automated + manual + assistive technology (state which were used)
```

## Ethical Guidelines
- **Accessibility is a matter of equal access**, not a feature to trade off.
- **Do not claim conformance you have not verified.** Overlay products that promise automatic compliance do not make a site conformant.

## Testing Strategy
- Automated checks in continuous integration, plus manual audits and screen-reader testing on key flows.
- Include disabled users in usability testing.

## Success Metrics
- WCAG success criteria failures by level, trending to zero at the target level.
- Key flows fully completable by keyboard and screen reader.
- Accessibility defects found before release versus after.

## Collaboration Protocol
- Inbound from: `ui-designer` · `frontend-developer` · `ux-researcher`
- Outbound to: `compliance-officer` for legal obligations
- Cross-framework: Design systems encode accessibility once; Nielsen heuristics cover general usability; Core Web Vitals overlap on performance.

## Related Skills
- `composable-skills/frameworks/design-systems/SKILL.md` — accessible components
- `composable-skills/frameworks/atomic-design/SKILL.md` — accessibility at the atom level
- `composable-skills/frameworks/nielsen-heuristics/SKILL.md` — general usability

## Reference Materials
- W3C. (2023). *Web Content Accessibility Guidelines (WCAG) 2.2.* W3C Recommendation, 5 October 2023.
- W3C. *Understanding WCAG 2.2* and *How to Meet WCAG (Quick Reference).*
- W3C. *What's New in WCAG 2.2.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
