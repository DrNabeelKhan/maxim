# 🎯 Frameworks Master Reference

> Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc. SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years).

**Complete cross-reference matrix of industry frameworks — shipping and roadmap.**

| Version                     | 5.1                    |
| --------------------------- | ---------------------- |
| Frameworks shipping v1.0.0  | **64**                 |
| Frameworks total documented | 78 (64 shipped + 14 roadmap — 4 duplicated across roadmap tracks) |
| Categories                  | 9                      |
| Agents Using Frameworks     | 88 (all)               |
| New in v1.0.0               | 🆕 2 (CCPA §16, FedRAMP §23) + Proactive Watch |
| Deferred to v1.1 / v1.2     | 18 — see [FRAMEWORK_ROADMAP.md](./FRAMEWORK_ROADMAP.md) |
| Last Updated                | 2026-04-21             |

> **Reading this file:** the §N sections below document every framework, shipped and planned. Items with 🆕 that are not yet implemented as dispatchable `SKILL.md` files are marked in this header's "Deferred" row. Those remain valid reference material and can be reasoned about by specialist agents, but are not yet wired into the automated dispatch. See the [roadmap](./FRAMEWORK_ROADMAP.md) for implementation schedule.

---

## 📊 Quick Navigation

| Category                         | Shipped v1.0.0 | Roadmap | Quick Link                                        |
| -------------------------------- | -------------- | ------- | ------------------------------------------------- |
| 🔍 Search & Visibility           | 6              | —       | [Jump](#-search--visibility-frameworks)           |
| 🔐 Security & Compliance         | 17             | 🗺 7 v1.1 | [Jump](#-security--compliance-frameworks)       |
| 🏛️ Enterprise Architecture       | 8              | —       | [Jump](#-enterprise-architecture-frameworks)     |
| 📦 Product & Research            | 8              | —       | [Jump](#-product--research-frameworks)           |
| 📚 Content & Marketing           | 6              | —       | [Jump](#-content--marketing-frameworks)          |
| 💻 Engineering & DevOps          | 6              | —       | [Jump](#-engineering--devops-frameworks)         |
| 🎨 Design & UX                   | 5              | —       | [Jump](#-design--ux-frameworks)                  |
| 📋 Project Management            | 4              | —       | [Jump](#-project-management-frameworks)          |
| 🧠 Behavior Science & Persuasion | 9 + Proactive Watch | 🗺 10 v1.2 | [Jump](#-behavior-science--persuasion-frameworks)|
| **TOTAL**                        | **64**         | **18**  | |

---

## 🔍 Search & Visibility Frameworks

### 1. E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness)

| Attribute         | Details                                                                                                                                                   |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Owner**         | Google Search Quality                                                                                                                                     |
| **Purpose**       | Content quality evaluation framework for search rankings                                                                                                  |
| **Official Docs** | [Google Search Quality Evaluator Guidelines](https://static.googleusercontent.com/media/guidelines.raterhub.com/en//searchqualityevaluatorguidelines.pdf) |
| **Maturity**      | Established (2014, updated 2022 with Experience)                                                                                                          |

#### Key Components

| Component             | Description                       | How to Optimize                                  |
| --------------------- | --------------------------------- | ------------------------------------------------ |
| **Experience**        | First-hand use of product/service | Add author bios, case studies, user testimonials |
| **Expertise**         | Knowledge and skill in topic      | Show credentials, certifications, portfolio      |
| **Authoritativeness** | Reputation in the field           | Build backlinks, mentions, industry recognition  |
| **Trustworthiness**   | Reliability and accuracy          | HTTPS, clear contact info, transparent policies  |

#### Agents Using This Framework

| Agent             | Application                         |
| ----------------- | ----------------------------------- |
| SEO Specialist    | Content optimization for rankings   |
| Article Writer    | Creating E-E-A-T signals in content |
| Content Creator   | Building authority through content  |
| Brand Guardian    | Maintaining trust signals           |
| Authority Builder | Developing authoritativeness        |

#### Related Frameworks

- Google Search Central Guidelines
- Core Web Vitals
- Schema.org

---

### 2. Core Web Vitals

| Attribute         | Details                                      |
| ----------------- | -------------------------------------------- |
| **Owner**         | Google                                       |
| **Purpose**       | User experience metrics for page performance |
| **Official Docs** | [web.dev/vitals](https://web.dev/vitals/)    |
| **Maturity**      | Established (2020)                           |

#### Key Metrics

| Metric  | Full Name                 | Good Threshold | Measurement            |
| ------- | ------------------------- | -------------- | ---------------------- |
| **LCP** | Largest Contentful Paint  | < 2.5s         | Loading performance    |
| **FID** | First Input Delay         | < 100ms        | Interactivity          |
| **CLS** | Cumulative Layout Shift   | < 0.1          | Visual stability       |
| **INP** | Interaction to Next Paint | < 200ms        | Responsiveness (2024+) |

#### Agents Using This Framework

| Agent                   | Application                  |
| ----------------------- | ---------------------------- |
| SEO Specialist          | Page experience optimization |
| Technical SEO Auditor   | Performance audits           |
| Frontend Developer      | Code optimization            |
| Performance Benchmarker | Testing and monitoring       |

---

### 3. Schema.org (Structured Data)

| Attribute         | Details                                                |
| ----------------- | ------------------------------------------------------ |
| **Owner**         | Schema.org Consortium (Google, Bing, Yahoo, Yandex)    |
| **Purpose**       | Standardized structured data markup for search engines |
| **Official Docs** | [schema.org](https://schema.org/)                      |
| **Maturity**      | Established (2011)                                     |

#### Common Types

| Type         | Use Case                   | Example                     |
| ------------ | -------------------------- | --------------------------- |
| Article      | Blog posts, news articles  | BlogPosting, NewsArticle    |
| Organization | Company information        | Organization, LocalBusiness |
| Product      | E-commerce products        | Product, Offer              |
| FAQ          | Frequently asked questions | FAQPage                     |
| HowTo        | Step-by-step instructions  | HowTo                       |
| Person       | Author profiles            | Person                      |

#### Agents Using This Framework

| Agent                 | Application                   |
| --------------------- | ----------------------------- |
| AEO Strategist        | Featured snippet optimization |
| Technical SEO Auditor | Markup validation             |
| Article Writer        | Content structuring           |
| Documentation Writer  | API documentation markup      |

---

### 4. SEO (Search Engine Optimization)

| Attribute         | Details                                                       |
| ----------------- | ------------------------------------------------------------- |
| **Owner**         | Industry Standard                                             |
| **Purpose**       | Improve organic search visibility                             |
| **Official Docs** | [Google Search Central](https://developers.google.com/search) |
| **Maturity**      | Established (1990s)                                           |

#### Key Pillars

| Pillar            | Components                                              |
| ----------------- | ------------------------------------------------------- |
| **Technical SEO** | Crawlability, indexing, site speed, mobile-friendliness |
| **On-Page SEO**   | Content, keywords, meta tags, headers, internal linking |
| **Off-Page SEO**  | Backlinks, brand mentions, social signals               |
| **Local SEO**     | Google Business Profile, local citations, reviews       |
| **Content SEO**   | Quality, relevance, freshness, comprehensiveness        |

#### Agents Using This Framework

| Agent                 | Application               |
| --------------------- | ------------------------- |
| SEO Specialist        | Primary framework         |
| Article Writer        | Content optimization      |
| Technical SEO Auditor | Technical audits          |
| Content Creator       | Multi-format optimization |
| GEO Optimizer         | AI search alignment       |

---

### 5. AEO (Answer Engine Optimization)

| Attribute         | Details                                                                                                |
| ----------------- | ------------------------------------------------------------------------------------------------------ |
| **Owner**         | Industry Standard (Emerging)                                                                           |
| **Purpose**       | Optimize for voice search and direct answers                                                           |
| **Official Docs** | [Featured Snippets Guidelines](https://developers.google.com/search/documents/appearance/featured-snippets) |
| **Maturity**      | Emerging (2018+)                                                                                       |

#### Optimization Strategies

| Strategy               | Implementation                                    |
| ---------------------- | ------------------------------------------------- |
| Question-Based Content | Target "who, what, when, where, why, how" queries |
| Concise Answers        | Provide 40-60 word direct answers                 |
| Structured Format      | Use lists, tables, step-by-step instructions      |
| Voice Search           | Optimize for natural language queries             |
| Featured Snippets      | Target position zero in search results            |

#### Agents Using This Framework

| Agent           | Application                |
| --------------- | -------------------------- |
| AEO Strategist  | Primary framework          |
| Article Writer  | Question-based content     |
| SEO Specialist  | Integrated search strategy |
| Content Creator | Multi-format answers       |

---

### 6. GEO (Generative Engine Optimization)

| Attribute         | Details                                                                           |
| ----------------- | --------------------------------------------------------------------------------- |
| **Owner**         | Industry Standard (Emerging)                                                      |
| **Purpose**       | Optimize for AI-generated search results                                          |
| **Official Docs** | [Research Papers](https://arxiv.org/search/?query=generative+engine+optimization) |
| **Maturity**      | Emerging (2023+)                                                                  |

#### Optimization Strategies

| Strategy              | Implementation                              |
| --------------------- | ------------------------------------------- |
| Brand Citations       | Build mentions across authoritative sources |
| Entity Optimization   | Optimize for knowledge graph inclusion      |
| Content Structure     | Clear formatting for AI extraction          |
| Authority Signals     | E-E-A-T, backlinks, expert contributions    |
| AI Overview Targeting | Structure content for AI summary inclusion  |

#### Agents Using This Framework

| Agent             | Application                 |
| ----------------- | --------------------------- |
| GEO Optimizer     | Primary framework           |
| SEO Specialist    | Integrated search strategy  |
| Article Writer    | AI-friendly content         |
| Authority Builder | Citation building           |
| Content Creator   | Multi-platform optimization |

---

## 🔐 Security & Compliance Frameworks

### 7. OWASP Top 10

| Attribute         | Details                                                                 |
| ----------------- | ----------------------------------------------------------------------- |
| **Owner**         | OWASP Foundation                                                        |
| **Purpose**       | Web application security risks                                          |
| **Official Docs** | [owasp.org/www-project-top-ten](https://owasp.org/www-project-top-ten/) |
| **Maturity**      | Established (2003, updated 2021)                                        |

#### Top 10 Risks (2021)

| Rank | Risk                      | Description                           |
| ---- | ------------------------- | ------------------------------------- |
| A01  | Broken Access Control     | Restrictions not properly enforced    |
| A02  | Cryptographic Failures    | Sensitive data exposure               |
| A03  | Injection                 | SQL, NoSQL, OS, LDAP injection        |
| A04  | Insecure Design           | Design flaws and missing controls     |
| A05  | Security Misconfiguration | Default configs, unused features      |
| A06  | Vulnerable Components     | Known vulnerabilities in dependencies |
| A07  | Authentication Failures   | Weak credentials, session management  |
| A08  | Software & Data Integrity | CI/CD, updates without verification   |
| A09  | Security Logging Failures | Insufficient logging and monitoring   |
| A10  | SSRF                      | Server-side request forgery           |

#### Agents Using This Framework

| Agent              | Application               |
| ------------------ | ------------------------- |
| Penetration Tester | Primary testing framework |
| Security Auditor   | Audit checklist           |
| Ethical Hacker     | Exploitation testing      |
| Security Architect | Secure design patterns    |
| Backend Architect  | Secure API design         |

---

### 8. NIST Cybersecurity Framework (CSF)

| Attribute         | Details                                                        |
| ----------------- | -------------------------------------------------------------- |
| **Owner**         | NIST (National Institute of Standards and Technology)          |
| **Purpose**       | Cybersecurity risk management                                  |
| **Official Docs** | [nist.gov/cyberframework](https://www.nist.gov/cyberframework) |
| **Maturity**      | Established (2014, updated 2018, 2024)                         |

#### Core Functions

| Function     | Description                          |
| ------------ | ------------------------------------ |
| **Identify** | Understand cybersecurity risk        |
| **Protect**  | Implement safeguards                 |
| **Detect**   | Identify cybersecurity events        |
| **Respond**  | Take action on detected events       |
| **Recover**  | Restore capabilities after incidents |

#### Agents Using This Framework

| Agent              | Application                  |
| ------------------ | ---------------------------- |
| Incident Responder | Response and recovery        |
| Security Architect | Protection design            |
| Threat Analyst     | Detection and identification |
| Security Auditor   | Compliance assessment        |
| Compliance Officer | Regulatory alignment         |

---

### 9. ISO 27001

| Attribute         | Details                                                      |
| ----------------- | ------------------------------------------------------------ |
| **Owner**         | ISO/IEC                                                      |
| **Purpose**       | Information security management system (ISMS)                |
| **Official Docs** | [iso.org/standard/27001](https://www.iso.org/standard/27001) |
| **Maturity**      | Established (2005, updated 2013, 2022)                       |

#### Key Controls (Annex A)

| Domain         | Controls                                 |
| -------------- | ---------------------------------------- |
| Organizational | Policies, roles, responsibilities        |
| People         | Training, awareness, disciplinary        |
| Physical       | Secure areas, equipment security         |
| Technological  | Access control, cryptography, operations |

#### Agents Using This Framework

| Agent                     | Application            |
| ------------------------- | ---------------------- |
| Security Auditor          | Certification audits   |
| Compliance Officer        | Compliance management  |
| Security Architect        | Control implementation |
| Infrastructure Maintainer | Technical controls     |

---

### 10. SOC 2

| Attribute         | Details                                         |
| ----------------- | ----------------------------------------------- |
| **Owner**         | AICPA                                           |
| **Purpose**       | Service organization controls for data security |
| **Official Docs** | [aicpa.org](https://www.aicpa.org/)             |
| **Maturity**      | Established (2010)                              |

#### Trust Service Criteria

| Criteria                 | Description                             |
| ------------------------ | --------------------------------------- |
| **Security**             | Protection against unauthorized access  |
| **Availability**         | System availability for operation       |
| **Processing Integrity** | Complete, accurate, timely processing   |
| **Confidentiality**      | Protection of confidential information  |
| **Privacy**              | Personal information collection and use |

#### Agents Using This Framework

| Agent                     | Application            |
| ------------------------- | ---------------------- |
| Security Auditor          | SOC 2 audits           |
| Compliance Officer        | Compliance management  |
| Infrastructure Maintainer | Control implementation |
| Legal Compliance Checker  | Privacy requirements   |

---

### 11. GDPR (General Data Protection Regulation)

| Attribute         | Details                                |
| ----------------- | -------------------------------------- |
| **Owner**         | European Union                         |
| **Purpose**       | Data protection and privacy regulation |
| **Official Docs** | [gdpr.eu](https://gdpr.eu/)            |
| **Maturity**      | Established (2018)                     |

#### Key Principles

| Principle                          | Description                         |
| ---------------------------------- | ----------------------------------- |
| Lawfulness, Fairness, Transparency | Clear legal basis for processing    |
| Purpose Limitation                 | Collect for specified purposes only |
| Data Minimization                  | Only necessary data                 |
| Accuracy                           | Keep data accurate and up-to-date   |
| Storage Limitation                 | Retain only as long as needed       |
| Integrity & Confidentiality        | Secure processing                   |
| Accountability                     | Demonstrate compliance              |

#### Agents Using This Framework

| Agent                    | Application           |
| ------------------------ | --------------------- |
| Compliance Officer       | Primary compliance    |
| Legal Compliance Checker | Regulatory review     |
| Security Architect       | Privacy by design     |
| Data Architect           | Data governance       |
| Support Responder        | Data subject requests |

---

### 12. HIPAA

| Attribute         | Details                                     |
| ----------------- | ------------------------------------------- |
| **Owner**         | U.S. Department of Health & Human Services  |
| **Purpose**       | Healthcare data protection                  |
| **Official Docs** | [hhs.gov/hipaa](https://www.hhs.gov/hipaa/) |
| **Maturity**      | Established (1996, updated 2013)            |

#### Key Rules

| Rule                | Description                        |
| ------------------- | ---------------------------------- |
| Privacy Rule        | Protected health information (PHI) |
| Security Rule       | Electronic PHI safeguards          |
| Breach Notification | Required breach reporting          |
| Enforcement Rule    | Violation penalties                |

#### Agents Using This Framework

| Agent                     | Application           |
| ------------------------- | --------------------- |
| Compliance Officer        | Healthcare compliance |
| Legal Compliance Checker  | Regulatory review     |
| Security Architect        | PHI protection        |
| Infrastructure Maintainer | Technical safeguards  |

---

### 13. MITRE ATT&CK

| Attribute         | Details                                         |
| ----------------- | ----------------------------------------------- |
| **Owner**         | MITRE Corporation                               |
| **Purpose**       | Adversary tactics and techniques knowledge base |
| **Official Docs** | [attack.mitre.org](https://attack.mitre.org/)   |
| **Maturity**      | Established (2015)                              |

#### Matrix Categories

| Category             | Description                            |
| -------------------- | -------------------------------------- |
| Reconnaissance       | Information gathering before attack    |
| Resource Development | Establishing infrastructure            |
| Initial Access       | Getting into the network               |
| Execution            | Running malicious code                 |
| Persistence          | Maintaining access                     |
| Privilege Escalation | Gaining higher permissions             |
| Defense Evasion      | Avoiding detection                     |
| Credential Access    | Stealing credentials                   |
| Discovery            | Learning about the environment         |
| Lateral Movement     | Moving through the network             |
| Collection           | Gathering data of interest             |
| Command & Control    | Communicating with compromised systems |
| Exfiltration         | Stealing data                          |
| Impact               | Manipulating or destroying data        |

#### Agents Using This Framework

| Agent              | Application                 |
| ------------------ | --------------------------- |
| Threat Analyst     | Threat intelligence mapping |
| Penetration Tester | Attack simulation           |
| Incident Responder | Incident classification     |
| Security Architect | Defensive controls          |

---

### 14. Zero Trust Architecture

| Attribute         | Details                                                                       |
| ----------------- | ----------------------------------------------------------------------------- |
| **Owner**         | NIST / Industry Standard                                                      |
| **Purpose**       | Security model assuming no implicit trust                                     |
| **Official Docs** | [NIST SP 800-207](https://csrc.nist.gov/publications/detail/sp/800-207/final) |
| **Maturity**      | Established (2020)                                                            |

#### Core Principles

| Principle              | Description                                  |
| ---------------------- | -------------------------------------------- |
| Verify Explicitly      | Authenticate and authorize based on all data |
| Least Privilege Access | Limit user access with JIT/JEA               |
| Assume Breach          | Minimize blast radius, segment access        |

#### Agents Using This Framework

| Agent                     | Application          |
| ------------------------- | -------------------- |
| Security Architect        | Architecture design  |
| Infrastructure Maintainer | Implementation       |
| Security Auditor          | Verification         |
| Compliance Officer        | Compliance alignment |

---

### 15. PCI-DSS

| Attribute         | Details                                                           |
| ----------------- | ----------------------------------------------------------------- |
| **Owner**         | PCI Security Standards Council                                    |
| **Purpose**       | Payment card data security                                        |
| **Official Docs** | [pcisecuritystandards.org](https://www.pcisecuritystandards.org/) |
| **Maturity**      | Established (2004, updated 2022 v4.0)                             |

#### Requirements (v4.0)

| Requirement | Description                                    |
| ----------- | ---------------------------------------------- |
| 1           | Install and maintain network security controls |
| 2           | Apply secure configurations                    |
| 3           | Protect stored account data                    |
| 4           | Protect cardholder data with encryption        |
| 5           | Protect against malware                        |
| 6           | Develop and maintain secure systems            |
| 7           | Restrict access on need-to-know basis          |
| 8           | Identify users and authenticate access         |
| 9           | Restrict physical access                       |
| 10          | Log and monitor access                         |
| 11          | Test security regularly                        |
| 12          | Support information security with policies     |

#### Agents Using This Framework

| Agent              | Application           |
| ------------------ | --------------------- |
| Security Auditor   | PCI audits            |
| Compliance Officer | Compliance management |
| Security Architect | Secure payment design |
| Backend Architect  | Secure API design     |

---


### 🆕 16. CCPA / CPRA (California Consumer Privacy Act / Rights Act)

| Attribute         | Details                                                                       |
| ----------------- | ----------------------------------------------------------------------------- |
| **Owner**         | State of California / California Privacy Protection Agency (CPPA)             |
| **Purpose**       | Consumer privacy rights and data protection for California residents          |
| **Official Docs** | [oag.ca.gov/privacy/ccpa](https://oag.ca.gov/privacy/ccpa)                   |
| **Maturity**      | Established (CCPA 2020, CPRA 2023)                                            |

#### Key Rights

| Right                          | Description                                              |
| ------------------------------ | -------------------------------------------------------- |
| **Right to Know**              | What personal data is collected and how it's used        |
| **Right to Delete**            | Request deletion of personal information                 |
| **Right to Opt-Out**           | Opt out of sale or sharing of personal data              |
| **Right to Correct**           | Correct inaccurate personal information                  |
| **Right to Limit Use**         | Limit use of sensitive personal information              |
| **Right to Non-Discrimination**| Cannot be penalized for exercising privacy rights        |

#### Agents Using This Framework

| Agent                    | Application                  |
| ------------------------ | ---------------------------- |
| Compliance Officer       | US privacy compliance        |
| Legal Compliance Checker | Regulatory review            |
| Data Architect           | Data classification          |
| Security Architect       | Privacy by design            |
| Support Responder        | Consumer rights requests     |

---

### 🆕 17. EU AI Act

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | European Union                                                                  |
| **Purpose**       | Risk-based regulation of artificial intelligence systems                        |
| **Official Docs** | [artificialintelligenceact.eu](https://artificialintelligenceact.eu/)           |
| **Maturity**      | Active (2024, enforcement phased through 2026–2027)                             |

#### Risk Classification

| Risk Level          | Description                                     | Examples                                   |
| ------------------- | ----------------------------------------------- | ------------------------------------------ |
| **Unacceptable**    | Prohibited AI practices                         | Social scoring, real-time biometric mass surveillance |
| **High Risk**       | Significant conformity requirements             | Medical devices, recruitment AI, credit scoring |
| **Limited Risk**    | Transparency obligations                        | Chatbots, deepfakes                        |
| **Minimal Risk**    | No mandatory requirements                       | Spam filters, AI in games                  |
| **GPAI Models**     | General-purpose AI model requirements           | Foundation models (GPT, Claude, etc.)      |

#### Compliance Requirements

| Requirement               | Description                                              |
| ------------------------- | -------------------------------------------------------- |
| **Risk Management System**| Identify, analyze, and mitigate risks                    |
| **Data Governance**       | Training data quality and relevance                      |
| **Technical Documentation**| Pre-market and ongoing documentation                    |
| **Human Oversight**       | Ensure meaningful human control                          |
| **Transparency**          | Clear disclosure when interacting with AI                |
| **Accuracy & Robustness** | Performance metrics and cybersecurity                    |

#### Agents Using This Framework

| Agent                    | Application                       |
| ------------------------ | --------------------------------- |
| Compliance Officer       | AI product compliance             |
| Legal Compliance Checker | Regulatory alignment              |
| Security Architect       | AI risk architecture              |
| Data Architect           | Training data governance          |
| Product Strategist       | Responsible AI product strategy   |

---

### 🆕 18. ISO 42001 (AI Management System)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | ISO/IEC JTC 1/SC 42                                                             |
| **Purpose**       | International standard for establishing AI management systems (AIMS)           |
| **Official Docs** | [iso.org/standard/81230.html](https://www.iso.org/standard/81230.html)         |
| **Maturity**      | Established (Published December 2023)                                           |

#### Key Clauses

| Clause | Area                    | Description                                       |
| ------ | ----------------------- | ------------------------------------------------- |
| 4      | Context of Organization | Understanding AI impact on stakeholders           |
| 5      | Leadership              | Top management commitment and AI policy           |
| 6      | Planning                | Risk and opportunity management for AI            |
| 7      | Support                 | Resources, competence, awareness                  |
| 8      | Operation               | AI system lifecycle controls                      |
| 9      | Performance Evaluation  | Monitoring, measurement, audits                   |
| 10     | Improvement             | Nonconformity and continual improvement           |

#### Agents Using This Framework

| Agent                    | Application                       |
| ------------------------ | --------------------------------- |
| Compliance Officer       | AI system certification           |
| Security Architect       | AI control implementation         |
| Governance Specialist    | AI governance structure           |
| Data Architect           | AI data requirements              |
| Enterprise Architect     | AI organizational alignment       |

---

### 🆕 19. SOX (Sarbanes-Oxley Act)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | U.S. Congress / SEC / PCAOB                                                     |
| **Purpose**       | Financial reporting integrity and IT controls for public companies              |
| **Official Docs** | [sec.gov/about/laws/soa2002.pdf](https://www.sec.gov/about/laws/soa2002.pdf)   |
| **Maturity**      | Established (2002)                                                              |

#### Key Sections

| Section     | Description                                               |
| ----------- | --------------------------------------------------------- |
| **Section 302** | CEO/CFO personal certification of financial reports   |
| **Section 404** | Management assessment of internal controls (ICFR)    |
| **Section 409** | Real-time disclosure of material events               |
| **Section 802** | Records retention and destruction penalties           |

#### IT Controls (ITGC)

| Control Area           | Description                               |
| ---------------------- | ----------------------------------------- |
| Access Controls        | Who can access financial systems          |
| Change Management      | IT system change documentation            |
| Computer Operations    | Backup, recovery, batch processing        |
| Data Center Security   | Physical and logical data security        |

#### Agents Using This Framework

| Agent                    | Application                       |
| ------------------------ | --------------------------------- |
| Compliance Officer       | SOX compliance management         |
| Legal Compliance Checker | Regulatory review                 |
| Governance Specialist    | IT governance controls            |
| Security Auditor         | ITGC audit                        |
| Data Architect           | Financial data integrity          |

---

### 🆕 20. CIS Controls (Center for Internet Security)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Center for Internet Security (CIS)                                              |
| **Purpose**       | Prioritized set of actions to protect against cyber threats                    |
| **Official Docs** | [cisecurity.org/controls](https://www.cisecurity.org/controls)                  |
| **Maturity**      | Established (v8, 2021)                                                          |

#### Implementation Groups

| Group | Target Organization     | Control Count |
| ----- | ----------------------- | ------------- |
| **IG1**  | Small/low-risk        | 56 safeguards |
| **IG2**  | Mid-size organizations| 130 safeguards|
| **IG3**  | Large/high-risk       | All 153 safeguards|

#### Top 5 CIS Controls

| Control | Name                        | Description                                       |
| ------- | --------------------------- | ------------------------------------------------- |
| 1       | Inventory of Enterprise Assets | Know all hardware in your environment          |
| 2       | Inventory of Software Assets  | Know all software running                       |
| 3       | Data Protection               | Classify, handle, and retain data               |
| 4       | Secure Configuration          | Establish and maintain secure configurations    |
| 5       | Account Management            | Manage the lifecycle of all accounts            |

#### Agents Using This Framework

| Agent                     | Application                       |
| ------------------------- | --------------------------------- |
| Security Architect        | Control implementation            |
| Security Auditor          | Baseline assessment               |
| Infrastructure Maintainer | Configuration hardening           |
| Compliance Officer        | Compliance roadmap                |

---

### 🆕 21. DORA (Digital Operational Resilience Act)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | European Union                                                                  |
| **Purpose**       | ICT risk management and operational resilience for EU financial entities        |
| **Official Docs** | [digital-operational-resilience-act.com](https://www.digital-operational-resilience-act.com/) |
| **Maturity**      | Active (Effective January 2025)                                                 |

#### Five Pillars

| Pillar                          | Description                                              |
| ------------------------------- | -------------------------------------------------------- |
| **ICT Risk Management**         | Governance frameworks and risk strategies                |
| **ICT Incident Reporting**      | Classification and mandatory reporting of incidents      |
| **Digital Operational Resilience Testing** | Threat-Led Penetration Testing (TLPT)         |
| **ICT Third-Party Risk**        | Contractual requirements for critical ICT providers      |
| **Information Sharing**         | Threat intelligence sharing between financial entities   |

#### Agents Using This Framework

| Agent                    | Application                       |
| ------------------------ | --------------------------------- |
| Compliance Officer       | DORA compliance program           |
| Security Architect       | Resilience architecture           |
| Incident Responder       | Incident classification & reporting|
| Penetration Tester       | TLPT exercises                    |
| Legal Compliance Checker | Third-party contract review       |

---

### 🆕 22. NIST SP 800-53 (Security and Privacy Controls)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | NIST (National Institute of Standards and Technology)                           |
| **Purpose**       | Comprehensive security and privacy controls catalog for federal systems         |
| **Official Docs** | [csrc.nist.gov/publications/detail/sp/800-53/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) |
| **Maturity**      | Established (Rev 5, 2020)                                                       |

#### Control Families (Selected)

| Family | ID  | Description                          |
| ------ | --- | ------------------------------------ |
| Access Control         | AC | Who can access what and how   |
| Audit & Accountability | AU | Logging and audit trails      |
| Configuration Mgmt     | CM | Secure baseline configurations |
| Incident Response      | IR | Incident handling procedures  |
| Risk Assessment        | RA | Risk identification and analysis|
| System & Comm. Protection | SC | Network and boundary controls|
| System & Info Integrity | SI | Malware, patching, monitoring |

#### Agents Using This Framework

| Agent                     | Application                       |
| ------------------------- | --------------------------------- |
| Security Architect        | Control selection and design      |
| Compliance Officer        | FedRAMP and federal compliance    |
| Security Auditor          | Control assessment                |
| Infrastructure Maintainer | Control implementation            |

---

### 🆕 23. FedRAMP (Federal Risk and Authorization Management Program)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | U.S. General Services Administration (GSA)                                     |
| **Purpose**       | Standardized cloud security authorization for US federal agencies              |
| **Official Docs** | [fedramp.gov](https://www.fedramp.gov/)                                         |
| **Maturity**      | Established (2011, FedRAMP 20x 2024)                                            |

#### Authorization Levels

| Level       | Impact | Typical Use Case                              |
| ----------- | ------ | --------------------------------------------- |
| **Low**     | Low    | Publicly available information systems        |
| **Moderate**| Moderate| Most federal cloud services (80%+ of systems)|
| **High**    | High   | Law enforcement, emergency response, financial|

#### Authorization Paths

| Path                    | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| **Agency Authorization**| Individual agency sponsors authorization                 |
| **JAB Authorization**   | Joint Authorization Board P-ATO (most rigorous)          |
| **FedRAMP 20x**         | Continuous authorization framework (new approach)        |

#### Agents Using This Framework

| Agent                    | Application                       |
| ------------------------ | --------------------------------- |
| Compliance Officer       | FedRAMP authorization management  |
| Security Architect       | FedRAMP control implementation    |
| Security Auditor         | Third-Party Assessment (3PAO)     |
| Infrastructure Maintainer| Cloud control implementation      |

---

### 🆕 24. LGPD (Lei Geral de Proteção de Dados — Brazil)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Brazil / ANPD (Autoridade Nacional de Proteção de Dados)                        |
| **Purpose**       | Data privacy and protection regulation for Brazil                               |
| **Official Docs** | [gov.br/anpd](https://www.gov.br/anpd/pt-br)                                   |
| **Maturity**      | Established (2020)                                                              |

#### Legal Bases for Processing

| Legal Basis          | Description                                         |
| -------------------- | --------------------------------------------------- |
| **Consent**          | Explicit consent of data subject                    |
| **Legal Obligation** | Compliance with legal or regulatory obligation      |
| **Public Policy**    | Execution of public policies                        |
| **Research**         | Research by public body                             |
| **Contract**         | Execution of contract with data subject             |
| **Legitimate Interest** | Based on controller's legitimate interest        |

#### Agents Using This Framework

| Agent                    | Application                       |
| ------------------------ | --------------------------------- |
| Compliance Officer       | LATAM privacy compliance          |
| Legal Compliance Checker | Brazilian regulatory alignment    |
| Data Architect           | Data classification               |
| Security Architect       | Privacy by design                 |

---

## 🏛️ Enterprise Architecture Frameworks

### 16. TOGAF (The Open Group Architecture Framework)

| Attribute         | Details                                                |
| ----------------- | ------------------------------------------------------ |
| **Owner**         | The Open Group                                         |
| **Purpose**       | Enterprise architecture methodology                    |
| **Official Docs** | [opengroup.org/togaf](https://www.opengroup.org/togaf) |
| **Maturity**      | Established (1995, TOGAF 10 2022)                      |

#### Architecture Development Method (ADM)

| Phase       | Description                      |
| ----------- | -------------------------------- |
| Preliminary | Framework customization          |
| A           | Architecture Vision              |
| B           | Business Architecture            |
| C           | Information Systems Architecture |
| D           | Technology Architecture          |
| E           | Opportunities & Solutions        |
| F           | Migration Planning               |
| G           | Implementation Governance        |
| H           | Architecture Change Management   |

#### Agents Using This Framework

| Agent                 | Application             |
| --------------------- | ----------------------- |
| Enterprise Architect  | Primary framework       |
| Solution Architect    | Solution design         |
| Business Architect    | Business architecture   |
| Technology Architect  | Technology architecture |
| Governance Specialist | Governance processes    |

---

### 17. DMBOK (Data Management Body of Knowledge)

| Attribute         | Details                           |
| ----------------- | --------------------------------- |
| **Owner**         | DAMA International                |
| **Purpose**       | Data management framework         |
| **Official Docs** | [dama.org](https://www.dama.org/) |
| **Maturity**      | Established (DMBOK2 2017)         |

#### Knowledge Areas

| Area                      | Description                           |
| ------------------------- | ------------------------------------- |
| Data Governance           | Data management authority and control |
| Data Architecture         | Blueprint for data assets             |
| Data Modeling             | Data requirements representation      |
| Data Storage & Operations | Data lifecycle management             |
| Data Security             | Data privacy and protection           |
| Data Integration          | Data movement and consolidation       |
| Document & Content        | Unstructured data management          |
| Reference & Master Data   | Shared data management                |
| Data Warehousing          | Analytics data management             |
| Metadata                  | Data about data                       |
| Data Quality              | Fitness for use                       |

#### Agents Using This Framework

| Agent                 | Application              |
| --------------------- | ------------------------ |
| Data Architect        | Primary framework        |
| Enterprise Architect  | Enterprise data strategy |
| Governance Specialist | Data governance          |
| Data Scientist        | Data quality management  |

---

### 18. Zachman Framework

| Attribute         | Details                                |
| ----------------- | -------------------------------------- |
| **Owner**         | Zachman International                  |
| **Purpose**       | Enterprise ontology and classification |
| **Official Docs** | [zachman.com](https://zachman.com/)    |
| **Maturity**      | Established (1987)                     |

#### Framework Matrix

|                           | What (Data)             | How (Function)             | Where (Network)             | Who (People)                   | When (Time)              | Why (Motivation)        |
| ------------------------- | ----------------------- | -------------------------- | --------------------------- | ------------------------------ | ------------------------ | ----------------------- |
| **Who (Planner)**         | List of Business Things | List of Business Processes | List of Business Locations  | List of Business Organizations | List of Business Cycles  | List of Business Goals  |
| **What (Owner)**          | Business Entity Model   | Business Process Model     | Business Distribution Model | Business Organization Model    | Business Master Schedule | Business Strategy Model |
| **How (Designer)**        | System Data Model       | Application Architecture   | Distributed Architecture    | Security Architecture          | Processing Architecture  | Business Rule Model     |
| **When (Builder)**        | Data Design             | Application Design         | Network Design              | Interface Design               | Control Design           | Rule Design             |
| **Where (Subcontractor)** | Data Definitions        | Program Code               | Network Configuration       | Training Materials             | Timing Definitions       | Business Rules          |
| **How (Functioning)**     | Data                    | Functioning System         | Network                     | People                         | Cycle                    | Strategy                |

#### Agents Using This Framework

| Agent                | Application               |
| -------------------- | ------------------------- |
| Enterprise Architect | Enterprise classification |
| Data Architect       | Data classification       |
| Solution Architect   | Solution classification   |

---

### 19. COBIT

| Attribute         | Details                                        |
| ----------------- | ---------------------------------------------- |
| **Owner**         | ISACA                                          |
| **Purpose**       | IT governance and management                   |
| **Official Docs** | [isaca.org/cobit](https://www.isaca.org/cobit) |
| **Maturity**      | Established (1996, COBIT 2019)                 |

#### Governance Objectives

| Domain | Description               |
| ------ | ------------------------- |
| EDM    | Evaluate, Direct, Monitor |
| APO    | Align, Plan, Organize     |
| BAI    | Build, Acquire, Implement |
| DSS    | Deliver, Service, Support |
| MEA    | Monitor, Evaluate, Assess |

#### Agents Using This Framework

| Agent                     | Application             |
| ------------------------- | ----------------------- |
| Governance Specialist     | Primary framework       |
| Compliance Officer        | Governance compliance   |
| Enterprise Architect      | IT governance alignment |
| Infrastructure Maintainer | Service management      |

---

### 20. ITIL (Information Technology Infrastructure Library)

| Attribute         | Details                                                                          |
| ----------------- | -------------------------------------------------------------------------------- |
| **Owner**         | Axelos                                                                           |
| **Purpose**       | IT service management                                                            |
| **Official Docs** | [axelos.com/itil](https://www.axelos.com/certifications/itil-service-management) |
| **Maturity**      | Established (1989, ITIL 4 2019)                                                  |

#### Service Value System

| Component             | Description                        |
| --------------------- | ---------------------------------- |
| Guiding Principles    | Recommendations for all situations |
| Governance            | Direction and control              |
| Service Value Chain   | Operating model for value creation |
| Practices             | Sets of organizational resources   |
| Continual Improvement | Ongoing improvement at all levels  |

#### Agents Using This Framework

| Agent                     | Application               |
| ------------------------- | ------------------------- |
| Infrastructure Maintainer | Service management        |
| Support Responder         | Incident management       |
| Technology Architect      | Technology service design |
| Governance Specialist     | IT governance             |

---

### 21. BIZBOK (Business Architecture Body of Knowledge)

| Attribute         | Details                                                                     |
| ----------------- | --------------------------------------------------------------------------- |
| **Owner**         | Business Architecture Guild                                                 |
| **Purpose**       | Business architecture practice guide                                        |
| **Official Docs** | [businessarchitectureguild.org](https://www.businessarchitectureguild.org/) |
| **Maturity**      | Established (2014)                                                          |

#### Core Concepts

| Concept       | Description                  |
| ------------- | ---------------------------- |
| Capabilities  | What a business does         |
| Value Streams | How value is delivered       |
| Information   | Data required for business   |
| Organization  | Structure and relationships  |
| Products      | What is offered to customers |
| Stakeholders  | Who is involved              |
| Initiatives   | Change programs              |
| Strategies    | Business direction           |

#### Agents Using This Framework

| Agent                | Application           |
| -------------------- | --------------------- |
| Business Architect   | Primary framework     |
| Enterprise Architect | Business-IT alignment |
| Product Strategist   | Strategy alignment    |
| Market Analyst       | Market positioning    |

---

### 22. FEAF (Federal Enterprise Architecture Framework)

| Attribute         | Details                                                           |
| ----------------- | ----------------------------------------------------------------- |
| **Owner**         | U.S. Federal CIO Council                                          |
| **Purpose**       | Federal government architecture                                   |
| **Official Docs** | [enterprisearchitecture.gov](https://enterprisearchitecture.gov/) |
| **Maturity**      | Established (1999, FEAF II 2013)                                  |

#### Reference Models

| Model             | Description                      |
| ----------------- | -------------------------------- |
| Performance       | Performance measurement          |
| Business          | Business services and components |
| Service Component | Reusable service components      |
| Data              | Data categorization              |
| Application       | Application portfolios           |
| Infrastructure    | Infrastructure standards         |
| Security          | Security and privacy             |

#### Agents Using This Framework

| Agent                | Application           |
| -------------------- | --------------------- |
| Enterprise Architect | Government projects   |
| Security Architect   | Security compliance   |
| Compliance Officer   | Regulatory compliance |

---

## 📦 Product & Research Frameworks

### 23. Design Thinking

| Attribute         | Details                                               |
| ----------------- | ----------------------------------------------------- |
| **Owner**         | IDEO / Stanford d.school                              |
| **Purpose**       | Human-centered design methodology                     |
| **Official Docs** | [dschool.stanford.edu](https://dschool.stanford.edu/) |
| **Maturity**      | Established (1990s)                                   |

#### Five Stages

| Stage     | Description           |
| --------- | --------------------- |
| Empathize | Understand user needs |
| Define    | Frame the problem     |
| Ideate    | Generate solutions    |
| Prototype | Build representations |
| Test      | Validate with users   |

#### Agents Using This Framework

| Agent                 | Application         |
| --------------------- | ------------------- |
| Innovation Researcher | Innovation process  |
| User Researcher       | User understanding  |
| UX Researcher         | UX design process   |
| Product Strategist    | Product development |
| UI Designer           | Design process      |

---

### 24. Lean Startup

| Attribute         | Details                                           |
| ----------------- | ------------------------------------------------- |
| **Owner**         | Eric Ries                                         |
| **Purpose**       | Startup methodology for validated learning        |
| **Official Docs** | [theleanstartup.com](https://theleanstartup.com/) |
| **Maturity**      | Established (2011)                                |

#### Build-Measure-Learn Loop

| Stage   | Description       |
| ------- | ----------------- |
| Build   | Create MVP        |
| Measure | Collect data      |
| Learn   | Validate or pivot |

#### Agents Using This Framework

| Agent                 | Application               |
| --------------------- | ------------------------- |
| Product Strategist    | Product development       |
| Innovation Researcher | Innovation validation     |
| Rapid Prototyper      | MVP creation              |
| Data Scientist        | Measurement and analytics |
| Experiment Tracker    | Experiment management     |

---

### 25. Agile / Scrum

| Attribute         | Details                                                                                |
| ----------------- | -------------------------------------------------------------------------------------- |
| **Owner**         | Agile Alliance / Scrum.org                                                             |
| **Purpose**       | Iterative development methodology                                                      |
| **Official Docs** | [agilemanifesto.org](https://agilemanifesto.org/), [scrum.org](https://www.scrum.org/) |
| **Maturity**      | Established (2001)                                                                     |

#### Scrum Framework

| Element              | Description                      |
| -------------------- | -------------------------------- |
| Sprint               | Time-boxed iteration (1-4 weeks) |
| Product Backlog      | Prioritized work items           |
| Sprint Planning      | Plan sprint work                 |
| Daily Standup        | Daily synchronization            |
| Sprint Review        | Demo and feedback                |
| Sprint Retrospective | Process improvement              |

#### Agents Using This Framework

| Agent              | Application         |
| ------------------ | ------------------- |
| Sprint Prioritizer | Backlog management  |
| Project Shipper    | Sprint delivery     |
| Experiment Tracker | Iterative testing   |
| Frontend Developer | Development process |
| Backend Architect  | Development process |

---

### 26. OKRs (Objectives and Key Results)

| Attribute         | Details                                         |
| ----------------- | ----------------------------------------------- |
| **Owner**         | Intel / Google (popularized)                    |
| **Purpose**       | Goal setting framework                          |
| **Official Docs** | [whatmatters.com](https://www.whatmatters.com/) |
| **Maturity**      | Established (1970s, popularized 2010s)          |

#### Structure

| Component   | Description                            |
| ----------- | -------------------------------------- |
| Objective   | What you want to achieve (qualitative) |
| Key Results | How you measure success (quantitative) |
| Initiatives | Projects to achieve key results        |

#### Agents Using This Framework

| Agent              | Application       |
| ------------------ | ----------------- |
| Product Strategist | Product goals     |
| Sprint Prioritizer | Sprint objectives |
| Analytics Reporter | KPI tracking      |
| Project Shipper    | Delivery tracking |

---

### 27. TAM/SAM/SOM

| Attribute         | Details                 |
| ----------------- | ----------------------- |
| **Owner**         | Industry Standard       |
| **Purpose**       | Market sizing framework |
| **Official Docs** | Industry standard       |
| **Maturity**      | Established             |

#### Market Levels

| Level | Description                                |
| ----- | ------------------------------------------ |
| TAM   | Total Addressable Market (everyone)        |
| SAM   | Serviceable Addressable Market (reachable) |
| SOM   | Serviceable Obtainable Market (realistic)  |

#### Agents Using This Framework

| Agent                 | Application            |
| --------------------- | ---------------------- |
| Market Analyst        | Market sizing          |
| Product Strategist    | Market opportunity     |
| Innovation Researcher | Opportunity assessment |
| Competitive Analyst   | Market positioning     |

---

### 28. Porter's Five Forces

| Attribute         | Details                                  |
| ----------------- | ---------------------------------------- |
| **Owner**         | Michael Porter (Harvard Business School) |
| **Purpose**       | Industry competition analysis            |
| **Official Docs** | HBR Publications                         |
| **Maturity**      | Established (1979)                       |

#### Five Forces

| Force                  | Description                |
| ---------------------- | -------------------------- |
| Competitive Rivalry    | Intensity of competition   |
| Supplier Power         | Supplier negotiation power |
| Buyer Power            | Customer negotiation power |
| Threat of Substitution | Alternative solutions      |
| Threat of New Entry    | Barrier to entry           |

#### Agents Using This Framework

| Agent                 | Application           |
| --------------------- | --------------------- |
| Market Analyst        | Industry analysis     |
| Competitive Analyst   | Competitive landscape |
| Product Strategist    | Strategic positioning |
| Innovation Researcher | Market opportunities  |

---

### 29. SWOT Analysis

| Attribute         | Details                             |
| ----------------- | ----------------------------------- |
| **Owner**         | Industry Standard (Albert Humphrey) |
| **Purpose**       | Strategic planning framework        |
| **Official Docs** | Industry standard                   |
| **Maturity**      | Established (1960s)                 |

#### Components

| Component     | Description                  |
| ------------- | ---------------------------- |
| Strengths     | Internal positive attributes |
| Weaknesses    | Internal negative attributes |
| Opportunities | External positive factors    |
| Threats       | External negative factors    |

#### Agents Using This Framework

| Agent               | Application          |
| ------------------- | -------------------- |
| Competitive Analyst | Competitive analysis |
| Product Strategist  | Strategic planning   |
| Market Analyst      | Market analysis      |
| Business Architect  | Business strategy    |

---

### 30. Nielsen Heuristics

| Attribute         | Details                                                                                                     |
| ----------------- | ----------------------------------------------------------------------------------------------------------- |
| **Owner**         | Jakob Nielsen                                                                                               |
| **Purpose**       | Usability evaluation framework                                                                              |
| **Official Docs** | [nngroup.com/articles/ten-usability-heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/) |
| **Maturity**      | Established (1994)                                                                                          |

#### 10 Heuristics

| #   | Heuristic                         | Description               |
| --- | --------------------------------- | ------------------------- |
| 1   | Visibility of System Status       | Keep users informed       |
| 2   | Match Between System & Real World | Use user language         |
| 3   | User Control & Freedom            | Undo and redo             |
| 4   | Consistency & Standards           | Follow conventions        |
| 5   | Error Prevention                  | Prevent errors            |
| 6   | Recognition Rather Than Recall    | Minimize memory load      |
| 7   | Flexibility & Efficiency          | Accelerators for experts  |
| 8   | Aesthetic & Minimalist Design     | Relevant information only |
| 9   | Help Users Recognize Errors       | Clear error messages      |
| 10  | Help & Documentation              | Easy to find help         |

#### Agents Using This Framework

| Agent              | Application          |
| ------------------ | -------------------- |
| Usability Tester   | Usability evaluation |
| UX Researcher      | UX assessment        |
| UI Designer        | Design evaluation    |
| Product Strategist | Product quality      |

---

## 📚 Content & Marketing Frameworks

### 31. AIDA

| Attribute         | Details                               |
| ----------------- | ------------------------------------- |
| **Owner**         | Industry Standard (E. St. Elmo Lewis) |
| **Purpose**       | Copywriting and marketing framework   |
| **Official Docs** | Industry standard                     |
| **Maturity**      | Established (1898)                    |

#### Stages

| Stage     | Description                   |
| --------- | ----------------------------- |
| Attention | Capture audience attention    |
| Interest  | Generate interest in offering |
| Desire    | Create desire for solution    |
| Action    | Prompt action/purchase        |

#### Agents Using This Framework

| Agent                   | Application             |
| ----------------------- | ----------------------- |
| Article Writer          | Content structure       |
| Content Creator         | Marketing copy          |
| Social Media Strategist | Social content          |
| Growth Hacker           | Conversion optimization |

---

### 32. Content Calendar

| Attribute         | Details                         |
| ----------------- | ------------------------------- |
| **Owner**         | Industry Standard               |
| **Purpose**       | Content planning and scheduling |
| **Official Docs** | Industry standard               |
| **Maturity**      | Established                     |

#### Components

| Component | Description                 |
| --------- | --------------------------- |
| Topics    | Content themes and subjects |
| Channels  | Distribution platforms      |
| Dates     | Publishing schedule         |
| Owners    | Content creators            |
| Status    | Draft, review, published    |

#### Agents Using This Framework

| Agent                   | Application           |
| ----------------------- | --------------------- |
| Social Media Strategist | Content planning      |
| Article Writer          | Article scheduling    |
| Content Creator         | Multi-format planning |
| Newsletter Writer       | Email scheduling      |

---

### 33. Growth Hacking

| Attribute         | Details                        |
| ----------------- | ------------------------------ |
| **Owner**         | Industry Standard (Sean Ellis) |
| **Purpose**       | Rapid growth experimentation   |
| **Official Docs** | Industry standard              |
| **Maturity**      | Established (2010)             |

#### Framework

| Component   | Description               |
| ----------- | ------------------------- |
| Acquisition | Get users                 |
| Activation  | First positive experience |
| Retention   | Keep users coming back    |
| Revenue     | Monetize users            |
| Referral    | Users invite others       |

#### Agents Using This Framework

| Agent              | Application        |
| ------------------ | ------------------ |
| Growth Hacker      | Primary framework  |
| Marketing Team     | Growth campaigns   |
| Product Strategist | Product-led growth |
| Analytics Reporter | Growth metrics     |

---

### 34. ASO (App Store Optimization)

| Attribute         | Details                              |
| ----------------- | ------------------------------------ |
| **Owner**         | Industry Standard                    |
| **Purpose**       | Mobile app visibility optimization   |
| **Official Docs** | Apple App Store, Google Play Console |
| **Maturity**      | Established (2008+)                  |

#### Key Factors

| Factor      | Description                |
| ----------- | -------------------------- |
| Title       | App name with keywords     |
| Keywords    | Search terms for discovery |
| Description | App features and benefits  |
| Screenshots | Visual app preview         |
| Reviews     | User ratings and feedback  |
| Downloads   | Install velocity           |

#### Agents Using This Framework

| Agent               | Application       |
| ------------------- | ----------------- |
| App Store Optimizer | Primary framework |
| Content Creator     | App descriptions  |
| Growth Hacker       | Download growth   |
| Analytics Reporter  | ASO metrics       |

---

### 35. Brand Guidelines

| Attribute         | Details                     |
| ----------------- | --------------------------- |
| **Owner**         | Industry Standard           |
| **Purpose**       | Brand consistency framework |
| **Official Docs** | Organization-specific       |
| **Maturity**      | Established                 |

#### Components

| Component    | Description                  |
| ------------ | ---------------------------- |
| Logo         | Usage and variations         |
| Colors       | Brand color palette          |
| Typography   | Font families and usage      |
| Voice & Tone | Brand personality            |
| Imagery      | Photo and illustration style |
| Layout       | Design templates             |

#### Agents Using This Framework

| Agent                   | Application           |
| ----------------------- | --------------------- |
| Brand Guardian          | Primary framework     |
| Content Creator         | Brand consistency     |
| UI Designer             | Visual consistency    |
| Social Media Strategist | Social brand presence |

---

### 36. Platform-Specific Writing

| Attribute         | Details                            |
| ----------------- | ---------------------------------- |
| **Owner**         | Platform Guidelines                |
| **Purpose**       | Optimize content for each platform |
| **Official Docs** | X, LinkedIn, Medium guidelines     |
| **Maturity**      | Established                        |

#### Platform Best Practices

| Platform    | Best Practices                           |
| ----------- | ---------------------------------------- |
| X (Twitter) | Threads, 280 chars, hashtags, engagement |
| LinkedIn    | Professional tone, articles, networking  |
| Medium      | Long-form, publications, curation        |
| TikTok      | Short video, trends, music               |
| Instagram   | Visual, reels, stories                   |

#### Agents Using This Framework

| Agent                   | Application                 |
| ----------------------- | --------------------------- |
| Article Writer          | Platform optimization       |
| Social Media Strategist | Multi-platform strategy     |
| Content Creator         | Cross-platform content      |
| Video Script Writer     | Video platform optimization |

---

## 💻 Engineering & DevOps Frameworks

### 37. CI/CD

| Attribute         | Details                               |
| ----------------- | ------------------------------------- |
| **Owner**         | Industry Standard                     |
| **Purpose**       | Continuous integration and deployment |
| **Official Docs** | Industry standard                     |
| **Maturity**      | Established (2000s)                   |

#### Pipeline Stages

| Stage   | Description           |
| ------- | --------------------- |
| Code    | Write and commit code |
| Build   | Compile and package   |
| Test    | Automated testing     |
| Release | Deploy to staging     |
| Deploy  | Deploy to production  |
| Monitor | Monitor performance   |

#### Agents Using This Framework

| Agent                     | Application           |
| ------------------------- | --------------------- |
| DevOps Automator          | Primary framework     |
| Backend Architect         | Pipeline design       |
| API Tester                | Automated testing     |
| Infrastructure Maintainer | Deployment management |

---

### 38. Infrastructure as Code (IaC)

| Attribute         | Details                            |
| ----------------- | ---------------------------------- |
| **Owner**         | Industry Standard                  |
| **Purpose**       | Manage infrastructure through code |
| **Official Docs** | Terraform, CloudFormation, etc.    |
| **Maturity**      | Established (2010s)                |

#### Tools

| Tool           | Description              |
| -------------- | ------------------------ |
| Terraform      | Multi-cloud provisioning |
| CloudFormation | AWS infrastructure       |
| ARM Templates  | Azure infrastructure     |
| Ansible        | Configuration management |
| Puppet         | Configuration management |
| Chef           | Configuration management |

#### Agents Using This Framework

| Agent                     | Application               |
| ------------------------- | ------------------------- |
| DevOps Automator          | Infrastructure automation |
| Infrastructure Maintainer | Infrastructure management |
| Security Architect        | Secure infrastructure     |
| Backend Architect         | Scalable infrastructure   |

---

### 39. Microservices Architecture

| Attribute         | Details                              |
| ----------------- | ------------------------------------ |
| **Owner**         | Industry Standard                    |
| **Purpose**       | Decompose applications into services |
| **Official Docs** | Industry standard                    |
| **Maturity**      | Established (2010s)                  |

#### Principles

| Principle              | Description                    |
| ---------------------- | ------------------------------ |
| Single Responsibility  | Each service does one thing    |
| Decentralized Data     | Each service owns its data     |
| Independent Deployment | Services deploy independently  |
| Fault Isolation        | Failures don't cascade         |
| Technology Diversity   | Use best tool for each service |

#### Agents Using This Framework

| Agent              | Application        |
| ------------------ | ------------------ |
| Backend Architect  | Service design     |
| DevOps Automator   | Service deployment |
| API Tester         | Service testing    |
| Security Architect | Service security   |

---

### 40. API Design (REST/GraphQL)

| Attribute         | Details                      |
| ----------------- | ---------------------------- |
| **Owner**         | Industry Standard            |
| **Purpose**       | API design best practices    |
| **Official Docs** | REST, GraphQL specifications |
| **Maturity**      | Established                  |

#### Design Principles

| Principle      | Description              |
| -------------- | ------------------------ |
| Resource-Based | URLs represent resources |
| HTTP Verbs     | GET, POST, PUT, DELETE   |
| Status Codes   | Standard HTTP responses  |
| Versioning     | API version management   |
| Documentation  | Clear API documentation  |

#### Agents Using This Framework

| Agent                | Application       |
| -------------------- | ----------------- |
| Backend Architect    | API design        |
| API Tester           | API validation    |
| Documentation Writer | API documentation |
| Frontend Developer   | API integration   |

---

## 🎨 Design & UX Frameworks

### 41. Design Systems

| Attribute         | Details                       |
| ----------------- | ----------------------------- |
| **Owner**         | Industry Standard             |
| **Purpose**       | Reusable design components    |
| **Official Docs** | Material Design, Carbon, etc. |
| **Maturity**      | Established (2010s)           |

#### Components

| Component  | Description                        |
| ---------- | ---------------------------------- |
| Components | Reusable UI elements               |
| Patterns   | Common interaction patterns        |
| Guidelines | Usage documentation                |
| Tokens     | Design variables (colors, spacing) |
| Tools      | Design and development tools       |

#### Agents Using This Framework

| Agent                | Application              |
| -------------------- | ------------------------ |
| UI Designer          | Component design         |
| Frontend Developer   | Component implementation |
| Brand Guardian       | Brand consistency        |
| Documentation Writer | System documentation     |

---

### 42. User Journey Mapping

| Attribute         | Details                   |
| ----------------- | ------------------------- |
| **Owner**         | Industry Standard         |
| **Purpose**       | Visualize user experience |
| **Official Docs** | Industry standard         |
| **Maturity**      | Established               |

#### Components

| Component     | Description          |
| ------------- | -------------------- |
| Persona       | User representation  |
| Stages        | Journey phases       |
| Actions       | User actions         |
| Thoughts      | User thoughts        |
| Emotions      | Emotional state      |
| Pain Points   | Problems encountered |
| Opportunities | Improvement areas    |

#### Agents Using This Framework

| Agent              | Application          |
| ------------------ | -------------------- |
| UX Researcher      | Journey research     |
| User Researcher    | User understanding   |
| Product Strategist | Product improvements |
| UI Designer        | Experience design    |

---

### 43. Accessibility (WCAG)

| Attribute         | Details                                         |
| ----------------- | ----------------------------------------------- |
| **Owner**         | W3C                                             |
| **Purpose**       | Web accessibility guidelines                    |
| **Official Docs** | [w3.org/WAI/WCAG](https://www.w3.org/WAI/WCAG/) |
| **Maturity**      | Established (1999, WCAG 2.2 2023)               |

#### Principles (POUR)

| Principle      | Description                            |
| -------------- | -------------------------------------- |
| Perceivable    | Information presentable to users       |
| Operable       | Interface navigable by all             |
| Understandable | Information and operation clear        |
| Robust         | Compatible with assistive technologies |

#### Agents Using This Framework

| Agent              | Application               |
| ------------------ | ------------------------- |
| UI Designer        | Accessible design         |
| Frontend Developer | Accessible implementation |
| UX Researcher      | Accessibility testing     |
| Compliance Officer | Compliance verification   |

---

### 44. SUS (System Usability Scale)

| Attribute         | Details               |
| ----------------- | --------------------- |
| **Owner**         | John Brooke           |
| **Purpose**       | Usability measurement |
| **Official Docs** | Industry standard     |
| **Maturity**      | Established (1986)    |

#### Scale

| Score Range | Rating    |
| ----------- | --------- |
| 85-100      | Excellent |
| 70-84       | Good      |
| 50-69       | OK        |
| 25-49       | Poor      |
| 0-24        | Awful     |

#### Agents Using This Framework

| Agent              | Application           |
| ------------------ | --------------------- |
| Usability Tester   | Usability measurement |
| UX Researcher      | User research         |
| Product Strategist | Product quality       |

---

### 45. Atomic Design

| Attribute         | Details                                                           |
| ----------------- | ----------------------------------------------------------------- |
| **Owner**         | Brad Frost                                                        |
| **Purpose**       | Design system methodology                                         |
| **Official Docs** | [atomicdesign.bradfrost.com](https://atomicdesign.bradfrost.com/) |
| **Maturity**      | Established (2013)                                                |

#### Levels

| Level     | Description           |
| --------- | --------------------- |
| Atoms     | Basic building blocks |
| Molecules | Groups of atoms       |
| Organisms | Complex components    |
| Templates | Page-level layouts    |
| Pages     | Final content         |

#### Agents Using This Framework

| Agent              | Application              |
| ------------------ | ------------------------ |
| UI Designer        | Component design         |
| Frontend Developer | Component implementation |
| Design System Lead | System architecture      |

---

## 📋 Project Management Frameworks

### 46. Kanban

| Attribute         | Details                             |
| ----------------- | ----------------------------------- |
| **Owner**         | Toyota (adapted for software)       |
| **Purpose**       | Visual workflow management          |
| **Official Docs** | [kanban.zone](https://kanban.zone/) |
| **Maturity**      | Established (1940s, software 2000s) |

#### Principles

| Principle               | Description             |
| ----------------------- | ----------------------- |
| Visualize Work          | Kanban board            |
| Limit WIP               | Work in progress limits |
| Manage Flow             | Optimize workflow       |
| Explicit Policies       | Clear rules             |
| Feedback Loops          | Regular reviews         |
| Improve Collaboratively | Continuous improvement  |

#### Agents Using This Framework

| Agent              | Application        |
| ------------------ | ------------------ |
| Sprint Prioritizer | Backlog management |
| Project Shipper    | Delivery tracking  |
| Experiment Tracker | Experiment flow    |

---

### 47. Stage-Gate

| Attribute         | Details                     |
| ----------------- | --------------------------- |
| **Owner**         | Robert G. Cooper            |
| **Purpose**       | Product development process |
| **Official Docs** | Stage-Gate International    |
| **Maturity**      | Established (1980s)         |

#### Stages

| Stage         | Description            |
| ------------- | ---------------------- |
| Discovery     | Idea generation        |
| Scoping       | Preliminary assessment |
| Business Case | Detailed investigation |
| Development   | Product development    |
| Testing       | Validation and testing |
| Launch        | Commercialization      |

#### Agents Using This Framework

| Agent              | Application         |
| ------------------ | ------------------- |
| R&D Coordinator    | R&D management      |
| Product Strategist | Product development |
| Project Shipper    | Stage management    |

---

### 48. A/B Testing

| Attribute         | Details                   |
| ----------------- | ------------------------- |
| **Owner**         | Industry Standard         |
| **Purpose**       | Experimentation framework |
| **Official Docs** | Industry standard         |
| **Maturity**      | Established               |

#### Process

| Step           | Description              |
| -------------- | ------------------------ |
| Hypothesis     | Define what to test      |
| Variation      | Create test variants     |
| Traffic        | Split audience           |
| Measurement    | Track metrics            |
| Analysis       | Statistical significance |
| Implementation | Deploy winner            |

#### Agents Using This Framework

| Agent              | Application           |
| ------------------ | --------------------- |
| Experiment Tracker | Experiment management |
| Data Scientist     | Statistical analysis  |
| Growth Hacker      | Growth experiments    |
| Product Strategist | Product decisions     |

---

### 49. RACI Matrix

| Attribute         | Details                   |
| ----------------- | ------------------------- |
| **Owner**         | Industry Standard         |
| **Purpose**       | Responsibility assignment |
| **Official Docs** | Industry standard         |
| **Maturity**      | Established               |

#### Roles

| Role        | Description           |
| ----------- | --------------------- |
| Responsible | Does the work         |
| Accountable | Ultimately answerable |
| Consulted   | Provides input        |
| Informed    | Kept up-to-date       |

#### Agents Using This Framework

| Agent                 | Application               |
| --------------------- | ------------------------- |
| Project Shipper       | Project responsibilities  |
| Studio Producer       | Creative responsibilities |
| Governance Specialist | Governance roles          |

---

## 🧠 Behavior Science & Persuasion Frameworks

### 50. Cialdini's 6 Principles of Persuasion

| Attribute         | Details                                                              |
| ----------------- | -------------------------------------------------------------------- |
| **Owner**         | Dr. Robert Cialdini                                                  |
| **Purpose**       | Evidence-based principles of influence and persuasion                |
| **Official Docs** | [Influence: The Psychology of Persuasion](https://www.cialdini.com/) |
| **Maturity**      | Established (1984, updated 2016 with 7th principle)                  |

#### Six Principles

| Principle        | Description                           | Application                               |
| ---------------- | ------------------------------------- | ----------------------------------------- |
| **Reciprocity**  | People feel obliged to return favors  | Free trials, samples, valuable content    |
| **Scarcity**     | Limited availability increases desire | Limited-time offers, exclusive access     |
| **Authority**    | People follow credible experts        | Credentials, certifications, endorsements |
| **Consistency**  | People align with past commitments    | Small yeses leading to bigger commitments |
| **Liking**       | People say yes to those they like     | Rapport building, similarity, compliments |
| **Social Proof** | People follow what others do          | Testimonials, reviews, user counts        |

#### Agents Using This Framework

| Agent                 | Application         |
| --------------------- | ------------------- |
| Persuasion Specialist | Primary framework   |
| Conversion Optimizer  | Funnel optimization |
| Influence Strategist  | Campaign design     |
| Content Creator       | Persuasive content  |
| Article Writer        | Copy optimization   |
| Growth Hacker         | Growth campaigns    |

#### Related Frameworks

- AIDA Model
- Elaboration Likelihood Model
- Social Proof Theory

---

### 51. Fogg Behavior Model (FBM)

| Attribute         | Details                                                         |
| ----------------- | --------------------------------------------------------------- |
| **Owner**         | Dr. BJ Fogg (Stanford University)                               |
| **Purpose**       | Understand and design for behavior change                       |
| **Official Docs** | [bjfogg.com/behavior-model](https://bjfogg.com/behavior-model/) |
| **Maturity**      | Established (2009)                                              |

#### Behavior Formula

Behavior = Motivation × Ability × Prompt

| Component      | Description                 | Design Implication                                |
| -------------- | --------------------------- | ------------------------------------------------- |
| **Motivation** | Desire to perform behavior  | Increase through benefits, fears, social pressure |
| **Ability**    | Ease of performing behavior | Reduce friction, simplify, train                  |
| **Prompt**     | Trigger to perform behavior | Add cues, notifications, calls-to-action          |

#### Behavior Change Strategies

| Strategy            | When to Use            | Example                  |
| ------------------- | ---------------------- | ------------------------ |
| Increase Motivation | When ability is high   | Gamification, rewards    |
| Increase Ability    | When motivation is low | Simplify, reduce steps   |
| Add Prompt          | When both are present  | Notifications, reminders |

#### Agents Using This Framework

| Agent                 | Application            |
| --------------------- | ---------------------- |
| Behavioral Designer   | Primary framework      |
| Habit Formation Coach | Habit design           |
| Conversion Optimizer  | Funnel optimization    |
| Product Strategist    | Feature adoption       |
| UX Researcher         | User behavior analysis |

---

### 52. Nudge Theory

| Attribute         | Details                                                                                       |
| ----------------- | --------------------------------------------------------------------------------------------- |
| **Owner**         | Thaler & Sunstein                                                                             |
| **Purpose**       | Influence choices without restricting freedom                                                 |
| **Official Docs** | [Nudge: Improving Decisions About Health, Wealth, and Happiness](https://www.nudgeworld.org/) |
| **Maturity**      | Established (2008)                                                                            |

#### Key Concepts

| Concept                     | Description                        | Application                        |
| --------------------------- | ---------------------------------- | ---------------------------------- |
| **Choice Architecture**     | How options are presented          | Default options, framing, ordering |
| **Libertarian Paternalism** | Guide without restricting          | Opt-out vs opt-in defaults         |
| **Sludge**                  | Friction that discourages behavior | Reduce barriers, simplify forms    |
| **Nudge**                   | Subtle push toward better choices  | Smart defaults, social norms       |

#### Nudge Techniques

| Technique       | Description                       | Example                      |
| --------------- | --------------------------------- | ---------------------------- |
| Default Options | Pre-selected choices              | Opt-out organ donation       |
| Social Norms    | Show what others do               | "90% of users complete this" |
| Framing         | Present information strategically | "95% fat-free" vs "5% fat"   |
| Salience        | Make important info prominent     | Highlighted fees, warnings   |

#### Agents Using This Framework

| Agent               | Application           |
| ------------------- | --------------------- |
| Nudge Architect     | Primary framework     |
| Decision Architect  | Decision optimization |
| Behavioral Designer | Choice design         |
| Product Strategist  | Feature defaults      |
| Policy Designer     | Public policy         |

#### ⚠️ Ethical Considerations

- **ALWAYS** preserve freedom of choice
- **NEVER** manipulate without transparency
- **ALWAYS** design for user benefit
- **NEVER** exploit cognitive vulnerabilities

---

### 53. Hook Model

| Attribute         | Details                                                                          |
| ----------------- | -------------------------------------------------------------------------------- |
| **Owner**         | Nir Eyal                                                                         |
| **Purpose**       | Build habit-forming products                                                     |
| **Official Docs** | [Hooked: How to Build Habit-Forming Products](https://www.nirandfar.com/hooked/) |
| **Maturity**      | Established (2014)                                                               |

#### Hook Cycle

| Stage               | Description                    | Example                          |
| ------------------- | ------------------------------ | -------------------------------- |
| **Trigger**         | Internal or external cue       | Notification, boredom, FOMO      |
| **Action**          | Simple behavior performed      | Click, scroll, share, post       |
| **Variable Reward** | Unpredictable positive outcome | Likes, comments, new content     |
| **Investment**      | User puts something in         | Data, time, content, connections |

#### Types of Triggers

| Type     | Description                    | Example                |
| -------- | ------------------------------ | ---------------------- |
| External | Notifications, emails, ads     | Push notification      |
| Internal | Emotions, routines, situations | Boredom → social media |

#### Types of Rewards

| Type   | Description             | Example                     |
| ------ | ----------------------- | --------------------------- |
| Social | Connection, recognition | Likes, comments, shares     |
| Hunt   | Search for resources    | Scrolling feed, deals       |
| Self   | Mastery, completion     | Progress bars, achievements |

#### Agents Using This Framework

| Agent                 | Application              |
| --------------------- | ------------------------ |
| Habit Formation Coach | Primary framework        |
| Product Strategist    | Product engagement       |
| Growth Hacker         | Retention strategies     |
| Behavioral Designer   | Feature design           |
| UX Researcher         | User engagement analysis |

---

### 54. COM-B Model

| Attribute         | Details                                                         |
| ----------------- | --------------------------------------------------------------- |
| **Owner**         | Michie et al. (UCL Centre for Behaviour Change)                 |
| **Purpose**       | Understand behavior for intervention design                     |
| **Official Docs** | [Behaviour Change Wheel](https://www.behaviourchangewheel.com/) |
| **Maturity**      | Established (2011)                                              |

#### Behavior Equation

Behavior = Capability × Opportunity × Motivation

| Component       | Description                        | Intervention Types           |
| --------------- | ---------------------------------- | ---------------------------- |
| **Capability**  | Physical/psychological ability     | Training, education, skills  |
| **Opportunity** | External factors enabling behavior | Environment, resources, cues |
| **Motivation**  | Brain processes directing behavior | Incentives, emotions, habits |

#### Intervention Functions

| Function                    | Description                    | Example                      |
| --------------------------- | ------------------------------ | ---------------------------- |
| Education                   | Increase knowledge             | Tutorials, documentation     |
| Persuasion                  | Influence attitudes            | Testimonials, social proof   |
| Incentivization             | Create expectation of reward   | Points, badges, prizes       |
| Coercion                    | Create expectation of cost     | Penalties, restrictions      |
| Training                    | Impart skills                  | Workshops, practice          |
| Restriction                 | Limit options                  | Blocking, rules              |
| Environmental Restructuring | Change physical context        | Defaults, placement          |
| Modeling                    | Provide example                | Demonstrations, case studies |
| Enablement                  | Increase means/reduce barriers | Tools, support               |

#### Agents Using This Framework

| Agent                 | Application                  |
| --------------------- | ---------------------------- |
| Behavioral Designer   | Behavior intervention design |
| Habit Formation Coach | Habit system design          |
| Product Strategist    | Feature adoption             |
| Change Management     | Organizational change        |
| Health Designer       | Health behavior change       |

---

### 55. EAST Framework

| Attribute         | Details                                                   |
| ----------------- | --------------------------------------------------------- |
| **Owner**         | Behavioural Insights Team (BIT)                           |
| **Purpose**       | Simple framework for applying behavior science            |
| **Official Docs** | [bi.team/publications](https://www.bi.team/publications/) |
| **Maturity**      | Established (2014)                                        |

#### Four Principles

| Principle      | Description                | Application                    |
| -------------- | -------------------------- | ------------------------------ |
| **Easy**       | Reduce friction and effort | Simplify forms, reduce steps   |
| **Attractive** | Make it appealing          | Design, rewards, gamification  |
| **Social**     | Leverage social influence  | Social proof, norms, networks  |
| **Timely**     | Intervene at right moment  | Context-based prompts, moments |

#### Implementation Checklist

| Principle  | Questions to Ask                             |
| ---------- | -------------------------------------------- |
| Easy       | Can we simplify? Remove steps? Pre-fill?     |
| Attractive | Is it visually appealing? Are rewards clear? |
| Social     | Can we show others doing it? Use norms?      |
| Timely     | Are we reaching people at the right moment?  |

#### Agents Using This Framework

| Agent                | Application         |
| -------------------- | ------------------- |
| Nudge Architect      | Primary framework   |
| Conversion Optimizer | Funnel optimization |
| Behavioral Designer  | Intervention design |
| Product Strategist   | Feature design      |
| Marketing Strategist | Campaign design     |

---

### 56. Cognitive Biases (Key Selection)

| Attribute         | Details                                                                                             |
| ----------------- | --------------------------------------------------------------------------------------------------- |
| **Owner**         | Kahneman & Tversky / Psychology Research                                                            |
| **Purpose**       | Understand systematic thinking errors                                                               |
| **Official Docs** | [Thinking, Fast and Slow](https://www.nobelprize.org/prizes/economic-sciences/2002/kahneman/facts/) |
| **Maturity**      | Established (1970s+)                                                                                |

#### Key Biases for Design

| Bias              | Description                      | Ethical Application               |
| ----------------- | -------------------------------- | --------------------------------- |
| **Anchoring**     | First information weighs heavily | Price anchoring, first impression |
| **Loss Aversion** | Losses hurt more than gains      | Free trial expiration, FOMO       |
| **Status Quo**    | Prefer current state             | Default options, opt-out          |
| **Confirmation**  | Seek confirming evidence         | Testimonials, case studies        |
| **Availability**  | Recall recent/vivid examples     | Success stories, recent wins      |
| **Endowment**     | Value owned items more           | Free trials, customization        |
| **Social Proof**  | Follow what others do            | Reviews, user counts              |
| **Scarcity**      | Value limited items              | Limited editions, time limits     |

#### Agents Using This Framework

| Agent                  | Application            |
| ---------------------- | ---------------------- |
| Decision Architect     | Bias mitigation        |
| Persuasion Specialist  | Persuasive messaging   |
| Negotiation Specialist | Negotiation strategy   |
| Product Strategist     | Feature design         |
| UX Researcher          | User research analysis |

#### ⚠️ Ethical Considerations

- **ALWAYS** disclose important information
- **NEVER** exploit vulnerabilities
- **ALWAYS** allow informed consent
- **NEVER** create false urgency

---

### 57. Jobs-to-be-Done (JTBD)

| Attribute         | Details                                                 |
| ----------------- | ------------------------------------------------------- |
| **Owner**         | Clayton Christensen / Anthony Ulwick                    |
| **Purpose**       | Understand why customers "hire" products                |
| **Official Docs** | [jobs-to-be-done.com](https://www.jobs-to-be-done.com/) |
| **Maturity**      | Established (2000s)                                     |

#### Job Types

| Type               | Description        | Example             |
| ------------------ | ------------------ | ------------------- |
| **Functional Job** | Task to accomplish | "Send a message"    |
| **Emotional Job**  | Feeling to achieve | "Feel connected"    |
| **Social Job**     | Social outcome     | "Look professional" |

#### JTBD Framework

| Component             | Description             |
| --------------------- | ----------------------- |
| **Situation**         | Context when job arises |
| **Motivation**        | Why the job matters     |
| **Expected Outcome**  | What success looks like |
| **Current Solutions** | What they use now       |
| **Pain Points**       | What frustrates them    |

#### Agents Using This Framework

| Agent                 | Application                |
| --------------------- | -------------------------- |
| Product Strategist    | Product-market fit         |
| User Researcher       | User interviews            |
| Behavioral Designer   | Behavior understanding     |
| Market Analyst        | Market segmentation        |
| Innovation Researcher | Opportunity identification |

---

### 58. Elaboration Likelihood Model (ELM)

| Attribute         | Details                      |
| ----------------- | ---------------------------- |
| **Owner**         | Petty & Cacioppo             |
| **Purpose**       | Understand persuasion routes |
| **Official Docs** | Psychology research          |
| **Maturity**      | Established (1986)           |

#### Two Routes

| Route          | Description                         | When Used                     |
| -------------- | ----------------------------------- | ----------------------------- |
| **Central**    | Careful, thoughtful processing      | High motivation, high ability |
| **Peripheral** | Heuristic, surface-level processing | Low motivation, low ability   |

#### Agents Using This Framework

| Agent                 | Application      |
| --------------------- | ---------------- |
| Persuasion Specialist | Message design   |
| Content Creator       | Content strategy |
| Marketing Strategist  | Campaign design  |

---


### 🆕 59. Transtheoretical Model (TTM / Stages of Change)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Prochaska & DiClemente                                                          |
| **Purpose**       | Model of intentional behavior change through identifiable stages               |
| **Official Docs** | [uri.edu/research/cprc](https://web.uri.edu/cprc/transtheoretical-model/)       |
| **Maturity**      | Established (1983)                                                              |

#### Stages of Change

| Stage               | Description                                     | Intervention Strategy                        |
| ------------------- | ----------------------------------------------- | -------------------------------------------- |
| **Pre-contemplation** | Not intending to change in next 6 months      | Raise awareness, provide information         |
| **Contemplation**   | Intending to change within 6 months             | Explore ambivalence, pros/cons               |
| **Preparation**     | Intending to act within next 30 days            | Help create action plan                      |
| **Action**          | Made specific changes in past 6 months          | Support and reinforce behavior               |
| **Maintenance**     | Sustained change for more than 6 months         | Prevent relapse, build identity              |
| **Termination**     | No temptation, 100% confidence                  | Rare — consolidate permanent change          |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Habit Formation Coach | Stage-matched habit design         |
| Behavioral Designer   | Onboarding and retention design    |
| Health Designer       | Health behavior interventions      |
| Change Management     | Organizational readiness           |
| Product Strategist    | User lifecycle messaging           |

#### ⚠️ Ethical Considerations

- **NEVER** force users to skip stages prematurely
- **ALWAYS** match interventions to stage — wrong-stage nudges backfire
- **ALWAYS** respect individual readiness timelines

---

### 🆕 60. Self-Determination Theory (SDT)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Edward Deci & Richard Ryan (University of Rochester)                            |
| **Purpose**       | Framework for understanding intrinsic vs. extrinsic motivation                 |
| **Official Docs** | [selfdeterminationtheory.org](https://selfdeterminationtheory.org/)             |
| **Maturity**      | Established (1985)                                                              |

#### Three Basic Psychological Needs

| Need               | Description                                      | Design Application                           |
| ------------------ | ------------------------------------------------ | -------------------------------------------- |
| **Autonomy**       | Feeling of volition and ownership                | User choice, customization, opt-in design    |
| **Competence**     | Feeling of effectiveness and mastery             | Progressive challenges, skill feedback       |
| **Relatedness**    | Feeling of connection to others                  | Social features, community, shared goals     |

#### Motivation Spectrum

| Type                   | Description                                  | Example                       |
| ---------------------- | -------------------------------------------- | ----------------------------- |
| **Intrinsic**          | Inherently rewarding activity                | Curiosity, creativity, fun    |
| **Identified**         | Personally meaningful external goal          | Exercise for health values    |
| **Introjected**        | Guilt or ego-driven                          | "I should" behaviors          |
| **External**           | Driven by reward or punishment               | Bonuses, deadlines            |
| **Amotivation**        | No motivation at all                         | Disengagement                 |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Habit Formation Coach | Intrinsic motivation design        |
| Product Strategist    | Engagement and retention           |
| Behavioral Designer   | Feature autonomy and feedback      |
| Growth Hacker         | Sustainable growth design          |
| UX Researcher         | Motivational user research         |

---

### 🆕 61. Dual Process Theory (System 1 & System 2)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Daniel Kahneman (Thinking, Fast and Slow) / Stanovich & West                   |
| **Purpose**       | Framework describing two modes of thought underlying all human decisions       |
| **Official Docs** | [nobelprize.org/prizes/economic-sciences/2002/kahneman](https://www.nobelprize.org/prizes/economic-sciences/2002/kahneman/facts/) |
| **Maturity**      | Established (2002 Nobel, popularized 2011)                                      |

#### Two Systems

| System       | Nickname    | Characteristics                              | Examples                          |
| ------------ | ----------- | -------------------------------------------- | --------------------------------- |
| **System 1** | Fast        | Automatic, unconscious, emotional, heuristic | Recognizing faces, gut reactions  |
| **System 2** | Slow        | Deliberate, effortful, logical, controlled   | Math problems, weighing decisions |

#### Design Implications

| Principle               | System 1 Application                      | System 2 Application                     |
| ----------------------- | ----------------------------------------- | ---------------------------------------- |
| **Friction**            | Remove friction for desired behaviors     | Add friction to prevent impulsive errors |
| **Defaults**            | Smart defaults exploit System 1           | Confirmation dialogs engage System 2     |
| **Framing**             | Emotional framing activates System 1      | Data and reasoning engage System 2       |
| **Trust**               | Visual cues and familiarity               | Credentials, reviews, detailed proof     |

#### Agents Using This Framework

| Agent                  | Application                        |
| ---------------------- | ---------------------------------- |
| Decision Architect     | Choice environment design          |
| Persuasion Specialist  | Message design by cognitive load   |
| Behavioral Designer    | UX friction and flow design        |
| Conversion Optimizer   | Checkout and funnel optimization   |
| Negotiation Specialist | Negotiation timing and framing     |

---

### 🆕 62. SCARF Model

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | David Rock (NeuroLeadership Institute)                                          |
| **Purpose**       | Neuroscience-based model of social threats and rewards shaping behavior        |
| **Official Docs** | [neuroleadership.com/research/scarf-model](https://neuroleadership.com/)        |
| **Maturity**      | Established (2008)                                                              |

#### Five Domains

| Domain           | Description                                     | Threat Response                    | Reward Response                    |
| ---------------- | ----------------------------------------------- | ---------------------------------- | ---------------------------------- |
| **Status**       | Relative importance to others                   | Being criticized or undermined     | Recognition, promotion, praise     |
| **Certainty**    | Ability to predict the future                   | Ambiguity, unclear expectations    | Clear goals, predictable process   |
| **Autonomy**     | Sense of control over events                    | Micromanagement, forced choices    | Self-directed work, choices        |
| **Relatedness**  | Sense of safety with others                     | Working with strangers, exclusion  | Team cohesion, collaboration       |
| **Fairness**     | Perception of fair exchanges                    | Inconsistent rules, favoritism     | Transparent processes, equity      |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Behavioral Designer   | People-centered product design     |
| Change Management     | Organizational change design       |
| Influence Strategist  | Leadership communication           |
| Negotiation Specialist| Negotiation and conflict resolution|
| Product Strategist    | Team engagement and culture        |

---

### 🆕 63. Theory of Planned Behavior (TPB)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Icek Ajzen                                                                      |
| **Purpose**       | Predict and explain individual behavior through attitudes and social norms     |
| **Official Docs** | [people.umass.edu/aizen/tpb.html](https://people.umass.edu/aizen/tpb.html)     |
| **Maturity**      | Established (1991)                                                              |

#### Core Components

| Component                      | Description                                      | Design Application                       |
| ------------------------------ | ------------------------------------------------ | ---------------------------------------- |
| **Attitude**                   | Individual's evaluation of the behavior          | Shape perception of benefit/risk         |
| **Subjective Norms**           | Perceived social pressure to perform behavior    | Social proof, testimonials, norms        |
| **Perceived Behavioral Control** | Belief in ability to perform behavior          | Reduce barriers, build self-efficacy     |
| **Behavioral Intention**       | Readiness to perform behavior                    | Commitment devices, planning prompts     |
| **Behavior**                   | Actual action taken                              | Measure and reinforce                    |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Behavioral Designer   | Behavior prediction modeling       |
| Policy Designer       | Public behavior intervention       |
| UX Researcher         | User intention research            |
| Health Designer       | Health adoption design             |
| Conversion Optimizer  | Purchase intent optimization       |

---

### 🆕 64. Social Learning Theory (Bandura)

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Albert Bandura (Stanford University)                                            |
| **Purpose**       | Explains learning through observation, imitation, and modeling of others       |
| **Official Docs** | [albertbandura.com](https://www.albertbandura.com/)                             |
| **Maturity**      | Established (1977)                                                              |

#### Key Concepts

| Concept               | Description                                      | Application                              |
| --------------------- | ------------------------------------------------ | ---------------------------------------- |
| **Observational Learning** | Learning by watching others                 | Tutorials, examples, role models        |
| **Self-Efficacy**     | Belief in one's ability to succeed               | Progress feedback, mastery moments      |
| **Modeling**          | Imitating observed behavior                      | Influencer marketing, case studies      |
| **Vicarious Reinforcement** | Motivation from seeing others rewarded     | Social proof, peer success stories      |
| **Reciprocal Determinism** | Behavior, person, and environment interact  | Ecosystem design, community features    |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Behavioral Designer   | Learning experience design         |
| Habit Formation Coach | Role model and community design    |
| Content Creator       | Tutorial and modeling content      |
| Product Strategist    | Social feature design              |
| Growth Hacker         | Viral loop and referral design     |

---

### 🆕 65. Operant Conditioning / Reinforcement Theory

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | B.F. Skinner                                                                    |
| **Purpose**       | Explains how consequences shape and reinforce behavior                         |
| **Official Docs** | Psychology research / B.F. Skinner Foundation                                  |
| **Maturity**      | Established (1938)                                                              |

#### Reinforcement Types

| Type                       | Description                                | Example                              |
| -------------------------- | ------------------------------------------ | ------------------------------------ |
| **Positive Reinforcement** | Add reward to increase behavior            | Points, badges, praise, bonuses      |
| **Negative Reinforcement** | Remove aversive stimulus to increase behavior | Remove ads after goal completion  |
| **Positive Punishment**    | Add aversive stimulus to decrease behavior | Error messages, fines, friction      |
| **Negative Punishment**    | Remove reward to decrease behavior         | Lose streak, reduced privileges      |

#### Reinforcement Schedules

| Schedule                | Description                              | Behavioral Effect                    |
| ----------------------- | ---------------------------------------- | ------------------------------------ |
| **Fixed Ratio**         | Reward every N responses                 | High rate, pause after reward        |
| **Variable Ratio**      | Reward after unpredictable N responses   | Highest rate — slot machine effect   |
| **Fixed Interval**      | Reward at predictable time intervals     | Scallop pattern, burst before reward |
| **Variable Interval**   | Reward at unpredictable time intervals   | Steady, persistent responding        |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Habit Formation Coach | Reward schedule design             |
| Behavioral Designer   | Gamification and loyalty systems   |
| Product Strategist    | Engagement loop design             |
| Growth Hacker         | Retention mechanism design         |
| Conversion Optimizer  | Incentive structure design         |

#### ⚠️ Ethical Considerations

- **NEVER** use variable ratio schedules to exploit addictive tendencies
- **ALWAYS** ensure rewards align with user wellbeing
- **NEVER** use punishment in ways that harm user dignity

---

### 🆕 66. Prospect Theory

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Daniel Kahneman & Amos Tversky                                                  |
| **Purpose**       | Describes how people make decisions under uncertainty and risk                 |
| **Official Docs** | [nobelprize.org/prizes/economic-sciences/2002/kahneman](https://www.nobelprize.org/prizes/economic-sciences/2002/kahneman/facts/) |
| **Maturity**      | Established (1979)                                                              |

#### Core Principles

| Principle              | Description                                      | Application                              |
| ---------------------- | ------------------------------------------------ | ---------------------------------------- |
| **Loss Aversion**      | Losses hurt ~2x more than equivalent gains feel good | Frame offers as avoiding loss         |
| **Reference Point**    | Outcomes evaluated relative to a reference       | Anchor pricing, show baseline            |
| **Diminishing Sensitivity** | Marginal utility decreases from reference   | Tiered pricing, bundle design            |
| **Probability Weighting** | Overweight small probabilities               | Sweepstakes, jackpot language            |

#### Value Function Implications

| Scenario               | Behavior                                         | Design Implication                       |
| ---------------------- | ------------------------------------------------ | ---------------------------------------- |
| Price Framing          | "$5 surcharge" feels worse than "5% fee"         | Use percentage framing for small amounts |
| Free Trial Expiry      | Losing access feels worse than not having it     | Endowment effect in trial design         |
| Bundling               | Losses are aggregated, gains are segregated      | Separate gains; bundle losses            |
| Default Options        | Opt-out leverages loss aversion                  | Default to desired behavior              |

#### Agents Using This Framework

| Agent                  | Application                        |
| ---------------------- | ---------------------------------- |
| Decision Architect     | Choice and pricing design          |
| Conversion Optimizer   | Offer framing and checkout         |
| Persuasion Specialist  | Message framing strategy           |
| Negotiation Specialist | Risk framing in negotiations       |
| Behavioral Designer    | Loss aversion-informed UX          |

---

### 🆕 67. Diffusion of Innovations

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Everett Rogers                                                                  |
| **Purpose**       | Explains how, why, and at what rate new ideas and technologies spread          |
| **Official Docs** | [diffusionofinnovations.com](https://www.diffusionofinnovations.com/)            |
| **Maturity**      | Established (1962, 5th edition 2003)                                            |

#### Adopter Categories

| Adopter Group      | % of Population | Characteristics                                |
| ------------------ | --------------- | ---------------------------------------------- |
| **Innovators**     | 2.5%            | Risk-tolerant, tech-savvy, first to try        |
| **Early Adopters** | 13.5%           | Opinion leaders, social respect, eager         |
| **Early Majority** | 34%             | Deliberate, influenced by peers                |
| **Late Majority**  | 34%             | Skeptical, adopt after social pressure         |
| **Laggards**       | 16%             | Traditional, last to adopt, change-resistant   |

#### Innovation Adoption Factors

| Factor                   | Description                                      |
| ------------------------ | ------------------------------------------------ |
| **Relative Advantage**   | Is it better than what it replaces?              |
| **Compatibility**        | Consistent with values and past experiences?     |
| **Complexity**           | Is it difficult to understand and use?           |
| **Trialability**         | Can it be tried on a limited basis?              |
| **Observability**        | Are results visible to others?                   |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| Product Strategist    | Go-to-market and adoption strategy |
| Growth Hacker         | User segment targeting             |
| Marketing Strategist  | Campaign phasing by segment        |
| Innovation Researcher | Technology adoption forecasting    |
| Change Management     | Organizational adoption planning   |

---

### 🆕 68. Emotional Design Model

| Attribute         | Details                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **Owner**         | Don Norman                                                                      |
| **Purpose**       | Framework for designing products that create emotional connections with users  |
| **Official Docs** | [Emotional Design (Basic Books)](https://www.nngroup.com/books/emotional-design/) |
| **Maturity**      | Established (2004)                                                              |

#### Three Levels of Emotional Design

| Level           | Description                                        | Design Focus                             |
| --------------- | -------------------------------------------------- | ---------------------------------------- |
| **Visceral**    | Immediate, pre-conscious reaction to appearance    | Aesthetics, color, shape, first impression|
| **Behavioral** | Usability and feel during interaction              | Ergonomics, ease, feedback, performance  |
| **Reflective**  | Post-hoc conscious evaluation and meaning          | Brand identity, nostalgia, self-image    |

#### Application Matrix

| Level        | Question to Ask                          | Design Elements                          |
| ------------ | ---------------------------------------- | ---------------------------------------- |
| Visceral     | Does it look and feel instantly appealing? | Visual design, motion, sound, texture  |
| Behavioral   | Is it satisfying and effortless to use?  | Micro-interactions, responsiveness, flow|
| Reflective   | Does it mean something to the user?      | Brand story, values, community, legacy  |

#### Agents Using This Framework

| Agent                 | Application                        |
| --------------------- | ---------------------------------- |
| UI Designer           | Visual and emotional design        |
| UX Researcher         | Emotional user research            |
| Behavioral Designer   | Experience emotion mapping         |
| Brand Guardian        | Brand emotional resonance          |
| Product Strategist    | Product positioning and meaning    |

---

## 📊 Framework-to-Agent Mapping Summary

| Framework                   | Total Agents | Primary Category        |
| --------------------------- | ------------ | ----------------------- |
| E-E-A-T                     | 5            | Search & Visibility     |
| OWASP Top 10                | 4            | Security                |
| TOGAF                       | 5            | Enterprise Architecture |
| GDPR                        | 5            | Security/Compliance     |
| Agile/Scrum                 | 6            | Product/Engineering     |
| Design Thinking             | 5            | Product/Design          |
| SEO Best Practices          | 8            | Search/Content          |
| A/B Testing                 | 4            | Product/Testing         |
| OKRs                        | 4            | Product/Management      |
| CI/CD                       | 4            | Engineering/DevOps      |
| NIST CSF                    | 5            | Security                |
| ISO 27001                   | 4            | Security                |
| DMBOK                       | 4            | Enterprise Architecture |
| Schema.org                  | 4            | Search                  |
| Core Web Vitals             | 4            | Search/Engineering      |
| **Cialdini's 6 Principles** | **6**        | **Behavior Science**    |
| **Fogg Behavior Model**     | **5**        | **Behavior Science**    |
| **Nudge Theory**            | **4**        | **Behavior Science**    |
| **Hook Model**              | **4**        | **Behavior Science**    |
| **COM-B Model**             | **4**        | **Behavior Science**    |
| **🆕 CCPA/CPRA**            | **5**        | **Security/Compliance** |
| **🆕 EU AI Act**            | **5**        | **Security/Compliance** |
| **🆕 ISO 42001**            | **5**        | **Enterprise/Compliance**|
| **🆕 SOX**                  | **4**        | **Security/Compliance** |
| **🆕 CIS Controls**         | **4**        | **Security**            |
| **🆕 DORA**                 | **5**        | **Security/Compliance** |
| **🆕 NIST SP 800-53**       | **4**        | **Security**            |
| **🆕 FedRAMP**              | **4**        | **Security/Compliance** |
| **🆕 LGPD**                 | **4**        | **Security/Compliance** |
| **🆕 TTM / Stages of Change**| **5**       | **Behavior Science**    |
| **🆕 Self-Determination Theory**| **5**    | **Behavior Science**    |
| **🆕 Dual Process Theory**  | **5**        | **Behavior Science**    |
| **🆕 SCARF Model**          | **4**        | **Behavior Science**    |
| **🆕 Theory of Planned Behavior**| **5**   | **Behavior Science**    |
| **🆕 Social Learning Theory**| **5**       | **Behavior Science**    |
| **🆕 Operant Conditioning** | **5**        | **Behavior Science**    |
| **🆕 Prospect Theory**      | **5**        | **Behavior Science**    |
| **🆕 Diffusion of Innovations**| **5**     | **Behavior Science**    |
| **🆕 Emotional Design Model**| **5**       | **Behavior Science**    |

---

## 🔗 Official Documentation Links

### Search & Visibility

- [Google Search Central](https://developers.google.com/search)
- [Schema.org](https://schema.org/)
- [web.dev](https://web.dev/)

### Security & Compliance

- [OWASP](https://owasp.org/)
- [NIST](https://www.nist.gov/)
- [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) 🆕
- [ISO](https://www.iso.org/)
- [ISO 42001](https://www.iso.org/standard/81230.html) 🆕
- [GDPR](https://gdpr.eu/)
- [CCPA/CPRA](https://oag.ca.gov/privacy/ccpa) 🆕
- [LGPD / ANPD](https://www.gov.br/anpd/pt-br) 🆕
- [MITRE ATT&CK](https://attack.mitre.org/)
- [CIS Controls](https://www.cisecurity.org/controls) 🆕
- [FedRAMP](https://www.fedramp.gov/) 🆕
- [EU AI Act](https://artificialintelligenceact.eu/) 🆕
- [DORA](https://www.digital-operational-resilience-act.com/) 🆕
- [SOX / SEC](https://www.sec.gov/about/laws/soa2002.pdf) 🆕

### Enterprise Architecture

- [The Open Group](https://www.opengroup.org/)
- [DAMA International](https://www.dama.org/)
- [ISACA](https://www.isaca.org/)
- [Business Architecture Guild](https://www.businessarchitectureguild.org/)

### Product & Research

- [IDEO](https://www.ideo.com/)
- [Stanford d.school](https://dschool.stanford.edu/)
- [Agile Alliance](https://www.agilealliance.org/)
- [Scrum.org](https://www.scrum.org/)

### Content & Marketing

- [AICPA](https://www.aicpa.org/)
- Platform guidelines (X, LinkedIn, Medium)

### Engineering & DevOps

- [Terraform](https://www.terraform.io/)
- [Kubernetes](https://kubernetes.io/)

### Design & UX

- [W3C WCAG](https://www.w3.org/WAI/WCAG/)
- [Nielsen Norman Group](https://www.nngroup.com/)
- [Atomic Design](https://atomicdesign.bradfrost.com/)

### Behavior Science & Persuasion

- [Cialdini.com](https://www.cialdini.com/)
- [BJ Fogg Behavior Model](https://bjfogg.com/)
- [Behavioural Insights Team](https://www.bi.team/)
- [Nir Eyal - Hooked](https://www.nirandfar.com/)
- [Behaviour Change Wheel](https://www.behaviourchangewheel.com/)
- [Jobs-to-be-Done](https://www.jobs-to-be-done.com/)
- [Transtheoretical Model (TTM)](https://web.uri.edu/cprc/transtheoretical-model/) 🆕
- [Self-Determination Theory](https://selfdeterminationtheory.org/) 🆕
- [Dual Process Theory / Kahneman](https://www.nobelprize.org/prizes/economic-sciences/2002/kahneman/facts/) 🆕
- [SCARF Model / NeuroLeadership](https://neuroleadership.com/) 🆕
- [Theory of Planned Behavior](https://people.umass.edu/aizen/tpb.html) 🆕
- [Social Learning Theory / Bandura](https://www.albertbandura.com/) 🆕
- [Diffusion of Innovations](https://www.diffusionofinnovations.com/) 🆕
- [Emotional Design / Don Norman](https://www.nngroup.com/books/emotional-design/) 🆕

---

## 📝 Version History

| Version | Date       | Changes                                                                 |
| ------- | ---------- | ----------------------------------------------------------------------- |
| 1.0     | 2026-03-01 | Initial framework documentation                                         |
| 2.0     | 2026-03-01 | Added GEO, AEO frameworks                                               |
| 3.0     | 2026-03-01 | Expanded security frameworks                                            |
| 4.0     | 2026-03-01 | Complete 40+ framework coverage                                         |
| 4.1     | 2026-03-01 | Added Behavior Science & Persuasion (8 frameworks)                      |
| 5.0     | 2026-04-01 | 🆕 Gap Analysis Update: +9 Compliance, +10 Behavioral (78 documented)  |
| 5.1     | 2026-04-21 | Maxim v1.0.0 launch reconciliation: 64 ship today, 18 deferred to v1.1/v1.2 — see [FRAMEWORK_ROADMAP.md](./FRAMEWORK_ROADMAP.md) |

---

**Last Updated:** 2026-04-21
**Version:** 5.1
**Maintained By:** Maxim framework library maintainers
**Shipping in v1.0.0:** 64 frameworks (63 SKILL.md + 1 proactive-watch.md)
**Deferred to roadmap:** 18 frameworks — see [FRAMEWORK_ROADMAP.md](./FRAMEWORK_ROADMAP.md) for v1.1 (compliance) and v1.2 (behavioral) schedule

---

This **documents/reference/FRAMEWORKS_MASTER.md** provides:

✅ **Complete documentation for all 40+ frameworks**  
✅ **Official documentation links** for each framework  
✅ **Agent-to-framework mapping** showing which agents use each framework  
✅ **Key components and principles** for every framework  
✅ **Framework maturity and ownership** information  
✅ **Cross-reference tables** for quick lookup  
✅ **Version history** for tracking updates
