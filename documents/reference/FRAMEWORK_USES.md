# Maxim Framework Uses Index

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.


> **Purpose:** Companion to `documents/reference/FRAMEWORKS_MASTER.md`. Shows exactly which agents consume each framework — scannable without opening the full reference document.
>
> **Source of truth:** `documents/reference/FRAMEWORKS_MASTER.md` (full framework specs) + `config/agent-registry.json` (agent catalog)
>
> **Last updated:** 2026-03-16 | **Maintainer:** DrNabeelKhan | iSimplification.io

---

## Quick Index

| # | Framework | Category | Agent Count | Agents |
|---|---|---|---|---|
| 1 | [E-E-A-T](#1-e-e-a-t) | Search & Visibility | 5 | SEO Specialist · Article Writer · Content Creator · Brand Guardian · Authority Builder |
| 2 | [Core Web Vitals](#2-core-web-vitals) | Search & Visibility | 4 | SEO Specialist · Technical SEO Auditor · Frontend Developer · Performance Benchmarker |
| 3 | [Schema.org](#3-schemaorg) | Search & Visibility | 4 | AEO Strategist · Technical SEO Auditor · Article Writer · Documentation Writer |
| 4 | [SEO Best Practices](#4-seo-best-practices) | Search & Visibility | 5 | SEO Specialist · Article Writer · Technical SEO Auditor · Content Creator · GEO Optimizer |
| 5 | [AEO](#5-aeo) | Search & Visibility | 4 | AEO Strategist · Article Writer · SEO Specialist · Content Creator |
| 6 | [GEO](#6-geo) | Search & Visibility | 5 | GEO Optimizer · SEO Specialist · Article Writer · Authority Builder · Content Creator |
| 7 | [OWASP Top 10](#7-owasp-top-10) | Security & Compliance | 5 | Penetration Tester · Security Auditor · Ethical Hacker · Security Architect · Backend Architect |
| 8 | [NIST CSF](#8-nist-csf) | Security & Compliance | 5 | Incident Responder · Security Architect · Threat Analyst · Security Auditor · Compliance Officer |
| 9 | [ISO 27001](#9-iso-27001) | Security & Compliance | 4 | Security Auditor · Compliance Officer · Security Architect · Infrastructure Maintainer |
| 10 | [SOC 2](#10-soc-2) | Security & Compliance | 4 | Security Auditor · Compliance Officer · Infrastructure Maintainer · Legal Compliance Checker |
| 11 | [GDPR](#11-gdpr) | Security & Compliance | 5 | Compliance Officer · Legal Compliance Checker · Security Architect · Data Architect · Support Responder |
| 12 | [HIPAA](#12-hipaa) | Security & Compliance | 4 | Compliance Officer · Legal Compliance Checker · Security Architect · Infrastructure Maintainer |
| 13 | [MITRE ATT&CK](#13-mitre-attck) | Security & Compliance | 4 | Threat Analyst · Penetration Tester · Incident Responder · Security Architect |
| 14 | [Zero Trust Architecture](#14-zero-trust-architecture) | Security & Compliance | 4 | Security Architect · Infrastructure Maintainer · Security Auditor · Compliance Officer |
| 15 | [PCI-DSS](#15-pci-dss) | Security & Compliance | 4 | Security Auditor · Compliance Officer · Security Architect · Backend Architect |
| 16 | [TOGAF](#16-togaf) | Enterprise Architecture | 5 | Enterprise Architect · Solution Architect · Business Architect · Technology Architect · Governance Specialist |
| 17 | [DMBOK](#17-dmbok) | Enterprise Architecture | 4 | Data Architect · Enterprise Architect · Governance Specialist · Data Scientist |
| 18 | [Zachman Framework](#18-zachman-framework) | Enterprise Architecture | 3 | Enterprise Architect · Data Architect · Solution Architect |
| 19 | [COBIT](#19-cobit) | Enterprise Architecture | 4 | Governance Specialist · Compliance Officer · Enterprise Architect · Infrastructure Maintainer |
| 20 | [ITIL](#20-itil) | Enterprise Architecture | 4 | Infrastructure Maintainer · Support Responder · Technology Architect · Governance Specialist |
| 21 | [BIZBOK](#21-bizbok) | Enterprise Architecture | 4 | Business Architect · Enterprise Architect · Product Strategist · Market Analyst |
| 22 | [FEAF](#22-feaf) | Enterprise Architecture | 3 | Enterprise Architect · Security Architect · Compliance Officer |
| 23 | [Design Thinking](#23-design-thinking) | Product & Research | 5 | Innovation Researcher · User Researcher · UX Researcher · Product Strategist · UI Designer |
| 24 | [Lean Startup](#24-lean-startup) | Product & Research | 5 | Product Strategist · Innovation Researcher · Rapid Prototyper · Data Scientist · Experiment Tracker |
| 25 | [Agile / Scrum](#25-agile--scrum) | Product & Research | 5 | Sprint Prioritizer · Project Shipper · Experiment Tracker · Frontend Developer · Backend Architect |
| 26 | [OKRs](#26-okrs) | Product & Research | 4 | Product Strategist · Sprint Prioritizer · Analytics Reporter · Project Shipper |
| 27 | [TAM/SAM/SOM](#27-tamsamsom) | Product & Research | 4 | Market Analyst · Product Strategist · Innovation Researcher · Competitive Analyst |
| 28 | [Porter's Five Forces](#28-porters-five-forces) | Product & Research | 4 | Market Analyst · Competitive Analyst · Product Strategist · Innovation Researcher |
| 29 | [SWOT Analysis](#29-swot-analysis) | Product & Research | 4 | Competitive Analyst · Product Strategist · Market Analyst · Business Architect |
| 30 | [Nielsen Heuristics](#30-nielsen-heuristics) | Product & Research | 4 | Usability Tester · UX Researcher · UI Designer · Product Strategist |
| 31 | [AIDA](#31-aida) | Content & Marketing | 4 | Article Writer · Content Creator · Social Media Strategist · Growth Hacker |
| 32 | [Content Calendar](#32-content-calendar) | Content & Marketing | 4 | Social Media Strategist · Article Writer · Content Creator · Newsletter Writer |
| 33 | [Growth Hacking](#33-growth-hacking) | Content & Marketing | 4 | Growth Hacker · Marketing Team · Product Strategist · Analytics Reporter |
| 34 | [ASO](#34-aso) | Content & Marketing | 4 | App Store Optimizer · Content Creator · Growth Hacker · Analytics Reporter |
| 35 | [Brand Guidelines](#35-brand-guidelines) | Content & Marketing | 4 | Brand Guardian · Content Creator · UI Designer · Social Media Strategist |
| 36 | [Platform-Specific Writing](#36-platform-specific-writing) | Content & Marketing | 4 | Article Writer · Social Media Strategist · Content Creator · Video Script Writer |
| 37 | [CI/CD](#37-cicd) | Engineering & DevOps | 4 | DevOps Automator · Backend Architect · API Tester · Infrastructure Maintainer |
| 38 | [Infrastructure as Code](#38-infrastructure-as-code) | Engineering & DevOps | 4 | DevOps Automator · Infrastructure Maintainer · Security Architect · Backend Architect |
| 39 | [Microservices Architecture](#39-microservices-architecture) | Engineering & DevOps | 4 | Backend Architect · DevOps Automator · API Tester · Security Architect |
| 40 | [API Design REST/GraphQL](#40-api-design-restgraphql) | Engineering & DevOps | 4 | Backend Architect · API Tester · Documentation Writer · Frontend Developer |
| 41 | [Design Systems](#41-design-systems) | Design & UX | 4 | UI Designer · Frontend Developer · Brand Guardian · Documentation Writer |
| 42 | [User Journey Mapping](#42-user-journey-mapping) | Design & UX | 4 | UX Researcher · User Researcher · Product Strategist · UI Designer |
| 43 | [Accessibility WCAG](#43-accessibility-wcag) | Design & UX | 4 | UI Designer · Frontend Developer · UX Researcher · Compliance Officer |
| 44 | [SUS](#44-sus) | Design & UX | 3 | Usability Tester · UX Researcher · Product Strategist |
| 45 | [Atomic Design](#45-atomic-design) | Design & UX | 3 | UI Designer · Frontend Developer · Design System Lead |
| 46 | [Kanban](#46-kanban) | Project Management | 3 | Sprint Prioritizer · Project Shipper · Experiment Tracker |
| 47 | [Stage-Gate](#47-stage-gate) | Project Management | 3 | R&D Coordinator · Product Strategist · Project Shipper |
| 48 | [A/B Testing](#48-ab-testing) | Project Management | 4 | Experiment Tracker · Data Scientist · Growth Hacker · Product Strategist |
| 49 | [RACI Matrix](#49-raci-matrix) | Project Management | 3 | Project Shipper · Studio Producer · Governance Specialist |
| 50 | [Cialdini's 6 Principles](#50-cialdinis-6-principles) | Behavior Science | 6 | Persuasion Specialist · Conversion Optimizer · Influence Strategist · Content Creator · Article Writer · Growth Hacker |
| 51 | [Fogg Behavior Model](#51-fogg-behavior-model) | Behavior Science | 5 | Behavioral Designer · Habit Formation Coach · Conversion Optimizer · Product Strategist · UX Researcher |
| 52 | [Nudge Theory](#52-nudge-theory) | Behavior Science | 4 | Nudge Architect · Decision Architect · Behavioral Designer · Product Strategist |
| 53 | [Hook Model](#53-hook-model) | Behavior Science | 4 | Habit Formation Coach · Product Strategist · Growth Hacker · Behavioral Designer |
| 54 | [COM-B Model](#54-com-b-model) | Behavior Science | 4 | Behavioral Designer · Habit Formation Coach · Product Strategist · UX Researcher |
| 55 | [EAST Framework](#55-east-framework) | Behavior Science | 4 | Nudge Architect · Conversion Optimizer · Behavioral Designer · Product Strategist |
| 56 | [Cognitive Biases](#56-cognitive-biases) | Behavior Science | 5 | Decision Architect · Persuasion Specialist · Negotiation Specialist · Product Strategist · UX Researcher |
| 57 | [Jobs-to-be-Done](#57-jobs-to-be-done) | Behavior Science | 5 | Product Strategist · User Researcher · Behavioral Designer · Market Analyst · Innovation Researcher |
| 58 | [Elaboration Likelihood Model](#58-elaboration-likelihood-model) | Behavior Science | 3 | Persuasion Specialist · Content Creator · Marketing Strategist |

---

## Search & Visibility Frameworks

### 1. E-E-A-T
**Used by:** SEO Specialist · Article Writer · Content Creator · Brand Guardian · Authority Builder

### 2. Core Web Vitals
**Used by:** SEO Specialist · Technical SEO Auditor · Frontend Developer · Performance Benchmarker

### 3. Schema.org
**Used by:** AEO Strategist · Technical SEO Auditor · Article Writer · Documentation Writer

### 4. SEO Best Practices
**Used by:** SEO Specialist · Article Writer · Technical SEO Auditor · Content Creator · GEO Optimizer

### 5. AEO
**Used by:** AEO Strategist · Article Writer · SEO Specialist · Content Creator

### 6. GEO
**Used by:** GEO Optimizer · SEO Specialist · Article Writer · Authority Builder · Content Creator

---

## Security & Compliance Frameworks

### 7. OWASP Top 10
**Used by:** Penetration Tester · Security Auditor · Ethical Hacker · Security Architect · Backend Architect

### 8. NIST CSF
**Used by:** Incident Responder · Security Architect · Threat Analyst · Security Auditor · Compliance Officer

### 9. ISO 27001
**Used by:** Security Auditor · Compliance Officer · Security Architect · Infrastructure Maintainer

### 10. SOC 2
**Used by:** Security Auditor · Compliance Officer · Infrastructure Maintainer · Legal Compliance Checker

### 11. GDPR
**Used by:** Compliance Officer · Legal Compliance Checker · Security Architect · Data Architect · Support Responder

### 12. HIPAA
**Used by:** Compliance Officer · Legal Compliance Checker · Security Architect · Infrastructure Maintainer

### 13. MITRE ATT&CK
**Used by:** Threat Analyst · Penetration Tester · Incident Responder · Security Architect

### 14. Zero Trust Architecture
**Used by:** Security Architect · Infrastructure Maintainer · Security Auditor · Compliance Officer

### 15. PCI-DSS
**Used by:** Security Auditor · Compliance Officer · Security Architect · Backend Architect

---

## Enterprise Architecture Frameworks

### 16. TOGAF
**Used by:** Enterprise Architect · Solution Architect · Business Architect · Technology Architect · Governance Specialist

### 17. DMBOK
**Used by:** Data Architect · Enterprise Architect · Governance Specialist · Data Scientist

### 18. Zachman Framework
**Used by:** Enterprise Architect · Data Architect · Solution Architect

### 19. COBIT
**Used by:** Governance Specialist · Compliance Officer · Enterprise Architect · Infrastructure Maintainer

### 20. ITIL
**Used by:** Infrastructure Maintainer · Support Responder · Technology Architect · Governance Specialist

### 21. BIZBOK
**Used by:** Business Architect · Enterprise Architect · Product Strategist · Market Analyst

### 22. FEAF
**Used by:** Enterprise Architect · Security Architect · Compliance Officer

---

## Product & Research Frameworks

### 23. Design Thinking
**Used by:** Innovation Researcher · User Researcher · UX Researcher · Product Strategist · UI Designer

### 24. Lean Startup
**Used by:** Product Strategist · Innovation Researcher · Rapid Prototyper · Data Scientist · Experiment Tracker

### 25. Agile / Scrum
**Used by:** Sprint Prioritizer · Project Shipper · Experiment Tracker · Frontend Developer · Backend Architect

### 26. OKRs
**Used by:** Product Strategist · Sprint Prioritizer · Analytics Reporter · Project Shipper

### 27. TAM/SAM/SOM
**Used by:** Market Analyst · Product Strategist · Innovation Researcher · Competitive Analyst

### 28. Porter's Five Forces
**Used by:** Market Analyst · Competitive Analyst · Product Strategist · Innovation Researcher

### 29. SWOT Analysis
**Used by:** Competitive Analyst · Product Strategist · Market Analyst · Business Architect

### 30. Nielsen Heuristics
**Used by:** Usability Tester · UX Researcher · UI Designer · Product Strategist

---

## Content & Marketing Frameworks

### 31. AIDA
**Used by:** Article Writer · Content Creator · Social Media Strategist · Growth Hacker

### 32. Content Calendar
**Used by:** Social Media Strategist · Article Writer · Content Creator · Newsletter Writer

### 33. Growth Hacking
**Used by:** Growth Hacker · Marketing Team · Product Strategist · Analytics Reporter

### 34. ASO
**Used by:** App Store Optimizer · Content Creator · Growth Hacker · Analytics Reporter

### 35. Brand Guidelines
**Used by:** Brand Guardian · Content Creator · UI Designer · Social Media Strategist

### 36. Platform-Specific Writing
**Used by:** Article Writer · Social Media Strategist · Content Creator · Video Script Writer

---

## Engineering & DevOps Frameworks

### 37. CI/CD
**Used by:** DevOps Automator · Backend Architect · API Tester · Infrastructure Maintainer

### 38. Infrastructure as Code
**Used by:** DevOps Automator · Infrastructure Maintainer · Security Architect · Backend Architect

### 39. Microservices Architecture
**Used by:** Backend Architect · DevOps Automator · API Tester · Security Architect

### 40. API Design REST/GraphQL
**Used by:** Backend Architect · API Tester · Documentation Writer · Frontend Developer

---

## Design & UX Frameworks

### 41. Design Systems
**Used by:** UI Designer · Frontend Developer · Brand Guardian · Documentation Writer

### 42. User Journey Mapping
**Used by:** UX Researcher · User Researcher · Product Strategist · UI Designer

### 43. Accessibility WCAG
**Used by:** UI Designer · Frontend Developer · UX Researcher · Compliance Officer

### 44. SUS
**Used by:** Usability Tester · UX Researcher · Product Strategist

### 45. Atomic Design
**Used by:** UI Designer · Frontend Developer · Design System Lead

---

## Project Management Frameworks

### 46. Kanban
**Used by:** Sprint Prioritizer · Project Shipper · Experiment Tracker

### 47. Stage-Gate
**Used by:** R&D Coordinator · Product Strategist · Project Shipper

### 48. A/B Testing
**Used by:** Experiment Tracker · Data Scientist · Growth Hacker · Product Strategist

### 49. RACI Matrix
**Used by:** Project Shipper · Studio Producer · Governance Specialist

---

## Behavior Science & Persuasion Frameworks

### 50. Cialdini's 6 Principles
**Used by:** Persuasion Specialist · Conversion Optimizer · Influence Strategist · Content Creator · Article Writer · Growth Hacker

### 51. Fogg Behavior Model
**Used by:** Behavioral Designer · Habit Formation Coach · Conversion Optimizer · Product Strategist · UX Researcher

### 52. Nudge Theory
**Used by:** Nudge Architect · Decision Architect · Behavioral Designer · Product Strategist

### 53. Hook Model
**Used by:** Habit Formation Coach · Product Strategist · Growth Hacker · Behavioral Designer

### 54. COM-B Model
**Used by:** Behavioral Designer · Habit Formation Coach · Product Strategist · UX Researcher

### 55. EAST Framework
**Used by:** Nudge Architect · Conversion Optimizer · Behavioral Designer · Product Strategist

### 56. Cognitive Biases
**Used by:** Decision Architect · Persuasion Specialist · Negotiation Specialist · Product Strategist · UX Researcher

### 57. Jobs-to-be-Done
**Used by:** Product Strategist · User Researcher · Behavioral Designer · Market Analyst · Innovation Researcher

### 58. Elaboration Likelihood Model
**Used by:** Persuasion Specialist · Content Creator · Marketing Strategist

---

## Agent → Frameworks Reverse Index

For each agent, all frameworks they consume:

| Agent | Frameworks |
|---|---|
| AEO Strategist | AEO · Schema.org |
| Analytics Reporter | OKRs · Growth Hacking · ASO |
| API Tester | CI/CD · Microservices · API Design |
| App Store Optimizer | ASO |
| Article Writer | E-E-A-T · SEO · AEO · GEO · AIDA · Content Calendar · Platform-Specific Writing · Cialdini's 6 Principles |
| Authority Builder | E-E-A-T · GEO |
| Backend Architect | OWASP · Agile/Scrum · CI/CD · IaC · Microservices · API Design · PCI-DSS |
| Behavioral Designer | Fogg Behavior Model · Nudge Theory · Hook Model · COM-B · EAST · JTBD |
| Brand Guardian | E-E-A-T · Brand Guidelines · Design Systems |
| Business Architect | TOGAF · BIZBOK · SWOT |
| Competitive Analyst | TAM/SAM/SOM · Porter's Five Forces · SWOT |
| Compliance Officer | NIST CSF · ISO 27001 · SOC 2 · GDPR · HIPAA · Zero Trust · PCI-DSS · COBIT · FEAF · Accessibility |
| Content Creator | E-E-A-T · SEO · AEO · GEO · AIDA · Content Calendar · ASO · Brand Guidelines · Platform-Specific Writing · Cialdini's 6 Principles |
| Conversion Optimizer | Cialdini's 6 Principles · Fogg Behavior Model · EAST |
| Data Architect | GDPR · DMBOK · Zachman |
| Data Scientist | DMBOK · Lean Startup · A/B Testing |
| Decision Architect | Nudge Theory · Cognitive Biases |
| DevOps Automator | CI/CD · IaC · Microservices |
| Documentation Writer | Schema.org · API Design · Design Systems |
| Enterprise Architect | TOGAF · DMBOK · Zachman · COBIT · BIZBOK · FEAF |
| Experiment Tracker | Lean Startup · Agile/Scrum · OKRs · Kanban · A/B Testing |
| Ethical Hacker | OWASP |
| Frontend Developer | Core Web Vitals · Agile/Scrum · API Design · Design Systems · Accessibility · Atomic Design |
| GEO Optimizer | GEO · SEO |
| Governance Specialist | TOGAF · COBIT · ITIL · RACI |
| Growth Hacker | AIDA · Growth Hacking · ASO · Cialdini's 6 Principles · Hook Model · A/B Testing |
| Habit Formation Coach | Fogg Behavior Model · Hook Model · COM-B |
| Incident Responder | NIST CSF · MITRE ATT&CK |
| Influence Strategist | Cialdini's 6 Principles |
| Infrastructure Maintainer | ISO 27001 · SOC 2 · HIPAA · Zero Trust · COBIT · ITIL · CI/CD · IaC |
| Innovation Researcher | Design Thinking · Lean Startup · TAM/SAM/SOM · Porter's Five Forces · JTBD |
| Legal Compliance Checker | SOC 2 · GDPR · HIPAA |
| Market Analyst | TAM/SAM/SOM · Porter's Five Forces · SWOT · BIZBOK |
| Negotiation Specialist | Cognitive Biases |
| Newsletter Writer | Content Calendar |
| Nudge Architect | Nudge Theory · EAST |
| Penetration Tester | OWASP · MITRE ATT&CK |
| Performance Benchmarker | Core Web Vitals |
| Persuasion Specialist | Cialdini's 6 Principles · Cognitive Biases · ELM |
| Product Strategist | Design Thinking · Lean Startup · OKRs · TAM/SAM/SOM · Porter's Five Forces · SWOT · Nielsen Heuristics · Growth Hacking · Stage-Gate · A/B Testing · Fogg Behavior Model · Nudge Theory · Hook Model · COM-B · EAST · JTBD |
| Project Shipper | Agile/Scrum · OKRs · Kanban · Stage-Gate · RACI |
| R&D Coordinator | Stage-Gate |
| Rapid Prototyper | Lean Startup |
| Security Analyst | NIST CSF |
| Security Architect | OWASP · NIST CSF · ISO 27001 · GDPR · HIPAA · Zero Trust · PCI-DSS · MITRE ATT&CK · IaC · Microservices · FEAF |
| Security Auditor | OWASP · NIST CSF · ISO 27001 · SOC 2 · Zero Trust · PCI-DSS |
| SEO Specialist | E-E-A-T · Core Web Vitals · SEO · AEO · GEO |
| Social Media Strategist | AIDA · Content Calendar · Brand Guidelines · Platform-Specific Writing |
| Solution Architect | TOGAF · Zachman |
| Sprint Prioritizer | Agile/Scrum · OKRs · Kanban |
| Studio Producer | RACI |
| Support Responder | GDPR · ITIL |
| Technical SEO Auditor | Core Web Vitals · Schema.org · SEO |
| Technology Architect | TOGAF · ITIL |
| Threat Analyst | NIST CSF · MITRE ATT&CK |
| UI Designer | Design Thinking · Nielsen Heuristics · Design Systems · User Journey Mapping · Accessibility · Atomic Design · Brand Guidelines |
| UI/UX Designer (orchestrator) | Design Systems · Brand Guidelines |
| Usability Tester | Nielsen Heuristics · SUS |
| User Researcher | Design Thinking · User Journey Mapping · JTBD |
| UX Researcher | Design Thinking · Nielsen Heuristics · User Journey Mapping · Accessibility · Fogg Behavior Model · COM-B · Cognitive Biases |
| Video Script Writer | Platform-Specific Writing |
| Vulnerability Scanner | NIST CSF |

---

**See also:** [`documents/reference/FRAMEWORKS_MASTER.md`](documents/reference/FRAMEWORKS_MASTER.md) — full framework specs, key components, official docs
**See also:** [`documents/reference/SKILLS_MAP.md`](documents/reference/SKILLS_MAP.md) — skill folder × agent cross-reference
**See also:** [`config/agent-registry.json`](config/agent-registry.json) — canonical agent catalog
