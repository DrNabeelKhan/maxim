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

if ! command -v jq >/dev/null 2>&1; then
  echo "WARN: jq not found; falling back to python parser"
  PACKS_JSON=$(python -c "import json,sys; d=json.load(open('$REG')); [print(json.dumps(p)) for p in d['packs']]")
else
  PACKS_JSON=$(jq -c '.packs[]' "$REG")
fi

if [ "$mode" = "list" ]; then
  echo "$PACKS_JSON" | while IFS= read -r p; do
    id=$(echo "$p" | python -c "import json,sys; print(json.loads(sys.stdin.read())['id'])")
    src=$(echo "$p" | python -c "import json,sys; print(json.loads(sys.stdin.read())['source'])")
    echo "  $id ← $src"
  done
  exit 0
fi

success=0
failed=0

echo "$PACKS_JSON" | while IFS= read -r pack; do
  id=$(echo "$pack" | python -c "import json,sys; d=json.loads(sys.stdin.read()); print(d['id'])")
  source=$(echo "$pack" | python -c "import json,sys; d=json.loads(sys.stdin.read()); print(d['source'])")
  branch=$(echo "$pack" | python -c "import json,sys; d=json.loads(sys.stdin.read()); print(d['branch'])")
  install_path=$(echo "$pack" | python -c "import json,sys; d=json.loads(sys.stdin.read()); print(d['install_path'])")

  if [ -d "$install_path" ] && [ "$mode" != "force" ]; then
    echo "SKIP  $id — already present at $install_path"
    continue
  fi

  if [ -d "$install_path" ]; then
    echo "FORCE removing $install_path"
    rm -rf "$install_path"
  fi

  mkdir -p "$(dirname "$install_path")"
  echo "CLONE $id ← github.com/$source @ $branch"
  if git clone --depth 1 --branch "$branch" "https://github.com/${source}.git" "$install_path" 2>&1 | tail -3; then
    success=$((success + 1))
  else
    echo "FAIL  $id"
    failed=$((failed + 1))
  fi
done

echo ""
echo "mxm-community-packs done. Run 'bash $0 --list' to see installed packs."
