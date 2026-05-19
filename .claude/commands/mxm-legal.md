---
description: TIER 3 persona — in-house counsel, privacy lawyers, GRC, contract review. Dispatches to CSO security-analyst + compliance skill with jurisdictional logic across 14 frameworks (GDPR, PIPEDA, UAE-PDPL, HIPAA, PCI-DSS, SOC2, ISO 27001/13485/14971, NIST CSF, EU AI Act, CASL, FINTRAC, WCAG 2.1).
---

# /mxm-legal

The legal persona surface (TIER 3 added v1.2.0). For in-house counsel, privacy lawyers, contract reviewers, GRC managers, and anyone whose primary job is "make sure this product doesn't get us sued." Speaks the persona's vocabulary; routes invisibly to the right specialist agents.

## Usage

```
/mxm-legal <sub-command> <args>
```

Five sub-commands ship in v1.2.0. Each cites the framework, names the routed agent(s), and emits a concrete artifact — not a checklist.

| Sub-command | What it produces | Primary agent | Frameworks |
|---|---|---|---|
| `jurisdictional-map <data-flow>` | Per-flow framework applicability matrix | CSO `security-analyst` + `compliance` skill | GDPR · PIPEDA · UAE-PDPL · HIPAA · PCI-DSS · SOC2 · CCPA · LGPD · PIPL |
| `privacy-impact <feature>` | DPIA-style write-up — data categories · lawful basis · retention · transfer mechanism · ROPA entry | CSO + `compliance` (GDPR/PIPEDA/UAE-PDPL specialist after WS5) | GDPR Art. 35 · PIPEDA · UAE-PDPL · ISO 27001 A.6 |
| `contract-review <doc>` | Issue spotting — limitation of liability · IP assignment · indemnification · jurisdiction · DPA | Orchestrators `reviewer` + CSO (GDPR-counsel after WS5) | Standard contract terms · ISO 27001 vendor clauses |
| `vendor-dpa <vendor>` | Data Processing Addendum tailored to project compliance scope | CSO `compliance` skill | GDPR Art. 28 · UAE-PDPL · standard DPA template |
| `regulatory-map <product>` | Which laws apply to THIS product — AI Act + ISO 42001 (if AI) · SOX (if public co) · DORA (if EU fintech) · HIPAA (if PHI) · etc. | CEO `enterprise-architect` + CSO | All 14 compliance frameworks |

---

## Sub-command details

### `/mxm-legal jurisdictional-map <data-flow>`

Maps a data flow against jurisdictional frameworks. Output is a per-jurisdiction applicability table, not a generic compliance checklist.

**Input:** describe the data flow in plain English. Example: "User signs up via web form, email + name + IP go to Postgres in eu-west-1, replicated to a Snowflake warehouse in us-east-1 for analytics."

**Reads:** `config/project-manifest.json` (compliance scope) · `documents/reference/FRAMEWORKS_MASTER.md` § compliance · jurisdictional metadata in `mxm-compliance` MCP tool catalog

**Output:**
```
Jurisdictional Map — <data flow summary>
─────────────────────────────────────────
| Framework | Applies? | Why | Action |
|---|---|---|---|
| GDPR     | YES     | EU subjects in flow                       | DPIA + ROPA entry |
| PIPEDA   | DEPENDS | Only if Canadian users                    | Confirm user geography |
| UAE-PDPL | YES     | UAE replica or UAE users                  | Cross-border transfer mechanism |
| CCPA     | DEPENDS | Only if CA residents                      | Privacy notice update |
| HIPAA    | NO      | No PHI in flow                            | — |
| PCI-DSS  | NO      | No card data in flow                      | — |
| SOC2     | YES (if customer-facing service) | Trust criteria       | Add to control catalog |

CSO auto-loop: FIRED (regulated data detected)
Confidence: 🟢 HIGH (manifest-grounded) | 🟡 (assumed geography) | 🔴 (no manifest)
```

**Behavioral note:** This is the highest-fidelity output Maxim ships for legal personas. The 14 compliance frameworks aren't a marketing line — they're a routing matrix. CSO auto-loop fires on EVERY data flow with regulated signals, no bypass.

---

### `/mxm-legal privacy-impact <feature>`

DPIA-style write-up. The artifact privacy lawyers actually need (not a checklist — a document they can hand to a DPO).

**Reads:** the feature spec (file path or inline description) · GDPR Art. 35 criteria · project-manifest compliance scope

**Output structure (full DPIA template):**
```
DPIA — <feature name>
─────────────────────
1. PROCESSING DESCRIPTION
   Purpose: <why this feature exists>
   Categories of data subjects: <employees | customers | minors | etc.>
   Categories of personal data: <name | email | location | device id | etc.>
   Special categories (Art. 9): <health | biometric | political | etc. | NONE>

2. LAWFUL BASIS (Art. 6)
   Primary: <consent | contract | legitimate interest | legal obligation>
   Documented at: <link to consent flow or contract clause>

3. NECESSITY & PROPORTIONALITY
   Why this data is needed (vs. less invasive alternatives): <reasoning>

4. RISK ASSESSMENT
   Risks to data subjects: <re-identification | discrimination | fraud | etc.>
   Likelihood: low/medium/high
   Severity: low/medium/high
   Inherent risk: <product>

5. MITIGATIONS
   Technical: <encryption · pseudonymization · access control · retention limits>
   Organizational: <DPIA review cadence · DPO sign-off · training>
   Residual risk: <product after mitigations>

6. CONSULTATION
   DPO consulted: YES | NO (and why)
   Data subjects consulted: YES | NO (and why)

7. RETENTION & DELETION
   Retention period: <duration> · justification: <legal/contractual basis>
   Deletion mechanism: <how + when>

8. TRANSFER MECHANISM (if applicable)
   Destination: <country/jurisdiction>
   Mechanism: <SCC · adequacy · BCR · derogation>

9. ROPA ENTRY DRAFT
   <Pre-formatted entry for the project's Records of Processing Activities>
```

**Confidence:** 🟢 HIGH if feature spec read + compliance scope clear · 🟡 if Art. 9 special-category determination needs operator input · 🔴 if no feature spec available.

---

### `/mxm-legal contract-review <doc>`

Issue-spotting review on a contract or DPA. Pairs `reviewer` orchestrator with CSO compliance skill.

**Reads:** contract text (file path or pasted) · `documents/reference/FRAMEWORKS_MASTER.md` § compliance · prior reviewed contracts in `findings.md` if any

**Issue categories scanned:**
- Limitation of liability — cap appropriate to deal size?
- IP assignment — clear ownership · pre-existing IP carve-outs · derivative works
- Indemnification — mutual? · carve-outs for breach of compliance obligations?
- Jurisdiction & venue — appropriate for both parties' compliance exposure?
- Data Processing Addendum — Art. 28 elements present? · sub-processor list disclosed?
- Termination — for-cause grounds · transition assistance · data return/deletion
- Confidentiality — survival period · permitted disclosures
- Warranties — fitness · non-infringement · compliance with stated frameworks
- Audit rights — frequency · scope · cost allocation
- Insurance — cyber · E&O · appropriate limits

**Output:**
```
Contract Review — <doc name>
─────────────────────────────
Section-by-section findings:
  §<N>.<M> <issue category>: <one-line concern + suggested edit>
  ...

Risk summary:
  HIGH:    <count> issues (deal-blocking until resolved)
  MEDIUM:  <count> issues (negotiable, recommend redline)
  LOW:     <count> issues (informational, optional)

Recommended redlines: <bulleted list of specific markup>
Confidence: 🟢 / 🟡 / 🔴
```

---

### `/mxm-legal vendor-dpa <vendor>`

Generates a Data Processing Addendum tailored to project compliance scope. Concrete artifact — operator can hand-edit and send.

**Reads:** `config/project-manifest.json` (data categories · jurisdictions · sub-processor model) · standard DPA template · vendor metadata (if known)

**Output:** Full DPA document with placeholders filled. Sections:
- Definitions (GDPR-aligned)
- Scope & duration of processing
- Subject matter & nature
- Types of personal data & categories of subjects
- Obligations of processor (Art. 28(3) (a)-(h) checklist)
- Sub-processor approval mechanism
- International transfers (SCCs attached if applicable)
- Security measures (Annex II — TOMs)
- Data subject rights assistance
- Personal data breach notification SLA
- Audit rights
- Return/deletion at termination
- Liability allocation

Output is `🟢 HIGH` only if manifest declares jurisdictions + processor model unambiguously. Otherwise `🟡` with operator prompts for the missing pieces.

---

### `/mxm-legal regulatory-map <product>`

Which laws apply to THIS product. Layered framework reasoning that's hard to do without years of GRC experience — Maxim ships the layering as routing logic.

**Input signals:** product type, target geographies, data categories handled, industry vertical, customer segment (B2C/B2B/Gov), payment processing, AI usage, public-company status.

**Output:**
```
Regulatory Map — <product>
─────────────────────────
DATA PROTECTION:
  GDPR        APPLIES — EU users in scope
  PIPEDA      APPLIES — Canadian users in scope
  UAE-PDPL    OUT OF SCOPE — no UAE users / data residency
  CCPA        APPLIES — CA residents in scope (B2C)
  ...

AI-SPECIFIC:
  EU AI Act     APPLIES — product uses GenAI for customer-facing decisions (high-risk Art. 6)
  ISO 42001     RECOMMENDED — voluntary AI MS certification, signals maturity to enterprise buyers
  NIST AI RMF   APPLIES — US federal procurement readiness
  Constitutional AI principles  RECOMMENDED — Claude-native, brand-aligned

INDUSTRY-SPECIFIC:
  HIPAA       NOT APPLICABLE — no PHI
  PCI-DSS     APPLIES — Stripe Connect platform model, scope is SAQ-A
  SOX         NOT APPLICABLE — pre-IPO
  DORA        NOT APPLICABLE — not an EU financial entity
  HIPAA       NOT APPLICABLE — confirm if telehealth feature ships

SECURITY BASELINE:
  ISO 27001   APPLIES — enterprise customers expect ISMS
  SOC2 Type 2 APPLIES — same expectation
  NIST CSF    APPLIES — government RFP readiness
  CIS Controls RECOMMENDED — operational baseline

ACCESSIBILITY:
  WCAG 2.1 AA APPLIES — public-facing surfaces

Next steps:
  Highest priority: <2-3 frameworks to operationalize first>
  Audit cadence: <annual SOC2 · ISMS · etc.>
  Owner: <CSO or designated DPO>
```

---

## Behavioral Overlay

- **CSO auto-loop:** every legal sub-command auto-loops `security-analyst` because legal output is compliance-adjacent by definition. No bypass.
- **Framework citation requirement (per ADR-007):** every output names the framework, article number, or clause justifying each finding. "GDPR applies" without "Art. 6 lawful basis: <which>" gets rejected as 🔴 LOW.
- **Specialist routing (WS5+):** today, all legal sub-commands route through CSO `security-analyst` + `compliance` skill. After WS5 ships the 19-agent CSO expansion (gdpr-counsel · hipaa-counsel · pci-dss-qsa · iso27001-lead-auditor · soc2-auditor · pipeda-counsel · uae-pdpl-counsel · dpia-specialist · privacy-engineer), each sub-command auto-routes to the specialist matching the framework. Operator experience stays identical; specialist depth gets activated by the expanded roster.
- **Confidence tag rubric:** 🟢 HIGH = manifest grounded + framework cited + specialist routed correctly. 🟡 MEDIUM = framework cited but operator input needed for completeness. 🔴 LOW = generic legal output without framework citation.

## TIER 3 surface note

`/mxm-legal` exists because legal professionals don't think "I need the CSO office's compliance skill" — they think "I need a DPIA." TIER 3 persona commands speak the persona's vocabulary so the first 10 seconds in Maxim feel native, not architectural.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 3 persona dispatcher shipped in WS3 of v1.2.0 sprint (2026-05-19) per AGENT_ROSTER_v1.2_PROPOSAL.md § TIER 3._
