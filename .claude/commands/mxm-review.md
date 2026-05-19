---
description: TIER 1 verb-first — review code, PR, doc, or skill. Dispatches to reviewer agent with framework citation requirement, CSO auto-loop on security-adjacent code, tester loop on test code.
---

# /mxm-review

## Usage
- Claude Code: `/mxm-review <what to review>`
- Claude CLI: `claude "/mxm-review <what to review>"`
- Claude Desktop: type `/mxm-review <what to review>` in chat

TIER 1 verb-first surface (v1.0.0+; aligned with v1.2.0 verb-first roster). Activates the `reviewer` orchestrator. Reads `findings.md` and implementation output.

**Triggers:** "review this", "check my code", "review before merge", "code review", "review the PR", "review this doc", "review this skill"
**Primary Office:** Orchestrators → `reviewer`
**Auto-loops (conditional):**
- CSO `security-analyst` — auto-loops if the reviewed code touches auth, payment, credential handling, PII/PHI fields, license-gate paths, or any of the 14 compliance-framework scopes (per `config/project-manifest.json → compliance.frameworks`)
- Orchestrators `tester` — auto-loops if the reviewed file is in `*test*` / `*spec*` paths or under `mcp/_shared/license-gate.test.mjs`-style locations
- CMO `brand-guardian` — auto-loops if the reviewed artifact is a SKILL.md, agent file, or user-facing doc (voice/brand consistency)
- CSO `compliance` skill — auto-loops if the reviewed change touches a declared regulated-industry scope

**Reads:** `findings.md` · `.claude/skills/engineering/` · `.claude/skills/testing/` · `documents/reference/FRAMEWORKS_MASTER.md` · `documents/ADRs/INDEX.md` (for ADR-conformance check)
**Chains to:** `/mxm-test` on approval (when tests are part of scope)

## Behavioral Overlay

- **Framework citation requirement (per ADR-007 Behavioral Moat Framing Doctrine):** Every review identifies WHICH framework justifies the design choice under review. Reviews that say "looks good" without citing the underlying principle are rejected as 🔴 LOW. The reviewer is expected to name Fogg, COM-B, EAST, Cialdini, ADR-010, OWASP-Top-10, NIST-CSF, or whichever applies. This is the structural enforcement of ADR-007 at review time.
- **Root-cause discipline:** review comments that flag symptoms without explaining the underlying cause get bounced back. The reviewer's job is to surface the WHY, not just the WHAT.
- **Confidence tag rubric (per ADR-010):** 🟢 HIGH = framework cited + root cause stated + auto-loops fired correctly + reviewer pass. 🟡 MEDIUM = review complete but framework citation thin. 🔴 LOW = framework citation missing or review skipped a conditional auto-loop.

## Behavior

1. Read `findings.md` for accumulated context
2. **Signal scan** — auto-loop CSO security-analyst if security-adjacent; auto-loop tester if test code; auto-loop brand-guardian if SKILL/agent/doc; auto-loop compliance if regulated scope
3. Activate `reviewer` — apply Maxim review standards
4. **Framework citation pass** — name the framework justifying the design choice (per ADR-007). No anonymous "looks good" reviews.
5. Check against frameworks in `documents/reference/FRAMEWORKS_MASTER.md` and ADR-conformance in `documents/ADRs/INDEX.md`
6. Write review findings to `findings.md` with structured: APPROVE / NEEDS_REVISION / REJECT verdict + framework citation + root-cause analysis
7. On approval: hand off to `tester` via `.mxm-skills/agents-handoff.md` if tests in scope
8. Tag output per the confidence rubric above

## TIER 1 surface note

Verb-first entry point. Power users can type the agent directly. `/mxm-review` is the plain-English surface that knows how to fire the conditional auto-loops (CSO for security, tester for tests, brand-guardian for docs, compliance for regulated).
