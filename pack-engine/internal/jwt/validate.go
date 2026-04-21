// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// Package jwt validates Maxim pack license JWTs (RS256, ADR-005).
//
// Phase B wiring (v1.0.0 Sprint 3b): the Cloudflare Worker public key is
// embedded at build time via go:embed. The MXM_PACK_PUBKEY env var remains
// as an override path for testing and key-rotation drills.
package jwt

import (
	"crypto/rsa"
	"crypto/x509"
	_ "embed"
	"encoding/pem"
	"errors"
	"fmt"
	"os"
	"time"

	jwtlib "github.com/golang-jwt/jwt/v5"
)

// embeddedPubKey is the RSA-4096 public key for the Cloudflare Worker that
// issues Maxim license JWTs. The matching private key lives only inside the
// Worker's secret store (mxm-packs-source/cloudflare-worker/secrets/,
// gitignored). Rotate by regenerating the pair and bumping pack-engine.
//
//go:embed keys/public.pem
var embeddedPubKey string

// Claims is the pack license JWT payload.
type Claims struct {
	Subject string   `json:"sub"`
	Packs   []string `json:"packs"`
	Machine string   `json:"mch,omitempty"`
	Expires int64    `json:"exp"`
	jwtlib.RegisteredClaims
}

// Validate parses and verifies a JWT license. Returns claims on success.
func Validate(token string) (*Claims, error) {
	pub, err := loadPublicKey()
	if err != nil {
		return nil, fmt.Errorf("load public key: %w", err)
	}
	var claims Claims
	t, err := jwtlib.ParseWithClaims(token, &claims, func(t *jwtlib.Token) (any, error) {
		if _, ok := t.Method.(*jwtlib.SigningMethodRSA); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}
		return pub, nil
	})
	if err != nil {
		return nil, err
	}
	if !t.Valid {
		return nil, errors.New("token invalid")
	}
	if claims.Expires > 0 && time.Now().Unix() > claims.Expires {
		return nil, errors.New("token expired")
	}
	return &claims, nil
}

// loadPublicKey returns the RSA public key used to verify Maxim license JWTs.
// Priority: MXM_PACK_PUBKEY env var (override for testing) > embedded key.
func loadPublicKey() (*rsa.PublicKey, error) {
	pemData := os.Getenv("MXM_PACK_PUBKEY")
	if pemData == "" {
		pemData = embeddedPubKey
	}
	if pemData == "" {
		return nil, errors.New("no public key available (embedded missing and MXM_PACK_PUBKEY unset)")
	}
	block, _ := pem.Decode([]byte(pemData))
	if block == nil {
		return nil, errors.New("invalid PEM")
	}
	pub, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		return nil, err
	}
	rsaPub, ok := pub.(*rsa.PublicKey)
	if !ok {
		return nil, errors.New("key is not RSA")
	}
	return rsaPub, nil
}
