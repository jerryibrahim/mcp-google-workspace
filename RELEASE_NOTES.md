# Release Notes

## v1.0.0

Initial release.

### Features

- Dockerized Google Workspace MCP server cloned and built from the
  upstream [gemini-cli-extensions/workspace](https://github.com/gemini-cli-extensions/workspace)
  repository
- Multi-stage Docker build with cross-platform support (amd64/arm64)
- Persistent OAuth credentials via named Docker volume
- Fixed container hostname to ensure stable token encryption/decryption
- File-based encrypted token storage (keychain-free)
- Headless OAuth authentication flow for Docker environments
- Setup scripts for Claude Desktop (`setup-claude-desktop.sh`) and
  Claude Code (`setup-mcp-json.sh`)
- Makefile with commands for build, auth, status, and cleanup

### Supported Google Workspace Services

- Google Drive
- Google Docs
- Google Sheets
- Google Slides
- Google Calendar
- Gmail
- Google Chat
- Google People

### Known Issues

- The upstream server prints a startup message to stderr on each launch;
  this is cosmetic and does not affect MCP communication
- `make auth-status` requires a rebuild if upgrading from an earlier
  development version (the auth-utils bundle was not included previously)
