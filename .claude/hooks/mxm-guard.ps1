# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-guard.ps1 — external-boundary-drift pre-commit checker (v1.0.0, ADR-006)
# Parity with mxm-guard.sh.

$ErrorActionPreference = 'Stop'
$violations = 0

$staged = (git diff --cached --name-only --diff-filter=ACMR 2>$null) -split "`n" | Where-Object { $_ -ne '' }
if (-not $staged) { exit 0 }

$exemptFiles = @('CHANGELOG.md', 'mcp/mxm-behavioral/server.js')
$exemptPrefixes = @('documents/releases/', 'documents/ADRs/', '.mxm-skills/archive/')

if ($staged | Where-Object { $_ -match '^external/' }) {
  Write-Host "Maxim Guard FAIL: external/ directory removed in v1.0.0 (ADR-006)."
  $violations++
}
if ($staged | Where-Object { $_ -match '^composable-skills/(superpowers|planning-with-files)/' }) {
  Write-Host "Maxim Guard FAIL: composable-skills third-party dirs removed (ADR-008)."
  $violations++
}
if ($staged | Where-Object { $_ -match '^agents/voltagent/' }) {
  Write-Host "Maxim Guard FAIL: agents/voltagent/ removed. Install via community pack."
  $violations++
}

foreach ($file in $staged) {
  if ($exemptFiles -contains $file) { continue }
  $skip = $false
  foreach ($p in $exemptPrefixes) { if ($file.StartsWith($p)) { $skip = $true; break } }
  if ($skip) { continue }
  $content = git show ":$file" 2>$null
  if ($content -match '\bexternal/') {
    Write-Host "Maxim Guard FAIL: $file contains live 'external/' path reference."
    $violations++
  }
}

if ($violations -gt 0) {
  Write-Host ""
  Write-Host "Maxim Guard: $violations violation(s) — commit blocked."
  Write-Host "Reference: documents/ADRs/ADR-006-external-content-boundary-rule.md"
  exit 1
}
exit 0
