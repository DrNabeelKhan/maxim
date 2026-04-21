// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

// mxm-pack-engine — Maxim commercial pack runtime (v1.0.0, ADR-005)
//
// Decrypts encrypted pack content (.md.enc AES-256-GCM) given a valid JWT
// license, with owner-key bypass for machine-bound OWNER-1 keys.
//
// Minimal-viable binary per pre-approval A (Go over Rust). Cloudflare Worker
// JWT issuer URL stubbed — full integration in Phase B.
package main

import (
	"flag"
	"fmt"
	"io"
	"os"

	"github.com/DrNabeelKhan/mxm-pack-engine/internal/decrypt"
	"github.com/DrNabeelKhan/mxm-pack-engine/internal/jwt"
	"github.com/DrNabeelKhan/mxm-pack-engine/internal/machine"
	"github.com/DrNabeelKhan/mxm-pack-engine/internal/owner"
)

const version = "0.1.0-alpha.1"

func main() {
	var (
		showVer     = flag.Bool("version", false, "print version and exit")
		decryptFile = flag.String("decrypt", "", "decrypt .md.enc file to stdout")
		token       = flag.String("token", "", "JWT license token (or env MXM_LICENSE)")
		validateJWT = flag.Bool("validate-jwt", false, "validate JWT license only")
		fingerprint = flag.Bool("fingerprint", false, "print machine fingerprint sha256")
	)
	flag.Parse()

	if *showVer {
		fmt.Printf("mxm-pack-engine %s\n", version)
		return
	}

	if *fingerprint {
		fp, err := machine.Fingerprint()
		if err != nil {
			fail("fingerprint: %v", err)
		}
		fmt.Println(fp)
		return
	}

	licenseToken := *token
	if licenseToken == "" {
		licenseToken = os.Getenv("MXM_LICENSE")
	}

	// Owner key bypass first (OWNER-1 machine-bound)
	if owner.HasOwnerKey() {
		fmt.Fprintln(os.Stderr, "mxm-pack-engine: owner key present — license checks bypassed")
	} else if *validateJWT || *decryptFile != "" {
		if licenseToken == "" {
			fail("no --token or MXM_LICENSE set (and no owner key)")
		}
		claims, err := jwt.Validate(licenseToken)
		if err != nil {
			fail("jwt validate: %v", err)
		}
		fmt.Fprintf(os.Stderr, "mxm-pack-engine: license valid (sub=%s packs=%v)\n", claims.Subject, claims.Packs)
	}

	if *validateJWT {
		return
	}

	if *decryptFile != "" {
		packKey, err := decrypt.ResolveKey(*decryptFile, licenseToken)
		if err != nil {
			fail("key resolve: %v", err)
		}
		plain, err := decrypt.File(*decryptFile, packKey)
		if err != nil {
			fail("decrypt: %v", err)
		}
		_, _ = io.Copy(os.Stdout, plain)
		return
	}

	flag.Usage()
}

func fail(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "mxm-pack-engine error: "+format+"\n", args...)
	os.Exit(1)
}
