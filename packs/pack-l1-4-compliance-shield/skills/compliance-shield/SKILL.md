---
name: L1.4 Compliance Shield
description: "14 regulated-industry frameworks enforced on every output. Audit-ready on demand."
business_outcome: "Framework-coverage rate 100% for in-scope jurisdictions; mechanism tracked in documents/ledgers/MOAT_TRACKER.md § MOAT-04."
primary_framework: "COM-B (Michie et al., 2011)"
product_id: L1.4
lemonsqueezy_variant_id: 1551370
pack_tier: L1
ships_with: v1.0.0
license: proprietary
---

# L1.4 Compliance Shield

## The Maxim Moat

Compliance is not a department. Compliance is a behavior the whole team performs or the whole team fails. L1.4 Compliance Shield is the pack that makes that behavior structural rather than aspirational across fourteen regulated-industry frameworks.

Most compliance tools produce evidence after the fact. Teams write policy, ship work, then scramble to construct an audit trail when the regulator asks. Organizations do not fail audits because the policy is wrong. They fail because the behavior required by the policy was never enforced at the moment work was produced.

The replication barrier is the real-time enforcement surface. Every Maxim output is scanned against the fourteen frameworks declared applicable to the operator's jurisdiction and industry. The CSO auto-loop fires automatically on any task containing security, PII, or regulated-industry signals; the loop cannot be bypassed. The `mxm-compliance` MCP gives live verdicts on check_compliance, audit_data_handling, generate_ropa_entry, get_frameworks, and get_jurisdiction_requirements. Competitors can publish a policy PDF. They cannot replicate a generation-time enforcement hook that fires on every output, writes a per-decision audit record, and produces a jurisdiction-aware ROPA export on demand.

## Business Outcome

L1.4 Compliance Shield applies COM-B (Susan Michie, Lou Atkins, and Robert West, 2011) as the substrate for the entire pack. Compliance is a behavior change problem at team and organizational scale. Capability × Opportunity × Motivation must hold together for compliance to emerge from daily work rather than bolt on at audit time. Outcome claims accumulate in the living ledger at `documents/ledgers/MOAT_TRACKER.md` § MOAT-04.

Primary metric: framework-coverage rate. The percentage of applicable frameworks (determined by the operator's jurisdiction plus industry) where Maxim outputs have been checked within the last 7 days. Target post-v1.0.0: 100% for in-scope frameworks. Secondary metrics: time-to-audit-ready in minutes from auditor request to ROPA export delivery (target under 10 minutes); compliance-drift false-alarm rate (<5% per 30-day window); cross-jurisdiction coverage depth (operator in-scope framework count vs applicable framework count).

## Primary Behavioral Framework

**Framework:** COM-B (Capability, Opportunity, Motivation → Behavior).

**Mechanism:** behavior emerges only when all three prerequisites hold together. Capability is the knowledge and skill to perform the behavior (do team members know GDPR Article 5?). Opportunity is the environment that permits it (does infrastructure make PII handling traceable?). Motivation is the reflective and automatic incentive to perform it (is compliance rewarded, or penalized as friction?). Collapse any one of the three, and compliance behavior does not occur regardless of the other two.

**Source:** Susan Michie, Maartje M. van Stralen, and Robert West, "The Behaviour Change Wheel" in *Implementation Science* (2011), systematizing decades of behavioral-medicine intervention research.

**Application:** Compliance Shield supplies all three COM-B factors as infrastructure. Capability comes from the fourteen-framework knowledge base exposed through the compliance MCP, plus the `mxm-cso` command surface for regulatory research. Opportunity comes from pre-commit hooks that block PII/secret leaks and from the audit-trail ledger that makes every data-handling decision traceable. Motivation comes from the CSO auto-loop that surfaces compliance obligations before work ships, converting compliance from a blocker into a routed task. Capability without Opportunity is pretense. Opportunity without Motivation is waste. Motivation without Capability is theater.

**Critique:** COM-B is a framework for intervention design, not a predictive model. Critics (Cane et al., 2012) note the three categories overlap in practice; capability and opportunity interact, motivation has reflective and automatic subtypes that are often measured separately. Maxim treats COM-B as a diagnostic checklist for compliance rollout, not as a closed-form predictor of team behavior.

## Behavioral → Compliance Translation

The five frameworks below address compliance at five different scales: individual capability, team motivation, organizational adoption, population-level convergence, and cross-organizational isomorphism. COM-B names the individual-and-team mechanism. The others define how compliance lands across the wider system.

| Framework | Mechanism | Maxim positive | Maxim anti-pattern | Boundary |
|---|---|---|---|---|
| COM-B (Michie et al., 2011) | Capability × Opportunity × Motivation | compliance MCP supplies all three factors | training (Capability) with no tooling (Opportunity) | categories overlap in practice (Cane et al., 2012) |
| Prospect Theory (Kahneman & Tversky, 1979) | loss aversion, reference point | "avoid EU AI Act Article 83 fine up to €35M" framing | fear-only framing on low-risk internal process | reference-point shifts (Kőszegi & Rabin, 2006) |
| Diffusion of Innovations (Everett Rogers, 1962) | five adopter categories | regulated-industry overlay reaches laggards last | forcing laggards to early-adopter pace | curve validity contested in organizational contexts |
| Theory of Planned Behavior (Icek Ajzen, 1991) | attitude + subjective norms + perceived control | making compliance the perceived team norm | compliance stated but norm is "ship fast regardless" | intention-behavior gap (Sheeran, 2002) |
| Institutional Isomorphism (Paul DiMaggio & Walter Powell, 1983) | coercive, mimetic, normative pressures | peer-firm audit-ready defaults reduce friction | mimicking surface compliance without mechanism | three pressures interact, not independent |

Where others see compliance overhead, I see infrastructure that earns the right to operate. Concrete invocations follow.

**1. Live framework check via the compliance MCP:**

```json
{
  "tool": "mcp__mxm-compliance__check_compliance",
  "args": {
    "framework": "GDPR",
    "article": "5",
    "scope": "user data in .mxm-operator-profile/",
    "jurisdiction": "EU"
  }
}
// Returns: { "compliant": true,
//            "principles_covered": ["lawfulness", "purpose_limitation",
//                                   "data_minimisation", "accuracy",
//                                   "storage_limitation", "integrity"],
//            "gaps": [],
//            "next_review_due": "2026-07-20" }
```

**2. Record of Processing Activity (ROPA) export for EU auditor:**

```json
{
  "tool": "mcp__mxm-compliance__generate_ropa_entry",
  "args": {
    "controller": "iSystematic AG",
    "activity": "operator-profile storage",
    "legal_basis": "legitimate interest (GDPR Art. 6(1)(f))",
    "data_categories": ["preferences", "session history"],
    "retention_days": 365,
    "recipients": [],
    "transfers_outside_eea": false
  }
}
// Returns: ROPA table row in CSV + markdown + JSON formats.
```

**3. Jurisdiction-aware regulatory scope via `/mxm-cso`:**

```
$ /mxm-cso scope --jurisdiction EU --industry healthtech
  Applicable frameworks (7):
    GDPR              (EU)         — data protection, active
    EU AI Act         (EU)         — AI transparency, active 2026-02
    ISO 13485         (global)     — medical device QMS, applicable
    ISO 14971         (global)     — medical device risk, applicable
    SOC 2             (global)     — security controls, active
    ISO 27001         (global)     — InfoSec management, applicable
    WCAG 2.1 AA       (EU + US)    — accessibility, active
  Not applicable: HIPAA (US-only), PIPEDA (CA-only), FINTRAC, UAE-PDPL, CASL, PCI-DSS (no card data), NIST CSF (US-only).
  Coverage status: 7 of 7 in-scope frameworks scanned within last 7 days.
```

## Anti-Patterns

Five failures catalogued from compliance rollouts across regulated-industry Maxim deployments, documented so the enforcement surface is not silently eroded.

**1. Framework as logo.** Compliance framework names appear on landing pages and proposals; no enforcement fires at generation time. Passes the first buyer, fails the first audit.

**2. Point-in-time audit.** Compliance checked once at year-end, never between. COM-B Opportunity collapses between audits; work ships for eleven months with no regulatory scan, then scrambles for two weeks of retrofit.

**3. Single-framework tunnel vision.** GDPR treated as the whole compliance posture. Thirteen other applicable frameworks go unchecked. The operator learns about ISO 27001 obligations from a prospect's RFP rather than from their own tooling.

**4. Privacy-as-afterthought.** Data-protection impact assessment (DPIA) run after launch. COM-B Capability exists (the team can read GDPR); Opportunity exists (the tooling supports DPIA); Motivation fails (launch pressure beats privacy discipline). Behavior does not emerge.

**5. Cross-jurisdiction blind spot.** Operator based in the US building a product sold to EU users. Applicable framework set never updated. GDPR obligations apply; the tooling is scoped to US frameworks only. Institutional Isomorphism fires only from peer-firm pressure, months after the regulatory pressure that should have fired first.

## Pack Integrations

Three sibling packs deepen Compliance Shield in specific ways. Pack L1.1 through L1.6 are the live ecosystem; no future packs referenced.

- **L1.1 AI Governance:** provides the baseline AI transparency layer (audit trail, confidence tag, ethics check). Compliance Shield extends that baseline from EU AI Act Articles 13 and 14 to the full fourteen-framework regulated-industry set.
- **L1.3 Proactive Watch:** the `compliance-drift` class (drift class 8) catches framework-coverage regressions continuously. When a new skill ships without the compliance scan, the class fails the commit. Coverage stays enforced without quarterly audit scrambles.
- **L1.6 Behavioral Intelligence:** frames compliance adoption itself as behavior change. COM-B diagnoses which factor is missing; Prospect Theory frames the loss-aversion motivator; Diffusion of Innovations times the rollout across early adopters and laggards.

Compliance is not a policy document. Compliance is a behavior the whole team performs, every day, on every output, because the infrastructure makes the other option harder than the compliant one.

*Team-tier operators get L1.4 Compliance Shield inside Growth Stack, Professional OS, or Agency All-In at 47% off individual L1 pricing; the [pack catalog](../../../maxim/documents/business/sales-marketing/packs-catalog/mxm-pack-catalog-v1.0.0.md) has the full matrix.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
