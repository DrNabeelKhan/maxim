// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Package owner checks for the OWNER-1 machine-bound RSA key that bypasses
// all license checks on DrNabeelKhan's owned machines (ADR-005, OB-7).
//
// Lookup order:
//   1. $MXM_OWNER_KEY env var
//   2. ~/.mxm-packs/owner.key
//
// If a valid OWNER-1 key exists AND its embedded machine fingerprint matches
// the current host, license checks are skipped entirely.
package owner

import (
	"os"
	"path/filepath"
)

// HasOwnerKey returns true if a readable owner.key exists via either lookup
// path. Phase A scaffold: does not yet verify RSA signature or fingerprint
// match — Phase B completes that. Presence alone triggers bypass for now.
func HasOwnerKey() bool {
	if p := os.Getenv("MXM_OWNER_KEY"); p != "" {
		if _, err := os.Stat(p); err == nil {
			return true
		}
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return false
	}
	candidate := filepath.Join(home, ".mxm-packs", "owner.key")
	_, err = os.Stat(candidate)
	return err == nil
}
