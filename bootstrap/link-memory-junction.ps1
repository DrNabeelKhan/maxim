# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# link-memory-junction.ps1 — Maxim Memory Junction Creator
# Version: 1.0.0  |  Maxim v1.0.0
# Cross-platform: PowerShell 7+ (Windows, macOS, Linux)
#
# Creates a junction/symlink so Claude's auto-memory directory points to
# .claude-sessions-memory/ inside your project. This means:
#   - All Claude memory files live IN your project (version-controllable)
#   - Claude reads/writes them transparently via its normal memory path
#   - Works across sessions without any manual file copying
#
# Usage:
#   # For a specific project:
#   pwsh bootstrap/link-memory-junction.ps1 -ProjectPath "E:\Projects\Maxim\mxm-simplification"
#   pwsh bootstrap/link-memory-junction.ps1 -ProjectPath ~/Projects/my-app
#
#   # Bulk-convert ALL existing Claude projects:
#   pwsh bootstrap/link-memory-junction.ps1 -BulkConvert
#
# What it does:
#   1. Computes Claude's project key from the project path
#   2. Creates .claude-sessions-memory/ in your project (if absent)
#   3. Migrates any existing Claude memory files into it
#   4. Creates a junction/symlink from Claude's memory dir → your project
#
# Safe to re-run: idempotent (checks before creating)

param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = "",

    [Parameter(Mandatory = $false)]
    [switch]$BulkConvert = $false
)

# ── Helpers ──────────────────────────────────────────────────────────────────
function Write-Info    { param([string]$Msg) Write-Host "  [Maxim] $Msg" -ForegroundColor Cyan }
function Write-Success { param([string]$Msg) Write-Host "  [OK]   $Msg" -ForegroundColor Green }
function Write-Warn    { param([string]$Msg) Write-Host "  [WARN] $Msg" -ForegroundColor Yellow }
function Write-Fail    { param([string]$Msg) Write-Host "  [FAIL] $Msg" -ForegroundColor Red }

# ── Compute Claude project key from path ─────────────────────────────────────
# Claude Code uses this formula: absolute path → strip ":" → replace "\" and "/" with "-"
function Get-ClaudeProjectKey {
    param([string]$AbsolutePath)
    $key = $AbsolutePath -replace ':', '' -replace '[/\\]', '-'
    # Remove leading dash if present (from paths like /home/user → -home-user)
    $key = $key.TrimStart('-')
    return $key
}

# ── Create junction for one project ──────────────────────────────────────────
function New-MemoryJunction {
    param([string]$ProjectRoot)

    # Resolve to absolute path
    $resolved = Resolve-Path $ProjectRoot -ErrorAction SilentlyContinue
    if (-not $resolved) {
        Write-Fail "Path not found: $ProjectRoot"
        return $false
    }
    $ProjectRoot = $resolved.Path

    $projectName = Split-Path $ProjectRoot -Leaf
    Write-Host ""
    Write-Host "  Project: $projectName" -ForegroundColor White
    Write-Host "  Path:    $ProjectRoot" -ForegroundColor DarkGray

    # Compute paths
    $claudeProjectKey = Get-ClaudeProjectKey $ProjectRoot
    $claudeProjectDir = [IO.Path]::Combine($HOME, ".claude", "projects", $claudeProjectKey)
    $claudeMemoryDir  = [IO.Path]::Combine($claudeProjectDir, "memory")
    $localMemory      = [IO.Path]::Combine($ProjectRoot, ".claude-sessions-memory")

    Write-Info "Claude key: $claudeProjectKey"

    # Step 1: Create .claude-sessions-memory/ in project if absent
    if (-not (Test-Path $localMemory)) {
        New-Item -ItemType Directory -Path $localMemory -Force | Out-Null
        Write-Success "Created: .claude-sessions-memory/"
    } else {
        Write-Success "Exists:  .claude-sessions-memory/ ($(( Get-ChildItem $localMemory -File | Measure-Object).Count) files)"
    }

    # Step 2: Check if Claude's memory dir already exists
    if (Test-Path $claudeMemoryDir) {
        $item = Get-Item $claudeMemoryDir -Force

        # Already a junction/symlink pointing to the right place?
        if ($item.LinkType -and $item.Target -contains $localMemory) {
            Write-Success "Junction already correct: memory → .claude-sessions-memory/"
            return $true
        }

        # It's a junction but pointing somewhere else
        if ($item.LinkType) {
            $currentTarget = $item.Target
            Write-Warn "Junction exists but points to: $currentTarget"
            Write-Warn "Expected target: $localMemory"
            Write-Info "Removing old junction and creating correct one..."
            if ($IsWindows) { cmd /c rmdir "$claudeMemoryDir" 2>$null }
            else { Remove-Item $claudeMemoryDir -Force }
        }
        # It's a real directory with files — migrate first
        else {
            $fileCount = (Get-ChildItem $claudeMemoryDir -File | Measure-Object).Count
            if ($fileCount -gt 0) {
                Write-Info "Migrating $fileCount existing memory files..."
                Get-ChildItem $claudeMemoryDir -File | ForEach-Object {
                    $destPath = [IO.Path]::Combine($localMemory, $_.Name)
                    if (-not (Test-Path $destPath)) {
                        Move-Item $_.FullName $localMemory
                        Write-Info "  Moved: $($_.Name)"
                    } else {
                        Write-Warn "  Skipped (already exists): $($_.Name)"
                    }
                }
            }
            # Remove the now-empty directory
            if ($IsWindows) { cmd /c rmdir "$claudeMemoryDir" 2>$null }
            else { Remove-Item $claudeMemoryDir -Recurse -Force }
            Write-Success "Migrated and removed old memory directory"
        }
    }

    # Step 3: Ensure parent directory exists
    if (-not (Test-Path $claudeProjectDir)) {
        New-Item -ItemType Directory -Path $claudeProjectDir -Force | Out-Null
        Write-Info "Created Claude project dir: $claudeProjectKey"
    }

    # Step 4: Create junction (Windows) or symlink (Mac/Linux)
    try {
        if ($IsWindows) {
            # Junction works without admin on Windows
            New-Item -ItemType Junction -Path $claudeMemoryDir -Target $localMemory | Out-Null
        } else {
            # Symlink on Mac/Linux (no admin needed)
            New-Item -ItemType SymbolicLink -Path $claudeMemoryDir -Target $localMemory | Out-Null
        }
        Write-Success "Junction created:"
        Write-Host "    $claudeMemoryDir" -ForegroundColor DarkGray
        Write-Host "    → $localMemory" -ForegroundColor DarkGray
        return $true
    }
    catch {
        Write-Fail "Failed to create junction: $_"
        return $false
    }
}

# ── Banner ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Maxim Memory Junction Tool  ·  v1.0.0" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────" -ForegroundColor Cyan

# ── Mode: Bulk Convert ───────────────────────────────────────────────────────
if ($BulkConvert) {
    Write-Host "  Mode: Bulk Convert — all existing Claude projects" -ForegroundColor Yellow
    Write-Host ""

    $claudeProjects = [IO.Path]::Combine($HOME, ".claude", "projects")
    if (-not (Test-Path $claudeProjects)) {
        Write-Fail "No Claude projects directory found at: $claudeProjects"
        exit 1
    }

    $converted = 0
    $skipped = 0
    $failed = 0

    Get-ChildItem $claudeProjects -Directory | ForEach-Object {
        $key = $_.Name
        $memDir = [IO.Path]::Combine($_.FullName, "memory")

        # Reverse the key back to a probable path
        # E--Projects-Maxim-foo → E:\Projects\Maxim\foo (Windows)
        # or home-user-projects-foo → /home/user/projects/foo (Mac/Linux)
        if ($IsWindows) {
            $guessed = $key -replace '^([A-Za-z])-', '$1:\' -replace '-', '\'
        } else {
            $guessed = "/" + ($key -replace '-', '/')
        }

        if (Test-Path $guessed) {
            $result = New-MemoryJunction -ProjectRoot $guessed
            if ($result) { $converted++ } else { $failed++ }
        } else {
            Write-Warn "Path not found (skipping): $guessed"
            $skipped++
        }
    }

    Write-Host ""
    Write-Host "  Summary: $converted converted, $skipped skipped, $failed failed" -ForegroundColor White
    Write-Host ""
    exit 0
}

# ── Mode: Single Project ────────────────────────────────────────────────────
if ($ProjectPath -eq "") {
    # Interactive: ask for path
    Write-Host "  Enter the project path (or press Enter for current directory):" -ForegroundColor White
    $input = Read-Host "  Path"
    if ($input -eq "") { $ProjectPath = (Get-Location).Path }
    else { $ProjectPath = $input }
}

$result = New-MemoryJunction -ProjectRoot $ProjectPath

Write-Host ""
if ($result) {
    Write-Host "  Done. Claude will now read/write memory through the junction." -ForegroundColor Green
    Write-Host "  All memory files live in: .claude-sessions-memory/" -ForegroundColor DarkGray
} else {
    Write-Host "  Junction creation failed. Check errors above." -ForegroundColor Red
}
Write-Host ""
