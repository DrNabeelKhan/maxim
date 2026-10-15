---
skill_id: pci-dss
name: PCI-DSS
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - pci dss
  - pci compliance
  - cardholder data
  - payment card security
  - reduce pci scope
collaborates_with:
  - security-auditor
  - compliance-officer
  - security-architect
  - backend-architect
ethics_required: true
priority: high
tags: [security, framework, pci, payments, cardholder-data, compliance]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# PCI-DSS

## Purpose
Use the Payment Card Industry Data Security Standard (PCI DSS) to protect payment card account data. It applies to every entity that stores, processes or transmits cardholder data or sensitive authentication data, or that can affect the security of that environment. It is a contractual requirement enforced by the card brands and acquiring banks, not a law. The most effective first step is usually to **reduce scope**: keep card data out of your systems wherever possible.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `pci-dss` |
| Category | Security — Industry Standard |
| Version | 2.0.0 |
| Owner | PCI Security Standards Council (founded 2006 by major card brands) |
| Current version | PCI DSS v4.0.1 (2024); requirements introduced as future-dated in v4.0 became mandatory on 31 March 2025 |
| Validation | Self-Assessment Questionnaire (SAQ) or a Report on Compliance (ROC) by a Qualified Security Assessor (QSA), depending on entity type and volume |

## The Twelve Requirements
**Build and maintain a secure network and systems**
1. Install and maintain network security controls.
2. Apply secure configurations to all system components.

**Protect account data**
3. Protect stored account data.
4. Protect cardholder data with strong cryptography during transmission over open, public networks.

**Maintain a vulnerability management program**
5. Protect all systems and networks from malicious software.
6. Develop and maintain secure systems and software.

**Implement strong access control measures**
7. Restrict access by business need to know.
8. Identify users and authenticate access.
9. Restrict physical access to cardholder data.

**Regularly monitor and test networks**
10. Log and monitor all access to system components and cardholder data.
11. Test the security of systems and networks regularly.

**Maintain an information security policy**
12. Support information security with organisational policies and programs.

## Core Principles
- **Minimise scope.** Hosted payment pages, tokenisation and outsourcing can shrink the cardholder data environment.
- **Never store sensitive authentication data after authorisation,** such as full track data or card verification codes.
- **Segment the cardholder data environment** from other networks.
- **Compliance is continuous,** not an annual event.
- **Choose defined or customised approaches**: v4.0 lets mature organisations meet objectives with their own controls, with more validation.

## Applications & Use Cases
| Use Case | Application | Requirement |
|---|---|---|
| E-commerce checkout | Use a provider's hosted fields or payment page to reduce scope | Scoping |
| Storing cards for repeat billing | Use the processor's tokens instead of card numbers | Req. 3 |
| Network design | Segment and restrict traffic to the CDE | Req. 1 |
| Payment page scripts | Inventory and authorise scripts on payment pages | Req. 6 |
| Access control | MFA for access into the CDE | Req. 8 |
| Annual validation | Determine SAQ type or ROC requirement | Validation |

## Usage Guidelines
- **Map where card data flows** and define the cardholder data environment.
- **Reduce scope first**, using tokenisation, hosted payment pages and segmentation.
- **Determine your validation path** with your acquirer.
- **Implement the requirements that apply** to the remaining scope and collect evidence continuously.
- **Check your payment provider's compliance documentation** and the responsibilities it leaves to you.

## Prompt Template
```
You are assessing PCI DSS v4.0.1 scope and compliance.

PAYMENT FLOWS: channels, providers, where card data touches your systems: [[...]]
SCOPE: cardholder data environment and connected systems
SCOPE REDUCTION options: tokenisation · hosted payment page · segmentation
VALIDATION PATH: SAQ type or ROC
FOR EACH APPLICABLE REQUIREMENT 1-12: status · evidence · gap
SHARED RESPONSIBILITY with providers:
```

## Ethical Guidelines
- **Never collect card verification codes or full track data** beyond authorisation.
- **Do not misstate compliance** on SAQs or to customers.

## Testing Strategy
- Internal and external vulnerability scans and penetration tests as the standard requires.
- Segmentation testing to confirm scope.

## Success Metrics
- Size of the cardholder data environment.
- Assessment findings and time to remediate.
- Scan and test results within required intervals.

## Collaboration Protocol
- Inbound from: `backend-architect` · `security-architect`
- Outbound to: `security-auditor` · `compliance-officer`
- Cross-framework: OWASP Top 10 for payment application security; ISO 27001 and SOC 2 for wider assurance; zero trust for segmentation.

## Related Skills
- `composable-skills/frameworks/owasp-top-10/SKILL.md` — secure payment applications
- `composable-skills/frameworks/iso-27001/SKILL.md` — information security management
- `composable-skills/frameworks/zero-trust-architecture/SKILL.md` — segmentation and access

## Reference Materials
- PCI Security Standards Council. (2024). *Payment Card Industry Data Security Standard, v4.0.1.*
- PCI Security Standards Council. *Information Supplement: Guidance for PCI DSS Scoping and Network Segmentation.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
