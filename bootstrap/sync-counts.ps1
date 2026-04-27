# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# bootstrap/sync-counts.ps1 — propagate AGENT_SKILL_INVENTORY counts to all surfaces.
# Windows mirror of sync-counts.sh. Same semantics; same exit codes.
#
# Idempotent: running on a clean tree is a no-op (zero file modifications).
# Companion to Proactive Watch Class 11 (surface-claims-drift).
#
# Exit codes:
#   0 = clean (or successfully synced, all surfaces aligned)
#   1 = drift remained after sync (manual review required)
#   2 = invalid inventory (could not parse a required section)
#   3 = environment error
#
# Usage:
#   .\bootstrap\sync-counts.ps1             # default: all anchors, all surfaces
#   .\bootstrap\sync-counts.ps1 -DryRun     # report planned changes without writing
#   .\bootstrap\sync-counts.ps1 -Check      # exit 1 if any drift detected; do not modify
#   .\bootstrap\sync-counts.ps1 -Verbose    # log every match + replacement decision
#
# Environment:
#   $env:MAXIM_LANDING_PAGE — optional path to sibling landing-page checkout

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Check
)

$ErrorActionPreference = 'Stop'

# =====================================================================
# Setup
# =====================================================================

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$Inventory = Join-Path $RepoRoot 'documents\ledgers\AGENT_SKILL_INVENTORY.md'
$WatchReportDir = Join-Path $RepoRoot '.mxm-skills'
$WatchReport = Join-Path $WatchReportDir 'watch-report.jsonl'

$LandingDefault = Resolve-Path (Join-Path $RepoRoot '..\landing-page') -ErrorAction SilentlyContinue
$LandingRoot = if ($env:MAXIM_LANDING_PAGE) { $env:MAXIM_LANDING_PAGE } else { $LandingDefault }

$DriftRemaining = $false

if (-not (Test-Path $Inventory)) {
    Write-Error "FATAL: inventory not found at $Inventory"
    exit 2
}

if (-not (Test-Path $WatchReportDir)) {
    New-Item -ItemType Directory -Force -Path $WatchReportDir | Out-Null
}

function Write-Log($msg) {
    if ($VerbosePreference -eq 'Continue') { Write-Host "  $msg" }
}

function Emit-Drift($class, $file, $anchor, $claimed, $canonical) {
    $ts = (Get-Date -AsUTC).ToString('yyyy-MM-ddTHH:mm:ssZ')
    $entry = @{
        ts = $ts; phase = 'sync'; project = 'maxim'
        drift_class = $class; severity = 3
        declared = [int]$canonical; actual = [int]$claimed
        evidence = "${file}:$anchor"; action = 'manual-review'
    } | ConvertTo-Json -Compress
    Add-Content -Path $WatchReport -Value $entry
    $script:DriftRemaining = $true
}

# =====================================================================
# 1. Parse INVENTORY for canonical counts
# =====================================================================

function Parse-SectionCount($pattern) {
    Get-Content $Inventory | Where-Object { $_ -match "^##\s+$pattern.*?\((\d+)\)" } | ForEach-Object {
        if ($_ -match '\((\d+)\)') { return [int]$Matches[1] }
    } | Select-Object -First 1
}

$Agents     = Parse-SectionCount 'Section 1.*Specialist Agents'
$Skills     = Parse-SectionCount 'Section 2.*Domain Skills'
$Commands   = Parse-SectionCount 'Section 3.*Slash Commands'
$Hooks      = Parse-SectionCount 'Section 5.*Hooks'
$Frameworks = Parse-SectionCount 'Section 6.*Behavioral Frameworks'
$Compliance = Parse-SectionCount 'Section 7.*Compliance Frameworks'

# Section 4 is "MCP Servers (N servers, M tools)" — special-cased
$Section4 = (Get-Content $Inventory | Where-Object { $_ -match '^##\s+Section 4.*MCP Servers' } | Select-Object -First 1)
$McpServers = $null; $McpTools = $null
if ($Section4 -match '\((\d+)\s+server') { $McpServers = [int]$Matches[1] }
if ($Section4 -match '(\d+)\s+tools?\)') { $McpTools = [int]$Matches[1] }

if (-not $Agents) {
    Write-Error "FATAL: could not parse Section 1 agent count"
    exit 2
}

Write-Log "Canonical counts from INVENTORY:"
Write-Log "  agents=$Agents skills=$Skills commands=$Commands"
Write-Log "  mcp_servers=$McpServers mcp_tools=$McpTools hooks=$Hooks"
Write-Log "  frameworks=$Frameworks compliance=$Compliance"

# =====================================================================
# 2. Define surface scan paths + exclusions
# =====================================================================

$ExcludePatterns = @(
    'CHANGELOG\.md$'
    'documents[\\/]ADRs[\\/]INDEX\.md$'
    '[\\/]v[0-9][0-9.]*-[a-zA-Z0-9-]+\.md$'
    '[\\/]changelog[\\/]'
    'migration-log'
    'MIGRATION_LOG\.md$'
    'SECRETS_TO_ROTATE\.md$'
    '[\\/]node_modules[\\/]'
    '[\\/]\.git[\\/]'
    '[\\/]community-packs[\\/]'
    'config[\\/]agent-registry\.json$'
    'CLAUDE\.d[\\/]office-catalog\.md$'
    'documents[\\/]ledgers[\\/]AGENT_SKILL_INVENTORY\.md$'
    '[\\/]agents[\\/]MXM[\\/]'
    '[\\/]\.claude[\\/]agents[\\/]'
    '[\\/]documents[\\/]proposals[\\/]'
    'AGENT_ROSTER_v1\.[0-9]+_PROPOSAL\.md$'
)

function Test-Excluded($path) {
    foreach ($p in $ExcludePatterns) {
        if ($path -match $p) { return $true }
    }
    return $false
}

function Get-PluginRepoSurfaces {
    Get-ChildItem -Path $RepoRoot -Recurse -File -Include '*.md', 'agent-registry.json' |
        Where-Object {
            $rel = $_.FullName.Substring($RepoRoot.Path.Length + 1)
            -not (Test-Excluded $_.FullName) -and
            ($_.Extension -eq '.md' -or $_.Name -eq 'agent-registry.json')
        } |
        Select-Object -ExpandProperty FullName
}

function Get-LandingPageSurfaces {
    if (-not $LandingRoot -or -not (Test-Path $LandingRoot)) {
        Write-Log "Landing-page not found at $LandingRoot — skipping cross-repo scan"
        return @()
    }
    Get-ChildItem -Path $LandingRoot -Recurse -File -Include '*.tsx', '*.ts' |
        Where-Object {
            $rel = $_.FullName.Substring($LandingRoot.Path.Length + 1) -replace '\\', '/'
            $_.FullName -notmatch '[\\/]node_modules[\\/]' -and
            $_.FullName -notmatch '[\\/]\.next[\\/]' -and
            $rel -notmatch '^app/changelog/' -and
            $rel -notmatch '^app/roadmap/' -and
            $rel -notmatch '^app/giveaway/' -and
            $rel -ne 'components/DispatchDiagram.tsx'
        } |
        Select-Object -ExpandProperty FullName
}

# =====================================================================
# 3. Anchor → count mapping
# =====================================================================

$Anchors = @()
if ($Agents)     { $Anchors += @{ keyword = 'agents';                count = $Agents } }
if ($Skills)     { $Anchors += @{ keyword = 'skill domains';         count = $Skills } }
if ($Commands)   { $Anchors += @{ keyword = 'commands';              count = $Commands } }
if ($McpServers) { $Anchors += @{ keyword = 'MCP servers';           count = $McpServers } }
if ($McpTools)   { $Anchors += @{ keyword = 'MCP tools';             count = $McpTools } }
if ($Hooks)      { $Anchors += @{ keyword = 'hooks';                 count = $Hooks } }
if ($Frameworks) { $Anchors += @{ keyword = 'behavioral frameworks'; count = $Frameworks } }
if ($Compliance) { $Anchors += @{ keyword = 'compliance frameworks'; count = $Compliance } }

function Sync-File($filePath) {
    $before = Get-Content $filePath -Raw -ErrorAction SilentlyContinue
    if ($null -eq $before) { return $false }
    $after = $before
    foreach ($a in $Anchors) {
        $kwEsc = [regex]::Escape($a.keyword)
        # SAFE pattern: only match in two strict forms (matches sync-counts.sh):
        #   1. <num>+<space><kw>             — "+"-suffix marks open-ended count claim
        #   2. <num><space><adj><space><kw>  — adjective-prefixed (specialist|governed|Maxim|peer-reviewed)
        # Bare "<num> <kw>" is intentionally NOT matched — too many false positives
        # (per-office breakdowns, complexity thresholds, historical changelog entries).
        $patternPlus = "\b\d{1,4}\+(\s+)$kwEsc\b"
        $patternAdj  = "\b\d{1,4}(\s+(?:specialist|governed|peer-reviewed|Maxim)\s+)$kwEsc\b"
        $after = [regex]::Replace($after, $patternPlus, "$($a.count)+`$1$($a.keyword)", 'IgnoreCase')
        $after = [regex]::Replace($after, $patternAdj,  "$($a.count)`$1$($a.keyword)",  'IgnoreCase')
    }
    if ($before -eq $after) { return $false }
    if ($DryRun -or $Check) {
        Write-Log "Would update: $($filePath.Substring($RepoRoot.Path.Length + 1))"
        if ($Check) { $script:DriftRemaining = $true }
        return $true
    }
    Set-Content -Path $filePath -Value $after -NoNewline
    Write-Log "Updated: $($filePath.Substring($RepoRoot.Path.Length + 1))"
    return $true
}

# =====================================================================
# 4. Run sync
# =====================================================================

$Total = 0; $Changed = 0
foreach ($f in (Get-PluginRepoSurfaces)) {
    $Total++
    if (Sync-File $f) { $Changed++ }
}

$LandingTotal = 0; $LandingChanged = 0
foreach ($f in (Get-LandingPageSurfaces)) {
    $LandingTotal++
    if (Sync-File $f) { $LandingChanged++ }
}

# =====================================================================
# 5. Report
# =====================================================================

Write-Host ""
Write-Host "✓ sync-counts complete"
Write-Host "  inventory:        $Inventory"
Write-Host "  canonical counts: agents=$Agents skills=$Skills commands=$Commands mcp_servers=$McpServers hooks=$Hooks frameworks=$Frameworks compliance=$Compliance"
Write-Host "  plugin-repo:      $Changed of $Total surface files modified"
if ($LandingRoot -and (Test-Path $LandingRoot)) {
    Write-Host "  landing-page:     $LandingChanged of $LandingTotal surface files modified ($LandingRoot)"
} else {
    Write-Host "  landing-page:     skipped (set `$env:MAXIM_LANDING_PAGE to enable)"
}
if ($DryRun) {
    Write-Host "  mode:             DRY-RUN (no files modified)"
}
if ($Check -and $DriftRemaining) {
    Write-Host "  CHECK FAILED: drift detected — run without -Check to propagate"
    exit 1
}
if ($DriftRemaining) {
    Write-Host "  WARNING: residual drift logged to .mxm-skills/watch-report.jsonl"
    exit 1
}
exit 0
