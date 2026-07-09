# Maxim: Master One-Pager

**Status:** v1.3.6 ship-ready · supersedes v1.0.0 launch draft
**Format:** Print-ready single page · sales leave-behind · email attachment
**Dimensions:** Letter (8.5"×11") + A4 variants · PDF + Markdown source
**Audience:** Senior technical buyer (IT director · CTO at small/mid firm · solo founder · regulated-industry operator)

---

# Maxim
### The behavioral intelligence layer for Claude

v1.3.6 · BSL 1.1 (core) + Proprietary packs · Built in Canada · Apache 2.0 in 4 years per ADR-005

---

## What Maxim is · SCQA

**Situation.** AI-assisted work needs governance, framework grounding, and cross-session memory, not just chat. Most Claude plugins ship templates or prompts.

**Complication.** A capability list doesn't tell a buyer what they'd actually *use* on real work. Picking a tier without seeing the moat work fails Prospect Theory's loss-aversion bar.

**Question.** How does a senior operator evaluate a behavioral-intelligence layer before committing?

**Answer.** Maxim defaults to a 90-day Trial of all 14 packs. Run real work through it. By day 80 the upgrade-or-downgrade decision is anchored on capability experienced, not capability promised.

---

## What Maxim does differently

**Framework citation enforced on every output.** Per ADR-007 Behavioral Moat Framing Doctrine, every Maxim emission names the framework (Fogg · Cialdini · Prospect Theory · OWASP · NIST · 70 more). Outputs without citation get rejected pre-emit by `behavioral-overlay-orchestrator`. Structurally impossible to ship generic-LLM "looks good" copy.

**Documents as Executable Contracts (ADR-002).** Five canonical ledgers (`CHANGELOG` · `MOAT_TRACKER` · `BUG_TRACKER` · `AGENT_SKILL_INVENTORY` · `SESSION_CONTINUITY`) are read by the pre-commit hook (Claude Code CLI) as live state. Drift between claim and reality blocks commits.

**CSO auto-loop.** Security-analyst reviews every task touching regulated data. Non-bypassable. BLOCK / COMPLIANT / REMEDIATE verdicts across 14 compliance frameworks. Even super-user mode cannot disable it for regulated work.

**Proactive Watch: 13 drift classes.** Continuous drift detection at every session start (Claude Code CLI; `/mxm-watch` on demand elsewhere). Class 11 surface-claims-drift caught v1.3.2's own 87→95 MCP undercount before ship. AI-coded projects rot fast; Watch is the rot detector.

**Voice routing as agent invocation property (ADR-016 + ADR-019).** Your voice loads when a writing agent dispatches, not when you remember to invoke `/mxm-brand-voice` first. Per-operator template pattern means every operator gets locked voice across surfaces.

**Two-layer dispatch with cross-surface parity (ADR-017).** 24 dispatchable subagents + 91-agent specialist catalog via `mxm-catalog` MCP. Same routing surface on Claude Code, Desktop, Web, Cowork. The "91 agents" claim is structurally true, not aspirational.

**Autonomous Workflow Standard (ADR-022).** Unattended multi-step workflows under `mxm-orchestrator`: a budget guard hard-kills on token / tool-call / runtime / cost breach, a verification gate runs separately from generation, every run is idempotent, and dry-run is on by default. Autonomy you can let run, because it cannot run away. Paired with 14 everyday skills (benefit-first surfaces over existing depth) and the default-on router (ADR-021) that routes every prompt to the right office automatically on the Claude Code CLI.

---

## By the numbers (v1.3.8 inventory · audited 2026-06-26)

|  |  |
|---|---|
| **91** | Specialist agents across 7 executive offices · 100% Grade A bilateral DNA |
| **52** | Skills: 37 domain + 14 everyday (benefit-first) + 1 orchestrator, each with the behavioral wrapper |
| **50** | Slash commands · 7 TIER 1 verb-first · 10 TIER 2 office · 5 TIER 3 persona · 28 domain/workflow |
| **9 / 95** | MCP servers / tools · behavioral · compliance · memory · portfolio · voice · context · catalog · commands · notebooklm |
| **86** | Behavioral science frameworks (Fogg · COM-B · EAST · Hook · SCARF · Prospect Theory · 80 more) |
| **14** | Compliance frameworks (GDPR · PIPEDA · UAE-PDPL · HIPAA · PCI-DSS · SOC2 · ISO 27001/13485/14971 · NIST CSF · EU AI Act · CASL · FINTRAC · WCAG 2.1) |
| **13** | Proactive Watch drift classes (4 free at Core severity, 9 with gated severity-block at Pro+) |
| **16** | Executable hooks across session lifecycle + git hygiene + pre-commit + the default-on router |
| **22** | ADRs (18 public + 4 confidential) ratifying every architectural decision |

---

## Pricing at a glance (v1.3.0 wizard ladder)

| Path | Price | Composes | Best for |
|---|---|---|---|
| **Trial** (default) | $0 · 90 days | All 14 packs unlocked · no card · cancel anytime | Anyone evaluating |
| **Solo** | $0 forever | Core only: 91/37/48/9/95/78/14/13 | Solo operators exploring Maxim |
| **Pro** | $19.99/mo | Core + 6 L1 capability packs | Serious operators on 1-2 projects |
| **Pro + Compliance** | $39/mo | Pro + L1.4 with full 14-framework enforcement | Regulated solo founders |
| **Professional** | $99/mo | Pro + L1.5 Brand & Design Pro unlimited + priority | Senior ICs · architects · technical writers |
| **Team** | $249/mo (5 seats) | Professional × 5 + shared MemPalace KG + team audit | Founders with multi-vertical operations |
| **Enterprise** | All 14 packs | Team + 4 L3 industry packs (Healthcare · Legal · Fintech · GovTech) | Regulated industries · multi-team orgs |

**L3 industry overlays (one-time, stackable):** Healthcare $249 · Legal $199 · Fintech $199 · GovTech $149. Bundle 2: 20% off · Bundle 3+: 35% off.

Full catalog + pricing: [`maxim.isystematic.com/pricing`](https://maxim.isystematic.com/pricing) · Full pack architecture: [`documents/guides/PACKS.md`](../../guides/PACKS.md).

---

## Buyer personas (Jobs-to-be-Done)

**Solo regulated founder**: building in healthcare / fintech / legal, can't hire a compliance officer yet. *Trial → Enterprise after 60 days. L3 catches the leak before PR time.*

**Multi-client agency operator**: 10+ clients across verticals, brand drift between client projects is killing me. *Trial → Team. Per-client `.brand-foundation/startups/` overlays lock voice per client.*

**Senior IC / architect**: RFCs, ADRs, design reviews need framework citation discipline I can show a tech lead. *Trial → Professional. Every ADR cites the right framework.*

**Pre-seed → Series A founder**: doing 8 jobs, need each to surface its own framework when I'm tired. *Trial → Team. L2 Founder OS bundles pitch + GTM + competitive moat.*

**Enterprise architect**: TOGAF/C4 shop, SOC 2 / GDPR pass-through required. *Enterprise + L3 verticals. Compliance authorship, not just awareness.*

**Developer evaluating AI tooling**: want to know if this is real before I commit my workflow. *Solo (Core forever) → Pro after multi-project adoption.*

---

## The business case

**Without Maxim:** every Claude session starts cold. Compliance is manual. No framework citation. Every project independent. Generic agents. Capability claims drift across surfaces. Voice drifts across outputs.

**With Maxim:** sessions resume full context (MemPalace). Compliance automatic (14 frameworks at MCP layer). 86 frameworks applied structurally. Portfolio-wide awareness. 91 governed specialists. Drift detected before ship (13 Watch classes). Voice locked across surfaces (ADR-019 operator-writer template).

**The math:** a human chief of staff costs $200K. A compliance officer costs $150K. A behavioral scientist costs $160K. A 15-person marketing team costs $1.5M+. Maxim replaces structural layers of all of them (governed, tireless, deepening with every session) for the cost of a Claude subscription + pack licenses.

---

## Get started in 60 seconds

```bash
# Plugin marketplace install
/plugin marketplace add DrNabeelKhan/maxim
/plugin install maxim@maxim-packs

# Then the tier wizard (default · pre-selected: Trial)
bash bootstrap/install-tier-packs.sh        # Mac · Linux · WSL · Git Bash
pwsh -File bootstrap/install-tier-packs.ps1 # Windows · or PS7 cross-platform
```

The wizard pre-selects 90-day Trial. Press Enter to start. No card. Cancel anytime.

Multi-surface deployment: Claude Code (100% fidelity) · Claude Desktop (~95%) · Claude.ai Web (~85%) · Claude.ai Cowork (~85%). Desktop one-command setup: `bash bootstrap/mxm-desktop-config.sh`. Hook-enforced governance (pre-commit contracts · session-start drift scan · the default-on router) is **Claude Code CLI only**; on Desktop/Web/Cowork it degrades to advisory ([#45514](https://github.com/anthropics/claude-code/issues/45514)). Skills, commands, and MCP are cross-surface.

---

**maxim.isystematic.com** · github.com/DrNabeelKhan/maxim · [contact](https://maxim.isystematic.com/contact)

---

*Maxim Master One-Pager · v1.3.6 · 2026-06-19 · BSL 1.1 core · Proprietary packs · © 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.*