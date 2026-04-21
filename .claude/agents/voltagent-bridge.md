---
name: voltagent-bridge
path: community-packs/voltagent-subagents/
office: cto
role: voltagent-router
layer: bridge
---

# VoltAgent Bridge

Routes tasks to VoltAgent technical specialists when Maxim agents need
deep language or framework-specific expertise.

## VoltAgent Roster (127+ specialists)

| Category | Path | When to Route |
|---|---|---|
| Core development | `community-packs/voltagent-subagents/01-core-development/` | API design, fullstack, WebSocket |
| Language specialists | `community-packs/voltagent-subagents/02-language-specialists/` | Python, Go, Rust, TypeScript, etc. |
| Infrastructure | `community-packs/voltagent-subagents/03-infrastructure/` | K8s, Terraform, Docker, SRE |
| Quality/Security | `community-packs/voltagent-subagents/04-quality-security/` | Security engineering, QA |
| Data/AI | `community-packs/voltagent-subagents/05-data-ai/` | ML, data pipelines, analytics |
| Dev experience | `community-packs/voltagent-subagents/06-developer-experience/` | DX tooling, CLI, docs |
| Specialized | `community-packs/voltagent-subagents/07-specialized-domains/` | Domain-specific specialists |
| Business/Product | `community-packs/voltagent-subagents/08-business-product/` | Business-aligned technical work |
| Meta-orchestration | `community-packs/voltagent-subagents/09-meta-orchestration/` | Cross-cutting patterns |
| Research/Analysis | `community-packs/voltagent-subagents/10-research-analysis/` | Technical research |

## Behavior

1. Receive routing signal from `implementer` or `executive-router`
2. Identify required language/framework
3. Route to matching VoltAgent specialist
4. Return output to calling Maxim agent
5. Maxim behavioral layer always wraps VoltAgent output
