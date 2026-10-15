---
skill_id: cicd
name: CI/CD
version: 2.0.0
category: engineering-devops
type: framework
frameworks: []
triggers:
  - ci/cd
  - continuous integration
  - continuous delivery
  - deployment pipeline
  - dora metrics
collaborates_with:
  - devops-automator
  - backend-architect
  - api-tester
  - infrastructure-maintainer
ethics_required: false
priority: high
tags: [engineering, framework, ci, cd, deployment, devops]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# CI/CD

## Purpose
Use continuous integration and continuous delivery to make releasing software routine, low-risk and fast. **Continuous integration** means everyone merges small changes to a shared mainline frequently, with an automated build and test run each time. **Continuous delivery** means every change that passes the pipeline is releasable, so deployment becomes a business decision rather than a technical event. Research by the DORA program has linked these practices to both speed and stability, showing that the two need not be traded off.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `cicd` |
| Category | Engineering — Delivery Pipeline |
| Version | 2.0.0 |
| Key references | Fowler, "Continuous Integration" (2006) · Humble & Farley, *Continuous Delivery* (2010) · Forsgren, Humble & Kim, *Accelerate* (2018) |
| Delivery measures | The DORA metrics. Not to be confused with DORA, the EU Digital Operational Resilience Act, which has its own definition. |

## The Practices
- **Mainline development**: small, frequent merges, ideally daily.
- **Automated build and test** on every change.
- **A deployment pipeline**: stages from commit to production, each giving more confidence.
- **Build once, deploy the same artifact** to every environment.
- **Deployment automation and safe release techniques**: feature flags, canary and blue-green releases.
- **Fast feedback**: a broken build is fixed or reverted immediately.

### The DORA software delivery metrics
DORA currently defines five, in two groups (dora.dev):
- **Throughput**: change lead time; deployment frequency; failed deployment recovery time.
- **Instability**: change fail rate; deployment rework rate.
Earlier DORA reports and *Accelerate* (2018) used four metrics, with "time to restore service" in place of failed deployment recovery time and no rework rate.

## Core Principles
- **Small batches reduce risk.** Smaller changes are easier to test, review and roll back.
- **Keep the mainline releasable at all times.**
- **Automate everything repeatable**, from build to deployment.
- **Fix a broken pipeline first.** A red build blocks everyone.
- **Speed and stability go together** when the pipeline is well built.

## Applications & Use Cases
| Use Case | Application | Practice |
|---|---|---|
| Painful, infrequent releases | Automate the pipeline and release smaller changes | Small batches |
| Long-lived branches | Move to trunk-based development | Mainline development |
| Environment drift | Build once, deploy the same artifact | Artifact promotion |
| Risky deployments | Canary or blue-green releases with feature flags | Safe release |
| Measuring delivery | Track the DORA software delivery metrics | Measurement |
| Quality gates | Tests, security and performance checks in the pipeline | Automated testing |

## Usage Guidelines
- **Run the full automated test suite on every merge** to the mainline.
- **Keep branches short-lived**, merging at least daily.
- **Promote one immutable artifact** through all environments.
- **Separate deployment from release** with feature flags.
- **Track the DORA metrics** and improve the weakest.

## Prompt Template
```
You are designing or reviewing a CI/CD pipeline (Humble & Farley 2010; DORA metrics).

CURRENT STATE: branch strategy · merge frequency · test automation · release process
PIPELINE STAGES (commit -> production):
ARTIFACT PROMOTION: built once?
RELEASE SAFETY: feature flags · canary · blue-green · rollback
DORA METRICS: change lead time · deployment frequency · failed deployment recovery time · change fail rate · deployment rework rate
BIGGEST CONSTRAINT and the next improvement:
```

## Ethical Guidelines
- **Protect pipeline secrets and signing keys;** a compromised pipeline compromises every user.
- **Do not bypass quality and security gates** under deadline pressure.

## Testing Strategy
- Layered tests: fast unit tests on commit, broader tests in later stages.
- Test the rollback path, not only the deployment path.

## Success Metrics
- The DORA software delivery metrics (throughput and instability).
- Pipeline duration and reliability.
- Share of changes deployed without manual steps.

## Collaboration Protocol
- Inbound from: `devops-automator` · `backend-architect` · `api-tester`
- Outbound to: `infrastructure-maintainer` for environments
- Cross-framework: DevSecOps adds security to the pipeline; infrastructure as code provisions environments; Kanban shortens the flow before the pipeline.

## Related Skills
- `composable-skills/frameworks/devsecops/SKILL.md` — security in the pipeline
- `composable-skills/frameworks/infrastructure-as-code/SKILL.md` — reproducible environments
- `composable-skills/frameworks/kanban/SKILL.md` — flow of work into the pipeline

## Reference Materials
- Fowler, M. (2006). "Continuous Integration." martinfowler.com.
- Humble, J., & Farley, D. (2010). *Continuous Delivery.* Addison-Wesley.
- DORA. "DORA's software delivery performance metrics." dora.dev/guides/dora-metrics.
- Forsgren, N., Humble, J., & Kim, G. (2018). *Accelerate: The Science of Lean Software and DevOps.* IT Revolution Press.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
