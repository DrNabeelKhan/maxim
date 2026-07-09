# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
# =============================================================================
# Maxim - UserPromptSubmit Hook: Default-On Intent Router (ADR-021) - PowerShell
# =============================================================================
# Windows-native mirror of user-prompt-router.sh. Classifies prompt intent
# (deterministic keyword match vs config/routing-table.json) and, ONLY on a
# confident match, injects a routing directive (office + skills + frameworks)
# with a visible routing-token-cost banner. No match -> silent passthrough.
# Opt out: routing-table.json "enabled": false  OR  <project>/.mxm-skills/router-off.
# Exit 0 always (never block).
# =============================================================================
$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }
try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

$prompt = "$($data.prompt)".Trim()
if (-not $prompt) { exit 0 }
$plow = $prompt.ToLower()

$root = if ($env:CLAUDE_PLUGIN_ROOT) { $env:CLAUDE_PLUGIN_ROOT } else { (Resolve-Path "$PSScriptRoot\..\..").Path }
$tablePath = Join-Path $root 'config\routing-table.json'
if (-not (Test-Path $tablePath)) { exit 0 }
try { $table = Get-Content $tablePath -Raw | ConvertFrom-Json } catch { exit 0 }
if ($table.enabled -eq $false) { exit 0 }

$cwd = if ($data.cwd) { "$($data.cwd)" } else { '.' }
if (Test-Path (Join-Path $cwd '.mxm-skills\router-off')) { exit 0 }

$minhits = if ($table.min_keyword_hits) { [int]$table.min_keyword_hits } else { 1 }
$weak = @{}; foreach ($w in $table.weak_keywords) { $weak["$w".ToLower()] = $true }
# Instruction zone: the operator's directive usually LEADS; pasted/quoted content
# trails. A route that only matches on deep-pasted words scores lower (BUG-012).
$zone = if ($plow.Length -gt 160) { $plow.Substring(0,160) } else { $plow }
$margin = if ($table.confidence_margin) { [int]$table.confidence_margin } else { 1 }
$floor  = if ($table.confidence_floor)  { [int]$table.confidence_floor }  else { 2 }
$best = $null; $bestScore = 0; $bestHits = 0; $secondScore = 0
foreach ($r in $table.routes) {
  $hits = 0; $strong = 0; $zoneBonus = 0
  foreach ($k in $r.keywords) {
    # Word-boundary match (allow simple plural) — avoids substring false routes
    # like "code"->codex, "api"->therapist, "plan"->explanation, "feature"->features.
    $pat = '\b' + [Regex]::Escape("$k".ToLower()) + '(?:s|es)?\b'
    if ([Regex]::IsMatch($plow, $pat)) {
      $hits++
      if (-not $weak.ContainsKey("$k".ToLower())) { $strong++; if ([Regex]::IsMatch($zone, $pat)) { $zoneBonus = 1 } }
    }
  }
  # A single weak-only keyword is not a confident route: need >=1 strong OR >=2 total.
  if (($hits -eq 0) -or (($strong -eq 0) -and ($hits -lt 2))) { continue }
  $score = $strong + $zoneBonus
  if ($score -gt $bestScore) { $secondScore = $bestScore; $best = $r; $bestScore = $score; $bestHits = $hits }
  elseif ($score -gt $secondScore) { $secondScore = $score }
}
# Confident only if it clears the floor AND beats the runner-up by the margin;
# else pass through silently (array order no longer breaks ties).
if ((-not $best) -or ($bestScore -lt $floor) -or (($bestScore - $secondScore) -lt $margin)) { exit 0 }

$skills = ($best.skills -join ', '); $fw = ($best.frameworks -join ', ')
$short  = (($best.skills | Select-Object -First 3) -join ' · ')
$fwshort = (($best.frameworks | Select-Object -First 2) -join ' · ')
$fb = if ($table.fallback.command) { "$($table.fallback.command)" } else { 'bash bootstrap/mxm-find-skill.sh "<need>"' }

$tmpl = "[Maxim Default-On Router · ADR-021] This is a $($best.office)-office task ($($best.id)). Use Maxim skills: $skills. Apply frameworks: $fw — cite per ADR-007, confidence-tag per ADR-010. If you lack a native skill for any part, run: $fb (external candidates are Maxim-UNENHANCED per ADR-008). Begin your reply with EXACTLY this line: ""🧭 Maxim: $($best.office) · $short · $fwshort · routing ~{0} tokens"""
$base = ($tmpl -f 0)
$N = [Math]::Max(1, [int]([Math]::Floor($base.Length / 4)))
$final = ($tmpl -f $N)

if ($table.show_token_cost -ne $false) {
  try {
    $logDir = Join-Path $cwd '.mxm-skills'
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Force $logDir | Out-Null }
    $prev = $prompt.Substring(0, [Math]::Min(60, $prompt.Length))
    $entry = @{ ts=(Get-Date -Format s); route=$best.id; office=$best.office; keyword_hits=$bestHits; routing_tokens_est=$N; prompt_preview=$prev } | ConvertTo-Json -Compress
    Add-Content -Path (Join-Path $logDir 'routing-log.jsonl') -Value $entry
  } catch {}
}

$out = @{ hookSpecificOutput = @{ hookEventName='UserPromptSubmit'; additionalContext=$final } } | ConvertTo-Json -Compress
Write-Output $out
exit 0
