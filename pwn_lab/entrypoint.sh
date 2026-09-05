#!/bin/bash
set -Eeuo pipefail

# ================================================================
# PwnLab runtime identity setup
#
# Goals:
#   - Match pwn UID to host UID
#   - Match pwn's primary GID to host GID
#   - Handle existing UID/GID collisions safely
#   - Never modify /workspace ownership
#   - Never modify arbitrary system users/groups
#   - Keep /home/pwn owned by pwn
# ================================================================

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

PWN_USER="pwn"
PWN_HOME="/home/pwn"
WORKSPACE="/workspace"

log() {
    echo "[+] $*"
}

warn() {
    echo "[!] $*" >&2
}

die() {
    echo "[ERROR] $*" >&2
    exit 1
}

# ------------------------------------------------
# Validate HOST_UID / HOST_GID
# ------------------------------------------------

[[ "$HOST_UID" =~ ^[0-9]+$ ]] || die "Invalid HOST_UID: $HOST_UID"
[[ "$HOST_GID" =~ ^[0-9]+$ ]] || die "Invalid HOST_GID: $HOST_GID"

# Prevent dangerous UID/GID values.
# 0 is root and should never be assigned to pwn.
(( HOST_UID > 0 )) || die "HOST_UID cannot be 0"
(( HOST_GID > 0 )) || die "HOST_GID cannot be 0"

# Linux UID/GID upper bound.
(( HOST_UID <= 4294967295 )) || die "HOST_UID out of range"
(( HOST_GID <= 4294967295 )) || die "HOST_GID out of range"

# ------------------------------------------------
# Verify pwn exists
# ------------------------------------------------

id "$PWN_USER" >/dev/null 2>&1 || die "User '$PWN_USER' does not exist"

PWN_CURRENT_UID="$(id -u "$PWN_USER")"
PWN_CURRENT_GID="$(id -g "$PWN_USER")"

log "Requested host identity: UID=$HOST_UID GID=$HOST_GID"
log "Current pwn identity:    UID=$PWN_CURRENT_UID GID=$PWN_CURRENT_GID"

# ================================================================
# UID handling
# ================================================================

if [[ "$PWN_CURRENT_UID" != "$HOST_UID" ]]; then

    EXISTING_USER="$(getent passwd "$HOST_UID" | cut -d: -f1 || true)"

    if [[ -n "$EXISTING_USER" && "$EXISTING_USER" != "$PWN_USER" ]]; then

        warn "UID $HOST_UID is already used by '$EXISTING_USER'."

        # We do NOT steal another user's UID.
        #
        # This situation is uncommon in a normal Ubuntu container
        # because host UIDs such as 1000 usually don't exist as users.
        #
        # If the UID is occupied, we need to determine whether
        # pwn can safely use it through an existing user.
        #
        # The safest behavior is to fail instead of modifying
        # an unrelated system account.

        die "Cannot assign UID $HOST_UID to '$PWN_USER' because it is already occupied by '$EXISTING_USER'."
    fi

    log "Changing pwn UID: $PWN_CURRENT_UID -> $HOST_UID"

    usermod \
        --uid "$HOST_UID" \
        "$PWN_USER"

else

    log "UID already matches: $HOST_UID"

fi

# ================================================================
# GID handling
# ================================================================

PWN_CURRENT_GID="$(id -g "$PWN_USER")"

if [[ "$PWN_CURRENT_GID" != "$HOST_GID" ]]; then

    EXISTING_GROUP="$(getent group "$HOST_GID" | cut -d: -f1 || true)"

    if [[ -n "$EXISTING_GROUP" ]]; then

        # --------------------------------------------------------
        # The requested GID already exists.
        #
        # Don't groupmod it because that could modify an
        # unrelated system group.
        #
        # Instead, make pwn use the existing group.
        # --------------------------------------------------------

        log "GID $HOST_GID already exists as group '$EXISTING_GROUP'."
        log "Using existing group '$EXISTING_GROUP' for pwn."

        usermod \
            --gid "$EXISTING_GROUP" \
            "$PWN_USER"

    else

        # --------------------------------------------------------
        # Requested GID doesn't exist.
        #
        # Safe to move pwn's existing primary group.
        # --------------------------------------------------------

        PWN_GROUP="$(id -gn "$PWN_USER")"

        log "Changing pwn group '$PWN_GROUP': GID $PWN_CURRENT_GID -> $HOST_GID"

        groupmod \
            --gid "$HOST_GID" \
            "$PWN_GROUP"

    fi

else

    log "GID already matches: $HOST_GID"

fi

# ================================================================
# Re-read identity after modifications
# ================================================================

FINAL_UID="$(id -u "$PWN_USER")"
FINAL_GID="$(id -g "$PWN_USER")"
FINAL_GROUP="$(id -gn "$PWN_USER")"

# ------------------------------------------------
# Final sanity checks
# ------------------------------------------------

[[ "$FINAL_UID" == "$HOST_UID" ]] || \
    die "UID synchronization failed: expected $HOST_UID, got $FINAL_UID"

[[ "$FINAL_GID" == "$HOST_GID" ]] || \
    die "GID synchronization failed: expected $HOST_GID, got $FINAL_GID"

# Never allow pwn to become root.
[[ "$FINAL_UID" != "0" ]] || die "Refusing to run pwn as root"
[[ "$FINAL_GID" != "0" ]] || die "Refusing to use root as pwn's primary group"

# ================================================================
# Container-owned files
# ================================================================

# IMPORTANT:
# /workspace is a bind mount from the host.
# NEVER chown it here.
#
# /home/pwn belongs to the container, so fixing its ownership
# is safe.

if [[ -d "$PWN_HOME" ]]; then
    chown -R "$FINAL_UID:$FINAL_GID" "$PWN_HOME"
fi

# ------------------------------------------------
# Workspace
# ------------------------------------------------

mkdir -p "$WORKSPACE"

# Do NOT chown workspace.
# Its ownership comes from the host bind mount.

# ================================================================
# Final information
# ================================================================

echo
echo "================================================"
echo " PwnLab ready"
echo "================================================"
echo " User:      $PWN_USER"
echo " UID:       $FINAL_UID"
echo " GID:       $FINAL_GID"
echo " Group:     $FINAL_GROUP"
echo " Workspace: $WORKSPACE"
echo "================================================"
echo

# ================================================================
# Drop privileges
# ================================================================

exec gosu "$PWN_USER" "$@"