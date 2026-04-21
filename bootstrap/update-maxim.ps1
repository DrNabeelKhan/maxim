# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# update-maxim.ps1 — Maxim Project Update & Migration Tool
# Version: 1.0.0  |  Maxim v1.0.0
# Cross-platform: PowerShell 7+ (Windows, macOS, Linux)
#
# Updates existing Maxim-bootstrapped projects to the latest version.
# Reads ALL existing project data before making changes.
# Never overwrites user data — only adds missing fields and creates missing files.
#
# Usage:
#   cd E:\Projects\Maxim\maxim
#   .\bootstrap\update-maxim.ps1
#   .\bootstrap\update-maxim.ps1 -WhatIf       # preview changes, no writes
#   .\bootstrap\update-maxim.ps1 -AutoScan     # skip discovery prompt, auto-scan known paths
#   .\bootstrap\update-maxim.ps1 -ProjectPaths "E:\Projects\my-app","E:\Projects\other-app"
#
# Cross-platform: PowerShell 7+ on Windows, macOS, Linux.
# ─────────────────────────────────────────────────────────────────────────────

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string[]]$ProjectPaths = @(),

    [Parameter(Mandatory = $false)]
    [switch]$AutoScan = $false,

    [Parameter(Mandatory = $false)]
    [switch]$SkipConfirmation = $false
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Resolve Maxim repo root (script lives in bootstrap/) ───────────────────────
$Maxim = Split-Path $MyInvocation.MyCommand.Path -Parent |
        Split-Path -Parent

# ── Read target version from agent-registry.json ──────────────────────────────
$registryPath = [IO.Path]::Combine($Maxim, "config", "agent-registry.json")
if (-not (Test-Path $registryPath)) {
    Write-Host ""
    Write-Host "ERROR: config/agent-registry.json not found at: $registryPath" -ForegroundColor Red
    Write-Host "       Is this script running from inside the maxim repo?" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

$registry = $null
try {
    $registry = Get-Content $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "ERROR: Failed to parse config/agent-registry.json: $_" -ForegroundColor Red
    exit 1
}

$TARGET_VERSION = $registry.version
if ([string]::IsNullOrWhiteSpace($TARGET_VERSION)) {
    Write-Host "ERROR: 'version' field missing from agent-registry.json" -ForegroundColor Red
    exit 1
}

# ── Read template manifest ─────────────────────────────────────────────────────
$templatePath = [IO.Path]::Combine($Maxim, "config", "project-manifest.TEMPLATE.json")
$TEMPLATE_MANIFEST = $null
if (Test-Path $templatePath) {
    try {
        $TEMPLATE_MANIFEST = Get-Content $templatePath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        Write-Host "WARNING: Could not parse project-manifest.TEMPLATE.json: $_" -ForegroundColor Yellow
    }
}

# ── Admin check (Windows only) ────────────────────────────────────────────────
if ($env:OS -match 'Windows' -or [System.Environment]::OSVersion.Platform -eq 'Win32NT') {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::
                GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host ""
        Write-Host "WARNING: Not running as Administrator." -ForegroundColor Yellow
        Write-Host "         Symlink creation may fail on Windows without elevation." -ForegroundColor DarkGray
        Write-Host "         Non-symlink updates will still proceed." -ForegroundColor DarkGray
        Write-Host ""
    }
}

# ── Header ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Maxim Update Tool v1.0.0  |  Target version: $TARGET_VERSION        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Maxim source : $Maxim" -ForegroundColor White
if ($WhatIfPreference) {
    Write-Host "  Mode        : DRY RUN (WhatIf) — no files will be written" -ForegroundColor Yellow
}
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────
# HELPER FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────

function Write-SectionHeader {
    param([string]$Text, [ConsoleColor]$Color = "White")
    Write-Host ""
    Write-Host "── $Text ──" -ForegroundColor $Color
}

function Write-BoxLine {
    param([string]$Text, [ConsoleColor]$Color = "White")
    # Pad to 60 chars for the box width
    $padded = $Text.PadRight(58)
    Write-Host "│ $padded │" -ForegroundColor $Color
}

function Test-JsonValid {
    param([string]$FilePath)
    try {
        $null = Get-Content $FilePath -Raw -Encoding UTF8 | ConvertFrom-Json
        return $true
    } catch {
        return $false
    }
}

function Get-InstallMode {
    param([string]$ProjectPath)
    $MaximSystem = [IO.Path]::Combine($ProjectPath, ".mxm-skills")
    $claudeLocal = [IO.Path]::Combine($ProjectPath, ".claude")
    $globalClaude = [IO.Path]::Combine($HOME, ".claude", "CLAUDE.md")

    if (Test-Path $MaximSystem) {
        return "LEGACY"
    } elseif ((Test-Path $globalClaude) -and -not (Test-Path $claudeLocal)) {
        return "GLOBAL"
    } elseif (Test-Path $claudeLocal) {
        return "LEGACY-DIRECT"
    } else {
        return "UNKNOWN"
    }
}

function Get-ManifestVersion {
    param($ManifestObj)
    if ($null -eq $ManifestObj) { return "unknown" }
    # Check mxm_version first, then version, then manifest_version
    if ($ManifestObj.PSObject.Properties.Name -contains "mxm_version" -and
        -not [string]::IsNullOrWhiteSpace($ManifestObj.mxm_version)) {
        return $ManifestObj.mxm_version
    }
    if ($ManifestObj.PSObject.Properties.Name -contains "version" -and
        -not [string]::IsNullOrWhiteSpace($ManifestObj.version)) {
        return $ManifestObj.version
    }
    return "unknown"
}

function Compare-Versions {
    param([string]$Current, [string]$Target)
    # Returns: -1 (current < target), 0 (equal), 1 (current > target)
    try {
        $c = [Version]$Current
        $t = [Version]$Target
        return $c.CompareTo($t)
    } catch {
        # Not valid semver — treat as unknown/older
        return -1
    }
}

# Deep-merge: copy missing keys from $Source into $Target object (non-destructive)
function Merge-JsonObject {
    param(
        [PSCustomObject]$Target,
        [PSCustomObject]$Source,
        [string]$Path = ""
    )

    if ($null -eq $Source) { return $Target }
    if ($null -eq $Target) { return $Source }

    foreach ($prop in $Source.PSObject.Properties) {
        $key = $prop.Name
        $fullPath = if ($Path) { "$Path.$key" } else { $key }

        if ($Target.PSObject.Properties.Name -notcontains $key) {
            # Key missing — add it
            $Target | Add-Member -NotePropertyName $key -NotePropertyValue $prop.Value -Force
        } elseif ($prop.Value -is [PSCustomObject] -and $Target.$key -is [PSCustomObject]) {
            # Recurse into nested objects
            $Target.$key = Merge-JsonObject -Target $Target.$key -Source $prop.Value -Path $fullPath
        }
        # All other cases: existing value wins — never overwrite
    }
    return $Target
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1 — PROJECT DISCOVERY
# ─────────────────────────────────────────────────────────────────────────────

function Find-ProjectsInPath {
    param([string]$BasePath, [int]$Depth = 3)

    $found = @()
    if (-not (Test-Path $BasePath)) { return $found }

    try {
        $manifests = Get-ChildItem -Path $BasePath -Recurse -Depth $Depth `
            -Filter "project-manifest.json" -File -ErrorAction SilentlyContinue |
            Where-Object {
                $_.FullName -notmatch [regex]::Escape([IO.Path]::Combine("node_modules")) -and
                $_.FullName -notmatch '\.git[\\/]' -and
                $_.FullName -notmatch [regex]::Escape([IO.Path]::Combine(".mxm-skills")) -and
                $_.DirectoryName -like "*config*"
            }

        foreach ($m in $manifests) {
            # The project root is the parent of the config/ folder
            $projectRoot = Split-Path $m.DirectoryName -Parent
            # Skip if this is the Maxim repo itself
            if ([IO.Path]::GetFullPath($projectRoot) -eq [IO.Path]::GetFullPath($Maxim)) { continue }
            $found += $projectRoot
        }
    } catch {
        # Silently skip inaccessible paths
    }

    return $found | Select-Object -Unique
}

function Get-ProjectsInteractive {
    param([string[]]$PreloadedPaths = @())

    $confirmedPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($p in $PreloadedPaths) {
        if (Test-Path $p) { $confirmedPaths.Add([IO.Path]::GetFullPath($p)) }
    }

    # Fast-path: if preloaded paths provided with SkipConfirmation, return immediately
    if ($PreloadedPaths.Count -gt 0 -and $SkipConfirmation) {
        return @($confirmedPaths)
    }

    if ($AutoScan -or $PreloadedPaths.Count -gt 0) {
        $mode = if ($PreloadedPaths.Count -gt 0) { "2" } else { "1" }
    } else {
        Write-Host "How would you like to find projects to update?" -ForegroundColor White
        Write-Host ""
        Write-Host "  1) Auto-scan  — search common project locations" -ForegroundColor Cyan
        Write-Host "  2) Enter paths — type paths manually, one per line" -ForegroundColor Cyan
        Write-Host ""
        $mode = (Read-Host "Choice [1/2]").Trim()
    }

    if ($mode -eq "2" -and $PreloadedPaths.Count -eq 0) {
        Write-Host ""
        Write-Host "Enter project paths (one per line). Press Enter on an empty line when done:" -ForegroundColor White
        while ($true) {
            $line = (Read-Host "  Path").Trim()
            if ([string]::IsNullOrWhiteSpace($line)) { break }
            $expanded = [System.Environment]::ExpandEnvironmentVariables($line)
            if (Test-Path $expanded) {
                $confirmedPaths.Add([IO.Path]::GetFullPath($expanded))
                Write-Host "    Added: $expanded" -ForegroundColor DarkGray
            } else {
                Write-Host "    WARNING: Path not found — skipped: $expanded" -ForegroundColor Yellow
            }
        }
    } else {
        # Auto-scan
        Write-Host ""
        Write-Host "Scanning common project locations..." -ForegroundColor White

        $scanBases = @()
        if ($env:OS -match 'Windows' -or [System.Environment]::OSVersion.Platform -eq 'Win32NT') {
            $scanBases += @(
                "E:\Projects",
                "C:\Projects",
                [IO.Path]::Combine($HOME, "Projects"),
                [IO.Path]::Combine($HOME, "dev")
            )
        } else {
            $scanBases += @(
                [IO.Path]::Combine($HOME, "Projects"),
                [IO.Path]::Combine($HOME, "projects"),
                [IO.Path]::Combine($HOME, "dev"),
                [IO.Path]::Combine($HOME, "code")
            )
        }

        $scanned = [System.Collections.Generic.List[string]]::new()
        foreach ($base in $scanBases) {
            Write-Host "  Scanning: $base" -ForegroundColor DarkGray
            $found = Find-ProjectsInPath -BasePath $base -Depth 3
            foreach ($f in $found) { $scanned.Add($f) }
        }

        if ($scanned.Count -eq 0) {
            Write-Host ""
            Write-Host "  No Maxim projects found via auto-scan." -ForegroundColor Yellow
            Write-Host "  Try option 2 to enter paths manually." -ForegroundColor DarkGray
            Write-Host ""
            return @()
        }

        Write-Host ""
        Write-Host "Found $($scanned.Count) Maxim project(s):" -ForegroundColor Green
        for ($i = 0; $i -lt $scanned.Count; $i++) {
            Write-Host "  [$($i+1)] $($scanned[$i])" -ForegroundColor White
        }
        Write-Host ""
        Write-Host "Options:" -ForegroundColor DarkGray
        Write-Host "  Press Enter     → confirm all" -ForegroundColor DarkGray
        Write-Host "  Type numbers    → e.g. '1,3' to select specific projects" -ForegroundColor DarkGray
        Write-Host "  Type 'add'      → add additional paths" -ForegroundColor DarkGray
        Write-Host ""

        $selection = (Read-Host "Selection").Trim()

        if ([string]::IsNullOrWhiteSpace($selection)) {
            foreach ($s in $scanned) { $confirmedPaths.Add($s) }
        } elseif ($selection -eq "add") {
            foreach ($s in $scanned) { $confirmedPaths.Add($s) }
            Write-Host "Enter additional paths (empty line to finish):" -ForegroundColor White
            while ($true) {
                $extra = (Read-Host "  Path").Trim()
                if ([string]::IsNullOrWhiteSpace($extra)) { break }
                $expanded = [System.Environment]::ExpandEnvironmentVariables($extra)
                if (Test-Path $expanded) {
                    $confirmedPaths.Add([IO.Path]::GetFullPath($expanded))
                } else {
                    Write-Host "    WARNING: Not found — skipped: $expanded" -ForegroundColor Yellow
                }
            }
        } else {
            # Parse comma/space-separated numbers
            $nums = $selection -split '[,\s]+' | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
            foreach ($n in $nums) {
                if ($n -ge 1 -and $n -le $scanned.Count) {
                    $confirmedPaths.Add($scanned[$n - 1])
                }
            }

            # Allow adding more
            $addMore = (Read-Host "Add more paths? (y/N)").Trim().ToLower()
            if ($addMore -eq "y") {
                Write-Host "Enter additional paths (empty line to finish):" -ForegroundColor White
                while ($true) {
                    $extra = (Read-Host "  Path").Trim()
                    if ([string]::IsNullOrWhiteSpace($extra)) { break }
                    $expanded = [System.Environment]::ExpandEnvironmentVariables($extra)
                    if (Test-Path $expanded) {
                        $confirmedPaths.Add([IO.Path]::GetFullPath($expanded))
                    } else {
                        Write-Host "    WARNING: Not found — skipped: $expanded" -ForegroundColor Yellow
                    }
                }
            }
        }
    }

    return $confirmedPaths | Select-Object -Unique
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2 — INTELLIGENCE SCAN
# ─────────────────────────────────────────────────────────────────────────────

function Invoke-ProjectScan {
    param([string]$ProjectPath)

    $result = [PSCustomObject]@{
        Path              = $ProjectPath
        Name              = Split-Path $ProjectPath -Leaf
        InstallMode       = "UNKNOWN"
        CurrentVersion    = "unknown"
        Manifest          = $null
        ManifestPath      = $null
        ClaudeProjectPath = $null
        LocalRegistryPath = $null
        PlanningFiles     = @{}
        SessionMemory     = @{}
        MaximRuntime       = @{}
        PhaseDocs         = @()
        Gaps              = [System.Collections.Generic.List[string]]::new()
        Adds              = [System.Collections.Generic.List[string]]::new()
        Warnings          = [System.Collections.Generic.List[string]]::new()
        FileCount         = 0
        SkipUpdate        = $false
    }

    # ── 3a. File inventory ───────────────────────────────────────────────────
    try {
        $allFiles = Get-ChildItem -Path $ProjectPath -Recurse -Depth 3 -File `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch 'node_modules|\.git[\\/]' }
        $result.FileCount = ($allFiles | Measure-Object).Count
    } catch {
        $result.FileCount = 0
    }

    $result.InstallMode = Get-InstallMode -ProjectPath $ProjectPath

    # ── 3b. Core config ──────────────────────────────────────────────────────
    $manifestPath = [IO.Path]::Combine($ProjectPath, "config", "project-manifest.json")
    $claudeProjectPath = [IO.Path]::Combine($ProjectPath, "CLAUDE.project.md")
    $localRegistryPath = [IO.Path]::Combine($ProjectPath, "config", "agent-registry.json")

    if (Test-Path $manifestPath) {
        $result.ManifestPath = $manifestPath
        try {
            $result.Manifest = Get-Content $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $result.CurrentVersion = Get-ManifestVersion -ManifestObj $result.Manifest
        } catch {
            $result.Warnings.Add("config/project-manifest.json — invalid JSON: $_")
        }
    } else {
        $result.Gaps.Add("config/project-manifest.json — missing")
    }

    if (Test-Path $claudeProjectPath) {
        $result.ClaudeProjectPath = $claudeProjectPath
    } else {
        $result.Gaps.Add("CLAUDE.project.md — missing")
    }

    if (Test-Path $localRegistryPath) {
        $result.LocalRegistryPath = $localRegistryPath
    } else {
        $result.Adds.Add("config/agent-registry.json — will create local copy")
    }

    # ── 3c. Planning state ───────────────────────────────────────────────────
    $planningLocations = @(
        [IO.Path]::Combine($ProjectPath, "task_plan.md"),
        [IO.Path]::Combine($ProjectPath, "progress.md"),
        [IO.Path]::Combine($ProjectPath, "findings.md"),
        [IO.Path]::Combine($ProjectPath, "planning", "task_plan.md"),
        [IO.Path]::Combine($ProjectPath, "planning", "progress.md"),
        [IO.Path]::Combine($ProjectPath, "planning", "findings.md")
    )

    # Deep bundles
    try {
        $deepBundles = Get-ChildItem -Path $ProjectPath -Recurse -Depth 3 `
            -Filter "task_plan.md" -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch 'node_modules|\.git[\\/]' }
        foreach ($d in $deepBundles) {
            if ($d.FullName -notin $planningLocations) {
                $planningLocations += $d.FullName
            }
        }

        # *-planning/ folders
        $planningDirs = Get-ChildItem -Path $ProjectPath -Directory -Depth 2 `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match 'planning' -and $_.FullName -notmatch 'node_modules|\.git[\\/]' }
        foreach ($dir in $planningDirs) {
            foreach ($ft in @("task_plan.md", "progress.md", "findings.md")) {
                $p = [IO.Path]::Combine($dir.FullName, $ft)
                if ($p -notin $planningLocations) { $planningLocations += $p }
            }
        }
    } catch { }

    $planFiles = @{ "task_plan" = [System.Collections.Generic.List[string]]::new()
                    "progress"  = [System.Collections.Generic.List[string]]::new()
                    "findings"  = [System.Collections.Generic.List[string]]::new() }

    foreach ($p in $planningLocations) {
        if (Test-Path $p) {
            $fname = [IO.Path]::GetFileNameWithoutExtension($p)
            if ($planFiles.ContainsKey($fname)) {
                $planFiles[$fname].Add($p)
            }
        }
    }
    $result.PlanningFiles = $planFiles

    # ── 3d. Claude memory & session state ────────────────────────────────────
    $memoryChecks = @{
        "handoff"       = @(
            [IO.Path]::Combine($ProjectPath, ".claude-sessions-memory", "handoff.md"),
            [IO.Path]::Combine($ProjectPath, ".mxm", "handoff.md")
        )
        "decision-log"  = @(
            [IO.Path]::Combine($ProjectPath, ".claude-sessions-memory", "decision-log.md"),
            [IO.Path]::Combine($ProjectPath, ".mxm", "decision-log.md")
        )
        "skill-gaps"    = @(
            [IO.Path]::Combine($ProjectPath, ".claude-sessions-memory", "skill-gaps.log"),
            [IO.Path]::Combine($ProjectPath, ".mxm", "skill-gaps.log")
        )
        "session-continuity" = @(
            [IO.Path]::Combine($ProjectPath, "documents/ledgers/SESSION_CONTINUITY.md")
        )
    }

    # Also check legacy claude-memory/ locations
    foreach ($memDir in @("claude-memory", ".claude-memory")) {
        $memPath = [IO.Path]::Combine($ProjectPath, $memDir)
        if (Test-Path $memPath) {
            try {
                $mdFiles = Get-ChildItem $memPath -Filter "*.md" -File -ErrorAction SilentlyContinue
                foreach ($mf in $mdFiles) {
                    $key = "legacy-$($mf.BaseName)"
                    if (-not $memoryChecks.ContainsKey($key)) {
                        $memoryChecks[$key] = @($mf.FullName)
                    }
                }
            } catch { }
        }
    }

    $sessionMemory = @{}
    foreach ($key in $memoryChecks.Keys) {
        $found = @()
        foreach ($p in $memoryChecks[$key]) {
            if (Test-Path $p) { $found += $p }
        }
        if ($found.Count -gt 0) { $sessionMemory[$key] = $found }
    }
    $result.SessionMemory = $sessionMemory

    # ── 3e. Maxim runtime state ────────────────────────────────────────────────
    $MaximDir   = [IO.Path]::Combine($ProjectPath, ".mxm")
    $MaximRuntime = @{
        "skill-gaps-count"    = 0
        "skill-gaps-last3"    = @()
        "handoff-status"      = "none"
        "bg-agent-count"      = 0
        "session-files"       = @()
    }

    $skillGapsPath = [IO.Path]::Combine($MaximDir, "skill-gaps.log")
    if (Test-Path $skillGapsPath) {
        try {
            $lines = Get-Content $skillGapsPath -Encoding UTF8 | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            $MaximRuntime["skill-gaps-count"] = ($lines | Measure-Object).Count
            $MaximRuntime["skill-gaps-last3"] = @($lines | Select-Object -Last 3)
        } catch { }
    }

    $handoffPath = [IO.Path]::Combine($MaximDir, "handoff.md")
    if (Test-Path $handoffPath) {
        try {
            $handoffContent = Get-Content $handoffPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
            if ($handoffContent -match 'status\s*[:=]\s*(\w+)') {
                $MaximRuntime["handoff-status"] = $Matches[1]
            } else {
                $MaximRuntime["handoff-status"] = "present"
            }
        } catch { }
    }

    $bgLogPath = [IO.Path]::Combine($MaximDir, "background-agent.log")
    if (Test-Path $bgLogPath) {
        try {
            $bgLines = Get-Content $bgLogPath -Encoding UTF8 -ErrorAction SilentlyContinue
            $MaximRuntime["bg-agent-count"] = ($bgLines | Measure-Object).Count
        } catch { }
    }

    # Session files — .mxm-skills/ and platform/.mxm-skills/
    $sessionDirs = @($MaximDir, [IO.Path]::Combine($ProjectPath, "platform", ".mxm"))
    foreach ($sd in $sessionDirs) {
        if (Test-Path $sd) {
            try {
                $sessions = Get-ChildItem $sd -Filter "session-*.md" -File -ErrorAction SilentlyContinue
                foreach ($s in $sessions) { $MaximRuntime["session-files"] += $s.FullName }
            } catch { }
        }
    }

    $result.MaximRuntime = $MaximRuntime

    # ── 3f. Phase docs ───────────────────────────────────────────────────────
    $phaseDocs = @()
    try {
        $phaseFiles = Get-ChildItem $ProjectPath -File -Depth 1 -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '^(PHASE|V1_SPRINT)\d*_CLI_INSTRUCTIONS' }
        foreach ($pf in $phaseFiles) { $phaseDocs += $pf.Name }
    } catch { }
    $result.PhaseDocs = $phaseDocs

    # ── 3g. Manifest-referenced documents ────────────────────────────────────
    if ($null -ne $result.Manifest -and
        $result.Manifest.PSObject.Properties.Name -contains "documents") {
        $docs = $result.Manifest.documents
        if ($null -ne $docs) {
            foreach ($prop in $docs.PSObject.Properties) {
                $docPath = [IO.Path]::Combine($ProjectPath, $prop.Value)
                if (-not (Test-Path $docPath)) {
                    $result.Warnings.Add("Referenced doc missing: $($prop.Value)")
                }
            }
        }
    }

    # ── Gap / Add detection ──────────────────────────────────────────────────

    # Required directories
    $requiredDirs = @(
        @{ Rel = ".mxm-skills";                 Label = ".mxm-skills/" },
        @{ Rel = ".claude-sessions-memory";     Label = ".claude-sessions-memory/" },
        @{ Rel = "config";                      Label = "config/" },
        @{ Rel = "docs\architecture";           Label = "documents/architecture/" },
        @{ Rel = "docs\architecture\.secrets";  Label = "documents/architecture/.secrets/" },
        @{ Rel = "docs\business";               Label = "documents/business/" },
        @{ Rel = "prototypes";                  Label = "prototypes/" },
        @{ Rel = ".mxm-operator-profile";      Label = ".mxm-operator-profile/" }
    )
    foreach ($d in $requiredDirs) {
        $p = [IO.Path]::Combine($ProjectPath, $d.Rel)
        if (-not (Test-Path $p)) {
            $result.Adds.Add("$($d.Label) — will create")
        }
    }

    # .claude.local/settings.local.json
    $settingsPath = [IO.Path]::Combine($ProjectPath, ".claude.local", "settings.local.json")
    if (-not (Test-Path $settingsPath)) {
        $result.Adds.Add(".claude.local/settings.local.json — will create")
    }

    # .mxm runtime files
    $MaximFiles = @(
        @{ Rel = ".mxm-skills/agents-skill-gaps.log";        Label = ".mxm-skills/agents-skill-gaps.log" },
        @{ Rel = ".mxm-skills/agents-handoff.md";            Label = ".mxm-skills/agents-handoff.md" },
        @{ Rel = ".mxm-skills/agents-background.log";  Label = ".mxm-skills/agents-background.log" }
    )
    foreach ($af in $MaximFiles) {
        $p = [IO.Path]::Combine($ProjectPath, $af.Rel)
        if (-not (Test-Path $p)) {
            $result.Adds.Add("$($af.Label) — will create")
        }
    }

    # .claude-sessions-memory files
    $memFiles = @(
        @{ Rel = ".claude-sessions-memory/handoff.md";    Label = ".claude-sessions-memory/handoff.md" },
        @{ Rel = ".claude-sessions-memory/decision-log.md"; Label = ".claude-sessions-memory/decision-log.md" },
        @{ Rel = ".claude-sessions-memory/skill-gaps.log"; Label = ".claude-sessions-memory/skill-gaps.log" }
    )
    foreach ($mf in $memFiles) {
        $p = [IO.Path]::Combine($ProjectPath, $mf.Rel)
        if (-not (Test-Path $p)) {
            $result.Adds.Add("$($mf.Label) — will create")
        }
    }

    # Operator profile files
    $operatorFiles = @(
        @{ Rel = ".mxm-operator-profile\OPERATOR.md";              Label = ".mxm-operator-profile/OPERATOR.md" },
        @{ Rel = ".mxm-operator-profile\preferences.md";           Label = ".mxm-operator-profile/preferences.md" },
        @{ Rel = ".mxm-operator-profile\rejected-patterns.md";     Label = ".mxm-operator-profile/rejected-patterns.md" },
        @{ Rel = ".mxm-operator-profile\communication-style.md";   Label = ".mxm-operator-profile/communication-style.md" }
    )
    foreach ($of in $operatorFiles) {
        $p = [IO.Path]::Combine($ProjectPath, $of.Rel)
        if (-not (Test-Path $p)) {
            $result.Adds.Add("$($of.Label) — will create")
        }
    }

    # Manifest field checks
    if ($null -ne $result.Manifest) {
        # super_user field
        if ($result.Manifest.PSObject.Properties.Name -notcontains "super_user") {
            $result.Gaps.Add("super_user — missing (will add: enabled=false)")
        }

        # domains field
        if ($result.Manifest.PSObject.Properties.Name -notcontains "domains" -and
            $result.Manifest.PSObject.Properties.Name -notcontains "portfolio") {
            $result.Gaps.Add("domains — missing (will add placeholder)")
        }

        # project.id
        if ($result.Manifest.PSObject.Properties.Name -contains "project" -and
            $null -ne $result.Manifest.project -and
            ($result.Manifest.project.PSObject.Properties.Name -notcontains "id" -or
             [string]::IsNullOrWhiteSpace($result.Manifest.project.id) -or
             $result.Manifest.project.id -eq "your-project-id")) {
            $result.Warnings.Add("project.id not set — update manually after migration")
        }
    }

    return $result
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3 — DISPLAY GAP REPORT
# ─────────────────────────────────────────────────────────────────────────────

function Show-ProjectReport {
    param([PSCustomObject]$ScanResult)

    $r = $ScanResult
    $versionCmp = Compare-Versions -Current $r.CurrentVersion -Target $TARGET_VERSION

    $versionColor = if ($versionCmp -lt 0) { "Yellow" } elseif ($versionCmp -eq 0) { "Green" } else { "Cyan" }

    Write-Host ""
    Write-Host "┌──────────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host ("│ Project: " + $r.Name).PadRight(63) + "│" -ForegroundColor Cyan
    Write-Host ("│ Install: $($r.InstallMode) | Current: $($r.CurrentVersion) | Target: $TARGET_VERSION").PadRight(63) + "│" -ForegroundColor $versionColor
    Write-Host "├──────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan

    # Manifest fields
    Write-Host "│ Manifest:".PadRight(63) + "│" -ForegroundColor White
    if ($null -ne $r.Manifest) {
        $projectId = "n/a"
        $compliance = "n/a"
        if ($r.Manifest.PSObject.Properties.Name -contains "project" -and $null -ne $r.Manifest.project) {
            $projectId = if ($r.Manifest.project.id) { $r.Manifest.project.id } else { "not set" }
        }
        if ($r.Manifest.PSObject.Properties.Name -contains "compliance" -and $null -ne $r.Manifest.compliance) {
            $fw = $r.Manifest.compliance.frameworks
            $compliance = if ($fw -and $fw.Count -gt 0) { "[" + ($fw -join ", ") + "]" } else { "[]" }
        }
        Write-Host ("│   project.id: $projectId").PadRight(63) + "│" -ForegroundColor DarkGray
        Write-Host ("│   compliance.frameworks: $compliance").PadRight(63) + "│" -ForegroundColor DarkGray
    } else {
        Write-Host "│   (no manifest loaded)".PadRight(63) + "│" -ForegroundColor Yellow
    }

    foreach ($gap in $r.Gaps) {
        Write-Host ("│   WARNING  $gap").PadRight(63) + "│" -ForegroundColor Yellow
    }

    Write-Host "│".PadRight(63) + "│" -ForegroundColor Cyan

    # Files
    Write-Host "│ Files:".PadRight(63) + "│" -ForegroundColor White
    $fileChecks = @(
        @{ Rel = "config/project-manifest.json"; Label = "config/project-manifest.json" },
        @{ Rel = "CLAUDE.project.md";            Label = "CLAUDE.project.md" },
        @{ Rel = ".mxm-skills/agents-skill-gaps.log";         Label = ".mxm-skills/agents-skill-gaps.log" },
        @{ Rel = ".claude-sessions-memory";      Label = ".claude-sessions-memory/" },
        @{ Rel = ".claude.local/settings.local.json"; Label = ".claude.local/settings.local.json" }
    )
    foreach ($fc in $fileChecks) {
        $p = [IO.Path]::Combine($r.Path, $fc.Rel)
        if (Test-Path $p) {
            Write-Host ("│   OK  $($fc.Label)").PadRight(63) + "│" -ForegroundColor DarkGreen
        } else {
            Write-Host ("│   MISSING  $($fc.Label) — will create").PadRight(63) + "│" -ForegroundColor Red
        }
    }

    Write-Host "│".PadRight(63) + "│" -ForegroundColor Cyan

    # Planning
    Write-Host "│ Planning:".PadRight(63) + "│" -ForegroundColor White
    foreach ($key in @("task_plan", "progress", "findings")) {
        $paths = $r.PlanningFiles[$key]
        if ($paths -and $paths.Count -gt 0) {
            if ($paths.Count -gt 1) {
                Write-Host ("│   MERGE  $key.md found at $($paths.Count) locations — will merge").PadRight(63) + "│" -ForegroundColor Cyan
            } else {
                $rel = $paths[0] -replace [regex]::Escape($r.Path), "."
                Write-Host ("│   OK  $key.md at $rel").PadRight(63) + "│" -ForegroundColor DarkGreen
            }
        } else {
            Write-Host ("│   (no $key.md found)").PadRight(63) + "│" -ForegroundColor DarkGray
        }
    }

    Write-Host "│".PadRight(63) + "│" -ForegroundColor Cyan

    # Session memory
    Write-Host "│ Session Memory:".PadRight(63) + "│" -ForegroundColor White
    if ($r.SessionMemory.ContainsKey("session-continuity")) {
        Write-Host "│   WARNING  documents/ledgers/SESSION_CONTINUITY.md found — will preserve".PadRight(63) + "│" -ForegroundColor Yellow
    }
    foreach ($key in $r.SessionMemory.Keys | Where-Object { $_ -ne "session-continuity" } | Select-Object -First 3) {
        Write-Host ("│   OK  $key").PadRight(63) + "│" -ForegroundColor DarkGray
    }

    Write-Host "│".PadRight(63) + "│" -ForegroundColor Cyan

    # Runtime
    $gapCount   = $r.MaximRuntime["skill-gaps-count"]
    $handoff    = $r.MaximRuntime["handoff-status"]
    $sessionCnt = ($r.MaximRuntime["session-files"] | Measure-Object).Count
    $phaseCount = $r.PhaseDocs.Count

    Write-Host ("│ Skill Gaps: $gapCount entries | Handoff: $handoff | Sessions: $sessionCnt").PadRight(63) + "│" -ForegroundColor White
    if ($phaseCount -gt 0) {
        Write-Host ("│ Phase docs: $phaseCount doc(s) found").PadRight(63) + "│" -ForegroundColor DarkGray
    }

    # Warnings
    foreach ($w in $r.Warnings) {
        Write-Host ("│ WARNING  $w").PadRight(63) + "│" -ForegroundColor Yellow
    }

    Write-Host "└──────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4 — MERGE DUPLICATE PLANNING FILES
# ─────────────────────────────────────────────────────────────────────────────

function Merge-PlanningFiles {
    param(
        [string]$ProjectPath,
        [hashtable]$PlanningFiles
    )

    $staleRefs = [System.Collections.Generic.List[string]]::new()

    foreach ($fileType in $PlanningFiles.Keys) {
        $paths = @($PlanningFiles[$fileType])
        if ($paths.Count -le 1) { continue }

        # Canonical destination
        $memDir   = [IO.Path]::Combine($ProjectPath, ".claude-sessions-memory")
        $canonical = [IO.Path]::Combine($memDir, "$fileType.md")

        # Backup folder
        $backupDir = [IO.Path]::Combine($ProjectPath, ".mxm-backup",
                        "merged-$(Get-Date -Format 'yyyy-MM-dd')")

        if (-not $WhatIfPreference) {
            New-Item -ItemType Directory -Force $backupDir -ErrorAction SilentlyContinue | Out-Null
            New-Item -ItemType Directory -Force $memDir -ErrorAction SilentlyContinue | Out-Null
        }

        # Sort oldest first
        $sorted = $paths | Sort-Object { (Get-Item $_).LastWriteTime }

        # Build merged content
        $mergedLines = [System.Collections.Generic.List[string]]::new()
        $mergedLines.Add("# $fileType — Merged by Maxim Update Tool $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
        $mergedLines.Add("")

        foreach ($p in $sorted) {
            $relPath = $p -replace [regex]::Escape($ProjectPath), "."
            $mergedLines.Add("# --- Merged from: $relPath ---")
            try {
                $content = Get-Content $p -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
                if (-not [string]::IsNullOrWhiteSpace($content)) {
                    $mergedLines.Add($content)
                }
            } catch {
                $mergedLines.Add("# (could not read: $_)")
            }
            $mergedLines.Add("")
        }

        if (-not $WhatIfPreference) {
            Set-Content $canonical ($mergedLines -join "`n") -Encoding UTF8

            # Backup originals
            $mergeLog = [IO.Path]::Combine($backupDir, "MERGE_LOG.md")
            foreach ($p in $paths) {
                try {
                    $backupName = ($p -replace [regex]::Escape($ProjectPath), "") `
                                    -replace '[/\\]', '_'
                    $backupName = $backupName.TrimStart('_')
                    Copy-Item $p ([IO.Path]::Combine($backupDir, $backupName)) -Force -ErrorAction SilentlyContinue
                } catch { }
            }

            $logEntry = @"

## $fileType.md merge — $(Get-Date -Format 'yyyy-MM-dd HH:mm')
Sources   : $($paths -join ', ')
Canonical : $canonical
Maxim ver  : $TARGET_VERSION
"@
            Add-Content $mergeLog $logEntry -Encoding UTF8 -ErrorAction SilentlyContinue
        }

        Write-Host "    MERGED  $($paths.Count) copies of $fileType.md -> .claude-sessions-memory/" -ForegroundColor Cyan

        # Scan for stale references
        try {
            $mdFiles = Get-ChildItem $ProjectPath -Filter "*.md" -Depth 2 -File `
                -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch 'node_modules|\.git[\\/]' }
            foreach ($md in $mdFiles) {
                try {
                    $content = Get-Content $md.FullName -Raw -ErrorAction SilentlyContinue
                    if ($content -match "planning/$fileType\.md|\./$fileType\.md") {
                        $staleRefs.Add("  Stale ref in $($md.Name): '$($Matches[0])' -> '.claude-sessions-memory/$fileType.md'")
                    }
                } catch { }
            }
        } catch { }
    }

    foreach ($ref in $staleRefs) {
        Write-Host $ref -ForegroundColor Yellow
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5 — APPLY UPDATES
# ─────────────────────────────────────────────────────────────────────────────

function Invoke-ProjectUpdate {
    param([PSCustomObject]$ScanResult)

    $r = $ScanResult
    $projectPath = $r.Path
    $updated = $false
    $filesAdded = 0
    $errors = [System.Collections.Generic.List[string]]::new()

    Write-Host ""
    Write-Host "  Updating: $($r.Name)" -ForegroundColor White

    # ── Backup manifest + CLAUDE.project.md ─────────────────────────────────
    if ($null -ne $r.ManifestPath -and (Test-Path $r.ManifestPath)) {
        if (-not $WhatIfPreference) {
            try {
                Copy-Item $r.ManifestPath "$($r.ManifestPath).backup" -Force
            } catch {
                $errors.Add("Backup failed for manifest: $_")
            }
        } else {
            Write-Host "    WhatIf: would backup $($r.ManifestPath)" -ForegroundColor DarkGray
        }
    }

    if ($null -ne $r.ClaudeProjectPath -and (Test-Path $r.ClaudeProjectPath)) {
        if (-not $WhatIfPreference) {
            try {
                Copy-Item $r.ClaudeProjectPath "$($r.ClaudeProjectPath).backup" -Force
            } catch {
                $errors.Add("Backup failed for CLAUDE.project.md: $_")
            }
        } else {
            Write-Host "    WhatIf: would backup CLAUDE.project.md" -ForegroundColor DarkGray
        }
    }

    # ── Create required directories ──────────────────────────────────────────
    $requiredDirs = @(
        [IO.Path]::Combine($projectPath, "config"),
        [IO.Path]::Combine($projectPath, ".mxm-skills"),
        [IO.Path]::Combine($projectPath, ".claude-sessions-memory"),
        [IO.Path]::Combine($projectPath, ".mxm-operator-profile"),
        [IO.Path]::Combine($projectPath, ".claude.local")
    )
    foreach ($dir in $requiredDirs) {
        if (-not (Test-Path $dir)) {
            if (-not $WhatIfPreference) {
                try {
                    New-Item -ItemType Directory -Force $dir -ErrorAction Stop | Out-Null
                    Write-Host "    Created: $(Split-Path $dir -Leaf)/" -ForegroundColor DarkGray
                    $filesAdded++
                    $updated = $true
                } catch {
                    $errors.Add("Failed to create ${dir}: $_")
                }
            } else {
                Write-Host "    WhatIf: would create $dir" -ForegroundColor DarkGray
            }
        }
    }

    # ── Merge manifest (preserve + extend) ──────────────────────────────────
    if ($null -ne $r.ManifestPath -and $null -ne $r.Manifest -and $null -ne $TEMPLATE_MANIFEST) {
        $merged = Merge-JsonObject -Target $r.Manifest -Source $TEMPLATE_MANIFEST

        # Always update these tracking fields
        $merged.mxm_version = $TARGET_VERSION
        $merged.last_updated = (Get-Date -Format "yyyy-MM-dd")
        if ($merged.PSObject.Properties.Name -notcontains "next_review") {
            $merged | Add-Member -NotePropertyName "next_review" -NotePropertyValue `
                ((Get-Date).AddMonths(3).ToString("yyyy-MM-dd")) -Force
        } else {
            $merged.next_review = (Get-Date).AddMonths(3).ToString("yyyy-MM-dd")
        }

        # Ensure super_user block if missing
        if ($merged.PSObject.Properties.Name -notcontains "super_user") {
            $merged | Add-Member -NotePropertyName "super_user" -NotePropertyValue ([PSCustomObject]@{
                enabled  = $false
                identity = ""
                bypass   = [PSCustomObject]@{
                    cso_auto_loop         = $false
                    ethics_gate           = $false
                    compliance_pre_check  = $false
                    confidence_tagging    = $false
                    escalation_required   = $false
                }
                note = "Set enabled: true and identity to activate super user mode."
            }) -Force
        }

        $newJson = $merged | ConvertTo-Json -Depth 10 -Compress:$false

        # Validate before writing
        try {
            $null = $newJson | ConvertFrom-Json
            if (-not $WhatIfPreference) {
                Set-Content $r.ManifestPath $newJson -Encoding UTF8
                Write-Host "    Updated: config/project-manifest.json (version -> $TARGET_VERSION)" -ForegroundColor Green
                $updated = $true
            } else {
                Write-Host "    WhatIf: would update config/project-manifest.json" -ForegroundColor DarkGray
            }
        } catch {
            $errors.Add("JSON validation failed after manifest merge — skipped write: $_")
            Write-Host "    ERROR: JSON validation failed — manifest not written" -ForegroundColor Red
        }
    } elseif ($null -eq $r.ManifestPath) {
        # Create a minimal manifest from template
        if ($null -ne $TEMPLATE_MANIFEST -and -not $WhatIfPreference) {
            $configDir = [IO.Path]::Combine($projectPath, "config")
            New-Item -ItemType Directory -Force $configDir -ErrorAction SilentlyContinue | Out-Null
            $newManifestPath = [IO.Path]::Combine($configDir, "project-manifest.json")
            $TEMPLATE_MANIFEST.mxm_version = $TARGET_VERSION
            $TEMPLATE_MANIFEST.last_updated = (Get-Date -Format "yyyy-MM-dd")
            Set-Content $newManifestPath ($TEMPLATE_MANIFEST | ConvertTo-Json -Depth 10) -Encoding UTF8
            Write-Host "    Created: config/project-manifest.json (from template)" -ForegroundColor Cyan
            $filesAdded++
            $updated = $true
        } elseif ($WhatIfPreference) {
            Write-Host "    WhatIf: would create config/project-manifest.json from template" -ForegroundColor DarkGray
        }
    }

    # ── Copy local agent-registry.json ──────────────────────────────────────
    if ($null -eq $r.LocalRegistryPath) {
        $destRegistry = [IO.Path]::Combine($projectPath, "config", "agent-registry.json")
        if (-not $WhatIfPreference) {
            try {
                Copy-Item $registryPath $destRegistry -Force
                Write-Host "    Created: config/agent-registry.json" -ForegroundColor DarkGray
                $filesAdded++
                $updated = $true
            } catch {
                $errors.Add("Failed to copy agent-registry.json: $_")
            }
        } else {
            Write-Host "    WhatIf: would create config/agent-registry.json" -ForegroundColor DarkGray
        }
    }

    # ── Create .mxm-skills runtime files ───────────────────────────────────
    $MaximDir = [IO.Path]::Combine($projectPath, ".mxm-skills")
    $MaximFiles = @(
        @{
            Path    = [IO.Path]::Combine($MaximDir, "skill-gaps.log")
            Content = "# Maxim Skill Gaps Log — initialized by update-maxim.ps1 $(Get-Date -Format 'yyyy-MM-dd')`n"
            Label   = ".mxm-skills/agents-skill-gaps.log"
        },
        @{
            Path    = [IO.Path]::Combine($MaximDir, "handoff.md")
            Content = "# Maxim Handoff State`n`nstatus: none`n`n_Initialized by update-maxim.ps1 $(Get-Date -Format 'yyyy-MM-dd')_`n"
            Label   = ".mxm-skills/agents-handoff.md"
        },
        @{
            Path    = [IO.Path]::Combine($MaximDir, "background-agent.log")
            Content = "# Maxim Background Agent Log — initialized by update-maxim.ps1 $(Get-Date -Format 'yyyy-MM-dd')`n"
            Label   = ".mxm-skills/agents-background.log"
        }
    )
    foreach ($af in $MaximFiles) {
        if (-not (Test-Path $af.Path)) {
            if (-not $WhatIfPreference) {
                try {
                    Set-Content $af.Path $af.Content -Encoding UTF8
                    Write-Host "    Created: $($af.Label)" -ForegroundColor DarkGray
                    $filesAdded++
                    $updated = $true
                } catch {
                    $errors.Add("Failed to create $($af.Label): $_")
                }
            } else {
                Write-Host "    WhatIf: would create $($af.Label)" -ForegroundColor DarkGray
            }
        }
    }

    # ── Create .claude-sessions-memory files ─────────────────────────────────
    $memDir = [IO.Path]::Combine($projectPath, ".claude-sessions-memory")
    $memFiles = @(
        @{
            Path    = [IO.Path]::Combine($memDir, "handoff.md")
            Content = "# Maxim Handoff State`n`nstatus: none`n`n_Initialized by update-maxim.ps1 $(Get-Date -Format 'yyyy-MM-dd')_`n"
            Label   = ".claude-sessions-memory/handoff.md"
        },
        @{
            Path    = [IO.Path]::Combine($memDir, "decision-log.md")
            Content = "# Maxim Decision Log`n`n_Initialized by update-maxim.ps1 $(Get-Date -Format 'yyyy-MM-dd')_`n"
            Label   = ".claude-sessions-memory/decision-log.md"
        },
        @{
            Path    = [IO.Path]::Combine($memDir, "skill-gaps.log")
            Content = "# Maxim Skill Gaps Log`n`n_Initialized by update-maxim.ps1 $(Get-Date -Format 'yyyy-MM-dd')_`n"
            Label   = ".claude-sessions-memory/skill-gaps.log"
        }
    )
    foreach ($mf in $memFiles) {
        if (-not (Test-Path $mf.Path)) {
            if (-not $WhatIfPreference) {
                try {
                    Set-Content $mf.Path $mf.Content -Encoding UTF8
                    Write-Host "    Created: $($mf.Label)" -ForegroundColor DarkGray
                    $filesAdded++
                    $updated = $true
                } catch {
                    $errors.Add("Failed to create $($mf.Label): $_")
                }
            } else {
                Write-Host "    WhatIf: would create $($mf.Label)" -ForegroundColor DarkGray
            }
        }
    }

    # ── Create .mxm-operator-profile files ────────────────────────────────────
    $operatorDir = [IO.Path]::Combine($projectPath, ".mxm-operator-profile")
    $operatorFiles = @(
        @{
            Path    = [IO.Path]::Combine($operatorDir, "OPERATOR.md")
            Content = @"
# Operator Profile
# Updated automatically at session end by Maxim behavioral-designer agent.

## Identity
<!-- Name, role, organization -->

## Working Style
<!-- Preferences -->

## Output Preferences
<!-- Format preferences -->

## Technical Context
<!-- Languages, frameworks, tools -->
"@
            Label   = ".mxm-operator-profile/OPERATOR.md"
        },
        @{
            Path    = [IO.Path]::Combine($operatorDir, "preferences.md")
            Content = "# Operator Preferences`n"
            Label   = ".mxm-operator-profile/preferences.md"
        },
        @{
            Path    = [IO.Path]::Combine($operatorDir, "rejected-patterns.md")
            Content = "# Rejected Patterns`n"
            Label   = ".mxm-operator-profile/rejected-patterns.md"
        },
        @{
            Path    = [IO.Path]::Combine($operatorDir, "communication-style.md")
            Content = "# Communication Style`n"
            Label   = ".mxm-operator-profile/communication-style.md"
        }
    )
    foreach ($of in $operatorFiles) {
        if (-not (Test-Path $of.Path)) {
            if (-not $WhatIfPreference) {
                try {
                    Set-Content $of.Path $of.Content -Encoding UTF8
                    Write-Host "    Created: $($of.Label)" -ForegroundColor DarkGray
                    $filesAdded++
                    $updated = $true
                } catch {
                    $errors.Add("Failed to create $($of.Label): $_")
                }
            } else {
                Write-Host "    WhatIf: would create $($of.Label)" -ForegroundColor DarkGray
            }
        }
    }

    # ── Create .claude.local/settings.local.json ─────────────────────────────
    $settingsPath = [IO.Path]::Combine($projectPath, ".claude.local", "settings.local.json")
    if (-not (Test-Path $settingsPath)) {
        $settingsContent = [PSCustomObject]@{
            _comment      = "Per-project Maxim settings. Do not commit to git."
            mxm_version  = $TARGET_VERSION
            project_root  = $projectPath
            install_mode  = $r.InstallMode
            created_by    = "update-maxim.ps1"
            created_at    = (Get-Date -Format "yyyy-MM-dd HH:mm")
        } | ConvertTo-Json -Depth 5

        if (-not $WhatIfPreference) {
            try {
                Set-Content $settingsPath $settingsContent -Encoding UTF8
                Write-Host "    Created: .claude.local/settings.local.json" -ForegroundColor DarkGray
                $filesAdded++
                $updated = $true
            } catch {
                $errors.Add("Failed to create settings.local.json: $_")
            }
        } else {
            Write-Host "    WhatIf: would create .claude.local/settings.local.json" -ForegroundColor DarkGray
        }
    }

    # ── Update .gitignore ─────────────────────────────────────────────────────
    $gitignorePath = [IO.Path]::Combine($projectPath, ".gitignore")
    $gitignoreEntries = @(
        "# Maxim per-project — do not commit",
        ".claude.local/",
        "*.backup",
        ".mxm-backup/",
        ".claude-sessions-memory/",
        ".mxm-skills/agents-session-*.md",
        ".mxm-skills/agents-background.log",
        "documents/architecture/",
        "config/mempalace.yaml",
        ".mempalace/",
        ".mxm-operator-profile/"
    )
    $existingGitignore = ""
    if (Test-Path $gitignorePath) {
        try { $existingGitignore = Get-Content $gitignorePath -Raw -Encoding UTF8 } catch { }
    }
    $missingEntries = @($gitignoreEntries | Where-Object {
        $entry = $_.Trim()
        $entry -notlike "#*" -and $existingGitignore -notmatch [regex]::Escape($entry)
    })
    if ($missingEntries.Count -gt 0) {
        if (-not $WhatIfPreference) {
            try {
                $toAppend = "`n" + ($gitignoreEntries -join "`n") + "`n"
                Add-Content $gitignorePath $toAppend -Encoding UTF8
                Write-Host "    Updated: .gitignore (added $($missingEntries.Count) Maxim entries)" -ForegroundColor DarkGray
                $updated = $true
            } catch {
                $errors.Add("Failed to update .gitignore: $_")
            }
        } else {
            Write-Host "    WhatIf: would add $($missingEntries.Count) entries to .gitignore" -ForegroundColor DarkGray
        }
    }

    # ── CLAUDE.project.md — create if missing ────────────────────────────────
    if ($null -eq $r.ClaudeProjectPath) {
        $claudeProjectDest = [IO.Path]::Combine($projectPath, "CLAUDE.project.md")
        $claudeProjectContent = @"
# CLAUDE.project.md — Project-Specific Maxim Rules
# Project: $($r.Name)
# Created by: update-maxim.ps1 v1.0.0 | Maxim $TARGET_VERSION
# Date: $(Get-Date -Format 'yyyy-MM-dd')
#
# This file overrides or extends CLAUDE.md for this specific project.
# Fill in your project details below.

## Project Identity

- **Project ID**: (set in config/project-manifest.json → project.id)
- **Stack**: (e.g. Next.js + Supabase + Stripe)
- **Stage**: (idea | early-stage | active | scaling | mature)

## Brand Voice

(Describe your brand tone, personality, target audience)

## Key Constraints

(Any technical, regulatory, or business constraints the AI should know)

## Compliance Scope

(Markets / frameworks: e.g. GDPR, PIPEDA, SOC2 — mirror config/project-manifest.json → compliance)

## Agent Overrides

(Any per-project agent behavior changes — leave empty for standard Maxim behavior)
"@
        if (-not $WhatIfPreference) {
            try {
                Set-Content $claudeProjectDest $claudeProjectContent -Encoding UTF8
                Write-Host "    Created: CLAUDE.project.md (template — fill in your project details)" -ForegroundColor Cyan
                $filesAdded++
                $updated = $true
            } catch {
                $errors.Add("Failed to create CLAUDE.project.md: $_")
            }
        } else {
            Write-Host "    WhatIf: would create CLAUDE.project.md (from template)" -ForegroundColor DarkGray
        }
    }

    # ── Merge duplicate planning files ────────────────────────────────────────
    $hasDuplicates = $r.PlanningFiles.Keys | Where-Object { $r.PlanningFiles[$_].Count -gt 1 }
    if ($hasDuplicates) {
        Write-Host "    Merging duplicate planning files..." -ForegroundColor Cyan
        Merge-PlanningFiles -ProjectPath $projectPath -PlanningFiles $r.PlanningFiles
        $updated = $true
    }

    # ── Final JSON validation ─────────────────────────────────────────────────
    $finalManifestPath = [IO.Path]::Combine($projectPath, "config", "project-manifest.json")
    if (Test-Path $finalManifestPath) {
        if (-not (Test-JsonValid -FilePath $finalManifestPath)) {
            $errors.Add("config/project-manifest.json failed final JSON validation — check manually")
            Write-Host "    ERROR: config/project-manifest.json failed JSON validation" -ForegroundColor Red
        }
    }

    return [PSCustomObject]@{
        ProjectName  = $r.Name
        OldVersion   = $r.CurrentVersion
        NewVersion   = $TARGET_VERSION
        FilesAdded   = $filesAdded
        Updated      = $updated
        Errors       = $errors
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# MAIN EXECUTION
# ─────────────────────────────────────────────────────────────────────────────

# ── Project discovery ─────────────────────────────────────────────────────────
$projectList = @()

if ($ProjectPaths.Count -gt 0) {
    $projectList = @(Get-ProjectsInteractive -PreloadedPaths $ProjectPaths)
} else {
    $projectList = @(Get-ProjectsInteractive)
}

if ($projectList.Count -eq 0) {
    Write-Host ""
    Write-Host "No projects selected. Exiting." -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "Selected $($projectList.Count) project(s) for update." -ForegroundColor White

# ── Scan all projects ─────────────────────────────────────────────────────────
Write-SectionHeader "Running Intelligence Scan" "White"
$scanResults = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($projectPath in $projectList) {
    Write-Host "  Scanning: $projectPath" -ForegroundColor DarkGray
    try {
        $scan = Invoke-ProjectScan -ProjectPath $projectPath
        $scanResults.Add($scan)
    } catch {
        Write-Host "  ERROR scanning ${projectPath}: $_" -ForegroundColor Red
        $scanResults.Add([PSCustomObject]@{
            Path         = $projectPath
            Name         = Split-Path $projectPath -Leaf
            SkipUpdate   = $true
            Gaps         = [System.Collections.Generic.List[string]]::new()
            Adds         = [System.Collections.Generic.List[string]]::new()
            Warnings     = [System.Collections.Generic.List[string]]::new()
            PlanningFiles = @{ "task_plan" = @(); "progress" = @(); "findings" = @() }
            SessionMemory = @{}
            MaximRuntime  = @{ "skill-gaps-count" = 0; "handoff-status" = "error";
                               "bg-agent-count" = 0; "session-files" = @() }
            PhaseDocs     = @()
            FileCount     = 0
            InstallMode   = "UNKNOWN"
            CurrentVersion = "unknown"
            Manifest      = $null
            ManifestPath  = $null
            ClaudeProjectPath = $null
            LocalRegistryPath = $null
        })
    }
}

# ── Show gap reports and prompt per-project ───────────────────────────────────
$updateResults = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($scan in $scanResults) {
    Show-ProjectReport -ScanResult $scan

    if ($scan.SkipUpdate) {
        Write-Host "  Scan failed — skipping this project." -ForegroundColor Red
        $updateResults.Add([PSCustomObject]@{
            ProjectName = $scan.Name
            OldVersion  = "error"
            NewVersion  = $TARGET_VERSION
            FilesAdded  = 0
            Updated     = $false
            Errors      = [System.Collections.Generic.List[string]]@("Scan failed")
        })
        continue
    }

    if ($SkipConfirmation -or $WhatIfPreference) {
        $choice = if ($WhatIfPreference) { "y" } else { "y" }
    } else {
        Write-Host ""
        $choice = (Read-Host "Proceed? (y)es / (n)o / (s)kip").Trim().ToLower()
    }

    if ($choice -eq "s" -or $choice -eq "n" -or $choice -eq "no") {
        Write-Host "  Skipped: $($scan.Name)" -ForegroundColor DarkGray
        $updateResults.Add([PSCustomObject]@{
            ProjectName = $scan.Name
            OldVersion  = $scan.CurrentVersion
            NewVersion  = $TARGET_VERSION
            FilesAdded  = 0
            Updated     = $false
            Errors      = [System.Collections.Generic.List[string]]::new()
        })
        continue
    }

    # Apply update
    try {
        $result = Invoke-ProjectUpdate -ScanResult $scan
        $updateResults.Add($result)

        if ($result.Updated) {
            Write-Host "  OK  $($scan.Name) updated to $TARGET_VERSION ($($result.FilesAdded) files added)" -ForegroundColor Green
        } else {
            Write-Host "  OK  $($scan.Name) — already up to date, no changes needed" -ForegroundColor DarkGreen
        }

        foreach ($err in $result.Errors) {
            Write-Host "  ERROR  $err" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ERROR: Update failed for $($scan.Name): $_" -ForegroundColor Red
        $updateResults.Add([PSCustomObject]@{
            ProjectName = $scan.Name
            OldVersion  = $scan.CurrentVersion
            NewVersion  = $TARGET_VERSION
            FilesAdded  = 0
            Updated     = $false
            Errors      = [System.Collections.Generic.List[string]]@("Update failed: $_")
        })
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 6 — SUMMARY TABLE
# ─────────────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Maxim Update Summary" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

# Column widths
$colName    = 24
$colOld     = 9
$colNew     = 9
$colFiles   = 13
$colStatus  = 10

$header = "  {0,-$colName}  {1,-$colOld}  {2,-$colNew}  {3,-$colFiles}  {4,-$colStatus}" -f `
    "Project", "Old", "New", "Files Added", "Status"
Write-Host $header -ForegroundColor White

$divider = "  " + ("-" * $colName) + "  " + ("-" * $colOld) + "  " + ("-" * $colNew) + `
           "  " + ("-" * $colFiles) + "  " + ("-" * $colStatus)
Write-Host $divider -ForegroundColor DarkGray

foreach ($r in $updateResults) {
    $statusLabel = if ($r.Errors -and $r.Errors.Count -gt 0) {
        "ERROR"
    } elseif ($r.Updated) {
        "Updated"
    } else {
        "Skipped"
    }

    $statusColor = switch ($statusLabel) {
        "Updated" { "Green" }
        "ERROR"   { "Red" }
        default   { "DarkGray" }
    }

    $nameTrunc = if ($r.ProjectName.Length -gt $colName) {
        $r.ProjectName.Substring(0, $colName - 2) + ".."
    } else {
        $r.ProjectName
    }

    $row = "  {0,-$colName}  {1,-$colOld}  {2,-$colNew}  {3,-$colFiles}  " -f `
        $nameTrunc, $r.OldVersion, $r.NewVersion, $r.FilesAdded
    Write-Host -NoNewline $row -ForegroundColor White
    Write-Host $statusLabel -ForegroundColor $statusColor
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$updatedCount = @($updateResults | Where-Object { $_.Updated }).Count
$errorCount   = @($updateResults | Where-Object { $_.Errors -and $_.Errors.Count -gt 0 }).Count

if ($updatedCount -gt 0) {
    Write-Host "  Next step: open each updated project in Claude Code and run /mxm-status" -ForegroundColor White
}
if ($errorCount -gt 0) {
    Write-Host "  WARNING: $errorCount project(s) had errors — review output above." -ForegroundColor Yellow
}
if ($WhatIfPreference) {
    Write-Host "  DRY RUN complete — no files were written. Remove -WhatIf to apply changes." -ForegroundColor Yellow
}
Write-Host ""
