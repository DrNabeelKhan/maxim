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

# ----- Topology: child rollup to parent (ADR-013) -----
try {
    $ManifestPath2 = Join-Path $ProjectRoot 'config\project-manifest.json'
    if (Test-Path $ManifestPath2) {
        $topo2 = (Get-Content $ManifestPath2 -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue).topology
        if ($topo2 -and $topo2.kind -eq 'child' -and $topo2.parent) {
            $ParentPath = $topo2.parent
            if (Test-Path $ParentPath) {
                $ParentMemDir = Join-Path $ParentPath '.claude-sessions-memory'
                if (-not (Test-Path $ParentMemDir)) { New-Item -ItemType Directory -Path $ParentMemDir -Force | Out-Null }
                $RollupFile = Join-Path $ParentMemDir 'children-rollup.md'
                $ChildProjectId = 'unknown'
                try {
                    $cm2 = Get-Content $ManifestPath2 -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
                    if ($cm2 -and $cm2.project -and $cm2.project.id) { $ChildProjectId = $cm2.project.id }
                } catch {}
                $ChildHandoffStatus = 'READY'
                try {
                    $chp2 = Join-Path $ProjectRoot '.mxm-skills\agents-handoff.md'
                    if (Test-Path $chp2) {
                        $cl2 = (Select-String -Path $chp2 -Pattern '^\*?\*?Status:' | Select-Object -First 1).Line
                        if ($cl2) { $ChildHandoffStatus = ($cl2 -replace '\*','' -replace '^Status:\s*','').Trim().Substring(0,[Math]::Min(20,$cl2.Length)) }
                    }
                } catch {}
                $ChildSummary2 = ''
                try {
                    $hf2 = Join-Path $ProjectRoot '.claude-sessions-memory\handoff.md'
                    if (Test-Path $hf2) {
                        $ll2 = (Get-Content $hf2 -ErrorAction SilentlyContinue | Where-Object {$_.Trim()-ne'' -and -not $_.StartsWith('#')} | Select-Object -Last 1)
                        if ($ll2) { $ChildSummary2 = $ll2.Trim().Substring(0,[Math]::Min(80,$ll2.Trim().Length)) }
                    }
                } catch {}
                Add-Content -Path $RollupFile -Value "[$NowIso] | $ChildProjectId | $ChildHandoffStatus | $ChildSummary2" -ErrorAction SilentlyContinue
            }
        }
    }
} catch {
    $GapLogPath = Join-Path $ProjectRoot '.mxm-skills\agents-skill-gaps.log'
    Add-Content -Path $GapLogPath -Value "[$NowIso] [topology-rollup-warn] child->parent rollup failed: $_" -ErrorAction SilentlyContinue
}

[Console]::Error.WriteLine("Maxim SessionEnd: $Today marker written")
exit 0
