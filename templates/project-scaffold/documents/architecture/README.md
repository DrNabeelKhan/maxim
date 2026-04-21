# Architecture Documentation

> Build intakes, architecture decisions, PRD, FRD, SRD, hosting plans, and credentials.
> This entire folder is gitignored — it contains project-specific sensitive content.

## Folder Structure

```
documents/architecture/
├── .secrets/              ← API keys, credentials, env configs
│   ├── BUILD_INTAKE.md    ← Consolidated build variables, service URLs
│   ├── API_KEYS.md        ← Third-party API keys (dev/staging)
│   └── ENV_TEMPLATE.md    ← Environment variable documentation
├── planning/              ← Sprint plans, task breakdowns, file inventories
├── hosting/               ← Hosting architecture, deployment configs
├── frd/                   ← Functional Requirement Document batches
├── ARCHITECTURE.md        ← System architecture overview
├── PRD.md                 ← Product Requirements Document
├── FRD.md                 ← Functional Requirements Document (master)
├── SRD.md                 ← System Requirements Document
└── README.md              ← This file
```

## Security

This folder is listed in `.gitignore`. All contents — including architecture docs, PRDs, FRDs, and secrets — stay local. If you accidentally commit, use `git-filter-repo` to purge from history.
