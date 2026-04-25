#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-guard — external-boundary-drift pre-commit checker (v1.0.0, ADR-006)
#
# Fails if any staged files:
#   1. Live outside community-packs/ but reference external/ as a live path
#   2. Reintroduce external/ directory
#   3. Reintroduce composable-skills/superpowers/ or planning-with-files/
#   4. Reintroduce agents/voltagent/
#
# Exempt: CHANGELOG.md, documents/releases/, documents/ADRs/, .mxm-skills/archive/,
#         mcp/mxm-behavioral/server.js (Hook Model "Trigger (external/internal)").

set -u

violations=0
staged=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null)

if [ -z "$staged" ]; then
  exit 0
fi

# Check 1: external/ directory reintroduction
if echo "$staged" | grep -qE "^external/"; then
  echo "Maxim Guard FAIL: external/ directory is removed (ADR-006). Move to community-packs/ or a private repo."
  violations=$((violations + 1))
fi

# Check 2: composable-skills third-party reintroduction
if echo "$staged" | grep -qE "^composable-skills/(superpowers|planning-with-files)/"; then
  echo "Maxim Guard FAIL: composable-skills/{superpowers,planning-with-files}/ removed in v1.0.0 (ADR-008). Install via community pack."
  violations=$((violations + 1))
fi

# Check 3: agents/voltagent/ reintroduction
if echo "$staged" | grep -qE "^agents/voltagent/"; then
  echo "Maxim Guard FAIL: agents/voltagent/ removed in v1.0.0. Install via community-packs/voltagent-subagents/."
  violations=$((violations + 1))
fi

# Check 4: live external/ path refs in staged content (exempt list)
while IFS= read -r file; do
  [ -z "$file" ] && continue
  case "$file" in
    CHANGELOG.md) continue ;;
    documents/releases/*) continue ;;
    documents/ADRs/*) continue ;;
    .mxm-skills/archive/*) continue ;;
    mcp/mxm-behavioral/server.js) continue ;;
  esac
  if git show ":$file" 2>/dev/null | grep -qE "\bexternal/"; then
    echo "Maxim Guard FAIL: $file contains live 'external/' path reference. Use 'community-packs/' or add to exempt list."
    violations=$((violations + 1))
  fi
done <<< "$staged"

if [ "$violations" -gt 0 ]; then
  echo ""
  echo "Maxim Guard: $violations violation(s) — commit blocked."
  echo "Reference: documents/ADRs/ADR-006-external-content-boundary-rule.md"
  exit 1
fi

exit 0
