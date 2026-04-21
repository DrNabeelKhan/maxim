# mxm-pack-engine

Maxim commercial pack runtime (v1.0.0, Phase A scaffold).

Decrypts AES-256-GCM encrypted pack content given a valid RS256 JWT license,
with an OWNER-1 machine-bound bypass for the project owner.

## Status

- **Phase A (v1.0.0 sprint-2a):** code scaffold, `--version`, `--fingerprint`,
  `--validate-jwt` (stub), `--decrypt` (stub key resolve). Does NOT deploy to
  Cloudflare.
- **Phase B (post-megasprint):** real Cloudflare Worker issuer, LemonSqueezy
  webhook wiring, real KMS key derivation, owner key signature verification.

## Build

```bash
cd pack-engine
go mod tidy
go build -o mxm-pack-engine
./mxm-pack-engine --version
```

## Usage

```bash
# Print machine fingerprint (for owner key generation)
mxm-pack-engine --fingerprint

# Validate a JWT license
mxm-pack-engine --token "$MXM_LICENSE" --validate-jwt

# Decrypt a pack file (prints plaintext to stdout)
mxm-pack-engine --token "$MXM_LICENSE" --decrypt packs/encrypted/pack-l1-6/SKILL.md.enc
```

Environment:
- `MXM_LICENSE` — JWT license token
- `MXM_PACK_PUBKEY` — PEM-encoded RSA public key (Phase B: fetched from Worker)
- `MXM_OWNER_KEY` — path to owner.key (bypass)

## Architecture

See ADR-005 (5-layer IP protection) and ADR-008 (pack distribution).
