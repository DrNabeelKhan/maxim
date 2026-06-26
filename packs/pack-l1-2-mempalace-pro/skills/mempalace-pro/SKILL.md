---
name: L1.2 MemPalace Pro
description: "Cross-session memory that resumes your project where you left it, not where the base voice assumes."
business_outcome: "Cross-session context preservation rate >=95% across 30+ day engagements; tracked in documents/ledgers/MOAT_TRACKER.md § MOAT-02."
primary_framework: "Cognitive Load Theory (Sweller, 1988)"
product_id: L1.2
lemonsqueezy_variant_id: 1551380
pack_tier: L1
ships_with: v1.0.0
license: proprietary
---

# L1.2 MemPalace Pro

## The Maxim Moat

Memory is not storage. Memory is retrieval at the speed of thought, scoped to the question the operator actually asked. L1.2 MemPalace Pro is the pack that makes cross-session memory a first-class capability of the agent, not an afterthought bolted onto a chat transcript.

Most AI systems treat each session as a blank slate. Context evaporates when the window closes. Knowledge accumulated over ten sessions becomes scroll-back nobody will read. Teams do not lose continuity because they forget. They lose continuity because their tools were never designed to remember.

The replication barrier is the knowledge graph itself. Every drawer, tunnel, and wing in the AAAK schema is authored against a specific retrieval question. Every session's decisions, learnings, and open loops get written to the graph at session end and loaded on demand next time. Competitors can bolt vector search onto a transcript database. They cannot reproduce the authored graph structure, the session-end write protocol, and the dispatch-level retrieval rules that compound over months of operator work. Memory is not a feature. Memory is the substrate that makes long-running projects defensible.

## Business Outcome

L1.2 MemPalace Pro applies Cognitive Load Theory (John Sweller, 1988) as the foundation for the entire pack. Memory tooling exists to reduce extraneous load and preserve germane load for reasoning the operator cannot outsource. The mechanism: MemPalace stores episodic decisions, semantic associations, and operator-stage signals across sessions; retrieval happens on demand against authored graph structure, not blind similarity. Outcome claims accumulate in the living ledger at `documents/ledgers/MOAT_TRACKER.md` § MOAT-02.

Primary metric: cross-session context preservation rate. The percentage of projects where a new session correctly resumes the prior session's state without operator re-briefing. Target post-v1.0.0: ≥95% across engagements older than 30 days. Secondary metrics: time-to-context-load in seconds from session start to full context availability (target under 5 seconds); knowledge-graph query precision (proportion of retrieved nodes rated relevant by the operator; target ≥90%); TTM stage-detection accuracy against operator self-report.

## Primary Behavioral Framework

**Framework:** Cognitive Load Theory.

**Mechanism:** working memory has finite capacity. Cognitive load falls into three categories: intrinsic (inherent task difficulty), extraneous (imposed by presentation or interface friction), and germane (genuine effort toward schema construction). Operators running long projects exhaust working memory on extraneous load (where did I put that decision? what did I tell the client last week?) and have nothing left for the germane work that actually moves the project. Every byte of context held in the tool is a byte the operator does not have to hold in their head.

**Source:** John Sweller, "Cognitive Load During Problem Solving" (1988); refined in Sweller, van Merriënboer, and Paas, *Educational Psychology Review* (1998).

**Application:** MemPalace Pro offloads extraneous load from the operator to the knowledge graph. Decisions get stored as episodic nodes with tunnels to the ADRs that ratified them. Brand drift, TTM stage shifts, and compliance checkpoints get semantic nodes with cross-session timelines. When a new session starts on an ongoing project, the session-start hook loads only the graph slice relevant to today's work. Storage serves recall. Recall serves continuity. Continuity serves the compounding advantage of a tool that remembers what the operator cannot.

**Critique:** Cognitive Load Theory measures load indirectly (performance under dual-task, self-report). Critics (de Jong, 2010) argue the three-type taxonomy is not cleanly separable in real tasks. Maxim treats CLT as directional guidance, not a metric system. The aim is "operator does not re-brief themselves," not "germane load quantified."

## Behavioral → MemPalace Translation

The five frameworks below address memory from five angles: capacity, retrieval, attention, adoption, and processing mode. Cognitive Load Theory anchors capacity. The others define what the graph does with the capacity it frees.

| Framework | Mechanism | Maxim positive | Maxim anti-pattern | Boundary |
|---|---|---|---|---|
| Cognitive Load Theory (John Sweller, 1988) | intrinsic / extraneous / germane load | KG offloads extraneous load from operator | storing everything regardless of retrieval utility | load types not cleanly separable (de Jong, 2010) |
| Spreading Activation Theory (Allan Collins & Elizabeth Loftus, 1975) | associative retrieval in semantic networks | authored tunnels between related drawers | every node connected to every other | empirical scope narrower than the 1975 generalization |
| Zeigarnik Effect (Bluma Zeigarnik, 1927) | open loops consume attention until closed | `.mxm-skills/review-queue.md` closes loops | review queue grows unbounded | effect size contested in modern replications |
| Transtheoretical Model (James Prochaska & Carlo DiClemente, 1983) | six stages of change | per-operator adoption stage tracked in KG | stage assumed rather than detected | crisp-boundary critique (Sutton, 2001) |
| Dual Process Theory (Daniel Kahneman, 2011) | System 1 retrieval / System 2 reasoning | fast graph lookup for System 1; reasoning routed to System 2 | graph returns unfiltered ambiguity to System 2 | dichotomy oversimplified (Evans, 2014) |

Where others see a memory feature, I see working-memory liberated to do the work the operator was actually hired to do. Concrete invocations follow.

**1. Cross-session semantic recall via `/mxm-recall`:**

```
$ /mxm-recall "why did we pick LemonSqueezy over Stripe for L1 packs"
  [MemPalace] drawer: decisions/payments-provider
  [MemPalace] tunnel: decisions/payments-provider → ADR-005 Layer 4
  [MemPalace] session: 2026-04-15 (sess_d91a)
  Answer: LemonSqueezy approved faster for digital goods and handles EU VAT
          without separate merchant-of-record. ADR-005 § Layer 4 cites
          reduced integration surface as tie-breaker. Tunnel to compliance
          drawer confirms GDPR handling by LS.
```

**2. Write a decision to the knowledge graph at session end (MCP call):**

```json
{
  "tool": "mcp__mempalace__mempalace_kg_add",
  "args": {
    "wing": "decisions",
    "room": "v1.0.0-sprint-3b",
    "drawer": "bug-001-fingerprint-parity",
    "content": "Fixed disk PHYSICALDRIVE0 filter + virtual-MAC exclusion + InterfaceIndex-descending sort. Parity verified.",
    "tunnels": ["ADR-005-layer-4", "commit-09e0d80", "test-fingerprint-parity"]
  }
}
```

**3. Session-start retrieval using the AAAK drawer structure:**

```yaml
# Automatic load at session start (session-start.sh hook)
session: 2026-04-21
active_project: maxim
load_slice:
  wings:
    - decisions               # recent decisions this project
    - open-loops              # Zeigarnik queue
    - operator-state          # TTM stage + personalization
  filters:
    since: 2026-03-20         # last 30 days
    relevance_min: 0.6        # spreading-activation cutoff
  budget:
    max_nodes: 120            # Cognitive-Load cap
    max_tokens: 8000
```

## Anti-Patterns

Five failures catalogued from MemPalace rollouts, documented so the retrieval edge is not silently eroded.

**1. Memory dump.** Storing everything, retrieving nothing. The graph grows; retrieval precision collapses. Cognitive Load Theory inverts: the tool becomes the extraneous load it was meant to reduce.

**2. Stale index.** The knowledge graph is not updated at session end. Retrieval returns ghosts: decisions that were reversed, people who left, projects that shipped differently than the graph remembers. Trust in the system collapses faster than it builds.

**3. Over-chunking.** Context fragmented into nodes too small to stand alone. Each retrieval returns pieces the operator must reassemble. Spreading Activation fires across fragments that do not carry enough surface to trigger the right associations.

**4. Over-linking.** Every node tunneled to every other node. Relevance signal dilutes. A query returns the whole graph; the operator scrolls through noise searching for the one relevant node.

**5. TTM assumption.** Operator adoption stage assumed rather than detected. The system treats a first-week user the same as a six-month power user. Interventions mismatch the actual stage; adoption stalls at the first contact with over-tuned copy.

## Pack Integrations

Three sibling packs deepen MemPalace Pro in specific ways. Pack L1.1 through L1.6 are the live ecosystem; no future packs referenced.

- **L1.6 Behavioral Intelligence:** per-audience framework memory across sessions. The knowledge graph stores which behavioral frameworks have fired for which audiences, so the next output composed for that audience inherits the framework history rather than starting from the default stack.
- **L1.5 Brand & Design Pro:** voice drift memory across months. MemPalace stores the operator's voice-scan results over time; drift trends surface before a reviewer notices, and the operator's `personal.local/` overlay re-calibrates with data rather than guesswork.
- **L1.3 Proactive Watch:** the `session-memory-staleness` class (drift class 2) catches knowledge-graph entries that reference deleted files, closed projects, or superseded ADRs. Memory that rots without detection is worse than no memory at all; this class prevents that.

Memory is not a feature bolted onto a session. Memory is the graph that compounds between sessions, loaded at the speed of the first thought and pruned at the cadence of the operator's real workflow.

*Team-tier operators get L1.2 MemPalace Pro inside Founder OS, Growth Stack, Professional OS, or Agency All-In at 47% off individual L1 pricing; the [pack catalog](../../../maxim/documents/business/sales-marketing/packs-catalog/mxm-pack-catalog-v1.0.0.md) has the full matrix.*

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
