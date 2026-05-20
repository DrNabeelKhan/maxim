#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# install-tier-packs.sh — Maxim tier-aware install wizard (v1.3.0+, ADR-019)
#
# Reduces 14 separate /plugin install commands to one operator decision.
# Behavioral framing per ADR-019: loss aversion on capabilities, default effect
# on Trial, endowment setup. No prices in wizard (anchoring decision per ADR-019).
#
# Usage:
#   bash bootstrap/install-tier-packs.sh           # interactive wizard
#   bash bootstrap/install-tier-packs.sh trial     # non-interactive Trial
#   bash bootstrap/install-tier-packs.sh solo      # non-interactive Solo
#   bash bootstrap/install-tier-packs.sh pro       # non-interactive Pro
#   bash bootstrap/install-tier-packs.sh team      # non-interactive Team
#   bash bootstrap/install-tier-packs.sh enterprise # non-interactive Enterprise

set -euo pipefail

# ─── Color output ─────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'
  CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; MAGENTA=''; BOLD=''; NC=''
fi

# ─── Pack definitions ─────────────────────────────────────────────────────────
L1_PACKS=(
  "mxm-pack-l1-1-ai-governance"
  "mxm-pack-l1-2-mempalace-pro"
  "mxm-pack-l1-3-proactive-watch"
  "mxm-pack-l1-4-compliance-shield"
  "mxm-pack-l1-5-brand-design-pro"
  "mxm-pack-l1-6-behavioral-intelligence"
)

L2_PACKS=(
  "mxm-pack-l2-1-founder-os"
  "mxm-pack-l2-2-growth-stack"
  "mxm-pack-l2-3-professional-os"
  "mxm-pack-l2-4-agency-all-in"
)

L3_PACKS=(
  "mxm-pack-l3-1-healthcare"
  "mxm-pack-l3-2-legal"
  "mxm-pack-l3-3-fintech"
  "mxm-pack-l3-4-govtech"
)

# ─── Wizard ────────────────────────────────────────────────────────────────────
show_wizard() {
  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}${MAGENTA}Maxim v1.3.0 · Choose your install${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${BOLD}Maxim Core${NC} (already installed · free forever):"
  echo "  • 91 specialist agents across 7 executive offices"
  echo "  • 36 skill domains · 48 slash commands"
  echo "  • 74 behavioral frameworks active by default"
  echo "  • 14 compliance frameworks enforced at MCP layer"
  echo "  • 9 MCPs · 95 tools including NotebookLM research synthesis"
  echo ""
  echo -e "${YELLOW}What you can't access yet (the structural moats Core hints at):${NC}"
  echo ""
  echo "  L1.1  AI Governance         — audit trail on every AI decision"
  echo "  L1.2  MemPalace Pro         — memory that resumes where you left it"
  echo "  L1.3  Proactive Watch       — drift caught BEFORE you ship"
  echo "  L1.4  Compliance Shield     — 14 frameworks enforced on every output"
  echo "  L1.5  Brand & Design Pro    — your voice locked across AI outputs"
  echo "  L1.6  Behavioral Intel      — the flagship moat (74 frameworks dispatched)"
  echo ""
  echo "  L2 vertical bundles for founders · growth · professional · agency"
  echo "  L3 industry packs for healthcare · legal · fintech · govtech"
  echo ""
  echo -e "${BOLD}Which path matches you?${NC}"
  echo ""
  echo -e "  ${BOLD}${GREEN}[1]${NC}  ${BOLD}90-day trial${NC}  ${CYAN}(default — recommended)${NC}"
  echo "                  All 14 packs unlocked. See the full moat work."
  echo "                  No card required. Cancel anytime."
  echo "                  ${YELLOW}Why we default to this:${NC} hard to evaluate a moat"
  echo "                  you can't see. Run your real work through it for"
  echo "                  three months, then decide what's worth keeping."
  echo ""
  echo -e "  ${BOLD}[2]${NC}  Solo            — Core only · upgrade anytime"
  echo "                  Best for: solo operators evaluating Maxim."
  echo "                  What you give up: the 6 L1 structural moats."
  echo ""
  echo -e "  ${BOLD}[3]${NC}  Pro             — Core + 6 L1 packs"
  echo "                  Best for: serious operators on 1-2 projects."
  echo "                  What you unlock: audit trail · drift detection ·"
  echo "                  voice lock · compliance enforcement · governance ·"
  echo "                  behavioral intelligence layer."
  echo ""
  echo -e "  ${BOLD}[4]${NC}  Team            — Core + L1 + 4 L2 vertical bundles"
  echo "                  Best for: teams running multiple verticals."
  echo "                  Adds: founder-os · growth-stack · pro-os · agency-all."
  echo ""
  echo -e "  ${BOLD}[5]${NC}  Enterprise      — Everything · all 14 packs"
  echo "                  Best for: regulated industries · multi-team orgs."
  echo "                  Adds L3 industry packs: healthcare · legal · fintech · govtech."
  echo ""
  echo -e "  ${BOLD}[6]${NC}  Choose individually"
  echo ""
  echo -e "  ${BOLD}[q]${NC}  Skip · I'll decide later (Core stays installed)"
  echo ""
  echo -ne "${BOLD}Choice [1]: ${NC}"
}

# ─── Install logic ─────────────────────────────────────────────────────────────
install_pack() {
  local pack=$1
  echo -ne "  ${CYAN}→${NC} $pack ... "
  if claude /plugin install "${pack}@maxim-packs" >/dev/null 2>&1; then
    echo -e "${GREEN}ok${NC}"
  else
    echo -e "${YELLOW}check manually${NC}"
  fi
}

install_l1() {
  echo ""
  echo -e "${BOLD}Installing 6 L1 packs${NC} (the structural moat layer)..."
  for pack in "${L1_PACKS[@]}"; do install_pack "$pack"; done
}

install_l2() {
  echo ""
  echo -e "${BOLD}Installing 4 L2 vertical bundles${NC}..."
  for pack in "${L2_PACKS[@]}"; do install_pack "$pack"; done
}

install_l3() {
  echo ""
  echo -e "${BOLD}Installing 4 L3 industry packs${NC}..."
  for pack in "${L3_PACKS[@]}"; do install_pack "$pack"; done
}

issue_trial_jwt() {
  echo ""
  echo -e "${BOLD}Activating 90-day trial${NC}..."
  echo -e "  ${CYAN}→${NC} Requesting trial JWT from license worker..."
  # Delegate to existing license-gate trial-issue endpoint
  if claude /plugin run mxm-pack-engine activate --trial 90 >/dev/null 2>&1; then
    echo -e "  ${GREEN}ok${NC} Trial JWT issued (expires in 90 days)"
  else
    echo -e "  ${YELLOW}manual activation needed${NC}"
    echo -e "     Visit ${CYAN}https://maxim.isystematic.com/trial${NC} to claim your trial JWT"
  fi
}

# ─── Tier handlers ─────────────────────────────────────────────────────────────
do_trial() {
  install_l1
  install_l2
  install_l3
  issue_trial_jwt
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Trial active — 90 days · all 14 packs unlocked${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "What to try first (suggestions ranked by impact):"
  echo ""
  echo -e "  ${CYAN}1.${NC} ${BOLD}Watch the moat work on YOUR project:${NC}"
  echo "     /mxm-watch     → 13 drift classes scan your repo"
  echo "     /mxm-status    → see what's stale, what's drifting"
  echo ""
  echo -e "  ${CYAN}2.${NC} ${BOLD}See behavioral intelligence in action:${NC}"
  echo "     /mxm-behavior  → analyze any decision with Fogg · COM-B · EAST"
  echo ""
  echo -e "  ${CYAN}3.${NC} ${BOLD}Test compliance enforcement on regulated work:${NC}"
  echo "     /mxm-compliance → 14 frameworks scan your output, flag risk"
  echo ""
  echo -e "  ${CYAN}4.${NC} ${BOLD}Calibrate your voice:${NC}"
  echo "     /mxm-brand-voice calibrate"
  echo "     → instantiates your own operator-writer · routes every"
  echo "       writing task through your voice automatically"
  echo ""
  echo "Trial ends in 90 days. We'll remind you at day 80."
  echo "To convert: visit maxim.isystematic.com/pricing or /mxm-status"
  echo ""
}

do_solo() {
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Solo · Core ready${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "Maxim Core is fully active. 74 behavioral frameworks dispatch on"
  echo "every output. 14 compliance frameworks check every regulated task."
  echo ""
  echo -e "${YELLOW}What stays gated until you upgrade:${NC}"
  echo "  • Audit trail on every AI decision (L1.1 AI Governance)"
  echo "  • Cross-session memory continuity (L1.2 MemPalace Pro)"
  echo "  • 13-class drift detection (L1.3 Proactive Watch)"
  echo "  • 14-framework compliance enforcement (L1.4 Compliance Shield)"
  echo "  • Voice lock across all outputs (L1.5 Brand & Design Pro)"
  echo "  • 74-framework behavioral dispatch (L1.6 Behavioral Intel)"
  echo ""
  echo -e "${CYAN}Try them free for 90 days:${NC} ${BOLD}bash bootstrap/install-tier-packs.sh trial${NC}"
  echo ""
  echo "Or upgrade individually anytime: /plugin install <pack-id>@maxim-packs"
  echo ""
}

do_pro() {
  install_l1
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Pro · Core + 6 L1 packs installed${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "What you unlocked:"
  echo "  ✓ AI Governance audit trail on every AI decision"
  echo "  ✓ MemPalace Pro cross-session continuity"
  echo "  ✓ Proactive Watch 13-class drift detection"
  echo "  ✓ Compliance Shield 14-framework enforcement"
  echo "  ✓ Brand & Design Pro voice lock"
  echo "  ✓ Behavioral Intelligence 74-framework dispatch"
  echo ""
  echo "Activate your license JWT: mxm-pack-engine activate --license <JWT>"
  echo ""
}

do_team() {
  install_l1
  install_l2
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Team · Core + L1 + 4 L2 vertical bundles installed${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "Plus vertical bundles for: founder-os · growth-stack · pro-os · agency-all"
  echo ""
  echo "Activate your license JWT: mxm-pack-engine activate --license <JWT>"
  echo ""
}

do_enterprise() {
  install_l1
  install_l2
  install_l3
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Enterprise · All 14 packs installed${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "Plus L3 industry packs: healthcare · legal · fintech · govtech"
  echo ""
  echo "Activate your license JWT: mxm-pack-engine activate --license <JWT>"
  echo ""
}

do_individual() {
  echo ""
  echo -e "${CYAN}Individual pack install — run any of:${NC}"
  echo ""
  echo "L1 packs (structural moats):"
  for pack in "${L1_PACKS[@]}"; do echo "  /plugin install $pack@maxim-packs"; done
  echo ""
  echo "L2 vertical bundles:"
  for pack in "${L2_PACKS[@]}"; do echo "  /plugin install $pack@maxim-packs"; done
  echo ""
  echo "L3 industry packs:"
  for pack in "${L3_PACKS[@]}"; do echo "  /plugin install $pack@maxim-packs"; done
  echo ""
}

# ─── Main ──────────────────────────────────────────────────────────────────────
choice=""
if [[ $# -gt 0 ]]; then
  choice=$1
else
  show_wizard
  read -r choice
  choice=${choice:-1}  # default to Trial
fi

case "$choice" in
  1|trial|Trial|TRIAL)            do_trial ;;
  2|solo|Solo|SOLO)               do_solo ;;
  3|pro|Pro|PRO)                  do_pro ;;
  4|team|Team|TEAM)               do_team ;;
  5|enterprise|Enterprise|ENT*)   do_enterprise ;;
  6|individual|Individual|i)      do_individual ;;
  q|Q|skip|Skip)
    echo ""
    echo "Skipped. Re-run anytime: bash bootstrap/install-tier-packs.sh"
    echo ""
    ;;
  *)
    echo -e "${RED}Unknown choice: $choice${NC}"
    echo "Valid: 1-6 or trial/solo/pro/team/enterprise/individual/q"
    exit 1
    ;;
esac
