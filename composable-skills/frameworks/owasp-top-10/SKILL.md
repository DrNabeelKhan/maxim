---
skill_id: owasp-top-10
name: OWASP Top 10
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - owasp top 10
  - web application security
  - broken access control
  - injection vulnerability
  - secure code review
collaborates_with:
  - penetration-tester
  - security-auditor
  - ethical-hacker
  - security-architect
  - backend-architect
ethics_required: true
priority: high
tags: [security, framework, owasp, appsec, web, vulnerabilities]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# OWASP Top 10

## Purpose
Use the OWASP Top 10 as an awareness baseline for the most critical security risks to web applications. Published by the Open Worldwide Application Security Project (OWASP), it ranks categories of risk using vulnerability data contributed by organisations and a community survey. It is a starting point, not a complete standard: OWASP itself recommends the Application Security Verification Standard (ASVS) when you need testable requirements.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `owasp-top-10` |
| Category | Security — Application Security |
| Version | 2.0.0 |
| Owner | OWASP Foundation |
| Current edition | OWASP Top 10:2025 (succeeds the 2021 edition) |
| Related OWASP projects | ASVS (verification requirements) · API Security Top 10 · Top 10 for LLM Applications · Cheat Sheet Series |

## The 2025 Categories
- **A01 Broken Access Control.**
- **A02 Security Misconfiguration.**
- **A03 Software Supply Chain Failures.**
- **A04 Cryptographic Failures.**
- **A05 Injection** (including cross-site scripting).
- **A06 Insecure Design.**
- **A07 Authentication Failures.**
- **A08 Software or Data Integrity Failures.**
- **A09 Security Logging and Alerting Failures.**
- **A10 Mishandling of Exceptional Conditions.**

Category numbers changed between editions; for example, Injection was A03 in 2021, and Server-Side Request Forgery, a separate 2021 category, now falls under Broken Access Control. Always cite the edition with the number, such as "A05:2025".

## Core Principles
- **An awareness document, not a checklist.** Being free of the Top 10 does not make an application secure.
- **Prefer secure defaults and frameworks** that prevent whole classes of flaws, such as parameterised queries and output encoding.
- **Enforce access control on the server**, deny by default, for every request.
- **Design matters.** Insecure design cannot be fixed by perfect implementation; threat-model early.
- **Know your components.** Track dependencies and patch known vulnerabilities.

## Applications & Use Cases
| Use Case | Application | Category |
|---|---|---|
| Developer training | Teach each category with examples from your stack | All |
| Code review | Review checklists derived from the categories | A01, A05 |
| Threat modelling | Identify design-level risks before building | A06 |
| Dependency and supply chain | Software composition analysis, SBOMs and patching | A03 |
| Penetration test scoping | Make sure tests cover each category | All |
| Logging design | Log security events and alert on them | A09 |

## Usage Guidelines
- **Train developers on the categories** using examples in your own languages and frameworks.
- **Use the ASVS for testable requirements** and the Top 10 for awareness.
- **Automate what can be automated**, such as dependency scanning and static analysis, and test access control manually.
- **Threat-model new features** to catch insecure design.
- **Check the current edition** before citing category numbers.

## Prompt Template
```
You are reviewing an application against the OWASP Top 10:2025.

APPLICATION and stack: [[...]]
FOR EACH CATEGORY A01-A10:
  exposure in this application · existing controls · gaps · test method
TOP RISKS by likelihood and impact:
REMEDIATION order:
```

## Ethical Guidelines
- **Test only systems you are authorised to test.**
- **Report vulnerabilities responsibly** and protect users until fixes are deployed.

## Testing Strategy
- Static and dynamic analysis in the pipeline.
- Manual testing for access control and business logic.
- Penetration tests by qualified testers.

## Success Metrics
- Vulnerabilities by category found in testing versus production.
- Mean time to remediate by severity.

## Collaboration Protocol
- Inbound from: `backend-architect` · `security-architect`
- Outbound to: `penetration-tester` · `ethical-hacker` · `security-auditor`
- Cross-framework: DevSecOps for automation; API design for API-specific risks; NIST CSF for program context.

## Related Skills
- `composable-skills/frameworks/devsecops/SKILL.md` — automating security checks
- `composable-skills/frameworks/api-design/SKILL.md` — API security
- `composable-skills/frameworks/mitre-attck/SKILL.md` — attacker techniques

## Reference Materials
- OWASP Foundation. (2025). *OWASP Top 10:2025.* top10.owasp.org/2025.
- OWASP Foundation. (2021). *OWASP Top 10:2021.* top10.owasp.org/2021.
- OWASP Foundation. *Application Security Verification Standard (ASVS).*
- OWASP Foundation. *OWASP Cheat Sheet Series.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
