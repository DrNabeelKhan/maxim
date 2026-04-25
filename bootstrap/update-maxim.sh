#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# =============================================================================
# Maxim Project Update & Migration Tool (Bash)
# Version: 1.0.0  |  Maxim v1.0.0
# Platform: macOS, Linux, WSL
# Requires: bash 4+, jq (recommended) or node (fallback)
# Usage:
#   bash bootstrap/update-maxim.sh                    # interactive
#   bash bootstrap/update-maxim.sh /path/to/project   # single project
#   bash bootstrap/update-maxim.sh --scan             # auto-discover
#   bash bootstrap/update-maxim.sh --dry-run          # preview only
#   bash bootstrap/update-maxim.sh --yes              # skip confirmations
# =============================================================================

set -euo pipefail

# ---- Colors -----------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DARK_GRAY='\033[0;90m'
DARK_GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# ---- Helpers ----------------------------------------------------------------
info()    { echo -e "${BLUE}[Maxim]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC}   $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

# ---- Resolve Maxim repo root (script lives in bootstrap/) --------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MXM_ROOT="$(dirname "$SCRIPT_DIR")"

# ---- Parse CLI flags --------------------------------------------------------
DRY_RUN=false
AUTO_SCAN=false
SKIP_CONFIRM=false
SINGLE_PATH=""

for arg in "$@"; do
  case "$arg" in
    --dry-run)  DRY_RUN=true  ;;
    --scan)     AUTO_SCAN=true ;;
    --yes|-y)   SKIP_CONFIRM=true ;;
    --*)        warn "Unknown flag: $arg" ;;
    *)
      # Treat the first non-flag argument as a project path
      if [[ -z "$SINGLE_PATH" ]]; then
        SINGLE_PATH="$arg"
      fi
      ;;
  esac
done

# ---- Read Maxim version from agent-registry.json -----------------------------
REGISTRY_PATH="${MXM_ROOT}/config/agent-registry.json"
if [[ ! -f "$REGISTRY_PATH" ]]; then
  echo ""
  echo -e "${RED}ERROR: config/agent-registry.json not found at: ${REGISTRY_PATH}${NC}"
  echo -e "${YELLOW}       Is this script running from inside the maxim repo?${NC}"
  echo ""
  exit 1
fi

TARGET_VERSION=""
if command -v jq &>/dev/null; then
  TARGET_VERSION=$(jq -r '.version // empty' "$REGISTRY_PATH" 2>/dev/null)
elif command -v node &>/dev/null; then
  TARGET_VERSION=$(MXM_FILE="$REGISTRY_PATH" node -e "
    try {
      const r = JSON.parse(require('fs').readFileSync(process.env.MXM_FILE, 'utf8'));
      process.stdout.write(r.version || '');
    } catch(e) { process.exit(1); }
  " 2>/dev/null)
fi

if [[ -z "$TARGET_VERSION" ]]; then
  echo -e "${RED}ERROR: Could not read 'version' from config/agent-registry.json${NC}"
  echo -e "${YELLOW}       Install jq (brew install jq) or node, then retry.${NC}"
  exit 1
fi

# ---- Read template manifest -------------------------------------------------
TEMPLATE_PATH="${MXM_ROOT}/config/project-manifest.TEMPLATE.json"
HAS_TEMPLATE=false
if [[ -f "$TEMPLATE_PATH" ]]; then
  HAS_TEMPLATE=true
fi

TODAY=$(date +%Y-%m-%d)
NEXT_REVIEW=$(date -d '+3 months' +%Y-%m-%d 2>/dev/null || \
              date -v+3m +%Y-%m-%d 2>/dev/null || \
              echo "TBD")

# ---- Banner -----------------------------------------------------------------
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Maxim Update Tool v1.0.0  |  Target version: ${TARGET_VERSION}        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Maxim source : ${MXM_ROOT}"
if [[ "$DRY_RUN" == true ]]; then
  echo -e "  ${YELLOW}Mode        : DRY RUN — no files will be written${NC}"
fi
echo ""

# =============================================================================
# JSON UTILITIES
# =============================================================================

# Extract a top-level string field from a JSON file using jq or node
json_get() {
  local file="$1"
  local field="$2"
  if command -v jq &>/dev/null; then
    jq -r --arg f "$field" '.[$f] // empty' "$file" 2>/dev/null || true
  elif command -v node &>/dev/null; then
    MXM_FILE="$file" MXM_FIELD="$field" node -e "
      try {
        const obj = JSON.parse(require('fs').readFileSync(process.env.MXM_FILE, 'utf8'));
        process.stdout.write(String(obj[process.env.MXM_FIELD] || ''));
      } catch(e) {}
    " 2>/dev/null || true
  fi
}

# Deep-merge: template fields into project manifest.
# project always wins on conflicts; only missing keys are added from template.
merge_manifest() {
  local project_manifest="$1"
  local template_manifest="$2"
  local output="$3"

  if command -v jq &>/dev/null; then
    # jq deep merge: template * project (project wins because it is second)
    jq -s '
      def deepmerge(a; b):
        a as $a | b as $b |
        if ($a | type) == "object" and ($b | type) == "object" then
          reduce ($a | keys_unsorted[]) as $k (
            $b;
            if has($k) then
              if (.[$k] | type) == "object" and ($a[$k] | type) == "object" then
                .[$k] = deepmerge($a[$k]; .[$k])
              else
                .
              end
            else
              .[$k] = $a[$k]
            end
          )
        else
          $b
        end;
      deepmerge(.[0]; .[1])
    ' "$template_manifest" "$project_manifest" > "$output"
  elif command -v node &>/dev/null; then
    MXM_TMPL="$template_manifest" MXM_PROJ="$project_manifest" MXM_OUT="$output" node -e "
      const fs = require('fs');
      let template, project;
      try {
        template = JSON.parse(fs.readFileSync(process.env.MXM_TMPL, 'utf8'));
      } catch(e) {
        console.error('ERROR: Cannot parse template manifest: ' + e.message);
        process.exit(1);
      }
      try {
        project = JSON.parse(fs.readFileSync(process.env.MXM_PROJ, 'utf8'));
      } catch(e) {
        console.error('ERROR: Cannot parse project manifest: ' + e.message);
        process.exit(1);
      }
      function deepMerge(target, source) {
        // source (project) wins: only add keys from target (template) that are absent
        for (const key in target) {
          if (!(key in source)) {
            source[key] = target[key];
          } else if (
            typeof target[key] === 'object' &&
            !Array.isArray(target[key]) &&
            target[key] !== null &&
            typeof source[key] === 'object' &&
            !Array.isArray(source[key]) &&
            source[key] !== null
          ) {
            deepMerge(target[key], source[key]);
          }
          // If key exists in source (project), keep it as-is
        }
        return source;
      }
      const merged = deepMerge(template, project);
      fs.writeFileSync(process.env.MXM_OUT, JSON.stringify(merged, null, 2) + '\n');
    " 2>/dev/null
  else
    warn "Neither jq nor node found — cannot merge JSON. Install one: brew install jq"
    return 1
  fi
}

# Validate that a file contains valid JSON
json_valid() {
  local file="$1"
  if command -v jq &>/dev/null; then
    jq empty "$file" 2>/dev/null && return 0 || return 1
  elif command -v node &>/dev/null; then
    MXM_FILE="$file" node -e \
      "JSON.parse(require('fs').readFileSync(process.env.MXM_FILE, 'utf8'))" \
      2>/dev/null && return 0 || return 1
  fi
  # No validator available — assume valid
  return 0
}

# Inject or update a top-level string field in a JSON file (in-place)
json_set_field() {
  local file="$1"
  local field="$2"
  local value="$3"
  local tmp
  tmp=$(mktemp)

  if command -v jq &>/dev/null; then
    jq --arg f "$field" --arg v "$value" '.[$f] = $v' "$file" > "$tmp" && mv "$tmp" "$file"
  elif command -v node &>/dev/null; then
    MXM_FILE="$file" MXM_FIELD="$field" MXM_VALUE="$value" node -e "
      const fs = require('fs');
      const obj = JSON.parse(fs.readFileSync(process.env.MXM_FILE, 'utf8'));
      obj[process.env.MXM_FIELD] = process.env.MXM_VALUE;
      fs.writeFileSync(process.env.MXM_FILE, JSON.stringify(obj, null, 2) + '\n');
    " 2>/dev/null
    rm -f "$tmp"
  fi
}

# Ensure a nested object field exists (e.g. super_user block)
json_ensure_super_user() {
  local file="$1"
  local tmp
  tmp=$(mktemp)

  if command -v jq &>/dev/null; then
    jq '
      if has("super_user") then .
      else . + {
        "super_user": {
          "enabled": false,
          "identity": "",
          "bypass": {
            "cso_auto_loop": false,
            "ethics_gate": false,
            "compliance_pre_check": false,
            "confidence_tagging": false,
            "escalation_required": false
          },
          "note": "Set enabled: true and identity to activate super user mode."
        }
      }
      end
    ' "$file" > "$tmp" && mv "$tmp" "$file"
  elif command -v node &>/dev/null; then
    MXM_FILE="$file" node -e "
      const fs = require('fs');
      const obj = JSON.parse(fs.readFileSync(process.env.MXM_FILE, 'utf8'));
      if (!('super_user' in obj)) {
        obj['super_user'] = {
          enabled: false,
          identity: '',
          bypass: {
            cso_auto_loop: false,
            ethics_gate: false,
            compliance_pre_check: false,
            confidence_tagging: false,
            escalation_required: false
          },
          note: 'Set enabled: true and identity to activate super user mode.'
        };
      }
      fs.writeFileSync(process.env.MXM_FILE, JSON.stringify(obj, null, 2) + '\n');
    " 2>/dev/null
    rm -f "$tmp"
  fi
}

# =============================================================================
# INSTALL MODE DETECTION
# =============================================================================

get_install_mode() {
  local project_path="$1"
  local mxm_system="${project_path}/.mxm-skills"
  local claude_local="${project_path}/.claude"
  local global_claude="${HOME}/.claude/CLAUDE.md"

  if [[ -d "$mxm_system" ]]; then
    echo "LEGACY"
  elif [[ -f "$global_claude" ]] && [[ ! -d "$claude_local" ]]; then
    echo "GLOBAL"
  elif [[ -d "$claude_local" ]]; then
    echo "LEGACY-DIRECT"
  else
    echo "UNKNOWN"
  fi
}

# =============================================================================
# VERSION COMPARISON
# Prints: -1 (current < target), 0 (equal), 1 (current > target)
# =============================================================================

compare_versions() {
  local current="$1"
  local target="$2"

  # Normalize: strip 'v' prefix if present
  current="${current#v}"
  target="${target#v}"

  if [[ "$current" == "$target" ]]; then
    echo 0
    return
  fi

  # Split into numeric parts
  IFS='.' read -ra C <<< "$current"
  IFS='.' read -ra T <<< "$target"

  local max_len=$(( ${#C[@]} > ${#T[@]} ? ${#C[@]} : ${#T[@]} ))

  for (( i=0; i<max_len; i++ )); do
    local c_part="${C[$i]:-0}"
    local t_part="${T[$i]:-0}"

    # Only compare numeric parts
    if ! [[ "$c_part" =~ ^[0-9]+$ ]]; then c_part=0; fi
    if ! [[ "$t_part" =~ ^[0-9]+$ ]]; then t_part=0; fi

    if (( c_part < t_part )); then
      echo -1
      return
    elif (( c_part > t_part )); then
      echo 1
      return
    fi
  done

  echo 0
}

# =============================================================================
# STEP 1 — PROJECT DISCOVERY
# =============================================================================

find_projects_in_path() {
  local base_path="$1"
  local max_depth="${2:-3}"

  [[ -d "$base_path" ]] || return 0

  # Find all project-manifest.json files, excluding noise directories
  find "$base_path" \
    -maxdepth "$(( max_depth + 1 ))" \
    -name "project-manifest.json" \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    -not -path "*/.mxm-skills/*" \
    2>/dev/null | \
  while IFS= read -r manifest_file; do
    # Must be inside a config/ directory
    local dir
    dir=$(dirname "$manifest_file")
    [[ "$(basename "$dir")" == "config" ]] || continue

    # Project root = parent of config/
    local project_root
    project_root=$(dirname "$dir")

    # Skip if this is the Maxim repo itself
    local real_project real_Maxim
    real_project=$(cd "$project_root" 2>/dev/null && pwd)
    real_Maxim=$(cd "$MXM_ROOT" 2>/dev/null && pwd)
    [[ "$real_project" == "$real_Maxim" ]] && continue

    echo "$project_root"
  done | sort -u
}

discover_projects_interactive() {
  local -a confirmed_paths=()

  # If a single path was passed on the CLI, use it directly
  if [[ -n "$SINGLE_PATH" ]]; then
    if [[ -d "$SINGLE_PATH" ]]; then
      confirmed_paths+=("$(cd "$SINGLE_PATH" && pwd)")
    else
      error "Path not found: ${SINGLE_PATH}"
    fi
    printf '%s\n' "${confirmed_paths[@]}"
    return
  fi

  if [[ "$AUTO_SCAN" == true ]]; then
    local mode="scan"
  else
    echo -e "${BOLD}How would you like to find projects to update?${NC}"
    echo ""
    echo -e "  ${CYAN}1) Auto-scan${NC}  — search common project locations"
    echo -e "  ${CYAN}2) Enter paths${NC} — type paths manually, one per line"
    echo ""
    read -rp "Choice [1/2]: " mode_choice
    mode_choice="${mode_choice:-1}"
    if [[ "$mode_choice" == "2" ]]; then
      local mode="manual"
    else
      local mode="scan"
    fi
  fi

  if [[ "$mode" == "manual" ]]; then
    echo ""
    echo "Enter project paths (one per line). Press Enter on an empty line when done:"
    while true; do
      read -rp "  Path: " line
      line="${line:-}"
      [[ -z "$line" ]] && break
      # Expand ~ manually
      line="${line/#\~/$HOME}"
      if [[ -d "$line" ]]; then
        confirmed_paths+=("$(cd "$line" && pwd)")
        echo -e "    ${DARK_GRAY}Added: $line${NC}"
      else
        warn "Path not found — skipped: $line"
      fi
    done
  else
    # Auto-scan
    echo ""
    echo "Scanning common project locations..."

    local -a scan_bases=()
    scan_bases+=(
      "${HOME}/Projects"
      "${HOME}/projects"
      "${HOME}/dev"
      "${HOME}/code"
    )
    # On WSL / Windows-path-accessible environments, also check Windows paths
    if [[ -d "/mnt/e/Projects" ]]; then
      scan_bases+=("/mnt/e/Projects")
    fi
    if [[ -d "/mnt/c/Projects" ]]; then
      scan_bases+=("/mnt/c/Projects")
    fi

    local -a scanned=()
    for base in "${scan_bases[@]}"; do
      echo -e "  ${DARK_GRAY}Scanning: $base${NC}"
      while IFS= read -r found_path; do
        [[ -n "$found_path" ]] && scanned+=("$found_path")
      done < <(find_projects_in_path "$base" 3)
    done

    # Deduplicate
    local -a unique_scanned=()
    while IFS= read -r line; do
      unique_scanned+=("$line")
    done < <(printf '%s\n' "${scanned[@]}" | sort -u)

    if [[ ${#unique_scanned[@]} -eq 0 ]]; then
      echo ""
      warn "No Maxim projects found via auto-scan."
      echo "  Try running: bash bootstrap/update-maxim.sh /path/to/your/project"
      echo ""
      printf ''
      return
    fi

    echo ""
    echo -e "${GREEN}Found ${#unique_scanned[@]} Maxim project(s):${NC}"
    local i=1
    for p in "${unique_scanned[@]}"; do
      echo -e "  [${i}] ${p}"
      (( i++ ))
    done
    echo ""
    echo -e "  ${DARK_GRAY}Press Enter  → confirm all${NC}"
    echo -e "  ${DARK_GRAY}Type numbers → e.g. '1,3' to select specific projects${NC}"
    echo -e "  ${DARK_GRAY}Type 'add'   → add extra paths after confirming all${NC}"
    echo ""
    read -rp "Selection: " selection
    selection="${selection:-}"

    if [[ -z "$selection" ]]; then
      # Confirm all
      confirmed_paths=("${unique_scanned[@]}")
    elif [[ "$selection" == "add" ]]; then
      confirmed_paths=("${unique_scanned[@]}")
      echo "Enter additional paths (empty line to finish):"
      while true; do
        read -rp "  Path: " extra
        extra="${extra:-}"
        [[ -z "$extra" ]] && break
        extra="${extra/#\~/$HOME}"
        if [[ -d "$extra" ]]; then
          confirmed_paths+=("$(cd "$extra" && pwd)")
        else
          warn "Not found — skipped: $extra"
        fi
      done
    else
      # Parse comma/space-separated numbers
      IFS=', ' read -ra nums <<< "$selection"
      for n in "${nums[@]}"; do
        if [[ "$n" =~ ^[0-9]+$ ]]; then
          local idx=$(( n - 1 ))
          if (( idx >= 0 && idx < ${#unique_scanned[@]} )); then
            confirmed_paths+=("${unique_scanned[$idx]}")
          fi
        fi
      done

      read -rp "Add more paths? (y/N): " add_more
      if [[ "${add_more:-N}" =~ ^[Yy]$ ]]; then
        echo "Enter additional paths (empty line to finish):"
        while true; do
          read -rp "  Path: " extra
          extra="${extra:-}"
          [[ -z "$extra" ]] && break
          extra="${extra/#\~/$HOME}"
          if [[ -d "$extra" ]]; then
            confirmed_paths+=("$(cd "$extra" && pwd)")
          else
            warn "Not found — skipped: $extra"
          fi
        done
      fi
    fi
  fi

  printf '%s\n' "${confirmed_paths[@]}" | sort -u
}

# =============================================================================
# STEP 2 — INTELLIGENCE SCAN
# =============================================================================

# Scan a single project and write a set of variables into the scan_* globals.
# Because bash can't return structured data, we use a temporary associative
# array written to a temp file and sourced by the caller.

scan_project() {
  local project_path="$1"
  local out_file="$2"   # temp file to write scan results to (key=value format)

  local project_name
  project_name=$(basename "$project_path")

  # ── Install mode ──────────────────────────────────────────────────────────
  local install_mode
  install_mode=$(get_install_mode "$project_path")

  # ── Core config files ─────────────────────────────────────────────────────
  local manifest_path="${project_path}/config/project-manifest.json"
  local claude_project_path="${project_path}/CLAUDE.project.md"
  local local_registry_path="${project_path}/config/agent-registry.json"

  local has_manifest=false
  local has_claude_project=false
  local has_local_registry=false
  local current_version="unknown"
  local manifest_project_id=""
  local manifest_compliance="[]"

  if [[ -f "$manifest_path" ]]; then
    has_manifest=true
    # Read version
    if command -v jq &>/dev/null; then
      current_version=$(jq -r '
        if .mxm_version and (.mxm_version | length) > 0 then .mxm_version
        elif .version and (.version | length) > 0 then .version
        else "unknown"
        end
      ' "$manifest_path" 2>/dev/null || echo "unknown")
      manifest_project_id=$(jq -r '.project.id // "not set"' "$manifest_path" 2>/dev/null || echo "not set")
      manifest_compliance=$(jq -c '.compliance.frameworks // []' "$manifest_path" 2>/dev/null || echo "[]")
    elif command -v node &>/dev/null; then
      current_version=$(MXM_FILE="$manifest_path" node -e "
        try {
          const m = JSON.parse(require('fs').readFileSync(process.env.MXM_FILE, 'utf8'));
          process.stdout.write(m.mxm_version || m.version || 'unknown');
        } catch(e) { process.stdout.write('unknown'); }
      " 2>/dev/null || echo "unknown")
      manifest_project_id=$(MXM_FILE="$manifest_path" node -e "
        try {
          const m = JSON.parse(require('fs').readFileSync(process.env.MXM_FILE, 'utf8'));
          process.stdout.write((m.project && m.project.id) ? m.project.id : 'not set');
        } catch(e) { process.stdout.write('not set'); }
      " 2>/dev/null || echo "not set")
    fi
  fi

  [[ -f "$claude_project_path" ]] && has_claude_project=true
  [[ -f "$local_registry_path" ]] && has_local_registry=true

  # ── Planning file discovery ───────────────────────────────────────────────
  # Collect all task_plan.md, progress.md, findings.md locations up to depth 3
  local -a plan_task=()
  local -a plan_progress=()
  local -a plan_findings=()

  while IFS= read -r f; do
    case "$(basename "$f")" in
      task_plan.md) plan_task+=("$f") ;;
      progress.md)  plan_progress+=("$f") ;;
      findings.md)  plan_findings+=("$f") ;;
    esac
  done < <(find "$project_path" \
    -maxdepth 4 \
    \( -name "task_plan.md" -o -name "progress.md" -o -name "findings.md" \) \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    2>/dev/null | sort)

  # ── Session memory detection ──────────────────────────────────────────────
  local has_session_continuity=false
  local legacy_mem_count=0

  [[ -f "${project_path}/SESSION_CONTINUITY.md" ]] && has_session_continuity=true

  for mem_dir in ".claude-sessions-memory" "claude-memory" ".claude-memory"; do
    local d="${project_path}/${mem_dir}"
    if [[ -d "$d" ]]; then
      local cnt
      cnt=$(find "$d" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
      (( legacy_mem_count += cnt )) || true
    fi
  done

  # ── Maxim runtime state ────────────────────────────────────────────────────
  local mxm_dir="${project_path}/.mxm"
  local skill_gap_count=0
  local handoff_status="none"
  local session_file_count=0
  local bg_agent_count=0

  local skill_gaps_path="${mxm_dir}/skill-gaps.log"
  if [[ -f "$skill_gaps_path" ]]; then
    skill_gap_count=$(grep -c '[^[:space:]]' "$skill_gaps_path" 2>/dev/null || echo 0)
  fi

  local handoff_path="${mxm_dir}/handoff.md"
  if [[ -f "$handoff_path" ]]; then
    # Look for a line like "status: READY" or 'status: "BLOCKED"'
    local raw_status
    raw_status=$(grep -oE 'status[[:space:]]*[:=][[:space:]]*"?[A-Z_]+"?' "$handoff_path" 2>/dev/null | head -1 || true)
    if [[ -n "$raw_status" ]]; then
      handoff_status=$(echo "$raw_status" | grep -oE '[A-Z_]{3,}' | head -1 || echo "present")
    else
      handoff_status="present"
    fi
  fi

  if [[ -d "$mxm_dir" ]]; then
    session_file_count=$(find "$mxm_dir" -maxdepth 1 -name "session-*.md" 2>/dev/null | wc -l | tr -d ' ')
  fi

  local bg_log_path="${mxm_dir}/background-agent.log"
  if [[ -f "$bg_log_path" ]]; then
    bg_agent_count=$(wc -l < "$bg_log_path" | tr -d ' ')
  fi

  # ── Phase doc detection ───────────────────────────────────────────────────
  local phase_doc_count
  phase_doc_count=$(find "$project_path" -maxdepth 1 \
    -name "PHASE*_CLI_INSTRUCTIONS.md" \
    -o -name "V1_SPRINT*_CLI_INSTRUCTIONS.md" \
    2>/dev/null | wc -l | tr -d ' ')

  # ── Gaps / Adds ───────────────────────────────────────────────────────────
  local -a gaps=()
  local -a adds=()
  local -a warnings=()

  [[ "$has_manifest" == false ]]       && gaps+=("config/project-manifest.json — missing")
  [[ "$has_claude_project" == false ]] && gaps+=("CLAUDE.project.md — missing")
  [[ "$has_local_registry" == false ]] && adds+=("config/agent-registry.json — will create local copy")

  # Required directories
  for d in ".mxm" ".claude-sessions-memory" "config"; do
    [[ ! -d "${project_path}/${d}" ]] && adds+=("${d}/ — will create")
  done

  # .mxm runtime files
  for af in ".mxm-skills/agents-skill-gaps.log" ".mxm-skills/agents-handoff.md" ".mxm-skills/agents-background.log"; do
    [[ ! -f "${project_path}/${af}" ]] && adds+=("${af} — will create")
  done

  # .claude-sessions-memory files
  for mf in ".claude-sessions-memory/handoff.md" ".claude-sessions-memory/decision-log.md" ".claude-sessions-memory/skill-gaps.log"; do
    [[ ! -f "${project_path}/${mf}" ]] && adds+=("${mf} — will create")
  done

  # .claude.local/settings.local.json
  [[ ! -f "${project_path}/.claude.local/settings.local.json" ]] && \
    adds+=(".claude.local/settings.local.json — will create")

  # Manifest field checks (only if manifest is present and jq/node available)
  if [[ "$has_manifest" == true ]]; then
    local has_super_user=false
    if command -v jq &>/dev/null; then
      jq -e 'has("super_user")' "$manifest_path" &>/dev/null && has_super_user=true
    elif command -v node &>/dev/null; then
      MXM_FILE="$manifest_path" node -e "
        const m = JSON.parse(require('fs').readFileSync(process.env.MXM_FILE, 'utf8'));
        process.exit('super_user' in m ? 0 : 1);
      " 2>/dev/null && has_super_user=true
    fi
    [[ "$has_super_user" == false ]] && gaps+=("super_user — missing (will add: enabled=false)")

    if [[ "$manifest_project_id" == "your-project-id" || -z "$manifest_project_id" ]]; then
      warnings+=("project.id not set — update manually after migration")
    fi
  fi

  # ── Write results to temp file ────────────────────────────────────────────
  {
    echo "SCAN_PROJECT_PATH=$(printf '%q' "$project_path")"
    echo "SCAN_PROJECT_NAME=$(printf '%q' "$project_name")"
    echo "SCAN_INSTALL_MODE=$(printf '%q' "$install_mode")"
    echo "SCAN_CURRENT_VERSION=$(printf '%q' "$current_version")"
    echo "SCAN_HAS_MANIFEST=$has_manifest"
    echo "SCAN_HAS_CLAUDE_PROJECT=$has_claude_project"
    echo "SCAN_HAS_LOCAL_REGISTRY=$has_local_registry"
    echo "SCAN_MANIFEST_PROJECT_ID=$(printf '%q' "$manifest_project_id")"
    echo "SCAN_MANIFEST_COMPLIANCE=$(printf '%q' "$manifest_compliance")"
    echo "SCAN_HAS_SESSION_CONTINUITY=$has_session_continuity"
    echo "SCAN_LEGACY_MEM_COUNT=$legacy_mem_count"
    echo "SCAN_SKILL_GAP_COUNT=$skill_gap_count"
    echo "SCAN_HANDOFF_STATUS=$(printf '%q' "$handoff_status")"
    echo "SCAN_SESSION_FILE_COUNT=$session_file_count"
    echo "SCAN_BG_AGENT_COUNT=$bg_agent_count"
    echo "SCAN_PHASE_DOC_COUNT=$phase_doc_count"

    # Planning file arrays — serialize as colon-separated
    local plan_task_str
    plan_task_str=$(IFS=':'; echo "${plan_task[*]:-}")
    echo "SCAN_PLAN_TASK=$(printf '%q' "$plan_task_str")"
    local plan_progress_str
    plan_progress_str=$(IFS=':'; echo "${plan_progress[*]:-}")
    echo "SCAN_PLAN_PROGRESS=$(printf '%q' "$plan_progress_str")"
    local plan_findings_str
    plan_findings_str=$(IFS=':'; echo "${plan_findings[*]:-}")
    echo "SCAN_PLAN_FINDINGS=$(printf '%q' "$plan_findings_str")"

    # Gaps / Adds / Warnings — newline-separated inside the quoted value
    printf 'SCAN_GAPS=%q\n' "$(IFS=$'\n'; printf '%s' "${gaps[*]:-}")"
    printf 'SCAN_ADDS=%q\n' "$(IFS=$'\n'; printf '%s' "${adds[*]:-}")"
    printf 'SCAN_WARNINGS=%q\n' "$(IFS=$'\n'; printf '%s' "${warnings[*]:-}")"
  } > "$out_file"
}

# =============================================================================
# STEP 3 — DISPLAY GAP REPORT
# =============================================================================

show_project_report() {
  # Caller must have sourced a scan result file first (scan_* variables set)

  local ver_cmp
  ver_cmp=$(compare_versions "$SCAN_CURRENT_VERSION" "$TARGET_VERSION")

  local ver_color="$YELLOW"
  if (( ver_cmp == 0 )); then
    ver_color="$GREEN"
  elif (( ver_cmp > 0 )); then
    ver_color="$CYAN"
  fi

  local project_path="$SCAN_PROJECT_PATH"

  echo ""
  echo -e "${CYAN}┌──────────────────────────────────────────────────────────────┐${NC}"
  printf "${CYAN}│${NC} %-61s ${CYAN}│${NC}\n" "Project: ${SCAN_PROJECT_NAME}"
  printf "${ver_color}│${NC} %-61s ${ver_color}│${NC}\n" \
    "Install: ${SCAN_INSTALL_MODE} | Current: ${SCAN_CURRENT_VERSION} | Target: ${TARGET_VERSION}"
  echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"

  # Manifest info
  printf "${BOLD}│${NC} %-61s ${BOLD}│${NC}\n" "Manifest:"
  if [[ "$SCAN_HAS_MANIFEST" == true ]]; then
    printf "${DARK_GRAY}│${NC}   %-59s ${DARK_GRAY}│${NC}\n" "project.id: ${SCAN_MANIFEST_PROJECT_ID}"
    printf "${DARK_GRAY}│${NC}   %-59s ${DARK_GRAY}│${NC}\n" "compliance.frameworks: ${SCAN_MANIFEST_COMPLIANCE}"
  else
    printf "${YELLOW}│${NC}   %-59s ${YELLOW}│${NC}\n" "(no manifest loaded)"
  fi

  # Gaps
  if [[ -n "$SCAN_GAPS" ]]; then
    while IFS= read -r gap; do
      [[ -z "$gap" ]] && continue
      printf "${YELLOW}│${NC}   %-59s ${YELLOW}│${NC}\n" "WARNING  ${gap}"
    done <<< "$SCAN_GAPS"
  fi
  printf "${CYAN}│${NC} %-61s ${CYAN}│${NC}\n" ""

  # File checks
  printf "${BOLD}│${NC} %-61s ${BOLD}│${NC}\n" "Files:"
  local -a file_checks=(
    "config/project-manifest.json"
    "CLAUDE.project.md"
    ".mxm-skills/agents-skill-gaps.log"
    ".claude-sessions-memory"
    ".claude.local/settings.local.json"
  )
  for fc in "${file_checks[@]}"; do
    if [[ -e "${project_path}/${fc}" ]]; then
      printf "${DARK_GREEN}│${NC}   %-59s ${DARK_GREEN}│${NC}\n" "OK  ${fc}"
    else
      printf "${RED}│${NC}   %-59s ${RED}│${NC}\n" "MISSING  ${fc} — will create"
    fi
  done
  printf "${CYAN}│${NC} %-61s ${CYAN}│${NC}\n" ""

  # Planning files
  printf "${BOLD}│${NC} %-61s ${BOLD}│${NC}\n" "Planning:"
  for file_type in task_plan progress findings; do
    local var_name="SCAN_PLAN_$(echo "$file_type" | tr '[:lower:]' '[:upper:]')"
    local paths_str="${!var_name:-}"

    if [[ -z "$paths_str" ]]; then
      printf "${DARK_GRAY}│${NC}   %-59s ${DARK_GRAY}│${NC}\n" "(no ${file_type}.md found)"
    else
      IFS=':' read -ra paths_arr <<< "$paths_str"
      local count=${#paths_arr[@]}
      if (( count > 1 )); then
        printf "${CYAN}│${NC}   %-59s ${CYAN}│${NC}\n" \
          "MERGE  ${file_type}.md found at ${count} locations — will merge"
      else
        local rel="${paths_arr[0]#"${project_path}/"}"
        printf "${DARK_GREEN}│${NC}   %-59s ${DARK_GREEN}│${NC}\n" "OK  ${file_type}.md at ./${rel}"
      fi
    fi
  done
  printf "${CYAN}│${NC} %-61s ${CYAN}│${NC}\n" ""

  # Session memory
  printf "${BOLD}│${NC} %-61s ${BOLD}│${NC}\n" "Session Memory:"
  if [[ "$SCAN_HAS_SESSION_CONTINUITY" == true ]]; then
    printf "${YELLOW}│${NC}   %-59s ${YELLOW}│${NC}\n" "WARNING  documents/ledgers/SESSION_CONTINUITY.md found — will preserve"
  fi
  if (( SCAN_LEGACY_MEM_COUNT > 0 )); then
    printf "${DARK_GRAY}│${NC}   %-59s ${DARK_GRAY}│${NC}\n" \
      "Legacy memory files detected: ${SCAN_LEGACY_MEM_COUNT}"
  fi
  printf "${CYAN}│${NC} %-61s ${CYAN}│${NC}\n" ""

  # Runtime summary
  printf "${BOLD}│${NC} %-61s ${BOLD}│${NC}\n" \
    "Skill Gaps: ${SCAN_SKILL_GAP_COUNT} entries | Handoff: ${SCAN_HANDOFF_STATUS} | Sessions: ${SCAN_SESSION_FILE_COUNT}"
  if (( SCAN_PHASE_DOC_COUNT > 0 )); then
    printf "${DARK_GRAY}│${NC} %-61s ${DARK_GRAY}│${NC}\n" \
      "Phase docs: ${SCAN_PHASE_DOC_COUNT} doc(s) found"
  fi

  # Warnings
  if [[ -n "$SCAN_WARNINGS" ]]; then
    while IFS= read -r w; do
      [[ -z "$w" ]] && continue
      printf "${YELLOW}│${NC} %-61s ${YELLOW}│${NC}\n" "WARNING  ${w}"
    done <<< "$SCAN_WARNINGS"
  fi

  echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
}

# =============================================================================
# STEP 4 — MERGE DUPLICATE PLANNING FILES
# =============================================================================

merge_planning_files() {
  local project_path="$1"
  local file_type="$2"
  local paths_str="$3"    # colon-separated list of paths

  [[ -z "$paths_str" ]] && return

  IFS=':' read -ra paths_arr <<< "$paths_str"
  local count=${#paths_arr[@]}
  (( count <= 1 )) && return

  local mem_dir="${project_path}/.claude-sessions-memory"
  local canonical="${mem_dir}/${file_type}.md"
  local backup_date
  backup_date=$(date +%Y-%m-%d)
  local backup_dir="${project_path}/.mxm-backup/merged-${backup_date}"

  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$mem_dir"
    mkdir -p "$backup_dir"
  fi

  # Sort by modification time (oldest first using a temp file with timestamps)
  local -a sorted_paths=()
  while IFS= read -r path_entry; do
    sorted_paths+=("${path_entry}")
  done < <(
    for p in "${paths_arr[@]}"; do
      if [[ -f "$p" ]]; then
        printf '%s\t%s\n' "$(date -r "$p" +%s 2>/dev/null || stat -c %Y "$p" 2>/dev/null || echo 0)" "$p"
      fi
    done | sort -n | cut -f2-
  )

  # Build merged content
  local ts
  ts=$(date '+%Y-%m-%d %H:%M')
  local merged_content="# ${file_type} — Merged by Maxim Update Tool ${ts}"$'\n\n'

  for p in "${sorted_paths[@]}"; do
    local rel="${p#"${project_path}/"}"
    merged_content+="# --- Merged from: ./${rel} ---"$'\n'
    if [[ -f "$p" ]]; then
      merged_content+=$(cat "$p" 2>/dev/null || echo "(could not read)")
      merged_content+=$'\n\n'
    fi
  done

  if [[ "$DRY_RUN" == false ]]; then
    printf '%s' "$merged_content" > "$canonical"

    # Backup originals
    local merge_log="${backup_dir}/MERGE_LOG.md"
    for p in "${sorted_paths[@]}"; do
      local backup_name="${p#"${project_path}/"}"
      backup_name="${backup_name//\//_}"
      cp "$p" "${backup_dir}/${backup_name}" 2>/dev/null || true
    done

    cat >> "$merge_log" <<MERGE_EOF

## ${file_type}.md merge — ${ts}
Sources   : $(IFS=', '; echo "${sorted_paths[*]}")
Canonical : ${canonical}
Maxim ver  : ${TARGET_VERSION}
MERGE_EOF

    echo -e "    ${CYAN}MERGED${NC}  ${count} copies of ${file_type}.md -> .claude-sessions-memory/"
  else
    echo -e "    ${DARK_GRAY}DryRun: would merge ${count} copies of ${file_type}.md -> .claude-sessions-memory/${NC}"
  fi

  # Scan for stale references in .md files
  local -a stale_refs=()
  while IFS= read -r md_file; do
    if grep -qE "planning/${file_type}\.md|\./${file_type}\.md" "$md_file" 2>/dev/null; then
      local md_rel="${md_file#"${project_path}/"}"
      stale_refs+=("  Stale ref in ${md_rel} -> '.claude-sessions-memory/${file_type}.md'")
    fi
  done < <(find "$project_path" -maxdepth 3 -name "*.md" \
    -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null)

  for ref in "${stale_refs[@]}"; do
    echo -e "  ${YELLOW}${ref}${NC}"
  done
}

# =============================================================================
# STEP 5 — APPLY UPDATES
# =============================================================================

apply_project_update() {
  local project_path="$SCAN_PROJECT_PATH"
  local project_name="$SCAN_PROJECT_NAME"
  local files_added=0
  local updated=false
  local -a errors=()

  echo ""
  echo -e "  ${BOLD}Updating: ${project_name}${NC}"

  # ── Backup manifest + CLAUDE.project.md ────────────────────────────────────
  local manifest_path="${project_path}/config/project-manifest.json"
  local claude_project_path="${project_path}/CLAUDE.project.md"

  if [[ -f "$manifest_path" ]]; then
    if [[ "$DRY_RUN" == false ]]; then
      cp "$manifest_path" "${manifest_path}.backup" 2>/dev/null || \
        errors+=("Backup failed for manifest")
    else
      echo -e "    ${DARK_GRAY}DryRun: would backup config/project-manifest.json${NC}"
    fi
  fi

  if [[ -f "$claude_project_path" ]]; then
    if [[ "$DRY_RUN" == false ]]; then
      cp "$claude_project_path" "${claude_project_path}.backup" 2>/dev/null || \
        errors+=("Backup failed for CLAUDE.project.md")
    else
      echo -e "    ${DARK_GRAY}DryRun: would backup CLAUDE.project.md${NC}"
    fi
  fi

  # ── Create required directories ────────────────────────────────────────────
  local -a required_dirs=(
    "${project_path}/config"
    "${project_path}/.mxm"
    "${project_path}/.claude-sessions-memory"
    "${project_path}/.claude.local"
  )
  for dir in "${required_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
      if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$dir" && {
          echo -e "    ${DARK_GRAY}Created: $(basename "$dir")/${NC}"
          (( files_added++ )) || true
          updated=true
        } || errors+=("Failed to create: $dir")
      else
        echo -e "    ${DARK_GRAY}DryRun: would create $(basename "$dir")/${NC}"
      fi
    fi
  done

  # ── Merge manifest (preserve + extend) ────────────────────────────────────
  if [[ -f "$manifest_path" ]] && [[ "$HAS_TEMPLATE" == true ]]; then
    local tmp_merged
    tmp_merged=$(mktemp)

    if merge_manifest "$manifest_path" "$TEMPLATE_PATH" "$tmp_merged" 2>/dev/null; then
      # Update tracking fields
      if command -v jq &>/dev/null; then
        jq \
          --arg v "$TARGET_VERSION" \
          --arg d "$TODAY" \
          --arg nr "$NEXT_REVIEW" \
          '.mxm_version = $v | .last_updated = $d | .next_review = $nr' \
          "$tmp_merged" > "${tmp_merged}.2" && mv "${tmp_merged}.2" "$tmp_merged"
      elif command -v node &>/dev/null; then
        MXM_FILE="$tmp_merged" MXM_VER="$TARGET_VERSION" MXM_DATE="$TODAY" MXM_NR="$NEXT_REVIEW" \
        node -e "
          const fs = require('fs');
          const obj = JSON.parse(fs.readFileSync(process.env.MXM_FILE, 'utf8'));
          obj.mxm_version = process.env.MXM_VER;
          obj.last_updated = process.env.MXM_DATE;
          obj.next_review  = process.env.MXM_NR;
          fs.writeFileSync(process.env.MXM_FILE, JSON.stringify(obj, null, 2) + '\n');
        " 2>/dev/null
      fi

      # Ensure super_user block
      json_ensure_super_user "$tmp_merged" 2>/dev/null || true

      # Validate before writing
      if json_valid "$tmp_merged" 2>/dev/null; then
        if [[ "$DRY_RUN" == false ]]; then
          mv "$tmp_merged" "$manifest_path"
          echo -e "    ${GREEN}Updated: config/project-manifest.json (version -> ${TARGET_VERSION})${NC}"
          updated=true
        else
          rm -f "$tmp_merged"
          echo -e "    ${DARK_GRAY}DryRun: would update config/project-manifest.json${NC}"
        fi
      else
        rm -f "$tmp_merged"
        errors+=("JSON validation failed after manifest merge — skipped write")
        echo -e "    ${RED}ERROR: JSON validation failed — manifest not written${NC}"
      fi
    else
      rm -f "$tmp_merged"
      errors+=("Manifest merge failed (check jq/node installation)")
    fi

  elif [[ ! -f "$manifest_path" ]] && [[ "$HAS_TEMPLATE" == true ]]; then
    # Create minimal manifest from template
    if [[ "$DRY_RUN" == false ]]; then
      mkdir -p "${project_path}/config"
      local new_manifest="${project_path}/config/project-manifest.json"
      cp "$TEMPLATE_PATH" "$new_manifest"
      json_set_field "$new_manifest" "mxm_version" "$TARGET_VERSION" 2>/dev/null || true
      json_set_field "$new_manifest" "last_updated" "$TODAY" 2>/dev/null || true
      echo -e "    ${CYAN}Created: config/project-manifest.json (from template)${NC}"
      (( files_added++ )) || true
      updated=true
    else
      echo -e "    ${DARK_GRAY}DryRun: would create config/project-manifest.json from template${NC}"
    fi
  fi

  # ── Copy local agent-registry.json ────────────────────────────────────────
  if [[ "$SCAN_HAS_LOCAL_REGISTRY" == false ]]; then
    local dest_registry="${project_path}/config/agent-registry.json"
    if [[ "$DRY_RUN" == false ]]; then
      if cp "$REGISTRY_PATH" "$dest_registry" 2>/dev/null; then
        echo -e "    ${DARK_GRAY}Created: config/agent-registry.json${NC}"
        (( files_added++ )) || true
        updated=true
      else
        errors+=("Failed to copy agent-registry.json")
      fi
    else
      echo -e "    ${DARK_GRAY}DryRun: would create config/agent-registry.json${NC}"
    fi
  fi

  # ── Create .mxm runtime files ─────────────────────────────────────────────
  local mxm_dir="${project_path}/.mxm"
  local -a mxm_file_defs=(
    ".mxm-skills/agents-skill-gaps.log|# Maxim Skill Gaps Log — initialized by update-maxim.sh ${TODAY}"
    ".mxm-skills/agents-handoff.md|# Maxim Handoff State\n\nstatus: none\n\n_Initialized by update-maxim.sh ${TODAY}_"
    ".mxm-skills/agents-background.log|# Maxim Background Agent Log — initialized by update-maxim.sh ${TODAY}"
  )

  for def in "${mxm_file_defs[@]}"; do
    local rel_path="${def%%|*}"
    local content="${def##*|}"
    local full_path="${project_path}/${rel_path}"

    if [[ ! -f "$full_path" ]]; then
      if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$(dirname "$full_path")"
        printf '%b\n' "$content" > "$full_path" && {
          echo -e "    ${DARK_GRAY}Created: ${rel_path}${NC}"
          (( files_added++ )) || true
          updated=true
        } || errors+=("Failed to create: ${rel_path}")
      else
        echo -e "    ${DARK_GRAY}DryRun: would create ${rel_path}${NC}"
      fi
    fi
  done

  # ── Create .claude-sessions-memory files ──────────────────────────────────
  local mem_dir="${project_path}/.claude-sessions-memory"
  local -a mem_file_defs=(
    ".claude-sessions-memory/handoff.md|# Maxim Handoff State\n\nstatus: none\n\n_Initialized by update-maxim.sh ${TODAY}_"
    ".claude-sessions-memory/decision-log.md|# Maxim Decision Log\n\n_Initialized by update-maxim.sh ${TODAY}_"
    ".claude-sessions-memory/skill-gaps.log|# Maxim Skill Gaps Log\n\n_Initialized by update-maxim.sh ${TODAY}_"
  )

  for def in "${mem_file_defs[@]}"; do
    local rel_path="${def%%|*}"
    local content="${def##*|}"
    local full_path="${project_path}/${rel_path}"

    if [[ ! -f "$full_path" ]]; then
      if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$(dirname "$full_path")"
        printf '%b\n' "$content" > "$full_path" && {
          echo -e "    ${DARK_GRAY}Created: ${rel_path}${NC}"
          (( files_added++ )) || true
          updated=true
        } || errors+=("Failed to create: ${rel_path}")
      else
        echo -e "    ${DARK_GRAY}DryRun: would create ${rel_path}${NC}"
      fi
    fi
  done

  # ── Create .claude.local/settings.local.json ──────────────────────────────
  local settings_path="${project_path}/.claude.local/settings.local.json"
  if [[ ! -f "$settings_path" ]]; then
    if [[ "$DRY_RUN" == false ]]; then
      mkdir -p "$(dirname "$settings_path")"
      cat > "$settings_path" <<SETTINGS_EOF
{
  "_comment": "Per-project Maxim settings. Do not commit to git.",
  "mxm_version": "${TARGET_VERSION}",
  "project_root": "${project_path}",
  "install_mode": "${SCAN_INSTALL_MODE}",
  "created_by": "update-maxim.sh",
  "created_at": "${TODAY}"
}
SETTINGS_EOF
      echo -e "    ${DARK_GRAY}Created: .claude.local/settings.local.json${NC}"
      (( files_added++ )) || true
      updated=true
    else
      echo -e "    ${DARK_GRAY}DryRun: would create .claude.local/settings.local.json${NC}"
    fi
  fi

  # ── Update .gitignore ──────────────────────────────────────────────────────
  local gitignore_path="${project_path}/.gitignore"
  local -a gitignore_entries=(
    "# Maxim per-project — do not commit"
    ".claude.local/"
    "*.backup"
    ".mxm-backup/"
    ".claude-sessions-memory/"
    ".mxm-skills/agents-session-*.md"
    ".mxm-skills/agents-background.log"
  )

  local existing_gitignore=""
  [[ -f "$gitignore_path" ]] && existing_gitignore=$(cat "$gitignore_path" 2>/dev/null || true)

  local -a missing_entries=()
  for entry in "${gitignore_entries[@]}"; do
    # Skip comment lines for the membership check
    [[ "$entry" == \#* ]] && continue
    if ! echo "$existing_gitignore" | grep -qF "$entry" 2>/dev/null; then
      missing_entries+=("$entry")
    fi
  done

  if (( ${#missing_entries[@]} > 0 )); then
    if [[ "$DRY_RUN" == false ]]; then
      {
        echo ""
        for e in "${gitignore_entries[@]}"; do
          echo "$e"
        done
      } >> "$gitignore_path" && {
        echo -e "    ${DARK_GRAY}Updated: .gitignore (added ${#missing_entries[@]} Maxim entries)${NC}"
        updated=true
      } || errors+=("Failed to update .gitignore")
    else
      echo -e "    ${DARK_GRAY}DryRun: would add ${#missing_entries[@]} entries to .gitignore${NC}"
    fi
  fi

  # ── Create CLAUDE.project.md if missing ────────────────────────────────────
  if [[ "$SCAN_HAS_CLAUDE_PROJECT" == false ]]; then
    if [[ "$DRY_RUN" == false ]]; then
      cat > "$claude_project_path" <<CLAUDE_PROJECT_EOF
# CLAUDE.project.md — Project-Specific Maxim Rules
# Project: ${project_name}
# Created by: update-maxim.sh v1.0.0 | Maxim ${TARGET_VERSION}
# Date: ${TODAY}
#
# This file overrides or extends CLAUDE.md for this specific project.
# Fill in your project details below.

## Project Identity

- **Project ID**: (set in config/project-manifest.json -> project.id)
- **Stack**: (e.g. Next.js + Supabase + Stripe)
- **Stage**: (idea | early-stage | active | scaling | mature)

## Brand Voice

(Describe your brand tone, personality, target audience)

## Key Constraints

(Any technical, regulatory, or business constraints the AI should know)

## Compliance Scope

(Markets / frameworks: e.g. GDPR, PIPEDA, SOC2 — mirror config/project-manifest.json -> compliance)

## Agent Overrides

(Any per-project agent behavior changes — leave empty for standard Maxim behavior)
CLAUDE_PROJECT_EOF
      echo -e "    ${CYAN}Created: CLAUDE.project.md (template — fill in your project details)${NC}"
      (( files_added++ )) || true
      updated=true
    else
      echo -e "    ${DARK_GRAY}DryRun: would create CLAUDE.project.md (from template)${NC}"
    fi
  fi

  # ── Merge duplicate planning files ─────────────────────────────────────────
  for file_type in task_plan progress findings; do
    local var_name="SCAN_PLAN_$(echo "$file_type" | tr '[:lower:]' '[:upper:]')"
    local paths_str="${!var_name:-}"

    if [[ -n "$paths_str" ]]; then
      IFS=':' read -ra paths_arr <<< "$paths_str"
      if (( ${#paths_arr[@]} > 1 )); then
        echo -e "    ${CYAN}Merging duplicate ${file_type}.md files...${NC}"
        merge_planning_files "$project_path" "$file_type" "$paths_str"
        updated=true
      fi
    fi
  done

  # ── Final JSON validation ──────────────────────────────────────────────────
  if [[ -f "$manifest_path" ]]; then
    if ! json_valid "$manifest_path" 2>/dev/null; then
      errors+=("config/project-manifest.json failed final JSON validation — check manually")
      echo -e "    ${RED}ERROR: config/project-manifest.json failed JSON validation${NC}"
    fi
  fi

  # ── Return result via globals (no subshell) ────────────────────────────────
  UPDATE_RESULT_NAME="$project_name"
  UPDATE_RESULT_OLD_VERSION="$SCAN_CURRENT_VERSION"
  UPDATE_RESULT_NEW_VERSION="$TARGET_VERSION"
  UPDATE_RESULT_FILES_ADDED="$files_added"
  UPDATE_RESULT_UPDATED="$updated"
  # Serialize errors as newline-separated
  UPDATE_RESULT_ERRORS=$(IFS=$'\n'; printf '%s' "${errors[*]:-}")
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

# ── Step 1: Project discovery ─────────────────────────────────────────────────
echo ""
info "Discovering projects..."
echo ""

mapfile -t PROJECT_LIST < <(discover_projects_interactive)

if [[ ${#PROJECT_LIST[@]} -eq 0 ]]; then
  echo ""
  warn "No projects selected. Exiting."
  echo ""
  exit 0
fi

echo ""
echo -e "  ${BOLD}Selected ${#PROJECT_LIST[@]} project(s) for update.${NC}"

# ── Step 2: Scan all projects ─────────────────────────────────────────────────
echo ""
echo -e "── ${BOLD}Running Intelligence Scan${NC} ──"

declare -a SCAN_TEMP_FILES=()
declare -a SCAN_VALID_PATHS=()

for project_path in "${PROJECT_LIST[@]}"; do
  echo -e "  ${DARK_GRAY}Scanning: ${project_path}${NC}"
  tmp=$(mktemp)

  if scan_project "$project_path" "$tmp" 2>/dev/null; then
    SCAN_TEMP_FILES+=("$tmp")
    SCAN_VALID_PATHS+=("$project_path")
  else
    warn "Scan failed for: ${project_path} — skipping"
    rm -f "$tmp"
  fi
done

# ── Step 3 & 5: Report + confirm + update each project ────────────────────────

# Declare summary arrays
declare -a SUMMARY_NAMES=()
declare -a SUMMARY_OLD_VERSIONS=()
declare -a SUMMARY_NEW_VERSIONS=()
declare -a SUMMARY_FILES_ADDED=()
declare -a SUMMARY_UPDATED=()
declare -a SUMMARY_ERRORS=()

for idx in "${!SCAN_TEMP_FILES[@]}"; do
  tmp="${SCAN_TEMP_FILES[$idx]}"

  # Source the scan result (sets all SCAN_* variables in current shell)
  # shellcheck disable=SC1090
  source "$tmp"
  rm -f "$tmp"

  # Show gap report
  show_project_report

  # Prompt for confirmation
  if [[ "$SKIP_CONFIRM" == true ]] || [[ "$DRY_RUN" == true ]]; then
    choice="y"
  else
    echo ""
    read -rp "Proceed? (y)es / (n)o / (s)kip: " choice
    choice="${choice:-y}"
    choice="${choice,,}"
  fi

  if [[ "$choice" == "s" || "$choice" == "n" || "$choice" == "no" ]]; then
    echo -e "  ${DARK_GRAY}Skipped: ${SCAN_PROJECT_NAME}${NC}"
    SUMMARY_NAMES+=("$SCAN_PROJECT_NAME")
    SUMMARY_OLD_VERSIONS+=("$SCAN_CURRENT_VERSION")
    SUMMARY_NEW_VERSIONS+=("$TARGET_VERSION")
    SUMMARY_FILES_ADDED+=("0")
    SUMMARY_UPDATED+=("false")
    SUMMARY_ERRORS+=("")
    continue
  fi

  # Apply update
  # Reset result globals
  UPDATE_RESULT_NAME=""
  UPDATE_RESULT_OLD_VERSION=""
  UPDATE_RESULT_NEW_VERSION=""
  UPDATE_RESULT_FILES_ADDED=0
  UPDATE_RESULT_UPDATED=false
  UPDATE_RESULT_ERRORS=""

  if apply_project_update 2>/dev/null; then
    if [[ "$UPDATE_RESULT_UPDATED" == true ]]; then
      echo -e "  ${GREEN}OK${NC}  ${SCAN_PROJECT_NAME} updated to ${TARGET_VERSION} (${UPDATE_RESULT_FILES_ADDED} files added)"
    else
      echo -e "  ${DARK_GREEN}OK${NC}  ${SCAN_PROJECT_NAME} — already up to date, no changes needed"
    fi

    if [[ -n "$UPDATE_RESULT_ERRORS" ]]; then
      while IFS= read -r err_line; do
        [[ -z "$err_line" ]] && continue
        echo -e "  ${RED}ERROR${NC}  ${err_line}"
      done <<< "$UPDATE_RESULT_ERRORS"
    fi
  else
    echo -e "  ${RED}ERROR: Update failed for ${SCAN_PROJECT_NAME}${NC}"
    UPDATE_RESULT_UPDATED=false
    UPDATE_RESULT_ERRORS="Update function exited with error"
  fi

  SUMMARY_NAMES+=("${UPDATE_RESULT_NAME:-$SCAN_PROJECT_NAME}")
  SUMMARY_OLD_VERSIONS+=("${UPDATE_RESULT_OLD_VERSION:-$SCAN_CURRENT_VERSION}")
  SUMMARY_NEW_VERSIONS+=("${UPDATE_RESULT_NEW_VERSION:-$TARGET_VERSION}")
  SUMMARY_FILES_ADDED+=("${UPDATE_RESULT_FILES_ADDED:-0}")
  SUMMARY_UPDATED+=("${UPDATE_RESULT_UPDATED:-false}")
  SUMMARY_ERRORS+=("${UPDATE_RESULT_ERRORS:-}")
done

# =============================================================================
# STEP 6 — SUMMARY TABLE
# =============================================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Maxim Update Summary${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Column widths
COL_NAME=24
COL_OLD=9
COL_NEW=9
COL_FILES=13
COL_STATUS=10

printf "  ${BOLD}%-${COL_NAME}s  %-${COL_OLD}s  %-${COL_NEW}s  %-${COL_FILES}s  %-${COL_STATUS}s${NC}\n" \
  "Project" "Old" "New" "Files Added" "Status"

printf "  %s  %s  %s  %s  %s\n" \
  "$(printf '%*s' "$COL_NAME" '' | tr ' ' '-')" \
  "$(printf '%*s' "$COL_OLD"  '' | tr ' ' '-')" \
  "$(printf '%*s' "$COL_NEW"  '' | tr ' ' '-')" \
  "$(printf '%*s' "$COL_FILES" '' | tr ' ' '-')" \
  "$(printf '%*s' "$COL_STATUS" '' | tr ' ' '-')"

updated_count=0
error_count=0

for idx in "${!SUMMARY_NAMES[@]}"; do
  local_name="${SUMMARY_NAMES[$idx]}"
  local_old="${SUMMARY_OLD_VERSIONS[$idx]}"
  local_new="${SUMMARY_NEW_VERSIONS[$idx]}"
  local_files="${SUMMARY_FILES_ADDED[$idx]}"
  local_updated="${SUMMARY_UPDATED[$idx]}"
  local_errors="${SUMMARY_ERRORS[$idx]}"

  # Truncate name if too long
  if (( ${#local_name} > COL_NAME )); then
    local_name="${local_name:0:$(( COL_NAME - 2 ))}.."
  fi

  status_label="Skipped"
  status_color="$DARK_GRAY"

  if [[ -n "$local_errors" ]]; then
    status_label="ERROR"
    status_color="$RED"
    (( error_count++ )) || true
  elif [[ "$local_updated" == true ]]; then
    status_label="Updated"
    status_color="$GREEN"
    (( updated_count++ )) || true
  fi

  printf "  %-${COL_NAME}s  %-${COL_OLD}s  %-${COL_NEW}s  %-${COL_FILES}s  " \
    "$local_name" "$local_old" "$local_new" "$local_files"
  echo -e "${status_color}${status_label}${NC}"
done

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if (( updated_count > 0 )); then
  echo -e "  ${BOLD}Next step: open each updated project in Claude Code and run /mxm-status${NC}"
fi
if (( error_count > 0 )); then
  warn "${error_count} project(s) had errors — review output above."
fi
if [[ "$DRY_RUN" == true ]]; then
  warn "DRY RUN complete — no files were written. Remove --dry-run to apply changes."
fi
echo ""
