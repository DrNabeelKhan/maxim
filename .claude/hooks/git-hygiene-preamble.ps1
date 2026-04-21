# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim Git Hygiene Gate — Preamble (GH1–GH3) — PowerShell
# Run at the START of any bundled task / sprint / release sprint.
#
# Exit codes:
#   0 — all gates pass
#   1 — GH1 failed (working tree not clean)
#   2 — GH2 failed (wrong branch)
#   3 — GH3 failed (not up-to-date with origin)
#   4 — environment failure

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$ExpectedBranch = ''
)

$ErrorActionPreference = 'Continue'

function Say    { param($m) Write-Host "Maxim Git Hygiene ▸ $m" -ForegroundColor Cyan }
function OK     { param($m) Write-Host "Maxim Git Hygiene ✓ $m" -ForegroundColor Green }
function Fail   { param($m) Write-Host "Maxim Git Hygiene ✗ $m" -ForegroundColor Red }

# Env check
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail 'git not found'
    exit 4
}
git rev-parse --git-dir *> $null
if ($LASTEXITCODE -ne 0) {
    Fail 'not inside a git repository'
    exit 4
}

Say 'Running preamble gates…'

# GH1 — working tree clean
$status = git status --porcelain
if ($status) {
    Fail 'GH1 — working tree dirty. Commit or stash before starting.'
    git status --short | Write-Host
    exit 1
}
OK 'GH1 — working tree clean'

# GH2 — branch check
$currentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($ExpectedBranch -and $currentBranch -ne $ExpectedBranch) {
    Fail "GH2 — on branch '$currentBranch', expected '$ExpectedBranch'"
    exit 2
}
OK "GH2 — on branch '$currentBranch'"

# GH3 — up-to-date with origin
$remotes = git remote
if ($remotes -contains 'origin') {
    git fetch origin --quiet *> $null
    $upstream = "origin/$currentBranch"
    git rev-parse --verify $upstream *> $null
    if ($LASTEXITCODE -eq 0) {
        $behind = (git rev-list --count "HEAD..$upstream").Trim()
        if ([int]$behind -gt 0) {
            Fail "GH3 — $behind commits behind $upstream. Pull before starting."
            exit 3
        }
        OK "GH3 — up-to-date with $upstream"
    } else {
        Say "GH3 — no upstream tracking '$upstream' (local-only branch; allowed)"
    }
} else {
    Say 'GH3 — no ''origin'' remote (local-only repo; allowed)'
}

Say 'All preamble gates passed — safe to begin work.'
exit 0
