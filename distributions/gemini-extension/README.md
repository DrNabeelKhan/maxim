# Maxim — Gemini Extension (Placeholder)

**Status:** Not yet implemented. Spec pending Google Gemini for Workspace extension API stabilization.

## Planned scope

- Mirror canonical `agents/`, `.claude/skills/`, `mcp/` into Gemini Workspace extension format
- Map Maxim office routing commands to Gemini conversation commands
- Compliance + governance hooks adapted for Gemini tool-use API

## Reference

- Gemini for Workspace extension spec: [developers.google.com/workspace/gemini/extensions](https://developers.google.com/workspace/gemini/extensions)
- Canonical Maxim source: `.claude/`, `agents/`, `mcp/` at repo root
- Build infrastructure: `bootstrap/build-claude-plugin.ps1` (Claude Code distribution, reference for patterns)

## When this ships

On v7.0+ multi-distribution roadmap. Implementation begins after Claude Code marketplace launch confirms the build-and-mirror pattern is sound.
