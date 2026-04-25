#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim License Validation Hook
#
# Fires on Claude Code PermissionRequest events. Reads the cached JWT from
# ~/.mxm-packs/license.jwt (or $MXM_LICENSE env var fallback for CI), POSTs
# to the license endpoint, and emits a permissionDecision JSON document.
#
# Decision matrix:
#   no license file       -> allow  (free tier active)
#   license + server 200  -> allow  (license valid)
#   license + server 4xx  -> deny   (license expired or revoked; refresh required)
#   license + server 5xx  -> allow  (server unreachable; fail open)
#   license + timeout     -> allow  (network issue; fail open)
#
# Never deadlocks the user. Deny is reserved for confirmed invalid licenses.
# Pack-level gating is enforced by pack-engine binary at tool-execution time.

set -u

LICENSE_FILE="${HOME}/.mxm-packs/license.jwt"
LICENSE_ENDPOINT="${MXM_LICENSE_ENDPOINT:-https://license.isystematic.com/validate}"
RESPONSE_FILE="$(mktemp)"
trap 'rm -f "$RESPONSE_FILE"' EXIT

emit_decision() {
  local behavior="$1"
  local message="$2"
  cat <<EOF
{
  "continue": true,
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "${behavior}",
      "message": "${message}"
    }
  }
}
EOF
}

# Acquire JWT: env var takes precedence (CI/CD), then cached file.
if [ -n "${MXM_LICENSE:-}" ]; then
  JWT="$MXM_LICENSE"
elif [ -f "$LICENSE_FILE" ]; then
  JWT="$(cat "$LICENSE_FILE" 2>/dev/null || echo "")"
else
  emit_decision "allow" "Maxim free tier active. Install packs at https://maxim.isystematic.com"
  exit 0
fi

# No JWT content -> treat as free tier.
if [ -z "$JWT" ]; then
  emit_decision "allow" "Maxim free tier active (empty license). Run: mxm-pack-engine activate --license <JWT>"
  exit 0
fi

# Validate via license endpoint.
HTTP_CODE=$(curl -sS -o "$RESPONSE_FILE" -w "%{http_code}" \
  -X POST "$LICENSE_ENDPOINT" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -H "X-Maxim-Version: 6.4.4" \
  --max-time 8 \
  2>/dev/null || echo "000")

case "$HTTP_CODE" in
  200)
    # Parse "valid" field from response; default to true if JSON unparseable but 200.
    VALID=$(python3 -c "
import json, sys
try:
    d = json.load(open('$RESPONSE_FILE'))
    print('true' if d.get('valid', True) else 'false')
except Exception:
    print('true')
" 2>/dev/null || echo "true")
    if [ "$VALID" = "true" ]; then
      emit_decision "allow" "Maxim pack license valid."
    else
      emit_decision "deny" "License revoked. Run: mxm-pack-engine refresh"
    fi
    ;;
  401|403|410)
    emit_decision "deny" "License expired or revoked (HTTP ${HTTP_CODE}). Run: mxm-pack-engine refresh"
    ;;
  000)
    emit_decision "allow" "License server unreachable (network error). Free tier active."
    ;;
  *)
    # 4xx other than auth, or any 5xx: fail open, log the code.
    emit_decision "allow" "License server returned HTTP ${HTTP_CODE}. Proceeding in free-tier mode."
    ;;
esac
