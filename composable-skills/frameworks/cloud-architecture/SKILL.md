---
skill_id: cloud-architecture
name: Cloud Architecture
version: 2.0.0
category: engineering-devops
type: framework
frameworks: []
triggers:
  - cloud architecture
  - well-architected review
  - design for the cloud
  - shared responsibility model
  - cloud cost and reliability
collaborates_with:
  - solution-architect
  - backend-architect
  - devops-automator
  - infrastructure-maintainer
ethics_required: false
priority: high
tags: [engineering, framework, cloud, well-architected, reliability, cost]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Cloud Architecture

## Purpose
Use cloud architecture principles to design systems that are secure, reliable, efficient and affordable on cloud platforms. The major providers publish **well-architected frameworks** that organise these concerns into pillars and offer review questions; they are the practical standard for assessing a cloud design. Underneath them sit two foundational ideas: NIST's definition of what cloud computing is, and the **shared responsibility model**, which divides security duties between provider and customer.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `cloud-architecture` |
| Category | Engineering — Cloud Systems Design |
| Version | 2.0.0 |
| Definition | NIST SP 800-145, *The NIST Definition of Cloud Computing* (2011) |
| AWS Well-Architected | Six pillars: operational excellence, security, reliability, performance efficiency, cost optimization, sustainability (added 2021) |
| Azure Well-Architected | Five pillars: reliability, security, cost optimization, operational excellence, performance efficiency |

## Foundations
**NIST definition**: five essential characteristics (on-demand self-service, broad network access, resource pooling, rapid elasticity, measured service), three service models (IaaS, PaaS, SaaS) and four deployment models (private, community, public, hybrid).

**Shared responsibility.** The provider secures the cloud itself; the customer secures what they put in it. The split shifts with the service model: the customer carries more for IaaS than for SaaS.

**Well-architected pillars, in short**
- **Security**: identity, data protection, detection.
- **Reliability**: recover from failure and meet demand.
- **Performance efficiency**: use resources effectively as demand changes.
- **Cost optimisation**: avoid unnecessary spend.
- **Operational excellence**: run and improve the system.
- **Sustainability** (AWS): reduce environmental impact.

## Core Principles
- **Design for failure.** Components fail; the system should not.
- **Know your side of shared responsibility**, especially for identity and data.
- **Elasticity over fixed capacity**, scaling with demand.
- **Cost is an architectural property.** Design and review it, not just monitor it.
- **Pillars trade off.** More resilience usually costs more; make the trade-offs explicit.

## Applications & Use Cases
| Use Case | Application | Pillar |
|---|---|---|
| Architecture reviews | Run the provider's well-architected review | All |
| High-availability design | Multiple availability zones, health checks, failover | Reliability |
| Rising cloud bills | Rightsizing, autoscaling and pricing commitments | Cost optimisation |
| Data protection | Encryption, key management and access control | Security |
| Migration planning | Choose the service model per workload | All |
| Incident readiness | Runbooks, observability and recovery tests | Operational excellence |

## Usage Guidelines
- **Run a well-architected review** for significant systems, using the provider's questions.
- **Document the shared-responsibility split** for each service you use.
- **Set availability and recovery targets** (for example RTO and RPO) and design to them.
- **Tag resources and review cost** as part of design, not after the bill arrives.
- **Record pillar trade-offs** in architecture decision records.

## Prompt Template
```
You are reviewing a cloud architecture (well-architected pillars; NIST SP 800-145).

WORKLOAD and service models used: [[...]]
SHARED RESPONSIBILITY: what does the customer own here?
PILLARS — current state, risks, improvements:
security · reliability (RTO/RPO) · performance efficiency · cost · operational excellence · sustainability
TRADE-OFFS accepted, and why:
```

## Ethical Guidelines
- **Protect customer data** under the customer's side of shared responsibility; do not assume the provider does it.
- **Consider data residency** obligations when choosing regions.

## Testing Strategy
- Test failover and recovery regularly against stated targets.
- Load-test to confirm scaling behavior.

## Success Metrics
- Availability against target.
- Recovery time and recovery point achieved in tests.
- Cost per unit of business value over time.
- Open high-risk findings from well-architected reviews.

## Collaboration Protocol
- Inbound from: `solution-architect` · `backend-architect` · `devops-automator`
- Outbound to: `infrastructure-maintainer` for operations; CSO office for security architecture
- Cross-framework: Infrastructure as code implements the design; zero trust shapes identity and network design; microservices architecture shapes workload structure.

## Related Skills
- `composable-skills/frameworks/infrastructure-as-code/SKILL.md` — implementing the design
- `composable-skills/frameworks/zero-trust-architecture/SKILL.md` — identity-centred security
- `composable-skills/frameworks/microservices-architecture/SKILL.md` — workload structure

## Reference Materials
- NIST. (2011). SP 800-145, *The NIST Definition of Cloud Computing.*
- Amazon Web Services. *AWS Well-Architected Framework.*
- Microsoft. *Azure Well-Architected Framework.*
- Google Cloud. *Google Cloud Architecture Framework.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
