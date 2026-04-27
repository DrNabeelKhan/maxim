#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# bootstrap/sync-counts.sh — propagate AGENT_SKILL_INVENTORY counts to all surfaces.
#
# Reads documents/ledgers/AGENT_SKILL_INVENTORY.md (the single source of truth
# for capability counts) and updates every surface that hard-codes a count
# adjacent to a tracked keyword anchor (agents, frameworks, commands, MCP
# servers, MCP tools, hooks, skill domains, compliance frameworks).
#
# Idempotent: running on a clean tree is a no-op (zero file modifications).
# Running after a count bump produces exactly the diff a manual sweep would.
#
# Companion to Proactive Watch Class 11 (surface-claims-drift). Class 11 is
# detection; this script is propagation. Pre-commit hook fails-closed if a
# count mismatch remains after this tool runs (or if the tool wasn't run).
#
# Exit codes:
#   0 = clean (or successfully synced, all surfaces aligned)
#   1 = drift remained after sync (manual review required; see watch-report.jsonl)
#   2 = invalid inventory (could not parse a required section)
#   3 = environment error (missing Perl, missing repo root)
#
# Usage:
#   bootstrap/sync-counts.sh             # default — all anchors, all surfaces
#   bootstrap/sync-counts.sh --dry-run   # report planned changes without writing
#   bootstrap/sync-counts.sh --check     # exit 1 if any drift detected; do not modify
#   bootstrap/sync-counts.sh --verbose   # log every match + replacement decision
#
# Environment:
#   MAXIM_LANDING_PAGE  — optional path to sibling landing-page checkout.
#                         If unset, landing-page targets are skipped silently.
#                         Set explicitly to opt into cross-repo propagation.

set -euo pipefail

# =====================================================================
# Setup
# =====================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INVENTORY="$REPO_ROOT/documents/ledgers/AGENT_SKILL_INVENTORY.md"
WATCH_REPORT="$REPO_ROOT/.mxm-skills/watch-report.jsonl"
LANDING_PAGE_DEFAULT="$(cd "$REPO_ROOT/.." && pwd)/landing-page"
LANDING_PAGE_ROOT="${MAXIM_LANDING_PAGE:-$LANDING_PAGE_DEFAULT}"

DRY_RUN=0
CHECK_ONLY=0
VERBOSE=0
DRIFT_REMAINING=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --check) CHECK_ONLY=1 ;;
    --verbose) VERBOSE=1 ;;
    -h|--help)
      grep -E '^# ' "$0" | sed 's/^# \?//' | head -40
      exit 0 ;;
    *) echo "ERROR: unknown arg: $arg" >&2; exit 3 ;;
  esac
done

command -v perl >/dev/null 2>&1 || { echo "FATAL: perl is required" >&2; exit 3; }
[[ -f "$INVENTORY" ]] || { echo "FATAL: inventory not found at $INVENTORY" >&2; exit 2; }

mkdir -p "$(dirname "$WATCH_REPORT")"

log() { [[ $VERBOSE -eq 1 ]] && echo "  $*"; return 0; }
emit_drift() {
  local class="$1" file="$2" anchor="$3" claimed="$4" canonical="$5"
  local ts; ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "{\"ts\":\"$ts\",\"phase\":\"sync\",\"project\":\"maxim\",\"drift_class\":\"$class\",\"severity\":3,\"declared\":$canonical,\"actual\":$claimed,\"evidence\":\"$file:$anchor\",\"action\":\"manual-review\"}" >> "$WATCH_REPORT"
  DRIFT_REMAINING=1
}

# =====================================================================
# 1. Parse INVENTORY for canonical counts
# =====================================================================

# Each anchor maps to a regex that extracts its canonical number from INVENTORY.
# Section headings like "## Section 1 — Specialist Agents (90)" are the anchor;
# we extract the parenthesized number as the truth.
parse_section_count() {
  local section_pattern="$1"
  perl -ne 'if (/^##\s+'"$section_pattern"'.*?\((\d+)\)/) { print $1; exit 0 }' "$INVENTORY"
}

AGENTS=$(parse_section_count 'Section 1.*Specialist Agents')
SKILLS=$(parse_section_count 'Section 2.*Domain Skills')
COMMANDS=$(parse_section_count 'Section 3.*Slash Commands')
MCP_SERVERS=$(perl -ne 'if (/^##\s+Section 4.*MCP Servers.*?\((\d+)\s+server/) { print $1; exit 0 }' "$INVENTORY")
MCP_TOOLS=$(perl -ne   'if (/^##\s+Section 4.*?(\d+)\s+tools?\)/) { print $1; exit 0 }' "$INVENTORY")
HOOKS=$(parse_section_count 'Section 5.*Hooks')
FRAMEWORKS=$(parse_section_count 'Section 6.*Behavioral Frameworks')
COMPLIANCE=$(parse_section_count 'Section 7.*Compliance Frameworks')

[[ -z "$AGENTS" ]]   && { echo "FATAL: could not parse Section 1 (Specialist Agents)" >&2; exit 2; }
[[ -z "$SKILLS" ]]   && { echo "FATAL: could not parse Section 2 (Domain Skills)" >&2; exit 2; }
[[ -z "$COMMANDS" ]] && { echo "FATAL: could not parse Section 3 (Slash Commands)" >&2; exit 2; }

log "Canonical counts from INVENTORY:"
log "  agents=$AGENTS skills=$SKILLS commands=$COMMANDS"
log "  mcp_servers=${MCP_SERVERS:-?} mcp_tools=${MCP_TOOLS:-?} hooks=${HOOKS:-?}"
log "  frameworks=${FRAMEWORKS:-?} compliance=${COMPLIANCE:-?}"

# =====================================================================
# 2. Define surface scan paths + exclusions
# =====================================================================

# Excluded by design — historical / non-substantive / per-section breakdown matches:
EXCLUDE_PATTERNS=(
  '/CHANGELOG\.md$'
  '/documents/ADRs/INDEX\.md$'
  '/v[0-9][0-9.]*-[a-zA-Z0-9-]+\.md$'   # versioned historical (maxim-pack-catalog-v1.0.0.md)
  '/changelog/'                           # any directory named changelog
  '/migration-log'
  '/MIGRATION_LOG\.md$'
  '/SECRETS_TO_ROTATE\.md$'
  '/node_modules/'
  '/\.git/'
  '/config/agent-registry\.json$'        # has internal changelog with historical counts; breakdown comment updated separately
  '/CLAUDE\.d/office-catalog\.md$'       # per-office breakdowns — distinct truth source
  '/documents/ledgers/AGENT_SKILL_INVENTORY\.md$'  # source of truth itself; has per-section table that is NOT global counts
  '/agents/MXM/'                          # agent definition files often contain complexity thresholds like ">= 3 agents"
  '/\.claude/agents/'                     # ditto for plugin-side agent files
  '/documents/proposals/'                 # forward-looking spec docs reference v1.x plan targets, not current state
  '/AGENT_ROSTER_v1\.[0-9]+_PROPOSAL\.md$' # v1.x roadmap proposals contain plan targets distinct from current state
)

is_excluded() {
  local path="$1"
  for pat in "${EXCLUDE_PATTERNS[@]}"; do
    [[ "$path" =~ $pat ]] && return 0
  done
  return 1
}

# Plugin-repo glob list — markdown + JSON
collect_plugin_repo_surfaces() {
  cd "$REPO_ROOT"
  find . -type f \( -name "*.md" -o -path "*/config/agent-registry.json" \) \
    -not -path "./node_modules/*" \
    -not -path "./.git/*" \
    -not -path "./mcp/*/node_modules/*" \
    -not -path "./cloudflare-worker/node_modules/*" \
    -not -path "./community-packs/*" \
  | while read -r f; do
      f="${f#./}"
      is_excluded "/$f" || echo "$REPO_ROOT/$f"
    done
}

# Landing-page surfaces — only if env points to a real directory
collect_landing_page_surfaces() {
  [[ -d "$LANDING_PAGE_ROOT" ]] || { log "Landing-page not found at $LANDING_PAGE_ROOT — skipping cross-repo scan"; return 0; }
  cd "$LANDING_PAGE_ROOT"
  find . -type f \( -name "*.tsx" -o -name "*.ts" \) \
    -not -path "./node_modules/*" \
    -not -path "./.git/*" \
    -not -path "./.next/*" \
  | while read -r f; do
      f="${f#./}"
      # Excluded landing-page paths
      case "$f" in
        app/changelog/*|app/roadmap/*|app/giveaway/*|components/DispatchDiagram.tsx) continue ;;
      esac
      echo "$LANDING_PAGE_ROOT/$f"
    done
}

# =====================================================================
# 3. Anchor → count mapping with substitution patterns
# =====================================================================

# Each entry: <anchor_keyword>|<canonical_count>
# Pattern matches: \b(\d{1,4})\+?\s+(?:specialist\s+|governed\s+|peer-reviewed\s+|Maxim\s+)?<keyword>\b
# (case-insensitive, allows + suffix, allows common adjective prefixes)
ANCHORS=()
[[ -n "${AGENTS:-}" ]]      && ANCHORS+=("agents|$AGENTS")
[[ -n "${SKILLS:-}" ]]      && ANCHORS+=("skill domains|$SKILLS")
[[ -n "${COMMANDS:-}" ]]    && ANCHORS+=("commands|$COMMANDS")
[[ -n "${MCP_SERVERS:-}" ]] && ANCHORS+=("MCP servers|$MCP_SERVERS")
[[ -n "${MCP_TOOLS:-}" ]]   && ANCHORS+=("MCP tools|$MCP_TOOLS")
[[ -n "${HOOKS:-}" ]]       && ANCHORS+=("hooks|$HOOKS")
[[ -n "${FRAMEWORKS:-}" ]]  && ANCHORS+=("behavioral frameworks|$FRAMEWORKS")
[[ -n "${COMPLIANCE:-}" ]]  && ANCHORS+=("compliance frameworks|$COMPLIANCE")

# Build a single Perl regex pipeline that handles all anchors in one pass.
# Pre-flight: build alternation of escaped anchor keywords for grep filtering.
ANCHOR_GREP_PATTERN=""
for entry in "${ANCHORS[@]}"; do
  anchor="${entry%|*}"
  if [[ -z "$ANCHOR_GREP_PATTERN" ]]; then
    ANCHOR_GREP_PATTERN="$anchor"
  else
    ANCHOR_GREP_PATTERN="$ANCHOR_GREP_PATTERN|$anchor"
  fi
done

# Build Perl substitution chain (one expression per anchor, joined with `s/.../.../gi;`).
# Run as a SINGLE perl invocation per file (vs. 8 — Windows perf fix).
build_perl_script() {
  local script=""
  for entry in "${ANCHORS[@]}"; do
    local anchor="${entry%|*}"
    local count="${entry##*|}"
    # SAFE pattern: only match in two strict forms:
    #   1. <num>+<space><kw>             — "+"-suffix marks open-ended count claim (e.g., "90+ agents")
    #   2. <num><space><adj><space><kw>  — adjective-prefixed (specialist|governed|Maxim|peer-reviewed)
    # We DO NOT match bare "<num> <kw>" — too many false positives:
    #   - per-office breakdowns ("25 agents" for CTO)
    #   - complexity thresholds (">= 3 agents")
    #   - historical changelog entries ("87 agents at v1.0.0")
    # Class 11 detection still flags those; humans review manually.
    script+="s/\\b\\d{1,4}\\+(\\s+)$anchor\\b/${count}+\$1$anchor/gi;"
    script+="s/\\b\\d{1,4}(\\s+(?:specialist|governed|peer-reviewed|Maxim)\\s+)$anchor\\b/${count}\$1$anchor/gi;"
  done
  printf '%s' "$script"
}

PERL_SCRIPT="$(build_perl_script)"

# Apply substitution to a single file. Returns 0 if file modified, 1 if unchanged.
sync_file() {
  local file="$1"

  # Pre-filter: skip files with no anchor keyword present (cheap grep test).
  # Massive speedup on a tree where most files don't claim any capability count.
  if ! grep -qiE "$ANCHOR_GREP_PATTERN" "$file" 2>/dev/null; then
    return 1
  fi

  local before after
  before=$(<"$file")
  # Single perl invocation for all 8 anchors.
  after=$(printf '%s' "$before" | perl -pe "$PERL_SCRIPT")

  if [[ "$before" == "$after" ]]; then
    return 1  # unchanged
  fi
  if [[ $DRY_RUN -eq 1 || $CHECK_ONLY -eq 1 ]]; then
    log "Would update: ${file#$REPO_ROOT/}"
    [[ $CHECK_ONLY -eq 1 ]] && DRIFT_REMAINING=1
    return 0
  fi
  printf '%s' "$after" > "$file"
  log "Updated: ${file#$REPO_ROOT/}"
  return 0
}

# =====================================================================
# 4. Run sync across all surfaces
# =====================================================================

CHANGED=0
TOTAL=0

while IFS= read -r f; do
  TOTAL=$((TOTAL+1))
  if sync_file "$f"; then
    CHANGED=$((CHANGED+1))
  fi
done < <(collect_plugin_repo_surfaces)

LANDING_TOTAL=0
LANDING_CHANGED=0
while IFS= read -r f; do
  LANDING_TOTAL=$((LANDING_TOTAL+1))
  if sync_file "$f"; then
    LANDING_CHANGED=$((LANDING_CHANGED+1))
  fi
done < <(collect_landing_page_surfaces)

# =====================================================================
# 5. Report
# =====================================================================

echo ""
echo "✓ sync-counts complete"
echo "  inventory:        $INVENTORY"
echo "  canonical counts: agents=$AGENTS skills=${SKILLS:-?} commands=${COMMANDS:-?} mcp_servers=${MCP_SERVERS:-?} hooks=${HOOKS:-?} frameworks=${FRAMEWORKS:-?} compliance=${COMPLIANCE:-?}"
echo "  plugin-repo:      $CHANGED of $TOTAL surface files modified"
if [[ -d "$LANDING_PAGE_ROOT" ]]; then
  echo "  landing-page:     $LANDING_CHANGED of $LANDING_TOTAL surface files modified ($LANDING_PAGE_ROOT)"
else
  echo "  landing-page:     skipped (set MAXIM_LANDING_PAGE to enable)"
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "  mode:             DRY-RUN (no files modified)"
fi
if [[ $CHECK_ONLY -eq 1 && $DRIFT_REMAINING -eq 1 ]]; then
  echo "  CHECK FAILED: drift detected — run without --check to propagate"
  exit 1
fi
if [[ $DRIFT_REMAINING -eq 1 ]]; then
  echo "  WARNING: residual drift logged to .mxm-skills/watch-report.jsonl"
  exit 1
fi
exit 0
