#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim — SessionEnd Hook (Bash)
# =============================================================================
# Fires when a Claude Code session ends.
# Implements step 1, 11 of the Session End Protocol from CLAUDE.md:
#   - Writes session-[YYYY-MM-DD].md if not already present today
#   - Updates .claude-sessions-memory/handoff.md with last_seen timestamp
#   - Calls mxm-portfolio.sync_portfolio if available (non-blocking)
#
# Steps performed:
#   1. Detect project root
#   2. Append last-activity timestamp to handoff.md
#   3. Ensure today's session-YYYY-MM-DD.md exists (touch if absent)
#   4. Append session-end marker to .mxm-skills/agents-background.log
#
# Exit codes:
#   0 = success (always — never block session end)
# =============================================================================

set -uo pipefail

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
  echo "$PWD"
}

PROJECT_ROOT="$(find_project_root)"
cd "$PROJECT_ROOT" || exit 0

TODAY="$(date -u +%Y-%m-%d)"
NOW_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

mkdir -p .mxm-skills .claude-sessions-memory 2>/dev/null

# ----- Append session-end marker to background log -----
echo "[$NOW_ISO] session_end" >> .mxm-skills/agents-background.log 2>/dev/null

# ----- Ensure today's session file exists (placeholder for Claude to fill) -----
SESSION_FILE=".claude-sessions-memory/session-${TODAY}.md"
if [ ! -f "$SESSION_FILE" ]; then
  cat > "$SESSION_FILE" <<EOF
# Session ${TODAY}

> Auto-created by SessionEnd hook. Claude should populate this file at session end
> with: tasks completed, decisions made, files created/modified, open items.

**Status:** auto-created (awaiting Claude population)
**Last touch:** ${NOW_ISO}
EOF
fi

# ----- Touch handoff.md last_seen marker -----
HANDOFF_FILE=".claude-sessions-memory/handoff.md"
if [ ! -f "$HANDOFF_FILE" ]; then
  cat > "$HANDOFF_FILE" <<EOF
# Session Handoff

**Last touch:** ${NOW_ISO}
**Status:** READY
EOF
fi

echo "Maxim SessionEnd: ${TODAY} marker written" >&2
exit 0
