# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim - SessionStart Hook (PowerShell)
# =============================================================================
# Fires at the start of every Claude Code session on Windows.
# Mirrors session-start.sh behavior. See that file for protocol description.
#
# Exit codes:
#   0 = success (always - never block session start)
# =============================================================================

$ErrorActionPreference = 'Continue'

# ----- Find project root -----
function Find-ProjectRoot {
    $dir = (Get-Location).Path
    for ($i = 0; $i -lt 4; $i++) {
        if (Test-Path (Join-Path $dir 'config\project-manifest.json')) {
            return $dir
        }
        $parent = Split-Path -Parent $dir
        if ([string]::IsNullOrEmpty($parent) -or $parent -eq $dir) { break }
        $dir = $parent
    }
    return (Get-Location).Path
}

$ProjectRoot = Find-ProjectRoot
Set-Location $ProjectRoot

# ----- Load project ID -----
$ProjectId = 'unknown'
$ManifestPath = Join-Path $ProjectRoot 'config\project-manifest.json'
if (Test-Path $ManifestPath) {
    try {
        $manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
        if ($manifest.project.id) { $ProjectId = $manifest.project.id }
    } catch { }
}

# ----- Ensure runtime directories exist -----
@('.mxm-skills', '.claude-sessions-memory', '.mxm-operator-profile') | ForEach-Object {
    $path = Join-Path $ProjectRoot $_
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

# ----- Auto-install community packs (first-session bootstrap) -----
# Claude Code plugin API has no PostInstall hook, so SessionStart is the
# enforcement point. If config/community-pack-registry.json declares
# auto_install_required=true and any required pack is missing, runs
# bootstrap/mxm-community-packs.ps1. Subsequent sessions see the sentinel and
# skip. Fail-soft - never blocks session start.
$RegistryPath = Join-Path $ProjectRoot 'config\community-pack-registry.json'
$InstallerPath = Join-Path $ProjectRoot 'bootstrap\mxm-community-packs.ps1'
if ((Test-Path $RegistryPath) -and (Test-Path $InstallerPath)) {
    $Sentinel = Join-Path $ProjectRoot '.mxm-skills\.community-packs-installed'
    $NeedCheck = $true
    if (Test-Path $Sentinel) {
        $sentinelMtime = (Get-Item $Sentinel).LastWriteTime
        $registryMtime = (Get-Item $RegistryPath).LastWriteTime
        if ($sentinelMtime -gt $registryMtime) { $NeedCheck = $false }
    }
    if ($NeedCheck) {
        $MissingCount = 0
        try {
            $registry = Get-Content $RegistryPath -Raw | ConvertFrom-Json
            if ($registry.auto_install_required) {
                foreach ($p in $registry.packs) {
                    if ($p.required -and -not (Test-Path (Join-Path $ProjectRoot $p.install_path))) {
                        $MissingCount++
                    }
                }
            }
        } catch { $MissingCount = 1 }
        if ($MissingCount -gt 0) {
            [Console]::Error.WriteLine('------------------------------------------------------')
            [Console]::Error.WriteLine("Maxim: installing $MissingCount community pack(s) (first run, ~1-2 min)...")
            [Console]::Error.WriteLine('------------------------------------------------------')
            try {
                & pwsh -NoProfile -File $InstallerPath 2>&1 | ForEach-Object { [Console]::Error.WriteLine($_) }
                if ($LASTEXITCODE -eq 0) {
                    New-Item -ItemType File -Path $Sentinel -Force | Out-Null
                } else {
                    [Console]::Error.WriteLine('Maxim: community pack install FAILED.')
                    [Console]::Error.WriteLine('  Retry manually: pwsh -File bootstrap\mxm-community-packs.ps1')
                }
            } catch {
                [Console]::Error.WriteLine("Maxim: community pack install error: $_")
            }
        } else {
            New-Item -ItemType File -Path $Sentinel -Force | Out-Null
        }
    }
}

# ----- Auto-install MCP server dependencies (first-session bootstrap) -----
# Each MCP server (mcp\mxm-*\) is a self-contained Node package. Without
# node_modules, Claude Code's MCP spawn fails with ERR_MODULE_NOT_FOUND
# and the user sees an MCP timeout.
#
# BUG-007 fix (v1.1.0.2): MCP servers spawn from PLUGIN install dir, NOT
# PROJECT dir. Sentinel + install paths must be plugin-version-scoped.
# CLAUDE_PLUGIN_ROOT is set by Claude Code when this hook is invoked via
# plugin.json; fallback derives from script location for manual invocation.
$PluginRoot = if ($env:CLAUDE_PLUGIN_ROOT) {
    $env:CLAUDE_PLUGIN_ROOT
} else {
    try { (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path } catch { $null }
}
$McpInstaller = if ($PluginRoot) { Join-Path $PluginRoot 'bootstrap\mxm-mcp-install.ps1' } else { $null }
$McpDir = if ($PluginRoot) { Join-Path $PluginRoot 'mcp' } else { $null }
if ($PluginRoot -and (Test-Path $McpDir) -and (Test-Path $McpInstaller) -and (Get-Command npm -ErrorAction SilentlyContinue)) {
    $McpSentinel = Join-Path $PluginRoot '.mcp-deps-installed'
    if (-not (Test-Path $McpSentinel)) {
        $needsInstall = $false
        Get-ChildItem -Directory -Path (Join-Path $PluginRoot 'mcp\mxm-*') | ForEach-Object {
            if ((Test-Path (Join-Path $_.FullName 'package.json')) -and -not (Test-Path (Join-Path $_.FullName 'node_modules'))) {
                $needsInstall = $true
            }
        }
        if ($needsInstall) {
            [Console]::Error.WriteLine('------------------------------------------------------')
            [Console]::Error.WriteLine('Maxim: installing MCP server dependencies (first run, ~30-60 sec)...')
            [Console]::Error.WriteLine('------------------------------------------------------')
            try {
                # Bootstrap script reads cwd-relative mcp/, so push cwd to PluginRoot
                Push-Location $PluginRoot
                try {
                    & pwsh -NoProfile -File $McpInstaller 2>&1 | ForEach-Object { [Console]::Error.WriteLine($_) }
                    if ($LASTEXITCODE -eq 0) {
                        New-Item -ItemType File -Path $McpSentinel -Force | Out-Null
                        [Console]::Error.WriteLine('Maxim: MCP servers ready. Restart this session to load them.')
                    } else {
                        [Console]::Error.WriteLine('Maxim: MCP install FAILED.')
                        [Console]::Error.WriteLine("  Retry manually: cd `"$PluginRoot`"; pwsh -File bootstrap\mxm-mcp-install.ps1 -Force")
                    }
                } finally {
                    Pop-Location
                }
            } catch {
                [Console]::Error.WriteLine("Maxim: MCP install error: $_")
            }
        } else {
            New-Item -ItemType File -Path $McpSentinel -Force | Out-Null
        }
    }
}

# ----- Surface handoff state -----
$HandoffState = 'none'
$HandoffPath = Join-Path $ProjectRoot '.mxm-skills\agents-handoff.md'
if (Test-Path $HandoffPath) {
    $line = (Select-String -Path $HandoffPath -Pattern '^\*?\*?Status:' | Select-Object -First 1).Line
    if ($line) {
        $HandoffState = ($line -replace '\*', '' -replace '^Status:\s*', '').Trim()
        if ($HandoffState.Length -gt 40) { $HandoffState = $HandoffState.Substring(0, 40) }
    }
}

# ----- Count open skill gaps -----
$GapCount = 0
$GapPath = Join-Path $ProjectRoot '.mxm-skills\agents-skill-gaps.log'
if (Test-Path $GapPath) {
    $GapCount = (Select-String -Path $GapPath -Pattern '^\[2\d{3}-').Count
}

# ----- Count PENDING review queue items -----
$PendingCount = 0
$ReviewPath = Join-Path $ProjectRoot '.mxm-skills\review-queue.md'
if (Test-Path $ReviewPath) {
    $PendingCount = (Select-String -Path $ReviewPath -Pattern '^\| PENDING').Count
}

# ----- Run Proactive Watch LIGHT (v1.0.0+) -----
$WatchDrift = 0
$WatchErrors = 0
$WatchScript = Join-Path $ProjectRoot '.claude\skills\proactive-watch\watch.ps1'
$WatchProfile = Join-Path $ProjectRoot 'config\watch-profile.yml'
if ((Test-Path $WatchScript) -and (Test-Path $WatchProfile)) {
    try {
        $watchOut = & pwsh -NoProfile -File $WatchScript all 2>&1 | Select-Object -Last 5
        $summary = $watchOut | Where-Object { $_ -match 'drift=\d+' } | Select-Object -Last 1
        if ($summary -match 'drift=(\d+)') { $WatchDrift = [int]$Matches[1] }
        if ($summary -match 'errors=(\d+)') { $WatchErrors = [int]$Matches[1] }
    } catch {
        # fail-open — watch errors never block session
    }
}

# ----- Print session start summary to stderr -----
[Console]::Error.WriteLine('=======================================================')
[Console]::Error.WriteLine('Maxim SESSION START')
[Console]::Error.WriteLine("  Project   : $ProjectId")
[Console]::Error.WriteLine("  Root      : $ProjectRoot")
[Console]::Error.WriteLine("  Handoff   : $HandoffState")
[Console]::Error.WriteLine("  Open gaps : $GapCount")
[Console]::Error.WriteLine("  Pending review: $PendingCount")
if ($WatchDrift -gt 0 -or $WatchErrors -gt 0) {
    [Console]::Error.WriteLine("  Drift     : $WatchDrift (run /mxm-watch for details)")
    if ($WatchErrors -gt 0) { [Console]::Error.WriteLine("  Watch errs: $WatchErrors") }
}
[Console]::Error.WriteLine('=======================================================')

exit 0
