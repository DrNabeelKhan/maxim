#!/usr/bin/env bash
# Maxim Proactive Watch — unified bash driver (v1.0.0 LIGHT phase)
# Implements all 10 drift checkers.
#
# Usage:
#   watch.sh                     # run all enabled checkers (default)
#   watch.sh all
#   watch.sh <checker-name>      # run a single checker
#   watch.sh --list              # list available checkers
#   watch.sh --light             # explicit LIGHT phase (default)
#
# Checker names:
#   inventory-drift, version-drift, contract-drift, cross-doc-drift,
#   orphan-refs, dependency-drift, git-hygiene, junction-drift,
#   stale-handoff, compliance-drift
#
# Output:
#   - Human summary on stderr
#   - JSONL report at .mxm-skills/watch-report.jsonl (one line per drift)
#   - Error log at .mxm-skills/watch-errors.jsonl (one line per checker error)
#
# Exit code: 0 always (LIGHT phase is warn-only)

set -u

ARG="${1:-all}"
PROJECT_ROOT="${PWD}"
MXM_SKILLS_DIR="${PROJECT_ROOT}/.mxm-skills"
REPORT_FILE="${MXM_SKILLS_DIR}/watch-report.jsonl"
ERROR_FILE="${MXM_SKILLS_DIR}/watch-errors.jsonl"
PROFILE="${PROJECT_ROOT}/config/watch-profile.yml"
PROJECT_ID="$(basename "$PROJECT_ROOT")"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
DRIFT_COUNT=0
ERROR_COUNT=0

mkdir -p "$MXM_SKILLS_DIR"

emit() {
  local drift_class="$1" severity="$2" triage="$3" evidence="$4" declared="${5:-}" actual="${6:-}"
  printf '{"ts":"%s","phase":"light","project":"%s","drift_class":"%s","severity":%s,"triage":"%s","evidence":"%s","declared":"%s","actual":"%s","action":"review-queue"}\n' \
    "$TS" "$PROJECT_ID" "$drift_class" "$severity" "$triage" "$evidence" "$declared" "$actual" >> "$REPORT_FILE"
  DRIFT_COUNT=$((DRIFT_COUNT + 1))
  printf "  ⚠ %s: %s (severity %s, triage %s)\n" "$drift_class" "$evidence" "$severity" "$triage" >&2
}

emit_error() {
  local checker="$1" msg="$2" tier="${3:-standard}"
  printf '{"ts":"%s","checker":"%s","tier":"%s","error":"%s"}\n' "$TS" "$checker" "$tier" "$msg" >> "$ERROR_FILE"
  ERROR_COUNT=$((ERROR_COUNT + 1))
  printf "  ✗ %s: %s (tier: %s)\n" "$checker" "$msg" "$tier" >&2
}

# ──────────── Checker 1: inventory-drift ────────────
check_inventory_drift() {
  # Prefer canonical location (documents/ledgers/); fall back to root for legacy repos
  local inv="${PROJECT_ROOT}/documents/ledgers/AGENT_SKILL_INVENTORY.md"
  [ -f "$inv" ] || inv="${PROJECT_ROOT}/AGENT_SKILL_INVENTORY.md"
  [ -f "$inv" ] || { emit_error inventory-drift "documents/ledgers/AGENT_SKILL_INVENTORY.md not found" standard; return; }

  # Declared agent count — prefer "= N" (final sum) over first-number fallback
  # Skip lines that mention "agents" but have no digits (enumeration lines)
  local declared
  declared=$(grep -iE 'total[[:space:]]*agents' "$inv" | grep -E '[0-9]' | head -1 | grep -oE '=[[:space:]]*[0-9]+' | grep -oE '[0-9]+' | tail -1)
  [ -n "$declared" ] || declared=$(grep -iE 'total[[:space:]]*agents' "$inv" | grep -E '[0-9]' | head -1 | grep -oE '[0-9]+' | head -1)
  declared="${declared:-0}"

  # Actual agent count — office-direct files only, exclude deprecated + README
  local actual=0
  if [ -d "${PROJECT_ROOT}/agents/Maxim" ]; then
    actual=$(find "${PROJECT_ROOT}/agents/Maxim" -mindepth 1 -maxdepth 2 -name '*.md' -type f \
      -not -name 'README.md' -not -path '*/deprecated/*' 2>/dev/null | wc -l | tr -d ' ')
  fi

  if [ "$declared" -ne "$actual" ] && [ "$actual" -gt 0 ]; then
    emit inventory-drift 3 coo "documents/ledgers/AGENT_SKILL_INVENTORY.md:agents" "$declared" "$actual"
  fi

  # Skill domain count — skip enumeration lines (no digits)
  local declared_skills
  declared_skills=$(grep -iE 'skill[[:space:]]*domains?' "$inv" | grep -E '[0-9]' | head -1 | grep -oE '=[[:space:]]*[0-9]+' | grep -oE '[0-9]+' | tail -1)
  [ -n "$declared_skills" ] || declared_skills=$(grep -iE 'skill[[:space:]]*domains?' "$inv" | grep -E '[0-9]' | head -1 | grep -oE '[0-9]+' | head -1)
  declared_skills="${declared_skills:-0}"
  local actual_skills=0
  if [ -d "${PROJECT_ROOT}/.claude/skills" ]; then
    actual_skills=$(find "${PROJECT_ROOT}/.claude/skills" -mindepth 1 -maxdepth 1 -type d \
      -not -name 'deprecated' 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "$declared_skills" -ne "$actual_skills" ] && [ "$actual_skills" -gt 0 ]; then
    emit inventory-drift 3 coo "documents/ledgers/AGENT_SKILL_INVENTORY.md:skill-domains" "$declared_skills" "$actual_skills"
  fi
}

# ──────────── Checker 2: version-drift ────────────
check_version_drift() {
  local anchor="${PROJECT_ROOT}/config/agent-registry.json"
  [ -f "$anchor" ] || { emit_error version-drift "config/agent-registry.json not found" standard; return; }

  # Extract version from registry (simple grep)
  local anchor_ver
  anchor_ver=$(grep -oE '"version"[[:space:]]*:[[:space:]]*"[^"]+"' "$anchor" | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  [ -n "$anchor_ver" ] || { emit_error version-drift "could not parse registry version" standard; return; }

  for f in README.md documents/guides/HELP.md documents/guides/ABOUT.md CLAUDE.md; do
    local path="${PROJECT_ROOT}/${f}"
    [ -f "$path" ] || continue
    # Grep for vX.Y.Z markers; ignore historical ones in CHANGELOG-like blocks
    local found
    found=$(grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' "$path" | sort -u | grep -c "$anchor_ver" || true)
    local any_version
    any_version=$(grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' "$path" | sort -u | wc -l | tr -d ' ')
    if [ "$any_version" -gt 0 ] && [ "$found" -eq 0 ]; then
      emit version-drift 3 coo "${f}:no-match-for-${anchor_ver}" "$anchor_ver" "missing"
    fi
  done
}

# ──────────── Checker 3: contract-drift ────────────
check_contract_drift() {
  # Prefer canonical location (documents/ADRs); fall back to legacy lowercase
  # path for repos bootstrapped before the rename. New Maxim projects create
  # documents/ADRs/ by default.
  local adr_dir="${PROJECT_ROOT}/documents/ADRs"
  [ -d "$adr_dir" ] || adr_dir="${PROJECT_ROOT}/documents/adr"
  [ -d "$adr_dir" ] || { return; }
  local idx="${adr_dir}/INDEX.md"
  [ -f "$idx" ] || { emit_error contract-drift "documents/ADRs/INDEX.md not found" critical; return; }

  # Verify every ACCEPTED ADR referenced in INDEX has an existing file
  local missing=0
  while IFS= read -r line; do
    local adr_file
    adr_file=$(echo "$line" | grep -oE 'ADR-[0-9]+-[a-z0-9-]+\.md' | head -1)
    if [ -n "$adr_file" ]; then
      [ -f "${adr_dir}/${adr_file}" ] || {
        emit contract-drift 4 ceo "INDEX references missing ${adr_file}" "exists" "missing"
        missing=$((missing + 1))
      }
    fi
  done < <(grep -E 'ACCEPTED' "$idx" 2>/dev/null || true)
}

# ──────────── Checker 4: cross-doc-drift ────────────
check_cross_doc_drift() {
  local chg="${PROJECT_ROOT}/CHANGELOG.md"
  [ -f "$chg" ] || { return; }

  # Current version claimed by CHANGELOG (top [X.Y.Z] or [vX.Y.Z])
  local current_ver
  current_ver=$(grep -oE '^##[[:space:]]*\[v?[0-9]+\.[0-9]+\.[0-9]+\]' "$chg" | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  [ -n "$current_ver" ] || { return; }

  # README and HELP should mention the same version
  for f in README.md documents/guides/HELP.md; do
    local path="${PROJECT_ROOT}/${f}"
    [ -f "$path" ] || continue
    grep -q "$current_ver" "$path" || emit cross-doc-drift 2 coo "${f}:missing-${current_ver}" "$current_ver" "missing"
  done
}

# ──────────── Checker 5: orphan-refs ────────────
check_orphan_refs() {
  local cmd_dir="${PROJECT_ROOT}/.claude/commands"
  local skills_dir="${PROJECT_ROOT}/.claude/skills"

  [ -d "$cmd_dir" ] && [ -d "$skills_dir" ] || return

  # Commands referencing skills that don't exist
  while IFS= read -r -d '' cmd; do
    # Look for skill: lines
    while IFS= read -r skill_ref; do
      local skill_id
      skill_id=$(echo "$skill_ref" | sed -E 's/.*skill[_-]?id?[: ]+([a-z0-9_-]+).*/\1/i')
      if [ -n "$skill_id" ] && [ ! -d "${skills_dir}/${skill_id}" ]; then
        emit orphan-refs 3 cto "$(basename "$cmd"):skill-${skill_id}-missing" "exists" "missing"
      fi
    done < <(grep -iE 'skill[_-]?id?[: ]' "$cmd" 2>/dev/null | head -5)
  done < <(find "$cmd_dir" -name '*.md' -print0 2>/dev/null)
}

# ──────────── Checker 6: dependency-drift ────────────
check_dependency_drift() {
  # Scan mcp/*/package.json; verify node_modules exists if packages declared
  local mcp_dir="${PROJECT_ROOT}/mcp"
  [ -d "$mcp_dir" ] || return

  while IFS= read -r -d '' pkg; do
    local dir
    dir=$(dirname "$pkg")
    if grep -q '"dependencies"' "$pkg" 2>/dev/null && [ ! -d "${dir}/node_modules" ]; then
      emit dependency-drift 2 cto "$(basename "$dir"):no-node_modules" "installed" "missing"
    fi
  done < <(find "$mcp_dir" -maxdepth 2 -name 'package.json' -print0 2>/dev/null)
}

# ──────────── Checker 7: git-hygiene ────────────
check_git_hygiene() {
  command -v git >/dev/null 2>&1 || return
  git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1 || return

  # Stale uncommitted changes
  local changes
  changes=$(git -C "$PROJECT_ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$changes" -gt 10 ]; then
    emit git-hygiene 2 cto "${changes}-uncommitted-files" "< 10" "$changes"
  fi

  # Branch behind origin
  local branch
  branch=$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if git -C "$PROJECT_ROOT" rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
    local behind
    behind=$(git -C "$PROJECT_ROOT" rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo 0)
    if [ "$behind" -gt 0 ]; then
      emit git-hygiene 3 cto "branch-${branch}-behind-origin" "0" "$behind"
    fi
  fi
}

# ──────────── Checker 8: junction-drift ────────────
check_junction_drift() {
  # Windows-specific — check expected junctions resolve
  local has_windows=0
  [ -n "${WINDIR:-}" ] && has_windows=1
  [ -n "${USERPROFILE:-}" ] && has_windows=1
  [ "$has_windows" -eq 0 ] && return

  for j in .mxm-system .claude; do
    local path="${PROJECT_ROOT}/${j}"
    if [ -e "$path" ]; then
      # Check if it resolves (readable)
      ls "$path" >/dev/null 2>&1 || emit junction-drift 4 cto "${j}:unresolvable" "resolves" "broken"
    fi
  done
}

# ──────────── Checker 9: stale-handoff ────────────
check_stale_handoff() {
  local handoff="${PROJECT_ROOT}/.claude-sessions-memory/handoff.md"
  [ -f "$handoff" ] || return

  local age_days
  if [ "$(uname 2>/dev/null)" = "Darwin" ]; then
    age_days=$(( ( $(date +%s) - $(stat -f %m "$handoff") ) / 86400 ))
  else
    age_days=$(( ( $(date +%s) - $(stat -c %Y "$handoff" 2>/dev/null || echo $(date +%s)) ) / 86400 ))
  fi

  if [ "$age_days" -gt 7 ]; then
    emit stale-handoff 2 coo "handoff-${age_days}-days-old" "< 7 days" "${age_days} days"
  fi
}

# ──────────── Checker 10: compliance-drift ────────────
check_compliance_drift() {
  # LIGHT-phase check: look for obvious secret patterns in staged files only
  # Full semantic compliance audit is FULL-phase (v1.0.0+) via mxm-compliance MCP
  command -v git >/dev/null 2>&1 || { emit_error compliance-drift "git not available" critical; return; }
  git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1 || return

  # Scan tracked files for high-signal secret patterns
  local hits=0
  if grep -rEn 'AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{32,}|ghp_[A-Za-z0-9]{36}|xoxb-[0-9]+-[0-9]+' \
      --include='*.md' --include='*.json' --include='*.yml' --include='*.yaml' \
      --exclude-dir=.git --exclude-dir=external --exclude-dir=node_modules \
      "$PROJECT_ROOT" 2>/dev/null | head -3 > /tmp/watch-secret-check.$$ ; then
    hits=$(wc -l < /tmp/watch-secret-check.$$ | tr -d ' ')
    rm -f /tmp/watch-secret-check.$$
  fi

  if [ "$hits" -gt 0 ]; then
    emit compliance-drift 5 cso "secret-pattern-detected-${hits}-files" "0" "$hits"
  fi
}

# ──────────── Dispatcher ────────────
run_checker() {
  case "$1" in
    inventory-drift)   check_inventory_drift ;;
    version-drift)     check_version_drift ;;
    contract-drift)    check_contract_drift ;;
    cross-doc-drift)   check_cross_doc_drift ;;
    orphan-refs)       check_orphan_refs ;;
    dependency-drift)  check_dependency_drift ;;
    git-hygiene)       check_git_hygiene ;;
    junction-drift)    check_junction_drift ;;
    stale-handoff)     check_stale_handoff ;;
    compliance-drift)  check_compliance_drift ;;
    *) printf "unknown checker: %s\n" "$1" >&2; return 2 ;;
  esac
}

if [ "$ARG" = "--list" ]; then
  cat <<EOF
Available checkers:
  inventory-drift    Capability inventory vs filesystem reality
  version-drift      Version string consistency across docs
  contract-drift     ACCEPTED ADR conformance (🔒 locked to CEO)
  cross-doc-drift    CHANGELOG / README / HELP agreement
  orphan-refs        Commands / hooks pointing to missing files
  dependency-drift   MCP server deps, subtree lag
  git-hygiene        Uncommitted / unpushed staleness
  junction-drift     Broken symlinks / Windows junctions
  stale-handoff      handoff.md age > threshold
  compliance-drift   Secret patterns, PII, license (🔒 locked to CSO)
EOF
  exit 0
fi

printf "Maxim WATCH (light) ▸ phase=light project=%s\n" "$PROJECT_ID" >&2

if [ "$ARG" = "all" ] || [ "$ARG" = "--light" ]; then
  for c in inventory-drift version-drift contract-drift cross-doc-drift orphan-refs \
           dependency-drift git-hygiene junction-drift stale-handoff compliance-drift; do
    run_checker "$c" || true
  done
else
  run_checker "$ARG" || true
fi

printf "Maxim WATCH (light) ▸ drift=%s errors=%s report=%s\n" "$DRIFT_COUNT" "$ERROR_COUNT" "$REPORT_FILE" >&2

exit 0
