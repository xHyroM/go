init:
	make install
	make setup-env

install:
	shards install
	bun install

setup-env:
	@echo "# MYSQL" >> .env
	@echo "MYSQL_USER=something" >> .env
	@echo "MYSQL_PASSWORD=something" >> .env
	@echo "MYSQL_IP=0.0.0.0" >> .env
	@echo "" >> .env
	@echo "# GITHUB MULTI AUTH PROVIDER" >> .env
	@echo "GTIHUB_CLIENT_ID=000000" >> .env
	@echo "GITHUB_CLIENT_SECRET=00000" >> .env
	@echo "" >> .env

build:
	bun run build

lint:
	bun run lint
	bun run format

tests:
	bun run tests

run:
	bun run run

dev:
	bun run dev