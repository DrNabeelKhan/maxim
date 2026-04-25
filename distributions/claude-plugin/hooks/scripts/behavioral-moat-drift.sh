#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# behavioral-moat-drift — ADR-007 pre-commit checker (v1.0.0)
#
# Checks every staged .claude/skills/**/SKILL.md for the 7 required sections:
#   1. YAML frontmatter: business_outcome + primary_framework
#   2. ## The Maxim Moat
#   3. ## Business Outcome
#   4. ## Primary Behavioral Framework
#   5. ## Behavioral → [Domain] Translation
#   6. ## Anti-Patterns
#   7. ## Pack Integrations
#
# Policy (v1.0.0 → v6.5.0):
#   - NEW skills (created this commit): ALL 7 required — fail on missing.
#   - MODIFIED existing skills: warn on missing; do not block until v6.5.0.

set -u

errors=0
warnings=0

staged=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null | grep -E '^\.claude/skills/.*SKILL\.md$' || true)

if [ -z "$staged" ]; then
  exit 0
fi

check_section() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! git show ":$file" 2>/dev/null | grep -qE "$pattern"; then
    echo "  MISSING: $label"
    return 1
  fi
  return 0
}

while IFS= read -r file; do
  [ -z "$file" ] && continue
  is_new="no"
  if git diff --cached --name-status --diff-filter=A 2>/dev/null | grep -q "	$file\$"; then
    is_new="yes"
  fi

  missing=0
  echo "Checking: $file ($( [ "$is_new" = "yes" ] && echo NEW || echo MODIFIED ))"
  check_section "$file" "^business_outcome:" "frontmatter business_outcome" || missing=$((missing + 1))
  check_section "$file" "^primary_framework:" "frontmatter primary_framework" || missing=$((missing + 1))
  check_section "$file" "^##[[:space:]]+The Maxim Moat" "## The Maxim Moat" || missing=$((missing + 1))
  check_section "$file" "^##[[:space:]]+Business Outcome" "## Business Outcome" || missing=$((missing + 1))
  check_section "$file" "^##[[:space:]]+Primary Behavioral Framework" "## Primary Behavioral Framework" || missing=$((missing + 1))
  check_section "$file" "^##[[:space:]]+Behavioral" "## Behavioral → ... Translation" || missing=$((missing + 1))
  check_section "$file" "^##[[:space:]]+Anti-Patterns" "## Anti-Patterns" || missing=$((missing + 1))
  check_section "$file" "^##[[:space:]]+Pack Integrations" "## Pack Integrations" || missing=$((missing + 1))

  if [ "$missing" -gt 0 ]; then
    if [ "$is_new" = "yes" ]; then
      echo "  FAIL: $missing section(s) missing in NEW skill (ADR-007)."
      errors=$((errors + 1))
    else
      echo "  WARN: $missing section(s) missing (existing skill — warn until v6.5.0)."
      warnings=$((warnings + 1))
    fi
  fi
done <<< "$staged"

echo ""
echo "behavioral-moat-drift: errors=$errors warnings=$warnings"

if [ "$errors" -gt 0 ]; then
  echo "Commit blocked: new skills must carry all 7 sections (ADR-007)."
  exit 1
fi
exit 0
