#!/usr/bin/env bash
# mxm-find-skill.sh — Maxim STEP-1-miss fallback skill search.
# When Maxim has no native skill for a task (dispatch STEP 1 returns NO), search the
# vendored awesome-agent-skills catalog (VoltAgent, MIT) for an external candidate
# BEFORE logging a genuine skill gap. Surfaced candidates are 🔴 Maxim-UNENHANCED
# (ADR-008) — fetch the linked skill, apply the Maxim behavioral overlay, then use.
#
# Multi-word queries are tokenized; results are ranked by how many query terms match.
# Usage:  bash bootstrap/mxm-find-skill.sh "<query>"     e.g. "stripe billing"
set -euo pipefail

Q="${*:-}"
[ -z "$Q" ] && { echo "usage: mxm-find-skill.sh <query>"; exit 1; }

# Resolve catalog relative to this script (cross-platform; BUG-008 lesson: no $HOME interpolation)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAT="$SCRIPT_DIR/../community-packs/awesome-agent-skills/SKILLS_CATALOG.md"
[ -f "$CAT" ] || { echo "catalog not found: $CAT"; echo "vendor it: curl -sL https://raw.githubusercontent.com/VoltAgent/awesome-agent-skills/main/README.md -o \"$CAT\""; exit 2; }

echo "🔎 awesome-agent-skills (VoltAgent · MIT) — searching for: \"$Q\""
echo "   Maxim has no native skill — external candidates below are 🔴 Maxim-UNENHANCED (ADR-008)."
echo

# Tokenize query; for each catalog entry-with-link, count how many query terms it contains;
# rank by term-match count. Skip the Table-of-Contents / index-grid sections (de-noise).
RESULTS=$(awk -v q="$Q" '
  BEGIN { nw = split(tolower(q), words, /[^a-z0-9]+/); sec = "(top)" }
  /^#{2,4} / { sec = $0; gsub(/^#+ +/, "", sec); next }
  sec ~ /Table of Contents|Official Skills by/ { next }
  /\[[^]]+\]\([^)]+\)/ {
    line = tolower($0); c = 0
    for (i = 1; i <= nw; i++) if (words[i] != "" && index(line, words[i]) > 0) c++
    if (c > 0) { entry = $0; gsub(/^[-*|> ]+/, "", entry); printf "%d\t%s\t%s\n", c, sec, entry }
  }
' "$CAT" | sort -rn -k1,1 | head -8)

if [ -z "$RESULTS" ]; then
  echo "  ✗ no candidate — log a genuine skill gap (.mxm-skills/agents-skill-gaps.log)."
else
  echo "$RESULTS" | awk -F'\t' '{ s=($1>1?"s":""); print "  • [" $2 "]  (matched " $1 " term" s ")"; print "      " $3 }'
  echo
  echo "  ✓ candidates above, ranked by terms matched. Fetch the linked skill → apply Maxim overlay (confidence tag + framework citation) → flag 🔴 Maxim-UNENHANCED."
fi
