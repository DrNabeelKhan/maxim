// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Regression tests for BUG-001: fingerprint parity between pack-engine and
// the PowerShell keygen (bootstrap/mxm-owner-keygen-bootstrap.ps1).
//
// See BUG_TRACKER.md § BUG-001 for root-cause analysis and fix contract.
package machine

import (
	"encoding/json"
	"net"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
)

// TestBug001FingerprintParity verifies pack-engine's Fingerprint() produces
// the same hash as the PowerShell keygen stored in ~/.mxm-packs/owner-*.meta.json
// on this machine. Skips on non-Windows or when the meta file is absent.
//
// This test pins the BUG-001 fix: disk PHYSICALDRIVE0 filter + virtual-MAC
// exclusion + InterfaceIndex-descending sort + dash-uppercase MAC format.
func TestBug001FingerprintParity(t *testing.T) {
	if runtime.GOOS != "windows" {
		t.Skip("BUG-001 parity test targets Windows keygen heuristics; skipping")
	}

	home, err := os.UserHomeDir()
	if err != nil {
		t.Skipf("cannot resolve home dir: %v", err)
	}
	metaDir := filepath.Join(home, ".mxm-packs")
	entries, err := os.ReadDir(metaDir)
	if err != nil {
		t.Skipf("no ~/.mxm-packs directory (%v); keygen has not run on this machine", err)
	}

	var metaPath string
	for _, e := range entries {
		name := e.Name()
		if strings.HasPrefix(name, "owner-") && strings.HasSuffix(name, ".meta.json") {
			metaPath = filepath.Join(metaDir, name)
			break
		}
	}
	if metaPath == "" {
		t.Skip("no owner-*.meta.json found; keygen has not run on this machine")
	}

	raw, err := os.ReadFile(metaPath)
	if err != nil {
		t.Fatalf("read %s: %v", metaPath, err)
	}
	var meta struct {
		Fingerprint string `json:"fingerprint"`
		Machine     string `json:"machine"`
	}
	if err := json.Unmarshal(raw, &meta); err != nil {
		t.Fatalf("parse %s: %v", metaPath, err)
	}
	if meta.Fingerprint == "" {
		t.Fatalf("%s has empty fingerprint field", metaPath)
	}

	got, err := Fingerprint()
	if err != nil {
		t.Fatalf("Fingerprint() error: %v", err)
	}
	if got != meta.Fingerprint {
		cpu, disk, mac := FingerprintComponents()
		t.Fatalf("BUG-001 regression — fingerprint drift on machine %q\n"+
			"  want (from %s): %s\n"+
			"  got (pack-engine): %s\n"+
			"  components: cpu=%q disk=%q mac=%q",
			meta.Machine, metaPath, meta.Fingerprint, got, cpu, disk, mac)
	}
}

// TestVirtualAdapterFiltering asserts the IsVirtualAdapter filter excludes
// every documented virtual-adapter name pattern from BUG-001 and leaves
// physical-adapter names untouched.
func TestVirtualAdapterFiltering(t *testing.T) {
	shouldExclude := []string{
		"vEthernet (Default Switch)",
		"vEthernet (WSL)",
		"Virtual Ethernet Adapter",
		"VMware Network Adapter VMnet1",
		"vmware Host-Only",
		"Docker NAT",
		"DockerNAT",
		"VirtualBox Host-Only Network",
		"vboxnet0",
		"Tailscale",
		"Hyper-V Virtual Ethernet Adapter",
		"WSL (Hyper-V firewall)",
	}
	for _, name := range shouldExclude {
		if !IsVirtualAdapter(name) {
			t.Errorf("IsVirtualAdapter(%q) = false; expected true", name)
		}
	}

	shouldAllow := []string{
		"Ethernet",
		"Ethernet 2",
		"Wi-Fi",
		"Local Area Connection",
		"en0",
		"eth0",
	}
	for _, name := range shouldAllow {
		if IsVirtualAdapter(name) {
			t.Errorf("IsVirtualAdapter(%q) = true; expected false", name)
		}
	}
}

// TestFormatMACPowerShell asserts the dash-uppercase MAC format matches
// PowerShell Get-NetAdapter MacAddress output.
func TestFormatMACPowerShell(t *testing.T) {
	cases := []struct {
		in   net.HardwareAddr
		want string
	}{
		{net.HardwareAddr{0x00, 0xff, 0x96, 0x9c, 0x83, 0xa5}, "00-FF-96-9C-83-A5"},
		{net.HardwareAddr{0x58, 0x20, 0xb1, 0x41, 0x96, 0x96}, "58-20-B1-41-96-96"},
		{net.HardwareAddr{0xde, 0xad, 0xbe, 0xef, 0x00, 0x01}, "DE-AD-BE-EF-00-01"},
	}
	for _, c := range cases {
		got := formatMACPowerShell(c.in)
		if got != c.want {
			t.Errorf("formatMACPowerShell(%v) = %q; want %q", c.in, got, c.want)
		}
	}
}
