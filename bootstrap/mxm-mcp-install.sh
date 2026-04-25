#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

# mxm-mcp-install.sh — install npm deps for all 7 MCP servers
#
# Each MCP server (mcp/mxm-*/) is a self-contained Node package with its own
# package.json. node_modules/ is gitignored, so a fresh plugin install ships
# without dependencies. Without this step, Claude Code's MCP-spawn fails with
# ERR_MODULE_NOT_FOUND for @modelcontextprotocol/sdk and the user sees an
# MCP timeout.
#
# Usage:
#   bash bootstrap/mxm-mcp-install.sh           # install all (skip if present)
#   bash bootstrap/mxm-mcp-install.sh --force   # reinstall even if present
#
# Requires: node + npm on PATH.

set -u
mode="install"
case "${1:-}" in
  --force) mode="force" ;;
esac

if ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: npm not on PATH — required to install MCP server dependencies"
  echo "Install Node.js from https://nodejs.org and re-run this script."
  exit 1
fi

if [ ! -d "mcp" ]; then
  echo "ERROR: ./mcp directory not found (run from repo root)"
  exit 1
fi

success=0
skipped=0
failed=0

for server_dir in mcp/mxm-*/; do
  [ -d "$server_dir" ] || continue
  name=$(basename "$server_dir")

  # Skip if no package.json (shouldn't happen, but defensive)
  if [ ! -f "$server_dir/package.json" ]; then
    echo "SKIP  $name — no package.json"
    skipped=$((skipped + 1))
    continue
  fi

  # Skip if node_modules already present and not --force
  if [ -d "$server_dir/node_modules" ] && [ "$mode" != "force" ]; then
    echo "SKIP  $name — node_modules already present"
    skipped=$((skipped + 1))
    continue
  fi

  if [ -d "$server_dir/node_modules" ]; then
    echo "FORCE removing $server_dir/node_modules"
    rm -rf "$server_dir/node_modules"
  fi

  echo "INSTALL $name (npm install --omit=dev --no-audit --no-fund)"
  if (cd "$server_dir" && npm install --omit=dev --no-audit --no-fund 2>&1 | tail -3); then
    success=$((success + 1))
  else
    echo "FAIL  $name"
    failed=$((failed + 1))
  fi
done

echo ""
echo "mxm-mcp-install done — installed: $success, skipped: $skipped, failed: $failed"
if [ "$failed" -gt 0 ]; then
  echo "Note: re-run with --force to retry failed installs."
  exit 1
fi
exit 0
