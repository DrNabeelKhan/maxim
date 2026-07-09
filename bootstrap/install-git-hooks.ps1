# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
# =============================================================================
# Maxim - install-git-hooks (PowerShell)
# =============================================================================
# Windows-native mirror of install-git-hooks.sh. Installs the Maxim pre-commit
# gate into .git/hooks/pre-commit as a POSIX delegating shim (git runs hooks
# through its bundled sh even on Windows, so the shim is a bash script, not a
# .ps1). Copy-shim, not symlink (symlinks need admin/dev-mode on Windows).
# Idempotent. Writes LF, UTF-8 no-BOM so Git Bash executes it cleanly.
#
# Usage:  pwsh -File bootstrap/install-git-hooks.ps1
# =============================================================================
$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not (Test-Path (Join-Path $root '.git'))) {
  Write-Warning "install-git-hooks: $root is not a git repository (no .git/) - nothing to do."
  exit 0
}
$hookDir = Join-Path $root '.git\hooks'
New-Item -ItemType Directory -Force $hookDir | Out-Null
$target = Join-Path $hookDir 'pre-commit'

$shim = @"
#!/usr/bin/env bash
# Maxim pre-commit gate shim - installed by bootstrap/install-git-hooks.ps1.
# Delegates to the versioned hook so ``claude plugin update`` lands without a
# re-install. Remove this file (or ``git commit --no-verify``) to bypass.
DIR="`$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GATE="`$DIR/.claude/hooks/pre-commit.sh"
[ -x "`$GATE" ] || [ -f "`$GATE" ] || exit 0
exec bash "`$GATE"
"@ -replace "`r`n", "`n"

[System.IO.File]::WriteAllText($target, $shim, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "install-git-hooks: Maxim pre-commit gate installed -> $target"
