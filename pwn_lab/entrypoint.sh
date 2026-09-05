#!/bin/bash
set -e

# ================================================================
# PwnLab Runtime Entrypoint
#
# Synchronizes the container's pwn UID/GID with the host user.
#
# This allows /workspace to be bind-mounted from the host while
# keeping files owned by the normal host user.
# ================================================================

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

# ------------------------------------------------
# Validate UID/GID
# ------------------------------------------------

if ! [[ "$HOST_UID" =~ ^[0-9]+$ ]]; then
    echo "[!] Invalid HOST_UID: $HOST_UID"
    exit 1
fi

if ! [[ "$HOST_GID" =~ ^[0-9]+$ ]]; then
    echo "[!] Invalid HOST_GID: $HOST_GID"
    exit 1
fi

if [ "$HOST_UID" -eq 0 ] || [ "$HOST_GID" -eq 0 ]; then
    echo "[!] Running PwnLab as root is not supported."
    exit 1
fi

# ------------------------------------------------
# Remove Ubuntu's default user if it conflicts
# with the host UID/GID.
#
# Ubuntu 24.04 may contain:
#
# ubuntu = UID 1000
#
# We don't need that account inside PwnLab.
# ------------------------------------------------

EXISTING_USER="$(getent passwd "$HOST_UID" | cut -d: -f1 || true)"

if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "pwn" ]; then
    if [ "$EXISTING_USER" = "ubuntu" ]; then
        echo "[+] Removing unused Ubuntu default user..."
        userdel -r ubuntu 2>/dev/null || userdel ubuntu
    else
        echo "[!] UID $HOST_UID is already used by '$EXISTING_USER'."
        echo "[!] Refusing to modify an unrelated container user."
        exit 1
    fi
fi

# ------------------------------------------------
# Handle GID conflict
# ------------------------------------------------

EXISTING_GROUP="$(getent group "$HOST_GID" | cut -d: -f1 || true)"

if [ -n "$EXISTING_GROUP" ] && [ "$EXISTING_GROUP" != "pwn" ]; then
    echo "[!] GID $HOST_GID is already used by '$EXISTING_GROUP'."

    # The ubuntu group may remain after user removal.
    if [ "$EXISTING_GROUP" = "ubuntu" ]; then
        echo "[+] Removing unused Ubuntu default group..."
        groupdel ubuntu || true
    else
        echo "[!] Refusing to modify an unrelated container group."
        exit 1
    fi
fi

# ------------------------------------------------
# Synchronize pwn GID
# ------------------------------------------------

CURRENT_GID="$(id -g pwn)"

if [ "$CURRENT_GID" != "$HOST_GID" ]; then
    echo "[+] Changing pwn GID: $CURRENT_GID -> $HOST_GID"
    groupmod -g "$HOST_GID" pwn
fi

# ------------------------------------------------
# Synchronize pwn UID
# ------------------------------------------------

CURRENT_UID="$(id -u pwn)"

if [ "$CURRENT_UID" != "$HOST_UID" ]; then
    echo "[+] Changing pwn UID: $CURRENT_UID -> $HOST_UID"
    usermod -u "$HOST_UID" -g "$HOST_GID" pwn
fi

# ------------------------------------------------
# Fix ownership of the pwn home directory
#
# DO NOT chown /workspace.
#
# /workspace is the host bind mount and now has matching
# numeric UID/GID automatically.
# ------------------------------------------------

chown -R pwn:pwn /home/pwn

# ------------------------------------------------
# Ensure workspace exists
# ------------------------------------------------

mkdir -p /workspace

# ------------------------------------------------
# Information
# ------------------------------------------------

echo
echo "[+] PwnLab ready"
echo "[+] User:      pwn"
echo "[+] UID:       $(id -u pwn)"
echo "[+] GID:       $(id -g pwn)"
echo "[+] Workspace: /workspace"
echo

# ------------------------------------------------
# Drop root privileges and launch the container
# ------------------------------------------------

exec gosu pwn "$@"