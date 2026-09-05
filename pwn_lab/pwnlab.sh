#!/bin/bash
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Detecting host user..."
export HOST_UID="$(id -u)"
export HOST_GID="$(id -g)"

echo "[+] Host UID: $HOST_UID"
echo "[+] Host GID: $HOST_GID"

# Workspace on the host.
export PWN_WORKSPACE="${HOME}/pwn"

mkdir -p "$PWN_WORKSPACE"

# Check Docker.
if ! command -v docker >/dev/null 2>&1; then
    echo "[!] Docker is not installed."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "[!] Docker is not running or your user cannot access Docker."
    exit 1
fi

cd "$SCRIPT_DIR"

echo "[+] Building PwnLab image..."
docker build -t pwnlab:local .

echo "[+] Starting PwnLab..."
echo "[+] Workspace: $PWN_WORKSPACE"
echo

exec docker run \
    --rm \
    -it \
    --init \
    --hostname pwnlab \
    -e HOST_UID="$HOST_UID" \
    -e HOST_GID="$HOST_GID" \
    -e TERM=xterm-256color \
    -e COLORTERM=truecolor \
    -v "$PWN_WORKSPACE:/workspace" \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    pwnlab:local