# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim Statusline — Windows PowerShell 7+
#
# Reads Claude Code session JSON from stdin + three project-local data sources
# and emits a two-line statusline in Technical Educator voice per ADR-010.
#
# Data sources (all optional, graceful fallback when missing):
#   stdin                                                    - Claude Code session JSON
#   $CLAUDE_PROJECT_DIR\.claude-sessions-memory\activity.jsonl  - last line
#   $CLAUDE_PROJECT_DIR\config\project-manifest.json            - project + lifecycle
#   $CLAUDE_PROJECT_DIR\.mxm-skills\agents-skill-gaps.log      - line count
#   $CLAUDE_PROJECT_DIR\documents\references\mxm-statusline-labels.json  - label lookup
#
# Color tiers:
#   context % : green <60, yellow 60-80, red >=80
#   5h rate % : green <70, yellow 70-85, red >=85
#   7d rate % : green <75, yellow 75-80, red >=80
#
# OSC 8 clickable links route to https://maxim.isystematic.com/docs/glossary#<anchor>.
# Windows Terminal, PowerShell 7, and modern VS Code terminals support OSC 8.

$ErrorActionPreference = "SilentlyContinue"

# Read Claude JSON from stdin
$StdinRaw = [Console]::In.ReadToEnd()
if (-not $StdinRaw) { $StdinRaw = "{}" }
$Claude = try { $StdinRaw | ConvertFrom-Json -ErrorAction Stop } catch { [PSCustomObject]@{} }

# Project root
$ProjectRoot = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { $PWD.Path }
$ActivityFile = Join-Path $ProjectRoot ".claude-sessions-memory\activity.jsonl"
$ManifestFile = Join-Path $ProjectRoot "config\project-manifest.json"
$GapsFile     = Join-Path $ProjectRoot ".mxm-skills\agents-skill-gaps.log"
$LabelsFile   = Join-Path $ProjectRoot "documents\references\mxm-statusline-labels.json"

# ANSI
$ESC = [char]0x1b
$GREEN = "$ESC[32m"
$YELLOW = "$ESC[33m"
$RED = "$ESC[31m"
$DIM = "$ESC[2m"
$BOLD = "$ESC[1m"
$RESET = "$ESC[0m"

$GlossaryBase = "https://maxim.isystematic.com/docs/glossary"

function OSC8([string]$url, [string]$text) {
    return "$ESC]8;;$url$ESC\$text$ESC]8;;$ESC\"
}

function TierCtx([int]$p) { if ($p -lt 60) { $GREEN } elseif ($p -lt 80) { $YELLOW } else { $RED } }
function Tier5h ([int]$p) { if ($p -lt 70) { $GREEN } elseif ($p -lt 85) { $YELLOW } else { $RED } }
function Tier7d ([int]$p) { if ($p -lt 75) { $GREEN } elseif ($p -lt 80) { $YELLOW } else { $RED } }

function Get-NestedProperty($obj, [string[]]$path) {
    foreach ($key in $path) {
        if ($null -eq $obj) { return $null }
        $obj = $obj.PSObject.Properties[$key]?.Value
    }
    return $obj
}

# Parse Claude JSON fields
$ctxUsed = Get-NestedProperty $Claude @("context","used")
$ctxBudget = Get-NestedProperty $Claude @("context","budget")
$rate5h = Get-NestedProperty $Claude @("usage","five_hour_rate")
$rate7d = Get-NestedProperty $Claude @("usage","seven_day_rate")

# Compute percentages
$CtxPct = 0
if ($ctxBudget -and [double]$ctxBudget -gt 0) {
    $CtxPct = [int](100 * [double]$ctxUsed / [double]$ctxBudget)
}
$R5Pct = if ($rate5h) { [int](100 * [double]$rate5h) } else { 0 }
$R7Pct = if ($rate7d) { [int](100 * [double]$rate7d) } else { 0 }

# Project manifest
$ProjectId = "no-manifest"
$Lifecycle = "?"
if (Test-Path $ManifestFile) {
    try {
        $m = Get-Content $ManifestFile -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        $ProjectId = $m.project.id
        if (-not $ProjectId) { $ProjectId = $m.project_id }
        if (-not $ProjectId) { $ProjectId = "unknown" }
        $Lifecycle = $m.status.lifecycle
        if (-not $Lifecycle) { $Lifecycle = "active" }
    } catch {
        $ProjectId = "unknown"
        $Lifecycle = "?"
    }
}

# Last activity label key
$LabelKey = "default"
if (Test-Path $ActivityFile) {
    $lastLine = Get-Content $ActivityFile -Tail 1 -ErrorAction SilentlyContinue
    if ($lastLine) {
        try {
            $a = $lastLine | ConvertFrom-Json -ErrorAction Stop
            if ($a.label_key) { $LabelKey = $a.label_key }
        } catch { }
    }
}

# Label lookup
$LabelDisplay = "Maxim Ready"
$LabelGlossary = "maxim"
if (Test-Path $LabelsFile) {
    try {
        $raw = Get-Content $LabelsFile -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        $labels = $raw.labels
        $entry = $labels.$LabelKey
        if (-not $entry) { $entry = $labels.default }
        if ($entry.display)   { $LabelDisplay   = $entry.display }
        if ($entry.glossary)  { $LabelGlossary  = $entry.glossary }
    } catch { }
}

# Skill gap count
$Gaps = 0
if (Test-Path $GapsFile) {
    $Gaps = (Get-Content $GapsFile -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
    if (-not $Gaps) { $Gaps = 0 }
}

# Render
$ProjLink = OSC8 "$GlossaryBase#project" $ProjectId
$LabelLink = OSC8 "$GlossaryBase#$LabelGlossary" $LabelDisplay

$Line1 = "${BOLD}Maxim${RESET} $ProjLink ${DIM}(${Lifecycle})${RESET}  $LabelLink"
$Line2 = "ctx $(TierCtx $CtxPct)${CtxPct}%${RESET}  5h $(Tier5h $R5Pct)${R5Pct}%${RESET}  7d $(Tier7d $R7Pct)${R7Pct}%${RESET}  gaps $Gaps"

Write-Output $Line1
Write-Output $Line2
