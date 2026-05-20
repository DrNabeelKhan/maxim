#!/usr/bin/env pwsh
# Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# install-tier-packs.ps1 — Maxim tier-aware install wizard (v1.3.0+, ADR-019)
# Windows PowerShell 5.1+ / PowerShell 7+ on Mac/Linux. Companion to install-tier-packs.sh.
#
# Behavioral framing per ADR-019: loss aversion on capabilities, default effect
# on Trial, endowment setup. No prices shown for Solo/Pro (anchoring decision).

[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet("trial", "solo", "pro", "team", "enterprise", "individual", "")]
  [string]$Tier = ""
)

$ErrorActionPreference = "Stop"

# ─── Pack definitions ─────────────────────────────────────────────────────────
$L1Packs = @(
  "mxm-pack-l1-1-ai-governance",
  "mxm-pack-l1-2-mempalace-pro",
  "mxm-pack-l1-3-proactive-watch",
  "mxm-pack-l1-4-compliance-shield",
  "mxm-pack-l1-5-brand-design-pro",
  "mxm-pack-l1-6-behavioral-intelligence"
)
$L2Packs = @(
  "mxm-pack-l2-1-founder-os",
  "mxm-pack-l2-2-growth-stack",
  "mxm-pack-l2-3-professional-os",
  "mxm-pack-l2-4-agency-all-in"
)
$L3Packs = @(
  "mxm-pack-l3-1-healthcare",
  "mxm-pack-l3-2-legal",
  "mxm-pack-l3-3-fintech",
  "mxm-pack-l3-4-govtech"
)

# ─── Wizard ────────────────────────────────────────────────────────────────────
function Show-Wizard {
  Write-Host ""
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
  Write-Host "  Maxim v1.3.0 · Choose your install" -ForegroundColor Magenta
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
  Write-Host ""
  Write-Host "Maxim Core (already installed · free forever):" -ForegroundColor White
  Write-Host "  - 91 specialist agents across 7 executive offices"
  Write-Host "  - 36 skill domains · 48 slash commands"
  Write-Host "  - 64 behavioral frameworks active by default"
  Write-Host "  - 14 compliance frameworks enforced at MCP layer"
  Write-Host "  - 9 MCPs · 87 tools including NotebookLM research synthesis"
  Write-Host ""
  Write-Host "What you can't access yet (the structural moats Core hints at):" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  L1.1  AI Governance         - audit trail on every AI decision"
  Write-Host "  L1.2  MemPalace Pro         - memory that resumes where you left it"
  Write-Host "  L1.3  Proactive Watch       - drift caught BEFORE you ship"
  Write-Host "  L1.4  Compliance Shield     - 14 frameworks enforced on every output"
  Write-Host "  L1.5  Brand & Design Pro    - your voice locked across AI outputs"
  Write-Host "  L1.6  Behavioral Intel      - the flagship moat (74 frameworks dispatched)"
  Write-Host ""
  Write-Host "  L2 vertical bundles for founders · growth · professional · agency"
  Write-Host "  L3 industry packs for healthcare · legal · fintech · govtech"
  Write-Host ""
  Write-Host "Which path matches you?" -ForegroundColor White
  Write-Host ""
  Write-Host "  [1]  " -NoNewline; Write-Host "90-day trial" -ForegroundColor Green -NoNewline
  Write-Host "  " -NoNewline; Write-Host "(default - recommended)" -ForegroundColor Cyan
  Write-Host "                  All 14 packs unlocked. See the full moat work."
  Write-Host "                  No card required. Cancel anytime."
  Write-Host "                  Why we default to this: hard to evaluate a moat"
  Write-Host "                  you can't see. Run your real work through it for"
  Write-Host "                  three months, then decide what's worth keeping."
  Write-Host ""
  Write-Host "  [2]  Solo            - Core only · upgrade anytime"
  Write-Host "                  Best for: solo operators evaluating Maxim."
  Write-Host "                  What you give up: the 6 L1 structural moats."
  Write-Host ""
  Write-Host "  [3]  Pro             - Core + 6 L1 packs"
  Write-Host "                  Best for: serious operators on 1-2 projects."
  Write-Host "                  What you unlock: audit trail · drift detection ·"
  Write-Host "                  voice lock · compliance enforcement · governance ·"
  Write-Host "                  behavioral intelligence layer."
  Write-Host ""
  Write-Host "  [4]  Team            - Core + L1 + 4 L2 vertical bundles"
  Write-Host "                  Best for: teams running multiple verticals."
  Write-Host "                  Adds: founder-os · growth-stack · pro-os · agency-all."
  Write-Host ""
  Write-Host "  [5]  Enterprise      - Everything · all 14 packs"
  Write-Host "                  Best for: regulated industries · multi-team orgs."
  Write-Host "                  Adds L3 industry packs: healthcare · legal · fintech · govtech."
  Write-Host ""
  Write-Host "  [6]  Choose individually"
  Write-Host ""
  Write-Host "  [q]  Skip · I'll decide later (Core stays installed)"
  Write-Host ""
  $choice = Read-Host "Choice [1]"
  if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }
  return $choice
}

# ─── Install helpers ──────────────────────────────────────────────────────────
function Install-Pack($pack) {
  Write-Host "  -> $pack ... " -NoNewline -ForegroundColor Cyan
  try {
    & claude /plugin install "$pack@maxim-packs" 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "ok" -ForegroundColor Green
    } else {
      Write-Host "check manually" -ForegroundColor Yellow
    }
  } catch {
    Write-Host "check manually" -ForegroundColor Yellow
  }
}

function Install-L1 { Write-Host ""; Write-Host "Installing 6 L1 packs (the structural moat layer)..." -ForegroundColor White; foreach ($p in $L1Packs) { Install-Pack $p } }
function Install-L2 { Write-Host ""; Write-Host "Installing 4 L2 vertical bundles..." -ForegroundColor White; foreach ($p in $L2Packs) { Install-Pack $p } }
function Install-L3 { Write-Host ""; Write-Host "Installing 4 L3 industry packs..." -ForegroundColor White; foreach ($p in $L3Packs) { Install-Pack $p } }

function Issue-TrialJWT {
  Write-Host ""
  Write-Host "Activating 90-day trial..." -ForegroundColor White
  Write-Host "  -> Requesting trial JWT from license worker..." -ForegroundColor Cyan
  try {
    & claude /plugin run mxm-pack-engine activate --trial 90 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "  ok Trial JWT issued (expires in 90 days)" -ForegroundColor Green
    } else {
      Write-Host "  manual activation needed" -ForegroundColor Yellow
      Write-Host "     Visit https://maxim.isystematic.com/trial to claim your trial JWT" -ForegroundColor Cyan
    }
  } catch {
    Write-Host "  manual activation needed" -ForegroundColor Yellow
    Write-Host "     Visit https://maxim.isystematic.com/trial to claim your trial JWT" -ForegroundColor Cyan
  }
}

# ─── Tier handlers ─────────────────────────────────────────────────────────────
function Do-Trial {
  Install-L1; Install-L2; Install-L3; Issue-TrialJWT
  Write-Host ""
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host "  Trial active - 90 days · all 14 packs unlocked" -ForegroundColor Green
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host ""
  Write-Host "What to try first (suggestions ranked by impact):"
  Write-Host ""
  Write-Host "  1. Watch the moat work on YOUR project:" -ForegroundColor Cyan
  Write-Host "     /mxm-watch     -> 13 drift classes scan your repo"
  Write-Host "     /mxm-status    -> see what's stale, what's drifting"
  Write-Host ""
  Write-Host "  2. See behavioral intelligence in action:" -ForegroundColor Cyan
  Write-Host "     /mxm-behavior  -> analyze any decision with Fogg · COM-B · EAST"
  Write-Host ""
  Write-Host "  3. Test compliance enforcement on regulated work:" -ForegroundColor Cyan
  Write-Host "     /mxm-compliance -> 14 frameworks scan your output, flag risk"
  Write-Host ""
  Write-Host "  4. Calibrate your voice:" -ForegroundColor Cyan
  Write-Host "     /mxm-brand-voice calibrate"
  Write-Host "     -> instantiates your own operator-writer · routes every"
  Write-Host "       writing task through your voice automatically"
  Write-Host ""
  Write-Host "Trial ends in 90 days. We'll remind you at day 80."
  Write-Host "To convert: visit maxim.isystematic.com/pricing or /mxm-status"
  Write-Host ""
}

function Do-Solo {
  Write-Host ""
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host "  Solo · Core ready" -ForegroundColor Green
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host ""
  Write-Host "Maxim Core is fully active. 64 behavioral frameworks dispatch on"
  Write-Host "every output. 14 compliance frameworks check every regulated task."
  Write-Host ""
  Write-Host "What stays gated until you upgrade:" -ForegroundColor Yellow
  Write-Host "  - Audit trail on every AI decision (L1.1 AI Governance)"
  Write-Host "  - Cross-session memory continuity (L1.2 MemPalace Pro)"
  Write-Host "  - 13-class drift detection (L1.3 Proactive Watch)"
  Write-Host "  - 14-framework compliance enforcement (L1.4 Compliance Shield)"
  Write-Host "  - Voice lock across all outputs (L1.5 Brand & Design Pro)"
  Write-Host "  - 74-framework behavioral dispatch (L1.6 Behavioral Intel)"
  Write-Host ""
  Write-Host "Try them free for 90 days:" -NoNewline -ForegroundColor Cyan
  Write-Host ".\bootstrap\install-tier-packs.ps1 trial" -ForegroundColor White
  Write-Host ""
  Write-Host "Or upgrade individually anytime: /plugin install <pack-id>@maxim-packs"
  Write-Host ""
}

function Do-Pro {
  Install-L1
  Write-Host ""
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host "  Pro · Core + 6 L1 packs installed" -ForegroundColor Green
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host ""
  Write-Host "What you unlocked:"
  Write-Host "  v  AI Governance audit trail on every AI decision"
  Write-Host "  v  MemPalace Pro cross-session continuity"
  Write-Host "  v  Proactive Watch 13-class drift detection"
  Write-Host "  v  Compliance Shield 14-framework enforcement"
  Write-Host "  v  Brand & Design Pro voice lock"
  Write-Host "  v  Behavioral Intelligence 74-framework dispatch"
  Write-Host ""
  Write-Host "Activate your license JWT: mxm-pack-engine activate --license <JWT>"
  Write-Host ""
}

function Do-Team {
  Install-L1; Install-L2
  Write-Host ""
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host "  Team · Core + L1 + 4 L2 vertical bundles installed" -ForegroundColor Green
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host ""
  Write-Host "Plus vertical bundles for: founder-os · growth-stack · pro-os · agency-all"
  Write-Host ""
  Write-Host "Activate your license JWT: mxm-pack-engine activate --license <JWT>"
  Write-Host ""
}

function Do-Enterprise {
  Install-L1; Install-L2; Install-L3
  Write-Host ""
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host "  Enterprise · All 14 packs installed" -ForegroundColor Green
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host ""
  Write-Host "Plus L3 industry packs: healthcare · legal · fintech · govtech"
  Write-Host ""
  Write-Host "Activate your license JWT: mxm-pack-engine activate --license <JWT>"
  Write-Host ""
}

function Do-Individual {
  Write-Host ""
  Write-Host "Individual pack install - run any of:" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "L1 packs (structural moats):"
  foreach ($p in $L1Packs) { Write-Host "  /plugin install $p@maxim-packs" }
  Write-Host ""
  Write-Host "L2 vertical bundles:"
  foreach ($p in $L2Packs) { Write-Host "  /plugin install $p@maxim-packs" }
  Write-Host ""
  Write-Host "L3 industry packs:"
  foreach ($p in $L3Packs) { Write-Host "  /plugin install $p@maxim-packs" }
  Write-Host ""
}

# ─── Main ──────────────────────────────────────────────────────────────────────
$choice = $Tier
if ([string]::IsNullOrWhiteSpace($choice)) {
  $choice = Show-Wizard
}

switch -Regex ($choice) {
  '^(1|trial)$'         { Do-Trial }
  '^(2|solo)$'          { Do-Solo }
  '^(3|pro)$'           { Do-Pro }
  '^(4|team)$'          { Do-Team }
  '^(5|enterprise)$'    { Do-Enterprise }
  '^(6|individual|i)$'  { Do-Individual }
  '^(q|skip)$'          { Write-Host ""; Write-Host "Skipped. Re-run anytime: .\bootstrap\install-tier-packs.ps1"; Write-Host "" }
  default               { Write-Host "Unknown choice: $choice" -ForegroundColor Red; Write-Host "Valid: 1-6 or trial/solo/pro/team/enterprise/individual/q"; exit 1 }
}
