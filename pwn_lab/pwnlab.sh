#!/bin/bash
set -Eeuo pipefail

# ================================================================
# PwnLab launcher
# ================================================================

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

PWN_WORKSPACE="$HOME/pwn"

# ------------------------------------------------
# Create workspace if necessary
# ------------------------------------------------

mkdir -p "$PWN_WORKSPACE"

echo "[+] Host UID: $HOST_UID"
echo "[+] Host GID: $HOST_GID"
echo "[+] Workspace: $PWN_WORKSPACE"

# ------------------------------------------------
# Build image
# ------------------------------------------------

echo
echo "[+] Building PwnLab image..."

docker build \
    -t pwnlab:local \
    .

# ------------------------------------------------
# Run container
# ------------------------------------------------

echo
echo "[+] Starting PwnLab..."

exec docker run \
    --rm \
    -it \
    --init \
    --hostname pwnlab \
    \
    -e HOST_UID="$HOST_UID" \
    -e HOST_GID="$HOST_GID" \
    -e TERM=xterm-256color \
    -e COLORTERM=truecolor \
    \
    -v "$PWN_WORKSPACE:/workspace" \
    \
    --cap-drop=ALL \
    --cap-add=SYS_PTRACE \
    \
    pwnlab:local