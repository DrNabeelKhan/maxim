# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# install-global.ps1 — Maxim Global Install
# Version: 1.1.0  |  Maxim v1.0.0
#
# Creates symlinks from %USERPROFILE%\.claude\ → your local maxim clone.
# Direct symlinks — no Program Files detour. One hop. git pull updates everything.
#
# Usage:
#   cd E:\Projects\Maxim\maxim
#   .\bootstrap\install-global.ps1
#   .\bootstrap\install-global.ps1 -Force       # overwrite existing links
#   .\bootstrap\install-global.ps1 -Uninstall   # remove global links
#
# ─── What gets symlinked to %USERPROFILE%\.claude\ ───────────────────────────
#   CLAUDE.md    → $Maxim\CLAUDE.md              (loads every Claude Code session)
#   agents\      → $Maxim\agents\                (87 Maxim agents across 7 offices)
#   skills\      → $Maxim\.claude\skills\        (23 skill domains)
#   commands\    → $Maxim\.claude\commands\      (31 /mxm-* slash commands)
#
# NOTE: All 4 sources live at the repo root — no git subtree add required.
#       Works immediately after: git clone https://github.com/DrNabeelKhan/maxim.git
#
# ─── What stays per-project (created by link-local-project.ps1) ──────────────
#   config\project-manifest.json             ← unique per project
#   CLAUDE.project.md                        ← unique per project
#   .claude.local\settings.local.json        ← unique per project (Read() path)
#   .mxm-skills\                            ← runtime state, unique per project
#   .claude-sessions-memory\                 ← session persistence, unique per project
#   docs\architecture\                       ← PRD, FRD, SRD, secrets (gitignored)
#   docs\business\                           ← investor narrative, financial models
#   prototypes\                              ← v0 demos, POCs
#
# ─── Update Maxim globally ─────────────────────────────────────────────────────
#   cd E:\Projects\Maxim\maxim && git pull
#   All symlinked projects reflect changes instantly. Zero re-copy required.
# ─────────────────────────────────────────────────────────────────────────────

param(
  [Parameter(Mandatory=$false)]
  [switch]$Force = $false,

  [Parameter(Mandatory=$false)]
  [switch]$Uninstall = $false
)

# ── Resolve Maxim repo root (script lives in bootstrap\) ──────────────────────
$Maxim = Split-Path $MyInvocation.MyCommand.Path -Parent |
        Split-Path -Parent

$GLOBAL_CLAUDE = "$env:USERPROFILE\.claude"

# ── Admin check ───────────────────────────────────────────────────────────────
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::
            GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
  Write-Host ""
  Write-Host "❌  Must run as Administrator to create symlinks." -ForegroundColor Red
  Write-Host "    Right-click PowerShell → Run as Administrator, then retry." -ForegroundColor Yellow
  Write-Host ""
  exit 1
}

# ── Uninstall mode ────────────────────────────────────────────────────────────
if ($Uninstall) {
  Write-Host ""
  Write-Host "Removing Maxim global symlinks from $GLOBAL_CLAUDE ..." -ForegroundColor Yellow
  @("CLAUDE.md", "agents", "skills", "commands") | ForEach-Object {
    $p = "$GLOBAL_CLAUDE\$_"
    if (Test-Path $p) {
      Remove-Item $p -Recurse -Force
      Write-Host "  Removed: $_" -ForegroundColor DarkGray
    } else {
      Write-Host "  Not found (skipped): $_" -ForegroundColor DarkGray
    }
  }
  Write-Host ""
  Write-Host "✅  Maxim global install removed." -ForegroundColor Green
  Write-Host "    Per-project files (CLAUDE.project.md, project-manifest.json) are untouched." -ForegroundColor DarkGray
  Write-Host ""
  exit 0
}

# ── Header ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Maxim Global Install  ·  v1.0.0         ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Maxim source  : $Maxim" -ForegroundColor White
Write-Host "  Global target: $GLOBAL_CLAUDE" -ForegroundColor White
Write-Host ""

# ── Pre-flight: verify repo root sources exist ────────────────────────────────
Write-Host "Pre-flight checks..." -ForegroundColor White
$preflight = $true
@(
  @{ P = "$Maxim\CLAUDE.md";           L = "CLAUDE.md" },
  @{ P = "$Maxim\agents";              L = "agents\ (repo root)" },
  @{ P = "$Maxim\.claude\skills";      L = ".claude\skills\ (repo root)" },
  @{ P = "$Maxim\.claude\commands";    L = ".claude\commands\ (repo root)" }
) | ForEach-Object {
  if (Test-Path $_.P) {
    Write-Host "  ✅ Found : $($_.L)" -ForegroundColor DarkGray
  } else {
    Write-Host "  ❌ MISSING source: $($_.L)" -ForegroundColor Red
    Write-Host "     Expected at  : $($_.P)" -ForegroundColor DarkGray
    $preflight = $false
  }
}
if (-not $preflight) {
  Write-Host ""
  Write-Host "❌  Pre-flight failed. Is this run from the maxim repo root?" -ForegroundColor Red
  Write-Host "    cd E:\Projects\Maxim\maxim" -ForegroundColor Cyan
  Write-Host "    .\bootstrap\install-global.ps1" -ForegroundColor Cyan
  Write-Host ""
  exit 1
}
Write-Host ""

# ── Create %USERPROFILE%\.claude if needed ────────────────────────────────────
if (-not (Test-Path $GLOBAL_CLAUDE)) {
  New-Item -ItemType Directory -Force $GLOBAL_CLAUDE | Out-Null
  Write-Host "  📁 Created $GLOBAL_CLAUDE" -ForegroundColor DarkGray
}

# ── Helper: create symlink or junction safely ─────────────────────────────────
function New-GlobalSymlink {
  param(
    [string]$Name,
    [string]$Target,
    [string]$Label
  )
  $link = "$GLOBAL_CLAUDE\$Name"

  if (-not (Test-Path $Target)) {
    Write-Host "  ⚠️  Source missing — skipping : $Label" -ForegroundColor Yellow
    Write-Host "      Expected at: $Target" -ForegroundColor DarkGray
    return
  }

  if (Test-Path $link) {
    if ($Force) {
      Remove-Item $link -Recurse -Force
    } else {
      Write-Host "  ✅ Already linked : $Label" -ForegroundColor Green
      return
    }
  }

  $type = if (Test-Path $Target -PathType Container) { "Junction" } else { "SymbolicLink" }
  New-Item -ItemType $type -Path $link -Target $Target | Out-Null
  Write-Host "  🔗 Linked         : $Label" -ForegroundColor Cyan
  Write-Host "                      → $Target" -ForegroundColor DarkGray
}

# ── Create symlinks ───────────────────────────────────────────────────────────
Write-Host "[ 1/4 ] Linking Maxim dispatch rules..." -ForegroundColor White
New-GlobalSymlink "CLAUDE.md"  "$Maxim\CLAUDE.md"               "CLAUDE.md  (dispatch rules)"

Write-Host "[ 2/4 ] Linking agent catalog..." -ForegroundColor White
New-GlobalSymlink "agents"     "$Maxim\agents"                  "agents\    (87 Maxim agents)"

Write-Host "[ 3/4 ] Linking skill domains..." -ForegroundColor White
New-GlobalSymlink "skills"     "$Maxim\.claude\skills"          "skills\    (23 skill domains)"

Write-Host "[ 4/4 ] Linking slash commands..." -ForegroundColor White
New-GlobalSymlink "commands"   "$Maxim\.claude\commands"        "commands\  (all /mxm-* commands)"

# ── Validate ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Validation" -ForegroundColor White
Write-Host "──────────" -ForegroundColor White

$allPass = $true
@(
  @{ N = "CLAUDE.md"; L = "Maxim dispatch rules" },
  @{ N = "agents";    L = "Agent catalog (87 agents)" },
  @{ N = "skills";    L = "Skill domains (23 domains)" },
  @{ N = "commands";  L = "Slash commands (31 commands)" }
) | ForEach-Object {
  $p = "$GLOBAL_CLAUDE\$($_.N)"
  if (Test-Path $p) {
    Write-Host "  ✅ $($_.L)" -ForegroundColor Green
  } else {
    Write-Host "  ❌ MISSING: $($_.L)" -ForegroundColor Red
    $allPass = $false
  }
}

# ── Summary ───────────────────────────────────────────────────────────────────
Write-Host ""
if ($allPass) {
  Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Green
  Write-Host "║  ✅  Maxim global install complete.                       ║" -ForegroundColor Green
  Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Green
  Write-Host ""
  Write-Host "  Every Claude Code session now loads Maxim automatically." -ForegroundColor White
  Write-Host "  No per-project CLAUDE.md or .claude\ copies needed." -ForegroundColor DarkGray
  Write-Host ""
  Write-Host "  To update Maxim for ALL projects at once:" -ForegroundColor White
  Write-Host "    cd $Maxim" -ForegroundColor Cyan
  Write-Host "    git pull" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "  Per-project bootstrap (run for each new project):" -ForegroundColor White
  Write-Host "    .\bootstrap\link-local-project.ps1 -ProjectPath `"E:\Projects\YourProject`"" -ForegroundColor Cyan
  Write-Host ""
} else {
  Write-Host "⚠️  Some links failed. Re-run as Administrator with -Force flag:" -ForegroundColor Yellow
  Write-Host "   .\bootstrap\install-global.ps1 -Force" -ForegroundColor Cyan
  Write-Host ""
  exit 1
}
