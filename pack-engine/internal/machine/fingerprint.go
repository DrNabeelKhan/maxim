// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Package machine produces a stable machine fingerprint for Maxim license
// machine-binding (ADR-005, OWNER-1 key scheme).
//
// Fingerprint = sha256( cpu_id + disk_serial + primary_mac ) — hex.
//
// BUG-001 fix (v1.0.0 Sprint 2b): parity with bootstrap keygen heuristics.
//   - Disk: PHYSICALDRIVE0 only on Windows (matches PowerShell Win32_DiskDrive filter)
//   - MAC: exclude virtual adapters by interface name substring
//   - Interface enumeration: stable sort by Index before selection
package machine

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"net"
	"os/exec"
	"runtime"
	"sort"
	"strings"
)

// virtualAdapterSubstrings lists interface-name fragments that identify
// virtual adapters excluded from MAC-address fingerprinting. Case-insensitive
// match. Parity source: bootstrap/mxm-owner-keygen-bootstrap.ps1 Get-NetAdapter
// Virtual=$false semantics on Windows 10+.
var virtualAdapterSubstrings = []string{
	"virtual",
	"vethernet",
	"vmware",
	"docker",
	"vboxnet",
	"tailscale",
	"hyper-v",
	"wsl",
}

// IsVirtualAdapter reports whether the given interface name matches any
// virtual-adapter substring. Exported so regression tests can assert the
// filter without enumerating live interfaces.
func IsVirtualAdapter(name string) bool {
	lname := strings.ToLower(name)
	for _, p := range virtualAdapterSubstrings {
		if strings.Contains(lname, p) {
			return true
		}
	}
	return false
}

// Fingerprint returns the stable machine fingerprint.
func Fingerprint() (string, error) {
	cpu, disk, mac := FingerprintComponents()
	if cpu == "" && disk == "" && mac == "" {
		return "", fmt.Errorf("could not collect any hardware identifiers")
	}
	h := sha256.New()
	fmt.Fprintf(h, "%s|%s|%s", cpu, disk, mac)
	return hex.EncodeToString(h.Sum(nil)), nil
}

// FingerprintComponents returns the three raw inputs to Fingerprint() for
// diagnostics and tests. Errors are swallowed to match Fingerprint()'s
// best-effort composition (missing inputs produce empty strings, not panics).
func FingerprintComponents() (cpu, disk, mac string) {
	cpu, _ = cpuID()
	disk, _ = diskSerial()
	mac, _ = primaryMAC()
	return cpu, disk, mac
}

func cpuID() (string, error) {
	switch runtime.GOOS {
	case "windows":
		out, err := exec.Command("wmic", "cpu", "get", "ProcessorId").Output()
		if err != nil {
			return "", err
		}
		return firstNonHeader(string(out)), nil
	case "darwin":
		out, err := exec.Command("sysctl", "-n", "machdep.cpu.brand_string").Output()
		return strings.TrimSpace(string(out)), err
	default:
		out, err := exec.Command("sh", "-c", "lscpu | grep 'Model name' | head -1").Output()
		return strings.TrimSpace(string(out)), err
	}
}

func diskSerial() (string, error) {
	switch runtime.GOOS {
	case "windows":
		// BUG-001: filter to PHYSICALDRIVE0 to match bootstrap keygen. Use LIKE
		// clause because wmic path arguments are whitespace-fragile.
		out, err := exec.Command("wmic", "diskdrive", "where",
			"DeviceID like '%PHYSICALDRIVE0%'",
			"get", "SerialNumber").Output()
		if err != nil {
			return "", err
		}
		return firstNonHeader(string(out)), nil
	case "darwin":
		out, err := exec.Command("sh", "-c", "diskutil info / | grep 'Volume UUID' | awk '{print $3}'").Output()
		return strings.TrimSpace(string(out)), err
	default:
		out, err := exec.Command("sh", "-c", "lsblk -dno SERIAL | head -1").Output()
		return strings.TrimSpace(string(out)), err
	}
}

func primaryMAC() (string, error) {
	ifaces, err := net.Interfaces()
	if err != nil {
		return "", err
	}
	// BUG-001: match PowerShell keygen enumeration. Observed Get-NetAdapter
	// default order on Windows 10+ is InterfaceIndex DESCENDING. Sort to match.
	sort.Slice(ifaces, func(i, j int) bool { return ifaces[i].Index > ifaces[j].Index })
	for _, i := range ifaces {
		if i.HardwareAddr == nil || i.Flags&net.FlagLoopback != 0 {
			continue
		}
		// BUG-001: exclude virtual adapters (Docker, Hyper-V, VPN, etc.) so the
		// pack-engine matches the PowerShell keygen Get-NetAdapter -Virtual:$false.
		if IsVirtualAdapter(i.Name) {
			continue
		}
		if i.Flags&net.FlagUp != 0 && len(i.HardwareAddr) > 0 {
			// BUG-001: format MAC as dash-separated uppercase (PowerShell
			// Get-NetAdapter MacAddress format), not colon-lowercase (Go
			// net.HardwareAddr.String() default).
			return formatMACPowerShell(i.HardwareAddr), nil
		}
	}
	return "", fmt.Errorf("no non-virtual MAC address found")
}

// formatMACPowerShell renders a hardware address in the format
// PowerShell Get-NetAdapter uses for MacAddress: dash-separated uppercase hex.
// Example: net.HardwareAddr{0x00,0xff,0x96,0x9c,0x83,0xa5} -> "00-FF-96-9C-83-A5".
func formatMACPowerShell(h net.HardwareAddr) string {
	parts := make([]string, len(h))
	for i, b := range h {
		parts[i] = fmt.Sprintf("%02X", b)
	}
	return strings.Join(parts, "-")
}

func firstNonHeader(s string) string {
	for _, line := range strings.Split(strings.ReplaceAll(s, "\r", ""), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.EqualFold(line, "ProcessorId") || strings.EqualFold(line, "SerialNumber") {
			continue
		}
		return line
	}
	return ""
}
