#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.
#
# mxm-desktop-config.sh — Auto-configure Claude Desktop with all 9 Maxim MCPs.
#
# Cross-platform: macOS · Linux · WSL · Git Bash on Windows.
# Operator-friendly: one-line setup, no manual JSON editing required.
#
# Usage:
#   bash bootstrap/mxm-desktop-config.sh
#
# What it does:
#   1. Detects OS, locates claude_desktop_config.json
#   2. Backs up existing config to .bak-pre-maxim-<timestamp>
#   3. Locates Maxim plugin install cache (auto-detects version)
#   4. Merges 9 Maxim MCP server entries into mcpServers (preserves existing
#      entries like vazir + your preferences block)
#   5. Validates JSON
#   6. Reports next steps (restart Claude Desktop)
#
# Idempotent: safe to re-run. If MCPs are already configured, updates the paths
# to the latest plugin cache version.

set -euo pipefail

# ─── Color output ─────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; NC=''
fi

info()  { echo -e "${CYAN}-> $*${NC}"; }
ok()    { echo -e "${GREEN}OK${NC} $*"; }
warn()  { echo -e "${YELLOW}WARN${NC} $*"; }
fail()  { echo -e "${RED}FAIL${NC} $*"; exit 1; }

# ─── Detect OS + config path ──────────────────────────────────────────────────
OS="$(uname -s)"
case "$OS" in
  Darwin*)
    CONFIG_DIR="$HOME/Library/Application Support/Claude"
    PLATFORM="macOS"
    ;;
  Linux*)
    CONFIG_DIR="$HOME/.config/Claude"
    PLATFORM="Linux"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    CONFIG_DIR="$APPDATA/Claude"
    PLATFORM="Windows (Git Bash)"
    ;;
  *)
    fail "Unsupported OS: $OS"
    ;;
esac

CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"

info "Platform: $PLATFORM"
info "Config dir: $CONFIG_DIR"

if [[ ! -d "$CONFIG_DIR" ]]; then
  warn "Claude Desktop config dir not found at: $CONFIG_DIR"
  warn "Is Claude Desktop installed? Download: https://claude.ai/download"
  fail "Aborting — install Claude Desktop first, then re-run this script."
fi

# ─── Locate plugin install cache ──────────────────────────────────────────────
PLUGIN_CACHE="$HOME/.claude/plugins/cache/maxim-packs/maxim"

if [[ ! -d "$PLUGIN_CACHE" ]]; then
  fail "Maxim plugin not installed. Run '/plugin install maxim@maxim-packs' in Claude Code first."
fi

# Auto-detect plugin version (most recently modified dir)
PLUGIN_VERSION=$(ls -1t "$PLUGIN_CACHE" | head -n1)
PLUGIN_ROOT="$PLUGIN_CACHE/$PLUGIN_VERSION"
WRAPPER="$PLUGIN_ROOT/mcp/_shared/spawn-with-deps.mjs"

if [[ ! -f "$WRAPPER" ]]; then
  fail "spawn-with-deps.mjs not found at: $WRAPPER. Plugin install incomplete?"
fi

info "Plugin version: $PLUGIN_VERSION"
info "Plugin root: $PLUGIN_ROOT"

# ─── Backup existing config ───────────────────────────────────────────────────
TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
BACKUP_FILE="$CONFIG_FILE.bak-pre-maxim-$TIMESTAMP"

if [[ -f "$CONFIG_FILE" ]]; then
  cp "$CONFIG_FILE" "$BACKUP_FILE"
  ok "Backup created: $(basename "$BACKUP_FILE")"
else
  info "No existing config — creating fresh."
  echo '{"mcpServers":{}}' > "$CONFIG_FILE"
fi

# ─── Build the 8 MCP entries ──────────────────────────────────────────────────
build_mcp_entry() {
  local name=$1
  cat <<EOF
{"command":"node","args":["$WRAPPER","$PLUGIN_ROOT/mcp/$name/server.js"],"env":{}}
EOF
}

# ─── Merge with existing config using node ───────────────────────────────────
if ! command -v node >/dev/null 2>&1; then
  fail "node not found on PATH. Install Node.js 20+ from https://nodejs.org"
fi

info "Merging 9 Maxim MCP entries into mcpServers (preserving existing entries)..."

node - "$CONFIG_FILE" "$WRAPPER" "$PLUGIN_ROOT" <<'NODESCRIPT'
const fs = require('fs');
const [, , configFile, wrapper, pluginRoot] = process.argv;
const config = JSON.parse(fs.readFileSync(configFile, 'utf8'));
config.mcpServers = config.mcpServers || {};

const servers = ['mxm-portfolio','mxm-context','mxm-catalog','mxm-compliance','mxm-behavioral','mxm-memory','mxm-voice','mxm-commands','mxm-notebooklm'];

for (const name of servers) {
  config.mcpServers[name] = {
    command: 'node',
    args: [wrapper, `${pluginRoot}/mcp/${name}/server.js`],
    env: {}
  };
}

fs.writeFileSync(configFile, JSON.stringify(config, null, 2) + '\n');
console.log(`Wrote ${Object.keys(config.mcpServers).length} mcpServers entries total (8 Maxim + ${Object.keys(config.mcpServers).length - 8} preserved).`);
NODESCRIPT

# ─── Validate the result ──────────────────────────────────────────────────────
if ! node -e "JSON.parse(require('fs').readFileSync('$CONFIG_FILE','utf8'))" 2>/dev/null; then
  warn "Config JSON failed validation — restoring backup."
  cp "$BACKUP_FILE" "$CONFIG_FILE"
  fail "Validation failed. Original config restored. Open an issue with the .bak file attached."
fi

ok "JSON validated."

# ─── Pre-install MCP deps (v1.2.0.3+) ────────────────────────────────────────
# Claude Desktop's MCP client has a ~60s `initialize` timeout. Without this
# pre-warm, the first Desktop launch hits the cold spawn-with-deps install
# loop (~30–60s for 7 servers) and times out — reporting "failed" servers
# that are actually still running. Pre-installing here moves that cost into
# this script (where the operator is already watching progress) so the very
# first Desktop launch finds all node_modules in place and short-circuits.
#
# Sentinel `.mcp-deps-installed` makes spawn-with-deps skip its install path
# on every subsequent spawn. Idempotent — re-running this script is safe.

info "Pre-installing MCP server dependencies (eliminates Desktop first-launch timeout)..."

PREINSTALL_COUNT=0
PREINSTALL_SKIPPED=0
PREINSTALL_FAILED=0

for srv in "$PLUGIN_ROOT/mcp/"mxm-*; do
  [[ -d "$srv" ]] || continue
  srv_name=$(basename "$srv")
  if [[ ! -f "$srv/package.json" ]]; then
    PREINSTALL_SKIPPED=$((PREINSTALL_SKIPPED+1))
    continue
  fi
  if [[ -d "$srv/node_modules" ]] && [[ -f "$PLUGIN_ROOT/.mcp-deps-installed" ]]; then
    PREINSTALL_SKIPPED=$((PREINSTALL_SKIPPED+1))
    continue
  fi
  echo -n "  installing $srv_name… "
  if (cd "$srv" && npm install --omit=dev --no-audit --no-fund --silent 2>/dev/null); then
    echo "ok"
    PREINSTALL_COUNT=$((PREINSTALL_COUNT+1))
  else
    echo "FAIL"
    PREINSTALL_FAILED=$((PREINSTALL_FAILED+1))
  fi
done

if [[ $PREINSTALL_FAILED -eq 0 ]]; then
  # Write sentinel so spawn-with-deps short-circuits on every future spawn
  cat > "$PLUGIN_ROOT/.mcp-deps-installed" <<EOF
{
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "installed_count": $PREINSTALL_COUNT,
  "skipped_count": $PREINSTALL_SKIPPED,
  "plugin_root": "$PLUGIN_ROOT",
  "installer": "bootstrap/mxm-desktop-config.sh"
}
EOF
  ok "MCP deps ready (installed: $PREINSTALL_COUNT, already-present: $PREINSTALL_SKIPPED). Sentinel written."
else
  warn "MCP install partial (installed: $PREINSTALL_COUNT, failed: $PREINSTALL_FAILED). First Desktop launch may still hit timeout."
fi

# ─── Report final state ───────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}=========================================================${NC}"
echo -e "${GREEN}  Maxim Desktop MCP setup complete${NC}"
echo -e "${GREEN}=========================================================${NC}"
echo ""
echo -e "  Config:  $CONFIG_FILE"
echo -e "  Backup:  $(basename "$BACKUP_FILE")"
echo -e "  Plugin:  $PLUGIN_VERSION"
echo -e "  Servers: 9 Maxim MCPs (87 tools total)"
echo -e "  Deps:    pre-installed ($PREINSTALL_COUNT new, $PREINSTALL_SKIPPED already-present)"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "  1. ${YELLOW}Quit Claude Desktop completely${NC} (Cmd-Q on Mac, fully exit on Windows/Linux)"
echo -e "  2. Reopen Claude Desktop"
echo -e "  3. All 9 Maxim MCPs (49 tools) appear immediately — no first-launch wait."
echo ""
echo -e "${CYAN}Optional — activate behavioral layer in Desktop Projects:${NC}"
echo -e "  Paste contents of ${YELLOW}documents/cross-surface/maxim-project-instructions.md${NC}"
echo -e "  into any Desktop Project's Instructions field for ~85% fidelity."
echo ""
