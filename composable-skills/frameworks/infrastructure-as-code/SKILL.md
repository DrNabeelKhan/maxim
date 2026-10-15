---
skill_id: infrastructure-as-code
name: Infrastructure as Code
version: 2.0.0
category: engineering-devops
type: framework
frameworks: []
triggers:
  - infrastructure as code
  - terraform
  - gitops
  - configuration drift
  - reproducible environments
collaborates_with:
  - devops-automator
  - infrastructure-maintainer
  - security-architect
  - backend-architect
ethics_required: false
priority: high
tags: [engineering, framework, iac, gitops, automation, cloud]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# Infrastructure as Code

## Purpose
Use infrastructure as code (IaC) to define servers, networks, databases and other infrastructure in version-controlled files, and to create and change them through automation rather than by hand. This makes environments reproducible, changes reviewable, and the actual state of infrastructure knowable. It applies software engineering practice, such as version control, review, testing and continuous delivery, to infrastructure.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `infrastructure-as-code` |
| Category | Engineering — Infrastructure Automation |
| Version | 2.0.0 |
| Key reference | Morris, *Infrastructure as Code* (O'Reilly; 1st ed. 2016, 2nd ed. 2020, 3rd ed. 2025) |
| Related practices | GitOps · policy as code · immutable infrastructure |
| Common tools | Terraform and OpenTofu · Pulumi · AWS CloudFormation · Ansible |

## Key Concepts
- **Declarative versus imperative.** Declarative tools describe the desired end state and work out the steps; imperative tools specify the steps.
- **Idempotency.** Applying the same definition repeatedly produces the same result.
- **State.** Many tools record what they manage; that state must be stored securely and shared safely.
- **Drift.** Manual changes that make reality differ from the code; detect and correct it.
- **Immutable infrastructure.** Replace components rather than modifying them in place.
- **GitOps.** The repository is the source of truth, and an automated agent reconciles the running system to it.

## Core Principles
- **Everything in version control**, reviewed like application code.
- **No manual changes in production.** Manual changes create drift and undocumented state.
- **Small, modular, reusable definitions.**
- **Test infrastructure changes** before applying them, for example with plans, policy checks and test environments.
- **Treat state and secrets as sensitive**; never commit secrets to the repository.

## Applications & Use Cases
| Use Case | Application | Concept |
|---|---|---|
| Inconsistent environments | Define all environments from the same modules | Reproducibility |
| Risky manual changes | Review infrastructure changes as pull requests | Version control |
| Configuration drift | Scheduled drift detection and reconciliation | Drift |
| Disaster recovery | Rebuild environments from code | Reproducibility |
| Compliance controls | Enforce rules with policy as code | Policy as code |
| Kubernetes delivery | Reconcile clusters from Git | GitOps |

## Usage Guidelines
- **Keep infrastructure definitions in the same review process as application code.**
- **Store state remotely, with locking and encryption.**
- **Review the plan** of changes before every apply.
- **Scan definitions for misconfigurations** and enforce policy as code in the pipeline.
- **Detect and correct drift on a schedule.**

## Prompt Template
```
You are designing or reviewing infrastructure as code (Morris).

RESOURCES MANAGED: [[...]]
APPROACH: declarative | imperative · tool:
STATE: where stored? locked? encrypted?
MODULES and reuse:
CHANGE PROCESS: pull request -> plan -> policy check -> apply
DRIFT DETECTION:
SECRETS: how injected (never committed)?
```

## Ethical Guidelines
- **Never commit secrets or credentials** to infrastructure repositories.
- **Apply least privilege** to the automation that changes infrastructure.

## Testing Strategy
- Static analysis and policy checks on definitions.
- Apply to an ephemeral environment before production.

## Success Metrics
- Share of infrastructure managed as code.
- Drift incidents detected and corrected.
- Time to rebuild an environment from scratch.

## Collaboration Protocol
- Inbound from: `devops-automator` · `infrastructure-maintainer` · `backend-architect`
- Outbound to: `security-architect` for policy and access review
- Cross-framework: CI/CD runs the infrastructure pipeline; DevSecOps scans the definitions; cloud architecture shapes what is defined.

## Related Skills
- `composable-skills/frameworks/cicd/SKILL.md` — the delivery pipeline
- `composable-skills/frameworks/devsecops/SKILL.md` — scanning definitions
- `composable-skills/frameworks/cloud-architecture/SKILL.md` — what the code describes

## Reference Materials
- Morris, K. (2020). *Infrastructure as Code: Dynamic Systems for the Cloud Age* (2nd ed.). O'Reilly Media. (1st ed., 2016: *Managing Servers in the Cloud*; 3rd ed., 2025: *Designing and Delivering Dynamic Systems for the Cloud Age*.)
- OpenGitOps (CNCF). *GitOps Principles.* opengitops.dev.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
