# Prototypes

> UI prototypes, v0 demos, proof-of-concepts, and experimental builds.

## Typical Contents

```
prototypes/
├── v0-app/                ← First prototype (e.g., v0.dev, Bolt, Lovable output)
├── v0-landing-page/       ← Landing page prototype
├── v0-admin/              ← Admin dashboard prototype
├── poc-[feature]/         ← Proof-of-concept for specific features
└── README.md              ← This file
```

## Guidelines

- Prototypes are throwaway code — they validate ideas, not ship to production
- Name prototypes with `v0-` prefix for initial versions
- Name proof-of-concepts with `poc-` prefix
- Once a prototype is validated, move the learnings to `documents/architecture/` and build properly in the main codebase
- Large prototype folders can be excluded from git if needed (add to `.gitignore`)
