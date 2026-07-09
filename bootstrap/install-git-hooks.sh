#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
# =============================================================================
# Maxim — install-git-hooks (Bash)
# =============================================================================
# Installs the Maxim pre-commit gate into .git/hooks/pre-commit so the
# secret/PII/junction scan (.claude/hooks/pre-commit.sh) actually fires on
# `git commit`. Writes a tiny DELEGATING SHIM (copy, not symlink — symlinks are
# fragile on Windows / Git Bash) that always execs the versioned hook, so plugin
# updates land without re-installing. Idempotent: safe to run repeatedly.
#
# Git runs .git/hooks/* through its bundled sh on every platform (incl. native
# Windows), so a POSIX shim is correct regardless of the operator's shell.
#
# Usage:  bash bootstrap/install-git-hooks.sh
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ ! -d "$ROOT/.git" ]; then
  echo "install-git-hooks: $ROOT is not a git repository (no .git/) — nothing to do." >&2
  exit 0
fi
HOOK_DIR="$ROOT/.git/hooks"
mkdir -p "$HOOK_DIR"
TARGET="$HOOK_DIR/pre-commit"

cat > "$TARGET" <<'SHIM'
#!/usr/bin/env bash
# Maxim pre-commit gate shim — installed by bootstrap/install-git-hooks.sh.
# Delegates to the versioned hook so `claude plugin update` lands without a
# re-install. Remove this file (or `git commit --no-verify`) to bypass.
DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GATE="$DIR/.claude/hooks/pre-commit.sh"
[ -x "$GATE" ] || [ -f "$GATE" ] || exit 0   # gate absent → do not block
exec bash "$GATE"
SHIM

chmod +x "$TARGET" 2>/dev/null || true
echo "install-git-hooks: Maxim pre-commit gate installed → $TARGET"
