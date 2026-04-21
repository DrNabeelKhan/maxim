// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Package decrypt implements AES-256-GCM pack content decryption (v1.0.0, ADR-005).
//
// Input: .md.enc file with layout:
//   [12 bytes nonce][N bytes ciphertext][16 bytes GCM tag]
// Key: 32 bytes derived from the pack's build-time encryption key (rotated per
// release per IP-Q7).
package decrypt

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"errors"
	"fmt"
	"io"
	"os"
)

const nonceSize = 12

// File decrypts a .md.enc file using the given 32-byte key and returns an
// io.Reader over the plaintext.
func File(path string, key []byte) (io.Reader, error) {
	if len(key) != 32 {
		return nil, fmt.Errorf("key must be 32 bytes, got %d", len(key))
	}
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	if len(data) < nonceSize+16 {
		return nil, errors.New("ciphertext too short")
	}
	nonce, ct := data[:nonceSize], data[nonceSize:]

	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}
	plain, err := gcm.Open(nil, nonce, ct, nil)
	if err != nil {
		return nil, fmt.Errorf("auth failed: %w", err)
	}
	return bytes.NewReader(plain), nil
}

// ResolveKey returns the AES-256 key for decrypting the pack at path.
// Phase A stub: returns a zero-key placeholder so compilation succeeds; Phase B
// wires to LemonSqueezy JWT → Cloudflare Worker key issuance.
func ResolveKey(path, licenseToken string) ([]byte, error) {
	// TODO(Phase B): derive key from licenseToken via Cloudflare Worker.
	// For Phase A scaffold: return deterministic zero key + warn.
	fmt.Fprintln(os.Stderr, "WARN: decrypt.ResolveKey is a Phase A stub — Phase B wires the real KMS path")
	return make([]byte, 32), nil
}
