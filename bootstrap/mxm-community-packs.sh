#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-community-packs.sh — install all community packs per ADR-008 (v1.0.0)
#
# Reads config/community-pack-registry.json and clones each pack to its
# install_path (all under community-packs/, which is gitignored).
#
# Usage:
#   bootstrap/mxm-community-packs.sh          # install all required packs
#   bootstrap/mxm-community-packs.sh --list   # print the registry
#   bootstrap/mxm-community-packs.sh --force  # reclone even if present
#
# Requires one of: jq, python3, python, or node on PATH for JSON parsing.

set -u
mode="install"
case "${1:-}" in
  --list) mode="list" ;;
  --force) mode="force" ;;
esac

REG="config/community-pack-registry.json"
if [ ! -f "$REG" ]; then
  echo "ERROR: $REG not found (run from repo root)"
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git not on PATH — required for community pack install"
  exit 1
fi

# ----- Pick best available JSON parser: jq > python3 > python > node -----
JSON_TOOL=""
if command -v jq >/dev/null 2>&1; then
  JSON_TOOL="jq"
elif command -v python3 >/dev/null 2>&1; then
  JSON_TOOL="python3"
elif command -v python >/dev/null 2>&1; then
  JSON_TOOL="python"
elif command -v node >/dev/null 2>&1; then
  JSON_TOOL="node"
else
  echo "ERROR: need one of jq, python3, python, or node on PATH to parse $REG"
  exit 1
fi

_emit_packs() {
  case "$JSON_TOOL" in
    jq)      jq -c '.packs[]' "$REG" ;;
    python3) python3 -c "import json; d=json.load(open('$REG')); [print(json.dumps(p)) for p in d['packs']]" ;;
    python)  python  -c "import json; d=json.load(open('$REG')); [print(json.dumps(p)) for p in d['packs']]" ;;
    node)    node -e "const r=require('./$REG');for(const p of r.packs)console.log(JSON.stringify(p));" ;;
  esac
}

_field() {
  # $1 = JSON string, $2 = field name
  case "$JSON_TOOL" in
    jq)      echo "$1" | jq -r ".$2" ;;
    python3) echo "$1" | python3 -c "import json,sys; print(json.loads(sys.stdin.read())['$2'])" ;;
    python)  echo "$1" | python  -c "import json,sys; print(json.loads(sys.stdin.read())['$2'])" ;;
    node)    echo "$1" | node -e "let d='';process.stdin.on('data',c=>d+=c).on('end',()=>console.log(JSON.parse(d)['$2']));" ;;
  esac
}

PACKS_JSON="$(_emit_packs)"

if [ "$mode" = "list" ]; then
  echo "$PACKS_JSON" | while IFS= read -r p; do
    [ -z "$p" ] && continue
    id=$(_field "$p" id)
    src=$(_field "$p" source)
    echo "  $id ← $src"
  done
  exit 0
fi

# ----- Install loop -----
success=0
failed=0
skipped=0

# Write counters to a temp file since the while-pipe creates a subshell
COUNT_FILE="$(mktemp -t mxm-packs.XXXXXX 2>/dev/null || echo /tmp/mxm-packs-$$)"
echo "0 0 0" > "$COUNT_FILE"

echo "$PACKS_JSON" | while IFS= read -r pack; do
  [ -z "$pack" ] && continue
  id=$(_field "$pack" id)
  source=$(_field "$pack" source)
  branch=$(_field "$pack" branch)
  install_path=$(_field "$pack" install_path)

  read s f k < "$COUNT_FILE"

  if [ -d "$install_path" ] && [ "$mode" != "force" ]; then
    echo "SKIP  $id — already present at $install_path"
    k=$((k + 1))
    echo "$s $f $k" > "$COUNT_FILE"
    continue
  fi

  if [ -d "$install_path" ]; then
    echo "FORCE removing $install_path"
    rm -rf "$install_path"
  fi

  mkdir -p "$(dirname "$install_path")"
  echo "CLONE $id ← github.com/$source @ $branch"
  if git clone --depth 1 --branch "$branch" "https://github.com/${source}.git" "$install_path" 2>&1 | tail -3; then
    s=$((s + 1))
  else
    echo "FAIL  $id"
    f=$((f + 1))
  fi
  echo "$s $f $k" > "$COUNT_FILE"
done

read success failed skipped < "$COUNT_FILE"
rm -f "$COUNT_FILE"

echo ""
echo "mxm-community-packs done — installed: $success, skipped: $skipped, failed: $failed"
if [ "$failed" -gt 0 ]; then
  echo "Note: re-run with --force to retry failed packs."
  exit 1
fi
exit 0
