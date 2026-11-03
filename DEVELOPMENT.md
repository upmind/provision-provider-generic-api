# Development Environment

This project includes a Docker-based PHP development environment that can run PHP 8.3, PHP 8.4 or PHP 8.5.

## Requirements

- Docker Desktop (or Docker Engine with Compose v2)
- GNU Make

## Available PHP Versions

- `8.3` (service: `php83`)
- `8.4` (service: `php84`)
- `8.5` (service: `php85`)

## Start Containers

Use the version shortcuts:

```bash
make up83
# or
make up84
# or
make up85
```

Or specify a version directly:

```bash
make up PHP_VERSION=8.3
make up PHP_VERSION=8.4
make up PHP_VERSION=8.5
```

## Open a Bash Shell

```bash
make shell
```

`make shell` automatically attaches to the only running PHP container.

If more than one PHP container is running, specify a version explicitly:

```bash
make shell PHP_VERSION=8.3
make shell PHP_VERSION=8.4
make shell PHP_VERSION=8.5
```

## Common Commands

```bash
make ps
make logs PHP_VERSION=8.3
make php PHP_VERSION=8.3
make stop PHP_VERSION=8.3
make down
```

## Help

To view all available Make targets:

```bash
make help
```

## Notes

- The repository root is mounted to `/workspace` in each container.
- If `PHP_VERSION` is not provided, `8.3` is used by default.
- Development images include `composer`, `git`, `unzip`, and the PHP `zip` extension.
- Rebuild after changing `Dockerfile` (for example, `make build83`, `make build84` or `make build85`).
