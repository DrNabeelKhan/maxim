# notebooklm-py — Maxim Integration Notes

> This directory holds the **upstream community pack** for `teng-lin/notebooklm-py`, copied verbatim per ADR-008 Community Pack System and ADR-018 External Tool Integration Pattern.

## Files in this directory

- [`SKILL.md`](SKILL.md) — Upstream skill definition (verbatim — DO NOT MODIFY).
- [`LICENSE`](LICENSE) — Upstream MIT License (Copyright (c) 2026 Teng Lin). Compatible with Maxim's BSL-1.1.
- [`UPSTREAM_README.md`](UPSTREAM_README.md) — Upstream README (verbatim).
- This file (`MAXIM_INTEGRATION.md`) — Maxim-specific integration notes (NOT upstream).

## Maxim's value-add on top of upstream

Maxim's contribution to the integration is:

1. **`.claude/skills/notebooklm-py/SKILL.md`** — Maxim-flavored skill with ADR-007 behavioral framing (Diátaxis · Diffusion of Innovations · Dual Coding Theory) + office routing logic + ethics gate + fragility disclosure.

2. **`mcp/mxm-notebooklm/server.js`** — Node MCP server with 38 tools wrapping the upstream CLI. Cross-surface (Claude Code · Desktop · Web · Cowork) via MCP rather than Code-only via SKILL.md.

3. **Office routing in `mxm-catalog`** — `cino-office` primary (research synthesis), `cmo-office` secondary (audio/video/podcast production), `cpo-office` secondary (quiz/flashcards/onboarding artifacts). `cso-office` auto-loops on source upload for ethics + compliance.

4. **Fragility disclosure** — every operation output carries an `ADR-018 fragility_disclosure` audit-trail line acknowledging the undocumented-Google-API dependency.

## Why two SKILL.md files?

Per Maxim's dispatch sequence (CLAUDE.md):

> STEP 1 — Does `.claude/skills/{domain}/` have a Maxim skill for this?
>   YES → Activate Maxim skill, check community-packs for matching domain skill, MERGE
>   NO → Steps 2–5 (community-packs / composable-skills / behavioral layer)

The Maxim skill at `.claude/skills/notebooklm-py/SKILL.md` is the **primary dispatch surface** — it wins. This community-pack copy is the **canonical upstream reference** — preserved so operators (and future Maxim maintainers) can see exactly what upstream ships and detect drift when the upstream updates.

When updating: re-fetch `SKILL.md` + `LICENSE` + `UPSTREAM_README.md` verbatim from the upstream `main` branch. Do NOT edit those files locally. The Maxim-flavored skill at `.claude/skills/notebooklm-py/SKILL.md` is the file Maxim authors and maintains.

## License compatibility

| Component | License | Notes |
|---|---|---|
| Upstream notebooklm-py | MIT (Copyright 2026 Teng Lin) | Permissive — allows commercial use with attribution |
| This community pack copy | MIT (inherited) | Verbatim redistribution per MIT terms |
| Maxim-flavored skill at `.claude/skills/notebooklm-py/` | BSL-1.1 | Maxim's authored content — converts to Apache-2.0 after 4 years per ADR-005 |
| `mcp/mxm-notebooklm/` server | BSL-1.1 | Maxim's authored wrapper — same conversion path |

Combination is clean: MIT inside BSL-1.1 is permitted; MIT attribution preserved via this directory's LICENSE file.

## Fragility disclosure (mandatory per ADR-018)

Upstream notebooklm-py uses **undocumented Google APIs**. This is acknowledged upstream:

> *"Not affiliated with Google. API endpoints can change without notice. Best suited for prototypes, research, personal projects rather than production systems."*

Maxim ships this integration "by default" per operator directive but inherits the fragility. If a Google API change breaks the upstream:

1. The Maxim `mxm-notebooklm` MCP will surface a structured error rather than crashing
2. Operator remediation path is documented in the Maxim skill: `pip install --upgrade notebooklm-py` and check [upstream issues](https://github.com/teng-lin/notebooklm-py/issues)
3. The rest of Maxim continues working — only this skill degrades

## Update protocol

When the upstream releases a new version (check via `gh api repos/teng-lin/notebooklm-py/releases/latest`):

```bash
cd community-packs/notebooklm-py
curl -sL https://raw.githubusercontent.com/teng-lin/notebooklm-py/main/SKILL.md -o SKILL.md
curl -sL https://raw.githubusercontent.com/teng-lin/notebooklm-py/main/LICENSE -o LICENSE
curl -sL https://raw.githubusercontent.com/teng-lin/notebooklm-py/main/README.md -o UPSTREAM_README.md
git diff  # review what changed upstream
```

Then update `.claude/skills/notebooklm-py/SKILL.md` if upstream added/removed capabilities, and bump `mcp/mxm-notebooklm/server.js` if new CLI commands appeared.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Integration notes only — upstream files are MIT (Teng Lin). Ratified by ADR-018 (2026-05-20)._
