.PHONY: build up down restart logs auth auth-force auth-status clean

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down
	docker compose up -d

logs:
	docker compose logs -f google-workspace-mcp

auth:
	docker compose run --rm -it --entrypoint node google-workspace-mcp workspace-server/dist/headless-login.js

auth-force:
	docker compose run --rm -it --entrypoint node google-workspace-mcp workspace-server/dist/headless-login.js --force

auth-status:
	docker compose run --rm --entrypoint node google-workspace-mcp scripts/auth-utils.js status

clean:
	docker compose down -v
