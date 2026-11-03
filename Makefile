COMPOSE ?= docker compose
PHP_VERSION ?= 8.3
PHP_VERSION_ORIGIN := $(origin PHP_VERSION)
SERVICE := php$(subst .,,$(PHP_VERSION))

.PHONY: help build build83 build84 build85 up up83 up84 up85 stop stop83 stop84 stop85 down restart ps logs shell bash php

help:
	@echo "Usage:"
	@echo "  make up PHP_VERSION=8.3|8.4|8.5    Start selected PHP container"
	@echo "  make up83                          Start PHP 8.3 container"
	@echo "  make up84                          Start PHP 8.4 container"
	@echo "  make up85                          Start PHP 8.5 container"
	@echo "  make stop PHP_VERSION=8.3|8.4|8.5  Stop selected PHP container"
	@echo "  make down                          Stop and remove all containers"
	@echo "  make shell                         Open shell in the only running PHP container"
	@echo "  make shell PHP_VERSION=8.3|8.4|8.5 Open shell in selected PHP container"
	@echo "  make logs PHP_VERSION=8.3|8.4|8.5  Follow logs of selected container"
	@echo "  make build PHP_VERSION=8.3|8.4|8.5 Build selected PHP image"
	@echo "  make build83                       Build PHP 8.3 image"
	@echo "  make build84                       Build PHP 8.4 image"
	@echo "  make build85                       Build PHP 8.5 image"
	@echo "  make ps                            Show running containers"

build:
	@$(MAKE) validate-version
	$(COMPOSE) build $(SERVICE)

build83:
	@$(MAKE) build PHP_VERSION=8.3

build84:
	@$(MAKE) build PHP_VERSION=8.4

build85:
	@$(MAKE) build PHP_VERSION=8.5

up:
	@$(MAKE) validate-version
	$(COMPOSE) up -d $(SERVICE)

up83:
	@$(MAKE) up PHP_VERSION=8.3

up84:
	@$(MAKE) up PHP_VERSION=8.4

up85:
	@$(MAKE) up PHP_VERSION=8.5

stop:
	@$(MAKE) validate-version
	$(COMPOSE) stop $(SERVICE)

stop83:
	@$(MAKE) stop PHP_VERSION=8.3

stop84:
	@$(MAKE) stop PHP_VERSION=8.4

stop85:
	@$(MAKE) stop PHP_VERSION=8.5

down:
	$(COMPOSE) down

restart:
	@$(MAKE) validate-version
	$(COMPOSE) restart $(SERVICE)

ps:
	$(COMPOSE) ps

logs:
	@$(MAKE) validate-version
	$(COMPOSE) logs -f $(SERVICE)

shell:
	@running_services="$$($(COMPOSE) ps --services --status running | grep -E '^php(83|84|85)$$' || true)"; \
	if [ "$(PHP_VERSION_ORIGIN)" = "command line" ] || [ "$(PHP_VERSION_ORIGIN)" = "environment" ]; then \
		$(MAKE) -s validate-version; \
		target_service="$(SERVICE)"; \
	else \
		running_count="$$(printf "%s\n" "$$running_services" | sed '/^$$/d' | wc -l | tr -d ' ')"; \
		if [ "$$running_count" = "1" ]; then \
			target_service="$$running_services"; \
		elif [ "$$running_count" = "0" ]; then \
			echo "Error: no PHP container is running. Start one with 'make up83', 'make up84' or 'make up85'."; \
			exit 1; \
		else \
			echo "Error: multiple PHP containers are running. Use 'make shell PHP_VERSION=8.3', 'make shell PHP_VERSION=8.4' or 'make shell PHP_VERSION=8.5'."; \
			exit 1; \
		fi; \
	fi; \
	$(COMPOSE) exec "$$target_service" bash

bash: shell

php:
	@$(MAKE) validate-version
	$(COMPOSE) exec $(SERVICE) php -v

validate-version:
	@if [ "$(PHP_VERSION)" != "8.3" ] && [ "$(PHP_VERSION)" != "8.4" ] && [ "$(PHP_VERSION)" != "8.5" ]; then \
		echo "Error: PHP_VERSION must be 8.3, 8.4 or 8.5 (got '$(PHP_VERSION)')"; \
		exit 1; \
	fi
