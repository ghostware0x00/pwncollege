#!/bin/bash
set -e

HOST_UID="${HOST_UID:?HOST_UID is not set}"
HOST_GID="${HOST_GID:?HOST_GID is not set}"

echo
echo "=============================================="
echo " PwnLab"
echo "=============================================="
echo "[+] Host UID: $HOST_UID"
echo "[+] Host GID: $HOST_GID"

# Remove Ubuntu's default user if present
if getent passwd ubuntu >/dev/null 2>&1; then
    echo "[+] Removing default ubuntu user..."
    userdel -r ubuntu 2>/dev/null || true
fi

if getent group ubuntu >/dev/null 2>&1; then
    groupdel ubuntu 2>/dev/null || true
fi

# Host UID must not be root
if [ "$HOST_UID" = "0" ]; then
    echo "[!] Host UID 0 is not supported."
    exit 1
fi

# Check UID conflict
EXISTING_USER="$(getent passwd "$HOST_UID" | cut -d: -f1 || true)"

if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "pwn" ]; then
    echo "[!] UID $HOST_UID is already used by '$EXISTING_USER'."
    exit 1
fi

# Change UID
CURRENT_UID="$(id -u pwn)"

if [ "$CURRENT_UID" != "$HOST_UID" ]; then
    echo "[+] Changing pwn UID: $CURRENT_UID -> $HOST_UID"
    usermod -u "$HOST_UID" pwn
fi

# Check GID
EXISTING_GROUP="$(getent group "$HOST_GID" | cut -d: -f1 || true)"

if [ -n "$EXISTING_GROUP" ] && [ "$EXISTING_GROUP" != "pwn" ]; then
    echo "[!] GID $HOST_GID is already used by '$EXISTING_GROUP'."
    exit 1
fi

# Change GID
CURRENT_GID="$(id -g pwn)"

if [ "$CURRENT_GID" != "$HOST_GID" ]; then
    echo "[+] Changing pwn GID: $CURRENT_GID -> $HOST_GID"
    groupmod -g "$HOST_GID" pwn
fi

# Fix home ownership
chown "$HOST_UID:$HOST_GID" /home/pwn

echo "[+] Workspace:"
ls -ld /workspace

echo
echo "=============================================="
echo " Starting PwnLab"
echo "=============================================="
echo

# IMPORTANT:
# gosu directly replaces the shell process.
# This gives proper Ctrl+C / SIGINT handling.
exec gosu pwn zsh -l