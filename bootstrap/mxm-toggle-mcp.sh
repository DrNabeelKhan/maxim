#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
#
# mxm-toggle-mcp.sh - operator opt-in/opt-out for individual Maxim MCPs (v1.3.2.3+).
#
# Why this exists:
#   Heavy MCPs (mxm-notebooklm with Python upstream + 38-tool registry;
#   mempalace with Python venv cold-start) pay 30-60s cold-spawn cost on
#   every Claude Code restart. Operators who use these tools occasionally
#   rather than every session can disable them to keep restart fast.
#
# How it works:
#   - .mcp-disabled file in PLUGIN_ROOT lists disabled MCP names (one per line).
#   - This script edits both .mcp-disabled AND .mcp.json simultaneously.
#   - mxm-self-update.sh re-applies .mcp-disabled after every sync so operator
#     state is preserved across plugin upgrades.
#
# Usage:
#   bash bootstrap/mxm-toggle-mcp.sh disable <mcp-name>     # disable + apply
#   bash bootstrap/mxm-toggle-mcp.sh enable  <mcp-name>     # re-enable + apply
#   bash bootstrap/mxm-toggle-mcp.sh list                   # show disable list
#   bash bootstrap/mxm-toggle-mcp.sh status                 # full status report
#
# After disable/enable: RESTART Claude Code once to pick up the new .mcp.json.
#
# Path resolution uses Python's pathlib.Path.home() inside the heredoc to
# avoid the BUG-008 Windows Git Bash MSYS-path pitfall (resolved v1.3.2.2).

set -uo pipefail

ACTION="${1:-status}"
MCP_NAME="${2:-}"

# Locate install cache + marketplace cache via Python (BUG-008-style path discipline).
PATHS=$(python - <<'PYEOF'
from pathlib import Path
home = Path.home()
install_parent = home / ".claude" / "plugins" / "cache" / "maxim-packs" / "maxim"
marketplace = home / ".claude" / "plugins" / "marketplaces" / "maxim-packs"
if not install_parent.exists():
    print("INSTALL_PARENT_MISSING")
    raise SystemExit(1)
versions = sorted([d for d in install_parent.iterdir() if d.is_dir()])
if not versions:
    print("NO_VERSION_DIR")
    raise SystemExit(1)
install_dir = versions[0]
print(f"INSTALL_DIR={install_dir}")
print(f"MARKETPLACE_DIR={marketplace}")
print(f"DISABLE_LIST={install_dir / '.mcp-disabled'}")
print(f"INSTALL_MCP={install_dir / '.mcp.json'}")
print(f"MARKETPLACE_MCP={marketplace / '.mcp.json'}")
PYEOF
)

eval "$PATHS"

if [ -z "${INSTALL_DIR:-}" ] || [ "$INSTALL_DIR" = "INSTALL_PARENT_MISSING" ] || [ "$INSTALL_DIR" = "NO_VERSION_DIR" ]; then
    echo "ERROR: Maxim plugin install not found. Run /plugin install maxim@maxim-packs first." >&2
    exit 1
fi

# --- Helper: list known MCP names (for validation) ---
known_mcps() {
    python - <<PYEOF
import json
from pathlib import Path
p = Path(r"$MARKETPLACE_MCP")
if not p.exists():
    print("")
    raise SystemExit
data = json.loads(p.read_text(encoding='utf-8'))
print("\n".join(sorted(data.get("mcpServers", {}).keys())))
PYEOF
}

# --- Action dispatch ---

case "$ACTION" in
    disable)
        if [ -z "$MCP_NAME" ]; then
            echo "ERROR: disable requires <mcp-name>" >&2
            echo "Known MCPs:" >&2
            known_mcps >&2
            exit 1
        fi
        # Validate the MCP name exists in the marketplace template.
        if ! known_mcps | grep -qxF "$MCP_NAME"; then
            echo "ERROR: '$MCP_NAME' not in marketplace .mcp.json. Known MCPs:" >&2
            known_mcps >&2
            exit 1
        fi
        # Add to .mcp-disabled (idempotent).
        if [ -f "$DISABLE_LIST" ] && grep -qxF "$MCP_NAME" "$DISABLE_LIST"; then
            echo "INFO: $MCP_NAME already in disable list"
        else
            echo "$MCP_NAME" >> "$DISABLE_LIST"
            echo "OK: added $MCP_NAME to $DISABLE_LIST"
        fi
        # Remove from .mcp.json via Python.
        python - <<PYEOF
import json
from pathlib import Path
p = Path(r"$INSTALL_MCP")
data = json.loads(p.read_text(encoding='utf-8'))
if "$MCP_NAME" in data.get("mcpServers", {}):
    del data["mcpServers"]["$MCP_NAME"]
    p.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding='utf-8')
    print(f"OK: removed $MCP_NAME from .mcp.json")
else:
    print(f"INFO: $MCP_NAME not currently in .mcp.json")
PYEOF
        echo ""
        echo "RESTART Claude Code to apply (disabled MCP will not auto-spawn)."
        echo "To engage $MCP_NAME on demand, run its upstream CLI directly (e.g., 'notebooklm <command>')"
        ;;
    enable)
        if [ -z "$MCP_NAME" ]; then
            echo "ERROR: enable requires <mcp-name>" >&2
            exit 1
        fi
        # Remove from .mcp-disabled.
        if [ -f "$DISABLE_LIST" ]; then
            grep -vxF "$MCP_NAME" "$DISABLE_LIST" > "$DISABLE_LIST.tmp" 2>/dev/null || true
            mv "$DISABLE_LIST.tmp" "$DISABLE_LIST" 2>/dev/null || true
            echo "OK: removed $MCP_NAME from $DISABLE_LIST"
        fi
        # Restore in .mcp.json from marketplace template via Python.
        python - <<PYEOF
import json
from pathlib import Path
p_install = Path(r"$INSTALL_MCP")
p_marketplace = Path(r"$MARKETPLACE_MCP")
install_data = json.loads(p_install.read_text(encoding='utf-8'))
marketplace_data = json.loads(p_marketplace.read_text(encoding='utf-8'))
if "$MCP_NAME" not in marketplace_data.get("mcpServers", {}):
    print(f"ERROR: $MCP_NAME not in marketplace .mcp.json template")
    raise SystemExit(1)
install_data.setdefault("mcpServers", {})["$MCP_NAME"] = marketplace_data["mcpServers"]["$MCP_NAME"]
p_install.write_text(json.dumps(install_data, indent=2, ensure_ascii=False) + "\n", encoding='utf-8')
print(f"OK: restored $MCP_NAME in .mcp.json from marketplace template")
PYEOF
        echo ""
        echo "RESTART Claude Code to apply (MCP will spawn on next startup)."
        ;;
    list|status|*)
        echo "=== Maxim MCP toggle status ==="
        echo "Install dir:   $INSTALL_DIR"
        echo "Disable list:  $DISABLE_LIST"
        echo "Install .mcp:  $INSTALL_MCP"
        echo ""
        echo "=== Disabled MCPs (in .mcp-disabled) ==="
        if [ -f "$DISABLE_LIST" ] && [ -s "$DISABLE_LIST" ]; then
            cat "$DISABLE_LIST"
        else
            echo "(none)"
        fi
        echo ""
        echo "=== Currently registered in .mcp.json (will auto-spawn) ==="
        python -c "import json; from pathlib import Path; print('\n'.join(sorted(json.loads(Path(r'$INSTALL_MCP').read_text(encoding='utf-8')).get('mcpServers', {}).keys())))"
        echo ""
        echo "=== Known MCPs in marketplace template ==="
        known_mcps
        ;;
esac
