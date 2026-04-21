# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-owner-keygen-bootstrap.ps1
#
# Phase 0 bootstrap: generates OWNER-1 RSA machine-bound key pair before
# Sprint 2a authors the final mxm-owner-keygen CLI tool.
#
# Usage:
#   .\mxm-owner-keygen-bootstrap.ps1 -Machine "NK-ZBook"
#
# Produces:
#   ~/.mxm-packs/owner.key       (PRIVATE — NEVER commit, NEVER share)
#   ~/.mxm-packs/owner-$Machine.pub (PUBLIC — commit to mxm-packs-source/build/owner-keys/)
#
# Machine fingerprint algorithm:
#   fingerprint = sha256(cpu_id + disk_serial + primary_mac_address)
#
# Requires: PowerShell 7+, OpenSSL, Node.js (for fingerprint hash)

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Machine,

    [Parameter(Mandatory = $false)]
    [string]$Email = "https://maxim.isystematic.com/contact",

    [Parameter(Mandatory = $false)]
    [string]$Owner = "DrNabeelKhan"
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== Maxim OWNER-1 Keygen Bootstrap (v1.0.0 Phase 0) ===`n" -ForegroundColor Cyan

# --- 1. Preflight ---
$keyDir = Join-Path $env:USERPROFILE ".mxm-packs"
if (-not (Test-Path $keyDir)) {
    New-Item -ItemType Directory -Path $keyDir -Force | Out-Null
    Write-Host "[✓] Created $keyDir" -ForegroundColor Green
}

$privateKey = Join-Path $keyDir "owner.key"
$publicKey = Join-Path $keyDir "owner-$Machine.pub"

if (Test-Path $privateKey) {
    Write-Warning "Private key already exists at $privateKey"
    $confirm = Read-Host "Overwrite? This will break pack decryption on existing artifacts. [y/N]"
    if ($confirm -ne "y") { exit 0 }
}

# Require OpenSSL
$opensslPath = Get-Command openssl -ErrorAction SilentlyContinue
if (-not $opensslPath) {
    throw "OpenSSL not found. Install via winget: winget install OpenSSL.Light"
}

# Require Node.js (for fingerprint hash helper)
$nodePath = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodePath) {
    throw "Node.js not found. Install Node 20+ from https://nodejs.org"
}

# --- 2. Compute machine fingerprint ---
Write-Host "[→] Computing machine fingerprint..." -ForegroundColor Yellow

$cpuId = (Get-CimInstance Win32_Processor | Select-Object -First 1).ProcessorId
$diskSerial = (Get-CimInstance Win32_DiskDrive | Where-Object { $_.DeviceID -match "PHYSICALDRIVE0" } | Select-Object -First 1).SerialNumber.Trim()
$primaryMac = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Virtual -eq $false } | Select-Object -First 1).MacAddress

if (-not $cpuId -or -not $diskSerial -or -not $primaryMac) {
    throw "Failed to gather machine identity. CPU=$cpuId Disk=$diskSerial MAC=$primaryMac"
}

$fingerprintInput = "$cpuId|$diskSerial|$primaryMac"
$fingerprint = node -e "const crypto = require('crypto'); console.log(crypto.createHash('sha256').update('$fingerprintInput').digest('hex'))"

Write-Host "[✓] Machine fingerprint: $($fingerprint.Substring(0, 16))..." -ForegroundColor Green

# --- 3. Generate RSA keypair (4096-bit) ---
Write-Host "[→] Generating 4096-bit RSA keypair..." -ForegroundColor Yellow
& openssl genrsa -out $privateKey 4096 2>&1 | Out-Null
& openssl rsa -in $privateKey -pubout -out $publicKey 2>&1 | Out-Null

if (-not (Test-Path $privateKey) -or -not (Test-Path $publicKey)) {
    throw "Key generation failed."
}

# --- 4. Set restrictive permissions on private key ---
icacls $privateKey /inheritance:r /grant "${env:USERNAME}:F" | Out-Null
Write-Host "[✓] Private key permissions: $env:USERNAME only" -ForegroundColor Green

# --- 5. Write metadata sidecar (not a secret) ---
$metadata = @{
    machine = $Machine
    owner = $Owner
    email = $Email
    fingerprint = $fingerprint
    generated_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    mxm_version = "6.4.4-phase-0"
    key_type = "RSA-4096"
    phase = "bootstrap (pre-Sprint-2a)"
} | ConvertTo-Json

$metadataPath = Join-Path $keyDir "owner-$Machine.meta.json"
$metadata | Out-File -FilePath $metadataPath -Encoding utf8
Write-Host "[✓] Metadata written: $metadataPath" -ForegroundColor Green

# --- 6. Output summary ---
Write-Host "`n=== OWNER-1 KEY GENERATED ===" -ForegroundColor Cyan
Write-Host "Machine       : $Machine"
Write-Host "Owner         : $Owner <$Email>"
Write-Host "Fingerprint   : $fingerprint"
Write-Host "Private key   : $privateKey (PRIVATE — DO NOT SHARE)"
Write-Host "Public key    : $publicKey"
Write-Host "Metadata      : $metadataPath"
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Copy the PUBLIC key to mxm-packs-source repo:"
Write-Host "     cp `"$publicKey`" E:\Projects\Maxim\mxm-packs-source\build\owner-keys\"
Write-Host "  2. Commit to mxm-packs-source:"
Write-Host "     cd E:\Projects\Maxim\mxm-packs-source"
Write-Host "     git add build/owner-keys/owner-$Machine.pub"
Write-Host "     git commit -m `"security: add owner key for $Machine`""
Write-Host "     git push"
Write-Host "  3. The build pipeline (Sprint 2a) will include this .pub when encrypting packs"
Write-Host "  4. Repeat this script on MacBook-Pro using the .sh variant"
Write-Host ""
Write-Host "NEVER share the private key. NEVER commit the private key." -ForegroundColor Red
