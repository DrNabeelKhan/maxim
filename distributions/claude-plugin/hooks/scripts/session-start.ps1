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
