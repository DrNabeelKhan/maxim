#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# mxm-self-update.sh — fast in-place plugin update (v1.1.1+).
#
# Without this, every plugin patch (e.g. /mxm-help text fix) requires the
# painful flow:
#   /plugin uninstall maxim@maxim-packs
#   /plugin install maxim@maxim-packs
#   restart Claude Code
#   wait for spawn-with-deps wrapper to npm-install all 7 MCPs (~30 sec)
#   restart Claude Code again
#
# With this script, a single invocation:
#   1. Pulls latest commits in marketplace cache (git pull)
#   2. Syncs marketplace content into install cache (excludes .git,
#      node_modules, sentinels — so MCP deps are preserved)
#   3. Updates installed_plugins.json gitCommitSha + lastUpdated
#
# After running, user restarts Claude Code ONCE. node_modules already present;
# spawn-with-deps wrapper sees its sentinel and skips install. New content
# (commands, skills, agents, hooks, MCP code) loads on first session.
#
# Usage:
#   bash ~/.claude/plugins/cache/maxim-packs/maxim/<version>/bootstrap/mxm-self-update.sh
#   OR via slash command: /mxm-self-update
#
# Exit codes:
#   0 = success (or already up to date)
#   1 = error (network, missing install, registry write failure)

set -uo pipefail

PLUGIN_NAME="maxim"
MARKETPLACE_NAME="maxim-packs"
HOME_CLAUDE="${HOME}/.claude"
MARKETPLACE_DIR="${HOME_CLAUDE}/plugins/marketplaces/${MARKETPLACE_NAME}"
INSTALLED_REGISTRY="${HOME_CLAUDE}/plugins/installed_plugins.json"
INSTALL_CACHE_PARENT="${HOME_CLAUDE}/plugins/cache/${MARKETPLACE_NAME}/${PLUGIN_NAME}"

err() { echo "ERROR: $*" >&2; exit 1; }
log() { echo "→ $*" >&2; }

# ─── Step 1: Locate install cache dir ────────────────────────────────
[ -d "$INSTALL_CACHE_PARENT" ] || err "$PLUGIN_NAME plugin not installed. Run '/plugin install $PLUGIN_NAME@$MARKETPLACE_NAME' first."

INSTALL_DIR=$(ls -d "$INSTALL_CACHE_PARENT"/*/ 2>/dev/null | head -1)
[ -n "$INSTALL_DIR" ] || err "No version dir under $INSTALL_CACHE_PARENT/. Plugin install corrupted — full reinstall recommended."
INSTALL_DIR="${INSTALL_DIR%/}"
INSTALL_VERSION=$(basename "$INSTALL_DIR")
log "Install cache: $INSTALL_DIR (version $INSTALL_VERSION)"

# ─── Step 2: Pull marketplace cache ──────────────────────────────────
[ -d "$MARKETPLACE_DIR/.git" ] || err "Marketplace cache at $MARKETPLACE_DIR is not a git repo. Recreate via: /plugin marketplace remove $MARKETPLACE_NAME && /plugin marketplace add DrNabeelKhan/maxim"

OLD_SHA=$(cd "$MARKETPLACE_DIR" && git rev-parse HEAD 2>/dev/null) || err "git rev-parse failed in $MARKETPLACE_DIR"

log "Pulling latest marketplace state from origin/main…"
PULL_OUT=$(cd "$MARKETPLACE_DIR" && git pull --ff-only origin main 2>&1) || {
    echo "$PULL_OUT" >&2
    err "git pull failed. Check network connectivity + repo state."
}

NEW_SHA=$(cd "$MARKETPLACE_DIR" && git rev-parse HEAD)

if [ "$OLD_SHA" = "$NEW_SHA" ]; then
    log "Already at latest commit ($NEW_SHA). No update needed."
    exit 0
fi

log "Marketplace updated: ${OLD_SHA:0:8} → ${NEW_SHA:0:8}"

# ─── Step 3: Sync marketplace → install cache ────────────────────────
# Excludes preserve the operator's working state:
#   .git/                       — marketplace's git history; install cache shouldn't have it
#   node_modules/               — npm-installed deps; preserve to avoid re-install
#   .mcp-deps-installed         — spawn-with-deps wrapper sentinel
#   .mcp-install-lock           — concurrent-install lock file
log "Syncing marketplace content → install cache (preserving node_modules + sentinels)…"

if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete \
        --exclude='.git/' \
        --exclude='node_modules/' \
        --exclude='.mcp-deps-installed' \
        --exclude='.mcp-install-lock' \
        "$MARKETPLACE_DIR/" "$INSTALL_DIR/" >&2
else
    # Fallback for environments without rsync (rare on Windows Git-Bash)
    log "(rsync not found — using cp fallback; slower but functional)"
    for entry in "$MARKETPLACE_DIR"/.* "$MARKETPLACE_DIR"/*; do
        name=$(basename "$entry")
        # Skip . / .. / .git / pseudo-entries
        case "$name" in
            ".") continue ;;
            "..") continue ;;
            ".git") continue ;;
        esac
        # If destination has node_modules subtree, preserve it by not deleting it
        if [ -d "$INSTALL_DIR/$name/node_modules" ] && [ -d "$entry" ]; then
            # Copy contents, leaving node_modules intact
            cp -R "$entry"/. "$INSTALL_DIR/$name/" 2>/dev/null
        else
            rm -rf "$INSTALL_DIR/$name"
            cp -R "$entry" "$INSTALL_DIR/" 2>/dev/null
        fi
    done
fi

# ─── Step 4: Update installed_plugins.json gitCommitSha + lastUpdated ─
log "Updating installed_plugins.json registry…"
python - <<PYEOF
import json, sys
from datetime import datetime, timezone

path = r"$INSTALLED_REGISTRY"
key = "$PLUGIN_NAME@$MARKETPLACE_NAME"
new_sha = "$NEW_SHA"

try:
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
except Exception as e:
    print(f"  WARN: cannot read registry ({e}); registry SHA NOT updated", file=sys.stderr)
    sys.exit(0)

if key not in data.get("plugins", {}):
    print(f"  WARN: {key} not in registry; registry NOT updated", file=sys.stderr)
    sys.exit(0)

iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.") + f"{datetime.now(timezone.utc).microsecond // 1000:03d}Z"
for entry in data["plugins"][key]:
    entry["gitCommitSha"] = new_sha
    entry["lastUpdated"] = iso

try:
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  registry SHA → {new_sha[:8]}", file=sys.stderr)
except Exception as e:
    print(f"  WARN: registry write failed ({e})", file=sys.stderr)
PYEOF

# ─── Done ────────────────────────────────────────────────────────────
echo "" >&2
echo "════════════════════════════════════════════════════════════" >&2
echo "✓ Maxim plugin synced to commit ${NEW_SHA:0:8}" >&2
echo "  RESTART Claude Code to load the new content." >&2
echo "  node_modules preserved — no MCP re-install needed." >&2
echo "════════════════════════════════════════════════════════════" >&2

exit 0
