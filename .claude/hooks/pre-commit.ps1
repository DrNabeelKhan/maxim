# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim - PreCommit Hook (PowerShell)
# =============================================================================
# Mirrors pre-commit.sh on Windows. See that file for protocol description.
#
# Exit codes:
#   0 = pass
#   1 = block (secret found)
# =============================================================================

$ErrorActionPreference = 'Continue'

function Find-ProjectRoot {
    $dir = (Get-Location).Path
    for ($i = 0; $i -lt 4; $i++) {
        if (Test-Path (Join-Path $dir 'config\project-manifest.json')) {
            return $dir
        }
        $parent = Split-Path -Parent $dir
        if ([string]::IsNullOrEmpty($parent) -or $parent -eq $dir) { break }
        $dir = $parent
    }
    return (Get-Location).Path
}

$ProjectRoot = Find-ProjectRoot
Set-Location $ProjectRoot

$NowIso = (Get-Date -AsUTC -Format "yyyy-MM-ddTHH:mm:ssZ")
$AuditLog = Join-Path $ProjectRoot '.mxm-skills\compliance-audit.jsonl'

if (-not (Test-Path '.mxm-skills')) {
    New-Item -ItemType Directory -Path '.mxm-skills' -Force | Out-Null
}

# ----- Get staged files (added or modified) -----
try {
    $stagedFiles = git diff --cached --name-only --diff-filter=AM 2>$null
} catch {
    exit 0
}

if (-not $stagedFiles) { exit 0 }

# ----- Secret patterns (blocking) -----
$SecretPatterns = @(
    'AKIA[0-9A-Z]{16}',
    'aws_secret_access_key\s*=\s*["\047][A-Za-z0-9/+=]{40}["\047]',
    'sk-[a-zA-Z0-9]{32,}',
    'sk-ant-[a-zA-Z0-9_-]{32,}',
    'ghp_[A-Za-z0-9]{36}',
    'gho_[A-Za-z0-9]{36}',
    'glpat-[A-Za-z0-9_-]{20}',
    '-----BEGIN (RSA |EC |DSA |OPENSSH |)PRIVATE KEY-----',
    'xox[baprs]-[A-Za-z0-9-]{10,}'
)

# ----- PII patterns (warning) -----
$PiiPatterns = @(
    '\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b',
    '\b4[0-9]{12}(?:[0-9]{3})?\b',
    '\b5[1-5][0-9]{14}\b'
)

$BinaryExt = @('.png', '.jpg', '.jpeg', '.gif', '.pdf', '.zip', '.tar', '.gz', '.exe', '.dll', '.so', '.dylib', '.ico', '.woff', '.woff2', '.ttf', '.eot', '.mp4', '.mp3', '.wav')

$Violations = 0
$Warnings = 0
$Report = New-Object System.Collections.ArrayList

foreach ($file in $stagedFiles) {
    if (-not $file) { continue }
    if (-not (Test-Path $file)) { continue }

    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    if ($BinaryExt -contains $ext) { continue }

    try {
        $content = git diff --cached $file 2>$null
    } catch { continue }

    if (-not $content) { continue }

    # Check secrets (blocking)
    foreach ($pattern in $SecretPatterns) {
        if ($content -match $pattern) {
            $Violations++
            $patternDesc = $pattern.Substring(0, [Math]::Min(30, $pattern.Length)) + '...'
            [void]$Report.Add("[BLOCK] ${file}: secret pattern detected ($patternDesc)")
            "{`"timestamp`":`"$NowIso`",`"file`":`"$file`",`"violation`":`"secret_exposure`",`"action`":`"blocked`"}" | Add-Content -Path $AuditLog
        }
    }

    # Check PII (warning) - skip examples/documents/tests
    $skip = ($file -match '\.env\.example$') -or ($file -match 'README') -or ($file -like 'documents/*') -or ($file -like 'tests/*') -or ($file -match 'test') -or ($file -match 'fixture')
    if (-not $skip) {
        foreach ($pattern in $PiiPatterns) {
            if ($content -match $pattern) {
                $Warnings++
                [void]$Report.Add("[WARN] ${file}: possible PII pattern")
                "{`"timestamp`":`"$NowIso`",`"file`":`"$file`",`"violation`":`"pii_pattern`",`"action`":`"warned`"}" | Add-Content -Path $AuditLog
            }
        }
    }
}

if ($Violations -gt 0 -or $Warnings -gt 0) {
    [Console]::Error.WriteLine('=======================================================')
    [Console]::Error.WriteLine('Maxim PreCommit - Compliance Scan')
    [Console]::Error.WriteLine('=======================================================')
    foreach ($line in $Report) {
        [Console]::Error.WriteLine($line)
    }
    [Console]::Error.WriteLine("Audit log: $AuditLog")
}

if ($Violations -gt 0) {
    [Console]::Error.WriteLine("[BLOCKED] $Violations secret violation(s) detected.")
    [Console]::Error.WriteLine('   Remove secrets from staged files or use git commit --no-verify (audit gap).')
    exit 1
}

# v1.0.0: Maxim Guard + behavioral-moat-drift (ADR-006, ADR-007)
$hookDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MaximGuard = Join-Path $hookDir 'mxm-guard.ps1'
if (Test-Path $MaximGuard) {
    & pwsh -NoProfile -File $MaximGuard
    if ($LASTEXITCODE -ne 0) {
        [Console]::Error.WriteLine('[BLOCKED] mxm-guard (external-boundary-drift).')
        exit 1
    }
}
$moatDrift = Join-Path $hookDir 'behavioral-moat-drift.ps1'
if (Test-Path $moatDrift) {
    & pwsh -NoProfile -File $moatDrift
    if ($LASTEXITCODE -ne 0) {
        [Console]::Error.WriteLine('[BLOCKED] behavioral-moat-drift (ADR-007).')
        exit 1
    }
}

exit 0
