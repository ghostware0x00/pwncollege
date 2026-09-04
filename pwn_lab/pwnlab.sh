#!/bin/bash

set -e

# ================================================================
# PwnLab launcher
# ================================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------
# Check Docker
# ------------------------------------------------

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is not installed."
    echo
    echo "Install Docker using your Linux distribution's package manager."
    exit 1
fi

# ------------------------------------------------
# Check Docker daemon
# ------------------------------------------------

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker is not running or your user cannot access it."
    echo
    echo "Make sure the Docker daemon is running and your user"
    echo "has permission to access Docker."
    exit 1
fi

# ------------------------------------------------
# Automatically detect host identity
# ------------------------------------------------

export HOST_UID="$(id -u)"
export HOST_GID="$(id -g)"

# ------------------------------------------------
# Workspace
# ------------------------------------------------

export PWN_WORKSPACE="${HOME}/pwn"

mkdir -p "$PWN_WORKSPACE"

# ------------------------------------------------
# Build image if necessary, then start container
# ------------------------------------------------

cd "$SCRIPT_DIR"

docker compose build

exec docker compose run --rm pwnlab