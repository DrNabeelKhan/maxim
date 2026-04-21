# Maxim Proactive Watch — unified PowerShell driver (v1.0.0 LIGHT phase)
# Implements all 10 drift checkers.
#
# Usage:
#   .\watch.ps1                  # run all enabled checkers (default)
#   .\watch.ps1 all
#   .\watch.ps1 <checker-name>   # run a single checker
#   .\watch.ps1 --list
#
# Output: JSONL to .mxm-skills/watch-report.jsonl + summary to stderr
# Exit code: 0 always (LIGHT phase is warn-only)

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Checker = 'all'
)

$ErrorActionPreference = 'Continue'
$script:ProjectRoot = (Get-Location).Path
$script:MaximSkillsDir = Join-Path $script:ProjectRoot '.mxm-skills'
$script:ReportFile = Join-Path $script:MaximSkillsDir 'watch-report.jsonl'
$script:ErrorFile = Join-Path $script:MaximSkillsDir 'watch-errors.jsonl'
$script:ProjectId = Split-Path $script:ProjectRoot -Leaf
$script:Ts = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$script:DriftCount = 0
$script:ErrorCount = 0

if (-not (Test-Path $script:MaximSkillsDir)) {
    New-Item -ItemType Directory -Path $script:MaximSkillsDir -Force | Out-Null
}

function Emit {
    param(
        [string]$DriftClass,
        [int]$Severity,
        [string]$Triage,
        [string]$Evidence,
        [string]$Declared = '',
        [string]$Actual = ''
    )
    $rec = [ordered]@{
        ts          = $script:Ts
        phase       = 'light'
        project     = $script:ProjectId
        drift_class = $DriftClass
        severity    = $Severity
        triage      = $Triage
        evidence    = $Evidence
        declared    = $Declared
        actual      = $Actual
        action      = 'review-queue'
    }
    ($rec | ConvertTo-Json -Compress) | Out-File -Append -Encoding utf8 $script:ReportFile
    $script:DriftCount++
    Write-Host "  ⚠ $DriftClass`: $Evidence (severity $Severity, triage $Triage)" -ForegroundColor Yellow
}

function EmitError {
    param(
        [string]$Checker,
        [string]$Message,
        [string]$Tier = 'standard'
    )
    $rec = [ordered]@{
        ts      = $script:Ts
        checker = $Checker
        tier    = $Tier
        error   = $Message
    }
    ($rec | ConvertTo-Json -Compress) | Out-File -Append -Encoding utf8 $script:ErrorFile
    $script:ErrorCount++
    Write-Host "  ✗ $Checker`: $Message (tier: $Tier)" -ForegroundColor Red
}

# ──────────── Checker 1: inventory-drift ────────────
function Check-InventoryDrift {
    # Prefer canonical location (documents/ledgers/); fall back to root for legacy repos
    $inv = Join-Path $script:ProjectRoot 'documents/ledgers/AGENT_SKILL_INVENTORY.md'
    if (-not (Test-Path $inv)) {
        $inv = Join-Path $script:ProjectRoot 'AGENT_SKILL_INVENTORY.md'
    }
    if (-not (Test-Path $inv)) { EmitError 'inventory-drift' 'documents/ledgers/AGENT_SKILL_INVENTORY.md not found'; return }

    $content = Get-Content $inv -Raw
    $declared = 0
    if ($content -match '(?i)total\s*agents[^0-9]*(\d+)') { $declared = [int]$Matches[1] }

    $actual = 0
    $agentsDir = Join-Path $script:ProjectRoot 'agents/Maxim'
    if (Test-Path $agentsDir) {
        $actual = (Get-ChildItem -Path $agentsDir -Filter '*.md' -Recurse -File |
                   Where-Object { $_.Name -ne 'README.md' -and $_.FullName.Split([IO.Path]::DirectorySeparatorChar).Count -le ($agentsDir.Split([IO.Path]::DirectorySeparatorChar).Count + 3) }).Count
    }

    if ($declared -ne $actual -and $actual -gt 0) {
        Emit 'inventory-drift' 3 'coo' 'documents/ledgers/AGENT_SKILL_INVENTORY.md:agents' "$declared" "$actual"
    }

    # Skill domain count
    $declaredSkills = 0
    if ($content -match '(?i)skill\s*domains?[^0-9]*(\d+)') { $declaredSkills = [int]$Matches[1] }
    $actualSkills = 0
    $skillsDir = Join-Path $script:ProjectRoot '.claude/skills'
    if (Test-Path $skillsDir) {
        $actualSkills = (Get-ChildItem -Path $skillsDir -Directory | Where-Object { $_.Name -ne 'deprecated' }).Count
    }
    if ($declaredSkills -ne $actualSkills -and $actualSkills -gt 0) {
        Emit 'inventory-drift' 3 'coo' 'documents/ledgers/AGENT_SKILL_INVENTORY.md:skill-domains' "$declaredSkills" "$actualSkills"
    }
}

# ──────────── Checker 2: version-drift ────────────
function Check-VersionDrift {
    $anchor = Join-Path $script:ProjectRoot 'config/agent-registry.json'
    if (-not (Test-Path $anchor)) { EmitError 'version-drift' 'config/agent-registry.json not found'; return }

    $anchorContent = Get-Content $anchor -Raw
    $anchorVer = ''
    if ($anchorContent -match '"version"\s*:\s*"(v?\d+\.\d+\.\d+)"') { $anchorVer = $Matches[1] -replace '^v', '' }
    if (-not $anchorVer) { EmitError 'version-drift' 'could not parse registry version'; return }

    foreach ($f in 'README.md', 'documents/guides/HELP.md', 'documents/guides/ABOUT.md', 'CLAUDE.md') {
        $path = Join-Path $script:ProjectRoot $f
        if (-not (Test-Path $path)) { continue }
        $text = Get-Content $path -Raw
        $allVers = [regex]::Matches($text, 'v?\d+\.\d+\.\d+') | ForEach-Object { $_.Value -replace '^v', '' } | Select-Object -Unique
        if ($allVers.Count -gt 0 -and $allVers -notcontains $anchorVer) {
            Emit 'version-drift' 3 'coo' "${f}:no-match-for-$anchorVer" $anchorVer 'missing'
        }
    }
}

# ──────────── Checker 3: contract-drift ────────────
function Check-ContractDrift {
    # Prefer the canonical location (documents/ADRs); fall back to legacy lowercase
    # path for repos bootstrapped before the rename. New Maxim projects always
    # create documents/ADRs/.
    $adrDir = Join-Path $script:ProjectRoot 'documents/ADRs'
    if (-not (Test-Path $adrDir)) {
        $adrDir = Join-Path $script:ProjectRoot 'documents/adr'
    }
    if (-not (Test-Path $adrDir)) { return }
    $idx = Join-Path $adrDir 'INDEX.md'
    if (-not (Test-Path $idx)) { EmitError 'contract-drift' 'documents/ADRs/INDEX.md not found' 'critical'; return }

    $idxContent = Get-Content $idx -Raw
    # Find all ADR-NNN-slug.md references in ACCEPTED rows
    $acceptedLines = ($idxContent -split "`n") | Where-Object { $_ -match 'ACCEPTED' }
    foreach ($line in $acceptedLines) {
        if ($line -match '(ADR-\d+-[a-z0-9-]+\.md)') {
            $adrFile = $Matches[1]
            if (-not (Test-Path (Join-Path $adrDir $adrFile))) {
                Emit 'contract-drift' 4 'ceo' "INDEX references missing $adrFile" 'exists' 'missing'
            }
        }
    }
}

# ──────────── Checker 4: cross-doc-drift ────────────
function Check-CrossDocDrift {
    $chg = Join-Path $script:ProjectRoot 'CHANGELOG.md'
    if (-not (Test-Path $chg)) { return }

    $chgContent = Get-Content $chg -Raw
    $currentVer = ''
    if ($chgContent -match '(?m)^##\s*\[(\d+\.\d+\.\d+)\]') { $currentVer = $Matches[1] }
    if (-not $currentVer) { return }

    foreach ($f in 'README.md', 'documents/guides/HELP.md') {
        $path = Join-Path $script:ProjectRoot $f
        if (-not (Test-Path $path)) { continue }
        $text = Get-Content $path -Raw
        if ($text -notmatch [regex]::Escape($currentVer)) {
            Emit 'cross-doc-drift' 2 'coo' "${f}:missing-$currentVer" $currentVer 'missing'
        }
    }
}

# ──────────── Checker 5: orphan-refs ────────────
function Check-OrphanRefs {
    $cmdDir = Join-Path $script:ProjectRoot '.claude/commands'
    $skillsDir = Join-Path $script:ProjectRoot '.claude/skills'
    if (-not ((Test-Path $cmdDir) -and (Test-Path $skillsDir))) { return }

    Get-ChildItem $cmdDir -Filter '*.md' -File | ForEach-Object {
        $text = Get-Content $_.FullName -Raw
        $matches = [regex]::Matches($text, '(?i)skill[_-]?id?\s*[:=]\s*([a-z0-9_-]+)')
        foreach ($m in $matches | Select-Object -First 5) {
            $skillId = $m.Groups[1].Value
            if ($skillId -and -not (Test-Path (Join-Path $skillsDir $skillId))) {
                Emit 'orphan-refs' 3 'cto' "$($_.Name):skill-$skillId-missing" 'exists' 'missing'
            }
        }
    }
}

# ──────────── Checker 6: dependency-drift ────────────
function Check-DependencyDrift {
    $mcpDir = Join-Path $script:ProjectRoot 'mcp'
    if (-not (Test-Path $mcpDir)) { return }

    Get-ChildItem $mcpDir -Directory | ForEach-Object {
        $pkg = Join-Path $_.FullName 'package.json'
        if ((Test-Path $pkg) -and ((Get-Content $pkg -Raw) -match '"dependencies"')) {
            if (-not (Test-Path (Join-Path $_.FullName 'node_modules'))) {
                Emit 'dependency-drift' 2 'cto' "$($_.Name):no-node_modules" 'installed' 'missing'
            }
        }
    }
}

# ──────────── Checker 7: git-hygiene ────────────
function Check-GitHygiene {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return }
    git -C $script:ProjectRoot rev-parse --git-dir *> $null
    if ($LASTEXITCODE -ne 0) { return }

    $changes = (git -C $script:ProjectRoot status --porcelain | Measure-Object).Count
    if ($changes -gt 10) {
        Emit 'git-hygiene' 2 'cto' "$changes-uncommitted-files" '< 10' "$changes"
    }

    $branch = (git -C $script:ProjectRoot rev-parse --abbrev-ref HEAD).Trim()
    git -C $script:ProjectRoot rev-parse --verify "origin/$branch" *> $null
    if ($LASTEXITCODE -eq 0) {
        $behind = (git -C $script:ProjectRoot rev-list --count "HEAD..origin/$branch").Trim()
        if ([int]$behind -gt 0) {
            Emit 'git-hygiene' 3 'cto' "branch-$branch-behind-origin" '0' $behind
        }
    }
}

# ──────────── Checker 8: junction-drift ────────────
function Check-JunctionDrift {
    if (-not $env:WINDIR) { return }

    foreach ($j in '.mxm-system', '.claude') {
        $path = Join-Path $script:ProjectRoot $j
        if (Test-Path $path) {
            try {
                $null = Get-ChildItem $path -ErrorAction Stop | Select-Object -First 1
            } catch {
                Emit 'junction-drift' 4 'cto' "${j}:unresolvable" 'resolves' 'broken'
            }
        }
    }
}

# ──────────── Checker 9: stale-handoff ────────────
function Check-StaleHandoff {
    $handoff = Join-Path $script:ProjectRoot '.claude-sessions-memory/handoff.md'
    if (-not (Test-Path $handoff)) { return }

    $age = (Get-Date) - (Get-Item $handoff).LastWriteTime
    if ($age.TotalDays -gt 7) {
        $days = [math]::Round($age.TotalDays)
        Emit 'stale-handoff' 2 'coo' "handoff-$days-days-old" '< 7 days' "$days days"
    }
}

# ──────────── Checker 10: compliance-drift ────────────
function Check-ComplianceDrift {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { EmitError 'compliance-drift' 'git not available' 'critical'; return }

    $pattern = 'AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{32,}|ghp_[A-Za-z0-9]{36}|xoxb-[0-9]+-[0-9]+'
    $hits = @(Get-ChildItem $script:ProjectRoot -Recurse -File -Include '*.md', '*.json', '*.yml', '*.yaml' `
        -Exclude 'node_modules', 'external', '.git' -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\(node_modules|external|\.git)\\' } |
        Select-String -Pattern $pattern -List -ErrorAction SilentlyContinue |
        Select-Object -First 3)

    if ($hits.Count -gt 0) {
        Emit 'compliance-drift' 5 'cso' "secret-pattern-detected-$($hits.Count)-files" '0' "$($hits.Count)"
    }
}

# ──────────── Dispatcher ────────────
function Invoke-Checker {
    param([string]$Name)
    switch ($Name) {
        'inventory-drift'   { Check-InventoryDrift }
        'version-drift'     { Check-VersionDrift }
        'contract-drift'    { Check-ContractDrift }
        'cross-doc-drift'   { Check-CrossDocDrift }
        'orphan-refs'       { Check-OrphanRefs }
        'dependency-drift'  { Check-DependencyDrift }
        'git-hygiene'       { Check-GitHygiene }
        'junction-drift'    { Check-JunctionDrift }
        'stale-handoff'     { Check-StaleHandoff }
        'compliance-drift'  { Check-ComplianceDrift }
        default {
            Write-Host "unknown checker: $Name" -ForegroundColor Red
            return
        }
    }
}

if ($Checker -eq '--list') {
    @"
Available checkers:
  inventory-drift    Capability inventory vs filesystem reality
  version-drift      Version string consistency across docs
  contract-drift     ACCEPTED ADR conformance (🔒 locked to CEO)
  cross-doc-drift    CHANGELOG / README / HELP agreement
  orphan-refs        Commands / hooks pointing to missing files
  dependency-drift   MCP server deps, subtree lag
  git-hygiene        Uncommitted / unpushed staleness
  junction-drift     Broken symlinks / Windows junctions
  stale-handoff      handoff.md age > threshold
  compliance-drift   Secret patterns, PII, license (🔒 locked to CSO)
"@
    exit 0
}

Write-Host "Maxim WATCH (light) ▸ phase=light project=$($script:ProjectId)" -ForegroundColor Cyan

if ($Checker -eq 'all' -or $Checker -eq '--light') {
    foreach ($c in 'inventory-drift', 'version-drift', 'contract-drift', 'cross-doc-drift', 'orphan-refs',
                   'dependency-drift', 'git-hygiene', 'junction-drift', 'stale-handoff', 'compliance-drift') {
        Invoke-Checker $c
    }
} else {
    Invoke-Checker $Checker
}

Write-Host "Maxim WATCH (light) ▸ drift=$($script:DriftCount) errors=$($script:ErrorCount) report=$($script:ReportFile)" -ForegroundColor Cyan
exit 0
