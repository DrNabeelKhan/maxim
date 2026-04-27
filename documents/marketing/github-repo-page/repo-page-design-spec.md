# GitHub Repo Page — Design Specification v1

**Status:** DRAFT — awaiting content lock with free-tier spec v1.2
**Target ship:** v1.0.0 Discovery release (paired with landing site + Show HN + npm publish)
**Repo:** `github.com/DrNabeelKhan/maxim`
**Dependencies:** free-tier spec v1.2 locked, landing page at maxim.isystematic.com live

---

## 0. Purpose

The GitHub repo page is the **primary technical discovery surface**. Developers decide in 10 seconds whether to star, clone, or close. The page must:

1. Communicate moat in 10 seconds (hero + badges)
2. Show a working install inside 60 seconds of reading
3. Link clearly to landing site for buyers
4. Pass the "drive-by dev" test — does a skeptical engineer who knows LangGraph think this is real?
5. Rank on "claude agent framework", "claude governance", "MCP multi-agent" searches via GitHub Topics + README SEO

---

## 1. Page Components (GitHub surfaces)

```
github.com/DrNabeelKhan/maxim
├── Repo metadata (About section, Topics, website link, description)
├── Social preview image (1280×640 PNG; what shows in Twitter/LinkedIn shares)
├── README.md  ← primary content
├── LICENSE (BSL 1.1 for core/)
├── CODE_OF_CONDUCT.md
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   ├── feature_request.yml
│   │   └── compliance_question.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── CONTRIBUTING.md
│   ├── SECURITY.md
│   ├── FUNDING.yml (optional — GitHub Sponsors)
│   └── workflows/
│       └── mxm-validate.yml (existing)
├── Releases tab (auto-populated from tags)
└── Discussions tab (GitHub-native community)
```

---

## 2. Repo Metadata

### About section (gear icon → Edit repository details)

**Description** (350 char max):
> The Claude-native operating system. 90 governed agents across 7 executive offices. 64 behavioral frameworks. 14 compliance frameworks. Continuous drift detection. Documents as Executable Contracts. One `git pull` updates every project.

**Website:** `https://maxim.isystematic.com`

**Topics** (use all 20 slots):
```
claude, claude-code, claude-agent-skills, mcp, model-context-protocol,
multi-agent, agent-framework, ai-governance, compliance-automation,
behavioral-science, gdpr, hipaa, pipeda, agentic-ai, rag,
ai-operating-system, claude-native, anthropic, llm-orchestration,
canadian-tech
```

### Repo settings
- **Packages:** disable (not relevant for MD framework)
- **Environments:** disable
- **Wikis:** disable (README is canonical)
- **Discussions:** **enable** — primary community surface pre-Discord
- **Issues:** enable with templates (see §6)
- **Projects:** enable (public roadmap — see §7)
- **Sponsorships:** decide per concern #4 ($25K net profit gate)

### Social preview image
- 1280×640 PNG, <1 MB
- Dark background (matches landing), emerald accent
- Maxim logo + "The Claude-native operating system for AI-assisted work"
- Key numbers: `90 agents · 64 frameworks · 14 compliance · one git pull`
- No stock photos, no AI faces

---

## 3. README.md Structure

The README is the GitHub-native document. It must render clean in GitHub's markdown engine AND in any clone/dev tool that opens it.

### Section order (top to bottom)

1. **Hero block** — logo, badges, 1-line positioning, primary CTA
2. **Quick demo** — 60-second terminal GIF or screenshot
3. **Value statement** — 3 bullets: what Maxim is / what it's not / who it's for
4. **Install in 60 seconds** — copy-paste code block
5. **Capability summary** — numeric moat table (pulls from documents/ledgers/AGENT_SKILL_INVENTORY.md)
6. **Featured capabilities** — 6 highlighted capabilities with screenshots
7. **Documentation** — links out to landing + full docs
8. **Free vs Premium** — pack catalog summary with CTA to landing
9. **How it works** — 5-layer dispatch diagram
10. **Why Claude-native?** — positioning addressing the "multi-LLM?" question
11. **Community** — Discussions, Discord (if ready), Twitter
12. **Contributing** — link to CONTRIBUTING.md + BSL license note
13. **Canonical ledgers** — links to the 5 ledgers (transparency hook)
14. **Changelog** — link to CHANGELOG.md + latest release badge
15. **License** — BSL 1.1 for core, proprietary for packs
16. **Acknowledgements** — community-packs/ subtree attribution

**Target length:** ~250–350 lines rendered. Scrollable but comprehensive.

### Badges (top of README, horizontal row)

```markdown
[![Version](https://img.shields.io/badge/version-v1.0.0-emerald)](CHANGELOG.md)
[![License Core](https://img.shields.io/badge/core-BSL--1.1-blue)](LICENSE)
[![License Packs](https://img.shields.io/badge/packs-Proprietary-red)](LICENSE.pack.md)
[![Agents](https://img.shields.io/badge/agents-90%20(100%25%20Grade%20A)-emerald)](documents/ledgers/AGENT_SKILL_INVENTORY.md)
[![Skills](https://img.shields.io/badge/skills-34%20domains-emerald)](documents/ledgers/AGENT_SKILL_INVENTORY.md)
[![Frameworks](https://img.shields.io/badge/frameworks-64-emerald)](documents/reference/FRAMEWORKS_MASTER.md)
[![Compliance](https://img.shields.io/badge/compliance-14%20frameworks-emerald)](mcp/mxm-compliance/)
[![MCP](https://img.shields.io/badge/MCP-7%20servers%20%C2%B7%2047%20tools-emerald)](mcp/)
[![Claude](https://img.shields.io/badge/Claude-native-orange)](#why-claude-native)
[![PRs](https://img.shields.io/badge/contributions-welcome-purple)](.github/CONTRIBUTING.md)
```

### Hero block copy

```markdown
<h1 align="center">
  <img src="documents/assets/mxm-logo.svg" alt="Maxim" width="120"/>
  <br>
  Maxim
</h1>

<p align="center">
  <b>The Claude-native operating system for AI-assisted work.</b><br>
  90 governed agents · 64 behavioral frameworks · 14 compliance frameworks<br>
  Continuous drift detection · Documents as Executable Contracts · One <code>git pull</code>
</p>

<p align="center">
  <a href="https://maxim.isystematic.com">Website</a> ·
  <a href="#quick-install">Install</a> ·
  <a href="#the-moat">Moat</a> ·
  <a href="https://maxim.isystematic.com/packs">Packs</a> ·
  <a href="CHANGELOG.md">Changelog</a>
</p>
```

### Quick demo

Option A — Animated GIF (`documents/assets/mxm-demo.gif`, <3 MB, <30s loop):
- Open terminal
- `/mxm-cto build a GDPR-compliant auth system`
- CSO auto-loop fires
- Compliance verdict, agent handoff chain, output tagged 🟢

Option B — Static screenshot + "play full demo" link to YouTube.

**My lean: start with static screenshot (Option B) to avoid GitHub caching issues with large GIFs. Upgrade to GIF if engagement data warrants.**

### Install section

````markdown
## 🚀 Install in 60 Seconds

```bash
# Clone the repo
git clone https://github.com/DrNabeelKhan/maxim.git
cd maxim

# Install globally (Windows — as Administrator)
.\bootstrap\install-global.ps1

# Or on Mac/Linux/WSL
./bootstrap/new-project-setup.sh

# Bootstrap your first project
.\bootstrap\link-local-project.ps1 -ProjectPath "C:\Projects\MyProject"

# Verify
/mxm-status

# Start working
/mxm-route "describe what you need — Maxim figures out the rest"
```

**What just happened:** four symlinks from `~/.claude/` point at this repo. Every project you bootstrap inherits the full framework. `git pull` updates every project. Zero duplication.

See the full install guide → [`documents/guides/GETTING_STARTED.md`](documents/guides/GETTING_STARTED.md)
````

### Capability summary table

Pull from `documents/ledgers/AGENT_SKILL_INVENTORY.md`. Stable numbers.

```markdown
## 📊 Capability Surface

| Category | Count | Source |
|---|---:|---|
| Specialist Agents | 90 (100% Grade A DNA) | [`agents/MXM/`](agents/MXM/) |
| Skill Domains | 34 | [`.claude/skills/`](.claude/skills/) |
| Slash Commands | 37 | [`.claude/commands/`](.claude/commands/) |
| MCP Servers | 7 (47 tools) | [`mcp/`](mcp/) |
| Behavioral Frameworks | 64 | [`composable-skills/frameworks/`](composable-skills/frameworks/) |
| Compliance Frameworks | 14 | [`mcp/mxm-compliance/`](mcp/mxm-compliance/) |
| Executable Hooks | 10 | [`.claude/hooks/`](.claude/hooks/) |
| Architecture Decision Records | 2+ accepted | [`documents/ADRs/`](documents/ADRs/) |
| Canonical Ledgers | 5 | See §"Canonical Ledgers" |
```

### Featured capabilities (6 cards)

Each capability = `### Heading` + 2-sentence summary + small screenshot + link-out.

1. **Executive Offices Architecture** → 7 offices with 90 governed agents
2. **CSO Auto-Loop** → non-bypassable compliance gate
3. **Proactive Watch** → continuous drift detection at SessionStart
4. **Documents as Executable Contracts** → ADR-002 meta-principle
5. **Voice Mode** → Whisper STT + Kokoro TTS via MCP
6. **Cross-Surface Deployment** → 100% CLI / 85% Cowork / 60% Web-Desktop

### Documentation links

```markdown
## 📚 Documentation

- **Full docs:** [maxim.isystematic.com/docs](https://maxim.isystematic.com/docs)
- **Getting started:** [documents/guides/GETTING_STARTED.md](documents/guides/GETTING_STARTED.md)
- **Help:** [documents/guides/HELP.md](documents/guides/HELP.md)
- **Skills map:** [documents/reference/SKILLS_MAP.md](documents/reference/SKILLS_MAP.md)
- **Frameworks master:** [documents/reference/FRAMEWORKS_MASTER.md](documents/reference/FRAMEWORKS_MASTER.md)
- **Architecture:** [CLAUDE.d/](CLAUDE.d/) and [documents/ADRs/](documents/ADRs/)
- **For contributors:** [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
```

### Free vs Premium section

```markdown
## 🆓 Free vs 🔒 Premium

Maxim's core is free and open (BSL 1.1 — converts to Apache 2.0 in 4 years).
Premium packs unlock specific depth without touching the free floor.

| Tier | Use for | Price |
|---|---|---|
| **Free (core/)** | Solo developer projects, learning Maxim, multi-project governance | $0 |
| **Compliance Shield** | Regulated industry — GDPR, HIPAA, PIPEDA, SOC2 enforcement | $79/mo |
| **Behavioral Intelligence** | Output quality via 64 structurally-dispatched frameworks | $59/mo |
| **MemPalace Pro** | Cross-project semantic memory + Proactive Watch FULL phase | $49/mo |
| **Vertical OS** | Healthcare / Legal / Fintech / GovTech agent clusters | $199 one-time |
| **Brand & Design Pro** | Brand voice enforcer + archetype selector + audits | $39/mo |
| **Agency Command** | White-label multi-client deployment | $499/mo |

Full pack catalog → [maxim.isystematic.com/packs](https://maxim.isystematic.com/packs)
```

### How Maxim works (5-layer dispatch diagram)

```markdown
## 🔧 How Maxim Works

Maxim dispatches every task through a deterministic 5-layer sequence:

```
Layer 1: .claude/skills/          ← Maxim domain skills (supreme authority)
Layer 2: community-packs/claude-skills-library/  ← vendored deep knowledge (MIT, read-only)
Layer 3: composable-skills/       ← workflow engine (TDD, debugging, planning)
Layer 4: agents/MXM/{office}/    ← 90 specialist agents across 7 offices
Layer 5: behavioral + compliance  ← CLAUDE.md universal + 64 frameworks + 14 regulations
```

Every task touches every layer. Layer 1 always wins on conflict. No hallucinated routing.
```

### Why Claude-native

Acknowledge the "why not multi-LLM?" question upfront; turn it into positioning.

```markdown
## 🟠 Why Claude-Native?

Maxim is Claude-exclusive by design, not accident. The depth comes from Claude-specific
integrations: CLAUDE.md, Agent Skills, MCP, 10 executable hooks, cross-surface packaging
across Claude Code / Desktop / CLI / Dispatch / Cowork / Web Projects.

Abstracting the LLM layer would dilute that depth without opening any buyer segment that
CrewAI and LangGraph don't already own. Maxim is Xcode; LangGraph is VS Code.

If you need multi-LLM orchestration, use LangGraph or CrewAI. If you need governed depth
on Claude, use Maxim.
```

### Canonical ledgers section

Shows off the documents-as-contracts discipline — rare on public repos.

```markdown
## 📋 Canonical Ledgers

Maxim ships with 5 living ledgers under [ADR-002 Executable Contracts](documents/ADRs/ADR-002-executable-contracts.md).
Drift between any ledger and reality blocks commits:

- [`documents/ledgers/AGENT_SKILL_INVENTORY.md`](documents/ledgers/AGENT_SKILL_INVENTORY.md) — capability counts (critical contract)
- [`CHANGELOG.md`](CHANGELOG.md) — release history
- [`documents/ledgers/MOAT_TRACKER.md`](documents/ledgers/MOAT_TRACKER.md) — defensibility + feature timeline
- [`BUG_TRACKER.md`](BUG_TRACKER.md) — recurring-pattern registry
- [`documents/ledgers/DEBUGGING_PLAYBOOK.md`](documents/ledgers/DEBUGGING_PLAYBOOK.md) — append-only debugging journal

Plus an ADR ledger at [`documents/ADRs/`](documents/ADRs/) for every non-reversible decision.
```

### License section

```markdown
## 📜 License

Maxim core (`core/` and everything at repo root except `packs/`) is licensed under the
**Business Source License 1.1** ([LICENSE](LICENSE)). Non-production use permitted.
Converts to Apache License 2.0 on 2030-04-19.

Maxim premium packs (anything under `packs/`) are proprietary. All rights reserved.
See [LICENSE.pack.md](LICENSE.pack.md) for terms.

External libraries under [`community-packs/`](community-packs/) retain their upstream MIT / Apache
licenses. See individual subtree LICENSE files.

Maxim content is under active registration with the Canadian Intellectual Property
Office. Unauthorized redistribution may result in liability for statutory damages
up to $20,000 per work under the Copyright Act of Canada, plus liquidated damages
of $10,000 CAD per incident under the Maxim Premium Pack License.
```

### Acknowledgements

```markdown
## 🙏 Acknowledgements

Maxim vendors and composes several MIT-licensed libraries. Shoutout to their authors:

- **[VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md)** —
  59 brand DESIGN.md templates
- **[alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills)** —
  536 SKILL.md reference library
- **[nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)** —
  UI/UX databases + search engine
- **[OSideMedia/higgsfield-ai-prompt-skill](https://github.com/OSideMedia/higgsfield-ai-prompt-skill)** —
  Cinematic technical prompt reference (camera, motion, audio vocabulary)
- **[mbailey/voicemode](https://github.com/mbailey/voicemode)** —
  Voice Mode wrapper powering `/mxm-voice`
- **[MemPalace](#)** — knowledge graph backend powering `/mxm-wiki`
- **[claude-mem](#)** — persistent cross-session memory
```

---

## 4. Issue Templates (`.github/ISSUE_TEMPLATE/`)

### bug_report.yml

Structured YAML form. Required fields:
- Version of Maxim (v6.4.X)
- OS + shell
- Which skill/agent/command triggered the bug
- Steps to reproduce
- Expected vs actual
- Relevant logs from `.mxm-skills/watch-report.jsonl`

### feature_request.yml
- Use case
- Proposed solution
- Which office/skill/agent this would live under
- Would it be free or premium?

### compliance_question.yml

Dedicated path. Compliance questions get routed to a label for CSO office review.
- Jurisdiction
- Framework (GDPR / HIPAA / etc.)
- Your use case
- What Maxim said vs what you expected

### Config file

`.github/ISSUE_TEMPLATE/config.yml`:
```yaml
blank_issues_enabled: false
contact_links:
  - name: Pack support (paying customers)
    url: mailto:https://maxim.isystematic.com/contact
    about: If you have an active pack license, email support directly.
  - name: Security vulnerability
    url: https://github.com/DrNabeelKhan/maxim/security/advisories/new
    about: Report security issues privately via GitHub Security Advisories.
  - name: Ask a question
    url: https://github.com/DrNabeelKhan/maxim/discussions/new?category=q-a
    about: Use Discussions for usage questions, architecture chats, etc.
```

---

## 5. PR Template (`.github/PULL_REQUEST_TEMPLATE.md`)

```markdown
## Summary

<!-- What does this PR change and why? -->

## Change type
- [ ] Bug fix
- [ ] New feature
- [ ] Refactor (no behavior change)
- [ ] Documentation
- [ ] Critical Contract update (requires ADR — see CLAUDE.d/protocols.md)

## ADR impact
<!-- Does this change require a new ADR? Update an existing ADR? -->
- [ ] No ADR impact
- [ ] New ADR attached (path: documents/ADRs/ADR-XXX-<slug>.md)
- [ ] Existing ADR superseded (path: documents/ADRs/ADR-XXX.md)

## Critical Contract touched
- [ ] `documents/ledgers/AGENT_SKILL_INVENTORY.md`
- [ ] `config/agent-registry.json`
- [ ] `CHANGELOG.md`
- [ ] `documents/ledgers/MOAT_TRACKER.md`
- [ ] `CLAUDE.md` or `CLAUDE.d/`
- [ ] None

## Proactive Watch
- [ ] I ran `/mxm-watch` and drift is clean (or documented exceptions)

## Session-end discipline
- [ ] I ran `/mxm-session-end` before opening this PR
- [ ] CHANGELOG.md has an entry for this change
```

---

## 6. SECURITY.md

```markdown
# Security Policy

## Supported Versions

Only the latest minor release receives security updates.

| Version | Status |
|---------|--------|
| v6.4.x  | ✅ Current |
| < v6.4  | ❌ Unsupported |

## Reporting a Vulnerability

**Do not open public GitHub issues for security concerns.**

Report privately via:
1. [GitHub Security Advisories](https://github.com/DrNabeelKhan/maxim/security/advisories/new)
2. Email: https://maxim.isystematic.com/contact (PGP key on request)

We target a 72-hour acknowledgement, 14-day initial triage, and public disclosure
only after a fix ships. We do not operate a bug bounty at this time; we DO offer
credit in release notes and a reference letter.

## Scope

In scope:
- Maxim core (`core/`)
- Pack engine (`pack-engine/`)
- License validation logic
- MCP servers under `mcp/`
- Installation scripts under `bootstrap/`

Out of scope:
- External/vendored libraries (report upstream)
- Third-party MCP servers
- Claude Code / Anthropic API itself (report to Anthropic)
- License key sharing / redistribution (this is a legal matter, not a security vuln — see pack license)
```

---

## 7. Community (Discussions + Roadmap)

### GitHub Discussions — enable with these categories

- **Announcements** — release notes, breaking changes
- **Q&A** — usage questions (responses earn a rep point)
- **Ideas** — feature ideas (may graduate to feature_request issues)
- **Compliance Clinic** — async compliance Q&A (positions CSO office as expert)
- **Show & Tell** — user showcases (social proof channel)
- **Pack Feedback** — premium pack feedback (paying customers)

Pin a post at top of each category explaining rules.

### Public Roadmap (GitHub Projects)

Columns: Backlog / Sprint / In Progress / Done / Released.
Link from README: `See the roadmap →`.
Only surface user-facing features (not internal refactors).

---

## 8. Social Preview Image Spec

1280×640 PNG, <1 MB, PNG-optimized.

**Content:**
- Top-left: Maxim logo
- Center: headline "The Claude-native operating system" with subhead "90 agents · 64 frameworks · 14 compliance · Documents as Executable Contracts"
- Bottom-right: github.com/DrNabeelKhan/maxim
- Dark background, emerald accent, Inter Medium 48pt for headline, 24pt for subhead
- Subtle grid pattern or circuit-board texture

Deliverable: `documents/assets/og-image.png` + alt text for accessibility.

---

## 9. Pre-launch Checklist

- [ ] README.md reads clean top-to-bottom on GitHub
- [ ] All badge links resolve to real pages
- [ ] Social preview image uploaded in repo settings
- [ ] Topics set (20 slots)
- [ ] About description + website populated
- [ ] Discussions enabled with category templates
- [ ] Issue templates render correctly in new-issue flow
- [ ] SECURITY.md links work
- [ ] CONTRIBUTING.md references BSL 1.1 correctly
- [ ] CODE_OF_CONDUCT.md present (Contributor Covenant v2.1 recommended)
- [ ] LICENSE file contains BSL 1.1 for core/
- [ ] LICENSE.pack.md contains proprietary terms
- [ ] `mxm-validate.yml` CI badge green on main
- [ ] No leaked credentials in history (secret scanning enabled post history-sanitization)
- [ ] Historical v4–v1.0.0 tags removed per §11 free-tier spec
- [ ] Latest release (v1.0.0) published with release notes

---

## 10. Launch Coordination

**T-14d:** Landing site staged, README locked, assets uploaded
**T-7d:** Internal review pass — drive-by dev test (ask engineer friend to "review this in 10 sec")
**T-2d:** Final build — CI green, Proactive Watch clean, tag v1.0.0
**T-0 (launch morning):**
1. Tag v1.0.0
2. Force-push orphan main per history sanitization plan
3. Upload social preview image
4. Publish Release notes
5. Post Show HN (9 AM EST Tuesday–Thursday)
6. Post Twitter launch thread (10 AM EST)
7. Submit to MCP registry
8. npm publish (if applicable)
9. Post to /r/ClaudeAI, /r/LocalLLaMA
10. Send ProductHunt teaser for Day +7 launch

---

## 11. Decisions Needed (from you)

### GitHub-Q1. Enable GitHub Sponsors now or at $25K net profit threshold?
Playbook concern #4 defers IP spend to $25K; Sponsors is $0 setup cost and can accept one-time donations. My lean: **enable Sponsors with a "fund Maxim" button** from day 1 — small side-revenue stream, validates willingness-to-pay signal before pack launch.

### GitHub-Q2. Public roadmap on GitHub Projects — yes/no?
My lean: **yes, minimal**. Just user-facing features, 5 columns, light maintenance. Signals momentum.

### GitHub-Q3. Discussions vs Discord for community?
Concern #4 defers Discord. My lean: **GitHub Discussions only for launch**. Add Discord after 100+ active Discussion participants.

### GitHub-Q4. npm publish as `maxim` or `@dr-nabeel-khan/maxim`?
Unscoped package = cleaner `npm install maxim` command. Scoped = safer if naming collision occurs.
My lean: **unscoped `maxim`**. Secure the name at launch; trademark unimportant at this tier.

### GitHub-Q5. Issue templates — include a "compliance question" template or keep issues narrowly bug+feature?
My lean: **include compliance template**. Makes Maxim look enterprise-ready; filters noise.

### GitHub-Q6. `FUNDING.yml` — link to GitHub Sponsors only, or also LemonSqueezy pack purchase page?
My lean: **GitHub Sponsors only**. Pack purchase lives on landing site; mixing them feels pushy on GitHub.

### GitHub-Q7. Logo and visual identity — commission designer now or ship with text-only logo?
My lean: **text-only logo for v1.0.0 launch**. `Maxim` in Inter Bold is a legitimate brand mark at this stage. Hire a designer post-Pack-1-revenue.

---

## 12. Approval Checklist

- [ ] §1 page components approved
- [ ] §2 About description + 20 topics approved
- [ ] §3 README section order + copy approved
- [ ] §3 badges approved
- [ ] §3 hero block copy locked
- [ ] §3 capability table pulls from documents/ledgers/AGENT_SKILL_INVENTORY.md automatically
- [ ] §3 Free vs Premium table matches free-tier spec v1.2
- [ ] §3 Acknowledgements list complete and accurate
- [ ] §4 issue templates approved
- [ ] §5 PR template approved
- [ ] §6 SECURITY.md approved
- [ ] §7 Discussions categories + public roadmap approved
- [ ] §8 social preview image spec approved
- [ ] §9 pre-launch checklist feasible
- [ ] §10 launch coordination sequence approved
- [ ] §11 GitHub-Q1 through Q7 answered

---

*GitHub Repo Page — Design Specification v1 (DRAFT) — 2026-04-19*
*Authored by: Claude (session S26)*
*Awaiting approval from: DrNabeelKhan*
*Content dependencies: free-tier spec v1.2 (lock counts), landing page spec v1, IP architecture v1*
