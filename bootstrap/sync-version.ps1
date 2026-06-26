# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# sync-version.ps1 — Maxim Version Sync Tool
# Version: 2.0.0
#
# Reads the version from config/agent-registry.json (single source of truth)
# and propagates it to EVERY version-bearing surface via TARGETED string
# replacement (no ConvertFrom/ConvertTo-Json round-trip — that reformatted the
# whole registry in v1.x). Parity with bootstrap/sync-version.sh.
#
# Usage:
#   .\bootstrap\sync-version.ps1                      # propagate the registry version
#   .\bootstrap\sync-version.ps1 -NewVersion "X.Y.Z"  # bump the registry + propagate
#   .\bootstrap\sync-version.ps1 -WhatIf              # preview, no writes
#   .\bootstrap\sync-version.ps1 -Check               # exit 1 if any surface disagrees (CI / pre-commit)
#
# Exit: 0 = ok / in sync · 1 = drift remains (-Check) · 2 = environment/parse error
# ─────────────────────────────────────────────────────────────────────────

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$NewVersion = "",
    [switch]$Check
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Maxim = Split-Path $MyInvocation.MyCommand.Path -Parent | Split-Path -Parent
$registryPath = [IO.Path]::Combine($Maxim, "config", "agent-registry.json")
if (-not (Test-Path $registryPath)) {
    Write-Host "ERROR: config/agent-registry.json not found at: $registryPath" -ForegroundColor Red
    exit 2
}

# ── Pure string version read (FIRST "version" = top-level; no JSON round-trip) ──
$registryRaw = Get-Content $registryPath -Raw -Encoding UTF8
if ($registryRaw -match '"version"\s*:\s*"([^"]+)"') {
    $currentVersion = $Matches[1]
} else {
    Write-Host "ERROR: could not parse top-level version from agent-registry.json" -ForegroundColor Red
    exit 2
}
$targetVersion = if ([string]::IsNullOrWhiteSpace($NewVersion)) { $currentVersion } else { $NewVersion }

Write-Host ""
if ($Check) {
    Write-Host "Maxim Version Check — registry source-of-truth = v$currentVersion" -ForegroundColor Cyan
} elseif ($NewVersion) {
    Write-Host "Maxim Version Bump — v$currentVersion -> v$targetVersion" -ForegroundColor Cyan
} else {
    Write-Host "Maxim Version Sync — propagating v$targetVersion to all surfaces" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "  File                                       Status" -ForegroundColor White
Write-Host "  ─────────────────────────────────────      ──────" -ForegroundColor DarkGray

# Every version-bearing surface. {V} is substituted with the version.
# NOTE: bootstrap/new-project-setup.sh "MXM_version" is intentionally NOT here —
# it is a schema/launch-line field (canonical project-manifest keeps it 1.0.0),
# not the per-patch product version. Do not auto-bump it.
$surfaces = @(
    @{ File = "config/agent-registry.json";                    Tmpl = '"version": "{V}"';   Note = "source of truth";       Want = 1 }
    @{ File = ".claude-plugin/plugin.json";                    Tmpl = '"version": "{V}"';   Note = "plugin manifest";       Want = 1 }
    @{ File = ".claude-plugin/marketplace.json";               Tmpl = '"version": "{V}"';   Note = "marketplace outer+entry"; Want = 2 }
    @{ File = "README.md";                                     Tmpl = "version-{V}-blue";   Note = "README badge";          Want = 1 }
    @{ File = "documents/ledgers/AGENT_SKILL_INVENTORY.md";    Tmpl = "**Version:** v{V}";  Note = "inventory stamp";       Want = 1 }
    @{ File = "documents/guides/HELP.md";                      Tmpl = "Maxim v{V}";         Note = "HELP header";           Want = 1 }
    @{ File = "documents/guides/ABOUT.md";                     Tmpl = "Maxim v{V}";         Note = "ABOUT header";          Want = 1 }
    @{ File = "documents/guides/GETTING_STARTED.md";           Tmpl = "Maxim v{V}";         Note = "getting-started";       Want = 1 }
    @{ File = "documents/reference/MXM_COMMAND_MAP.md";        Tmpl = "Maxim v{V}";         Note = "command-map footer";    Want = 1 }
    @{ File = "documents/guides/ABOUT.md";                     Tmpl = "> **v{V} ·";         Note = "ABOUT tagline (line 3)"; Want = 1 }
    @{ File = "distributions/claude-plugin/DISTRIBUTION.md";   Tmpl = "**Version:** {V}";   Note = "distribution version";  Want = 1 }
    @{ File = "distributions/claude-plugin/MARKETPLACE_SUBMISSION.md"; Tmpl = "**Submission version:** {V}"; Note = "submission version"; Want = 1 }
    @{ File = "distributions/claude-plugin/MARKETPLACE_SUBMISSION.md"; Tmpl = '**Tag:** `v{V}`'; Note = "submission tag";    Want = 1 }
)

$updated = 0; $okCount = 0; $drift = 0; $missing = 0

foreach ($s in $surfaces) {
    $fp = [IO.Path]::Combine($Maxim, $s.File)
    $disp = $s.File.PadRight(42)
    if (-not (Test-Path $fp)) { Write-Host "  $disp MISSING" -ForegroundColor Yellow; $missing++; continue }

    $content = Get-Content $fp -Raw -Encoding UTF8
    $oldLit = $s.Tmpl -replace '\{V\}', $currentVersion
    $newLit = $s.Tmpl -replace '\{V\}', $targetVersion

    if ($Check) {
        $have = ([regex]::Matches($content, [regex]::Escape($newLit))).Count
        if ($have -ge $s.Want) { Write-Host "  $disp OK (v$targetVersion)" -ForegroundColor DarkGreen; $okCount++ }
        else { Write-Host "  $disp DRIFT — expected v$targetVersion ($($s.Note))" -ForegroundColor Red; $drift++ }
        continue
    }

    if (($currentVersion -ne $targetVersion) -and ($content -match [regex]::Escape($oldLit))) {
        if ($WhatIfPreference) {
            Write-Host "  $disp WOULD UPDATE -> v$targetVersion ($($s.Note))" -ForegroundColor Cyan
        } else {
            $new = $content -replace [regex]::Escape($oldLit), $newLit
            Set-Content $fp $new -Encoding UTF8 -NoNewline
            Write-Host "  $disp UPDATED -> v$targetVersion ($($s.Note))" -ForegroundColor Green
        }
        $updated++
    } elseif ($content -match [regex]::Escape($newLit)) {
        Write-Host "  $disp CURRENT (v$targetVersion)" -ForegroundColor DarkGreen; $okCount++
    } else {
        Write-Host "  $disp NOT FOUND ($($s.Note))" -ForegroundColor Yellow; $missing++
    }
}

# ── Bump registry last_updated (targeted replace — no JSON round-trip) ──
if ($NewVersion -and ($NewVersion -ne $currentVersion) -and -not $WhatIfPreference -and -not $Check) {
    $today = (Get-Date -Format "yyyy-MM-dd")
    $reg = Get-Content $registryPath -Raw -Encoding UTF8
    $reg = $reg -replace '"last_updated"\s*:\s*"[^"]*"', ('"last_updated": "' + $today + '"')
    Set-Content $registryPath $reg -Encoding UTF8 -NoNewline
    Write-Host "  $("registry last_updated".PadRight(42)) -> $today" -ForegroundColor Green
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  Version: v$targetVersion   (source of truth: config/agent-registry.json)" -ForegroundColor White
if ($Check) {
    Write-Host "  In sync: $okCount · Drift: $drift · Missing: $missing" -ForegroundColor DarkGray
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan; Write-Host ""
    if ($drift -gt 0) { Write-Host "CHECK FAILED — $drift surface(s) disagree with the registry. Run: .\bootstrap\sync-version.ps1" -ForegroundColor Red; exit 1 }
    exit 0
}
Write-Host "  Updated: $updated · Already current: $okCount · Not found: $missing" -ForegroundColor DarkGray
if ($WhatIfPreference) { Write-Host "  Mode: DRY RUN — no files changed" -ForegroundColor Yellow }
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan; Write-Host ""
exit 0
