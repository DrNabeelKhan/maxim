# Maxim License API — Deploy Checklist

**Scope:** Sprint 3b Phase 2 pre-deploy preparation for the Cloudflare Worker at `mxm-license-api`.
**Audience:** operator (DrNabeelKhan) deploying after the LemonSqueezy account approval email arrives.
**Version:** v0.1.0-alpha.1 · **Date:** 2026-04-20 · **Related:** ADR-005 Layer 4, Sprint 3b Phase 2.

---

## 1. Scope

This checklist enumerates every step required to move the Cloudflare Worker from the current pre-deploy state to a running production endpoint that accepts LemonSqueezy webhooks and issues RS256 JWT licenses. Two steps block on LemonSqueezy approval. Everything else is completed or can be run on demand.

Do not treat this file as narrative. Work top to bottom. Check each box as the step completes. Stop at any failure; diagnose before proceeding.

---

## 2. Completed (ready now)

- [x] **RSA-4096 JWT keypair generated.**
  `cloudflare-worker/secrets/jwt-private.pem` (3324 B). `cloudflare-worker/secrets/jwt-public.pem` (814 B). Verified 4096-bit. Gitignored via `secrets/` entry in `cloudflare-worker/.gitignore` (confirmed with `git check-ignore`).
- [x] **ADMIN_API_KEY generated.**
  `cloudflare-worker/secrets/admin-key.txt` contains 64 hex chars (`openssl rand -hex 32`). Gitignored.
- [x] **Worker dependencies installed.**
  `npm install` produced 136 packages. 7 advisories (6 moderate, 1 high) reported by npm audit; no automatic fix applied because `npm audit fix --force` would introduce breaking changes. Review before production deploy.
- [x] **Public key embedded in pack-engine.**
  `pack-engine/internal/jwt/keys/public.pem` committed to `maxim` repo (release/v1.0.0, commit `cbb8059`). `validate.go` uses `//go:embed` with an `MXM_PACK_PUBKEY` env-var override for key-rotation drills.
- [x] **BUG-001 resolved.**
  Fingerprint parity verified on NK-ZBook: `mxm-pack-engine.exe -fingerprint` equals `owner-NK-ZBook.meta.json` fingerprint field (`43c690c45cf733ef...e2`). Regression tests pass. Commit: `maxim@09e0d80`.
- [x] **Webhook signature verification in place.**
  `src/index.ts` already implements HMAC-SHA256 verification with constant-time comparison against `LEMONSQUEEZY_WEBHOOK_SECRET`. No code change required before deploy.

---

## 3. BLOCKED on LemonSqueezy approval

Two secrets must come from the LemonSqueezy dashboard once the account is approved. Deploy cannot complete without them.

### 3.1 LEMONSQUEEZY_API_KEY

- **Source:** LemonSqueezy dashboard → Settings → API → Create API Key.
- **Scope required:** read + write on `orders`, `subscriptions`, `webhooks` for the `maxim` store.
- **Storage:** Cloudflare Worker secret.
- **Command after retrieval:**
  ```bash
  wrangler secret put LEMONSQUEEZY_API_KEY
  # paste key when prompted, press ENTER
  ```

### 3.2 LEMONSQUEEZY_WEBHOOK_SECRET

- **Source:** LemonSqueezy dashboard → Settings → Webhooks → New Webhook. The signing secret is shown **once** at webhook creation.
- **Webhook URL:** `https://license.isystematic.com/webhook/lemonsqueezy` (after custom domain) or `https://mxm-license-api.<account>.workers.dev/webhook/lemonsqueezy` (during .workers.dev testing).
- **Events to subscribe:** `order_created`, `subscription_created`, `subscription_updated`, `subscription_cancelled`, `subscription_expired`.
- **Storage:** Cloudflare Worker secret.
- **Command after retrieval:**
  ```bash
  wrangler secret put LEMONSQUEEZY_WEBHOOK_SECRET
  # paste signing secret when prompted, press ENTER
  ```

---

## 4. Remaining wrangler commands (run in this order after the two secrets above)

Working directory: `E:\Projects\Maxim\mxm-packs-source\cloudflare-worker\`

1. **Authenticate wrangler.**
   ```bash
   npx wrangler login
   ```
2. **Create the KV namespace for license records.**
   ```bash
   npx wrangler kv namespace create LICENSES
   ```
   Copy the returned `id`, uncomment the `[[kv_namespaces]]` block in `wrangler.toml`, paste the id into the `id =` field.
3. **Install the JWT keypair and admin key as Worker secrets.**
   ```bash
   cat secrets/jwt-private.pem | npx wrangler secret put JWT_SIGNING_KEY_PRIVATE
   cat secrets/jwt-public.pem  | npx wrangler secret put JWT_SIGNING_KEY_PUBLIC
   cat secrets/admin-key.txt   | npx wrangler secret put ADMIN_API_KEY
   ```
4. **Install the owner public key allow-list.**
   ```bash
   # Build a JSON array of base64-encoded owner .pub files. Example:
   NK_PUB=$(base64 -w 0 ../build/owner-keys/owner-NK-ZBook.pub)
   echo "[\"$NK_PUB\"]" | npx wrangler secret put OWNER_PUBLIC_KEYS_JSON
   ```
5. **Install the two LemonSqueezy secrets from § 3.**
6. **First deploy.**
   ```bash
   npx wrangler deploy
   ```
   Record the returned `.workers.dev` URL for webhook configuration.
7. **Custom domain (optional, recommended).**
   Cloudflare dashboard → Workers & Pages → mxm-license-api → Triggers → Add Custom Domain → `license.isystematic.com`. Then uncomment the `[[routes]]` block in `wrangler.toml` and redeploy.
8. **Wire the LemonSqueezy webhook** as described in § 3.2 using the deployed URL from step 6 or 7.

---

## 5. Smoke tests (post-deploy)

Run each curl. Each must return the expected shape before accepting a real LemonSqueezy webhook.

1. **Health.**
   ```bash
   curl https://license.isystematic.com/health
   # -> {"status":"ok","service":"mxm-license-api","version":"0.1.0-alpha.1"}
   ```
2. **Public key.** Verify the returned PEM matches `cloudflare-worker/secrets/jwt-public.pem` byte-for-byte.
   ```bash
   diff <(curl -s https://license.isystematic.com/public-key) secrets/jwt-public.pem
   ```
3. **Manual license issuance.** Replace `$ADMIN_API_KEY` with the contents of `secrets/admin-key.txt`.
   ```bash
   curl -X POST https://license.isystematic.com/license/issue \
     -H "Authorization: Bearer $ADMIN_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","product_id":"L1.1","grants":["ai-governance"],"billing":"monthly","order_id":"test-001"}'
   # -> {"jwt":"eyJhbGciOiJSUzI1NiIs..."}
   ```
4. **End-to-end $1 test.** In LemonSqueezy, create a one-time $1 USD product, fire a checkout, confirm `/webhook/lemonsqueezy` receives it, license JWT lands in KV, customer email receives the JWT.
5. **Local JWT verification.** Take the JWT from step 3 or 4 and validate with pack-engine:
   ```bash
   mxm-pack-engine.exe --validate-jwt "$JWT"
   # -> "license valid (sub=... packs=...)"
   ```

---

## 6. Rollback

If any smoke test fails:

```bash
npx wrangler rollback
```

This reverts to the immediately prior deploy. Inspect logs with `npx wrangler tail`. Rotate keys only if the private key is suspected leaked; key rotation requires regenerating both `secrets/jwt-private.pem` and `pack-engine/internal/jwt/keys/public.pem`, re-embedding, and redeploying pack-engine alongside the Worker.

---

## 7. Done-when

This checklist is complete when all of these hold:

- Every box in § 2 remains checked
- Both boxes in § 3 checked with secrets installed
- All eight commands in § 4 executed without error
- All five smoke tests in § 5 pass
- `npx wrangler tail` shows no unexpected error logs over a 24-hour soak
- The first real LemonSqueezy order (canary $1 transaction) fires the webhook and produces a valid JWT

Version this file when material changes to the deploy contract ship. Keep the version header in § 1 in lock-step with `package.json` → `version`.
