---
skill_id: microservices-architecture
name: Microservices Architecture
version: 2.0.0
category: engineering-devops
type: framework
frameworks: []
triggers:
  - microservices
  - split the monolith
  - service boundaries
  - saga pattern
  - circuit breaker
collaborates_with:
  - backend-architect
  - devops-automator
  - api-tester
  - security-architect
ethics_required: false
priority: high
tags: [engineering, framework, microservices, distributed-systems, architecture]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Microservices Architecture

## Purpose
Use microservices architecture to build a system as a set of small, independently deployable services, each owning a business capability and its data, communicating over the network. The aim is to let teams change and deploy their parts independently. The cost is the complexity of a distributed system: network failures, data consistency across services, and much more operational work. The most important decision is often whether the benefits justify that cost for your organisation.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `microservices-architecture` |
| Category | Engineering — Distributed Systems Architecture |
| Version | 2.0.0 |
| Defining article | Lewis & Fowler, "Microservices" (2014) |
| Key books | Newman, *Building Microservices* (2015; 2nd ed. 2021) · Richardson, *Microservices Patterns* (2018) |
| Related law | Conway's Law (Conway, 1968) |

## Key Patterns
- **Service per business capability**, with boundaries often found through domain-driven design.
- **Database per service**: each service owns its data; others access it only through its API.
- **API gateway**: a single entry point for clients.
- **Saga**: a sequence of local transactions with compensating actions, replacing distributed transactions.
- **Circuit breaker**: stop calling a failing dependency to prevent cascading failure.
- **Strangler fig**: migrate from a monolith gradually by routing functions to new services.

**Conway's Law**: systems tend to mirror the communication structure of the organisations that build them, so service boundaries and team boundaries should be designed together.

## Core Principles
- **Independent deployability is the goal.** Services that must be deployed together are a distributed monolith.
- **Own your data.** Shared databases couple services tightly.
- **Design for failure.** Use timeouts, retries with backoff, and circuit breakers.
- **Start with a well-structured monolith** unless you already have the scale and teams that need independence.
- **Invest in observability.** Distributed tracing and centralised logging are prerequisites, not extras.

## Applications & Use Cases
| Use Case | Application | Pattern |
|---|---|---|
| Teams blocking each other | Align services to team-owned capabilities | Service per capability |
| Monolith migration | Route functions to new services gradually | Strangler fig |
| Cross-service business processes | Coordinate with sagas | Saga |
| Cascading outages | Isolate failing dependencies | Circuit breaker |
| Many client types | Central entry and routing | API gateway |
| Shared database bottleneck | Split data ownership | Database per service |

## Usage Guidelines
- **Decide deliberately whether to adopt microservices**, weighing team size and scaling needs against operational cost.
- **Draw boundaries around business capabilities**, not technical layers.
- **Give each service its own data store** and access data only through APIs.
- **Build resilience into every network call.**
- **Put tracing, logging and metrics in place before splitting.**

## Prompt Template
```
You are designing a microservices architecture (Lewis & Fowler 2014; Newman; Richardson).

SHOULD WE? team count, scaling needs, operational maturity:
SERVICES and the business capability each owns:
DATA OWNERSHIP: one store per service?
COMMUNICATION: synchronous / asynchronous, and failure handling
CROSS-SERVICE TRANSACTIONS: saga design
OBSERVABILITY: tracing, logging, metrics
TEAM ALIGNMENT (Conway's Law):
```

## Ethical Guidelines
- **Secure service-to-service communication** and apply least privilege between services.
- **Track where personal data lives** across services to meet privacy obligations.

## Testing Strategy
- Contract tests between services.
- Resilience testing that injects failures and latency.

## Success Metrics
- Deployment frequency per service.
- Share of deployments that require coordinating several services (target: low).
- Incidents caused by cascading failures.

## Collaboration Protocol
- Inbound from: `backend-architect` · `devops-automator` · `api-tester`
- Outbound to: `security-architect` for inter-service security
- Cross-framework: API design for service contracts; CI/CD for independent deployment; cloud architecture for the platform.

## Related Skills
- `composable-skills/frameworks/api-design/SKILL.md` — service contracts
- `composable-skills/frameworks/cicd/SKILL.md` — independent deployment
- `composable-skills/frameworks/cloud-architecture/SKILL.md` — the platform underneath

## Reference Materials
- Lewis, J., & Fowler, M. (2014). "Microservices." martinfowler.com.
- Newman, S. (2021). *Building Microservices* (2nd ed.). O'Reilly Media.
- Richardson, C. (2018). *Microservices Patterns.* Manning.
- Conway, M.E. (1968). "How Do Committees Invent?" *Datamation*, 14(4), 28–31.
- Nygard, M.T. (2007). *Release It!* Pragmatic Bookshelf.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
