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
