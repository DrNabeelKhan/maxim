# Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# mxm-toggle-mcp.ps1 - operator opt-in/opt-out for individual Maxim MCPs (v1.3.2.3+).
#
# Windows-native PowerShell mirror of bootstrap/mxm-toggle-mcp.sh.
#
# Usage:
#   pwsh -File bootstrap/mxm-toggle-mcp.ps1 disable <mcp-name>
#   pwsh -File bootstrap/mxm-toggle-mcp.ps1 enable  <mcp-name>
#   pwsh -File bootstrap/mxm-toggle-mcp.ps1 list
#   pwsh -File bootstrap/mxm-toggle-mcp.ps1 status
#
# After disable/enable: RESTART Claude Code once.

param(
    [Parameter(Position=0)] [string] $Action = "status",
    [Parameter(Position=1)] [string] $McpName = ""
)

$ErrorActionPreference = "Stop"

# Locate install cache + marketplace cache.
$InstallParent = Join-Path $env:USERPROFILE ".claude\plugins\cache\maxim-packs\maxim"
$MarketplaceDir = Join-Path $env:USERPROFILE ".claude\plugins\marketplaces\maxim-packs"

if (-not (Test-Path $InstallParent)) {
    Write-Error "Maxim plugin install not found at $InstallParent. Run /plugin install maxim@maxim-packs first."
    exit 1
}

$Versions = @(Get-ChildItem $InstallParent -Directory -ErrorAction SilentlyContinue)
if ($Versions.Count -eq 0) {
    Write-Error "No version directory under $InstallParent. Plugin install corrupted."
    exit 1
}
$InstallDir = $Versions[0].FullName
$DisableList = Join-Path $InstallDir ".mcp-disabled"
$InstallMcp = Join-Path $InstallDir ".mcp.json"
$MarketplaceMcp = Join-Path $MarketplaceDir ".mcp.json"

function Get-KnownMcps {
    if (-not (Test-Path $MarketplaceMcp)) { return @() }
    $data = Get-Content $MarketplaceMcp -Raw | ConvertFrom-Json
    return $data.mcpServers.PSObject.Properties.Name | Sort-Object
}

function Get-DisabledMcps {
    if (Test-Path $DisableList) {
        return @(Get-Content $DisableList | Where-Object { $_ -and $_.Trim() })
    }
    return @()
}

function Get-RegisteredMcps {
    if (-not (Test-Path $InstallMcp)) { return @() }
    $data = Get-Content $InstallMcp -Raw | ConvertFrom-Json
    return $data.mcpServers.PSObject.Properties.Name | Sort-Object
}

switch ($Action) {
    "disable" {
        if (-not $McpName) {
            Write-Error "disable requires <mcp-name>. Known MCPs:"
            Get-KnownMcps | ForEach-Object { Write-Host "  $_" }
            exit 1
        }
        $known = Get-KnownMcps
        if ($known -notcontains $McpName) {
            Write-Error "'$McpName' not in marketplace .mcp.json. Known MCPs:"
            $known | ForEach-Object { Write-Host "  $_" }
            exit 1
        }
        # Add to .mcp-disabled (idempotent).
        $disabled = Get-DisabledMcps
        if ($disabled -contains $McpName) {
            Write-Host "INFO: $McpName already in disable list"
        } else {
            Add-Content -Path $DisableList -Value $McpName -Encoding utf8NoBOM
            Write-Host "OK: added $McpName to $DisableList" -ForegroundColor Green
        }
        # Remove from .mcp.json.
        $data = Get-Content $InstallMcp -Raw | ConvertFrom-Json
        if ($data.mcpServers.PSObject.Properties.Name -contains $McpName) {
            $data.mcpServers.PSObject.Properties.Remove($McpName)
            ($data | ConvertTo-Json -Depth 20) | Set-Content -Path $InstallMcp -Encoding utf8NoBOM
            Write-Host "OK: removed $McpName from .mcp.json" -ForegroundColor Green
        } else {
            Write-Host "INFO: $McpName not currently in .mcp.json"
        }
        Write-Host ""
        Write-Host "RESTART Claude Code to apply (disabled MCP will not auto-spawn)." -ForegroundColor Cyan
        Write-Host "To engage $McpName on demand, run its upstream CLI directly."
    }
    "enable" {
        if (-not $McpName) {
            Write-Error "enable requires <mcp-name>"
            exit 1
        }
        # Remove from .mcp-disabled.
        if (Test-Path $DisableList) {
            $remaining = Get-DisabledMcps | Where-Object { $_ -ne $McpName }
            if ($remaining) {
                Set-Content -Path $DisableList -Value $remaining -Encoding utf8NoBOM
            } else {
                Remove-Item $DisableList -Force -ErrorAction SilentlyContinue
            }
            Write-Host "OK: removed $McpName from $DisableList" -ForegroundColor Green
        }
        # Restore in .mcp.json from marketplace template.
        $installData = Get-Content $InstallMcp -Raw | ConvertFrom-Json
        $marketplaceData = Get-Content $MarketplaceMcp -Raw | ConvertFrom-Json
        if ($marketplaceData.mcpServers.PSObject.Properties.Name -notcontains $McpName) {
            Write-Error "$McpName not in marketplace .mcp.json template"
            exit 1
        }
        $block = $marketplaceData.mcpServers.$McpName
        if ($installData.mcpServers.PSObject.Properties.Name -contains $McpName) {
            $installData.mcpServers.PSObject.Properties.Remove($McpName)
        }
        $installData.mcpServers | Add-Member -MemberType NoteProperty -Name $McpName -Value $block
        ($installData | ConvertTo-Json -Depth 20) | Set-Content -Path $InstallMcp -Encoding utf8NoBOM
        Write-Host "OK: restored $McpName in .mcp.json from marketplace template" -ForegroundColor Green
        Write-Host ""
        Write-Host "RESTART Claude Code to apply (MCP will spawn on next startup)." -ForegroundColor Cyan
    }
    default {
        Write-Host "=== Maxim MCP toggle status ===" -ForegroundColor White
        Write-Host "Install dir:   $InstallDir"
        Write-Host "Disable list:  $DisableList"
        Write-Host "Install .mcp:  $InstallMcp"
        Write-Host ""
        Write-Host "=== Disabled MCPs (in .mcp-disabled) ===" -ForegroundColor Yellow
        $disabled = Get-DisabledMcps
        if ($disabled.Count -eq 0) { Write-Host "(none)" } else { $disabled | ForEach-Object { Write-Host "  $_" } }
        Write-Host ""
        Write-Host "=== Currently registered in .mcp.json (will auto-spawn) ===" -ForegroundColor Green
        Get-RegisteredMcps | ForEach-Object { Write-Host "  $_" }
        Write-Host ""
        Write-Host "=== Known MCPs in marketplace template ===" -ForegroundColor Cyan
        Get-KnownMcps | ForEach-Object { Write-Host "  $_" }
    }
}
