# Maxim Plugin Binaries

This directory holds compiled binaries shipped with the Maxim Claude Code plugin. Binaries themselves are gitignored (`*.exe`) and produced by `bootstrap/build-claude-plugin.ps1`.

## Shipped Binaries

### `mxm-pack-engine.exe` (or `mxm-pack-engine` on Mac/Linux)

Maxim commercial pack runtime. Decrypts encrypted pack content (`.md.enc` AES-256-GCM) given a valid JWT license, with owner-key bypass for machine-bound OWNER-1 keys.

**Source:** `pack-engine/` at the maxim repo root (Go module `github.com/DrNabeelKhan/mxm-pack-engine`).

**Subcommands:**

| Subcommand | Purpose |
|---|---|
| `mxm-pack-engine activate --license <JWT>` | Cache a LemonSqueezy-issued JWT to `~/.mxm-packs/license.jwt` |
| `mxm-pack-engine refresh` | Re-authenticate against `/license/refresh` endpoint |
| `mxm-pack-engine fingerprint` | Print the machine fingerprint used for owner-key binding |
| `mxm-pack-engine decrypt <pack>` | Decrypt a purchased pack using the cached JWT |

## Build Process

The plugin build script (`bootstrap/build-claude-plugin.ps1`) handles compilation:

```powershell
# From maxim repo root:
.\bootstrap\build-claude-plugin.ps1
```

The script runs `go build` inside `pack-engine/`, then copies the resulting binary here. Binaries are cross-compiled for the host platform. Multi-platform distribution (Windows amd64 / Mac arm64 / Linux amd64) happens at marketplace-release time.

## What Is Not Shipped

### `mxm-owner-keygen`

Owner-key generation is an internal tool for Maxim pack maintainers. It lives in the private `mxm-packs-source` repo at `bootstrap/mxm-owner-keygen-bootstrap.{ps1,sh}` and is not bundled with the public Claude Code plugin.

End users do not need owner-keygen. Pack licenses are issued by the Cloudflare Worker after LemonSqueezy purchase; the plugin consumes those licenses via the license validation hook and the `mxm-pack-engine` binary.

## Platform Coverage

v1.0.0 ships Windows amd64 binaries only. Mac and Linux binaries arrive on v1.0.0 multi-platform build.
