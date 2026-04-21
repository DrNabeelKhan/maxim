# Maxim Cowork Plugin

Maxim is an 87-agent behavioral intelligence platform. It applies behavioral science (Fogg, COM-B, EAST), 63 frameworks, and 22 skill domains to every output — routing tasks automatically through 7 executive offices. Model-agnostic and provider-pluggable.

---

## Install

1. Clone the repo:
   ```bash
   git clone https://github.com/DrNabeelKhan/maxim.git
   cd maxim
   ```

2. Run the global installer (Windows):
   ```powershell
   .\bootstrap\install-global.ps1
   ```

   This installs Maxim commands, skill paths, and agent catalog globally so every project can use them.

---

## Configure

1. Copy the project manifest template:
   ```bash
   cp config/project-manifest.TEMPLATE.json config/project-manifest.json
   ```

2. Fill in your project identity, compliance scope, and tech stack. Fields marked `[REQUIRED]` must be completed before agents will run correctly.

3. Optionally create `CLAUDE.project.md` in your project root for brand voice, project-specific overrides, and bootstrap mappings.

---

## Use

Key commands to get started:

| Command           | What it does                                              |
|-------------------|-----------------------------------------------------------|
| `/mxm-help`      | Full command reference card                               |
| `/mxm-status`    | System health — install mode, skill gaps, compliance      |
| `/mxm-new-project` | Bootstrap a new project — 11 files + session memory     |
| `/mxm-route`     | Describe any task — Maxim classifies and routes it         |
| `/mxm-ceo`       | Strategy, finance, enterprise architecture                |
| `/mxm-cto`       | Engineering, AI, APIs, DevOps, cloud                      |
| `/mxm-cmo`       | Marketing, content, SEO, brand, growth                    |
| `/mxm-cso`       | Security, compliance, privacy, ethics                     |
| `/mxm-cpo`       | Product, UX/UI, research, pricing                         |
| `/mxm-coo`       | Planning, delivery, operations, support                   |
| `/mxm-plan`      | Start the product cycle for any feature                   |
| `/mxm-context`   | Generate portable context for Claude.ai / Desktop         |

---

## Requirements

- Claude Code, Claude CLI, or Claude Desktop
- Windows: PowerShell 5.1+ for bootstrap scripts
- Linux/Mac: bash for `bootstrap/new-project-setup.sh`
- Git (for subtree updates to external skill libraries)
- `config/project-manifest.json` present in project root before running agents
