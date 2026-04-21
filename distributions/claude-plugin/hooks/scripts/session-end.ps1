# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim - SessionEnd Hook (PowerShell)
# =============================================================================
# Mirrors session-end.sh on Windows. See that file for protocol description.
# =============================================================================

$ErrorActionPreference = 'Continue'

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

$Today = (Get-Date -Format 'yyyy-MM-dd')
$NowIso = (Get-Date -AsUTC -Format "yyyy-MM-ddTHH:mm:ssZ")

# Ensure dirs
@('.mxm-skills', '.claude-sessions-memory') | ForEach-Object {
    $path = Join-Path $ProjectRoot $_
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

# Append to background log
$BgLog = Join-Path $ProjectRoot '.mxm-skills\agents-background.log'
Add-Content -Path $BgLog -Value "[$NowIso] session_end"

# Ensure today's session file exists
$SessionFile = Join-Path $ProjectRoot ".claude-sessions-memory\session-$Today.md"
if (-not (Test-Path $SessionFile)) {
    @"
# Session $Today

> Auto-created by SessionEnd hook. Claude should populate this file at session end
> with: tasks completed, decisions made, files created/modified, open items.

**Status:** auto-created (awaiting Claude population)
**Last touch:** $NowIso
"@ | Set-Content -Path $SessionFile
}

# Touch handoff.md
$HandoffFile = Join-Path $ProjectRoot '.claude-sessions-memory\handoff.md'
if (-not (Test-Path $HandoffFile)) {
    @"
# Session Handoff

**Last touch:** $NowIso
**Status:** READY
"@ | Set-Content -Path $HandoffFile
}

[Console]::Error.WriteLine("Maxim SessionEnd: $Today marker written")
exit 0
