---
skill_id: dual-process-theory
name: Dual Process Theory (System 1 & System 2)
version: 1.0.0
category: behavior-science
type: framework
frameworks: []
triggers:
  - apply dual process theory
  - System 1 System 2 analysis
  - fast and slow thinking
  - intuitive vs deliberative
  - automatic vs controlled processing
collaborates_with:
  - behavioral-designer
  - conversion-optimizer
  - decision-architect
  - nudge-architect
  - ux-researcher
ethics_required: true
priority: high
tags: [behavior-science, framework, decision-making, cognitive-load]
adr: ADR-007
created: 2026-05-19
updated: 2026-10-15
---

# Dual Process Theory (System 1 & System 2)

## Purpose
Apply Dual Process Theory to design decisions that match the cognitive system the user is actually operating in. System 1 (fast · automatic · associative · low-effort) handles most routine judgments; System 2 (slow · deliberative · effortful) is engaged when a task demands it. (The popular "95% of decisions" figure is a marketing estimate, not a measurement.) Designing a System-2 interface for a System-1 task creates friction; designing a System-1 interface for a System-2 task creates errors. The mismatch is one of the most common UX failures.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `dual-process-theory` |
| Category | Behavior Science — Decision Making |
| Version | 1.0.0 |
| Originators | Daniel Kahneman (popularized) · William James (early roots) · Jonathan Evans · Keith Stanovich (formalized) |
| Maturity | Established — Nobel Prize 2002 (Kahneman); extensive empirical base |
| Primary references | Kahneman *Thinking, Fast and Slow* (2011) · Evans & Stanovich "Dual-Process Theories of Higher Cognition" (2013) |

## The Two Systems

| Attribute | System 1 | System 2 |
|---|---|---|
| Speed | Fast | Slow (seconds to minutes) |
| Effort | Automatic, low-effort | Effortful, requires attention |
| Control | Implicit, hard to override | Conscious, can be directed |
| Capacity | Massive parallel | Sequential, limited |
| Energy cost | Cheap | Effortful (attention- and working-memory-limited) |
| Decision style | Associative, intuitive | Logical, rule-based |
| Typical error mode | Biases from heuristics (but can also be correct) | Overload, errors of omission (and can also rationalise) |
| When dominant | Familiar context · time pressure · low stakes · routine | Novel context · explicit reasoning required · high stakes |

System 1 isn't "wrong" — it's the working horse. Kahneman (2011) attributes many catalogued biases (anchoring · availability · framing · representativeness) to System 1. Evans & Stanovich (2013) caution against the "Type 1 = bad, Type 2 = good" reading: both kinds of processing can produce biased or correct responses. System 2 is useful for verification, but it is effortful to deploy.

## Prompt Template
```
You are applying Dual Process Theory (System 1 / System 2).

CONTEXT:
- User decision under design: [[decision]]
- Decision frequency: high (multiple times per day) | medium | low (one-time)
- Decision stakes: low (reversible) | medium | high (irreversible · financial · health)
- User state: focused | distracted | time-pressured | cognitively loaded

SYSTEM DIAGNOSIS:
1. Which system is the user PROBABLY operating in for this decision?
   - High frequency + low stakes → System 1 dominant
   - Low frequency + high stakes → System 2 dominant (or should be)
2. Which system does the current interface ASSUME?
3. Diagnose mismatch (if any)

DESIGN PRESCRIPTIONS:
- For System-1 tasks: minimize cognitive load · use defaults · clear visual hierarchy · familiar patterns · pre-attentive design
- For System-2 tasks: provide reasoning surface · compare-and-contrast layouts · slow the user down on irreversible actions · confirmation steps for high stakes
- For mixed: System-1 path as default, System-2 escape hatch ("Show me details" / "Are you sure?")

ANTI-PATTERN CHECK:
- Is the design exploiting System 1 to bypass System 2 on high-stakes decisions? (dark pattern flag)
- Is the design forcing System 2 on routine tasks? (friction flag)

OUTPUT:
- System diagnosis (1 / 2 / mixed) + confidence
- Mismatch analysis
- Design recommendations
- Ethical-flag if exploiting System 1 on high-stakes decisions
```

## Core Principles
- **Match the system the user is operating in.** Designing for the wrong system is the most common UX failure.
- **Default to System 1 for routine tasks; escalate to System 2 for stakes.** Most product flows benefit from System-1-default + System-2-escape.
- **System 2 is lazy.** People default to System 1 even on high-stakes decisions unless deliberately engaged. Design must actively engage System 2 when it's needed.
- **System 2 capacity is limited.** Deliberate processing competes for attention and working memory, so heavy concurrent load degrades it. (Claims that decisions "deplete" a resource — ego depletion, decision fatigue — have weak support in large preregistered replications: Hagger et al. 2016; Vohs et al. 2021.)
- **Pre-attentive attributes work in System 1.** Color · motion · size · position · contrast — these are read in System 1 in milliseconds. Use them to surface the right information before System 2 has to engage.

## Applications & Use Cases
| Use Case | Application | Expected Outcome |
|---|---|---|
| Checkout flow | System-1 path with clear defaults; System-2 escape for variants | Higher conversion + fewer regret-driven refunds |
| Settings pages | System-2 friendly (compare-and-contrast layout) | Better config decisions |
| Onboarding | System-1 minimal load early; System-2 detail later | Higher activation |
| High-stakes financial / health flows | Force System 2 (confirmation · cooling-off · reasoning surface) | Fewer high-regret outcomes |
| Notifications | System-1 friendly (pre-attentive cues for urgency hierarchy) | Better signal-to-noise |
| Forms | Sequence System-2 fields; cluster System-1 fields | Lower abandonment |

## Reference Materials
- Kahneman, D. (2011). *Thinking, Fast and Slow.* Farrar, Straus and Giroux.
- Evans, J. & Stanovich, K. (2013). "Dual-Process Theories of Higher Cognition: Advancing the Debate." *Perspectives on Psychological Science* 8(3): 223–241.
- Stanovich, K. (2011). *Rationality and the Reflective Mind.* Oxford University Press.
- The Nobel Prize 2002 — https://www.nobelprize.org/prizes/economic-sciences/2002/kahneman/facts/
- Hagger, M.S., et al. (2016). "A Multilab Preregistered Replication of the Ego-Depletion Effect." *Perspectives on Psychological Science* 11(4): 546–573.
- Vohs, K.D., et al. (2021). "A Multisite Preregistered Paradigmatic Test of the Ego-Depletion Effect." *Psychological Science* 32(10): 1566–1581.

## Usage Guidelines
- Diagnose user state BEFORE designing interventions. A System-1 design that works for focused users will fail for distracted/time-pressured users.
- Reduce competing load around important decisions (interruptions, parallel tasks), rather than relying on contested decision-fatigue effects for placement.
- Use pre-attentive attributes (color · motion · size · contrast) to communicate priority WITHOUT requiring System 2 to read text.
- Cooling-off periods + confirmation steps engage System 2 for irreversible decisions.

## Collaboration Protocol
- Inbound from: `behavioral-designer` · `decision-architect` · `nudge-architect` · `ux-researcher`
- Outbound to: same agents + `conversion-optimizer` for funnel diagnosis
- Cross-framework: pairs with COM-B (Capability + Opportunity by system), Cognitive Biases (System 1 outputs), Prospect Theory (loss aversion is System 1)

## Ethical Guidelines
- **Bright line:** exploiting System 1 to bypass System 2 on high-stakes decisions is a dark pattern. Examples: hiding cancellation pathways · pre-checked subscription opt-ins · urgency-anxiety triggers without genuine time constraint.
- System-1-friendly design is NOT inherently manipulative — it's good UX for routine decisions. The ethical question is: would the user still make this decision if System 2 were engaged?
- For irreversible / high-cost decisions: design must actively engage System 2 even at the cost of conversion.

## Success Metrics
- Decision regret rate (post-decision surveys at 7/30/90 days)
- Error rate on irreversible decisions (refunds · cancellations · disputes)
- Task completion time vs error rate by user-state segment

## Related Skills
- `composable-skills/frameworks/fogg-behavior-model/SKILL.md` — Motivation × Ability × Prompt overlays both systems
- `composable-skills/frameworks/prospect-theory/SKILL.md` — loss aversion is a System 1 phenomenon
- `composable-skills/frameworks/com-b-model/SKILL.md` — Capability + Opportunity differ by system
- `composable-skills/frameworks/cognitive-biases/SKILL.md` — biases attributed to fast processing

## Testing Strategy
- A/B test System-1 vs System-2 calibrated designs for the same task
- Measure: completion rate · error rate · regret (post-decision survey) · time-to-decision
- Expected pattern: System-1 design wins on completion; if regret rates diverge, the task needed System 2

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Shipped in WS6a of v1.2.0 sprint (2026-05-19). One of 4 HIGH-priority behavioral frameworks per FRAMEWORK_ROADMAP § v1.2.E._
