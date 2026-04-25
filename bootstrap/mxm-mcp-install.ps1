# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-mcp-install.ps1 — install npm deps for all 7 MCP servers (Windows parity)
#
# Each MCP server (mcp\mxm-*\) is a self-contained Node package with its own
# package.json. node_modules\ is gitignored, so a fresh plugin install ships
# without dependencies. Without this step, Claude Code's MCP-spawn fails with
# ERR_MODULE_NOT_FOUND for @modelcontextprotocol/sdk and the user sees an
# MCP timeout.

param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: npm not on PATH — required to install MCP server dependencies"
    Write-Host "Install Node.js from https://nodejs.org and re-run this script."
    exit 1
}

if (-not (Test-Path 'mcp')) {
    Write-Host "ERROR: .\mcp directory not found (run from repo root)"
    exit 1
}

$success = 0
$skipped = 0
$failed = 0

Get-ChildItem -Directory -Path 'mcp\mxm-*' | ForEach-Object {
    $serverDir = $_.FullName
    $name = $_.Name
    $packageJson = Join-Path $serverDir 'package.json'
    $nodeModules = Join-Path $serverDir 'node_modules'

    if (-not (Test-Path $packageJson)) {
        Write-Host "SKIP  $name — no package.json"
        $script:skipped++
        return
    }

    if ((Test-Path $nodeModules) -and -not $Force) {
        Write-Host "SKIP  $name — node_modules already present"
        $script:skipped++
        return
    }

    if (Test-Path $nodeModules) {
        Write-Host "FORCE removing $nodeModules"
        Remove-Item -Recurse -Force $nodeModules
    }

    Write-Host "INSTALL $name (npm install --omit=dev --no-audit --no-fund)"
    Push-Location $serverDir
    try {
        & npm install --omit=dev --no-audit --no-fund 2>&1 | Select-Object -Last 3 | ForEach-Object { Write-Host $_ }
        if ($LASTEXITCODE -eq 0) {
            $script:success++
        } else {
            Write-Host "FAIL  $name"
            $script:failed++
        }
    } finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "mxm-mcp-install done — installed: $success, skipped: $skipped, failed: $failed"
if ($failed -gt 0) {
    Write-Host "Note: re-run with -Force to retry failed installs."
    exit 1
}
exit 0
