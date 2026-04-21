# mxm-voice

Voice-driven executive office routing MCP server. Wraps [mbailey/voicemode](https://github.com/mbailey/voicemode) (Whisper STT + Kokoro TTS) with Maxim's hotword config and intent dispatch through executive-router.

**Maxim is the only multi-agent framework with native voice-driven executive office routing.**

## Tools

| Tool | Purpose |
|---|---|
| `voice_invoke_command(spoken_phrase)` | Match transcribed utterance against hotwords in `config/voice-phrases.yml` → return Maxim slash command to dispatch. Falls back to `/mxm-route` for unmatched. |
| `voice_brief_office(office)` | Return TTS-ready spoken summary for CEO/CTO/CMO/CSO/CPO/COO/CINO office. Caller pipes to voicemode for Kokoro playback. |
| `voice_capture_decision(transcript, context?)` | Append voice-captured decision to `.claude-sessions-memory/decision-log.md` with timestamp. |
| `voice_status` | Report VoiceMode install state, hotword count, config path. Use to debug "/mxm-voice not working". |

## Architecture

Maxim does NOT reimplement STT/TTS. It wraps mbailey/voicemode and adds:

1. **Hotword config** (`config/voice-phrases.yml`) — user-editable phrase → command mapping
2. **Wildcard + regex pattern matching** — handles natural-language variation
3. **Office-aware briefings** — TTS-friendly summaries per executive office
4. **Decision capture** — spoken decisions persisted to session memory
5. **Graceful degradation** — works with clear install instructions when voicemode isn't installed

Calls to voicemode itself (Whisper transcription, Kokoro speech synthesis) happen in the Claude Code host process, not in this server. This server is a routing/config layer.

## Install Prerequisites

This MCP server runs standalone (no voicemode required) but `voice_invoke_command` and `voice_brief_office` are most useful WITH voicemode installed:

```bash
# Required: VoiceMode plugin (handles actual STT + TTS)
claude plugin marketplace add mbailey/voicemode
claude plugin install voicemode@voicemode
/voicemode:install   # downloads Whisper + Kokoro models (~1-2 GB)
```

Without voicemode: `voice_status` reports it's missing and provides install command. Other tools still work — they just return text rather than playing audio.

## Configuration

### Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `MXM_ROOT` | repo root | Where to find `config/voice-phrases.yml` |
| `VOICEMODE_REQUIRED` | `false` | If `true`, tools refuse to run when voicemode is not detected |
| `VOICEMODE_SAVE_AUDIO` | `false` | Save audio recordings under `~/.voicemode/audio/` |

### Hotword Config Format (`config/voice-phrases.yml`)

```yaml
phrases:
  - pattern: "maxim run my project health check"
    dispatch: "/mxm-health"

  - pattern: "maxim draft a landing page *"
    dispatch: "/mxm-design landing page $1"

  - pattern: "maxim research * tell me how it improves *"
    dispatch: "/mxm-cino research $1 for $2"

  - pattern: "regex:^maxim (?:run )?wiki (?:ingest|ingestion)$"
    dispatch: "/mxm-wiki ingest"
```

Pattern types:
- **Plain string** — case-insensitive substring match
- **Wildcard `*`** — captured as `$1`, `$2`, etc. for substitution
- **`regex:<pattern>`** — JavaScript regex (case-insensitive)

User edits `voice-phrases.yml` freely. Maxim reloads it on every `voice_invoke_command` call.

## Run

```bash
node ./mcp/mxm-voice/server.js
```

Auto-discovered via root `.mcp.json` when opening the repo in any Claude surface.

## Behavior

- Unmatched utterances → `/mxm-route <spoken>` (executive-router classifies intent)
- Matched utterances → exact dispatch command returned
- Voice-captured decisions → appended to project's `decision-log.md` with timestamp
- Office briefings → return TTS-friendly summary text the host can pipe to voicemode

## License

Apache 2.0 (see repository root). Wraps mbailey/voicemode (MIT). Whisper (MIT). Kokoro (Apache 2.0).
