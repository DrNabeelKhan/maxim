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

# ADR counts (Section 9 prose: "**Total ADRs: 21.**" + "(... 17 public + 4 confidential ...)")
$AdrTotal = $null; $AdrPublic = $null
$invRaw = Get-Content $Inventory -Raw
if ($invRaw -match '\*\*Total ADRs:\s*(\d+)') { $AdrTotal = [int]$Matches[1] }
if ($invRaw -match '(\d+)\s+public\s+\+\s+\d+\s+confidential') { $AdrPublic = [int]$Matches[1] }

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
    'documents[\\/]ADRs[\\/]ADR-[0-9]+'                # individual ADRs are historical
    'documents[\\/]ledgers[\\/]DEBUGGING_PLAYBOOK\.md$'
    'documents[\\/]ledgers[\\/]BUG_TRACKER\.md$'       # append-only bug ledger
    'documents[\\/]ledgers[\\/]MOAT_TRACKER\.md$'      # positioning entries dated to release
    'documents[\\/]sales[\\/]launch[\\/]'              # dated launch artifacts
    'documents[\\/]marketing[\\/]catalogues[\\/]'      # versioned catalogues
    'documents[\\/]marketing[\\/]packs-catalog[\\/]'   # versioned pack catalogues
    'documents[\\/]sales[\\/]MOE_v1_[0-9]+_'           # versioned build plans
    'documents[\\/]references[\\/]'                    # historical session bridges
    'templates[\\/]prompts[\\/]PROMPT_'                # version-bound demo prompts
    '[\\/]cinematic-styles[\\/]'                       # ai-media-generation skill — per-stack mechanics
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
    Get-ChildItem -Path $RepoRoot -Recurse -File -Include '*.md', 'agent-registry.json', 'plugin.json', 'marketplace.json' |
        Where-Object {
            $rel = $_.FullName.Substring($RepoRoot.Path.Length + 1)
            -not (Test-Excluded $_.FullName) -and
            ($_.Extension -eq '.md' -or
             $_.Name -eq 'agent-registry.json' -or
             ($_.Name -eq 'plugin.json' -and $_.FullName -match '[\\/]\.claude-plugin[\\/]plugin\.json$') -or
             ($_.Name -eq 'marketplace.json' -and $_.FullName -match '[\\/]\.claude-plugin[\\/]marketplace\.json$'))
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

# Capability-summary "list" nouns — synced ONLY adjacent to a middot "·" (the summary
# signature). "agents"/"frameworks" are EXCLUDED: office rosters ("16 agents · lead:")
# and "78 behavioral vs 14 compliance vs top-3 frameworks" make them ambiguous.
$ListAnchors = @()
if ($Skills)   { $ListAnchors += @{ keyword = 'skills';   count = $Skills } }
if ($Commands) { $ListAnchors += @{ keyword = 'commands'; count = $Commands } }

function Sync-File($filePath) {
    $before = Get-Content $filePath -Raw -ErrorAction SilentlyContinue
    if ($null -eq $before) { return $false }
    $after = $before
    foreach ($a in $Anchors) {
        $kwEsc = [regex]::Escape($a.keyword)
        # SAFE pattern — three strict forms (matches sync-counts.sh):
        #   1. <num>+<space><kw>             — "+"-suffix marks open-ended count claim
        #   2. <num><space><adj><space><kw>  — adjective-prefixed (specialist|governed|peer-reviewed|Maxim|slash)
        #   3. <num><space><kw>              — ONLY for compound (multi-word) anchors
        #                                       (e.g., "skill domains", "MCP servers", "behavioral frameworks").
        #                                       Compounds are specific enough to avoid the false-positive
        #                                       classes single-word bare-matches would hit.
        $patternPlus = "\b\d{1,4}\+(\s+)$kwEsc\b"
        $patternAdj  = "\b\d{1,4}(\s+(?:specialist|governed|peer-reviewed|Maxim|slash)\s+)$kwEsc\b"
        $after = [regex]::Replace($after, $patternPlus, "$($a.count)+`$1$($a.keyword)", 'IgnoreCase')
        $after = [regex]::Replace($after, $patternAdj,  "$($a.count)`$1$($a.keyword)",  'IgnoreCase')
        # Compound keyword detection: anchor contains a whitespace character.
        if ($a.keyword -match '\s') {
            $patternCompound = "\b\d{1,4}(\s+)$kwEsc\b"
            $after = [regex]::Replace($after, $patternCompound, "$($a.count)`$1$($a.keyword)", 'IgnoreCase')
        }
    }
    # Capability-summary "list" nouns: require an adjacent middot "·" (U+00B7), so
    # breakdowns like "(26 commands)" / "Office - 16 agents" are never touched.
    # NOTE: group refs are braced (${1}) — .NET reads an un-braced $1 followed by the
    # count digits as group $152 (invalid -> kept literal). Braces disambiguate.
    foreach ($n in $ListAnchors) {
        $nEsc = [regex]::Escape($n.keyword)
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+$nEsc\s*·)", "$($n.count)`${1}", 'IgnoreCase')
        $after = [regex]::Replace($after, "(·\s*)\d{1,4}(\s+$nEsc\b)", "`${1}$($n.count)`${2}", 'IgnoreCase')
    }
    # ADR counts (no office/sub breakdown -> simple bare + specific forms are safe)
    if ($AdrTotal) {
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+ADRs\b)", "$AdrTotal`${1}", 'IgnoreCase')
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+[Aa]rchitectural decisions)", "$AdrTotal`${1}", 'IgnoreCase')
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+Architecture Decision Records)", "$AdrTotal`${1}", 'IgnoreCase')
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+total\s+\(\s*\d+\s+public)", "$AdrTotal`${1}", 'IgnoreCase')
        $after = [regex]::Replace($after, "\*\*\d{1,4}\*\*(\s*\|\s*ADRs\b)", "**$AdrTotal**`${1}", 'IgnoreCase')
    }
    if ($AdrPublic) {
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+public\b[^0-9\n]{0,8}\d+\s+confidential)", "$AdrPublic`${1}", 'IgnoreCase')
        $after = [regex]::Replace($after, "(Public ADRs \()\d{1,4}(\))", "`${1}$AdrPublic`${2}", 'IgnoreCase')
        $after = [regex]::Replace($after, "\b\d{1,4}(\s+public\s+(?:ADRs?|ones)\b)", "$AdrPublic`${1}", 'IgnoreCase')
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
