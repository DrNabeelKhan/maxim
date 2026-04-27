# Maxim Pack Catalog — v1.0.0

> **Canonical sales/marketing reference for every Maxim product.**
> **Source of truth for landing page copy, sales conversations, investor decks, and support docs.**
> **Ratified by:** [ADR-009 — Pack Architecture v2](../../../adr/ADR-009-pack-architecture-v2-persona-vertical-capability.md)
> **Last updated:** 2026-04-20 (S28)
> **Status:** LOCKED for v1.0.0 launch

---

## 0. TL;DR — The 30-Second Pitch

Maxim is a **behavioral intelligence layer** for AI agents. Instead of generic prompts, every output is driven by peer-reviewed behavioral science (64 frameworks) and routed through 90 specialist agents across 7 executive offices (CEO/CTO/CMO/CSO/CPO/COO/CINO).

**Free core** = open-source (BSL 1.1) — use it forever, fork it, audit it.
**Premium packs** = the moat — 14 products across 3 layers:

- **Capability** — buy what you need ($19.99–$79.99/mo)
- **Persona** — bundle for your role ($99.99–$599.99/mo)
- **Vertical** — one-time overlay for your industry ($199.99 each)

Everything composable. Nothing locked behind enterprise sales calls.

---

## 1. Architecture at a Glance

```
                         ┌─────────────────────────┐
                         │     FREE CORE (BSL 1.1) │
                         │  90 agents · 4 watch    │
                         │  classes · 10 framework │
                         │  stubs · 59 brand tmpl  │
                         │  CEO automation · voice │
                         │  stubs · /mxm-recall   │
                         │  (silent in free)       │
                         └────────────┬────────────┘
                                      │
         ┌────────────────────────────┼────────────────────────────┐
         │                            │                            │
    LAYER 1                      LAYER 2                      LAYER 3
    CAPABILITIES                 PERSONAS                     VERTICALS
    (standalone)                 (bundles)                    (one-time)
         │                            │                            │
   6 products                   4 bundles                    4 overlays
   $19.99–$79.99/mo             $99.99–$599.99/mo            $199.99 each
         │                            │                            │
         └────────────────────────────┴────────────────────────────┘
                             14 total SKUs
```

**Key principles:**
- **Every L1 product is standalone** — buy just one, at $19.99/mo minimum
- **L2 bundles unlock savings** — 33–47% off buying L1 components individually
- **L3 verticals require base subscription** — must have ≥ $19.99/mo L1.1 (prevents "$199 forever" loophole)
- **Agency All-In includes everything** — all L1 + all L3 verticals + all future packs as released

---

## 2. Full Product Catalog (14 SKUs)

### 2.1 LAYER 1 — Capability Products (6)

These are the building blocks. Everyone starts here.

---

#### 🟢 L1.1 — AI Governance — **$19.99/mo**
**LemonSqueezy variant:** `1551385`

**One-liner:** *"Prove your AI use is responsible — for you, your team, and your auditors."*

**What it solves:**
- You need audit trails for every AI-generated decision
- EU AI Act compliance creeping into your workflow
- Executives asking "how do we know this AI output is ethical?"
- Regulated industry scrutiny on AI tooling

**What's inside:**
- `documents/governance/ETHICAL_GUIDELINES.md` automated enforcement on every output
- 🟢 HIGH / 🟡 MEDIUM / 🔴 LOW confidence tagging (every response)
- Audit trail: every AI decision timestamped + logged to `.claude-sessions-memory/`
- Decision log MCP (5 tools) — queryable by auditors
- Gated-project enforcement (refuse work on archived/gated projects)
- Super-user governance controls (when paired with L2.3 Professional OS)
- EU AI Act Article 13–15 transparency baseline

**Who it's for:**
- Any professional using AI in a regulated context
- Teams preparing for EU AI Act (effective Feb 2026)
- Entry point for buyers evaluating the Maxim ecosystem

**Upgrade trigger:**
- "I need the 13 other compliance frameworks too" → add L1.4 Compliance Shield
- "I want drift alerts on compliance gaps" → add L1.3 Proactive Watch
- "I'm ready to commit" → jump to L2.3 Professional OS

---

#### 🟢 L1.2 — MemPalace Pro — **$19.99/mo**
**LemonSqueezy variant:** `1551380`

**One-liner:** *"Never lose context across projects, sessions, or months."*

**What it solves:**
- You've explained your project 30 times to the AI
- Cross-project patterns go unnoticed because memory is siloed
- Session 10 came and went and you forgot what you learned in session 3
- Your AI "forgets" you every morning

**What's inside:**
- MemPalace knowledge graph (19 MCP tools: add drawers, query KG, timeline, traversal)
- 4 wiki skills: `wiki-ingest`, `wiki-query`, `wiki-lint`, `wiki-explore`
- Cross-session memory persistence (`.claude-sessions-memory/` + KG sync)
- TTM Stage Detection — tracks your adoption stage across sessions
- Session milestones at 10/25/50 (MemPalace, Operator Status, Certification prompts)
- `/mxm-recall` command (cross-project semantic search)
- Automatic session continuity via documents/ledgers/SESSION_CONTINUITY.md

**Who it's for:**
- Power users with ongoing projects (3+ months)
- Researchers, analysts, anyone with long-running context
- Multi-project operators (portfolio managers, agencies early-stage)

**Upgrade trigger:**
- "I need brand memory too" → bundle with L1.5 Brand & Design Pro
- "I want the persuasion layer" → bundle with L1.6 Behavioral Intelligence
- "I'm a founder" → L2.1 Founder OS includes MemPalace + Brand + Behavioral

---

#### 🟢 L1.3 — Proactive Watch — **$19.99/mo**
**LemonSqueezy variant:** `1551516`

**One-liner:** *"Catches drift before you notice it — 8 quality checkers running in the background."*

**What it solves:**
- Docs drift out of sync with code
- Skill inventory claims things that don't exist
- Compliance gaps widen silently
- Brand voice degrades across 100s of outputs

**What's inside (8 gated checker classes — free tier gets 4):**
| # | Class | What it detects |
|---|---|---|
| 5 | mcp-health | MCP servers unresponsive / degraded |
| 6 | skill-gap-accumulation | Unresolved skill gaps piling up |
| 7 | moat-drift | Moat signals weakening in outputs |
| 8 | brand-drift | Brand voice inconsistency across outputs |
| 9 | compliance-drift | Compliance coverage gaps widening |
| 10 | behavioral-framework-coverage | Skills without behavioral framing |
| 11 | external-boundary-drift | Third-party content leaking into Maxim skills |
| 12 | behavioral-moat-drift | Skills missing the 7 required behavioral-moat sections |

**Free tier gets classes 1–4** (inventory, session memory, version, changelog) — housekeeping hygiene.

**Who it's for:**
- Quality-conscious operators
- Teams with compliance burden
- Anyone whose output reputation matters (consultants, agencies)
- Individual contributors maintaining long-lived projects

**Upgrade trigger:**
- "I need the drift detection across all dimensions" → stay in L1.3
- "I'm bundling with other capabilities" → L2.1 / L2.2 / L2.3 all include L1.3

---

#### 🟢 L1.4 — Compliance Shield — **$49.99/mo**
**LemonSqueezy variant:** `1551370`

**One-liner:** *"14 regulated-industry frameworks enforced on every output."*

**What it solves:**
- You work in a regulated industry and need compliance automation
- Manual compliance review is slow and error-prone
- Frameworks proliferate faster than your team can learn them
- Audit prep used to take weeks

**What's inside:**
- Full access to all 14 compliance frameworks:
  - **Privacy:** GDPR, PIPEDA (Canada), UAE-PDPL
  - **Payment/Finance:** PCI-DSS, FINTRAC
  - **Security:** SOC2, ISO 27001, NIST CSF
  - **Healthcare:** HIPAA, ISO 13485 (medical device), ISO 14971 (risk management)
  - **AI-specific:** EU AI Act (full)
  - **Anti-Spam:** CASL
  - **Accessibility:** WCAG 2.1
- `mxm-compliance` MCP (5 tools: check_compliance, audit_data_handling, generate_ropa_entry, get_frameworks, get_jurisdiction_requirements)
- CSO office auto-loop (security-analyst notified on any security/PII/regulated task — cannot be bypassed)
- Compliance skill (full) with agent suite: security-analyst, compliance-officer, privacy-officer, auditor-agent
- Pre-commit PII/secret scanner

**Who it's for:**
- Regulated industries (healthcare, finance, govtech, legal)
- Enterprise teams preparing for SOC2/ISO audits
- SaaS companies with customers in EU/Canada/UAE
- Anyone touching payment data (PCI-DSS)

**Upgrade trigger:**
- "I need industry-specific deep dive" → add L3 vertical (Healthcare, Legal, Fintech, GovTech)
- "I'm a growth marketer handling GDPR on ad tracking" → L2.2 Growth Stack includes Compliance

---

#### 🟢 L1.5 — Brand & Design Pro — **$49.99/mo**
**LemonSqueezy variant:** `1551390`

**One-liner:** *"Your brand voice, locked. 15 cinematic styles. Design skills that don't sound AI-generated."*

**⚠️ Important:** This product is the premium design **layer on top of** the free 59 brand templates (which remain free under MIT per Q10). This product adds the Maxim-authored brand foundation system + design skills, not generic templates.

**What it solves:**
- Every piece of AI content sounds the same across brands
- AI outputs fail your brand voice review
- You have 3 startups and need 3 distinct voices
- "AI tells" give your content away in seconds

**What's inside:**
- **Brand foundation system:**
  - Personal voice profile (your writing signature)
  - Per-startup positioning + audience + compliance rules
  - AI tells banned-phrase list (scan every output)
  - Content rules engine (hard-coded brand constraints)
- **Design skills (premium):**
  - `design-system` — token-based design system generation
  - `banner-design` — social banner generation with brand-locked colors
  - `ai-media-generation` — 15 Maxim cinematic styles (cinematic, 3D-CGI, cartoon, comic-to-video, fight scenes, motion design ad, ecommerce ad, anime action, product 360, music video, social hook, brand story, fashion lookbook, food/beverage, real estate)
  - `ui-ux` — UI/UX design patterns library
  - `design-resources` — curated design asset library
- **Agents:** brand-strategist, designer, content-strategist (brand mode)

**Who it's for:**
- Founders building a brand identity
- Agencies managing multiple client brands
- Content creators with distinctive voice
- Anyone whose brand voice must survive hundreds of AI outputs

**Upgrade trigger:**
- "I also need behavioral frameworks for persuasion copy" → L2.1 Founder OS
- "I need this + all verticals" → L2.4 Agency All-In

---

#### 🟢 L1.6 — Behavioral Intelligence — **$79.99/mo** ⭐ FLAGSHIP MOAT
**LemonSqueezy variant:** `1551379`

**One-liner:** *"64 peer-reviewed behavioral frameworks applied to every output. This is the moat."*

**What it solves:**
- Your AI outputs are grammatically correct but don't persuade
- You know about Fogg/Nudge/COM-B but can't systematize applying them
- Every email/page/pitch feels generic despite good inputs
- Competitors can copy your content; they can't copy the mechanism

**What's inside:**
- Access to all 64 frameworks from [`documents/reference/FRAMEWORKS_MASTER.md`](../../../../FRAMEWORKS_MASTER.md) v5.0:
  - **Behavior change:** Fogg Behavior Model, COM-B, EAST, Transtheoretical Model, Dual Process Theory, Hook Model
  - **Motivation:** SDT, SCARF, Expectancy Theory, Maslow, Flow Theory
  - **Decision-making:** Prospect Theory, Anchoring, Availability, Endowment Effect, Loss Aversion
  - **Persuasion:** Cialdini's 7 (reciprocity, commitment, social proof, authority, liking, scarcity, unity), ELM, Yale Attitude Change
  - **Choice architecture:** Nudge Theory, EAST, BASIC, MINDSPACE
  - **+60 more frameworks across 9 categories**
- `mxm-behavioral` MCP (5 tools: recommend_frameworks, apply_framework, behavioral_audit, nudge_design, get_framework_details)
- Full persuasion system (headlines, CTAs, landing pages, email sequences)
- Nudge design skill
- Behavioral audit on demand (scan any output against applied frameworks)
- **Every Maxim skill integrates Behavioral Intelligence at a deeper level** when this pack is active (the 7-section behavioral-moat framing ADR-007 goes from "referenced" to "actively applied")

**Who it's for:**
- Marketers and growth professionals (highest ROI fit)
- Product managers designing conversion flows
- Sales teams crafting pitches
- Anyone who needs outputs to drive behavior, not just inform

**Why it's the moat:**
Any prompt library can say "write a good email." Only Maxim applies, e.g., Cialdini scarcity + Fogg prompt + Kahneman loss aversion in a measured, framework-tagged way. Competitors copying surface outputs won't reproduce the mechanism. This is why Behavioral Intelligence is the flagship at $79.99/mo — it's also the pack where the 47% bundle discounts apply (Founder + Growth both include it).

---

### 2.2 LAYER 2 — Persona Bundles (4)

Opinionated combinations saving 27–47% vs buying L1 products individually.

---

#### 🟣 L2.1 — Founder OS — **$99.99/mo**
**LemonSqueezy variant:** `1551386`

**One-liner:** *"Everything a solo founder needs — except the compliance burden you don't have yet."*

**Contents (5 of 6 L1):**
- ✅ L1.1 AI Governance
- ✅ L1.2 MemPalace Pro
- ✅ L1.3 Proactive Watch
- ❌ L1.4 Compliance Shield (not included — founders pre-regulatory scale)
- ✅ L1.5 Brand & Design Pro
- ✅ L1.6 Behavioral Intelligence

**Value math:** $19.99 × 3 + $49.99 + $79.99 = $189.95/mo → **$99.99/mo (47% off)**

**Who it's for:**
- Solo founders / early-stage teams
- Indie hackers / SaaS builders
- Anyone building a brand + pitching investors
- Pre-Series A companies without regulatory scope

**The pitch:**
> "You need to sound sharp (Behavioral), look sharp (Brand), remember what you told the AI last month (MemPalace), know your AI use is governed (Governance), and catch drift before customers do (Watch). You don't yet need 14 compliance frameworks — that comes at scale. $99.99/mo, save $69.97."

**Upgrade triggers:**
- Regulatory scope arrives → **Professional OS** (adds Compliance)
- Adds first healthcare/legal/fintech client → **buy the vertical** ($199.99 one-time)
- Agency moment → **Agency All-In**

---

#### 🟣 L2.2 — Growth Stack — **$99.99/mo**
**LemonSqueezy variant:** `1551388`

**One-liner:** *"Behavioral intelligence + compliance for paid growth at scale. Because ad platforms don't care about brand — they care about GDPR."*

**Contents (5 of 6 L1):**
- ✅ L1.1 AI Governance
- ✅ L1.2 MemPalace Pro
- ✅ L1.3 Proactive Watch
- ✅ L1.4 Compliance Shield
- ❌ L1.5 Brand & Design Pro (not included — brand systems live with creative teams, not growth)
- ✅ L1.6 Behavioral Intelligence

**Value math:** $19.99 × 3 + $49.99 + $79.99 = $189.95/mo → **$99.99/mo (47% off)**

**Who it's for:**
- Growth marketers running paid acquisition
- Performance marketing teams
- Demand gen specialists
- Anyone tracking user behavior under GDPR / CASL / CCPA

**The pitch:**
> "Behavioral frameworks make your ad copy convert (Behavioral). Compliance keeps your tracking pixels legal (Compliance). MemPalace remembers what worked last quarter (MemPalace). Proactive Watch flags compliance drift before your ad account gets banned (Watch). You don't need a brand foundation — your creative team runs that. $99.99/mo, save $69.97."

**Upgrade triggers:**
- Also need brand/design capability → **Professional OS**
- Vertical (Fintech/Healthcare) enters the ad mix → **buy the vertical**
- Agency scale → **Agency All-In**

---

#### 🟣 L2.3 — Professional OS — **$159.99/mo** ⭐ SWEET SPOT
**LemonSqueezy variant:** `1551393`

**One-liner:** *"Everything Maxim does, for one serious professional. Super-user access + voice mode included."*

**Contents (all 6 L1 + premium features):**
- ✅ All 6 Layer 1 capabilities
- ✅ Super-user mode (bypass certain governance gates when needed)
- ✅ Voice mode (`/mxm-voice` for hands-free office routing)
- ❌ Multi-tenant (Agency All-In only)
- ❌ Vertical overlays (buy separately)

**Value math:** $239.94/mo → **$159.99/mo (33% off)**

**Who it's for:**
- Senior consultants / fractional executives
- Full-stack professionals (solo founders post-scale)
- Technical power users across multiple domains
- Anyone who wanted Team Essentials ($149/mo in v1 planning)

**The pitch:**
> "Everything Maxim ships in 2026 — governance, memory, watch, compliance, brand, behavioral — plus super-user controls and voice commands. For professionals who outgrew persona-specific bundles. $159.99/mo, save $79.95."

**Upgrade triggers:**
- Managing 5+ clients → **Agency All-In** (multi-tenant unlocks)
- Adding multiple verticals → **Agency All-In** (includes all 4)

---

#### 🟣 L2.4 — Agency All-In + Future Packs — **$599.99/mo** ⭐ FORWARD-LOCKED
**LemonSqueezy variant:** `1551410`

**One-liner:** *"Everything. All 4 verticals. All future packs as they release. Multi-tenant. Forever-price-locked."*

**Contents:**
- ✅ All 6 Layer 1 capabilities
- ✅ Super-user mode
- ✅ Voice mode
- ✅ **All 4 Layer 3 verticals** (Healthcare + Legal + Fintech + GovTech) — value: $799.96 one-time
- ✅ **Multi-tenant support** (multiple .brand-foundations, multiple portfolios, multiple client workspaces)
- ✅ **All future packs as released** (DevOps & SRE v1.0.0+, Investor OS v1.0.0+, Customer Success v1.0.0+, Enterprise Governance v7.5+) — value: ~$300/mo forward
- ✅ Higher session limits
- ✅ Priority support queue

**Value math (v1.0.0 launch):**
- 6 L1: $239.94/mo
- 4 verticals amortized: $66.66/mo
- Multi-tenant + premium: priceless
- **v1.0.0 launch value: $306.60/mo + multi-tenant**

**Value math (forward-looking with future packs):**
- Add future packs at $300/mo estimated
- **Forward value: ~$632/mo for $599.99/mo fixed**

**Who it's for:**
- Digital agencies managing 5+ clients
- Consulting firms with multiple industry practice areas
- Enterprise teams centralizing AI operations
- Anyone who wants to never worry about pack upgrades

**The pitch:**
> "Every pack we've built. Every pack we will build. Every vertical we ship. Multi-tenant for your 10 clients. For serious agencies and enterprise teams. $599.99/mo, locked against future price increases."

**Upgrade triggers:**
- *None above this tier in v1.0.0.*
- v7.5+: when Enterprise Governance (Pack 6) ships, Agency All-In subscribers auto-receive it.

---

### 2.3 LAYER 3 — Vertical Overlays (4 products, one-time purchase)

One-time $199.99 each. Stack on top of any L1 or L2 subscription (requires minimum L1.1 AI Governance). **Agency All-In includes all 4** automatically.

---

#### 🟡 L3.1 — Healthcare Vertical — **$199.99 one-time**
**LemonSqueezy variant:** `1551382`

**One-liner:** *"The compliance depth of a healthcare legal team, automated."*

**What it adds on top of your subscription:**
- HIPAA deep-dive enforcement (not just the basic HIPAA in Compliance Shield — full technical safeguards checklist)
- ISO 13485 (medical device quality management)
- ISO 14971 (risk management for medical devices)
- FHIR/HL7 interoperability templates (resources, observations, medication requests)
- Clinical decision support templates
- Patient consent flow generators
- Medical terminology skill (ICD-10, SNOMED CT basics)
- PHI handling auto-escalation

**Who it's for:**
- Digital health startups (SaMD, telehealth, patient portals)
- HealthTech consultancies
- Any team touching patient data or clinical workflows

**Base requirement:** ≥ L1.1 AI Governance ($19.99/mo active subscription)
**Free with Agency All-In:** Yes

---

#### 🟡 L3.2 — Legal Vertical — **$199.99 one-time**
**LemonSqueezy variant:** `1551406`

**One-liner:** *"LegalTech compliance + ethics guardrails baked into every workflow."*

**What it adds:**
- Attorney-client privilege handling protocols
- Contract template library (NDA, MSA, SOW, employment, vendor)
- Ethics walls enforcement (conflict of interest detection)
- Conflict checking workflow
- LegalTech-specific compliance frameworks
- Court-filing format templates
- Privilege log generator

**Who it's for:**
- LegalTech startups
- Law firm innovation teams
- Compliance departments with legal adjacency
- Any AI workflow that touches legal documents

**Base requirement:** ≥ L1.1 AI Governance
**Free with Agency All-In:** Yes

---

#### 🟡 L3.3 — Fintech Vertical — **$199.99 one-time**
**LemonSqueezy variant:** `1551383`

**One-liner:** *"PCI-DSS + FINTRAC + SOX, with KYC/AML templates to match."*

**What it adds:**
- PCI-DSS deep enforcement (beyond Compliance Shield basics — full SAQ A/B/C/D guidance)
- FINTRAC (Canada) money laundering compliance
- KYC/AML workflow templates
- Open-banking (FDX) interop templates
- SOX control mapping
- Financial modeling templates (SaaS unit economics, cohort analysis)
- Transaction monitoring pattern library

**Who it's for:**
- Fintech startups (neobanks, payments, lending, wealth)
- Traditional finance AI initiatives
- Crypto exchanges / DeFi platforms with compliance scope

**Base requirement:** ≥ L1.1 AI Governance
**Free with Agency All-In:** Yes

---

#### 🟡 L3.4 — GovTech Vertical — **$199.99 one-time**
**LemonSqueezy variant:** `1551384`

**One-liner:** *"FedRAMP, NIST 800-53, Section 508 — government-grade, auditor-ready."*

**What it adds:**
- FedRAMP moderate baseline alignment
- NIST 800-53 control mapping
- Section 508 WCAG 2.1 AAA strict enforcement
- RFP response templates (federal/state/municipal)
- Procurement framework library
- FAR/DFARS clause reference
- Authority to Operate (ATO) prep templates

**Who it's for:**
- Government contractors (federal, state, municipal)
- GovTech startups (AI for public services)
- NGOs with government grant scope

**Base requirement:** ≥ L1.1 AI Governance
**Free with Agency All-In:** Yes

---

## 3. Buyer Journey Map

```
╔══════════════════════════════════════════════════════════════════╗
║                       FREE CORE (BSL 1.1)                        ║
║          Install · use · fork · audit · forever free            ║
╚══════════════════════════════════════════════════════════════════╝
                                │
                       (user needs more)
                                │
                ┌───────────────┴───────────────┐
                │                               │
       "I need just one thing"          "I know my role"
                │                               │
                ▼                               ▼
         ┌──────────────┐               ┌──────────────┐
         │   LAYER 1    │               │   LAYER 2    │
         │  $19.99–     │               │  $99.99–     │
         │  $79.99/mo   │               │  $599.99/mo  │
         └──────┬───────┘               └──────┬───────┘
                │                               │
         (outgrowing single)            (industry-specific)
                │                               │
                └───────────────┬───────────────┘
                                │
                                ▼
                       ┌──────────────┐
                       │   LAYER 3    │
                       │  $199.99     │
                       │  one-time    │
                       │  overlay     │
                       └──────────────┘
                                │
                         (agency scale)
                                │
                                ▼
                       ┌──────────────────┐
                       │  AGENCY ALL-IN   │
                       │    $599.99/mo    │
                       │  All forever.    │
                       └──────────────────┘
```

### Common paths

| Starting point | Next logical step | Why |
|---|---|---|
| Free core | L1.1 AI Governance ($19.99) | Lowest barrier — try paid |
| L1.1 | L2.1 Founder OS ($99.99) | Biggest save at 47%; covers 80% of solo founder needs |
| L2.1 Founder OS | L2.3 Professional OS (+$60/mo) | Regulatory scope arrived |
| L2.2 Growth Stack | L2.3 Professional OS (+$60/mo) | Now need brand systems |
| L2.3 Professional OS | L2.4 Agency All-In (+$440/mo) | Multi-client / vertical-heavy |
| Any L1 or L2 | Add L3 vertical ($199.99 one-time) | Industry-specific project arrived |
| L2.4 Agency All-In | (no upgrade) | Top tier; future packs auto-included |

---

## 4. Comparison Matrix

| Feature | Free | L1.1 AI Gov | L1.6 Beh Intel | Founder OS | Growth Stack | Pro OS | Agency All-In |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Price | $0 | $19.99 | $79.99 | $99.99 | $99.99 | $159.99 | $599.99 |
| 90 Maxim agents | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| CEO automation | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Executive routing | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 10 framework stubs | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 59 brand templates | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Confidence tagging | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 4 Proactive Watch (free) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Ethical guidelines + audit | ❌ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ |
| MemPalace (19 tools) | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| 8 gated Watch classes | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| 14 compliance frameworks | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |
| Brand foundation + 15 cinematic | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | ✅ |
| 64 behavioral frameworks | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Super-user mode | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Voice mode | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Multi-tenant | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| All 4 verticals included | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| All future packs | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 5. Pricing Summary Table (canonical)

### Layer 1 (subscription)
| Product | Monthly | Variant ID |
|---|---:|---|
| AI Governance | $19.99 | 1551385 |
| MemPalace Pro | $19.99 | 1551380 |
| Proactive Watch | $19.99 | 1551516 |
| Compliance Shield | $49.99 | 1551370 |
| Brand & Design Pro | $49.99 | 1551390 |
| Behavioral Intelligence | $79.99 | 1551379 |
| **Sum if bought individually** | **$239.94** | — |

### Layer 2 (subscription bundles)
| Bundle | Monthly | Discount | Variant ID |
|---|---:|---:|---|
| Founder OS | $99.99 | 47% off L1 | 1551386 |
| Growth Stack | $99.99 | 47% off L1 | 1551388 |
| Professional OS | $159.99 | 33% off L1 | 1551393 |
| Agency All-In + Future | $599.99 | see § Value | 1551410 |

### Layer 3 (one-time)
| Vertical | Price | Variant ID |
|---|---:|---|
| Healthcare | $199.99 | 1551382 |
| Legal | $199.99 | 1551406 |
| Fintech | $199.99 | 1551383 |
| GovTech | $199.99 | 1551384 |

### Future packs (roadmap — NOT for sale at v1.0.0 launch)
| Product | Target price | Planned version |
|---|---:|---|
| DevOps & SRE | ~$69/mo | v1.0.0+ |
| Investor OS | ~$99/mo | v1.0.0+ |
| Customer Success | ~$59/mo | v1.0.0+ |
| Enterprise Governance (Pack 6 reintroduced) | TBD | v7.5+ |

---

## 6. Free Tier Contract

Per [ADR-004](../../../adr/ADR-004-free-tier-spec-executable-contract.md), these features remain free forever under BSL 1.1:

- 10 framework stubs (names + descriptions; full frameworks gated to L1.6)
- CEO Automation skill (full)
- Executive office routing (all 7 offices)
- 90 Maxim agents
- 59 brand templates (MIT-locked — cannot be revoked)
- 4 Proactive Watch checker classes (inventory/session/version/changelog)
- Confidence tagging 🟢🟡🔴
- `/mxm-recall` silent absence (not in free — doesn't error, just absent)
- Ethical boundaries + compliance framework awareness (basic)
- All Maxim dispatch infrastructure
- MemPalace (local only, without KG — 4 MCP tools of 19)

**Never going behind a paywall:**
- The 90 Maxim agents
- CEO Automation
- 59 MIT templates
- 4 free Proactive Watch classes
- BSL 1.1 license (converts to Apache 2.0 after 4 years per version)

---

## 7. FAQ (sales-ready)

**Q: Can I buy Healthcare vertical alone for $199.99 and never pay monthly?**
A: No. Verticals require an active subscription (minimum L1.1 AI Governance at $19.99/mo) as base. This prevents perpetual one-time purchases and ensures continued updates to vertical content.

**Q: Why is Pack 2 Behavioral Intelligence the most expensive L1 at $79.99/mo?**
A: It's the flagship moat — 64 frameworks from peer-reviewed research, applied programmatically. No competitor ships this at any price. The 47% discount in Founder OS / Growth Stack makes it accessible for individuals.

**Q: What's the difference between Founder OS and Growth Stack — both are $99.99/mo?**
A: Contents differ. Founder OS includes Brand & Design Pro (for brand building / investor pitching). Growth Stack includes Compliance Shield (for GDPR tracking / ad platform rules). Both exclude the one the other has. Upgrade to Professional OS ($159.99) to get both.

**Q: Do I keep my subscription value if I cancel?**
A: Subscriptions stop billing at cancellation. Verticals (one-time) remain with you permanently. Agency All-In future-pack inclusions stop with cancellation.

**Q: Can I upgrade/downgrade mid-month?**
A: Yes. Prorated via LemonSqueezy. Contact support for enterprise-scale migrations.

**Q: Is there a free trial?**
A: Maxim's free core IS the trial — it's permanently free, not time-limited. You experience the 90 agents, CEO automation, confidence tagging, and 4 Proactive Watch classes before paying a cent.

**Q: Do you have enterprise / team pricing?**
A: v1.0.0 ships with Agency All-In at $599.99/mo. Enterprise-specific features (SAML/SSO, dedicated support, SOC2-audited infra) arrive with Pack 6 in v7.5+. For custom enterprise needs before v7.5, contact `https://maxim.isystematic.com/contact`.

**Q: Is there a lifetime deal?**
A: No lifetime subscription deals. Agency All-In is the closest — price-locked with all future packs included.

**Q: Can I gift / sponsor a license to someone?**
A: Yes — see the early adopter promo (300 licenses, 12-month free) for the pre-launch cohort. Post-launch, gift-purchases will be added via LemonSqueezy.

---

## 8. Positioning Snapshot (for website hero copy)

### Headline options
- *"The behavioral intelligence layer for AI agents. 64 frameworks. 90 specialists. One moat."*
- *"Your AI agents should act like professionals. Maxim makes them."*
- *"Free core. Premium moat. Transparent pricing. Every pack starts at $19.99."*

### Value prop pyramid

```
         ┌──────────────────────┐
         │   THE MOAT           │  64 behavioral frameworks,
         │   (Pack 2 / L1.6)    │  applied to every output
         └──────────┬───────────┘
                    │
         ┌──────────┴───────────┐
         │   THE INFRASTRUCTURE │  90 agents, 22 MCP tools,
         │   (free core)        │  7 executive offices
         └──────────┬───────────┘
                    │
         ┌──────────┴───────────┐
         │   THE GOVERNANCE     │  14 compliance frameworks,
         │   (L1.4 / L3)        │  industry verticals
         └──────────────────────┘
```

### Comparison one-liners (vs competition)
- *"Not just prompts. Not just agents. The behavioral science layer neither has."*
- *"Open-source core. Commercial moat. 14 products. 3 layers. Zero enterprise sales calls."*
- *"Copy our templates. You still can't copy our frameworks."*

---

## 9. Rollout Checklist (Sprint 7)

Pre-launch tasks tied to this catalog:
- [ ] Update `documents/business/pack-moat-strategy.md` to match ADR-009 (was on old 6-pack model)
- [ ] Verify all 14 LemonSqueezy products published + pricing correct
- [ ] Confirm all webhook events trigger license issuance
- [ ] Generate variant ID → pack capability mapping in Cloudflare Worker
- [ ] Update `maxim.isystematic.com` landing page hero + pricing page
- [ ] Draft pack-specific one-pagers (6 L1 + 4 L2 + 4 L3 = 14)
- [ ] Write comparison matrix for `/comparisons/`
- [ ] Update Show HN post copy to reflect persona bundles
- [ ] Update Twitter thread to reflect persona bundles
- [ ] Refresh `one-pagers/maxim-one-pager.md` master one-pager
- [ ] Review and refresh `catalogues/mxm-catalogue-v6.md`

---

## 10. Change Log

| Date | Version | Change |
|---|---|---|
| 2026-04-20 | 1.0 | Initial catalog per ADR-009 (S28) — 14 products across 3 layers |

---

*Source of truth. No pricing promises are valid unless present in this document.*
*Questions: `https://maxim.isystematic.com/contact`*
