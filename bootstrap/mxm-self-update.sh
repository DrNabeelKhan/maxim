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
#   .mcp-disabled               — operator opt-out list (v1.3.2.3+; preserved so disable choices survive upgrade)
log "Syncing marketplace content → install cache (preserving node_modules + sentinels + .mcp-disabled)…"

if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete \
        --exclude='.git/' \
        --exclude='node_modules/' \
        --exclude='.mcp-deps-installed' \
        --exclude='.mcp-install-lock' \
        --exclude='.mcp-disabled' \
        "$MARKETPLACE_DIR/" "$INSTALL_DIR/" >&2
else
    # Fallback for environments without rsync (rare on Windows Git-Bash).
    # Also preserves the operator's .mcp-disabled file by skipping copy + restore.
    log "(rsync not found — using cp fallback; slower but functional)"
    DISABLED_PRESERVE=""
    if [ -f "$INSTALL_DIR/.mcp-disabled" ]; then
        DISABLED_PRESERVE=$(cat "$INSTALL_DIR/.mcp-disabled")
    fi
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
    # Restore .mcp-disabled if the cp loop accidentally clobbered it.
    if [ -n "$DISABLED_PRESERVE" ]; then
        echo "$DISABLED_PRESERVE" > "$INSTALL_DIR/.mcp-disabled"
    fi
fi

# ─── Step 3b: Re-apply .mcp-disabled to freshly-synced .mcp.json (v1.3.2.3+) ─
# The just-synced .mcp.json has ALL MCPs registered (marketplace template).
# If the operator has disabled MCPs via bootstrap/mxm-toggle-mcp.sh, the disable
# list at $INSTALL_DIR/.mcp-disabled must be re-applied here so the operator's
# choices survive plugin upgrades.
if [ -f "$INSTALL_DIR/.mcp-disabled" ] && [ -s "$INSTALL_DIR/.mcp-disabled" ]; then
    log "Re-applying .mcp-disabled to synced .mcp.json…"
    # BUG-008 lesson applied (v1.3.2.3 hotfix-of-hotfix): path discovery via
    # Path.home() inside the heredoc instead of bash interpolation of
    # $INSTALL_DIR. On Windows Git Bash, bash $HOME is MSYS-style /c/Users/...
    # which Python on Windows cannot open. PATTERN-01 recurrence #5 prevented.
    # Hard-fail on errors (not silent WARN+exit-0) so disable choices cannot
    # be silently dropped on Windows upgrades.
    python - <<PYEOF
import json
import sys
from pathlib import Path

# Native cross-platform path resolution.
install_parent = Path.home() / ".claude" / "plugins" / "cache" / "maxim-packs" / "maxim"
versions = sorted([d for d in install_parent.iterdir() if d.is_dir()])
if not versions:
    print("  ERROR: no install version dir under " + str(install_parent), file=sys.stderr)
    raise SystemExit(1)
install_dir = versions[0]
mcp_path = install_dir / ".mcp.json"
disable_path = install_dir / ".mcp-disabled"

if not mcp_path.exists():
    print(f"  ERROR: .mcp.json not found at {mcp_path}", file=sys.stderr)
    raise SystemExit(1)

try:
    data = json.loads(mcp_path.read_text(encoding="utf-8"))
except Exception as e:
    print(f"  ERROR: could not parse .mcp.json ({e})", file=sys.stderr)
    raise SystemExit(1)

disabled = [line.strip() for line in disable_path.read_text(encoding="utf-8").splitlines()
            if line.strip() and not line.strip().startswith("#")]

removed = []
for name in disabled:
    if name in data.get("mcpServers", {}):
        del data["mcpServers"][name]
        removed.append(name)

if removed:
    try:
        mcp_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    except Exception as e:
        print(f"  ERROR: could not write reconciled .mcp.json ({e})", file=sys.stderr)
        raise SystemExit(1)
    print(f"  disabled MCPs re-applied: {', '.join(removed)}", file=sys.stderr)
else:
    print("  no disabled MCPs to re-apply (list empty or names not found in .mcp.json)", file=sys.stderr)
PYEOF
fi

# ─── Step 4: Update installed_plugins.json gitCommitSha + lastUpdated ─
# BUG-008 fix (v1.3.2.2): use Python-native pathlib.Path.home() inside the
# heredoc instead of interpolating $INSTALLED_REGISTRY from bash. On Windows
# Git Bash, $HOME resolves to MSYS-style /c/Users/... which Python on Windows
# cannot open. pathlib.Path.home() uses native filesystem APIs cross-platform.
# Bash-side $INSTALLED_REGISTRY var retained for logging only.
log "Updating installed_plugins.json registry…"
python - <<PYEOF
import json, sys
from datetime import datetime, timezone
from pathlib import Path

# Python-native path resolution (BUG-008 fix per v1.3.2.2).
# Works on Mac, Linux, WSL, Git Bash on Windows, and native Windows Python.
path = str(Path.home() / ".claude" / "plugins" / "installed_plugins.json")
key = "$PLUGIN_NAME@$MARKETPLACE_NAME"
new_sha = "$NEW_SHA"

try:
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    print(f"  ERROR: registry not found at {path} - did you install this plugin via /plugin install?", file=sys.stderr)
    sys.exit(1)  # BUG-008: promote buried WARN to hard-fail ERROR per BUG_TRACKER regression guard
except Exception as e:
    print(f"  ERROR: cannot read registry ({e})", file=sys.stderr)
    sys.exit(1)

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
    # Self-test: re-read and verify SHA round-tripped correctly (per BUG-008 regression guard)
    with open(path, encoding="utf-8") as f:
        verify = json.load(f)
    written_sha = verify["plugins"][key][0]["gitCommitSha"]
    if written_sha != new_sha:
        print(f"  ERROR: registry write verification failed - expected {new_sha[:8]}, got {written_sha[:8]}", file=sys.stderr)
        sys.exit(1)
    print(f"  registry SHA -> {new_sha[:8]} (verified round-trip)", file=sys.stderr)
except Exception as e:
    print(f"  ERROR: registry write failed ({e})", file=sys.stderr)
    sys.exit(1)
PYEOF

# ─── Done ────────────────────────────────────────────────────────────
echo "" >&2
echo "════════════════════════════════════════════════════════════" >&2
echo "✓ Maxim plugin synced to commit ${NEW_SHA:0:8}" >&2
echo "  RESTART Claude Code to load the new content." >&2
echo "  node_modules preserved — no MCP re-install needed." >&2
echo "" >&2
echo "  ⚠ First restart may take 5-10 min on Windows: 9 MCPs cold-spawn" >&2
echo "    concurrently while Windows Defender scans node_modules." >&2
echo "    Subsequent restarts are normal speed. See BUG-008 in" >&2
echo "    documents/ledgers/BUG_TRACKER.md for registry-update caveat." >&2
echo "" >&2
echo "  ⚠ To skip cold-spawn for heavy MCPs (e.g., mxm-notebooklm 38 tools):" >&2
echo "    bash bootstrap/mxm-toggle-mcp.sh disable mxm-notebooklm" >&2
echo "    (v1.3.2.3+; operator opt-out survives plugin upgrades)" >&2
echo "════════════════════════════════════════════════════════════" >&2

exit 0
