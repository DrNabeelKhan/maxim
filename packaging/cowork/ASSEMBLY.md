# Assembling maxim.plugin

> **How to build the `.plugin` file from the source repo.**
> Run this at release time, not on every commit. Output is published as a GitHub release artifact.

**Version:** v1.0.0 · **Build target:** Claude.ai Cowork plugin format

---

## Prerequisites

- Cloned maxim repo at tag `v1.0.0` (or `main`)
- Claude.ai Cowork account
- `cowork-plugin-management:create-cowork-plugin` skill OR the `cowork-plugin-customizer` skill
- Node.js 20+ (for any future JavaScript-based plugin validators)
- `zip` utility

---

## Build Steps

### Step 1 — Validate repo state

```bash
cd path/to/maxim
git status --porcelain   # must be empty (clean tree)
git describe --tags      # should report v1.0.0 (or candidate tag)
```

If dirty or on an untagged commit: do not proceed.

### Step 2 — Gather bundled assets

The plugin bundles a subset of the repo. Gather the following:

```bash
# Create build workspace
mkdir -p build/maxim-plugin
cd build/maxim-plugin

# Core manifest
cp ../../packaging/cowork/plugin.json .

# System prompt (used as Cowork plugin system prompt)
cp ../../maxim-project-instructions.md system_prompt.md

# Skills (20 of 34 — see skills/MANIFEST.md)
mkdir -p skills
for skill in ceo-automation engineering marketing security product studio-operations enterprise-architecture \
             brand design design-system ui-styling banner-design slides \
             behavior-science-persuasion compliance content-creation product-development-research \
             proactive-watch session-memory operator-profile; do
  cp -r ../../.claude/skills/$skill skills/
done

# Commands (14 of 37 — see commands/MANIFEST.md)
mkdir -p commands
for cmd in mxm-ceo mxm-cto mxm-cmo mxm-cso mxm-cpo mxm-coo mxm-cino mxm-route \
           mxm-watch mxm-session-end mxm-update mxm-release mxm-help mxm-status; do
  cp ../../.claude/commands/$cmd.md commands/
done

# Frameworks library (all 64 — read-only reference)
mkdir -p frameworks
cp -r ../../composable-skills/frameworks/. frameworks/

# MCP connector configs (7 servers)
mkdir -p mcp
for srv in mxm-context mxm-catalog mxm-behavioral \
           mxm-compliance mxm-memory mxm-portfolio mxm-voice; do
  if [ -d "../../mcp/$srv" ]; then
    cp -r ../../mcp/$srv mcp/
  fi
done

# Manifests (readable by Cowork UI)
cp ../../packaging/cowork/skills/MANIFEST.md skills/MANIFEST.md
cp ../../packaging/cowork/commands/MANIFEST.md commands/MANIFEST.md

# License + attribution
cp ../../LICENSE .
cp ../../packaging/cowork/README.md .
```

### Step 3 — Rewrite frontmatter for Cowork schema

Cowork plugins use a slightly different YAML frontmatter schema than Claude Code's `.claude/skills/`. Run the adapter:

```bash
# Adapter script (ships in repo at bootstrap/cowork-adapter.mjs)
node ../../bootstrap/cowork-adapter.mjs skills/
node ../../bootstrap/cowork-adapter.mjs commands/
```

The adapter:
- Converts `triggers:` YAML list → Cowork `activations:` block
- Merges `collaborates_with:` → Cowork's connector graph
- Strips executable-hook references (Cowork doesn't run hooks)
- Rewrites relative paths (`../../composable-skills/...`) → intra-plugin paths (`frameworks/...`)

*(The adapter script itself is a v1.0.0 deliverable. In v1.0.0 this is a manual find/replace step — see `MIGRATION_NOTES.md` below.)*

### Step 4 — Validate

```bash
# Structural validation
node ../../bootstrap/cowork-validator.mjs .   # v1.0.0+

# Manual spot-checks
cat plugin.json | jq .capabilities   # skills=20, commands=14, mcp=7
ls skills/ | wc -l                    # should be 20
ls commands/ | wc -l                  # should be 14 (excluding MANIFEST.md) + 1 manifest = 15
```

### Step 5 — Assemble

```bash
# Pack as .plugin (which is just a .zip with specific extension)
cd build
zip -r maxim-v1.0.0.plugin maxim-plugin/ -x '*.DS_Store' -x '*__pycache__*'
# Output: build/maxim-v1.0.0.plugin
```

### Step 6 — Test install

Before publishing:

1. Open Claude.ai Cowork
2. Settings → Plugins → Install from file → select `maxim-v1.0.0.plugin`
3. Restart the session
4. Test:
   - Type `/mxm-cmo` — should activate CMO office
   - Ask "scan this for AI tells" — should invoke `content-creation` + .brand-foundation scan
   - Ask "audit for drift" — should activate `proactive-watch` (advisory in Cowork)
   - Request payment/auth work — should trigger CSO auto-loop
5. Verify confidence tagging appears on every output

### Step 7 — Publish

```bash
# Create GitHub release
gh release create v1.0.0 ./build/maxim-v1.0.0.plugin \
  --title "Maxim v1.0.0 — Cowork Plugin" \
  --notes-file ../../CHANGELOG.md
```

Users download the `.plugin` from the release page.

---

## Migration Notes (Manual Adapter for v1.0.0)

Until `bootstrap/cowork-adapter.mjs` ships in v1.0.0, perform the YAML rewrites manually:

### Per skill in `skills/`

```yaml
# Before (Claude Code format)
---
skill_id: proactive-watch
triggers:
  - "session start (light phase)"
  - "/mxm-watch command"
collaborates_with:
  - executive-router
---

# After (Cowork format)
---
name: proactive-watch
activations:
  keywords: ["audit", "watch", "drift", "health check"]
  commands: ["/mxm-watch"]
connectors: ["executive-router"]
---
```

### Per command in `commands/`

Keep `.md` frontmatter mostly intact, but:
- Replace `framework: composable-skills/frameworks/proactive-watch.md` → `framework: frameworks/proactive-watch.md`
- Remove `adr:` field (Cowork manifest doesn't recognize)

This manual step will be automated in v1.0.0.

---

## What Ships vs What Doesn't

| Asset | In Plugin | Notes |
|---|---|---|
| `.claude/skills/` (20 of 34) | ✅ | See `skills/MANIFEST.md` |
| `.claude/commands/` (14 of 37) | ✅ | See `commands/MANIFEST.md` |
| `composable-skills/frameworks/` (all 64) | ✅ | Full reference library |
| `mcp/` servers (7 post-consolidation) | ✅ | As connector configs |
| `.claude/hooks/` | ❌ | No hook runtime in Cowork |
| `config/project-manifest.json` | ❌ | Per-project file, not plugin |
| `agents/MXM/` (88 agent MDs) | ❌ | Agents are skill-internal references |
| `community-packs/` (claude-skills, UI library) | ❌ | Optional; bloats plugin size |
| `.brand-foundation/personal/` | ❌ | User-specific; must upload |
| `documents/ADRs/` | ❌ | Project governance; user uploads if needed |
| `documents/business/` | ❌ | Per-project sales/marketing content |

---

## Plugin Size Budget

Target: `.plugin` file < 10 MB for fast Cowork install.

Current estimated size (v1.0.0):
- 20 skills: ~800 KB
- 14 commands: ~100 KB
- 64 frameworks: ~2 MB
- 7 MCP configs: ~50 KB
- System prompt + manifests + README: ~50 KB
- **Total: ~3 MB** (under budget)

If size grows > 10 MB in future releases, review framework inclusion policy.

---

## Release Cadence

Plugin releases **lock to maxim repo tags**. Every `v*.*.*` repo tag produces a matching plugin release. The release checklist in `/mxm-release` includes a "rebuild Cowork plugin" step (as of v1.0.0).

For patch releases that touch only skills bundled in the plugin, a patch plugin release ships within 24h. For releases that touch only non-bundled code, no plugin release is needed.

---

## Related

- `packaging/cowork/README.md` — plugin overview for end users
- `packaging/cowork/plugin.json` — plugin manifest
- `packaging/cowork/skills/MANIFEST.md` — bundled skills list
- `packaging/cowork/commands/MANIFEST.md` — bundled commands list
- `documents/cross-surface/maxim-surface-guide.md` — three-tier deployment overview
- `cowork-plugin-management:create-cowork-plugin` — skill for plugin creation
- `cowork-plugin-management:cowork-plugin-customizer` — per-org customization
