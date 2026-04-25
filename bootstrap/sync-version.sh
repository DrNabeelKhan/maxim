#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# sync-version.sh — Maxim Version Sync Tool
# Version: 1.0.0
#
# Reads version from config/agent-registry.json (single source of truth)
# and propagates it to ALL files that contain version strings.
#
# Usage:
#   cd maxim
#   bash bootstrap/sync-version.sh              # apply changes
#   bash bootstrap/sync-version.sh --dry-run    # preview only
#   bash bootstrap/sync-version.sh --version 5.3.0  # bump + sync
#
# Cross-platform: Linux, macOS, Windows (Git Bash / WSL)
# ─────────────────────────────────────────────────────────────────────────

set -euo pipefail

Maxim="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false
NEW_VERSION=""

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run) DRY_RUN=true; shift ;;
    --version) NEW_VERSION="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

REGISTRY="$Maxim/config/agent-registry.json"
if [[ ! -f "$REGISTRY" ]]; then
  echo "ERROR: config/agent-registry.json not found at: $REGISTRY"
  exit 1
fi

CURRENT=$(python3 -c "import json; print(json.load(open('$REGISTRY'))['version'])" 2>/dev/null \
  || node -e "console.log(JSON.parse(require('fs').readFileSync('$REGISTRY','utf8')).version)" 2>/dev/null)

if [[ -z "$CURRENT" ]]; then
  echo "ERROR: Could not read version from agent-registry.json"
  exit 1
fi

TARGET="${NEW_VERSION:-$CURRENT}"

echo ""
if [[ -n "$NEW_VERSION" ]]; then
  echo "Maxim Version Bump — v$CURRENT -> v$TARGET"
else
  echo "Maxim Version Sync — propagating v$TARGET to all files"
fi
echo ""

# ── File targets ─────────────────────────────────────────────────────────

UPDATED=0
SKIPPED=0

sync_file() {
  local file="$1"
  local old_pattern="$2"
  local new_pattern="$3"
  local note="$4"
  local filepath="$Maxim/$file"
  local display=$(printf "%-35s" "$file")

  if [[ ! -f "$filepath" ]]; then
    echo "  $display MISSING"
    ((SKIPPED++)) || true
    return
  fi

  if ! grep -qF "$old_pattern" "$filepath" 2>/dev/null; then
    if grep -qF "$new_pattern" "$filepath" 2>/dev/null; then
      echo "  $display CURRENT"
    else
      echo "  $display NOT FOUND ($note)"
    fi
    ((SKIPPED++)) || true
    return
  fi

  if $DRY_RUN; then
    echo "  $display WOULD UPDATE ($note)"
  else
    sed -i "s|$(echo "$old_pattern" | sed 's/[&/\]/\\&/g')|$(echo "$new_pattern" | sed 's/[&/\]/\\&/g')|g" "$filepath"
    echo "  $display UPDATED ($note)"
  fi
  ((UPDATED++)) || true
}

echo "  File                              Status"
echo "  ──────────────────────────────    ──────"

sync_file "config/agent-registry.json" \
  "\"version\": \"$CURRENT\"" \
  "\"version\": \"$TARGET\"" \
  "Source of truth"

sync_file "README.md" \
  "version-$CURRENT-blue" \
  "version-$TARGET-blue" \
  "Badge"

sync_file "documents/guides/HELP.md" \
  "Maxim v$CURRENT" \
  "Maxim v$TARGET" \
  "Header + footer"

sync_file "documents/reference/MXM_COMMAND_MAP.md" \
  "Maxim v$CURRENT" \
  "Maxim v$TARGET" \
  "Footer"

sync_file "documents/reference/SKILLS_MAP.md" \
  "v$CURRENT" \
  "v$TARGET" \
  "Source of truth line"

sync_file "documents/ledgers/SESSION_CONTINUITY.md" \
  "| agent-registry.json version | $CURRENT |" \
  "| agent-registry.json version | $TARGET |" \
  "Registry table"

sync_file "bootstrap/new-project-setup.sh" \
  "\"mxm_version\": \"$CURRENT\"" \
  "\"mxm_version\": \"$TARGET\"" \
  "Generated manifest"

# ── Update last_updated in registry ──────────────────────────────────────

if [[ -n "$NEW_VERSION" && "$NEW_VERSION" != "$CURRENT" && "$DRY_RUN" == "false" ]]; then
  TODAY=$(date +%Y-%m-%d)
  if command -v python3 &>/dev/null; then
    python3 -c "
import json
r = json.load(open('$REGISTRY'))
r['last_updated'] = '$TODAY'
json.dump(r, open('$REGISTRY','w'), indent=2)
print('  Registry last_updated set to $TODAY')
"
  fi
fi

# ── Summary ──────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Version: v$TARGET"
echo "  Updated: $UPDATED file(s)"
echo "  Skipped: $SKIPPED file(s)"
if $DRY_RUN; then
  echo "  Mode: DRY RUN — no files changed"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
