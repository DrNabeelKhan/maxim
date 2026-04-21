# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# behavioral-moat-drift.ps1 — ADR-007 pre-commit checker (v1.0.0)
# Parity with behavioral-moat-drift.sh.

$ErrorActionPreference = 'Stop'
$errors = 0
$warnings = 0

$staged = (git diff --cached --name-only --diff-filter=ACMR 2>$null) -split "`n" |
  Where-Object { $_ -match '^\.claude/skills/.*SKILL\.md$' }
if (-not $staged) { exit 0 }

$added = (git diff --cached --name-status --diff-filter=A 2>$null) -split "`n" |
  ForEach-Object { ($_ -split "`t")[-1] }

$patterns = @(
  @{ Re = '(?m)^business_outcome:'; Label = 'frontmatter business_outcome' },
  @{ Re = '(?m)^primary_framework:'; Label = 'frontmatter primary_framework' },
  @{ Re = '(?m)^##\s+The Maxim Moat'; Label = '## The Maxim Moat' },
  @{ Re = '(?m)^##\s+Business Outcome'; Label = '## Business Outcome' },
  @{ Re = '(?m)^##\s+Primary Behavioral Framework'; Label = '## Primary Behavioral Framework' },
  @{ Re = '(?m)^##\s+Behavioral'; Label = '## Behavioral → ... Translation' },
  @{ Re = '(?m)^##\s+Anti-Patterns'; Label = '## Anti-Patterns' },
  @{ Re = '(?m)^##\s+Pack Integrations'; Label = '## Pack Integrations' }
)

foreach ($file in $staged) {
  $isNew = $added -contains $file
  Write-Host "Checking: $file ($(if ($isNew) { 'NEW' } else { 'MODIFIED' }))"
  $content = git show ":$file" 2>$null
  $missing = 0
  foreach ($p in $patterns) {
    if ($content -notmatch $p.Re) {
      Write-Host "  MISSING: $($p.Label)"
      $missing++
    }
  }
  if ($missing -gt 0) {
    if ($isNew) {
      Write-Host "  FAIL: $missing section(s) missing in NEW skill (ADR-007)."
      $errors++
    } else {
      Write-Host "  WARN: $missing missing (existing skill — warn until v6.5.0)."
      $warnings++
    }
  }
}

Write-Host ""
Write-Host "behavioral-moat-drift: errors=$errors warnings=$warnings"
if ($errors -gt 0) {
  Write-Host "Commit blocked: new skills must carry all 7 sections (ADR-007)."
  exit 1
}
exit 0
