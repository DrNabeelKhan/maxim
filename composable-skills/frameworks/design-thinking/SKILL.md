---
skill_id: design-thinking
name: Design Thinking
version: 2.0.0
category: product-research
type: framework
frameworks: []
triggers:
  - design thinking
  - empathize define ideate prototype test
  - human-centered design
  - double diamond
  - design sprint discovery
collaborates_with:
  - innovation-researcher
  - user-researcher
  - ux-researcher
  - product-strategist
  - ui-designer
ethics_required: true
priority: high
tags: [product-research, framework, human-centered-design, innovation, discovery]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Design Thinking

## Purpose
Use design thinking to solve problems that are poorly defined, by starting from the needs of the people affected rather than from an assumed solution. It alternates between widening the field, to understand the problem and generate options, and narrowing it, to define the problem and choose what to build, and it tests ideas with cheap prototypes before committing. Its value is greatest early, when the risk is solving the wrong problem well.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `design-thinking` |
| Category | Product Research — Human-Centred Design |
| Version | 2.0.0 |
| Common models | Stanford d.school five modes · Design Council Double Diamond (developed 2003, shared from 2004) |
| Key references | Brown, "Design Thinking", *HBR* (2008) · Brown, *Change by Design* (2009) · Simon, *The Sciences of the Artificial* (1969) |

## Two Common Models
**Stanford d.school, five modes**
1. **Empathize**: understand people through observation and interviews.
2. **Define**: frame the specific problem worth solving.
3. **Ideate**: generate many possible solutions.
4. **Prototype**: make quick, cheap versions of the most promising ideas.
5. **Test**: learn from people using the prototypes, and loop back.

**Design Council, Double Diamond**
Discover and Define (diverge, then converge on the problem), then Develop and Deliver (diverge, then converge on the solution).

## Core Principles
- **Start with people, not the solution.** Direct contact with users is the core input.
- **Diverge before converging.** Generate options before choosing among them, for the problem as well as the solution.
- **Frame the problem deliberately.** A well-framed problem statement does much of the work.
- **Prototype to learn, not to impress.** The lowest-fidelity prototype that answers the question is the right one.
- **It is iterative.** Testing routinely sends a team back to redefine the problem.

## Applications & Use Cases
| Use Case | Application | Phase |
|---|---|---|
| New product discovery | Field research before defining features | Empathize, Define |
| Reframing a stuck problem | Write several alternative problem statements | Define |
| Service redesign | Map the experience and prototype changes with users | All |
| Innovation workshops | Structured ideation with clear selection criteria | Ideate |
| Concept validation | Paper or click-through prototypes tested with users | Prototype, Test |
| Cross-functional alignment | Shared understanding of user needs | Empathize |

## Usage Guidelines
- **Talk to real users early**, and record what they do, not only what they say.
- **Write the problem as a point-of-view statement**: user, need, and the insight behind it.
- **Separate idea generation from judgment** so options are not killed too early.
- **Prototype at the lowest fidelity that answers the current question.**
- **Plan for iteration**; expect testing to change the problem definition.

## Prompt Template
```
You are applying design thinking (d.school five modes / Double Diamond).

PEOPLE AFFECTED: [[who]]
EMPATHIZE: what was observed and heard?
DEFINE — point of view: [[user]] needs [[need]] because [[insight]]
IDEATE: at least ten options before choosing
PROTOTYPE: the cheapest artefact that tests the riskiest assumption
TEST: what will you watch for, and what would send you back to Define?
```

## Ethical Guidelines
- **Obtain informed consent** for research and protect participants' data.
- **Include the people most affected**, including those who are hardest to reach.
- **Do not present a workshop as research**; ideas from the team are not evidence about users.

## Testing Strategy
- Test prototypes with representative users, not colleagues.
- Track which assumptions each test confirmed or refuted.

## Success Metrics
- Number of user contacts in discovery.
- Assumptions tested before build.
- Outcomes of the shipped solution against the defined need.

## Collaboration Protocol
- Inbound from: `innovation-researcher` · `ux-researcher` · `product-strategist`
- Outbound to: `ui-designer` for prototypes; `user-researcher` for testing
- Cross-framework: Jobs-to-be-Done for framing needs; Lean Startup for validating solutions; user journey mapping for the experience.

## Related Skills
- `composable-skills/frameworks/jobs-to-be-done/SKILL.md` — framing the need
- `composable-skills/frameworks/lean-startup/SKILL.md` — validating with experiments
- `composable-skills/frameworks/user-journey-mapping/SKILL.md` — mapping the experience

## Reference Materials
- Brown, T. (2008). "Design Thinking." *Harvard Business Review*, June 2008.
- Brown, T. (2009). *Change by Design.* Harper Business.
- Design Council. "History of the Double Diamond." designcouncil.org.uk (model developed 2003, shared publicly from 2004).
- Simon, H.A. (1969). *The Sciences of the Artificial.* MIT Press.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
