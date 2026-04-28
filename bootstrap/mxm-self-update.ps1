# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# mxm-self-update.ps1 — fast in-place plugin update (v1.1.1+, Windows parity).
#
# See bootstrap/mxm-self-update.sh for full description.
#
# Usage:
#   pwsh -File ~/.claude/plugins/cache/maxim-packs/maxim/<version>/bootstrap/mxm-self-update.ps1
#   OR via slash command: /mxm-self-update

$ErrorActionPreference = 'Stop'

$PluginName = 'maxim'
$MarketplaceName = 'maxim-packs'
$HomeClaude = Join-Path $env:USERPROFILE '.claude'
$MarketplaceDir = Join-Path $HomeClaude "plugins\marketplaces\$MarketplaceName"
$InstalledRegistry = Join-Path $HomeClaude 'plugins\installed_plugins.json'
$InstallCacheParent = Join-Path $HomeClaude "plugins\cache\$MarketplaceName\$PluginName"

function Write-LogMsg($msg) { [Console]::Error.WriteLine("-> $msg") }
function Write-Err($msg) { [Console]::Error.WriteLine("ERROR: $msg"); exit 1 }

# --- Step 1: Locate install cache dir ---
if (-not (Test-Path $InstallCacheParent)) {
    Write-Err "$PluginName plugin not installed. Run '/plugin install $PluginName@$MarketplaceName' first."
}

$InstallDirInfo = Get-ChildItem -Directory -Path $InstallCacheParent | Select-Object -First 1
if (-not $InstallDirInfo) {
    Write-Err "No version dir under $InstallCacheParent\. Plugin install corrupted - full reinstall recommended."
}
$InstallDir = $InstallDirInfo.FullName
$InstallVersion = $InstallDirInfo.Name
Write-LogMsg "Install cache: $InstallDir (version $InstallVersion)"

# --- Step 2: Pull marketplace cache ---
if (-not (Test-Path (Join-Path $MarketplaceDir '.git'))) {
    Write-Err "Marketplace cache at $MarketplaceDir is not a git repo. Recreate via: /plugin marketplace remove $MarketplaceName && /plugin marketplace add DrNabeelKhan/maxim"
}

Push-Location $MarketplaceDir
try {
    $OldSha = (& git rev-parse HEAD 2>$null).Trim()
    if ($LASTEXITCODE -ne 0) { Write-Err "git rev-parse failed in $MarketplaceDir" }

    Write-LogMsg "Pulling latest marketplace state from origin/main..."
    $pullOutput = & git pull --ff-only origin main 2>&1
    if ($LASTEXITCODE -ne 0) {
        $pullOutput | ForEach-Object { [Console]::Error.WriteLine($_) }
        Write-Err "git pull failed. Check network connectivity + repo state."
    }

    $NewSha = (& git rev-parse HEAD 2>$null).Trim()
} finally {
    Pop-Location
}

if ($OldSha -eq $NewSha) {
    Write-LogMsg "Already at latest commit ($NewSha). No update needed."
    exit 0
}

Write-LogMsg "Marketplace updated: $($OldSha.Substring(0,8)) -> $($NewSha.Substring(0,8))"

# --- Step 3: Sync marketplace -> install cache ---
# Excludes preserve operator state: .git, node_modules, .mcp-deps-installed, .mcp-install-lock
Write-LogMsg "Syncing marketplace content -> install cache (preserving node_modules + sentinels)..."

# Use robocopy with /XD (exclude dir) and /XF (exclude file)
$robocopyArgs = @(
    $MarketplaceDir,
    $InstallDir,
    '/MIR',                              # Mirror — sync all files, delete extras
    '/XD', '.git', 'node_modules',       # Exclude these dirs at any depth
    '/XF', '.mcp-deps-installed', '.mcp-install-lock',
    '/NFL', '/NDL', '/NJH', '/NJS',      # Quiet output
    '/NP'                                # No progress
)
& robocopy @robocopyArgs | Out-Null
# robocopy exit codes: 0-7 are success (1 = files copied; 0 = no changes)
if ($LASTEXITCODE -ge 8) {
    Write-Err "robocopy sync failed (exit $LASTEXITCODE)"
}

# --- Step 4: Update installed_plugins.json registry ---
Write-LogMsg "Updating installed_plugins.json registry..."
$key = "$PluginName@$MarketplaceName"
try {
    $data = Get-Content $InstalledRegistry -Raw | ConvertFrom-Json
    if ($data.plugins.$key) {
        $iso = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
        foreach ($entry in $data.plugins.$key) {
            $entry.gitCommitSha = $NewSha
            $entry.lastUpdated = $iso
        }
        $data | ConvertTo-Json -Depth 20 | Set-Content $InstalledRegistry -Encoding UTF8
        Write-LogMsg "  registry SHA -> $($NewSha.Substring(0,8))"
    } else {
        [Console]::Error.WriteLine("  WARN: $key not in registry; registry NOT updated")
    }
} catch {
    [Console]::Error.WriteLine("  WARN: registry update failed: $_")
}

# --- Done ---
[Console]::Error.WriteLine('')
[Console]::Error.WriteLine('============================================================')
[Console]::Error.WriteLine("OK Maxim plugin synced to commit $($NewSha.Substring(0,8))")
[Console]::Error.WriteLine('   RESTART Claude Code to load the new content.')
[Console]::Error.WriteLine('   node_modules preserved - no MCP re-install needed.')
[Console]::Error.WriteLine('============================================================')

exit 0
