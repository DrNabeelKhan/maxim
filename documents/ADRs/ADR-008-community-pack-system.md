# ADR-008 — Community Pack System

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

- **Status:** accepted
- **Date:** 2026-04-21
- **Deciders:** DrNabeelKhan
- **Related:** ADR-009 (pack architecture)

---

## Context

Maxim ships 6 commercial L1 packs at v1.0.0 (see ADR-009 and `documents/guides/PACKS.md`). A buyer may want a capability Maxim does not ship — a vertical skill, an industry-specific overlay, an experimental framework. Three paths were considered:

- **Ship it ourselves.** Slow, doesn't scale, limits the catalog to operator-authored work.
- **Accept PRs into the core framework.** Review burden, BSL complications for outside contributors, governance overhead.
- **Community pack format.** Third parties author pack bundles that Maxim's dispatch can load at runtime, without the core framework having to absorb them.

---

## Decision

Maxim supports a **Community Pack System**. A community pack is a directory matching a documented layout (`packs/{name}/SKILL.md`, `packs/{name}/manifest.json`) that can be dropped into a Maxim install and loaded by the dispatch router. Community packs:

- Carry their own license (community packs are NOT BSL-bound; they are whatever their author licensed them as).
- Are discoverable via the `mxm-catalog` MCP (ADR-009) but not marketed by iSystematic.
- Must cite frameworks from `documents/reference/FRAMEWORKS_MASTER.md` or name their own source. They do NOT earn documents/ledgers/MOAT_TRACKER.md rows automatically — moat claims are reserved for Maxim-authored and commercial packs.
- Run with `🟡 MEDIUM` confidence by default (lower than a Maxim skill), unless they explicitly opt into `🔴 Maxim-UNENHANCED`.

The pack-engine validates a community pack's `manifest.json` structure on load; structural failures skip the pack, not the whole session.

---

## Rationale

Community packs let the catalog grow without the core framework absorbing governance cost. The confidence-tag downgrade is honest: a community pack has not been through the Maxim behavioral-moat review.

The alternative — one monolithic catalog where everything claims to be Maxim-grade — would dilute the moat (ADR-007) and expose iSystematic to claims about content it never authored.

---

## Consequences

**Easier:** third-party extension without PR review; buyer can install a single community pack for a niche need; operator retains clear authorship boundary.

**Harder:** discovering good community packs (catalog tooling is minimal at v1.0.0). Maxim's support burden on user questions about community pack behavior ("is this a Maxim bug?") is non-zero — the confidence-tag downgrade is the first-line response.

**Locks us into:** the manifest format. Changing it is a breaking change for every community pack author.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years).
