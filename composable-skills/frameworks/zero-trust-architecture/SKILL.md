---
skill_id: zero-trust-architecture
name: Zero Trust Architecture
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - zero trust
  - zero trust architecture
  - never trust always verify
  - identity-based access
  - microsegmentation
collaborates_with:
  - security-architect
  - infrastructure-maintainer
  - security-auditor
  - devops-automator
ethics_required: true
priority: high
tags: [security, framework, zero-trust, identity, network, nist]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Zero Trust Architecture

## Purpose
Use zero trust architecture to stop granting trust based on network location. Instead, every request to a resource is authenticated and authorised, per session, using dynamic policy based on identity, device state and other signals. The aim is to limit what an attacker can reach after compromising one account or device, which is why zero trust is especially valuable against lateral movement. It is a set of principles and an architecture, not a product.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `zero-trust-architecture` |
| Category | Security — Architecture |
| Version | 2.0.0 |
| Core reference | NIST SP 800-207, *Zero Trust Architecture* (2020) |
| Maturity model | CISA *Zero Trust Maturity Model* Version 2.0 (2023) |
| Origins | Kindervag, Forrester Research (2010) · Google BeyondCorp (Ward & Beyer, 2014) |

## Key Elements
**NIST SP 800-207 logical components**
- **Policy engine**: decides whether to grant access.
- **Policy administrator**: establishes or shuts down the connection based on that decision.
- **Policy enforcement point**: enables, monitors and terminates connections between subject and resource.

**CISA pillars**: identity; devices; networks; applications and workloads; and data. Cross-cutting capabilities: visibility and analytics, automation and orchestration, and governance. Maturity stages: traditional, initial, advanced and optimal.

## Core Principles
- **No implicit trust from network location.** Being inside the network grants nothing.
- **Secure all communication**, wherever it travels.
- **Grant access per session, with least privilege.**
- **Decide access by dynamic policy**, using identity, device posture, behaviour and context.
- **Monitor continuously** and use what you learn to improve policy.

## Applications & Use Cases
| Use Case | Application | Pillar |
|---|---|---|
| Replacing VPN access | Identity-aware access to individual applications | Identity, networks |
| Limiting lateral movement | Microsegmentation between workloads | Networks |
| Unmanaged devices | Device posture checks before access | Devices |
| Phishing-resistant authentication | Strong, phishing-resistant MFA | Identity |
| Sensitive data | Classify data and enforce access by attribute | Data |
| Cloud and hybrid estates | Consistent policy across environments | Applications and workloads |

## Usage Guidelines
- **Inventory users, devices, applications and data** before writing policy.
- **Start with identity:** strong, phishing-resistant authentication and centralised identity.
- **Protect the most sensitive resources first**, then extend.
- **Segment workloads** and remove broad network access.
- **Assess maturity per pillar** with the CISA model and plan the next stage.

## Prompt Template
```
You are designing a zero trust architecture (NIST SP 800-207; CISA ZTMM v2.0).

PROTECT SURFACE: critical data, applications, assets: [[...]]
FOR EACH PILLAR (identity · devices · networks · applications and workloads · data)
  current maturity · target maturity · next steps
POLICY: signals used for access decisions
ENFORCEMENT POINTS:
MONITORING and analytics:
```

## Ethical Guidelines
- **Continuous monitoring involves employee data;** be transparent and collect only what policy needs.
- **Balance security with accessibility** so controls do not exclude users with disabilities.

## Testing Strategy
- Test that access is denied without required signals.
- Red-team for lateral movement after a simulated compromise.

## Success Metrics
- Maturity stage per pillar.
- Share of applications behind identity-aware access.
- Blast radius of simulated compromises.

## Collaboration Protocol
- Inbound from: `security-architect` · `security-auditor`
- Outbound to: `infrastructure-maintainer` · `devops-automator`
- Cross-framework: NIST CSF Protect; MITRE ATT&CK lateral-movement techniques; cloud architecture for identity and network design.

## Related Skills
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — program context
- `composable-skills/frameworks/mitre-attck/SKILL.md` — techniques zero trust limits
- `composable-skills/frameworks/cloud-architecture/SKILL.md` — cloud identity and network

## Reference Materials
- Rose, S., Borchert, O., Mitchell, S., & Connelly, S. (2020). *Zero Trust Architecture.* NIST SP 800-207.
- CISA. (2023). *Zero Trust Maturity Model, Version 2.0.*
- Ward, R., & Beyer, B. (2014). "BeyondCorp: A New Approach to Enterprise Security." *;login:*, 39(6).
- Kindervag, J. (2010). *No More Chewy Centers: Introducing the Zero Trust Model of Information Security.* Forrester Research.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
