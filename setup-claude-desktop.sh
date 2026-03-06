#!/bin/bash
# Configure Claude Desktop to use the Google Workspace MCP server.
# This script safely merges the MCP server config into your existing
# Claude Desktop settings without overwriting other configuration.

set -e

COMPOSE_FILE="$(cd "$(dirname "$0")" && pwd)/docker-compose.yml"
CONFIG_DIR="$HOME/Library/Application Support/Claude"
CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"

MCP_ENTRY=$(cat <<EOF
{
  "command": "docker",
  "args": [
    "compose",
    "-f", "$COMPOSE_FILE",
    "run",
    "--rm",
    "-i",
    "google-workspace-mcp"
  ]
}
EOF
)

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
  # No existing config — create from scratch
  echo "{}" > "$CONFIG_FILE"
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed."
  echo "Install it with: brew install jq"
  exit 1
fi

# Validate existing JSON
if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
  echo "Error: $CONFIG_FILE contains invalid JSON."
  echo "Please fix it manually before running this script."
  exit 1
fi

# Check if already configured
if jq -e '.mcpServers["google-workspace"]' "$CONFIG_FILE" &>/dev/null; then
  echo "google-workspace is already configured in Claude Desktop."
  echo ""
  echo "Current config:"
  jq '.mcpServers["google-workspace"]' "$CONFIG_FILE"
  echo ""
  read -p "Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "No changes made."
    exit 0
  fi
fi

# Merge the MCP server entry into existing config
UPDATED=$(jq --argjson entry "$MCP_ENTRY" '
  .mcpServers //= {} |
  .mcpServers["google-workspace"] = $entry
' "$CONFIG_FILE")

echo "$UPDATED" > "$CONFIG_FILE"

echo "Claude Desktop configured successfully."
echo ""
echo "Restart Claude Desktop to pick up the changes."
