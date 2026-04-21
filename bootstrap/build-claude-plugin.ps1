# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

<#
.SYNOPSIS
    Mirrors canonical Maxim source into distributions/claude-plugin/ for Claude Code plugin packaging.

.DESCRIPTION
    Copies .claude/skills/, .claude/commands/, .claude/hooks/, agents/, mcp/ into
    distributions/claude-plugin/{skills,commands,hooks,agents,mcp}/.
    Generated output is gitignored until a release branch is cut.

    Source (canonical, always committed):
      .claude/skills/          -> distributions/claude-plugin/skills/
      .claude/commands/        -> distributions/claude-plugin/commands/
      .claude/hooks/           -> distributions/claude-plugin/hooks/scripts/
      agents/                  -> distributions/claude-plugin/agents/
      mcp/                     -> distributions/claude-plugin/mcp/

    Static plugin artifacts (committed, not mirrored):
      distributions/claude-plugin/.claude-plugin/plugin.json
      distributions/claude-plugin/settings.json
      distributions/claude-plugin/hooks/hooks.json
      distributions/claude-plugin/monitors/monitors.json
      distributions/claude-plugin/output-styles/mxm-mode.md
      distributions/claude-plugin/DISTRIBUTION.md

.PARAMETER Clean
    Remove existing mirrored directories before copying. Default: false.

.PARAMETER DryRun
    Print copy operations without executing them. Default: false.

.PARAMETER Release
    Cross-compile pack-engine for all target platforms (4 binaries: Linux amd64,
    Windows amd64, macOS arm64 Apple Silicon, macOS amd64 Intel). Default: false
    (host-platform only).

.EXAMPLE
    .\bootstrap\build-claude-plugin.ps1
    .\bootstrap\build-claude-plugin.ps1 -Clean
    .\bootstrap\build-claude-plugin.ps1 -DryRun
    .\bootstrap\build-claude-plugin.ps1 -Release
#>

[CmdletBinding()]
param(
    [switch]$Clean,
    [switch]$DryRun,
    [switch]$Release
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Paths ─────────────────────────────────────────────────────────────────────
$RepoRoot   = Split-Path $PSScriptRoot -Parent
$PluginDist = Join-Path $RepoRoot "distributions\claude-plugin"

$Mirrors = @(
    @{ Src = Join-Path $RepoRoot ".claude\skills";   Dst = Join-Path $PluginDist "skills"         }
    @{ Src = Join-Path $RepoRoot ".claude\commands"; Dst = Join-Path $PluginDist "commands"       }
    @{ Src = Join-Path $RepoRoot "agents";           Dst = Join-Path $PluginDist "agents"         }
    @{ Src = Join-Path $RepoRoot "mcp";              Dst = Join-Path $PluginDist "mcp"            }
)

# Hooks scripts only (not hooks.json — that is a static plugin artifact)
$HookScriptSrc = Join-Path $RepoRoot ".claude\hooks"
$HookScriptDst = Join-Path $PluginDist "hooks\scripts"

# ── Helpers ───────────────────────────────────────────────────────────────────
function Write-Step([string]$msg) { Write-Host "  $msg" -ForegroundColor Cyan }
function Write-Ok([string]$msg)   { Write-Host "  OK  $msg" -ForegroundColor Green }
function Write-Skip([string]$msg) { Write-Host "  --  $msg" -ForegroundColor DarkGray }

# ── Verify plugin dist root exists ────────────────────────────────────────────
if (-not (Test-Path $PluginDist)) {
    Write-Error "distributions/claude-plugin/ not found at $PluginDist. Run from repo root."
    exit 1
}

Write-Host "`nMaxim Plugin Build — mirroring canonical source to distributions/claude-plugin/" -ForegroundColor Yellow
Write-Host "Repo root : $RepoRoot"
Write-Host "Plugin dst: $PluginDist"
if ($DryRun) { Write-Host "  [DRY RUN — no files written]" -ForegroundColor Yellow }
Write-Host ""

# ── Optional clean ────────────────────────────────────────────────────────────
if ($Clean) {
    foreach ($m in $Mirrors) {
        if (Test-Path $m.Dst) {
            Write-Step "Removing $($m.Dst)"
            if (-not $DryRun) { Remove-Item $m.Dst -Recurse -Force }
        }
    }
    if (Test-Path $HookScriptDst) {
        Write-Step "Removing $HookScriptDst"
        if (-not $DryRun) { Remove-Item $HookScriptDst -Recurse -Force }
    }
    Write-Host ""
}

# ── Mirror directories ─────────────────────────────────────────────────────────
$Copied = 0
$Skipped = 0

foreach ($m in $Mirrors) {
    if (-not (Test-Path $m.Src)) {
        Write-Skip "Source not found, skipping: $($m.Src)"
        $Skipped++
        continue
    }

    Write-Step "$($m.Src) -> $($m.Dst)"

    if (-not $DryRun) {
        if (-not (Test-Path $m.Dst)) { New-Item -ItemType Directory -Path $m.Dst -Force | Out-Null }
        # robocopy: /MIR = mirror, /NJH /NJS /NP = quiet headers, /XD = exclude dirs
        $rc = robocopy $m.Src $m.Dst /MIR /NJH /NJS /NP `
            /XD "__pycache__" ".git" "node_modules" `
            /XF "*.pyc" "*.pyo" ".DS_Store" "Thumbs.db"
        # robocopy exit codes 0-7 = success or informational
        if ($rc -gt 7) { Write-Error "robocopy failed with exit code $rc for $($m.Src)"; exit 1 }
    }

    Write-Ok (Split-Path $m.Dst -Leaf)
    $Copied++
}

# ── Mirror hook scripts (exclude hooks.json — that is static) ─────────────────
if (Test-Path $HookScriptSrc) {
    Write-Step ".claude/hooks/ scripts -> hooks/scripts/"
    if (-not $DryRun) {
        if (-not (Test-Path $HookScriptDst)) { New-Item -ItemType Directory -Path $HookScriptDst -Force | Out-Null }
        $rc = robocopy $HookScriptSrc $HookScriptDst /MIR /NJH /NJS /NP `
            /XF "hooks.json" "*.pyc" ".DS_Store"
        if ($rc -gt 7) { Write-Error "robocopy failed for hooks scripts"; exit 1 }
    }
    Write-Ok "hooks/scripts"
    $Copied++
} else {
    Write-Skip ".claude/hooks/ not found"
    $Skipped++
}

# ── Build and copy pack-engine binary ─────────────────────────────────────────
$PackEngineSrc = Join-Path $RepoRoot "pack-engine"
$PackEngineBin = Join-Path $PluginDist "bin"

if (Test-Path $PackEngineSrc) {
    if (-not (Test-Path $PackEngineBin)) {
        if (-not $DryRun) { New-Item -ItemType Directory -Path $PackEngineBin -Force | Out-Null }
    }

    # Target matrix: on -Release produce 4 binaries; otherwise host-only.
    if ($Release) {
        $Targets = @(
            @{ GOOS = "linux";   GOARCH = "amd64"; Name = "mxm-pack-engine"              }
            @{ GOOS = "windows"; GOARCH = "amd64"; Name = "mxm-pack-engine.exe"          }
            @{ GOOS = "darwin";  GOARCH = "arm64"; Name = "mxm-pack-engine-darwin"       }
            @{ GOOS = "darwin";  GOARCH = "amd64"; Name = "mxm-pack-engine-darwin-amd64" }
        )
    } else {
        # PS 5.x on Windows does not define $IsWindows; fall back to the OS env var.
        $isWin = ((Get-Variable -Name IsWindows -ValueOnly -ErrorAction SilentlyContinue) -eq $true) -or ($env:OS -eq "Windows_NT")
        $hostName = if ($isWin) { "mxm-pack-engine.exe" } else { "mxm-pack-engine" }
        $Targets = @(
            @{ GOOS = $null; GOARCH = $null; Name = $hostName }
        )
    }

    foreach ($t in $Targets) {
        $out = Join-Path $PackEngineBin $t.Name
        Write-Step "Building $($t.Name) ($(if ($t.GOOS) { "$($t.GOOS)/$($t.GOARCH)" } else { "host" }))"
        if (-not $DryRun) {
            Push-Location $PackEngineSrc
            $prevGoos = $env:GOOS; $prevGoarch = $env:GOARCH
            if ($t.GOOS)   { $env:GOOS   = $t.GOOS }
            if ($t.GOARCH) { $env:GOARCH = $t.GOARCH }
            $buildOutput = & go build -o $out . 2>&1
            $buildExit = $LASTEXITCODE
            $env:GOOS = $prevGoos; $env:GOARCH = $prevGoarch
            Pop-Location

            if ($buildExit -ne 0) {
                Write-Error "go build failed for $($t.Name) (exit $buildExit): $buildOutput"
                exit 1
            }
            if (-not (Test-Path $out)) {
                Write-Error "expected $out was not produced"
                exit 1
            }
        }
        Write-Ok "bin/$($t.Name)"
        $Copied++
    }
} else {
    Write-Skip "pack-engine/ source not found — skipping binary build"
    $Skipped++
}

# ── Generate .mcp.json with plugin-internal paths ────────────────────────────
$RepoMcp = Join-Path $RepoRoot ".mcp.json"
$PluginMcp = Join-Path $PluginDist ".mcp.json"

if (Test-Path $RepoMcp) {
    Write-Step "Generating .mcp.json with plugin-internal paths"
    if (-not $DryRun) {
        $mcp = Get-Content $RepoMcp -Raw | ConvertFrom-Json

        # Rewrite each server's args: ./mcp/<server>/server.js -> ${CLAUDE_PLUGIN_ROOT}/mcp/<server>/server.js
        foreach ($serverName in $mcp.mcpServers.PSObject.Properties.Name) {
            $server = $mcp.mcpServers.$serverName
            if ($server.args) {
                $server.args = $server.args | ForEach-Object {
                    if ($_ -match '^\./mcp/(.+)$') {
                        '${CLAUDE_PLUGIN_ROOT}/mcp/' + $Matches[1]
                    } else {
                        $_
                    }
                }
            }
            # Rewrite command if it's a relative path
            if ($server.command -and $server.command -match '^\.\/') {
                $server.command = $server.command -replace '^\.\/', '${CLAUDE_PLUGIN_ROOT}/'
            }
        }

        # Remove internal comments not valid in strict JSON consumers
        $mcp.PSObject.Properties.Remove('_comment')

        $mcp | ConvertTo-Json -Depth 10 | Set-Content $PluginMcp -Encoding UTF8
    }
    Write-Ok ".mcp.json (paths rewritten to plugin-internal)"
    $Copied++
} else {
    Write-Skip "repo-root .mcp.json not found — skipping .mcp.json generation"
    $Skipped++
}

# ── Report ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Build complete: $Copied directories mirrored, $Skipped skipped." -ForegroundColor Green
Write-Host ""
Write-Host "Static plugin artifacts (committed, not mirrored):"
@(
    "distributions/claude-plugin/.claude-plugin/plugin.json"
    "distributions/claude-plugin/settings.json"
    "distributions/claude-plugin/hooks/hooks.json"
    "distributions/claude-plugin/monitors/monitors.json"
    "distributions/claude-plugin/output-styles/mxm-mode.md"
    "distributions/claude-plugin/scripts/mxm-license-check.sh"
    "distributions/claude-plugin/bin/README.md"
    "distributions/claude-plugin/statusline/"
    "distributions/claude-plugin/DISTRIBUTION.md"
) | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
Write-Host ""
Write-Host "Next: verify plugin at distributions/claude-plugin/ then cut release branch." -ForegroundColor Yellow
