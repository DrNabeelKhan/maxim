#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim — PreCommit Hook (Bash)
# =============================================================================
# Fires before any git commit (when symlinked or copied to .git/hooks/pre-commit).
# Implements compliance checks at the developer workflow layer:
#   1. Block commits that contain hardcoded secrets (API keys, tokens, passwords)
#   2. Warn on PII patterns (emails, SSNs, credit card numbers) in staged code
#   3. Block commits that touch files outside the project (junction safety)
#   4. Append every scan to .mxm-skills/compliance-audit.jsonl (audit trail)
#
# Bypass with: git commit --no-verify (NOT recommended — leaves audit gap)
#
# Exit codes:
#   0 = pass (commit allowed)
#   1 = block (commit refused; reason printed to stderr)
# =============================================================================

set -uo pipefail

find_project_root() {
  local dir="$PWD"
  for _ in 1 2 3 4; do
    if [ -f "$dir/config/project-manifest.json" ]; then
      echo "$dir"
      return 0
    fi
    [ "$dir" = "/" ] && break
    dir="$(dirname "$dir")"
  done
  echo "$PWD"
}

PROJECT_ROOT="$(find_project_root)"
cd "$PROJECT_ROOT" || exit 0

NOW_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
AUDIT_LOG=".mxm-skills/compliance-audit.jsonl"
mkdir -p .mxm-skills 2>/dev/null

VIOLATIONS=0
WARNINGS=0
REPORT=""

# ----- Get list of staged files (added or modified, not deleted) -----
STAGED_FILES="$(git diff --cached --name-only --diff-filter=AM 2>/dev/null)"
if [ -z "$STAGED_FILES" ]; then
  exit 0
fi

# ----- Secret detection patterns (block) -----
# These are high-confidence patterns. Tuned to minimize false positives.
SECRET_PATTERNS=(
  'AKIA[0-9A-Z]{16}'                                                    # AWS Access Key
  'aws_secret_access_key\s*=\s*["\047][A-Za-z0-9/+=]{40}["\047]'        # AWS Secret
  'sk-[a-zA-Z0-9]{32,}'                                                 # OpenAI / Stripe-style
  'sk-ant-[a-zA-Z0-9_-]{32,}'                                           # Anthropic API key
  'ghp_[A-Za-z0-9]{36}'                                                 # GitHub PAT
  'gho_[A-Za-z0-9]{36}'                                                 # GitHub OAuth
  'glpat-[A-Za-z0-9_-]{20}'                                             # GitLab PAT
  '-----BEGIN (RSA |EC |DSA |OPENSSH |)PRIVATE KEY-----'                # Private keys
  'xox[baprs]-[A-Za-z0-9-]{10,}'                                        # Slack tokens
)

# ----- PII detection patterns (warn, don't block) -----
# Skip files that are .env.example, README, docs, or test fixtures
PII_PATTERNS=(
  '\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b'                                     # SSN format
  '\b4[0-9]{12}(?:[0-9]{3})?\b'                                        # Visa-format CC
  '\b5[1-5][0-9]{14}\b'                                                # MasterCard-format CC
)

while IFS= read -r file; do
  [ -z "$file" ] && continue
  [ ! -f "$file" ] && continue

  # Skip binary files (>1MB or non-text per file extension blacklist)
  case "$file" in
    *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.zip|*.tar|*.gz|*.exe|*.dll|*.so|*.dylib|*.ico|*.woff*|*.ttf|*.eot|*.mp4|*.mp3|*.wav)
      continue ;;
  esac

  CONTENT="$(git diff --cached "$file" 2>/dev/null)"
  [ -z "$CONTENT" ] && continue

  # Check secrets (always blocking)
  for pattern in "${SECRET_PATTERNS[@]}"; do
    if echo "$CONTENT" | grep -qE "$pattern"; then
      VIOLATIONS=$((VIOLATIONS + 1))
      MATCHED_PATTERN_DESC="$(echo "$pattern" | head -c 30)..."
      REPORT="${REPORT}🔴 BLOCK: ${file} — secret pattern detected (${MATCHED_PATTERN_DESC})\n"
      echo "{\"timestamp\":\"$NOW_ISO\",\"file\":\"$file\",\"violation\":\"secret_exposure\",\"action\":\"blocked\"}" >> "$AUDIT_LOG"
    fi
  done

  # Check PII (warning only — skip example/docs)
  case "$file" in
    *.env.example|*README*|documents/*|tests/*|*test*|*fixture*) ;;
    *)
      for pattern in "${PII_PATTERNS[@]}"; do
        if echo "$CONTENT" | grep -qE "$pattern"; then
          WARNINGS=$((WARNINGS + 1))
          REPORT="${REPORT}🟡 WARN: ${file} — possible PII pattern\n"
          echo "{\"timestamp\":\"$NOW_ISO\",\"file\":\"$file\",\"violation\":\"pii_pattern\",\"action\":\"warned\"}" >> "$AUDIT_LOG"
        fi
      done
      ;;
  esac
done <<< "$STAGED_FILES"

# ----- Output report -----
if [ "$VIOLATIONS" -gt 0 ] || [ "$WARNINGS" -gt 0 ]; then
  {
    echo "═══════════════════════════════════════════════════════"
    echo "Maxim PreCommit — Compliance Scan"
    echo "═══════════════════════════════════════════════════════"
    echo -e "$REPORT"
    echo "Audit log: $AUDIT_LOG"
  } >&2
fi

if [ "$VIOLATIONS" -gt 0 ]; then
  echo "🔴 Commit BLOCKED: $VIOLATIONS secret violation(s) detected." >&2
  echo "   Remove secrets from staged files or use git commit --no-verify (audit gap)." >&2
  exit 1
fi

# ----- v1.0.0: Maxim Guard + behavioral-moat-drift (ADR-006, ADR-007) -----
HOOK_DIR="$(dirname "$0")"
if [ -x "$HOOK_DIR/mxm-guard.sh" ]; then
  if ! bash "$HOOK_DIR/mxm-guard.sh"; then
    echo "🔴 Commit BLOCKED by mxm-guard (external-boundary-drift)." >&2
    exit 1
  fi
fi
if [ -x "$HOOK_DIR/behavioral-moat-drift.sh" ]; then
  if ! bash "$HOOK_DIR/behavioral-moat-drift.sh"; then
    echo "🔴 Commit BLOCKED by behavioral-moat-drift (ADR-007)." >&2
    exit 1
  fi
fi

exit 0
