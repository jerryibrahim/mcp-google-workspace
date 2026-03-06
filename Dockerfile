FROM --platform=$BUILDPLATFORM node:22-slim AS build

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/gemini-cli-extensions/workspace.git .

RUN npm ci --ignore-scripts

RUN npm run build && cd workspace-server && node esbuild.auth-utils.js

FROM node:22-slim

WORKDIR /app

COPY --from=build /app .

# Force file-based token storage (no keychain in Docker)
ENV GEMINI_CLI_WORKSPACE_FORCE_FILE_STORAGE=true

# Symlink token files to a persistent volume so credentials survive container restarts.
# The server stores tokens at the project root (next to gemini-extension.json):
#   - gemini-cli-workspace-token.json  (encrypted OAuth tokens)
#   - .gemini-cli-workspace-master-key (encryption key)
RUN mkdir -p /app/credentials \
    && ln -sf /app/credentials/gemini-cli-workspace-token.json /app/gemini-cli-workspace-token.json \
    && ln -sf /app/credentials/.gemini-cli-workspace-master-key /app/.gemini-cli-workspace-master-key

ENTRYPOINT ["node", "workspace-server/dist/index.js"]
