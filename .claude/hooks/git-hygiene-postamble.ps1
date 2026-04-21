# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim Git Hygiene Gate — Postamble (GHN) — PowerShell
# Run at the END of any bundled task / sprint / release sprint.
#
# Exit codes:
#   0 — all gates pass
#   1 — GHN1 failed (working tree not clean)
#   2 — GHN2 failed (local commits not pushed)
#   4 — environment failure

[CmdletBinding()]
param(
    [switch]$SkipPushCheck
)

$ErrorActionPreference = 'Continue'

function Say    { param($m) Write-Host "Maxim Git Hygiene ▸ $m" -ForegroundColor Cyan }
function OK     { param($m) Write-Host "Maxim Git Hygiene ✓ $m" -ForegroundColor Green }
function Fail   { param($m) Write-Host "Maxim Git Hygiene ✗ $m" -ForegroundColor Red }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail 'git not found'
    exit 4
}
git rev-parse --git-dir *> $null
if ($LASTEXITCODE -ne 0) {
    Fail 'not inside a git repository'
    exit 4
}

Say 'Running postamble gates…'

# GHN1 — working tree clean
$status = git status --porcelain
if ($status) {
    Fail 'GHN1 — working tree dirty. Uncommitted work remains.'
    git status --short | Write-Host
    exit 1
}
OK 'GHN1 — working tree clean'

# GHN2 — pushed to origin
if ($SkipPushCheck) {
    Say 'GHN2 — push check skipped via -SkipPushCheck'
    exit 0
}

$currentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
$remotes = git remote
if ($remotes -contains 'origin') {
    git fetch origin --quiet *> $null
    $upstream = "origin/$currentBranch"
    git rev-parse --verify $upstream *> $null
    if ($LASTEXITCODE -eq 0) {
        $unpushed = (git rev-list --count "$upstream..HEAD").Trim()
        if ([int]$unpushed -gt 0) {
            Fail "GHN2 — $unpushed local commits not pushed to $upstream"
            git log --oneline "$upstream..HEAD" | Write-Host
            exit 2
        }
        OK "GHN2 — all commits pushed to $upstream"
    } else {
        Say "GHN2 — no upstream tracking '$upstream' (local-only branch; push disabled)"
    }
} else {
    Say 'GHN2 — no ''origin'' remote (local-only repo)'
}

Say 'All postamble gates passed — work is safely persisted.'
exit 0
