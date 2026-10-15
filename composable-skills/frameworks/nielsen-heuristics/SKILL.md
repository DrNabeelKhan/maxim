---
skill_id: nielsen-heuristics
name: Nielsen Heuristics
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - heuristic evaluation
  - nielsen heuristics
  - usability review
  - ten usability heuristics
  - ux audit
collaborates_with:
  - usability-tester
  - ux-researcher
  - ui-designer
  - product-strategist
ethics_required: false
priority: high
tags: [product-research, framework, usability, heuristic-evaluation, ux-audit]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Nielsen Heuristics

## Purpose
Use Jakob Nielsen's ten usability heuristics to evaluate an interface quickly against broad, well-established principles of usable design. In a heuristic evaluation, a few evaluators inspect the interface independently and record where it breaks a heuristic, then rate each problem's severity. It is fast and cheap and finds many issues before user testing, though it complements user research rather than replacing it.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `nielsen-heuristics` |
| Category | Product Research — Usability Inspection |
| Version | 2.0.0 |
| Originators | Jakob Nielsen and Rolf Molich (1990); refined by Nielsen (1994) |
| Primary reference | Nielsen Norman Group, "10 Usability Heuristics for User Interface Design" |

## The Ten Heuristics
1. **Visibility of system status.**
2. **Match between the system and the real world.**
3. **User control and freedom.**
4. **Consistency and standards.**
5. **Error prevention.**
6. **Recognition rather than recall.**
7. **Flexibility and efficiency of use.**
8. **Aesthetic and minimalist design.**
9. **Help users recognize, diagnose and recover from errors.**
10. **Help and documentation.**

**Severity ratings** commonly run from 0 (not a problem) to 4 (usability catastrophe), considering frequency, impact and persistence.

## Core Principles
- **Several independent evaluators find more.** A single evaluator misses many problems; three to five find a large share.
- **Evaluate independently, then combine,** so evaluators do not anchor on each other.
- **Rate severity** so fixes can be prioritised.
- **Heuristics are broad rules of thumb,** not specific guidelines.
- **Inspection does not replace testing with real users.**

## Applications & Use Cases
| Use Case | Application | Note |
|---|---|---|
| Early design review | Evaluate wireframes and prototypes | Cheap, before testing |
| UX audits | Assess a live product against the heuristics | Prioritise by severity |
| Competitive reviews | Compare usability of competitor products | Consistent criteria |
| Pre-test screening | Fix obvious issues before user testing | Better use of test time |
| Design critique | Shared language for feedback | Cite the heuristic |
| Training | Teach usability fundamentals | All ten |

## Usage Guidelines
- **Use three to five evaluators** where possible, working independently.
- **Walk through key tasks**, recording each problem with the heuristic it breaks and where it occurs.
- **Rate severity** for each problem.
- **Merge findings** and remove duplicates.
- **Confirm the most severe problems with user testing.**

## Prompt Template
```
You are running a heuristic evaluation (Nielsen & Molich 1990; Nielsen 1994).

INTERFACE AND KEY TASKS: [[...]]
FOR EACH PROBLEM
- Where it occurs:
- Heuristic broken (1-10):
- Severity (0-4) and why:
- Recommended fix:
SUMMARY: most severe problems first.
```

## Ethical Guidelines
- **Do not present expert opinion as user evidence.** Report heuristic findings as inspection results.

## Testing Strategy
- Validate the highest-severity findings with usability testing.
- Track whether fixes reduce related support requests or errors.

## Success Metrics
- Severe problems found and fixed per release.
- Reduction in task errors and support contacts after fixes.

## Collaboration Protocol
- Inbound from: `usability-tester` · `ux-researcher` · `product-strategist`
- Outbound to: `ui-designer` for fixes
- Cross-framework: SUS measures perceived usability after changes; WCAG covers accessibility, which the heuristics do not.

## Related Skills
- `composable-skills/frameworks/sus/SKILL.md` — measuring perceived usability
- `composable-skills/frameworks/wcag/SKILL.md` — accessibility requirements
- `composable-skills/frameworks/user-journey-mapping/SKILL.md` — the end-to-end experience

## Reference Materials
- Nielsen, J., & Molich, R. (1990). "Heuristic evaluation of user interfaces." *Proceedings of CHI '90*, 249–256.
- Nielsen, J. (1994). "Enhancing the explanatory power of usability heuristics." *Proceedings of CHI '94*.
- Nielsen Norman Group. "10 Usability Heuristics for User Interface Design." nngroup.com.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
