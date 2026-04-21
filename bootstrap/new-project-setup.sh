#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim New Project Setup Script
# Version: 1.1.0
# Usage:
#   bash bootstrap/new-project-setup.sh                  # interactive setup
#   bash bootstrap/new-project-setup.sh --validate-only  # validate existing setup
#   bash bootstrap/new-project-setup.sh --patch-hooks-only  # patch IDE adapters only (Option B subtree)
# =============================================================================

set -euo pipefail

# ---- Colors -----------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ---- Helpers ----------------------------------------------------------------
info()    { echo -e "${BLUE}[Maxim]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC}   $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

# ---- Mode flags -------------------------------------------------------------
VALIDATE_ONLY=false
PATCH_HOOKS_ONLY=false
if [[ "${1:-}" == "--validate-only" ]];   then VALIDATE_ONLY=true; fi
if [[ "${1:-}" == "--patch-hooks-only" ]]; then PATCH_HOOKS_ONLY=true; fi

# =============================================================================
# PATCH IDE ADAPTERS — Maxim OVERLAY
# =============================================================================
# Called after interactive setup AND available standalone via --patch-hooks-only.
# Prepends Maxim context block to user-prompt-submit.sh on all 16 adapters.
# Appends Maxim handoff check to stop.sh on all 16 adapters.
# Safe to re-run: idempotent (checks for Maxim marker before patching).
# OthmanAdi planning-with-files baseline is preserved — Maxim sits on top.
# =============================================================================
patch_ide_adapters() {
  echo ""
  info "Patching IDE adapters with Maxim overlay..."

  local MXM_MARKER="# [Maxim-OVERLAY]"

  # All 16 adapter folders
  local ADAPTERS=(
    ".adal" ".agent" ".claude-plugin" ".codebuddy" ".codex"
    ".continue" ".cursor" ".factory" ".gemini" ".github"
    ".kilocode" ".kiro" ".mastracode" ".openclaw" ".opencode" ".pi"
  )

  local patched=0
  local skipped=0
  local missing=0

  for adapter in "${ADAPTERS[@]}"; do
    local HOOKS_DIR="ide-adapters/${adapter}/hooks"
    local SUBMIT_SH="${HOOKS_DIR}/user-prompt-submit.sh"
    local STOP_SH="${HOOKS_DIR}/stop.sh"
    local SUBMIT_PS1="${HOOKS_DIR}/user-prompt-submit.ps1"
    local STOP_PS1="${HOOKS_DIR}/stop.ps1"

    # Skip if adapter hooks folder doesn't exist
    if [[ ! -d "$HOOKS_DIR" ]]; then
      ((missing++)) || true
      continue
    fi

    # --- Patch user-prompt-submit.sh (bash) ----------------------------------
    if [[ -f "$SUBMIT_SH" ]]; then
      if grep -q "$MXM_MARKER" "$SUBMIT_SH" 2>/dev/null; then
        ((skipped++)) || true
      else
        # Build Maxim block — inject after the shebang line
        local TMP_FILE
        TMP_FILE=$(mktemp)
        head -1 "$SUBMIT_SH" > "$TMP_FILE"  # preserve shebang
        cat >> "$TMP_FILE" <<'MXM_BLOCK'
# [Maxim-OVERLAY] — injected by bootstrap/new-project-setup.sh
# Maxim Layer 1-2 context injection. Do not remove this block.
# Re-run: bash bootstrap/new-project-setup.sh --patch-hooks-only

# Load project identity from manifest
if [ -f "config/project-manifest.json" ]; then
  _PROJECT_ID=$(grep -o '"id": "[^"]*"' config/project-manifest.json | head -1 | cut -d'"' -f4 2>/dev/null || echo "unknown")
  _REGULATED=$(grep -o '"regulated_projects": \[[^]]*\]' config/project-manifest.json | grep -v '\[\]' | wc -l | tr -d ' ')
  _PAYMENT=$(grep -o '"payment_projects": \[[^]]*\]' config/project-manifest.json | grep -v '\[\]' | wc -l | tr -d ' ')
  _HIPAA=$(grep -o '"hipaa_projects": \[[^]]*\]' config/project-manifest.json | grep -v '\[\]' | wc -l | tr -d ' ')
  echo "[Maxim] Project: ${_PROJECT_ID} | Model: $(grep -o '\"default_model_provider\": \"[^\"]*\"' config/project-manifest.json | cut -d'\"' -f4 2>/dev/null || echo 'anthropic')"
  [ "$_REGULATED" -gt 0 ] && echo "[Maxim] ⚠ COMPLIANCE ACTIVE — mandatory compliance loop on all agents"
  [ "$_PAYMENT" -gt 0 ]   && echo "[Maxim] ⚠ PAYMENT SCOPE — PCI-DSS checks active"
  [ "$_HIPAA" -gt 0 ]     && echo "[Maxim] ⚠ HIPAA SCOPE — PHI controls + 90% coverage threshold active"
fi

# Maxim 5-layer dispatch reminder
echo "[Maxim] Dispatch: 1) .claude/skills/ → 2) community-packs/claude-skills-library/ → 3) composable-skills/ → 4) agents/ → 5) behavioral layer"
echo "[Maxim] Maxim skills win all conflicts. Flag unenhanced output: 🔴 Maxim-UNENHANCED. Log gaps to .mxm-skills/agents-skill-gaps.log"

# Load CLAUDE.project.md reminder
if [ -f "CLAUDE.project.md" ]; then
  echo "[Maxim] CLAUDE.project.md present — load project-specific rules before proceeding."
fi

# Check active handoff state
if [ -f ".mxm-skills/agents-handoff.md" ]; then
  _HANDOFF_STATUS=$(grep -o 'status: "[^"]*"' .mxm-skills/agents-handoff.md | head -1 | cut -d'"' -f2 2>/dev/null || echo "")
  case "$_HANDOFF_STATUS" in
    BLOCKED)  echo "[Maxim] 🔴 HANDOFF BLOCKED — resolve blockers in .mxm-skills/agents-handoff.md before starting new work" ;;
    PARTIAL)  echo "[Maxim] 🟡 HANDOFF PARTIAL — incomplete task in .mxm-skills/agents-handoff.md — human decision required" ;;
    FAILED)   echo "[Maxim] 🔴 HANDOFF FAILED — escalate immediately. Do not proceed without resolution." ;;
    REVIEW_REQUIRED) echo "[Maxim] 🟡 HANDOFF REVIEW REQUIRED — human sign-off needed before next agent step" ;;
    READY|READY_WITH_NOTES) echo "[Maxim] 🟢 Handoff: ${_HANDOFF_STATUS}" ;;
  esac
fi

MXM_BLOCK
        # Append the rest of the original file (skip shebang)
        tail -n +2 "$SUBMIT_SH" >> "$TMP_FILE"
        mv "$TMP_FILE" "$SUBMIT_SH"
        chmod +x "$SUBMIT_SH"
        ((patched++)) || true
      fi
    fi

    # --- Patch stop.sh (bash) ------------------------------------------------
    if [[ -f "$STOP_SH" ]]; then
      if grep -q "$MXM_MARKER" "$STOP_SH" 2>/dev/null; then
        ((skipped++)) || true
      else
        # Append Maxim handoff check block before final exit
        cat >> "$STOP_SH" <<'MXM_STOP_BLOCK'

# [Maxim-OVERLAY] — handoff state check on stop
if [ -f ".mxm-skills/agents-handoff.md" ]; then
  _STOP_STATUS=$(grep -o 'status: "[^"]*"' .mxm-skills/agents-handoff.md | head -1 | cut -d'"' -f2 2>/dev/null || echo "")
  _TO_AGENT=$(grep -o 'to_agent: "[^"]*"' .mxm-skills/agents-handoff.md | head -1 | cut -d'"' -f2 2>/dev/null || echo "")
  _ESCALATE=$(grep -o 'required: [a-z]*' .mxm-skills/agents-handoff.md | head -1 | awk '{print $2}' 2>/dev/null || echo "false")
  if [ "$_ESCALATE" = "true" ]; then
    echo "{\"followup_message\": \"[Maxim] 🔴 ESCALATION REQUIRED — escalate_to_human is set in .mxm-skills/agents-handoff.md. Do not pass to next agent without human review.\"}"
  elif [ -n "$_STOP_STATUS" ] && [ "$_STOP_STATUS" != "READY" ] && [ "$_STOP_STATUS" != "READY_WITH_NOTES" ]; then
    echo "{\"followup_message\": \"[Maxim] Handoff status: ${_STOP_STATUS}. Check .mxm-skills/agents-handoff.md before continuing. Next agent: ${_TO_AGENT}.\"}"
  fi
fi
MXM_STOP_BLOCK
        ((patched++)) || true
      fi
    fi

    # --- Patch user-prompt-submit.ps1 (Windows) ------------------------------
    if [[ -f "$SUBMIT_PS1" ]]; then
      if grep -q "Maxim-OVERLAY" "$SUBMIT_PS1" 2>/dev/null; then
        ((skipped++)) || true
      else
        local TMP_PS1
        TMP_PS1=$(mktemp)
        cat >> "$TMP_PS1" <<'MXM_PS1_BLOCK'
# [Maxim-OVERLAY] — injected by bootstrap/new-project-setup.sh
if (Test-Path "config/project-manifest.json") {
  $manifest = Get-Content "config/project-manifest.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
  if ($manifest) {
    Write-Output "[Maxim] Project: $($manifest.project.id) | Model: $($manifest.tech_stack.default_model_provider)"
  }
}
Write-Output "[Maxim] Dispatch: 1) .claude/skills/ -> 2) community-packs/claude-skills-library/ -> 3) composable-skills/ -> 4) agents/ -> 5) behavioral layer"
if (Test-Path ".mxm-skills/agents-handoff.md") {
  $handoff = Get-Content ".mxm-skills/agents-handoff.md" -Raw
  if ($handoff -match 'status: "(BLOCKED|FAILED|PARTIAL)"') {
    Write-Output "[Maxim] !!  HANDOFF $($Matches[1]) — check .mxm-skills/agents-handoff.md before proceeding"
  }
}
MXM_PS1_BLOCK
        cat "$SUBMIT_PS1" >> "$TMP_PS1"
        mv "$TMP_PS1" "$SUBMIT_PS1"
        ((patched++)) || true
      fi
    fi

  done

  echo ""
  success "IDE adapter patching complete"
  echo "   Adapters patched : $patched hook files"
  echo "   Already patched  : $skipped (skipped — idempotent)"
  echo "   Adapters missing : $missing (no hooks/ folder — normal for some IDEs)"
  echo ""
  info "Maxim overlay active on all present adapters. Survives rsync — these are project files."
  info "Re-run anytime: bash bootstrap/new-project-setup.sh --patch-hooks-only"
}

# =============================================================================
# VALIDATE SECTION
# =============================================================================
validate() {
  echo ""
  echo -e "${BOLD}=== Maxim Setup Validation ===${NC}"
  echo ""

  local pass=0
  local warn_count=0
  local fail=0

  # 1. project-manifest.json
  if [[ -f "config/project-manifest.json" ]]; then
    success "config/project-manifest.json found"
    ((pass++))
  else
    warn "config/project-manifest.json not found. Run setup first."
    ((fail++))
  fi

  # 2. CLAUDE.project.md
  if [[ -f "CLAUDE.project.md" ]]; then
    success "CLAUDE.project.md found"
    ((pass++))
  else
    warn "CLAUDE.project.md not found."
    ((warn_count++))
  fi

  # 3. agent-registry.json
  if [[ -f "config/agent-registry.json" ]]; then
    success "config/agent-registry.json found"
    ((pass++))
  else
    warn "config/agent-registry.json not found."
    ((warn_count++))
  fi

  # 4. Agent count
  if command -v jq &>/dev/null && [[ -f "config/agent-registry.json" ]]; then
    AGENT_COUNT=$(jq '.total_mxm_agents' config/agent-registry.json)
    if [[ "$AGENT_COUNT" -ge 80 ]]; then
      success "Agent registry: $AGENT_COUNT agents registered"
      ((pass++))
    else
      warn "Agent registry shows only $AGENT_COUNT agents — expected 87+"
      ((warn_count++))
    fi
  else
    warn "jq not installed — skipping agent count check (install: brew install jq)"
    ((warn_count++))
  fi

  # 5. .mxm-skills/ folder
  if [[ -d ".mxm" ]]; then
    success ".mxm-skills/ folder found"
    ((pass++))
  else
    warn ".mxm-skills/ folder not found."
    ((warn_count++))
  fi

  # 6. handoff-schema.md
  if [[ -f ".mxm-skills/agents-handoff-schema.md" ]]; then
    success ".mxm-skills/agents-handoff-schema.md found (inter-agent protocol active)"
    ((pass++))
  else
    warn ".mxm-skills/agents-handoff-schema.md not found."
    ((warn_count++))
  fi

  # 7. CLAUDE.md
  if [[ -f "CLAUDE.md" ]]; then
    success "CLAUDE.md found (universal Maxim rules)"
    ((pass++))
  else
    warn "CLAUDE.md not found. This is the core Maxim instruction file."
    ((fail++))
  fi

  # 8. skill-gaps.log
  if [[ -f ".mxm-skills/agents-skill-gaps.log" ]]; then
    GAP_COUNT=$(wc -l < .mxm-skills/agents-skill-gaps.log | tr -d ' ')
    if [[ "$GAP_COUNT" -gt 0 ]]; then
      warn ".mxm-skills/agents-skill-gaps.log has $GAP_COUNT unresolved gap(s). Review before next session."
      ((warn_count++))
    else
      success ".mxm-skills/agents-skill-gaps.log is clean"
      ((pass++))
    fi
  else
    success ".mxm-skills/agents-skill-gaps.log not present (no gaps logged yet)"
    ((pass++))
  fi

  # 9. Maxim adapter overlay check
  local ADAPTER_PATCHED=false
  if [[ -f "ide-adapters/.cursor/hooks/user-prompt-submit.sh" ]]; then
    if grep -q "Maxim-OVERLAY" "ide-adapters/.cursor/hooks/user-prompt-submit.sh" 2>/dev/null; then
      success "IDE adapters: Maxim overlay confirmed (.cursor hook patched)"
      ADAPTER_PATCHED=true
      ((pass++))
    else
      warn "IDE adapters: Maxim overlay NOT present. Run: bash bootstrap/new-project-setup.sh --patch-hooks-only"
      ((warn_count++))
    fi
  else
    warn "IDE adapters: .cursor hook not found — adapter patch not verifiable"
    ((warn_count++))
  fi

  # ---- Summary ----------------------------------------------------------------
  echo ""
  echo -e "${BOLD}--- Validation Summary ---${NC}"
  echo -e "  ${GREEN}PASS:${NC}  $pass"
  echo -e "  ${YELLOW}WARN:${NC}  $warn_count"
  echo -e "  ${RED}FAIL:${NC}  $fail"
  echo ""

  if [[ $fail -gt 0 ]]; then
    echo -e "${RED}Setup incomplete. Fix the FAIL items above.${NC}"
    exit 1
  elif [[ $warn_count -gt 0 ]]; then
    echo -e "${YELLOW}Setup valid with warnings. Review WARN items above.${NC}"
  else
    echo -e "${GREEN}${BOLD}Maxim is fully configured and ready.${NC}"
  fi
}

# =============================================================================
# MODE ROUTING
# =============================================================================
if [[ "$VALIDATE_ONLY" == true ]]; then
  validate
  exit 0
fi

if [[ "$PATCH_HOOKS_ONLY" == true ]]; then
  echo ""
  echo -e "${BOLD}${BLUE}=====================================${NC}"
  echo -e "${BOLD}${BLUE}  Maxim IDE Adapter Patch (v1.1.0)    ${NC}"
  echo -e "${BOLD}${BLUE}=====================================${NC}"
  info "Patching IDE adapters only (--patch-hooks-only mode)."
  info "Use this after git subtree add (Option B) to activate Maxim hooks."
  echo ""
  patch_ide_adapters
  echo -e "${BOLD}${GREEN}=== Maxim Hook Patch Complete ===${NC}"
  echo ""
  info "Verify with: bash bootstrap/new-project-setup.sh --validate-only"
  exit 0
fi

# =============================================================================
# INTERACTIVE SETUP SECTION
# =============================================================================
clear
echo ""
echo -e "${BOLD}${BLUE}=====================================${NC}"
echo -e "${BOLD}${BLUE}  Maxim New Project Setup Wizard v1.1 ${NC}"
echo -e "${BOLD}${BLUE}=====================================${NC}"
echo ""
info "This wizard generates project-specific files only:"
info "  config/project-manifest.json and CLAUDE.project.md"
info "It will NOT overwrite CLAUDE.md or agent-registry.json."
info ""
info "Windows users: global install is recommended."
info "  Run bootstrap/install-global.ps1 once, then use this wizard per project."
echo ""

# ---- Collect inputs ---------------------------------------------------------
read -rp "$(echo -e "${BOLD}Project ID${NC} (lowercase, hyphen-separated, e.g. my-app): ")" PROJECT_ID
read -rp "$(echo -e "${BOLD}Project Name${NC} (e.g. My App): ")" PROJECT_NAME
read -rp "$(echo -e "${BOLD}Owner${NC} (GitHub username): ")" PROJECT_OWNER
read -rp "$(echo -e "${BOLD}Vertical${NC} (SaaS / AI / FinTech / HealthTech / LegalTech / EdTech / Other): ")" PROJECT_VERTICAL
read -rp "$(echo -e "${BOLD}Stage${NC} (idea / early-stage / active / scaling / mature): ")" PROJECT_STAGE
read -rp "$(echo -e "${BOLD}Description${NC} (one sentence): ")" PROJECT_DESCRIPTION

echo ""
info "Compliance frameworks (press Enter to skip each):"
read -rp "  Include GDPR? (y/N): " USE_GDPR
read -rp "  Include HIPAA? (y/N): " USE_HIPAA
read -rp "  Include PCI-DSS? (y/N): " USE_PCI
read -rp "  Include PIPEDA? (y/N): " USE_PIPEDA
read -rp "  Include SOC2? (y/N): " USE_SOC2
read -rp "  Include UAE-PDPL? (y/N): " USE_UAE
read -rp "  Include AU Privacy Act 1988? (y/N): " USE_AU

echo ""
read -rp "$(echo -e "${BOLD}Default model provider${NC} (anthropic / openai / gemini / mistral / local) [anthropic]: ")" MODEL_PROVIDER
MODEL_PROVIDER=${MODEL_PROVIDER:-anthropic}

read -rp "$(echo -e "${BOLD}Bootstrap template${NC} (saas-platform / ai-agent-service / compliance-app / api-backend / none) [none]: ")" BOOTSTRAP_TEMPLATE
BOOTSTRAP_TEMPLATE=${BOOTSTRAP_TEMPLATE:-none}

# ---- Build compliance array -------------------------------------------------
COMPLIANCE_FRAMEWORKS="[]"
FRAMEWORKS_LIST=""
[[ "$USE_GDPR" =~ ^[Yy]$ ]]   && FRAMEWORKS_LIST+='"GDPR",'
[[ "$USE_HIPAA" =~ ^[Yy]$ ]]  && FRAMEWORKS_LIST+='"HIPAA",'
[[ "$USE_PCI" =~ ^[Yy]$ ]]    && FRAMEWORKS_LIST+='"PCI-DSS",'
[[ "$USE_PIPEDA" =~ ^[Yy]$ ]] && FRAMEWORKS_LIST+='"PIPEDA",'
[[ "$USE_SOC2" =~ ^[Yy]$ ]]   && FRAMEWORKS_LIST+='"SOC2",'
[[ "$USE_UAE" =~ ^[Yy]$ ]]    && FRAMEWORKS_LIST+='"UAE-PDPL",'
[[ "$USE_AU" =~ ^[Yy]$ ]]     && FRAMEWORKS_LIST+='"AU-Privacy-Act-1988",'
FRAMEWORKS_LIST="${FRAMEWORKS_LIST%,}"
[[ -n "$FRAMEWORKS_LIST" ]] && COMPLIANCE_FRAMEWORKS="[$FRAMEWORKS_LIST]"

REGULATED="[]"
([[ "$USE_GDPR" =~ ^[Yy]$ ]] || [[ "$USE_HIPAA" =~ ^[Yy]$ ]] || [[ "$USE_UAE" =~ ^[Yy]$ ]] || [[ "$USE_AU" =~ ^[Yy]$ ]]) && REGULATED='["'"$PROJECT_ID"'"]'

PAYMENT="[]"
[[ "$USE_PCI" =~ ^[Yy]$ ]] && PAYMENT='["'"$PROJECT_ID"'"]'

HIPAA="[]"
[[ "$USE_HIPAA" =~ ^[Yy]$ ]] && HIPAA='["'"$PROJECT_ID"'"]'

TODAY=$(date +%Y-%m-%d)
NEXT_REVIEW=$(date -d '+2 weeks' +%Y-%m-%d 2>/dev/null || date -v+2w +%Y-%m-%d 2>/dev/null || echo "TBD")

# ---- Write project-manifest.json --------------------------------------------
info "Writing config/project-manifest.json..."
mkdir -p config

cat > config/project-manifest.json <<EOF
{
  "manifest_version": "1.0.0",
  "mxm_version": "6.2.0",
  "description": "Project identity manifest for ${PROJECT_NAME}. Generated by Maxim setup wizard.",

  "project": {
    "id": "${PROJECT_ID}",
    "name": "${PROJECT_NAME}",
    "owner": "${PROJECT_OWNER}",
    "vertical": "${PROJECT_VERTICAL}",
    "description": "${PROJECT_DESCRIPTION}",
    "stage": "${PROJECT_STAGE}",
    "active": true
  },

  "portfolio": [
    {
      "id": "${PROJECT_ID}",
      "name": "${PROJECT_NAME}",
      "vertical": "${PROJECT_VERTICAL}",
      "stage": "${PROJECT_STAGE}"
    }
  ],

  "compliance": {
    "frameworks": ${COMPLIANCE_FRAMEWORKS},
    "per_project": {
      "${PROJECT_ID}": ${COMPLIANCE_FRAMEWORKS}
    },
    "regulated_projects": ${REGULATED},
    "payment_projects": ${PAYMENT},
    "hipaa_projects": ${HIPAA}
  },

  "tech_stack": {
    "default_model_provider": "${MODEL_PROVIDER}",
    "supported_providers": ["anthropic", "openai", "gemini", "mistral", "local"],
    "preferred_models": {
      "reasoning": "claude-sonnet",
      "code": "claude-sonnet",
      "fast": "claude-haiku",
      "vision": "claude-sonnet"
    }
  },

  "bootstrap_templates": {
    "selected": "${BOOTSTRAP_TEMPLATE}"
  },

  "agent_overrides": {
    "description": "Per-project agent behavior overrides. Leave empty for standard Maxim behavior.",
    "overrides": []
  },

  "maintainer": "${PROJECT_OWNER}",
  "last_updated": "${TODAY}",
  "next_review": "${NEXT_REVIEW}"
}
EOF

success "config/project-manifest.json written"

# ---- Validate JSON -----------------------------------------------------------
if command -v node &>/dev/null; then
  if node -e "JSON.parse(require('fs').readFileSync('config/project-manifest.json','utf8'))" 2>/dev/null; then
    success "project-manifest.json — JSON valid ✅"
  else
    error "project-manifest.json has a JSON syntax error — fix before proceeding"
  fi
else
  warn "node not found — skipping JSON validation"
fi

# ---- Write CLAUDE.project.md ------------------------------------------------
info "Writing CLAUDE.project.md..."

cat > CLAUDE.project.md <<EOF
# Maxim Project-Specific Configuration

> Project: ${PROJECT_NAME}
> Generated by Maxim setup wizard on ${TODAY}.
> Universal Maxim rules live in \`CLAUDE.md\`. This file only adds or overrides.

**Project:** ${PROJECT_NAME}
**Owner:** ${PROJECT_OWNER}
**Generated:** ${TODAY}

---

## Active Projects

| ID | Project | Vertical | Stage |
|---|---|---|---|
| \`${PROJECT_ID}\` | ${PROJECT_NAME} | ${PROJECT_VERTICAL} | ${PROJECT_STAGE} |

**Source of truth:** \`config/project-manifest.json\`

---

## Compliance Requirements

Active frameworks: ${COMPLIANCE_FRAMEWORKS}

- Regulated projects (mandatory compliance loop): ${REGULATED}
- Payment projects (PCI-DSS scope checks): ${PAYMENT}
- HIPAA projects: ${HIPAA}

---

## Project-Specific Agent Rules

> Fill in your project-specific rules below.

<!-- TODO: Add your project-specific agent rules here -->

---

## Brand Voice

<!-- TODO: Add tone, audience, core message, and avoid list -->
- Tone:
- Audience:
- Core message:
- Avoid:

---

## How to Adopt This File for a New Project

1. Copy this file: \`cp CLAUDE.project.md CLAUDE.project.YOUR-PROJECT.md\`
2. Replace all sections with your project details
3. Update \`config/project-manifest.json\` with your project data
EOF

success "CLAUDE.project.md written"

# ---- Bootstrap template -----------------------------------------------------
if [[ "$BOOTSTRAP_TEMPLATE" != "none" && -d "bootstrap/${BOOTSTRAP_TEMPLATE}" ]]; then
  info "Applying bootstrap template: ${BOOTSTRAP_TEMPLATE}..."
  cp -r "bootstrap/${BOOTSTRAP_TEMPLATE}/" "./project-scaffold/"
  success "Template copied to ./project-scaffold/"
fi

# ---- Create project structure folders -----------------------------------------------
mkdir -p documents/ADRs
mkdir -p documents/ledgers
mkdir -p documents/architecture/.secrets
mkdir -p documents/business
mkdir -p prototypes

# ADR ledger scaffold — every Maxim project starts with an INDEX + TEMPLATE
if [[ ! -f "documents/ADRs/INDEX.md" ]]; then
  cat > documents/ADRs/INDEX.md <<'EOF'
# ADR Index

> Copyright (c) 2026 iSystematic Inc. Maxim-managed ledger.

| ADR | Title | Status | Date |
|---|---|---|---|
| _(none yet)_ | | | |

---

**Total ADRs:** 0 · **Accepted:** 0 · **Superseded:** 0 · **Rejected:** 0
EOF
fi
if [[ ! -f "documents/ADRs/TEMPLATE.md" ]]; then
  cat > documents/ADRs/TEMPLATE.md <<'EOF'
# ADR-NNN — [Short title of the decision]

- **Status:** proposed | accepted | superseded by ADR-NNN | deprecated | rejected
- **Date:** YYYY-MM-DD
- **Deciders:** [names or roles]
- **Related:** ADR-NNN, ADR-NNN

---

## Context

What problem are we solving? One or two paragraphs.

## Decision

The decision, stated positively, in one or two sentences.

## Rationale

Why this and not plausible alternatives. Name them.

## Consequences

What this makes easier, what it makes harder, what it locks us into.
EOF
fi

# ---- Create .mxm-skills/ folder ---------------------------------------------------
mkdir -p .mxm-skills
if [[ ! -f ".mxm-skills/agents-skill-gaps.log" ]]; then
  touch .mxm-skills/agents-skill-gaps.log
  success ".mxm-skills/agents-skill-gaps.log created"
fi

if [[ ! -f ".mxm-skills/agents-handoff.md" ]]; then
  cat > .mxm-skills/agents-handoff.md <<'HANDOFF_EOF'
# Agent Handoff Protocol
# Written by orchestrators during multi-agent task chains.
HANDOFF_EOF
  success ".mxm-skills/agents-handoff.md created"
fi

if [[ ! -f ".mxm-skills/agents-background.log" ]]; then
  touch .mxm-skills/agents-background.log
  success ".mxm-skills/agents-background.log created"
fi

if [[ ! -f ".mxm-skills/review-queue.md" ]]; then
  cat > .mxm-skills/review-queue.md <<'REVIEWQ_EOF'
# Maxim Review Queue
# Items pending human review. Generated by skill-synthesizer, gap-triage, and staleness prevention.
# Consumed by /mxm-ceo-morning (Task 0) and /mxm-ceo-overnight (gap-triage).

## Pending Review

| # | Type | Title | Source | Date | Status |
|---|---|---|---|---|---|

## Review History
REVIEWQ_EOF
  success ".mxm-skills/review-queue.md created"
fi

# ---- Create .claude-sessions-memory/ (parity with link-local-project.ps1) ---
mkdir -p .claude-sessions-memory
if [[ ! -f ".claude-sessions-memory/handoff.md" ]]; then
  cat > .claude-sessions-memory/handoff.md <<HANDOFF_EOF
# Session Handoff — ${PROJECT_NAME}
# Last updated: ${TODAY}
# Use this file to resume context across Claude Code sessions.

## Last Session Summary
<!-- Claude Code writes here automatically at session end -->

## Open Tasks
<!-- Incomplete items from last session -->

## Key Decisions Made
<!-- Architecture or product decisions logged here -->

## Next Session Start Point
<!-- What to load and run first next session -->
HANDOFF_EOF
  success ".claude-sessions-memory/handoff.md created"
fi

if [[ ! -f ".claude-sessions-memory/decision-log.md" ]]; then
  cat > .claude-sessions-memory/decision-log.md <<DECLOG_EOF
# Decision Log — ${PROJECT_NAME}
# Format: [DATE] [DECISION] rationale
# Append entries. Never delete.
DECLOG_EOF
  success ".claude-sessions-memory/decision-log.md created"
fi

if [[ ! -f ".claude-sessions-memory/skill-gaps.log" ]]; then
  cat > .claude-sessions-memory/skill-gaps.log <<SGLOG_EOF
# Session Skill Gaps — ${PROJECT_NAME}
# Format: [ISO-TIMESTAMP] [SKILL-GAP|Maxim-UNENHANCED] domain: message
SGLOG_EOF
  success ".claude-sessions-memory/skill-gaps.log created"
fi

# ---- Create .mxm-operator-profile/ ------------------------------------------------
mkdir -p .mxm-operator-profile
if [[ ! -f ".mxm-operator-profile/OPERATOR.md" ]]; then
  cat > .mxm-operator-profile/OPERATOR.md <<'OP_EOF'
# Operator Profile
# Updated automatically at session end by Maxim behavioral-designer agent.
# Manual edits welcome — Maxim will preserve and build on them.

## Identity
<!-- Name, role, organization -->

## Working Style
<!-- How you prefer to work: research-first, iterative, documentation-heavy, etc. -->

## Output Preferences
<!-- Preferred response format: structured markdown, concise, verbose, etc. -->

## Technical Context
<!-- Primary languages, frameworks, tools you use -->
OP_EOF
  success ".mxm-operator-profile/OPERATOR.md created"
fi

if [[ ! -f ".mxm-operator-profile/preferences.md" ]]; then
  cat > .mxm-operator-profile/preferences.md <<'PREF_EOF'
# Operator Preferences
# Append-only. Maxim adds entries as it learns your preferences.
PREF_EOF
  success ".mxm-operator-profile/preferences.md created"
fi

if [[ ! -f ".mxm-operator-profile/rejected-patterns.md" ]]; then
  cat > .mxm-operator-profile/rejected-patterns.md <<'REJ_EOF'
# Rejected Patterns
# Patterns you have corrected or rejected. Maxim will avoid these.
# NEVER delete entries — only add.
REJ_EOF
  success ".mxm-operator-profile/rejected-patterns.md created"
fi

if [[ ! -f ".mxm-operator-profile/communication-style.md" ]]; then
  cat > .mxm-operator-profile/communication-style.md <<'COMM_EOF'
# Communication Style
# How you phrase requests, preferred response format, verbosity level.
COMM_EOF
  success ".mxm-operator-profile/communication-style.md created"
fi

# ---- Create/update .gitignore -----------------------------------------------
if [[ ! -f ".gitignore" ]]; then
  cat > .gitignore <<'GITIGNORE_EOF'
# ── Maxim Session Memory (not for version control) ──────────────────────────
.claude-sessions-memory/

# ── Maxim Runtime State ────────────────────────────────────────────────────
.mxm-skills/agents-handoff.md
.mxm-skills/agents-skill-gaps.log
.mxm-skills/agents-background.log
.mxm-skills/review-queue.md

# ── Maxim Operator Profile (personal, not shared) ─────────────────────────
.mxm-operator-profile/

# ── Maxim Local Config ────────────────────────────────────────────────────
.claude.local/
config/project-manifest.local.json

# ── Maxim private documents (operator-local ledgers) ─────────────────────
# ADRs, architecture, business, references: local-only working folders.
# Public-facing docs live on maxim.isystematic.com, not in version control.
documents/ADRs/
documents/architecture/
documents/business/
documents/references/
documents/build-artifacts-scripts/

# ── Maxim ledger state (runtime-written, operator-local) ─────────────────
# SESSION_CONTINUITY + SPRINT_CLI_INSTRUCTIONS are session/sprint working state.
# AGENT_SKILL_INVENTORY, MOAT_TRACKER, DEBUGGING_PLAYBOOK are tracked
# intentionally — they are public Executable Contracts per ADR-002.
documents/ledgers/SESSION_CONTINUITY.md
documents/ledgers/SPRINT_CLI_INSTRUCTIONS.md

# ── Generated by bootstrap ───────────────────────────────────────────────
GEMINI.md
documents/reference/AGENTS.md
.github/copilot-instructions.md

# ── Common ───────────────────────────────────────────────────────────────
.env
.env.local
node_modules/
__pycache__/
*.pyc
.DS_Store
Thumbs.db
GITIGNORE_EOF
  success ".gitignore created"
else
  # Append .mxm-operator-profile/ if missing from existing .gitignore
  if ! grep -qF ".mxm-operator-profile/" .gitignore 2>/dev/null; then
    cat >> .gitignore <<'GITIGNORE_APPEND_EOF'

# ── Maxim Operator Profile (personal, not shared) ─────────────────────────
.mxm-operator-profile/
GITIGNORE_APPEND_EOF
    success ".gitignore updated — added .mxm-operator-profile/"
  fi
fi

# ---- Copy agent-registry.json (parity with link-local-project.ps1) ----------
if [[ ! -f "config/agent-registry.json" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MXM_ROOT="$(dirname "$SCRIPT_DIR")"
  if [[ -f "$MXM_ROOT/config/agent-registry.json" ]]; then
    cp "$MXM_ROOT/config/agent-registry.json" config/agent-registry.json
    success "config/agent-registry.json copied"
  elif [[ -f "config/agent-registry.json" ]]; then
    success "config/agent-registry.json already present"
  else
    warn "config/agent-registry.json not found in Maxim source — /mxm-status may not work"
  fi
fi

# ---- Patch IDE adapters (Step 3c) ------------------------------------------
patch_ide_adapters

# ---- Final validation -------------------------------------------------------
echo ""
info "Running validation..."
echo ""
validate

echo ""
echo -e "${BOLD}${GREEN}=== Maxim Setup Complete ===${NC}"
echo ""
info "Next steps:"
echo "  1. Review and complete CLAUDE.project.md (brand voice + agent rules)"
echo "  2. Open your IDE (Claude Code / Cursor / Windsurf)"
echo "  3. Call your first agent: @planner Create a task plan for [your feature]"
echo ""
info "Full guide: documents/guides/GETTING_STARTED.md"
info "Agent catalog: config/agent-registry.json"
info "Repo: https://github.com/DrNabeelKhan/maxim"
echo ""
