# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# sync-version.ps1 — Maxim Version Sync Tool
# Version: 1.0.0
#
# Reads the version from config/agent-registry.json (single source of truth)
# and propagates it to ALL files that contain version strings.
#
# Usage:
#   cd maxim
#   .\bootstrap\sync-version.ps1              # apply changes
#   .\bootstrap\sync-version.ps1 -WhatIf      # preview only
#   .\bootstrap\sync-version.ps1 -NewVersion "5.3.0"  # bump + sync
#
# Cross-platform: PowerShell 7+ (Windows, macOS, Linux)
# ─────────────────────────────────────────────────────────────────────────

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$NewVersion = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Resolve Maxim repo root ───────────────────────────────────────────────
$Maxim = Split-Path $MyInvocation.MyCommand.Path -Parent | Split-Path -Parent

$registryPath = [IO.Path]::Combine($Maxim, "config", "agent-registry.json")
if (-not (Test-Path $registryPath)) {
    Write-Host "ERROR: config/agent-registry.json not found at: $registryPath" -ForegroundColor Red
    exit 1
}

$registry = Get-Content $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$currentVersion = $registry.version

if ([string]::IsNullOrWhiteSpace($NewVersion)) {
    $targetVersion = $currentVersion
    Write-Host ""
    Write-Host "Maxim Version Sync — propagating v$targetVersion to all files" -ForegroundColor Cyan
} else {
    $targetVersion = $NewVersion
    Write-Host ""
    Write-Host "Maxim Version Bump — v$currentVersion -> v$targetVersion" -ForegroundColor Cyan
}

# ── Define all files + patterns that contain version strings ─────────────

$versionTargets = @(
    @{
        File    = "config/agent-registry.json"
        Pattern = '"version": "{OLD}"'
        Replace = '"version": "{NEW}"'
        Note    = "Source of truth"
    },
    @{
        File    = "README.md"
        Pattern = "version-{OLD}-blue"
        Replace = "version-{NEW}-blue"
        Note    = "Badge"
    },
    @{
        File    = "documents/guides/HELP.md"
        Pattern = "Maxim v{OLD}"
        Replace = "Maxim v{NEW}"
        Note    = "Header + footer"
    },
    @{
        File    = "documents/reference/MXM_COMMAND_MAP.md"
        Pattern = "Maxim v{OLD}"
        Replace = "Maxim v{NEW}"
        Note    = "Footer"
    },
    @{
        File    = "documents/reference/SKILLS_MAP.md"
        Pattern = "v{OLD}"
        Replace = "v{NEW}"
        Note    = "Source of truth line"
    },
    @{
        File    = "documents/guides/GETTING_STARTED.md"
        Pattern = "v{OLD}"
        Replace = "v{NEW}"
        Note    = "Version refs"
    },
    @{
        File    = "documents/ledgers/SESSION_CONTINUITY.md"
        Pattern = "| agent-registry.json version | {OLD} |"
        Replace = "| agent-registry.json version | {NEW} |"
        Note    = "Registry table"
    },
    @{
        File    = "bootstrap/new-project-setup.sh"
        Pattern = '"mxm_version": "{OLD}"'
        Replace = '"mxm_version": "{NEW}"'
        Note    = "Generated manifest version"
    }
)

# ── Process each target ──────────────────────────────────────────────────

$updated = 0
$skipped = 0
$errors = 0

Write-Host ""
Write-Host "  File                              Status" -ForegroundColor White
Write-Host "  ──────────────────────────────    ──────" -ForegroundColor DarkGray

foreach ($target in $versionTargets) {
    $filePath = [IO.Path]::Combine($Maxim, $target.File)
    $displayName = $target.File.PadRight(35)

    if (-not (Test-Path $filePath)) {
        Write-Host "  $displayName MISSING" -ForegroundColor Yellow
        $skipped++
        continue
    }

    $content = Get-Content $filePath -Raw -Encoding UTF8
    $oldPattern = $target.Pattern -replace '\{OLD\}', [regex]::Escape($currentVersion)
    $newPattern = $target.Replace -replace '\{NEW\}', $targetVersion
    $searchLiteral = $target.Pattern -replace '\{OLD\}', $currentVersion

    if ($content -notmatch [regex]::Escape($searchLiteral)) {
        # Try: maybe already at target version
        $alreadyPattern = $target.Pattern -replace '\{OLD\}', $targetVersion
        if ($content -match [regex]::Escape($alreadyPattern)) {
            Write-Host "  $displayName CURRENT" -ForegroundColor DarkGreen
        } else {
            Write-Host "  $displayName NOT FOUND ($($target.Note))" -ForegroundColor Yellow
        }
        $skipped++
        continue
    }

    if ($WhatIfPreference) {
        Write-Host "  $displayName WOULD UPDATE ($($target.Note))" -ForegroundColor Cyan
        $updated++
    } else {
        try {
            $newContent = $content -replace [regex]::Escape($searchLiteral), ($target.Replace -replace '\{NEW\}', $targetVersion)
            Set-Content $filePath $newContent -Encoding UTF8 -NoNewline
            Write-Host "  $displayName UPDATED ($($target.Note))" -ForegroundColor Green
            $updated++
        } catch {
            Write-Host "  $displayName ERROR: $_" -ForegroundColor Red
            $errors++
        }
    }
}

# ── Update registry version if bumping ───────────────────────────────────

if ($NewVersion -ne "" -and $NewVersion -ne $currentVersion -and -not $WhatIfPreference) {
    # Add changelog entry to registry
    $registry.version = $targetVersion
    $registry.last_updated = (Get-Date -Format "yyyy-MM-dd")
    $registryJson = $registry | ConvertTo-Json -Depth 10
    Set-Content $registryPath $registryJson -Encoding UTF8
}

# ── Summary ──────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  Version: v$targetVersion" -ForegroundColor White
Write-Host "  Updated: $updated file(s)" -ForegroundColor $(if ($updated -gt 0) { "Green" } else { "DarkGray" })
Write-Host "  Skipped: $skipped file(s)" -ForegroundColor DarkGray
if ($errors -gt 0) {
    Write-Host "  Errors:  $errors file(s)" -ForegroundColor Red
}
if ($WhatIfPreference) {
    Write-Host "  Mode: DRY RUN — no files changed" -ForegroundColor Yellow
}
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

if ($errors -gt 0) { exit 1 }
