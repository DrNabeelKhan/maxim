#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

#
# mxm-owner-keygen-bootstrap.sh
#
# Phase 0 bootstrap: generates OWNER-1 RSA machine-bound key pair before
# Sprint 2a authors the final mxm-owner-keygen CLI tool.
#
# Usage:
#   ./mxm-owner-keygen-bootstrap.sh --machine "MacBook-Pro"
#
# Produces:
#   ~/.mxm-packs/owner.key       (PRIVATE — NEVER commit, NEVER share)
#   ~/.mxm-packs/owner-$MACHINE.pub (PUBLIC — commit to mxm-packs-source/build/owner-keys/)
#
# Requires: bash 4+, openssl, node (for fingerprint hash)

set -euo pipefail

MACHINE=""
EMAIL="https://maxim.isystematic.com/contact"
OWNER="DrNabeelKhan"

# Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        --machine) MACHINE="$2"; shift 2 ;;
        --email) EMAIL="$2"; shift 2 ;;
        --owner) OWNER="$2"; shift 2 ;;
        *) echo "Unknown arg: $1"; exit 1 ;;
    esac
done

if [[ -z "$MACHINE" ]]; then
    echo "ERROR: --machine argument required (e.g., --machine MacBook-Pro)" >&2
    exit 1
fi

echo ""
echo "=== Maxim OWNER-1 Keygen Bootstrap (v1.0.0 Phase 0) ==="
echo ""

# --- 1. Preflight ---
KEY_DIR="$HOME/.mxm-packs"
mkdir -p "$KEY_DIR"

PRIVATE_KEY="$KEY_DIR/owner.key"
PUBLIC_KEY="$KEY_DIR/owner-$MACHINE.pub"

if [[ -f "$PRIVATE_KEY" ]]; then
    echo "WARNING: Private key already exists at $PRIVATE_KEY"
    read -p "Overwrite? This will break pack decryption on existing artifacts. [y/N] " CONFIRM
    if [[ "$CONFIRM" != "y" ]]; then exit 0; fi
fi

# Require openssl
if ! command -v openssl >/dev/null; then
    echo "ERROR: openssl not found. Install via 'brew install openssl' (Mac) or 'apt install openssl' (Linux)" >&2
    exit 1
fi

# Require node
if ! command -v node >/dev/null; then
    echo "ERROR: Node.js not found. Install Node 20+ from https://nodejs.org" >&2
    exit 1
fi

# --- 2. Compute machine fingerprint ---
echo "[→] Computing machine fingerprint..."

# macOS fingerprint sources
if [[ "$(uname)" == "Darwin" ]]; then
    CPU_ID=$(sysctl -n machdep.cpu.brand_string | tr -d ' ' || echo "unknown-cpu")
    DISK_SERIAL=$(system_profiler SPSerialATADataType SPNVMeDataType 2>/dev/null | awk -F': ' '/Serial Number/ {print $2; exit}' || echo "unknown-disk")
    PRIMARY_MAC=$(ifconfig en0 2>/dev/null | awk '/ether/ {print $2}' || echo "unknown-mac")
# Linux fingerprint sources
elif [[ "$(uname)" == "Linux" ]]; then
    CPU_ID=$(cat /proc/cpuinfo | grep "model name" | head -1 | awk -F': ' '{print $2}' | tr -d ' ' || echo "unknown-cpu")
    DISK_SERIAL=$(lsblk -d -o serial 2>/dev/null | tail -n +2 | head -1 | tr -d ' ' || echo "unknown-disk")
    PRIMARY_MAC=$(ip link show | awk '/ether/ {print $2; exit}' || echo "unknown-mac")
else
    echo "ERROR: Unsupported OS $(uname)" >&2
    exit 1
fi

if [[ -z "$CPU_ID" || -z "$DISK_SERIAL" || -z "$PRIMARY_MAC" ]]; then
    echo "ERROR: Failed to gather machine identity. CPU=$CPU_ID Disk=$DISK_SERIAL MAC=$PRIMARY_MAC" >&2
    exit 1
fi

FINGERPRINT_INPUT="$CPU_ID|$DISK_SERIAL|$PRIMARY_MAC"
FINGERPRINT=$(node -e "const crypto = require('crypto'); console.log(crypto.createHash('sha256').update('$FINGERPRINT_INPUT').digest('hex'))")

echo "[✓] Machine fingerprint: ${FINGERPRINT:0:16}..."

# --- 3. Generate RSA keypair (4096-bit) ---
echo "[→] Generating 4096-bit RSA keypair..."
openssl genrsa -out "$PRIVATE_KEY" 4096 2>/dev/null
openssl rsa -in "$PRIVATE_KEY" -pubout -out "$PUBLIC_KEY" 2>/dev/null

if [[ ! -f "$PRIVATE_KEY" || ! -f "$PUBLIC_KEY" ]]; then
    echo "ERROR: Key generation failed." >&2
    exit 1
fi

# --- 4. Set restrictive permissions on private key ---
chmod 600 "$PRIVATE_KEY"
echo "[✓] Private key permissions: 600 (owner read/write only)"

# --- 5. Write metadata sidecar (not a secret) ---
METADATA_PATH="$KEY_DIR/owner-$MACHINE.meta.json"
cat > "$METADATA_PATH" <<EOF
{
    "machine": "$MACHINE",
    "owner": "$OWNER",
    "email": "$EMAIL",
    "fingerprint": "$FINGERPRINT",
    "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "mxm_version": "6.4.4-phase-0",
    "key_type": "RSA-4096",
    "phase": "bootstrap (pre-Sprint-2a)"
}
EOF
echo "[✓] Metadata written: $METADATA_PATH"

# --- 6. Output summary ---
echo ""
echo "=== OWNER-1 KEY GENERATED ==="
echo "Machine       : $MACHINE"
echo "Owner         : $OWNER <$EMAIL>"
echo "Fingerprint   : $FINGERPRINT"
echo "Private key   : $PRIVATE_KEY (PRIVATE — DO NOT SHARE)"
echo "Public key    : $PUBLIC_KEY"
echo "Metadata      : $METADATA_PATH"
echo ""
echo "NEXT STEPS:"
echo "  1. Copy the PUBLIC key to mxm-packs-source repo:"
echo "     cp \"$PUBLIC_KEY\" /path/to/mxm-packs-source/build/owner-keys/"
echo "  2. Commit to mxm-packs-source:"
echo "     cd /path/to/mxm-packs-source"
echo "     git add build/owner-keys/owner-$MACHINE.pub"
echo "     git commit -m \"security: add owner key for $MACHINE\""
echo "     git push"
echo "  3. The build pipeline (Sprint 2a) will include this .pub when encrypting packs"
echo "  4. On other machines: run this same script with a different --machine name"
echo ""
echo "NEVER share the private key. NEVER commit the private key."
