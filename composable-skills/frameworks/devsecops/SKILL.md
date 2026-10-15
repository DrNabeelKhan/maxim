---
skill_id: devsecops
name: DevSecOps
version: 2.0.0
category: engineering-devops
type: framework
frameworks: []
triggers:
  - devsecops
  - shift left security
  - secure software supply chain
  - sbom
  - security in the pipeline
collaborates_with:
  - devops-automator
  - security-architect
  - security-auditor
  - infrastructure-maintainer
ethics_required: true
priority: high
tags: [engineering, framework, security, supply-chain, sbom, ssdf]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# DevSecOps

## Purpose
Use DevSecOps to build security into every stage of software delivery, rather than checking for it at the end. Security work moves earlier ("shift left"), is automated in the pipeline, and is shared by development, security and operations. It also extends to the software supply chain: the dependencies, build systems and artifacts a product is assembled from, which attackers increasingly target.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `devsecops` |
| Category | Engineering — Secure Delivery |
| Version | 2.0.0 |
| Secure development framework | NIST SP 800-218, *Secure Software Development Framework (SSDF)* v1.1 (2022) |
| Maturity model | OWASP Software Assurance Maturity Model (SAMM) |
| Supply chain | SLSA (Supply-chain Levels for Software Artifacts) · SBOM formats SPDX and CycloneDX |

## Security Activities Across the Pipeline
- **Plan and design**: threat modelling and security requirements.
- **Code**: secure coding standards and secret scanning before commit.
- **Build**: static analysis (SAST) and software composition analysis (SCA) for vulnerable dependencies.
- **Test**: dynamic analysis (DAST) and security tests.
- **Package and release**: generate an SBOM, sign artifacts, verify provenance.
- **Deploy and operate**: infrastructure-as-code scanning, runtime monitoring, vulnerability management.

**SSDF practice groups**: prepare the organization, protect the software, produce well-secured software, and respond to vulnerabilities.

## Core Principles
- **Shift left, but keep the right side too.** Earlier is cheaper, and runtime monitoring still matters.
- **Automate the checks** so security keeps pace with delivery.
- **Make findings actionable**: high-signal, prioritised, delivered where developers work.
- **Know what you ship.** An SBOM and provenance make supply-chain risk visible.
- **Security is shared,** not owned by a separate gatekeeping team.

## Applications & Use Cases
| Use Case | Application | Activity |
|---|---|---|
| Vulnerable dependencies | SCA in the pipeline with fix prioritisation | Build |
| Leaked credentials | Secret scanning before and after commit | Code |
| Supply-chain assurance | SBOM generation, signing and provenance | Release |
| Misconfigured cloud | Scan infrastructure as code before deploy | Deploy |
| Customer and regulatory demands | Map practices to the SSDF | All |
| Program maturity | Assess against OWASP SAMM | All |

## Usage Guidelines
- **Threat-model new features** before building them.
- **Add SAST, SCA and secret scanning to the pipeline**, tuned for signal over noise.
- **Generate an SBOM for every release** in SPDX or CycloneDX format.
- **Sign artifacts and verify provenance** before deployment.
- **Set remediation timelines by severity** and track them.

## Prompt Template
```
You are assessing a DevSecOps pipeline (NIST SSDF SP 800-218; OWASP SAMM).

PIPELINE STAGES: [[...]]
FOR EACH STAGE — security controls present / missing:
plan (threat modelling) · code (secrets) · build (SAST, SCA) · test (DAST)
release (SBOM, signing, provenance) · deploy (IaC scanning) · operate (monitoring)
SSDF COVERAGE: prepare · protect · produce · respond
TOP GAPS and the order to close them:
```

## Ethical Guidelines
- **Disclose vulnerabilities responsibly** and protect users while fixes ship.
- **Do not suppress findings** to pass a gate.

## Testing Strategy
- Verify that pipeline checks actually block on critical findings.
- Periodically test detection with known-vulnerable samples.

## Success Metrics
- Mean time to remediate by severity.
- Critical vulnerabilities reaching production.
- Releases shipped with an SBOM and signed artifacts.

## Collaboration Protocol
- Inbound from: `devops-automator` · `security-architect` · `infrastructure-maintainer`
- Outbound to: CSO office for risk acceptance decisions
- Cross-framework: CI/CD provides the pipeline; OWASP Top 10 defines common risks; NIST SP 800-53 supplies control requirements.

## Related Skills
- `composable-skills/frameworks/cicd/SKILL.md` — the pipeline security runs in
- `composable-skills/frameworks/owasp-top-10/SKILL.md` — common application risks
- `composable-skills/frameworks/infrastructure-as-code/SKILL.md` — scanning infrastructure definitions
- `composable-skills/frameworks/nist-sp-800-53/SKILL.md` — control requirements

## Reference Materials
- NIST. (2022). SP 800-218, *Secure Software Development Framework (SSDF) Version 1.1.*
- OWASP. *Software Assurance Maturity Model (SAMM).*
- OpenSSF. *SLSA: Supply-chain Levels for Software Artifacts.* slsa.dev.
- NTIA. (2021). *The Minimum Elements for a Software Bill of Materials (SBOM).*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
