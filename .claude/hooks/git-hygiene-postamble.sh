#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim Git Hygiene Gate — Postamble (GHN)
# Run at the END of any bundled task / sprint / release sprint.
# Verifies the repo is clean and pushed before declaring work complete.
#
# Exit codes:
#   0 — all gates pass
#   1 — GHN1 failed (working tree not clean — uncommitted work remains)
#   2 — GHN2 failed (local commits not pushed to origin)
#   4 — environment failure
#
# Usage:
#   .claude/hooks/git-hygiene-postamble.sh [--skip-push-check]

set -u

EXIT_OK=0
EXIT_DIRTY_TREE=1
EXIT_UNPUSHED=2
EXIT_ENV=4
SKIP_PUSH=0

for arg in "$@"; do
  case "$arg" in
    --skip-push-check) SKIP_PUSH=1 ;;
  esac
done

say() { printf "Maxim Git Hygiene ▸ %s\n" "$*" >&2; }
fail() { printf "Maxim Git Hygiene ✗ %s\n" "$*" >&2; }
ok() { printf "Maxim Git Hygiene ✓ %s\n" "$*" >&2; }

if ! command -v git >/dev/null 2>&1; then
  fail "git not found"
  exit $EXIT_ENV
fi
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  fail "not inside a git repository"
  exit $EXIT_ENV
fi

say "Running postamble gates…"

# GHN1 — working tree clean
if [ -n "$(git status --porcelain)" ]; then
  fail "GHN1 — working tree dirty. Uncommitted work remains."
  git status --short >&2
  exit $EXIT_DIRTY_TREE
fi
ok "GHN1 — working tree clean"

# GHN2 — pushed to origin
if [ "$SKIP_PUSH" -eq 1 ]; then
  say "GHN2 — push check skipped via --skip-push-check"
  exit $EXIT_OK
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if git remote | grep -q '^origin$'; then
  git fetch origin --quiet 2>/dev/null
  UPSTREAM="origin/$CURRENT_BRANCH"
  if git rev-parse --verify "$UPSTREAM" >/dev/null 2>&1; then
    UNPUSHED=$(git rev-list --count "$UPSTREAM"..HEAD 2>/dev/null || echo "0")
    if [ "$UNPUSHED" -gt 0 ]; then
      fail "GHN2 — $UNPUSHED local commits not pushed to $UPSTREAM"
      git log --oneline "$UPSTREAM"..HEAD >&2
      exit $EXIT_UNPUSHED
    fi
    ok "GHN2 — all commits pushed to $UPSTREAM"
  else
    say "GHN2 — no upstream tracking '$UPSTREAM' (local-only branch; push disabled)"
  fi
else
  say "GHN2 — no 'origin' remote (local-only repo)"
fi

say "All postamble gates passed — work is safely persisted."
exit $EXIT_OK
