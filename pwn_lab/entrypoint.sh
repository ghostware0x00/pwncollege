#!/bin/bash
set -e

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

# Validate UID/GID
[[ "$HOST_UID" =~ ^[1-9][0-9]*$ ]] || {
    echo "[!] Invalid HOST_UID: $HOST_UID"
    exit 1
}

[[ "$HOST_GID" =~ ^[1-9][0-9]*$ ]] || {
    echo "[!] Invalid HOST_GID: $HOST_GID"
    exit 1
}

# Match container user to host user.
if [ "$(id -g pwn)" != "$HOST_GID" ]; then
    groupmod -g "$HOST_GID" pwn
fi

if [ "$(id -u pwn)" != "$HOST_UID" ]; then
    usermod -u "$HOST_UID" -g "$HOST_GID" pwn
fi

# Fix only files belonging to the container user.
chown -R pwn:pwn /home/pwn

mkdir -p /workspace

echo
echo "[+] PwnLab ready"
echo "[+] User: pwn ($(id -u pwn):$(id -g pwn))"
echo "[+] Workspace: /workspace"
echo

exec gosu pwn "$@"