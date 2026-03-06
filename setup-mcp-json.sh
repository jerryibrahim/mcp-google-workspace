#!/bin/bash
# Generate a .mcp.json file for use with Claude Code.
#
# Usage:
#   ./setup-mcp-json.sh [target-directory]
#
# If target-directory is provided, the .mcp.json is written there.
# Otherwise it is written to the current directory.

set -e

COMPOSE_FILE="$(cd "$(dirname "$0")" && pwd)/docker-compose.yml"
TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: $TARGET_DIR is not a directory."
  exit 1
fi

OUTPUT="$TARGET_DIR/.mcp.json"

if [ -f "$OUTPUT" ]; then
  echo "$OUTPUT already exists."
  read -p "Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "No changes made."
    exit 0
  fi
fi

cat > "$OUTPUT" <<EOF
{
  "mcpServers": {
    "google-workspace": {
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
  }
}
EOF

echo "Wrote $OUTPUT"
