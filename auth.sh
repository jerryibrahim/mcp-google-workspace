#!/bin/bash
# Authenticate with Google Workspace via the headless OAuth flow.
# Run this once before using the MCP server with Claude.
#
# This will:
# 1. Print an OAuth URL — open it in your browser
# 2. After signing in, the browser shows a JSON blob
# 3. Copy/paste that JSON back into this terminal

set -e

COMPOSE_FILE="$(cd "$(dirname "$0")" && pwd)/docker-compose.yml"

docker compose -f "$COMPOSE_FILE" run --rm -it \
  --entrypoint node \
  google-workspace-mcp \
  workspace-server/dist/headless-login.js "$@"
