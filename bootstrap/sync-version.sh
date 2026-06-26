#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# sync-version.sh — Maxim Version Sync Tool
# Version: 2.0.0
#
# Reads the version from config/agent-registry.json (single source of truth)
# and propagates it to EVERY version-bearing surface. The read is PURE SHELL
# (grep/sed) — no node/python — because Windows-native interpreters cannot
# resolve MSYS absolute paths (/e/Projects/...), which silently broke v1.x of
# this tool under `set -e` (PATTERN-01: cross-platform path resolution).
#
# Usage:
#   bash bootstrap/sync-version.sh                 # propagate the registry version to all surfaces
#   bash bootstrap/sync-version.sh --version X.Y.Z # bump the registry + propagate
#   bash bootstrap/sync-version.sh --dry-run       # preview, no writes
#   bash bootstrap/sync-version.sh --check         # exit 1 if any surface disagrees (no writes) — for CI / pre-commit
#
# Cross-platform: Linux, macOS, Windows (Git Bash / WSL). No `set -e` (it masked
# the read failure); errors are reported explicitly and exit with a clear code.
# Exit: 0 = ok / in sync · 1 = drift remains (--check) · 2 = environment/parse error
# ─────────────────────────────────────────────────────────────────────────

set -uo pipefail

MAXIM="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false
CHECK=false
NEW_VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --check)   CHECK=true; DRY_RUN=true; shift ;;
    --version) NEW_VERSION="${2:-}"; [[ -n "$NEW_VERSION" ]] || { echo "ERROR: --version needs a value" >&2; exit 2; }; shift 2 ;;
    -h|--help) sed -n '5,20p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "ERROR: unknown arg: $1" >&2; exit 2 ;;
  esac
done

REGISTRY="$MAXIM/config/agent-registry.json"
[[ -f "$REGISTRY" ]] || { echo "ERROR: config/agent-registry.json not found at $REGISTRY" >&2; exit 2; }

# ── Pure-shell version read (the top-level "version" is the FIRST in the file) ──
read_top_version() {
  grep -m1 -oE '"version"[[:space:]]*:[[:space:]]*"[^"]+"' "$1" 2>/dev/null | sed -E 's/.*"([^"]+)"[[:space:]]*$/\1/'
}

CURRENT="$(read_top_version "$REGISTRY")"
[[ -n "$CURRENT" ]] || { echo "ERROR: could not parse top-level \"version\" from agent-registry.json" >&2; exit 2; }

TARGET="${NEW_VERSION:-$CURRENT}"

echo ""
if $CHECK; then
  echo "Maxim Version Check — registry source-of-truth = v$CURRENT"
elif [[ -n "$NEW_VERSION" ]]; then
  echo "Maxim Version Bump — v$CURRENT -> v$TARGET"
else
  echo "Maxim Version Sync — propagating v$TARGET to all surfaces"
fi
echo ""
echo "  File                                       Status"
echo "  ─────────────────────────────────────      ──────"

# ── Surfaces: "relative/path|template-with-%V|note" (every version-bearing file) ──
# %V is substituted with the version. Templates are anchored to avoid false hits.
SURFACES=(
  'config/agent-registry.json|"version": "%V"|source of truth'
  '.claude-plugin/plugin.json|"version": "%V"|plugin manifest'
  '.claude-plugin/marketplace.json|"version": "%V"|marketplace (outer + entry)'
  'README.md|version-%V-blue|README badge'
  'documents/ledgers/AGENT_SKILL_INVENTORY.md|**Version:** v%V|inventory stamp'
  'documents/guides/HELP.md|Maxim v%V|HELP header'
  'documents/guides/ABOUT.md|Maxim v%V|ABOUT header'
  'documents/guides/GETTING_STARTED.md|Maxim v%V|getting-started'
  'documents/reference/MXM_COMMAND_MAP.md|Maxim v%V|command-map footer'
)
# NOTE: bootstrap/new-project-setup.sh's "MXM_version" is intentionally NOT synced
# here. Per the pre-release audit it is a schema/launch-line field (canonical
# config/project-manifest.json keeps it at "1.0.0"), not the per-patch product
# version — so it must not track releases. (It currently reads 1.3.1; reconcile
# its semantics separately, do not auto-bump it.)

UPDATED=0; OK=0; DRIFT=0; MISSING=0
fmt() { printf "%-42s" "$1"; }

for entry in "${SURFACES[@]}"; do
  file="${entry%%|*}"; rest="${entry#*|}"; tmpl="${rest%%|*}"; note="${rest##*|}"
  fp="$MAXIM/$file"
  oldpat="${tmpl//%V/$CURRENT}"
  newpat="${tmpl//%V/$TARGET}"

  if [[ ! -f "$fp" ]]; then
    echo "  $(fmt "$file") MISSING"; MISSING=$((MISSING+1)); continue
  fi

  if $CHECK; then
    # In --check (TARGET == registry version): the surface MUST contain the target pattern.
    # marketplace.json carries TWO version fields → require both.
    want=1; [[ "$file" == ".claude-plugin/marketplace.json" ]] && want=2
    have=$(grep -cF "$newpat" "$fp" 2>/dev/null); have=${have:-0}
    if [[ "$have" -ge "$want" ]]; then
      echo "  $(fmt "$file") OK (v$TARGET)"; OK=$((OK+1))
    else
      echo "  $(fmt "$file") DRIFT — expected v$TARGET ($note)"; DRIFT=$((DRIFT+1))
    fi
    continue
  fi

  if grep -qF "$oldpat" "$fp" 2>/dev/null && [[ "$CURRENT" != "$TARGET" ]]; then
    if $DRY_RUN; then echo "  $(fmt "$file") WOULD UPDATE -> v$TARGET ($note)"
    else
      esc_old=$(printf '%s' "$oldpat" | sed 's/[&/\]/\\&/g')
      esc_new=$(printf '%s' "$newpat" | sed 's/[&/\]/\\&/g')
      sed -i "s/$esc_old/$esc_new/g" "$fp"
      echo "  $(fmt "$file") UPDATED -> v$TARGET ($note)"
    fi
    UPDATED=$((UPDATED+1))
  elif grep -qF "$newpat" "$fp" 2>/dev/null; then
    echo "  $(fmt "$file") CURRENT (v$TARGET)"; OK=$((OK+1))
  else
    echo "  $(fmt "$file") NOT FOUND ($note)"; MISSING=$((MISSING+1))
  fi
done

# ── Bump registry last_updated (pure sed — no python) ──
if [[ -n "$NEW_VERSION" && "$NEW_VERSION" != "$CURRENT" && "$DRY_RUN" == "false" ]]; then
  TODAY="$(date +%Y-%m-%d)"
  sed -i "s/\"last_updated\": \"[^\"]*\"/\"last_updated\": \"$TODAY\"/" "$REGISTRY"
  echo "  $(fmt "registry last_updated") -> $TODAY"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Version: v$TARGET   (source of truth: config/agent-registry.json)"
if $CHECK; then
  echo "  In sync: $OK · Drift: $DRIFT · Missing: $MISSING"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; echo ""
  [[ "$DRIFT" -eq 0 ]] || { echo "CHECK FAILED — $DRIFT surface(s) disagree with the registry. Run: bash bootstrap/sync-version.sh" >&2; exit 1; }
  exit 0
fi
echo "  Updated: $UPDATED · Already current: $OK · Not found: $MISSING"
$DRY_RUN && echo "  Mode: DRY RUN — no files changed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; echo ""
exit 0
