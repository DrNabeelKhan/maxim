---
description: TIER 3 persona — CISOs, AppSec engineers, GRC managers, threat modelers, AI risk practitioners. Dispatches to CSO security-analyst with triple-OWASP coverage (Top 10 + LLM Top 10 + API Top 10), STRIDE/PASTA/LINDDUN, NIST CSF, NIST AI RMF, MITRE ATLAS, SPDX/CycloneDX SBOM + AIBOM.
---

# /mxm-secure

The security persona surface (TIER 3 added v1.2.0). For CISOs, AppSec engineers, GRC managers, threat modelers, and AI-risk specialists. Maxim ships **triple-OWASP** coverage + AIBOM (EU AI Act Article 53) + NIST AI RMF + MITRE ATLAS — frameworks competitors don't ship natively.

## Usage

```
/mxm-secure <sub-command> <args>
```

Six sub-commands ship in v1.2.0. Each emits a concrete security artifact — not a checklist.

| Sub-command | What it produces | Primary agent | Frameworks |
|---|---|---|---|
| `threat-model <system>` | STRIDE / PASTA / LINDDUN threat model with mitigations | CSO `security-analyst` | STRIDE · PASTA · LINDDUN · attack trees |
| `owasp <code>` | OWASP Top 10 + OWASP LLM Top 10 + OWASP API Top 10 audit | CSO `security-analyst` + CTO `implementer` | OWASP Top 10:2021 · OWASP LLM Top 10 · OWASP API Top 10 |
| `sbom <project>` | SPDX 3.0 / CycloneDX SBOM + AIBOM for ML components | CSO `security-analyst` + CTO `dependency-auditor` | SPDX 3.0 · CycloneDX 1.5 · AIBOM (EU AI Act Art. 53) |
| `incident <event>` | NIST CSF / MITRE ATT&CK incident-response playbook | CSO `security-analyst` + COO `sre-analyst` | NIST CSF · MITRE ATT&CK · SANS IR · ISO 27035 |
| `compliance-posture` | Multi-framework dashboard: SOC2 + ISO 27001 + GDPR + PCI-DSS gap report | CSO + `mxm-compliance` MCP | All 14 Maxim compliance frameworks |
| `ai-risk <model>` | NIST AI RMF + MITRE ATLAS adversarial-ML threat matrix | CSO `security-analyst` | NIST AI RMF · MITRE ATLAS · OWASP LLM Top 10 · Constitutional AI |

---

## Sub-command details

### `/mxm-secure threat-model <system>`

Real threat model artifact, not a checklist. Uses STRIDE per-element, PASTA for risk-driven analysis, LINDDUN for privacy threats. Output is the document a security team reviews before approval.

**Reads:** system spec · data-flow diagram (or constructs one) · trust boundaries · `config/project-manifest.json → compliance.frameworks`

**Output (STRIDE primary, LINDDUN overlay for privacy):**
```
Threat Model — <system>
─────────────────────────
DATA FLOW DIAGRAM (DFD level 1):
  <Mermaid diagram with processes · data stores · external entities · trust boundaries>

THREATS (per element, STRIDE):
| Element | Spoofing | Tampering | Repudiation | Info Disclosure | DoS | Elevation |
|---|---|---|---|---|---|---|
| <process A> | T-001: <threat> · mitigation: <control> | T-002: ... | — | T-003: ... | — | T-004: ... |
| <data store B> | — | T-005: ... | T-006: ... | T-007: ... | — | — |
| ...

PRIVACY THREATS (LINDDUN):
| Element | Linkability | Identifiability | Non-repudiation | Detectability | Disclosure | Unawareness | Non-compliance |
| ...

PASTA-style RISK SCORING:
  T-001 · severity HIGH · likelihood MED · risk score 9/15 · status OPEN
  ...

MITIGATIONS PRIORITY:
  P0 (deal-blocking): <list>
  P1 (pre-launch):    <list>
  P2 (post-launch):   <list>

Confidence: 🟢 / 🟡 / 🔴
```

---

### `/mxm-secure owasp <code>`

Triple-OWASP audit. Three frameworks in one pass:
- **OWASP Top 10:2021** — broad web app vulnerabilities (injection · broken access · cryptographic failures · etc.)
- **OWASP API Top 10** — API-specific risks (broken auth · excessive data · resource consumption · etc.)
- **OWASP LLM Top 10** — LLM-specific (prompt injection · training data poisoning · model DoS · sensitive info disclosure · etc.)

**Reads:** code (file paths or directories) · OWASP framework definitions · `documents/reference/FRAMEWORKS_MASTER.md`

**Output:**
```
OWASP Triple Audit — <code scope>
─────────────────────────────────
TOP 10:2021 findings:
  A01-Broken Access Control:  <findings> · severity · file:line · fix
  A02-Cryptographic Failures: <findings> · severity · file:line · fix
  ... (all 10 categories)

API TOP 10 findings:
  API1-Broken Object Level Auth:  <findings> · severity · endpoint · fix
  API2-Broken Authentication:     <findings> · severity · endpoint · fix
  ... (all 10 categories)

LLM TOP 10 findings:
  LLM01-Prompt Injection:           <findings> · severity · model interface · fix
  LLM02-Insecure Output Handling:  <findings> · severity · output sink · fix
  ... (all 10 categories)

Cross-cutting issues: <findings that span multiple categories>
P0 fixes required: <list>
Confidence: 🟢 if code read in this turn · 🟡 if inferred · 🔴 if generic
```

---

### `/mxm-secure sbom <project>`

Generates SPDX 3.0 + CycloneDX SBOM AND AIBOM (AI Bill of Materials) for ML components. AIBOM is required by EU AI Act Article 53 for general-purpose AI models — Maxim ships this natively.

**Reads:** dependency manifests (`package.json` · `go.mod` · `pom.xml` · `Cargo.toml` · `requirements.txt`) · ML model registry · model card files

**Output:** Two artifacts:
1. `sbom.spdx.json` and `sbom.cdx.json` — standard SPDX 3.0 and CycloneDX formats for software components
2. `aibom.cdx.json` — AIBOM (CycloneDX ML extension) — model lineage · training data provenance · weights origin · evaluation datasets · known biases

Plus a delta report against the previous SBOM if one exists in `documents/security/sbom-history/`.

---

### `/mxm-secure incident <event>`

NIST CSF / MITRE ATT&CK / SANS IR-aligned incident response playbook. Operator describes the event; Maxim produces the IR plan.

**Reads:** event description · `documents/ledgers/DEBUGGING_PLAYBOOK.md` · NIST CSF Respond function · MITRE ATT&CK technique catalog

**Output:**
```
Incident Response Plan — <event>
────────────────────────────────
CLASSIFICATION:
  NIST CSF function: RESPOND (RS.RP, RS.CO, RS.AN, RS.MI, RS.IM)
  Severity: P0/P1/P2/P3 per project ladder
  MITRE ATT&CK technique (if applicable): T<NNNN> <name>

CONTAINMENT (first 1 hour):
  <steps>

ERADICATION (first 24 hours):
  <steps>

RECOVERY (first 72 hours):
  <steps>

COMMUNICATIONS:
  Internal:     <stakeholders + when + what>
  External:     <customers · regulators · law enforcement + when + what>
  Regulatory:   <GDPR 72hr · HIPAA · sector-specific> — auto-loops `compliance` skill

POST-INCIDENT:
  Blameless post-mortem template: <link to template>
  PIR (Personal Incident Review) cadence: <within N business days>
  PATTERN-NN entry for BUG_TRACKER if new failure mode
```

CSO auto-loop fires; if data breach signals present, `compliance` skill auto-loops for jurisdictional notification timelines.

---

### `/mxm-secure compliance-posture`

Multi-framework dashboard. Reads `config/project-manifest.json → compliance.frameworks` and produces gap report against each.

**Output:**
```
Compliance Posture — <project>
──────────────────────────────
| Framework | Status | Last Audit | Gaps Open | Next Action |
|---|---|---|---|---|
| SOC2 Type 2  | IN_PROGRESS | 2026-Q1 | 7 open    | Address access-review evidence |
| ISO 27001    | CERTIFIED   | 2026-02 | 0 open    | Annual surveillance audit in Q3 |
| GDPR         | OPERATIONAL | continuous | 2 open | Update ROPA · refresh DPIA |
| PCI-DSS      | SAQ-A       | 2026-01 | 1 open    | Refresh vendor attestations |
| HIPAA        | OUT_OF_SCOPE| —      | —          | — |

OVERLAP MATRIX (control reuse across frameworks):
  Access control:        SOC2 CC6 · ISO 27001 A.9 · GDPR Art. 32 · PCI-DSS Req. 7
  Encryption at rest:    SOC2 CC6 · ISO 27001 A.10 · GDPR Art. 32 · PCI-DSS Req. 3
  ...

UNADDRESSED GAPS (sorted by severity):
  P0: <gap with framework refs + remediation owner>
  ...
```

---

### `/mxm-secure ai-risk <model>`

NIST AI RMF + MITRE ATLAS adversarial-ML risk assessment. Two AI-specific frameworks Maxim ships that competitors lack.

**Reads:** model description · usage context · training data provenance · deployment surface · `documents/reference/FRAMEWORKS_MASTER.md` § AI Governance

**Output:**
```
AI Risk Assessment — <model>
────────────────────────────
NIST AI RMF (Govern · Map · Measure · Manage):
  GOVERN:   <policy gaps · accountability owners · risk tolerance statement>
  MAP:      <context · purpose · stakeholders · impact categories>
  MEASURE:  <evaluation methodology · datasets · metrics · known limitations>
  MANAGE:   <mitigation controls · monitoring · response plan>

MITRE ATLAS THREAT MATRIX:
| Tactic | Technique | Applicability | Mitigation |
|---|---|---|---|
| Reconnaissance         | AML.T0000 — Search Open ML Knowledge | Y | — |
| Initial Access         | AML.T0010 — Search Application Repos | Y | API rate limits |
| ML Model Access        | AML.T0040 — ML Model Inference API   | Y | Auth + audit |
| ML Attack Staging      | AML.T0045 — Acquire Public ML Artifacts | Y | Provenance check |
| Exfiltration           | AML.T0024 — Extract ML Model         | Y | DLP + watermarking |
| Impact                 | AML.T0048 — Erode ML Model Integrity | Y | Drift detection |
| ... (full ATLAS matrix scored)

OWASP LLM TOP 10 OVERLAY (if LLM-based):
  LLM01-Prompt Injection: <applicability + mitigation>
  ... (10 categories)

EU AI Act classification: <Prohibited | High-Risk | Limited-Risk | Minimal>
AIBOM status: <generated · not-applicable>

P0 risks: <list>
Confidence: 🟢 / 🟡 / 🔴
```

---

## Behavioral Overlay

- **Triple-OWASP is a unique offering.** Most AI tools ship OWASP Top 10. Maxim ships Top 10 + LLM Top 10 + API Top 10 in a single audit pass.
- **AIBOM (EU AI Act Art. 53):** General-purpose AI models in the EU require an AI Bill of Materials. Maxim ships AIBOM as a first-class artifact alongside SPDX/CycloneDX. Competitors don't.
- **NIST AI RMF + MITRE ATLAS:** Two AI-specific governance frameworks that enterprise procurement asks about. Maxim has both wired.
- **CSO auto-loop is non-negotiable.** Every security sub-command fires `security-analyst`. No bypass. Even `super_user.enabled = true` doesn't suppress this — security IS the governance layer.
- **Specialist routing (WS5+):** today, all sub-commands route through CSO `security-analyst` lead. After WS5 expands CSO to 19 specialists (`appsec-engineer` · `threat-modeler` · `owasp-specialist` · `sbom-analyst` · `incident-responder` · `llm-security-specialist` · `ai-risk-auditor` · `adversarial-ml-analyst` · `vulnerability-manager` · etc.), each sub-command routes to its specialist.
- **Confidence tag rubric:** 🟢 HIGH = artifact code/spec-grounded + framework cited + mitigations specific. 🟡 MEDIUM = artifact framework-grounded but generic mitigations. 🔴 LOW = generic security output without artifact-grade depth.

## TIER 3 surface note

Security pros think in artifacts (threat model · OWASP audit · SBOM · IR playbook · posture dashboard · AI risk matrix), not in office routing. `/mxm-secure` is artifact-first.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. TIER 3 persona dispatcher shipped in WS3 of v1.2.0 sprint (2026-05-19) per AGENT_ROSTER_v1.2_PROPOSAL.md § TIER 3._
