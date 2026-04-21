# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# link-local-project.ps1 — Maxim Per-Project Bootstrap
# Version: 3.0.0  |  Maxim v1.0.0
#
# Seeds a new project with Maxim per-project files.
# Assumes Maxim is already globally installed via bootstrap\install-global.ps1.
# In global mode (default): NO .mxm-skills / .claude / CLAUDE.md duplication.
# In legacy mode (-UseGlobalClaude:$false): symlinks everything per-project.
#
# ── Two modes ─────────────────────────────────────────────────────────────────
#
#   INTERACTIVE WIZARD (default — no -ProjectPath supplied):
#     .\bootstrap\link-local-project.ps1
#     Asks questions one at a time, builds project-manifest.json and
#     CLAUDE.project.md fully populated from your answers.
#
#   CLI MODE (v2.1.0-compatible — -ProjectPath supplied):
#     .\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\my-app"
#     .\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\my-app" -ProjectName "My App"
#     .\bootstrap\link-local-project.ps1 -ProjectPath "E:\Projects\my-app" -UseGlobalClaude:$false
#
# ─── Global mode (default, UseGlobalClaude=$true) ────────────────────────────
# Creates (per-project only):
#   config\project-manifest.json            <- fill in project details
#   config\agent-registry.json              <- local copy for /mxm-status
#   CLAUDE.project.md                       <- brand voice + rules
#   .claude.local\settings.local.json       <- Read() path for this project
#   .mxm\skill-gaps.log
#   .mxm\background-agent.log
#   .mxm\handoff.md
#   .claude-sessions-memory\handoff.md      <- session memory storage
#   .claude-sessions-memory\decision-log.md
#   .claude-sessions-memory\skill-gaps.log
#   .mxm-operator-profile\OPERATOR.md      <- operator identity + expertise
#   .mxm-operator-profile\preferences.md   <- output style preferences
#   .mxm-operator-profile\rejected-patterns.md <- patterns to avoid
#   .mxm-operator-profile\communication-style.md <- tone + verbosity
#   .gitignore
# Does NOT create: .mxm-skills, .claude, CLAUDE.md (those come from global install)
#
# ─── Legacy mode (UseGlobalClaude=$false) ────────────────────────────────────
# Additionally symlinks into project:
#   .mxm-skills   -> full Maxim source
#   .claude        -> commands, agents, skills
#   CLAUDE.md      -> dispatch rules
#   documents/reference/FRAMEWORKS_MASTER.md
#   documents/governance/ETHICAL_GUIDELINES.md
#
# Cross-platform: PowerShell 7+ on Windows, macOS, Linux.
# Symlinks require elevated prompt on Windows; work natively on macOS/Linux.

[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(Mandatory=$false)]
  [string]$ProjectPath = "",

  [Parameter(Mandatory=$false)]
  [string]$ProjectName = "",

  [Parameter(Mandatory=$false)]
  [bool]$UseGlobalClaude = $true,

  [Parameter(Mandatory=$false)]
  [switch]$Force = $false
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Detect run mode ───────────────────────────────────────────────────────────
$WizardMode = ($ProjectPath -eq "")

# ── Resolve Maxim root ─────────────────────────────────────────────────────────
$Maxim = Split-Path $MyInvocation.MyCommand.Path -Parent |
        Split-Path -Parent

# ── Cross-platform admin check (Windows only) ─────────────────────────────────
if ($IsWindows) {
  $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::
              GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  if (-not $isAdmin) {
    Write-Host ""
    Write-Host "ERROR: On Windows, this script must run as Administrator to create symlinks." -ForegroundColor Red
    Write-Host "       Right-click PowerShell -> Run as Administrator, then try again." -ForegroundColor Yellow
    Write-Host ""
    exit 1
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# HELPER FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────

function New-Symlink {
  param([string]$LinkPath, [string]$Target, [string]$Label)
  if (Test-Path $LinkPath) {
    if ($Force) { Remove-Item $LinkPath -Recurse -Force }
    else { Write-Host "  [OK] Already exists : $Label" -ForegroundColor Green; return }
  }
  # On Windows use Junction for directories (no elevation issues), SymbolicLink for files
  # On macOS/Linux use SymbolicLink for both
  if ($IsWindows -and (Test-Path $Target -PathType Container)) {
    New-Item -ItemType Junction -Path $LinkPath -Target $Target | Out-Null
  } else {
    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Target | Out-Null
  }
  Write-Host "  [->] Linked         : $Label" -ForegroundColor Cyan
}

function New-Dir {
  param([string]$Path, [string]$Label)
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Force $Path | Out-Null
    Write-Host "  [+] Created        : $Label" -ForegroundColor DarkGray
  }
}

function Copy-Safe {
  param([string]$Source, [string]$Dest, [string]$Label)
  if ((Test-Path $Dest) -and -not $Force) {
    Write-Host "  [OK] Already exists : $Label" -ForegroundColor Green; return
  }
  if (-not (Test-Path $Source)) {
    Write-Host "  [!]  Source missing : $Source" -ForegroundColor Yellow; return
  }
  $destDir = Split-Path $Dest -Parent
  if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Force $destDir | Out-Null }
  Copy-Item $Source $Dest -Force
  Write-Host "  [c] Copied         : $Label" -ForegroundColor DarkGray
}

function New-File {
  param([string]$Path, [string]$Content, [string]$Label)
  if ((Test-Path $Path) -and -not $Force) {
    Write-Host "  [OK] Already exists : $Label" -ForegroundColor Green; return
  }
  $dir = Split-Path $Path -Parent
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  Set-Content -Path $Path -Value $Content -Encoding UTF8
  Write-Host "  [f] Created        : $Label" -ForegroundColor DarkGray
}

function Read-WizardInput {
  param(
    [string]$Prompt,
    [string]$Default = "",
    [string[]]$ValidValues = @()
  )
  $displayDefault = if ($Default -ne "") { " [default: $Default]" } else { "" }
  $displayValid   = if ($ValidValues.Count -gt 0) { " ($($ValidValues -join ' / '))" } else { "" }

  while ($true) {
    Write-Host "  $Prompt$displayValid$displayDefault : " -NoNewline -ForegroundColor Cyan
    $raw = $Host.UI.ReadLine()
    $value = if ($raw.Trim() -eq "" -and $Default -ne "") { $Default } else { $raw.Trim() }

    if ($ValidValues.Count -gt 0 -and $value -ne "") {
      $match = $ValidValues | Where-Object { $_ -ieq $value }
      if (-not $match) {
        Write-Host "    Invalid choice. Choose from: $($ValidValues -join ', ')" -ForegroundColor Yellow
        continue
      }
      $value = $match  # normalise casing
    }
    if ($value -eq "" -and $Default -eq "") {
      Write-Host "    This field is required." -ForegroundColor Yellow
      continue
    }
    return $value
  }
}

function Read-YesNo {
  param([string]$Prompt, [bool]$Default = $false)
  $defaultLabel = if ($Default) { "Y/n" } else { "y/N" }
  Write-Host "  $Prompt [$defaultLabel] : " -NoNewline -ForegroundColor Cyan
  $raw = $Host.UI.ReadLine()
  if ($raw.Trim() -eq "") { return $Default }
  return ($raw.Trim() -imatch "^y(es)?$")
}

function ConvertTo-ProjectId {
  param([string]$Name)
  # lowercase, replace spaces/underscores with hyphens, strip special chars
  $id = $Name.ToLower()
  $id = $id -replace '[\s_]+', '-'
  $id = $id -replace '[^a-z0-9\-]', ''
  $id = $id -replace '-{2,}', '-'
  $id = $id.Trim('-')
  return $id
}

function Show-SummaryTable {
  param([hashtable]$Data)
  Write-Host ""
  Write-Host "  ── Project Summary ──────────────────────────────────────────" -ForegroundColor White
  Write-Host ("  {0,-22} {1}" -f "Project path:",    $Data.ProjectPath)    -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Project name:",    $Data.ProjectName)    -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Project ID:",      $Data.ProjectId)      -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Owner:",           $Data.Owner)          -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Vertical:",        $Data.Vertical)       -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Stage:",           $Data.Stage)          -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Description:",     $Data.Description)    -ForegroundColor Gray
  $fwList = if ($Data.Frameworks.Count -gt 0) { $Data.Frameworks -join ', ' } else { "(none)" }
  Write-Host ("  {0,-22} {1}" -f "Compliance:",      $fwList)              -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Model provider:",  $Data.ModelProvider)  -ForegroundColor Gray
  Write-Host ("  {0,-22} {1}" -f "Maxim mode:",       $(if ($Data.UseGlobalClaude) { "GLOBAL" } else { "LEGACY" })) -ForegroundColor Gray
  Write-Host "  ──────────────────────────────────────────────────────────────" -ForegroundColor White
  Write-Host ""
}

# ─────────────────────────────────────────────────────────────────────────────
# MANIFEST GENERATOR
# Builds a fully-populated project-manifest.json from wizard answers.
# ─────────────────────────────────────────────────────────────────────────────

function Build-ManifestJson {
  param([hashtable]$WizardData)

  $today        = Get-Date -Format "yyyy-MM-dd"
  $nextReview   = (Get-Date).AddDays(30).ToString("yyyy-MM-dd")
  $id           = $WizardData.ProjectId
  $name         = $WizardData.ProjectName
  $owner        = $WizardData.Owner
  $vertical     = $WizardData.Vertical
  $description  = $WizardData.Description
  $stage        = $WizardData.Stage
  $provider     = $WizardData.ModelProvider
  $frameworks   = $WizardData.Frameworks   # string[]

  # Build JSON arrays
  $fwJsonArray   = if ($frameworks.Count -gt 0) {
    "[`"" + ($frameworks -join '", "') + "`"]"
  } else { "[]" }

  $regulatedProjects = if ($frameworks | Where-Object { $_ -in @("GDPR","HIPAA","SOC2","UAE-PDPL","PIPEDA","AU-Privacy-Act-1988") }) {
    "[`"$id`"]"
  } else { "[]" }

  $paymentProjects = if ($frameworks -contains "PCI-DSS") { "[`"$id`"]" } else { "[]" }
  $hipaaProjects   = if ($frameworks -contains "HIPAA")   { "[`"$id`"]" } else { "[]" }

  $perProjectFw = if ($frameworks.Count -gt 0) {
    "`"$id`": [`"" + ($frameworks -join '", "') + "`"]"
  } else {
    "`"$id`": []"
  }

  return @"
{
  "manifest_version": "1.0.0",
  "mxm_version": "5.0.0",
  "description": "Project identity manifest for $name. Generated by Maxim setup wizard.",

  "project": {
    "id": "$id",
    "name": "$name",
    "owner": "$owner",
    "vertical": "$vertical",
    "description": "$description",
    "stage": "$stage",
    "active": true
  },

  "portfolio": [
    {
      "id": "$id",
      "name": "$name",
      "vertical": "$vertical",
      "stage": "$stage"
    }
  ],

  "compliance": {
    "frameworks": $fwJsonArray,
    "per_project": {
      $perProjectFw
    },
    "regulated_projects": $regulatedProjects,
    "payment_projects": $paymentProjects,
    "hipaa_projects": $hipaaProjects
  },

  "tech_stack": {
    "default_model_provider": "$provider",
    "supported_providers": ["anthropic", "openai", "gemini", "mistral", "local"],
    "preferred_models": {
      "reasoning": "claude-sonnet",
      "code": "claude-sonnet",
      "fast": "claude-haiku",
      "vision": "claude-sonnet"
    }
  },

  "bootstrap_templates": {
    "selected": "none"
  },

  "agent_overrides": {
    "description": "Per-project agent behavior overrides. Leave empty for standard Maxim behavior.",
    "overrides": []
  },

  "super_user": {
    "enabled": false,
    "identity": "$owner",
    "bypass": {
      "cso_auto_loop": false,
      "ethics_gate": false,
      "compliance_pre_check": false,
      "confidence_tagging": false,
      "escalation_required": false
    },
    "note": "Set enabled to true to suppress Maxim governance gates. Claude's own values layer is not affected."
  },

  "maintainer": "$owner",
  "last_updated": "$today",
  "next_review": "$nextReview"
}
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# CLAUDE.project.md GENERATOR
# ─────────────────────────────────────────────────────────────────────────────

function Build-ClaudeProjectMd {
  param([hashtable]$WizardData)

  $today       = Get-Date -Format "yyyy-MM-dd"
  $id          = $WizardData.ProjectId
  $name        = $WizardData.ProjectName
  $owner       = $WizardData.Owner
  $vertical    = $WizardData.Vertical
  $stage       = $WizardData.Stage
  $frameworks  = $WizardData.Frameworks
  $fwDisplay   = if ($frameworks.Count -gt 0) { $frameworks -join ' | ' } else { "None declared" }

  $regulatedSection = if ($frameworks | Where-Object { $_ -in @("GDPR","HIPAA","SOC2","UAE-PDPL","PIPEDA","AU-Privacy-Act-1988") }) {
@"

### Regulated Projects

- All data access must be logged (who, what, when)
- Security Analyst BLOCK status requires human sign-off before proceeding
- Compliance loop mandatory before any code handoff
- Active frameworks: $fwDisplay
"@
  } else { "" }

  $paymentSection = if ($frameworks -contains "PCI-DSS") {
@"

### Payment Projects (PCI-DSS)

- No card data in application layer
- Security Analyst verifies PCI compliance on every payment-related task
- Tokenisation required — raw card numbers never stored or logged
"@
  } else { "" }

  $hipaaSection = if ($frameworks -contains "HIPAA") {
@"

### Healthcare Projects (HIPAA)

- PHI must never appear in logs, error messages, or non-encrypted storage
- AI Ethics Reviewer required for any feature processing health data
- BAA required before any third-party data processor integration
"@
  } else { "" }

  return @"
# Maxim Project Configuration — $name

**Project:** $name
**ID:** ``$id``
**Owner:** $owner
**Vertical:** $vertical
**Stage:** $stage
**Last Updated:** $today

> Universal Maxim rules live in ``CLAUDE.md`` (global install).
> This file adds project-specific overrides only.

---

## Active Projects

| ID | Project | Vertical | Stage | Compliance |
|---|---|---|---|---|
| ``$id`` | $name | $vertical | $stage | $fwDisplay |

**Source of truth:** ``config/project-manifest.json``

---

## Compliance Requirements

Active frameworks: **$fwDisplay**

> These frameworks were declared during project setup.
> To add or remove frameworks, edit ``config/project-manifest.json`` -> ``compliance.frameworks``
> and update this section accordingly.
$regulatedSection$paymentSection$hipaaSection

---

## Project-Specific Agent Rules
$regulatedSection
### AI / LLM Projects

- Prompt Engineer loops on any LLM-facing feature
- AI Ethics Reviewer required for personal data processing
- Eval workspace used before any model swap in production

> Add project-specific rules below. Remove placeholder comments once filled.

<!-- Example rules:
- example-project: Security Analyst must approve all auth flows
- example-project: No third-party analytics on user health data
-->

---

## Brand Voice

- **Tone:** <!-- e.g. Precise, confident, systems-thinking — never jargon-heavy -->
- **Audience:** <!-- e.g. Enterprise CTOs, compliance officers, regulators -->
- **Core message:** <!-- One sentence positioning statement -->
- **Avoid:** <!-- e.g. Buzzwords without substance, vague claims, consumer-grade language -->

---

## Tech Stack Preferences

- **Default model provider:** $($WizardData.ModelProvider)
- **Primary language / framework:** <!-- e.g. TypeScript / Next.js / FastAPI -->
- **Infrastructure:** <!-- e.g. Azure / AWS / GCP / self-hosted -->
- **Database:** <!-- e.g. PostgreSQL / Cosmos DB / MongoDB -->
- **CI/CD:** <!-- e.g. GitHub Actions / Azure DevOps -->

---

## Session Memory Storage

<!-- DO NOT REMOVE — required by CLAUDE.md session enforcement -->

- **Session files:** ``.claude-sessions-memory/session-[YYYY-MM-DD].md``
- **Handoff state:** ``.claude-sessions-memory/handoff.md``
- **Decision log:** ``.claude-sessions-memory/decision-log.md``
- **Skill gaps:** ``.claude-sessions-memory/skill-gaps.log``
- **Task plan:** ``task_plan.md`` (project root)
- **Progress:** ``progress.md`` (project root)

> All session writes go to ``.claude-sessions-memory/`` inside this project folder.
> Never write session or memory files to the global ``%USERPROFILE%\.claude\`` directory.

---

## How to Complete This Setup

1. Fill in Brand Voice and Tech Stack Preferences above
2. Verify ``config/project-manifest.json`` compliance frameworks match your markets
3. Open this project in Claude Code
4. Run ``/mxm-status`` to confirm Maxim is loaded and compliance frameworks are detected
5. Run ``/mxm-behavior`` if any agent rules need further customisation
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# INTERACTIVE WIZARD
# ─────────────────────────────────────────────────────────────────────────────

function Invoke-SetupWizard {
  Write-Host ""
  Write-Host "Maxim Per-Project Setup Wizard  v3.0.0" -ForegroundColor Cyan
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
  Write-Host "Answer each question and press Enter." -ForegroundColor DarkGray
  Write-Host "Press Enter alone to accept the [default]." -ForegroundColor DarkGray
  Write-Host ""

  # ── Q1: Project path ──────────────────────────────────────────────────────
  $defaultPath = (Get-Location).Path
  Write-Host "  Project path [default: current directory ($defaultPath)] : " -NoNewline -ForegroundColor Cyan
  $rawPath = $Host.UI.ReadLine()
  $chosenPath = if ($rawPath.Trim() -eq "") { $defaultPath } else { $rawPath.Trim() }

  # ── Q2: Project name ──────────────────────────────────────────────────────
  $projectName = Read-WizardInput -Prompt "Project name (display)"

  # ── Q3: Project ID ────────────────────────────────────────────────────────
  $suggestedId = ConvertTo-ProjectId -Name $projectName
  Write-Host "  Project ID [suggested: $suggestedId] : " -NoNewline -ForegroundColor Cyan
  $rawId = $Host.UI.ReadLine()
  $projectId = if ($rawId.Trim() -eq "") { $suggestedId } else { ConvertTo-ProjectId -Name $rawId.Trim() }

  # ── Q4: Owner ─────────────────────────────────────────────────────────────
  $owner = Read-WizardInput -Prompt "Owner (GitHub username)"

  # ── Q5: Vertical ──────────────────────────────────────────────────────────
  $verticals = @("SaaS","AI","FinTech","HealthTech","LegalTech","EdTech","Other")
  $vertical  = Read-WizardInput -Prompt "Vertical" -ValidValues $verticals

  # ── Q6: Stage ─────────────────────────────────────────────────────────────
  $stages = @("idea","early-stage","active","scaling","mature")
  $stage  = Read-WizardInput -Prompt "Stage" -ValidValues $stages

  # ── Q7: Description ───────────────────────────────────────────────────────
  $description = Read-WizardInput -Prompt "Description (one sentence)"

  # ── Q8: Compliance frameworks ─────────────────────────────────────────────
  Write-Host ""
  Write-Host "  Compliance frameworks — answer y or N for each:" -ForegroundColor White

  $frameworks = [System.Collections.Generic.List[string]]::new()

  $compliancePrompts = @(
    @{ Key = "GDPR";                Label = "GDPR (EU General Data Protection Regulation)" },
    @{ Key = "HIPAA";               Label = "HIPAA (US Health Insurance Portability)" },
    @{ Key = "PCI-DSS";             Label = "PCI-DSS (Payment Card Industry)" },
    @{ Key = "PIPEDA";              Label = "PIPEDA (Canadian Personal Information)" },
    @{ Key = "SOC2";                Label = "SOC2 (Service Organization Controls)" },
    @{ Key = "UAE-PDPL";            Label = "UAE-PDPL (UAE Personal Data Protection)" },
    @{ Key = "AU-Privacy-Act-1988"; Label = "AU Privacy Act 1988 (Australian Privacy)" }
  )

  foreach ($fw in $compliancePrompts) {
    $selected = Read-YesNo -Prompt $fw.Label -Default $false
    if ($selected) { $frameworks.Add($fw.Key) }
  }

  # ── Q9: Model provider ────────────────────────────────────────────────────
  Write-Host ""
  $providers     = @("anthropic","openai","gemini","mistral","local")
  $modelProvider = Read-WizardInput -Prompt "Default model provider" -Default "anthropic" -ValidValues $providers

  # ── Confirmation ──────────────────────────────────────────────────────────
  $wizardData = @{
    ProjectPath    = $chosenPath
    ProjectName    = $projectName
    ProjectId      = $projectId
    Owner          = $owner
    Vertical       = $vertical
    Stage          = $stage
    Description    = $description
    Frameworks     = @($frameworks)
    ModelProvider  = $modelProvider
    UseGlobalClaude = $UseGlobalClaude
  }

  Show-SummaryTable -Data $wizardData

  Write-Host "  Create project with these settings?" -NoNewline -ForegroundColor White
  $confirm = Read-YesNo -Prompt "" -Default $true
  if (-not $confirm) {
    Write-Host ""
    Write-Host "  Aborted. No files were written." -ForegroundColor Yellow
    Write-Host ""
    exit 0
  }

  return $wizardData
}

# ─────────────────────────────────────────────────────────────────────────────
# CORE BOOTSTRAP — runs in both modes
# ─────────────────────────────────────────────────────────────────────────────

function Invoke-Bootstrap {
  param([hashtable]$WizardData)

  $resolvedPath = $WizardData.ProjectPath
  $displayName  = $WizardData.ProjectName
  $globalMode   = $WizardData.UseGlobalClaude

  # Resolve / create project directory
  $resolved = Resolve-Path $resolvedPath -ErrorAction SilentlyContinue
  if (-not $resolved) {
    New-Item -ItemType Directory -Force $resolvedPath | Out-Null
    $resolved = Resolve-Path $resolvedPath
  }
  $PROJECT = $resolved.Path

  $today = Get-Date -Format "yyyy-MM-dd"

  # ── Header ────────────────────────────────────────────────────────────────
  Write-Host ""
  Write-Host "Maxim Per-Project Bootstrap  v3.0.0" -ForegroundColor Cyan
  Write-Host "────────────────────────────────────" -ForegroundColor Cyan
  Write-Host "  Maxim source : $Maxim"
  Write-Host "  Project     : $PROJECT"

  if ($globalMode) {
    $GLOBAL_CLAUDE = [IO.Path]::Combine($HOME, ".claude")
    Write-Host "  Mode        : GLOBAL (using $GLOBAL_CLAUDE)" -ForegroundColor Green
    if (-not (Test-Path ([IO.Path]::Combine($GLOBAL_CLAUDE, "CLAUDE.md")))) {
      Write-Host ""
      Write-Host "  WARNING: Global Maxim not installed yet." -ForegroundColor Yellow
      Write-Host "           Run first: .\bootstrap\install-global.ps1" -ForegroundColor Cyan
      Write-Host ""
    }
  } else {
    Write-Host "  Mode        : LEGACY (per-project symlinks)" -ForegroundColor Yellow
  }
  Write-Host ""

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 1 — Project directory structure
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 1/7 ] Creating project structure..." -ForegroundColor White
  New-Dir ([IO.Path]::Combine($PROJECT, "config"))                               "config/"
  New-Dir ([IO.Path]::Combine($PROJECT, ".mxm-skills"))                          ".mxm-skills/"
  New-Dir ([IO.Path]::Combine($PROJECT, "documents"))                            "documents/"
  New-Dir ([IO.Path]::Combine($PROJECT, "documents", "ADRs"))                    "documents/ADRs/"
  New-Dir ([IO.Path]::Combine($PROJECT, "documents", "ledgers"))                 "documents/ledgers/"
  New-Dir ([IO.Path]::Combine($PROJECT, "documents", "architecture"))            "documents/architecture/"
  New-Dir ([IO.Path]::Combine($PROJECT, "documents", "architecture", ".secrets")) "documents/architecture/.secrets/"
  New-Dir ([IO.Path]::Combine($PROJECT, "documents", "business"))                "documents/business/"
  New-Dir ([IO.Path]::Combine($PROJECT, "prototypes"))                           "prototypes/"
  New-Dir ([IO.Path]::Combine($PROJECT, ".claude-sessions-memory"))              ".claude-sessions-memory/"

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 2 — Maxim shared assets (global vs legacy)
  # ────────────────────────────────────────────────────────────────────────────
  if ($globalMode) {
    Write-Host "[ 2/7 ] Global mode — skipping shared asset symlinks." -ForegroundColor DarkGray
    Write-Host "        CLAUDE.md, .claude/, agents/, skills/ served from global Maxim install." -ForegroundColor DarkGray
  } else {
    Write-Host "[ 2/7 ] Legacy mode — symlinking shared Maxim assets per-project..." -ForegroundColor Yellow
    New-Symlink ([IO.Path]::Combine($PROJECT, ".mxm-skills"))          $Maxim                                              ".mxm-skills -> Maxim source"
    New-Symlink ([IO.Path]::Combine($PROJECT, ".claude"))               ([IO.Path]::Combine($Maxim, ".claude"))             ".claude/ -> commands + agents"
    New-Symlink ([IO.Path]::Combine($PROJECT, "CLAUDE.md"))             ([IO.Path]::Combine($Maxim, "CLAUDE.md"))           "CLAUDE.md -> dispatch rules"
    New-Symlink ([IO.Path]::Combine($PROJECT, "documents/reference/FRAMEWORKS_MASTER.md"))  ([IO.Path]::Combine($Maxim, "documents/reference/FRAMEWORKS_MASTER.md")) "documents/reference/FRAMEWORKS_MASTER.md"
    New-Symlink ([IO.Path]::Combine($PROJECT, "documents/governance/ETHICAL_GUIDELINES.md")) ([IO.Path]::Combine($Maxim, "documents/governance/ETHICAL_GUIDELINES.md")) "documents/governance/ETHICAL_GUIDELINES.md"
  }

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 3 — Per-project config files
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 3/7 ] Writing per-project config files..." -ForegroundColor White

  $manifestPath    = [IO.Path]::Combine($PROJECT, "config", "project-manifest.json")
  $claudeProjectMd = [IO.Path]::Combine($PROJECT, "CLAUDE.project.md")

  if ($WizardData.ProjectId -ne "") {
    # Wizard mode — generate fully-populated files from answers
    if ((Test-Path $manifestPath) -and -not $Force) {
      Write-Host "  [OK] Already exists : config/project-manifest.json" -ForegroundColor Green
    } else {
      $manifestContent = Build-ManifestJson -WizardData $WizardData
      $dir = Split-Path $manifestPath -Parent
      if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
      Set-Content -Path $manifestPath -Value $manifestContent -Encoding UTF8
      Write-Host "  [f] Created        : config/project-manifest.json" -ForegroundColor DarkGray

      # JSON validation
      try {
        $null = Get-Content $manifestPath -Raw | ConvertFrom-Json
        Write-Host "  [OK] JSON valid     : config/project-manifest.json" -ForegroundColor Green
      } catch {
        Write-Host "  [ERR] JSON invalid  : config/project-manifest.json — $_" -ForegroundColor Red
      }
    }

    if ((Test-Path $claudeProjectMd) -and -not $Force) {
      Write-Host "  [OK] Already exists : CLAUDE.project.md" -ForegroundColor Green
    } else {
      $mdContent = Build-ClaudeProjectMd -WizardData $WizardData
      Set-Content -Path $claudeProjectMd -Value $mdContent -Encoding UTF8
      Write-Host "  [f] Created        : CLAUDE.project.md" -ForegroundColor DarkGray
    }
  } else {
    # CLI mode — copy templates (v2.1.0 behaviour)
    Copy-Safe ([IO.Path]::Combine($Maxim, "config", "project-manifest.TEMPLATE.json")) $manifestPath           "config/project-manifest.json (from template)"
    Copy-Safe ([IO.Path]::Combine($Maxim, "documents/templates/CLAUDE.project.TEMPLATE.md"))               $claudeProjectMd        "CLAUDE.project.md (from template)"
  }

  # agent-registry.json always copied from source
  Copy-Safe ([IO.Path]::Combine($Maxim, "config", "agent-registry.json")) ([IO.Path]::Combine($PROJECT, "config", "agent-registry.json")) "config/agent-registry.json"

  # CLI mode: pre-fill project name if -ProjectName supplied
  if ($WizardData.ProjectId -eq "" -and $displayName -ne "") {
    $manifest = Get-Content $manifestPath -Raw -ErrorAction SilentlyContinue
    if ($manifest) {
      $manifest = $manifest -replace '"Your Project Name"',   "`"$displayName`""
      $manifest = $manifest -replace '"your-project-name"',  "`"$(ConvertTo-ProjectId -Name $displayName)`""
      $manifest = $manifest -replace '"your-project-id"',    "`"$(ConvertTo-ProjectId -Name $displayName)`""
      Set-Content $manifestPath $manifest -Encoding UTF8
      Write-Host "  [OK] Project name pre-filled : $displayName" -ForegroundColor Green
    }
  }

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 4 — Runtime state files (.mxm-skills/)
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 4/7 ] Creating .mxm-skills/ runtime state files..." -ForegroundColor White

  New-File ([IO.Path]::Combine($PROJECT, ".mxm", "skill-gaps.log")) @"
# Maxim Skill Gaps Log
# Format: [ISO-TIMESTAMP] [SKILL-GAP|Maxim-UNENHANCED] domain: message
# Review after every session. Entries here drive skill priority.
"@ ".mxm-skills/agents-skill-gaps.log"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm", "background-agent.log")) @"
# Maxim Background Agent Log
# Format: [ISO-TIMESTAMP] [BACKGROUND-AGENT|BACKGROUND-FAIL] message
"@ ".mxm-skills/agents-background.log"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm", "handoff.md")) @"
# Maxim Agent Handoff
# Written by orchestrators during multi-agent task chains.
# This file is runtime-only — do not commit.
"@ ".mxm-skills/agents-handoff.md"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm", "review-queue.md")) @"
# Maxim Review Queue
# Items pending human review. Generated by skill-synthesizer, gap-triage, and staleness prevention.
# Consumed by /mxm-ceo-morning (Task 0) and /mxm-ceo-overnight (gap-triage).

## Pending Review

| # | Type | Title | Source | Date | Status |
|---|---|---|---|---|---|

## Review History
"@ ".mxm-skills/review-queue.md"

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 5 — Session memory files (.claude-sessions-memory/)
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 5/7 ] Creating .claude-sessions-memory/ files..." -ForegroundColor White

  New-File ([IO.Path]::Combine($PROJECT, ".claude-sessions-memory", "handoff.md")) @"
# Session Handoff — $displayName
# Last updated: $today
# Use this file to resume context across Claude Code sessions.

## Last Session Summary
<!-- Claude Code writes here automatically at session end -->

## Open Tasks
<!-- Incomplete items from last session -->

## Key Decisions Made
<!-- Architecture or product decisions logged here -->

## Next Session Start Point
<!-- What to load and run first next session -->
"@ ".claude-sessions-memory/handoff.md"

  New-File ([IO.Path]::Combine($PROJECT, ".claude-sessions-memory", "decision-log.md")) @"
# Decision Log — $displayName
# Format: [DATE] [DECISION] rationale
# Append entries. Never delete.
"@ ".claude-sessions-memory/decision-log.md"

  New-File ([IO.Path]::Combine($PROJECT, ".claude-sessions-memory", "skill-gaps.log")) @"
# Session Skill Gaps — $displayName
# Format: [ISO-TIMESTAMP] [SKILL-GAP|Maxim-UNENHANCED] domain: message
"@ ".claude-sessions-memory/skill-gaps.log"

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 5b — Operator profile (.mxm-operator-profile/)
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 5b/7 ] Creating .mxm-operator-profile/ files..." -ForegroundColor White

  New-Dir ([IO.Path]::Combine($PROJECT, ".mxm-operator-profile")) ".mxm-operator-profile/"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm-operator-profile", "OPERATOR.md")) @"
# Operator Profile — $displayName
# Last updated: $today

## Identity
<!-- Your name, role, and relationship to this project -->

## Expertise
<!-- Domains you're strong in — helps Maxim calibrate detail level -->

## Working Style
<!-- How you prefer to receive information, level of detail, etc. -->

## Goals
<!-- Current priorities and objectives for this project -->
"@ ".mxm-operator-profile/OPERATOR.md"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm-operator-profile", "preferences.md")) @"
# Operator Preferences — $displayName
# Last updated: $today
# Maxim reads this to adapt output style, tool choices, and defaults.
"@ ".mxm-operator-profile/preferences.md"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm-operator-profile", "rejected-patterns.md")) @"
# Rejected Patterns — $displayName
# Last updated: $today
# Patterns, approaches, or suggestions the operator has explicitly rejected.
# Maxim will avoid repeating these.
"@ ".mxm-operator-profile/rejected-patterns.md"

  New-File ([IO.Path]::Combine($PROJECT, ".mxm-operator-profile", "communication-style.md")) @"
# Communication Style — $displayName
# Last updated: $today
# How the operator prefers Maxim to communicate.
# Tone, verbosity, formatting preferences, etc.
"@ ".mxm-operator-profile/communication-style.md"

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 6 — .gitignore
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 6/7 ] Creating .gitignore..." -ForegroundColor White

  $maximPrivateDocs = @"
# ── Maxim private documents (operator-local, never committed) ─────────────
# ADRs, architecture, business, references: local-only working folders.
# Public-facing docs live on maxim.isystematic.com, not in version control.
documents/ADRs/
documents/architecture/
documents/business/
documents/references/
documents/build-artifacts-scripts/

# ── Maxim ledger state (session-local, never committed) ──────────────────
documents/ledgers/SESSION_CONTINUITY.md
documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md
"@

  $gitignoreContent = if ($globalMode) {
@"
# ── Maxim Session Memory (not for version control) ──────────────────────────
.claude-sessions-memory/

# ── Maxim Runtime State ────────────────────────────────────────────────────
.mxm-skills/agents-handoff.md
.mxm-skills/agents-skill-gaps.log
.mxm-skills/agents-background.log
.mxm-skills/review-queue.md

# ── Maxim Operator Profile (personal, not for version control) ────────────
.mxm-operator-profile/

# ── Maxim Local Config ────────────────────────────────────────────────────
.claude.local/
config/project-manifest.local.json

$maximPrivateDocs

# ── Generated by bootstrap ───────────────────────────────────────────────
GEMINI.md
documents/reference/AGENTS.md
.github/copilot-instructions.md

# ── Common ───────────────────────────────────────────────────────────────
.env
.env.local
node_modules/
__pycache__/
*.pyc
.DS_Store
Thumbs.db
"@
  } else {
@"
# ── Maxim Symlinks (local dev only — not for CI/CD) ─────────────────────────
.mxm-skills
.claude
CLAUDE.md
documents/reference/FRAMEWORKS_MASTER.md
documents/governance/ETHICAL_GUIDELINES.md

# ── Maxim Session Memory ───────────────────────────────────────────────────
.claude-sessions-memory/

# ── Maxim Runtime State ────────────────────────────────────────────────────
.mxm-skills/agents-handoff.md
.mxm-skills/agents-skill-gaps.log
.mxm-skills/agents-background.log
.mxm-skills/review-queue.md

# ── Maxim Operator Profile (personal, not for version control) ────────────
.mxm-operator-profile/

# ── Maxim Local Config ────────────────────────────────────────────────────
.claude.local/
config/project-manifest.local.json

$maximPrivateDocs

# ── Generated by bootstrap ───────────────────────────────────────────────
GEMINI.md
documents/reference/AGENTS.md
.github/copilot-instructions.md

# ── Common ───────────────────────────────────────────────────────────────
.env
.env.local
node_modules/
__pycache__/
*.pyc
.DS_Store
Thumbs.db
"@
  }

  New-File ([IO.Path]::Combine($PROJECT, ".gitignore")) $gitignoreContent ".gitignore"

  # ────────────────────────────────────────────────────────────────────────────
  # STEP 7 — settings.local.json
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host "[ 7/7 ] Creating project-scoped settings.local.json..." -ForegroundColor White

  # Always use forward slashes for Claude settings paths (cross-platform)
  $projectPathForward = $PROJECT -replace '\\', '/'
  $settingsContent = @"
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(node -e \":\"*)",
      "Bash(python3 -c \":\"*)",
      "Read($projectPathForward/**)",
      "Edit($projectPathForward/**)",
      "Write($projectPathForward/**)"
    ]
  }
}
"@

  New-File ([IO.Path]::Combine($PROJECT, ".claude.local", "settings.local.json")) $settingsContent ".claude.local/settings.local.json"

  # ────────────────────────────────────────────────────────────────────────────
  # VALIDATION
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host ""
  Write-Host "Validation" -ForegroundColor White
  Write-Host "──────────" -ForegroundColor White

  $perProjectChecks = @(
    @{ Path = $manifestPath;                                                                           Label = "config/project-manifest.json" },
    @{ Path = [IO.Path]::Combine($PROJECT, "config", "agent-registry.json");                          Label = "config/agent-registry.json" },
    @{ Path = $claudeProjectMd;                                                                        Label = "CLAUDE.project.md" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".claude.local", "settings.local.json");                   Label = ".claude.local/settings.local.json" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".mxm", "skill-gaps.log");                                Label = ".mxm-skills/agents-skill-gaps.log" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".claude-sessions-memory", "handoff.md");                  Label = ".claude-sessions-memory/handoff.md" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".claude-sessions-memory", "decision-log.md");             Label = ".claude-sessions-memory/decision-log.md" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".claude-sessions-memory", "skill-gaps.log");              Label = ".claude-sessions-memory/skill-gaps.log" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".mxm-operator-profile", "OPERATOR.md");                  Label = ".mxm-operator-profile/OPERATOR.md" },
    @{ Path = [IO.Path]::Combine($PROJECT, ".gitignore");                                             Label = ".gitignore" }
  )

  if ($globalMode) {
    $globalClaude = [IO.Path]::Combine($HOME, ".claude")
    $globalCheck  = @{ Path = [IO.Path]::Combine($globalClaude, "CLAUDE.md"); Label = "~/.claude/CLAUDE.md (global Maxim)" }
    $perProjectChecks = @($globalCheck) + $perProjectChecks
  } else {
    $legacyChecks = @(
      @{ Path = [IO.Path]::Combine($PROJECT, ".mxm-skills"); Label = ".mxm-skills symlink" },
      @{ Path = [IO.Path]::Combine($PROJECT, ".claude");      Label = ".claude/ symlink" },
      @{ Path = [IO.Path]::Combine($PROJECT, "CLAUDE.md");    Label = "CLAUDE.md symlink" }
    )
    $perProjectChecks = $legacyChecks + $perProjectChecks
  }

  $allPass = $true
  foreach ($check in $perProjectChecks) {
    if (Test-Path $check.Path) {
      Write-Host "  [OK] $($check.Label)" -ForegroundColor Green
    } else {
      Write-Host "  [MISSING] $($check.Label)" -ForegroundColor Red
      $allPass = $false
    }
  }

  # ────────────────────────────────────────────────────────────────────────────
  # SUMMARY
  # ────────────────────────────────────────────────────────────────────────────
  Write-Host ""
  if ($allPass) {
    Write-Host "Project ready." -ForegroundColor Green
  } else {
    Write-Host "Some items missing — check errors above." -ForegroundColor Yellow
  }

  Write-Host ""
  Write-Host "Next steps:" -ForegroundColor White

  if ($WizardData.ProjectId -ne "") {
    # Wizard mode — manifest is already filled
    Write-Host "  1. Review config/project-manifest.json — wizard-populated, no manual edits needed"
    Write-Host "  2. Open CLAUDE.project.md — fill in Brand Voice and Tech Stack Preferences"
    Write-Host "  3. Open $PROJECT in Claude Code"
    Write-Host "  4. Run: /mxm-status"
  } else {
    # CLI mode — templates need manual population
    Write-Host "  1. Open config/project-manifest.json — fill in ALL fields marked # REQUIRED"
    Write-Host "  2. Open CLAUDE.project.md — set brand voice, compliance markets, agent rules"
    Write-Host "  3. Open $PROJECT in Claude Code"
    Write-Host "  4. Run: /mxm-status"
  }

  Write-Host ""
  $MaximUpdatePath = $Maxim -replace '\\', '/'
  if ($globalMode) {
    Write-Host "  Install mode : GLOBAL — CLAUDE.md and agents loaded from ~/.claude" -ForegroundColor DarkGray
    Write-Host "  Session mem  : .claude-sessions-memory/ (all session writes go here)" -ForegroundColor DarkGray
    Write-Host "  Update Maxim  : cd $MaximUpdatePath && git pull" -ForegroundColor DarkGray
  } else {
    Write-Host "  Install mode : LEGACY — CLAUDE.md and agents symlinked per-project" -ForegroundColor DarkGray
    Write-Host "  Session mem  : .claude-sessions-memory/ (all session writes go here)" -ForegroundColor DarkGray
    Write-Host "  Update Maxim  : cd $MaximUpdatePath && git pull" -ForegroundColor DarkGray
  }
  Write-Host ""
}

# ─────────────────────────────────────────────────────────────────────────────
# ENTRY POINT
# ─────────────────────────────────────────────────────────────────────────────

if ($WizardMode) {
  # ── Interactive wizard mode ────────────────────────────────────────────────
  $wizardAnswers = Invoke-SetupWizard
  $wizardAnswers.UseGlobalClaude = $UseGlobalClaude
  Invoke-Bootstrap -WizardData $wizardAnswers

} else {
  # ── CLI mode (v2.1.0-compatible) ───────────────────────────────────────────
  # ProjectId empty string signals CLI mode to Invoke-Bootstrap
  $cliData = @{
    ProjectPath    = $ProjectPath
    ProjectName    = $ProjectName
    ProjectId      = ""          # empty = use template copy, not wizard generation
    Owner          = ""
    Vertical       = ""
    Stage          = ""
    Description    = ""
    Frameworks     = @()
    ModelProvider  = "anthropic"
    UseGlobalClaude = $UseGlobalClaude
  }
  Invoke-Bootstrap -WizardData $cliData
}
