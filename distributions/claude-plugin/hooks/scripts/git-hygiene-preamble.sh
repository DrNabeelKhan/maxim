#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim Git Hygiene Gate — Preamble (GH1–GH3)
# Run at the START of any bundled task / sprint / release sprint.
# Verifies the repo is in a clean, current, branch-correct state before work begins.
#
# Exit codes:
#   0 — all gates pass
#   1 — GH1 failed (working tree not clean)
#   2 — GH2 failed (wrong branch)
#   3 — GH3 failed (not up-to-date with origin)
#   4 — environment failure (not a git repo, etc.)
#
# Usage:
#   .claude/hooks/git-hygiene-preamble.sh [expected_branch]
#
# If expected_branch is omitted, any branch is acceptable for GH2 (only main/master
# are checked to be current).

set -u

EXPECTED_BRANCH="${1:-}"
EXIT_OK=0
EXIT_DIRTY_TREE=1
EXIT_WRONG_BRANCH=2
EXIT_BEHIND_ORIGIN=3
EXIT_ENV=4

say() { printf "Maxim Git Hygiene ▸ %s\n" "$*" >&2; }
fail() { printf "Maxim Git Hygiene ✗ %s\n" "$*" >&2; }
ok() { printf "Maxim Git Hygiene ✓ %s\n" "$*" >&2; }

# Env check
if ! command -v git >/dev/null 2>&1; then
  fail "git not found"
  exit $EXIT_ENV
fi
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  fail "not inside a git repository"
  exit $EXIT_ENV
fi

say "Running preamble gates…"

# GH1 — working tree clean
if [ -n "$(git status --porcelain)" ]; then
  fail "GH1 — working tree dirty. Commit or stash before starting."
  git status --short >&2
  exit $EXIT_DIRTY_TREE
fi
ok "GH1 — working tree clean"

# GH2 — branch check
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ -n "$EXPECTED_BRANCH" ] && [ "$CURRENT_BRANCH" != "$EXPECTED_BRANCH" ]; then
  fail "GH2 — on branch '$CURRENT_BRANCH', expected '$EXPECTED_BRANCH'"
  exit $EXIT_WRONG_BRANCH
fi
ok "GH2 — on branch '$CURRENT_BRANCH'"

# GH3 — up-to-date with origin
if git remote | grep -q '^origin$'; then
  git fetch origin --quiet 2>/dev/null
  UPSTREAM="origin/$CURRENT_BRANCH"
  if git rev-parse --verify "$UPSTREAM" >/dev/null 2>&1; then
    BEHIND=$(git rev-list --count HEAD.."$UPSTREAM" 2>/dev/null || echo "0")
    if [ "$BEHIND" -gt 0 ]; then
      fail "GH3 — $BEHIND commits behind $UPSTREAM. Pull before starting."
      exit $EXIT_BEHIND_ORIGIN
    fi
    ok "GH3 — up-to-date with $UPSTREAM"
  else
    say "GH3 — no upstream tracking '$UPSTREAM' (local-only branch; allowed)"
  fi
else
  say "GH3 — no 'origin' remote (local-only repo; allowed)"
fi

say "All preamble gates passed — safe to begin work."
exit $EXIT_OK
