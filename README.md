# Google Workspace MCP Server (Docker)

A Dockerized [Google Workspace MCP server](https://github.com/gemini-cli-extensions/workspace)
that works with Claude Desktop, Claude Code, or any MCP client.
Provides 50+ tools for interacting with Google Workspace from your AI agent.

## Supported Services

- **Google Drive** -- search, download, trash, rename, create folders
- **Google Docs** -- create, read, write, replace, format text
- **Google Sheets** -- read cells/ranges, find, get metadata
- **Google Slides** -- read text, get images/thumbnails
- **Google Calendar** -- list/create/update/delete events, find free time
- **Gmail** -- search, read, send, draft, label management
- **Google Chat** -- list spaces, send messages, DMs
- **People** -- user profiles, relations

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- A Google account

## Quick Start

### 1. Build

```bash
make build
```

### 2. Authenticate

```bash
make auth
```

This runs a headless OAuth flow:

1. A URL is printed -- open it in your browser
2. Sign in with your Google account
3. The browser displays a JSON blob with your credentials
4. Paste that JSON back into the terminal

Credentials are stored in a Docker volume and persist across container restarts.

### 3. Connect to Claude

**Claude Desktop:**

```bash
./setup-claude-desktop.sh
```

Then restart Claude Desktop.

**Claude Code:**

Generate a `.mcp.json` in any project directory to give Claude Code access
to Google Workspace:

```bash
# Current directory
/path/to/mcp-google-workspace/setup-mcp-json.sh

# Or specify a target project
/path/to/mcp-google-workspace/setup-mcp-json.sh ~/code/my-project
```

Then start Claude Code from that project directory.

## Make Commands

| Command            | Description                                           |
| ------------------ | ----------------------------------------------------- |
| `make build`       | Build the Docker image                                |
| `make auth`        | Run the headless OAuth flow                           |
| `make auth-force`  | Re-authenticate (overwrite existing credentials)      |
| `make auth-status` | Check if credentials are valid/expired                |
| `make clean`       | Stop containers and **delete the credentials volume** |

## How It Works

The upstream [gemini-cli-extensions/workspace](https://github.com/gemini-cli-extensions/workspace)
repo is a standard MCP server using `@modelcontextprotocol/sdk` with stdio transport.
Despite the name, it is not Gemini-specific.

This project wraps it in Docker with:

- **Multi-stage build** that clones and builds from the upstream repo directly
- **Persistent credentials** via a named Docker volume with symlinks
- **Fixed hostname** to ensure encrypted token files can be decrypted across container runs
- **File-based token storage** (the keychain backend is unavailable in Docker)

## Troubleshooting

### No browser available for authentication

Your credentials are missing or expired.
Run `make auth` (or `make auth-force` to re-authenticate).

### Check credential status

```bash
make auth-status
```

### View MCP server logs (Claude Desktop)

```bash
cat ~/Library/Logs/Claude/mcp-server-google-workspace.log
```

### Nuclear reset

Deletes credentials -- you will need to re-authenticate:

```bash
make clean
make build
make auth
```

---

[Release Notes](RELEASE_NOTES.md)
