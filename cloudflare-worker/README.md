# Maxim License API — Cloudflare Worker

> **Issues RS256 JWT pack licenses on LemonSqueezy purchase webhooks.**
> **Per ADR-005 Layer 4 (Machine binding + License validation).**
> **Status:** Scaffold (2026-04-20) — deploy-ready once LemonSqueezy webhook secret + JWT RSA keypair exist.

---

## Architecture

```
  LemonSqueezy checkout (customer buys Pack L1.X)
          │
          ▼
  order_created webhook → POST /webhook/lemonsqueezy
          │
          │ 1. Verify HMAC-SHA256 signature (LEMONSQUEEZY_WEBHOOK_SECRET)
          │ 2. Extract variant_id from payload
          │ 3. Look up variant_id → product_id + grants in VARIANT_MAP
          │ 4. Sign RS256 JWT (JWT_SIGNING_KEY_PRIVATE) with claims:
          │    { product_id, grants, billing, order_id, machine_fingerprint?, mxm_version_min, sub, iss, aud, exp }
          │ 5. Store license record in KV (LICENSES namespace)
          │ 6. Return JWT (or email via LemonSqueezy API in production)
          ▼
  Customer receives license JWT
          │
          ▼
  pack-engine (local on customer machine) validates:
          ├─ Verify JWT with public key from GET /public-key
          ├─ Check machine_fingerprint binds on first use
          ├─ Allow decryption of .md.enc pack artifacts
          └─ Silent canary check per ADR-005 Layer 3
```

---

## Endpoints

| Method | Path | Purpose | Auth |
|---|---|---|---|
| GET | `/health` | Health check | None |
| GET | `/public-key` | Returns JWT public key PEM (for pack-engine to verify) | None |
| POST | `/webhook/lemonsqueezy` | LemonSqueezy purchase webhook | HMAC signature |
| POST | `/license/issue` | Manual license issuance (admin) | Bearer ADMIN_API_KEY |
| POST | `/license/validate` | Optional remote JWT validation | None |
| POST | `/license/revoke` | Revoke a license | Bearer ADMIN_API_KEY |

---

## Deployment — one-time setup

### Prerequisites

- Cloudflare account (ID: `06fb1f612b22d6bdac1cb2155970c391`)
- `wrangler` CLI installed: `npm i -g wrangler`
- `wrangler login` (interactive browser auth)
- Custom domain `license.isystematic.com` DNS controllable in Cloudflare (you confirmed Cloudflare DNS)
- LemonSqueezy store approved (pending — check email for approval)
- Node.js 20+

### Step 1 — Generate JWT signing keypair

```bash
cd E:\Projects\Maxim\mxm-packs-source\cloudflare-worker
mkdir -p secrets
openssl genrsa -out secrets/jwt-private.pem 4096
openssl rsa -in secrets/jwt-private.pem -pubout -out secrets/jwt-public.pem
# IMPORTANT: secrets/ is gitignored. These files NEVER get committed.
```

### Step 2 — Install dependencies

```bash
npm install
```

### Step 3 — Create KV namespace

```bash
wrangler kv namespace create LICENSES
# Copy the returned id, paste into wrangler.toml under [[kv_namespaces]]
```

Edit `wrangler.toml`, uncomment `[[kv_namespaces]]` block, paste the namespace id.

### Step 4 — Set secrets

Each secret goes into Cloudflare via `wrangler secret put`, not into code:

```bash
# LemonSqueezy API key (Settings → API → Create API Key)
wrangler secret put LEMONSQUEEZY_API_KEY
# paste when prompted, ENTER

# LemonSqueezy webhook secret (Settings → Webhooks → create webhook → signing secret shown ONCE)
wrangler secret put LEMONSQUEEZY_WEBHOOK_SECRET

# JWT private key (contents of secrets/jwt-private.pem)
cat secrets/jwt-private.pem | wrangler secret put JWT_SIGNING_KEY_PRIVATE

# JWT public key (contents of secrets/jwt-public.pem)
cat secrets/jwt-public.pem | wrangler secret put JWT_SIGNING_KEY_PUBLIC

# Admin API key (generate a random 32-byte token)
openssl rand -hex 32 | wrangler secret put ADMIN_API_KEY

# Owner public keys JSON array (copy from build/owner-keys/*.pub, one element per machine)
cat <<EOF | wrangler secret put OWNER_PUBLIC_KEYS_JSON
["$(cat ../build/owner-keys/owner-NK-ZBook.pub | base64 -w 0)", "$(cat ../build/owner-keys/owner-MacBook-Pro.pub | base64 -w 0)"]
EOF
```

### Step 5 — First deploy

```bash
wrangler deploy
# → Worker URL: https://mxm-license-api.isystematic.workers.dev
```

### Step 6 — Configure custom domain (optional but recommended)

In Cloudflare dashboard:
1. Workers & Pages → mxm-license-api → Triggers → Add Custom Domain
2. Domain: `license.isystematic.com`
3. DNS auto-configures (Cloudflare nameservers)

Uncomment the `[[routes]]` block in `wrangler.toml` and redeploy.

### Step 7 — Configure LemonSqueezy webhook

In LemonSqueezy dashboard (once store approved):
1. Settings → Webhooks → Create
2. URL: `https://license.isystematic.com/webhook/lemonsqueezy` (or the `.workers.dev` URL)
3. Events: `order_created`, `subscription_created`, `subscription_updated`, `subscription_cancelled`, `subscription_expired`
4. Signing secret: copy and run `wrangler secret put LEMONSQUEEZY_WEBHOOK_SECRET`

### Step 8 — Smoke test

```bash
# Health check
curl https://license.isystematic.com/health
# Expected: {"status":"ok","service":"mxm-license-api","version":"0.1.0-alpha.1"}

# Public key
curl https://license.isystematic.com/public-key
# Expected: -----BEGIN PUBLIC KEY----- ... -----END PUBLIC KEY-----

# Manual license issuance (replace ADMIN_API_KEY)
curl -X POST https://license.isystematic.com/license/issue \
  -H "Authorization: Bearer $ADMIN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","product_id":"L1.1","grants":["ai-governance"],"billing":"monthly","order_id":"test-001"}'
# Expected: {"jwt":"eyJ..."}
```

---

## Integration with pack-engine

After deploy:
1. Copy `secrets/jwt-public.pem` contents into pack-engine embed or config
2. pack-engine validates incoming JWTs against this public key
3. pack-engine's machine_fingerprint is compared against JWT claim (bound on first use per ADR-005)

See `pack-engine/internal/jwt/validate.go` for the validator implementation.

---

## Environment matrix

| Environment | Worker URL | Trigger |
|---|---|---|
| Dev | `wrangler dev` → http://localhost:8787 | Local testing |
| Staging | `wrangler deploy --env staging` | Pre-prod smoke tests |
| Production | `wrangler deploy` | Live — receives real LemonSqueezy webhooks |

---

## Monitoring

- `wrangler tail` — live log tailing
- Cloudflare dashboard → Workers → mxm-license-api → Analytics
- KV namespace browser → see issued licenses
- Rate limits: Cloudflare default is 100,000 req/day on free tier; upgrade to Workers Paid if needed

---

## Known issues

- _(none open — BUG-001 resolved in maxim commit `09e0d80` on 2026-04-20; pack-engine fingerprint now matches keygen. See `DEPLOY_CHECKLIST.md` for pre-deploy status.)_

---

## References

- ADR-005: IP Protection 5-Layer Architecture (this Worker = Layer 4 License Validation)
- ADR-009: Pack Architecture v2 — variant ID mapping source of truth
- `config/lemonsqueezy-variant-map.json` — machine-readable variant → capability map (kept in sync with `src/index.ts VARIANT_MAP`)
- LemonSqueezy API docs: https://docs.lemonsqueezy.com/api/webhooks
- Cloudflare Workers: https://developers.cloudflare.com/workers/
