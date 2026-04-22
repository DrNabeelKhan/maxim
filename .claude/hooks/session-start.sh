#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim — SessionStart Hook (Bash)
# =============================================================================
# Fires at the start of every Claude Code session.
# Implements the Session Start Protocol from CLAUDE.md (replaces "documented
# behavior" with deterministic execution).
#
# Steps performed:
#   1. Detect project root (looks for config/project-manifest.json)
#   2. Verify .claude-sessions-memory/ exists (create if missing)
#   3. Verify .mxm-skills/ exists (create if missing)
#   4. Verify .mxm-operator-profile/ exists (create if missing)
#   5. Surface BLOCKED/PARTIAL handoff state from .mxm-skills/agents-handoff.md
#   6. Surface open skill gaps count
#   7. Surface PENDING review queue count
#   8. Print one-line session start summary to stderr
#
# Exit codes:
#   0 = success (always — never block session start)
# =============================================================================

set -uo pipefail

# ----- Find project root (walk up looking for project-manifest.json) -----
find_project_root() {
  local dir="$PWD"
  for _ in 1 2 3 4; do
    if [ -f "$dir/config/project-manifest.json" ]; then
      echo "$dir"
      return 0
    fi
    [ "$dir" = "/" ] && break
    dir="$(dirname "$dir")"
  done
  # Fallback: current directory
  echo "$PWD"
}

PROJECT_ROOT="$(find_project_root)"
cd "$PROJECT_ROOT" || exit 0

PROJECT_ID="unknown"
if [ -f "config/project-manifest.json" ] && command -v node >/dev/null 2>&1; then
  PROJECT_ID="$(node -e "try{console.log(require('./config/project-manifest.json').project?.id||'unknown')}catch(e){console.log('unknown')}" 2>/dev/null || echo "unknown")"
fi

# ----- Ensure runtime directories exist -----
mkdir -p .mxm-skills .claude-sessions-memory .mxm-operator-profile 2>/dev/null

# ----- Auto-install community packs (first-session bootstrap) -----
# Claude Code plugin API has no PostInstall hook, so SessionStart is the
# enforcement point. If config/community-pack-registry.json declares
# auto_install_required=true and any required pack is missing, runs
# bootstrap/mxm-community-packs.sh. Subsequent sessions see the sentinel and
# skip (no network call, no overhead). Fail-soft — never blocks session.
if [ -f "config/community-pack-registry.json" ] && [ -f "bootstrap/mxm-community-packs.sh" ]; then
  SENTINEL=".mxm-skills/.community-packs-installed"
  REGISTRY="config/community-pack-registry.json"
  # Valid sentinel = exists AND newer than registry (re-run if registry changed)
  NEED_CHECK=1
  if [ -f "$SENTINEL" ] && [ "$SENTINEL" -nt "$REGISTRY" ]; then
    NEED_CHECK=0
  fi
  if [ "$NEED_CHECK" -eq 1 ]; then
    MISSING_COUNT=0
    if command -v node >/dev/null 2>&1; then
      MISSING_COUNT=$(node -e "
        const r=require('./config/community-pack-registry.json');
        const fs=require('fs');
        let m=0;
        if(r.auto_install_required){for(const p of r.packs){if(p.required&&!fs.existsSync(p.install_path))m++;}}
        console.log(m);" 2>/dev/null || echo 0)
    else
      MISSING_COUNT=1
    fi
    if [ "$MISSING_COUNT" -gt 0 ]; then
      {
        echo "──────────────────────────────────────────────────────"
        echo "Maxim: installing ${MISSING_COUNT} community pack(s) (first run, ~1–2 min)…"
        echo "──────────────────────────────────────────────────────"
      } >&2
      if bash bootstrap/mxm-community-packs.sh >&2 2>&1; then
        touch "$SENTINEL"
      else
        {
          echo "Maxim: community pack install FAILED (network? git? jq/python?)."
          echo "  Retry manually: bash bootstrap/mxm-community-packs.sh"
        } >&2
      fi
    else
      touch "$SENTINEL"
    fi
  fi
fi

# ----- Surface handoff state -----
HANDOFF_STATE=""
if [ -f ".mxm-skills/agents-handoff.md" ]; then
  HANDOFF_STATE="$(grep -m1 -E '^Status:|^\*\*Status:\*\*' .mxm-skills/agents-handoff.md 2>/dev/null | sed 's/[*]//g; s/^Status:\s*//; s/^\s*//' | head -c 40)"
fi

# ----- Count open skill gaps -----
GAP_COUNT=0
if [ -f ".mxm-skills/agents-skill-gaps.log" ]; then
  GAP_COUNT="$(grep -cE '^\[2[0-9]{3}-' .mxm-skills/agents-skill-gaps.log 2>/dev/null || echo 0)"
fi

# ----- Count PENDING review queue items -----
PENDING_COUNT=0
if [ -f ".mxm-skills/review-queue.md" ]; then
  PENDING_COUNT="$(grep -cE '^\| PENDING' .mxm-skills/review-queue.md 2>/dev/null || echo 0)"
fi

# ----- Run Proactive Watch LIGHT (v1.0.0+) -----
# Best-effort: fail-open if watch skill missing or errors
WATCH_DRIFT=0
WATCH_ERRORS=0
WATCH_SCRIPT=".claude/skills/proactive-watch/watch.sh"
if [ -x "$WATCH_SCRIPT" ] && [ -f "config/watch-profile.yml" ]; then
  # Run silently, capture only counts from the final summary line
  WATCH_OUT="$("$WATCH_SCRIPT" all 2>&1 | tail -20 || true)"
  WATCH_DRIFT="$(echo "$WATCH_OUT" | grep -oE 'drift=[0-9]+' | tail -1 | cut -d= -f2 || echo 0)"
  WATCH_ERRORS="$(echo "$WATCH_OUT" | grep -oE 'errors=[0-9]+' | tail -1 | cut -d= -f2 || echo 0)"
fi

# ----- Print session start summary -----
{
  echo "═══════════════════════════════════════════════════════"
  echo "Maxim SESSION START"
  echo "  Project   : ${PROJECT_ID}"
  echo "  Root      : ${PROJECT_ROOT}"
  echo "  Handoff   : ${HANDOFF_STATE:-none}"
  echo "  Open gaps : ${GAP_COUNT}"
  echo "  Pending review: ${PENDING_COUNT}"
  if [ "$WATCH_DRIFT" -gt 0 ] || [ "$WATCH_ERRORS" -gt 0 ]; then
    echo "  Drift     : ${WATCH_DRIFT} (run /mxm-watch for details)"
    [ "$WATCH_ERRORS" -gt 0 ] && echo "  Watch errs: ${WATCH_ERRORS}"
  fi
  echo "═══════════════════════════════════════════════════════"
} >&2

exit 0
