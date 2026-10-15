# maxim-runtime

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1.

Maxim's in-engine runtime for Claude Code, built on **function hooks** (Claude Code "mods"). It installs beside the `maxim` plugin and moves the parts of Maxim that work better inside the engine out of shell scripts and prompt instructions.

## Install

At the prompt of a terminal session:

```
/plugin install maxim-runtime@maxim-packs
```

From a shell:

```bash
claude plugin install maxim-runtime@maxim-packs
```

Restart Claude Code. Run `/maxim` to see what the runtime is doing.

## What it does

| Feature | What changes | How |
|---|---|---|
| Operating standard | Maxim's standard (confidence tagging, framework citation, office routing, CSO auto-loop) is part of the **system prompt**, not a session-start message that compaction can shorten | `prompt.compose` adds a `maxim-runtime:standard` section; the shell session-start hook's copy is trimmed to its per-session summary |
| Router (ADR-021) | Same keyword routing as the shell router (22/22 parity cases), plus a small-model classifier **only when the keywords are unsure**. The route shows in the **status line**; the model no longer prints a routing banner | `prompt.submit` adds the routing directive as context; for each prompt it handles, the shell router's directive is dropped. It takes over only once it has seen its classic hooks run, so where they do not (managed organizations) the shell router keeps routing alone |
| Junction guard | A Write, Edit or NotebookEdit that passes through a `.mxm-system` or `.claude` junction is **refused**, naming where the junction leads. A link higher up the path (a symlinked projects folder) and your own `~/.claude` (often a dotfiles symlink) are not treated as junction writes. Writes made by shell commands are not covered | `tool.call` on Write, Edit, NotebookEdit; real-path check at the junction-named folder |
| Secret-commit guard | A `git commit` whose staged diff (and, with `git add` / `-a` in the same command, the unstaged diff of tracked files) adds a secret is **refused**, naming the file and kind, never the value. A commit it cannot scan is refused too, with how to proceed. Git Bash paths (`cd /c/...`) are understood | `tool.call` on Bash; patterns ported from `.claude/hooks/pre-commit.sh`; works in every repository |
| CSO auto-loop | Editing a security-sensitive file (auth, payments, secrets, PII, licensing) adds a CSO review note the model reads, once per file per session, and a toast | `tool.call` result `context` |
| Confidence tags | A substantive answer (400+ characters) with no confidence tag is flagged with a toast and counted | `turn.complete` |
| `/maxim` | A pane and a summary of this session: Maxim version, standard, last route, guard refusals, CSO reviews, tag counts | `command.run`, `ui.render` |
| Framework lookup | `mcp__maxim-runtime__framework` reads Maxim's 85 framework definitions in-process, so it works even when the `mxm-behavioral` MCP server failed to connect | `$.tool.register` |

## Settings

Set in `/config` (or `pluginConfigs` in settings):

| Setting | Values | Default |
|---|---|---|
| `router` | `hybrid` (keywords, small-model fallback when unsure) · `keywords` (no model calls) · `off` | `hybrid` |
| `guards` | `true` · `false` | `true` |

A project can still opt out of routing with `.mxm-skills/router-off`, and `config/routing-table.json` `"enabled": false` turns routing off everywhere, as before.

## How it finds Maxim

The runtime reads Maxim's own files, so the routing table, the standard and the framework definitions have one source. It looks first for the source repository layout (`mods/maxim-runtime` inside the maxim repo) and then for the install cache (`<marketplace>/maxim/<newest version>` beside `<marketplace>/maxim-runtime/<version>`). If Maxim is not found, routing and the standard stay with the shell hooks and `/maxim` says so.

## Limits

- **Claude Code only.** Function hooks run in the CLI, the IDE extensions and the Claude Desktop app's Code tab. Desktop and Web Projects chat and Cowork do not run them; there the `maxim` plugin's shell hooks, skills and MCP servers work as before.
- **Needs a Claude Code version with function-hook support.** On an older version the runtime does not load and nothing changes.
- **Managed organizations.** Where an organization manages Claude Code, the system-prompt section and the classic-hook trimming run only for plugins listed in managed settings. The runtime notices that its classic hooks never run and leaves routing to the shell router; the shell session-start hook delivers the standard. Nothing is sent twice, and the guards, tag check, `/maxim` and framework tool still work.
- **Early-access API.** Claude Code's function-hook API may change between releases; the runtime is tested against the version named in the CHANGELOG.
- **The hybrid router makes one small-model call** for prompts the keywords cannot route, capped at four seconds. Use `keywords` to avoid model calls.
- **The secret guard** scans what `git diff` shows. Brand-new untracked files staged by `git add .` in the same command are not in that diff (stage first, then commit, and they are). The `maxim` pre-commit hook still covers repositories that install it.
- **The CSO note** is a heuristic on file and folder names; it adds a review request, never blocks.

## Development

```bash
claude plugin validate mods/maxim-runtime
claude plugin test mods/maxim-runtime
node --test mods/maxim-runtime/parity/router-parity.test.mjs
```

`claude plugin test` runs `tests/runtime.test.ts` (27 tests) in the engine with the world beneath the plugin mocked. The parity test runs the ported router and `.claude/hooks/user-prompt-router.sh` on the same prompts against the real `config/routing-table.json` and requires the same route; it needs bash, python3 and Node 22.18 or newer (TypeScript type stripping), and runs the shell router in a temporary folder.
