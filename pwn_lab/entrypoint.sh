#!/bin/bash
set -e

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

# Validate UID/GID
if ! [[ "$HOST_UID" =~ ^[0-9]+$ ]]; then
    echo "[!] Invalid HOST_UID: $HOST_UID"
    exit 1
fi

if ! [[ "$HOST_GID" =~ ^[0-9]+$ ]]; then
    echo "[!] Invalid HOST_GID: $HOST_GID"
    exit 1
fi

# pwn starts as UID/GID 10000 inside the image.
CURRENT_UID="$(id -u pwn)"
CURRENT_GID="$(id -g pwn)"

# Handle GID collision.
EXISTING_GROUP="$(getent group "$HOST_GID" | cut -d: -f1 || true)"

if [ "$CURRENT_GID" != "$HOST_GID" ]; then
    if [ -n "$EXISTING_GROUP" ] && [ "$EXISTING_GROUP" != "pwn" ]; then

        # Ubuntu's default 'ubuntu' group is safe to remove.
        if [ "$EXISTING_GROUP" = "ubuntu" ]; then
            groupdel ubuntu || true
        else
            echo "[!] GID $HOST_GID is already used by group '$EXISTING_GROUP'."
            echo "[!] Cannot safely remap pwn."
            exit 1
        fi
    fi

    groupmod -g "$HOST_GID" pwn
fi

# Handle UID collision.
EXISTING_USER="$(getent passwd "$HOST_UID" | cut -d: -f1 || true)"

if [ "$CURRENT_UID" != "$HOST_UID" ]; then
    if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "pwn" ]; then

        # Ubuntu's default 'ubuntu' user is safe to remove.
        if [ "$EXISTING_USER" = "ubuntu" ]; then
            userdel ubuntu || true
        else
            echo "[!] UID $HOST_UID is already used by user '$EXISTING_USER'."
            echo "[!] Cannot safely remap pwn."
            exit 1
        fi
    fi

    usermod -u "$HOST_UID" -g "$HOST_GID" pwn
fi

# Make the pwn home directory owned by the remapped user.
chown -R pwn:pwn /home/pwn

# Ensure workspace exists.
mkdir -p /workspace

echo "[+] PwnLab user: pwn"
echo "[+] UID: $(id -u pwn)"
echo "[+] GID: $(id -g pwn)"
echo "[+] Workspace: /workspace"

# Drop privileges and start the requested command.
exec gosu pwn "$@"