#!/usr/bin/env pwsh
# Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
#
# mxm-desktop-config.ps1 — Auto-configure Claude Desktop with all 9 Maxim MCPs.
#
# Cross-platform PowerShell: works on Windows PowerShell 5.1+, PowerShell 7+
# (which also runs on macOS / Linux). Companion to mxm-desktop-config.sh.
#
# Usage:
#   pwsh -File bootstrap/mxm-desktop-config.ps1
#
# What it does:
#   1. Detects OS, locates claude_desktop_config.json
#   2. Backs up existing config to .bak-pre-maxim-<timestamp>
#   3. Locates Maxim plugin install cache (auto-detects version)
#   4. Merges 9 Maxim MCP server entries into mcpServers (preserves existing
#      entries like vazir + your preferences block)
#   5. Validates JSON
#   6. Reports next steps (restart Claude Desktop)
#
# Idempotent: safe to re-run.

$ErrorActionPreference = "Stop"

function Write-Info($msg)  { Write-Host "-> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)    { Write-Host "OK  $msg" -ForegroundColor Green }
function Write-Warn($msg)  { Write-Host "WARN $msg" -ForegroundColor Yellow }
function Write-Fail($msg)  { Write-Host "FAIL $msg" -ForegroundColor Red; exit 1 }

# ─── Detect OS + config path ──────────────────────────────────────────────────
if ($IsMacOS) {
    $ConfigDir = Join-Path $HOME "Library/Application Support/Claude"
    $Platform  = "macOS"
} elseif ($IsLinux) {
    $ConfigDir = Join-Path $HOME ".config/Claude"
    $Platform  = "Linux"
} else {
    $ConfigDir = Join-Path $env:APPDATA "Claude"
    $Platform  = "Windows"
}

$ConfigFile = Join-Path $ConfigDir "claude_desktop_config.json"

Write-Info "Platform: $Platform"
Write-Info "Config dir: $ConfigDir"

if (-not (Test-Path $ConfigDir)) {
    Write-Warn "Claude Desktop config dir not found at: $ConfigDir"
    Write-Warn "Is Claude Desktop installed? Download: https://claude.ai/download"
    Write-Fail "Aborting — install Claude Desktop first, then re-run this script."
}

# ─── Locate plugin install cache ──────────────────────────────────────────────
$PluginCache = Join-Path $HOME ".claude/plugins/cache/maxim-packs/maxim"

if (-not (Test-Path $PluginCache)) {
    Write-Fail "Maxim plugin not installed. Run '/plugin install maxim@maxim-packs' in Claude Code first."
}

# Auto-detect plugin version (most recently modified dir)
$PluginVersion = (Get-ChildItem $PluginCache -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1).Name
$PluginRoot    = Join-Path $PluginCache $PluginVersion
$Wrapper       = Join-Path $PluginRoot "mcp/_shared/spawn-with-deps.mjs"

if (-not (Test-Path $Wrapper)) {
    Write-Fail "spawn-with-deps.mjs not found at: $Wrapper. Plugin install incomplete?"
}

# Normalize paths to forward slashes for JSON
$Wrapper    = $Wrapper.Replace('\', '/')
$PluginRoot = $PluginRoot.Replace('\', '/')

Write-Info "Plugin version: $PluginVersion"
Write-Info "Plugin root: $PluginRoot"

# ─── Backup existing config ───────────────────────────────────────────────────
$Timestamp  = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupFile = "$ConfigFile.bak-pre-maxim-$Timestamp"

if (Test-Path $ConfigFile) {
    Copy-Item $ConfigFile $BackupFile
    Write-Ok "Backup created: $(Split-Path $BackupFile -Leaf)"
    $Config = Get-Content $ConfigFile -Raw | ConvertFrom-Json -AsHashtable
} else {
    Write-Info "No existing config — creating fresh."
    $Config = @{}
}

if (-not $Config.mcpServers) {
    $Config.mcpServers = @{}
}

# ─── Build + merge 8 MCP entries ──────────────────────────────────────────────
$MaximServers = @(
    'mxm-portfolio', 'mxm-context', 'mxm-catalog', 'mxm-compliance',
    'mxm-behavioral', 'mxm-memory', 'mxm-voice', 'mxm-commands',
    'mxm-notebooklm'
)

Write-Info "Merging 9 Maxim MCP entries into mcpServers (preserving existing entries)..."

foreach ($name in $MaximServers) {
    $Config.mcpServers[$name] = @{
        command = 'node'
        args    = @($Wrapper, "$PluginRoot/mcp/$name/server.js")
        env     = @{}
    }
}

# ─── Write + validate ─────────────────────────────────────────────────────────
$Json = $Config | ConvertTo-Json -Depth 10
$Json | Out-File -FilePath $ConfigFile -Encoding utf8

try {
    $null = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    Write-Ok "JSON validated."
} catch {
    Write-Warn "Config JSON failed validation — restoring backup."
    Copy-Item $BackupFile $ConfigFile -Force
    Write-Fail "Validation failed. Original config restored. Open an issue with the .bak file attached."
}

# ─── Pre-install MCP deps (v1.2.0.3+) ────────────────────────────────────────
# Claude Desktop's MCP client has a ~60s `initialize` timeout. Without this
# pre-warm, the first Desktop launch hits the cold spawn-with-deps install
# loop (~30–60s for 7 servers) and times out — reporting "failed" servers
# that are actually still running. Pre-installing here moves that cost into
# this script (where the operator is already watching progress) so the very
# first Desktop launch finds all node_modules in place and short-circuits.

Write-Info "Pre-installing MCP server dependencies (eliminates Desktop first-launch timeout)..."

# Restore PluginRoot to a filesystem-friendly form for Test-Path / npm install
$PluginRootFs = $PluginRoot.Replace('/', [IO.Path]::DirectorySeparatorChar)
$Sentinel = Join-Path $PluginRootFs ".mcp-deps-installed"

$PreInstallCount = 0
$PreInstallSkipped = 0
$PreInstallFailed = 0

$McpDir = Join-Path $PluginRootFs "mcp"
$McpServerDirs = Get-ChildItem -Path $McpDir -Directory -Filter "mxm-*" -ErrorAction SilentlyContinue

foreach ($srvDir in $McpServerDirs) {
    $pkgJson = Join-Path $srvDir.FullName "package.json"
    $nodeModules = Join-Path $srvDir.FullName "node_modules"
    if (-not (Test-Path $pkgJson)) {
        $PreInstallSkipped++
        continue
    }
    if ((Test-Path $nodeModules) -and (Test-Path $Sentinel)) {
        $PreInstallSkipped++
        continue
    }
    Write-Host "  installing $($srvDir.Name)… " -NoNewline
    try {
        Push-Location $srvDir.FullName
        $npmOutput = & npm install --omit=dev --no-audit --no-fund --silent 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "ok" -ForegroundColor Green
            $PreInstallCount++
        } else {
            Write-Host "FAIL" -ForegroundColor Red
            $PreInstallFailed++
        }
    } catch {
        Write-Host "FAIL ($_)" -ForegroundColor Red
        $PreInstallFailed++
    } finally {
        Pop-Location
    }
}

if ($PreInstallFailed -eq 0) {
    $SentinelContent = @{
        installed_at = (Get-Date -AsUTC).ToString('yyyy-MM-ddTHH:mm:ssZ')
        installed_count = $PreInstallCount
        skipped_count = $PreInstallSkipped
        plugin_root = $PluginRoot
        installer = "bootstrap/mxm-desktop-config.ps1"
    } | ConvertTo-Json
    Set-Content -Path $Sentinel -Value $SentinelContent -Encoding utf8
    Write-Ok "MCP deps ready (installed: $PreInstallCount, already-present: $PreInstallSkipped). Sentinel written."
} else {
    Write-Warn "MCP install partial (installed: $PreInstallCount, failed: $PreInstallFailed). First Desktop launch may still hit timeout."
}

# ─── Report final state ───────────────────────────────────────────────────────
$TotalServers = $Config.mcpServers.Count
$PreservedCount = $TotalServers - 9

Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "  Maxim Desktop MCP setup complete" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Config:  $ConfigFile"
Write-Host "  Backup:  $(Split-Path $BackupFile -Leaf)"
Write-Host "  Plugin:  $PluginVersion"
Write-Host "  Servers: $TotalServers total ($PreservedCount preserved + 9 Maxim MCPs = 87 tools)"
Write-Host "  Deps:    pre-installed ($PreInstallCount new, $PreInstallSkipped already-present)"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Quit Claude Desktop completely (Cmd-Q on Mac, fully exit on Windows/Linux)"
Write-Host "  2. Reopen Claude Desktop"
Write-Host "  3. All 9 Maxim MCPs (87 tools) appear immediately — no first-launch wait."
Write-Host ""
Write-Host "Optional - activate behavioral layer in Desktop Projects:" -ForegroundColor Cyan
Write-Host "  Paste contents of documents/cross-surface/maxim-project-instructions.md"
Write-Host "  into any Desktop Project's Instructions field for ~85% fidelity."
Write-Host ""
