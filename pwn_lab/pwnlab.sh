#!/bin/bash

HOST_UID=$(id -u)
HOST_GID=$(id -g)

exec docker compose run --rm \
    -e HOST_UID="$HOST_UID" \
    -e HOST_GID="$HOST_GID" \
    pwnlab