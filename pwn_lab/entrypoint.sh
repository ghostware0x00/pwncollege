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

# ------------------------------------------------
# UID conflict handling
# ------------------------------------------------

EXISTING_USER="$(getent passwd "$HOST_UID" | cut -d: -f1 || true)"

if [[ -n "$EXISTING_USER" && "$EXISTING_USER" != "pwn" ]]; then
    echo "[!] UID $HOST_UID is already used by '$EXISTING_USER'."

    # Remove the conflicting user if it is a normal
    # image-created user and not pwn.
    userdel -r "$EXISTING_USER" 2>/dev/null || true
fi

# ------------------------------------------------
# GID conflict handling
# ------------------------------------------------

EXISTING_GROUP="$(getent group "$HOST_GID" | cut -d: -f1 || true)"

if [[ -n "$EXISTING_GROUP" && "$EXISTING_GROUP" != "pwn" ]]; then
    echo "[!] GID $HOST_GID is already used by '$EXISTING_GROUP'."

    groupdel "$EXISTING_GROUP" 2>/dev/null || true
fi

# ------------------------------------------------
# Change pwn UID/GID
# ------------------------------------------------

CURRENT_UID="$(id -u pwn)"
CURRENT_GID="$(id -g pwn)"

if [[ "$CURRENT_UID" != "$HOST_UID" ]]; then
    usermod -u "$HOST_UID" pwn
fi

if [[ "$CURRENT_GID" != "$HOST_GID" ]]; then
    groupmod -g "$HOST_GID" pwn
fi

# ------------------------------------------------
# Fix ownership
# ------------------------------------------------

chown -R pwn:pwn /home/pwn
chown -R pwn:pwn /workspace

# ------------------------------------------------
# Display final identity
# ------------------------------------------------

echo
echo "[+] Container identity:"
id pwn

echo
echo "[+] Workspace:"
ls -ld /workspace

echo
echo "=============================================="
echo " Starting PwnLab"
echo "=============================================="
echo

# ------------------------------------------------
# Start Zsh as pwn
# ------------------------------------------------

exec su -s /bin/zsh pwn -c 'cd /workspace && exec zsh -l'