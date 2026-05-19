---
description: TIER 1 verb-first — cut a release, publish, or deploy. Plain-English entry point that chains to /mxm-release with COO planner + CSO + reviewer + CMO (CHANGELOG) coordinated auto-loops and SBOM check.
---

# /mxm-ship

## Usage
- Claude Code: `/mxm-ship <version or scope>`
- Claude CLI: `claude "/mxm-ship <version or scope>"`
- Claude Desktop: type `/mxm-ship <version or scope>` in chat

User-facing verb-first command (TIER 1 surface added v1.2.0). The operator-friendly entry point for shipping work. Chains into `/mxm-release` after running pre-ship coordination across COO + CSO + reviewer + CMO.

**Triggers:** "ship", "ship this", "release", "deploy", "publish", "cut a release", "tag", "push to prod", "go live"
**Primary Office:** COO → `planner` (coordinator) → routes through Orchestrators → `release-manager`
**Auto-loops (parallel, all four):**
- CSO `security-analyst` — SBOM check, secret/PII scan, regulated-data compliance review, license-middleware verification (for runtime gates)
- Orchestrators `reviewer` — final code review pass on uncommitted/unreviewed changes
- CMO `documentation-writer` + `content-strategist` — CHANGELOG entry drafted + landing-page/marketing surface drift check
- COO `planner` — session-end 9-document closure bundle invoked

**Reads:** `progress.md` · `findings.md` · `BUG_TRACKER.md` (any open P0/P1?) · `CHANGELOG.md` (current top) · `config/agent-registry.json` (version)
**Writes:** `CHANGELOG.md` (new version entry); commit; tag; (optionally) push if explicitly authorized by operator

## Behavioral Overlay

- **Session-end 9-document closure bundle (per ADR-002):** `/mxm-ship` does not bypass the closure ritual. Before any tag is created, the 9 documents (SESSION_CONTINUITY, SPRINT_CLI_INSTRUCTIONS if active, progress.md, BUG_TRACKER, DEBUGGING_PLAYBOOK, MOAT_TRACKER, CHANGELOG, project-manifest, MEMORY.md) get updated. Operator can skip the bundle ONLY by typing `/mxm-release` directly (power-user bypass).
- **SBOM check (per ADR-012):** Software Bill of Materials regenerated for the runtime artifacts (pack-engine, mcp/*, cloudflare-worker) before release. SBOM diff against the previous version flags new dependencies for CSO review.
- **Confidence tag rubric (per ADR-010):** 🟢 HIGH = pre-release audit clean + SBOM diff reviewed + CHANGELOG entry verified + no open P0/P1 in BUG_TRACKER. 🟡 MEDIUM = audit clean but SBOM has new dependencies waived without review. 🔴 LOW = open P0 OR audit blocker present (release halts).

## Behavior

1. **Pre-flight scope check** — is the operator asking for a major / minor / patch / hotfix? Confirm the version bump before any other step.
2. Read `BUG_TRACKER.md` — any open P0 or P1 blockers? If yes → halt and surface the list; release does not proceed.
3. Read `progress.md` to confirm scope completeness; partial plans block release with a 🔴 LOW tag.
4. **Parallel auto-loop fires (CSO + reviewer + CMO + COO):**
   - CSO: SBOM regeneration · secret/PII scan · regulated-data compliance · license-gate test status
   - Reviewer: final pass on any uncommitted changes; reject if quality bar not met
   - CMO documentation-writer: draft CHANGELOG entry (theme · sections · breaking changes · deferred items · upgrade path)
   - COO planner: invoke session-end 9-document closure bundle
5. **Hand off to `/mxm-release`** for the actual pre-release audit + version bump + tag. `/mxm-release` runs the 8-bucket BLOCKING audit per its own command spec — no bypass.
6. On successful release: tag, write `CHANGELOG.md` entry, run `bootstrap/sync-version.ps1`, verify all version-bearing files match.
7. **Push policy:** Push to remote ONLY if operator explicitly authorizes in this turn ("push it" / "yes push" / equivalent). Default: no push — operator pushes manually.
8. Tag output per the confidence rubric above

## Relationship to /mxm-release

`/mxm-ship` is the verb-first user surface. `/mxm-release` is the technical release-manager command. The two are sequenced: `/mxm-ship` does the coordination (CSO + reviewer + CMO + COO), then chains into `/mxm-release` which runs the 8-bucket pre-release audit and the version-bump mechanics. Power users who already coordinated manually can type `/mxm-release` directly to skip the TIER 1 frontend.

## TIER 1 surface note

Thin coordinator-frontend; the deep mechanics live in `/mxm-release` and the `release-manager` orchestrator agent. Operator types "ship v1.2.0-alpha.1" instead of remembering that release is technically a COO planner + release-manager + CSO + reviewer + CMO orchestration.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 1 surface added v1.2.0 per AGENT_ROSTER_v1.2_PROPOSAL.md._
