# ADR-013 — Multi-Project Memory Inheritance

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-05-13
- **Deciders:** DrNabeelKhan
- **Related:** ADR-002 (Documents as Executable Contracts), ADR-001 (architecture baseline)

---

## Context

Maxim's session-memory protocol (`CLAUDE.d/session-memory.md`) operates on a
per-project basis: each project maintains its own `.claude-sessions-memory/` and
`.mxm-skills/` directories, and the Multi-Project Safety Rule forbids any
cross-project memory writes.

This model works correctly for standalone projects. It breaks down for two real
operator topologies that have emerged in production use:

**Topology A — Parent / child:**

```
E:\Projects\nabeelkhan\              ← parent (has project-manifest.json)
└── E:\Projects\nabeelkhan\VAZIR\    ← child (has its own project-manifest.json)
```

The parent has a manifest and its own work. When Claude opens the parent project,
there is no way to see the state of child projects without manually opening each
one. The operator must open N windows to understand the portfolio under a parent —
exactly the kind of cognitive-load task the session-memory system exists to eliminate.

**Topology B — Container / standalone:**

```
E:\Projects\ARIA\                              ← container (NO manifest — invisible)
└── E:\Projects\ARIA\aria-simplification\     ← standalone (has its own manifest)
```

`E:\Projects\ARIA\` has no manifest. It is a directory grouping, not a project.
`aria-simplification` is fully independent. The container is correctly invisible to
Claude Code's project detection — no change needed for this topology.

The current `project-manifest.json` schema has no topology field. Session-start and
session-end hooks have no parent/child awareness. The existing Multi-Project Safety Rule
correctly prevents cross-writes in both directions — but it also prevents the one
legitimate cross-write that operators need: a child appending its session summary
upward to the parent at session end.

Without this ADR, operators with parent/child layouts must manually aggregate child
project states. This defeats the portfolio-awareness intent of `/mxm-portfolio` and
imposes a Fogg B=MAP ability barrier (low Ability = no automated rollup = low
likelihood of multi-project oversight behavior).

---

## Decision

Add a `topology` block to `config/project-manifest.json` with three enumerated kinds.
Implement a lightweight upward-rollup mechanism in the session-end hook and a
parent-dashboard display in the session-start hook. Extend the bootstrap wizard to
ask for topology on new project creation.

### Schema addition to `config/project-manifest.json`

```json
"topology": {
  "kind": "standalone",
  "children": [],
  "parent": null
}
```

| Field | Values | Meaning |
|---|---|---|
| `kind` | `"standalone"` (default) | No inheritance; current behavior unchanged |
| `kind` | `"parent"` | Declares child projects; reads their handoffs at session-start |
| `kind` | `"child"` | Declares parent path; appends rollup to parent at session-end |
| `children` | Array of absolute paths | Present only when `kind == "parent"` |
| `parent` | Absolute path string or `null` | Present only when `kind == "child"` |

### Session-start protocol addition (step 11.5)

After step 11 (load session memory), before printing the session-start summary:

> **If `topology.kind == "parent"`:**
> - Iterate `topology.children`
> - For each child path, read `<child>/.claude-sessions-memory/children-rollup.md` (last line) and `<child>/.mxm-skills/agents-handoff.md` (status field)
> - Render an aggregated children block in the SESSION START output:
>   ```
>   Maxim SESSION START
>     Project   : parent-project-id
>     Root      : E:\Projects\nabeelkhan
>     ...
>     Children  :
>       vazir    🟢 READY      2026-05-13  voice pipeline + sovereign TTS
>       project2 🟡 PARTIAL    2026-05-12  auth flow in progress
>   ```
> - Fail-soft: if a child path is missing or has no memory files, show `⚪ NO DATA` and continue. Never block session start on missing child data.

### Session-end protocol addition (child rollup)

> **If `topology.kind == "child"` and `topology.parent` is a non-null path:**
> - Resolve `<parent>/.claude-sessions-memory/children-rollup.md`
> - If parent path exists, append ONE line:
>   ```
>   [YYYY-MM-DDTHH:MM:SSZ] | <project-id> | <handoff-status> | <one-line-summary>
>   ```
>   where `<handoff-status>` is read from `.mxm-skills/agents-handoff.md` and
>   `<one-line-summary>` is the last non-empty line of `.claude-sessions-memory/handoff.md`.
> - Fail-soft: if parent path does not exist, or write fails, log a single warning line to `.mxm-skills/agents-skill-gaps.log` and exit normally. Never block session end on rollup failure.

### Cross-write rule — explicit amendment to the Multi-Project Safety Rule

| Direction | Allowed |
|---|---|
| Child → `<parent>/.claude-sessions-memory/children-rollup.md` (append, upward) | ✅ **ALLOWED** — the only named exception |
| Parent → any child file | ❌ FORBIDDEN |
| Sibling → sibling | ❌ FORBIDDEN |
| Any direction not listed above | ❌ FORBIDDEN |

This amendment is consistent with the existing data-flow doctrine (project → global,
never reverse). The parent here plays the same role as `.mxm-global/` in the portfolio
model: a derived summary cache updated upward from children, never written back down.

### Bootstrap additions

`bootstrap/link-local-project.ps1` and `bootstrap/new-project-setup.sh` gain:
- A `-Topology` parameter accepting `standalone | parent | child`
- When `child`: a `-Parent` parameter accepting the absolute path to the parent project
- When `parent`: a `-Children` parameter accepting a comma-separated list of child paths
- The interactive wizard asks the topology question after the compliance question

### Container directories

Directories with no `config/project-manifest.json` (e.g., `E:\Projects\ARIA\`) remain
fully invisible to Claude Code's project detection. No change needed. The session-start
hook's 4-level manifest walk already handles this correctly.

---

## Consequences

**Easier:**
- Opening a parent project gives an immediate aggregated view of all child project handoff states — no manual navigation required
- Child projects contribute to portfolio awareness automatically at every session end — zero operator effort after initial topology declaration
- The `topology` schema block provides the field needed by Maxim Studio's project tree view (Phase 4, ADR-015) without requiring a schema change at Studio launch
- The `meta.repo_topology` field added in the 2026-05-13 scaffolding bug-fix commit is semantically related but distinct: `meta.repo_topology` describes the git topology (monorepo, standalone, junction); `topology.kind` describes the Maxim session-memory inheritance topology. Both can coexist.

**Harder:**
- Session-start hook must walk child paths — fail-soft on every missing path, permission error, or malformed file. Must never block session start regardless of child state.
- Session-end hook must resolve parent path and write to a file outside the current project. This is the only intentional cross-project write in Maxim's history. Implementation must be explicit about the fail-soft contract.
- Bootstrap wizard gains a topology question — adds ~30 seconds to the interactive setup flow.
- Operators must declare topology explicitly; Maxim does not auto-detect parent/child relationships from filesystem layout. Auto-detection would be fragile (any directory containing another project would become a parent) and would violate the principle that project identity is declared, not inferred.

**Locks us into:**
- The three-kind taxonomy (standalone / parent / child). A fourth kind (e.g., `federated`, `mirror`) requires a new ADR.
- Upward-only cross-writes. Any further exceptions to the Multi-Project Safety Rule require a new ADR explicitly naming the exception.
- The `children-rollup.md` file name and append-only format. Changing this format requires a migration path for existing parent projects.

---

## Alternatives Considered

**Alternative 1 — Portfolio MCP as the only multi-project surface (reject, keep as complement)**

The `mxm-portfolio.sync_portfolio` MCP tool already reads all project manifests under
`MXM_PROJECTS_ROOT`. This provides cross-project awareness but requires MCP
connectivity, is read-only at the project level, gives a flat view without
parent/child hierarchy, and is not available in offline sessions.

Rejected as the sole solution because: MCP connectivity is not always available;
flat portfolio view lacks the granularity of per-child handoff state; offline
sessions lose all portfolio awareness. Portfolio MCP remains complementary — the
rollup mechanism here is the local, offline-capable equivalent.

**Alternative 2 — Shared memory directory at the parent level (bidirectional)**

A shared `.claude-sessions-memory/` at the parent level that both parent and children
read and write.

Rejected because: violates the data-flow rule (project → global, never reverse).
Bidirectional writes create conflict-resolution problems when two children write
simultaneously (race condition, last-write-wins, divergence). The existing
Multi-Project Safety Rule exists specifically to prevent this class of failure.
The single upward append in this ADR is designed to be conflict-free (append-only
log format, child-specific prefix on every line).

**Alternative 3 — Separate `portfolio-manifest.json` at the parent level**

A distinct file type for federation/portfolio, separate from `project-manifest.json`.

Rejected because: increases the number of config file types operators must understand
and maintain. A `topology` block added to the existing manifest is simpler,
backward-compatible (absent `topology` field = standalone = current behavior unchanged),
and follows the schema extension pattern already established by the `status` and `meta`
blocks added in the 2026-05-13 scaffolding fix.

**Alternative 4 — Document the manual pattern; do nothing**

Accept that multi-project awareness requires manual navigation and document the correct
manual workflow in `CLAUDE.d/session-memory.md`.

Rejected because: the manual pattern (open each child project, read its handoff, mentally
aggregate) is exactly the high-friction cognitive task that Maxim's behavioral-science
layer exists to automate. Per Fogg B=MAP: Ability is low when the operator must open
N projects to understand one parent. Automating the rollup removes the Ability barrier
and makes the desired multi-project-awareness behavior more likely without requiring
additional Motivation.

---

Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
