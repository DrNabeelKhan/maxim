# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-community-packs.ps1 — install all community packs per ADR-008 (v1.0.0)
#
# Parity with mxm-community-packs.sh.

param(
    [switch]$List,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$registry = "config/community-pack-registry.json"
if (-not (Test-Path $registry)) {
    Write-Host "ERROR: $registry not found (run from repo root)"
    exit 1
}

$data = Get-Content $registry -Raw | ConvertFrom-Json

if ($List) {
    foreach ($p in $data.packs) {
        Write-Host "  $($p.id) <- $($p.source)"
    }
    exit 0
}

$success = 0
$failed = 0

foreach ($pack in $data.packs) {
    $id = $pack.id
    $source = $pack.source
    $branch = $pack.branch
    $installPath = $pack.install_path

    if ((Test-Path $installPath) -and (-not $Force)) {
        Write-Host "SKIP  $id -- already present at $installPath"
        continue
    }

    if (Test-Path $installPath) {
        Write-Host "FORCE removing $installPath"
        Remove-Item -Recurse -Force $installPath
    }

    $parent = Split-Path -Parent $installPath
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    Write-Host "CLONE $id <- github.com/$source @ $branch"
    & git clone --depth 1 --branch $branch "https://github.com/$source.git" $installPath 2>&1 | Select-Object -Last 3 | ForEach-Object { Write-Host $_ }
    if ($LASTEXITCODE -eq 0) {
        $success++
    } else {
        Write-Host "FAIL  $id"
        $failed++
    }
}

Write-Host ""
Write-Host "mxm-community-packs done. Success=$success Failed=$failed"
Write-Host "Run 'pwsh $PSCommandPath -List' to see installed packs."
