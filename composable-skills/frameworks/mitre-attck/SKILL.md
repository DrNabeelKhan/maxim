---
skill_id: mitre-attck
name: MITRE ATT&CK
version: 2.0.0
category: security
type: framework
frameworks: []
triggers:
  - mitre att&ck
  - attack techniques
  - threat-informed defense
  - detection coverage
  - adversary emulation
collaborates_with:
  - threat-analyst
  - penetration-tester
  - incident-responder
  - security-architect
ethics_required: true
priority: high
tags: [security, framework, mitre, threat-intelligence, detection]
adr: ADR-007
created: 2026-03-14
updated: 2026-10-15
---

# MITRE ATT&CK

## Purpose
Use MITRE ATT&CK, a public knowledge base of adversary tactics and techniques based on real-world observations, to describe how attackers operate in a common language. Defenders use it to measure which attacker behaviours they can detect, to prioritise defences against the groups that target them, and to plan realistic tests. It focuses on what attackers do after they reach a target, not on the vulnerabilities they exploit.

## Frameworks & Standards
| Item | Value |
|---|---|
| Framework ID | `mitre-attck` |
| Category | Security — Threat Intelligence and Detection |
| Version | 2.0.0 |
| Owner | The MITRE Corporation |
| Matrices | Enterprise · Mobile · ICS (industrial control systems) |
| Release cadence | Updated regularly; check the current version at attack.mitre.org |
| Related MITRE projects | D3FEND (defensive techniques) · ATT&CK Navigator (visualisation) |

## Structure
- **Tactics**: the adversary's goal at a stage, the "why."
- **Techniques and sub-techniques**: how the goal is achieved.
- **Procedures**: specific ways particular groups or software have used a technique.
- **Groups, software and campaigns**: documented threat actors and tools, linked to techniques.
- **Mitigations and detections**: guidance for each technique.

**Enterprise tactics** (15 as of ATT&CK v20.0, October 2026): reconnaissance, resource development, initial access, execution, persistence, privilege escalation, stealth, defense impairment, credential access, discovery, lateral movement, collection, command and control, exfiltration, and impact. ATT&CK v19 (April 2026) retired the former "defense evasion" tactic, splitting it into stealth (which keeps TA0005) and defense impairment (TA0112). Older reports and mappings use the earlier 14-tactic list.

## Core Principles
- **Behaviour over indicators.** Techniques are harder for attackers to change than file hashes or IP addresses.
- **Threat-informed defence.** Prioritise the techniques used by groups that target your sector.
- **Coverage is about quality**, not colouring every cell of the matrix.
- **Assume breach.** Most tactics occur after initial access, so detection inside the network matters.
- **Test, don't assume.** Validate detections by emulating techniques.

## Applications & Use Cases
| Use Case | Application | Element |
|---|---|---|
| Detection coverage assessment | Map existing detections to techniques | Techniques |
| Threat prioritisation | Focus on techniques of relevant groups | Groups |
| Red and purple team planning | Emulate a group's procedures | Procedures |
| Incident analysis | Describe what happened in a shared language | Tactics, techniques |
| Security tool evaluation | Compare tools by technique coverage | Techniques |
| Threat intelligence reporting | Tag reports with technique IDs | All |

## Usage Guidelines
- **Identify the groups that target your sector** and the techniques they use.
- **Map existing detections and mitigations** to those techniques, recording confidence.
- **Prioritise gaps** by threat relevance, not by matrix completeness.
- **Validate detections** with adversary emulation or purple-team exercises.
- **Tag incidents and intelligence with technique IDs** to build a shared picture.

## Prompt Template
```
You are applying MITRE ATT&CK (Enterprise matrix; check current version).

ORGANISATION and sector: [[...]]
RELEVANT THREAT GROUPS and their techniques:
COVERAGE: technique · detection (yes / partial / no) · confidence · mitigation
PRIORITY GAPS:
VALIDATION PLAN: emulation or purple-team tests
```

## Ethical Guidelines
- **Emulate techniques only in authorised, controlled environments.**
- **Share intelligence responsibly,** protecting victims' identities.

## Testing Strategy
- Adversary emulation against prioritised techniques.
- Re-test after detection changes.

## Success Metrics
- Prioritised techniques with validated detection.
- Mean time to detect in exercises.
- Detection gaps closed per quarter.

## Collaboration Protocol
- Inbound from: `threat-analyst` · `security-architect`
- Outbound to: `penetration-tester` for emulation; `incident-responder` for response playbooks
- Cross-framework: NIST CSF Detect and Respond; SANS incident response for handling; zero trust for limiting lateral movement.

## Related Skills
- `composable-skills/frameworks/nist-cybersecurity-framework/SKILL.md` — program context
- `composable-skills/frameworks/sans-incident-response/SKILL.md` — incident handling
- `composable-skills/frameworks/zero-trust-architecture/SKILL.md` — limiting lateral movement

## Reference Materials
- The MITRE Corporation. *MITRE ATT&CK.* attack.mitre.org.
- Strom, B.E., et al. (2018). *MITRE ATT&CK: Design and Philosophy.* The MITRE Corporation.

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1. Authored 2026-10-15, replacing a generated template stub._
