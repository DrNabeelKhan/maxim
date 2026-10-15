---
skill_id: api-design
name: API Design
version: 2.0.0
category: engineering-devops
type: framework
frameworks: []
triggers:
  - api design
  - rest api design
  - openapi spec
  - api versioning
  - idempotency
  - api error format
collaborates_with:
  - backend-architect
  - api-tester
  - documentation-writer
  - frontend-developer
ethics_required: true
priority: high
tags: [engineering, framework, api, rest, http, openapi]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# API Design

## Purpose
Use these API design principles to build interfaces that are predictable, safe to retry, easy to evolve and easy for other developers to use correctly. An API is a long-lived contract: once others depend on it, every design decision becomes expensive to change. Good design therefore leans on established standards, HTTP semantics, a machine-readable specification and consistent conventions, rather than inventing new ones.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `api-design` |
| Category | Engineering — Interface Design |
| Version | 2.0.0 |
| Architectural style | REST, defined by Roy Fielding (2000) |
| HTTP semantics | RFC 9110 (2022) |
| Specification format | OpenAPI Specification 3.1 (2021) |
| Error format | Problem Details for HTTP APIs, RFC 9457 (2023, obsoletes RFC 7807) |
| Security reference | OWASP API Security Top 10 (2023) |

## Key Design Areas
- **Resources and naming**: nouns for resources, consistent plural naming, predictable paths.
- **HTTP methods and their semantics**: GET, PUT and DELETE are idempotent; POST is not. Use methods for what they mean.
- **Status codes**: the right class (2xx success, 4xx client error, 5xx server error) and the specific code.
- **Errors**: a consistent, machine-readable body, such as RFC 9457 Problem Details.
- **Idempotency for non-idempotent operations**: an idempotency key lets clients retry a POST safely.
- **Pagination, filtering and sorting**: cursor-based pagination for large or changing datasets.
- **Versioning and evolution**: additive changes by default, explicit versions for breaking ones.
- **Security**: authentication, per-object authorisation, rate limiting and input validation.

## Core Principles
- **Design the contract first** in a specification, then implement it.
- **Follow HTTP semantics** so clients, caches and proxies behave correctly.
- **Make operations safe to retry.** Networks fail; idempotency prevents duplicate side effects.
- **Never break existing clients silently.** Prefer additive changes; version and deprecate deliberately.
- **Authorise every object access.** Broken object-level authorisation tops the OWASP API Top 10.

## Applications & Use Cases
| Use Case | Application | Area |
|---|---|---|
| New public API | Spec-first design and review | Contract |
| Payments and orders | Idempotency keys on creating operations | Retries |
| Inconsistent errors | Adopt Problem Details across services | Errors |
| Large collections | Cursor-based pagination | Pagination |
| Breaking changes | Version, document and deprecate with a timeline | Evolution |
| Security review | Check against the OWASP API Security Top 10 | Security |

## Usage Guidelines
- **Write the OpenAPI specification before the code** and review it with consumers.
- **Use methods and status codes as HTTP defines them.**
- **Support idempotency keys** for operations that create or charge.
- **Return errors in one consistent, machine-readable format.**
- **Check object-level authorisation on every request** that accesses a resource by identifier.

## Prompt Template
```
You are designing an API (REST, RFC 9110, OpenAPI 3.1).

RESOURCES and operations: [[...]]
FOR EACH OPERATION
- Method and path (idempotent?):
- Request and response schema:
- Status codes:
- Errors (RFC 9457 Problem Details):
- Retry safety (idempotency key needed?):
- Authorisation check:
EVOLUTION: additive or breaking? Versioning and deprecation plan.
SECURITY: OWASP API Security Top 10 review.
```

## Ethical Guidelines
- **Minimise data exposure.** Return only the fields clients need, especially personal data.
- **Rate-limit and protect** against abuse that could harm other users.

## Testing Strategy
- Contract tests against the specification.
- Security tests for authorisation on every endpoint.
- Retry tests that confirm idempotent behavior.

## Success Metrics
- Breaking changes shipped without a version (target: none).
- Endpoints covered by the specification and contract tests.
- Authorisation defects found in testing versus production.

## Collaboration Protocol
- Inbound from: `backend-architect` · `frontend-developer` · `api-tester`
- Outbound to: `documentation-writer` for reference docs; CSO office for security review
- Cross-framework: OWASP Top 10 for security; microservices architecture for service boundaries; CI/CD for contract testing in the pipeline.

## Related Skills
- `composable-skills/frameworks/owasp-top-10/SKILL.md` — application security
- `composable-skills/frameworks/microservices-architecture/SKILL.md` — service boundaries
- `composable-skills/frameworks/cicd/SKILL.md` — contract tests in the pipeline

## Reference Materials
- Fielding, R.T. (2000). *Architectural Styles and the Design of Network-based Software Architectures.* Doctoral dissertation, University of California, Irvine.
- IETF. RFC 9110, *HTTP Semantics* (2022).
- IETF. RFC 9457, *Problem Details for HTTP APIs* (2023).
- OpenAPI Initiative. *OpenAPI Specification 3.1.0* (2021).
- OWASP. *API Security Top 10* (2023).

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
