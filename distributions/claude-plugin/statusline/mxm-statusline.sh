#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# Maxim Statusline — Mac / Linux
#
# Reads Claude Code session JSON from stdin + three project-local data sources
# and emits a two-line statusline in Technical Educator voice per ADR-010.
#
# Data sources (all optional, graceful fallback when missing):
#   stdin                                     - Claude Code session JSON
#   $CLAUDE_PROJECT_DIR/.claude-sessions-memory/activity.jsonl   - last line
#   $CLAUDE_PROJECT_DIR/config/project-manifest.json             - project + lifecycle
#   $CLAUDE_PROJECT_DIR/.mxm-skills/agents-skill-gaps.log       - line count
#   $CLAUDE_PROJECT_DIR/documents/references/mxm-statusline-labels.json  - label lookup
#
# Color tiers:
#   context % : green <60, yellow 60-80, red >=80
#   5h rate % : green <70, yellow 70-85, red >=85
#   7d rate % : green <75, yellow 75-80, red >=80
#
# OSC 8 clickable links route to https://maxim.isystematic.com/docs/glossary#<anchor>.

set -u

STDIN_JSON="$(cat 2>/dev/null || echo '{}')"
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"

ACTIVITY_FILE="$PROJECT_ROOT/.claude-sessions-memory/activity.jsonl"
MANIFEST_FILE="$PROJECT_ROOT/config/project-manifest.json"
GAPS_FILE="$PROJECT_ROOT/.mxm-skills/agents-skill-gaps.log"
LABELS_FILE="$PROJECT_ROOT/documents/references/mxm-statusline-labels.json"

GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'
GLOSSARY="https://maxim.isystematic.com/docs/glossary"

osc8() {
  printf '\033]8;;%s\033\\%s\033]8;;\033\\' "$1" "$2"
}

tier_ctx() { local p="$1"; if (( p < 60 )); then echo "$GREEN"; elif (( p < 80 )); then echo "$YELLOW"; else echo "$RED"; fi; }
tier_5h()  { local p="$1"; if (( p < 70 )); then echo "$GREEN"; elif (( p < 85 )); then echo "$YELLOW"; else echo "$RED"; fi; }
tier_7d()  { local p="$1"; if (( p < 75 )); then echo "$GREEN"; elif (( p < 80 )); then echo "$YELLOW"; else echo "$RED"; fi; }

# Shared python parser. Reads JSON from stdin, accepts dotted path, prints value or empty.
py_get() {
  local payload="$1" path="$2"
  python3 - <<PYEOF 2>/dev/null
import json, sys
try:
    d = json.loads('''$payload''')
    for k in "$path".split('.'):
        if isinstance(d, dict):
            d = d.get(k)
        else:
            d = None
            break
    print(d if d is not None else "")
except Exception:
    print("")
PYEOF
}

# Parse Claude stdin JSON
CTX_USED=$(py_get "$STDIN_JSON" "context.used")
CTX_BUDGET=$(py_get "$STDIN_JSON" "context.budget")
RATE_5H=$(py_get "$STDIN_JSON" "usage.five_hour_rate")
RATE_7D=$(py_get "$STDIN_JSON" "usage.seven_day_rate")
SESSION_MODEL=$(py_get "$STDIN_JSON" "session.model")

# Compute percentages with fallback
pct_int() {
  python3 -c "
try:
    n = float('${1:-0}' or 0)
    d = float('${2:-0}' or 0)
    print(int(100*n/d) if d > 0 else 0)
except Exception:
    print(0)
" 2>/dev/null || echo 0
}
to_pct() {
  python3 -c "
try: print(int(100*float('${1:-0}' or 0)))
except: print(0)
" 2>/dev/null || echo 0
}

CTX_PCT=$(pct_int "$CTX_USED" "$CTX_BUDGET")
R5_PCT=$(to_pct "$RATE_5H")
R7_PCT=$(to_pct "$RATE_7D")

# Project manifest (id + lifecycle)
PROJECT_ID="no-manifest"
LIFECYCLE="?"
if [ -f "$MANIFEST_FILE" ]; then
  PROJECT_ID=$(python3 -c "
import json
try:
    d = json.load(open('$MANIFEST_FILE'))
    print(d.get('project',{}).get('id') or d.get('project_id') or 'unknown')
except Exception:
    print('unknown')
" 2>/dev/null)
  LIFECYCLE=$(python3 -c "
import json
try:
    d = json.load(open('$MANIFEST_FILE'))
    print(d.get('status',{}).get('lifecycle','active'))
except Exception:
    print('?')
" 2>/dev/null)
fi

# Last activity label key
LABEL_KEY="default"
if [ -f "$ACTIVITY_FILE" ]; then
  LAST_LINE=$(tail -n 1 "$ACTIVITY_FILE" 2>/dev/null || true)
  if [ -n "$LAST_LINE" ]; then
    LABEL_KEY=$(python3 -c "
import json
try:
    d = json.loads('''$LAST_LINE''')
    print(d.get('label_key', 'default'))
except Exception:
    print('default')
" 2>/dev/null || echo "default")
  fi
fi

# Look up label display + glossary anchor
LABEL_DISPLAY="Maxim Ready"
LABEL_GLOSSARY="maxim"
if [ -f "$LABELS_FILE" ]; then
  LABEL_DISPLAY=$(python3 -c "
import json
try:
    d = json.load(open('$LABELS_FILE')).get('labels', {})
    e = d.get('$LABEL_KEY') or d.get('default', {})
    print(e.get('display','Maxim Ready'))
except Exception:
    print('Maxim Ready')
" 2>/dev/null)
  LABEL_GLOSSARY=$(python3 -c "
import json
try:
    d = json.load(open('$LABELS_FILE')).get('labels', {})
    e = d.get('$LABEL_KEY') or d.get('default', {})
    print(e.get('glossary','maxim'))
except Exception:
    print('maxim')
" 2>/dev/null)
fi

# Skill gap count
GAPS=0
if [ -f "$GAPS_FILE" ]; then
  GAPS=$(wc -l < "$GAPS_FILE" 2>/dev/null | tr -d ' ')
  [ -z "$GAPS" ] && GAPS=0
fi

# Render 2-line output
PROJ_LINK="$(osc8 "$GLOSSARY#project" "$PROJECT_ID")"
LABEL_LINK="$(osc8 "$GLOSSARY#$LABEL_GLOSSARY" "$LABEL_DISPLAY")"

printf '%sMaxim%s %s %s(%s)%s  %s\n' \
  "$BOLD" "$RESET" \
  "$PROJ_LINK" \
  "$DIM" "$LIFECYCLE" "$RESET" \
  "$LABEL_LINK"

printf 'ctx %s%d%%%s  5h %s%d%%%s  7d %s%d%%%s  gaps %d\n' \
  "$(tier_ctx $CTX_PCT)" $CTX_PCT "$RESET" \
  "$(tier_5h $R5_PCT)" $R5_PCT "$RESET" \
  "$(tier_7d $R7_PCT)" $R7_PCT "$RESET" \
  "$GAPS"
