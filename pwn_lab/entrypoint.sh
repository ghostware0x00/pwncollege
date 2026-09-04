#!/bin/bash
set -e

# ================================================================
# PwnLab runtime UID/GID synchronization
# ================================================================

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

# ------------------------------------------------
# Validate UID/GID
# ------------------------------------------------

if ! [[ "$HOST_UID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Invalid HOST_UID: $HOST_UID"
    exit 1
fi

if ! [[ "$HOST_GID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Invalid HOST_GID: $HOST_GID"
    exit 1
fi

# ------------------------------------------------
# Current pwn identity
# ------------------------------------------------

CURRENT_UID="$(id -u pwn)"
CURRENT_GID="$(id -g pwn)"

# ------------------------------------------------
# Change group first
# ------------------------------------------------

if [ "$CURRENT_GID" != "$HOST_GID" ]; then

    EXISTING_GROUP="$(getent group "$HOST_GID" | cut -d: -f1 || true)"

    if [ -n "$EXISTING_GROUP" ] && [ "$EXISTING_GROUP" != "pwn" ]; then
        echo "ERROR: GID $HOST_GID is already used by group '$EXISTING_GROUP'."
        exit 1
    fi

    groupmod -g "$HOST_GID" pwn
fi

# ------------------------------------------------
# Change user UID
# ------------------------------------------------

if [ "$CURRENT_UID" != "$HOST_UID" ]; then

    EXISTING_USER="$(getent passwd "$HOST_UID" | cut -d: -f1 || true)"

    if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "pwn" ]; then
        echo "ERROR: UID $HOST_UID is already used by user '$EXISTING_USER'."
        exit 1
    fi

    usermod -u "$HOST_UID" pwn
fi

# ------------------------------------------------
# Fix ownership of pwn's HOME
# ------------------------------------------------

chown -R pwn:pwn /home/pwn

# ------------------------------------------------
# Workspace
#
# /workspace is a host bind mount.
# DO NOT chown it recursively.
# Its ownership comes from the host.
# ------------------------------------------------

mkdir -p /workspace

# ------------------------------------------------
# Drop root privileges
# ------------------------------------------------

exec gosu pwn "$@"