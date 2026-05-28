#!/bin/bash
set -e

VOLUME_UID=$(stat -c "%u" /pgrx)
VOLUME_GID=$(stat -c "%g" /pgrx)

# Remap pgrx user to match the volume owner
usermod -u "$VOLUME_UID" pgrx 2>/dev/null
groupmod -g "$VOLUME_GID" pgrx 2>/dev/null

# Fix ownership of pgrx home dirs (cargo, rustup caches, etc.)
chown -R pgrx:pgrx /usr/local/cargo /home/pgrx 2>/dev/null || true

# Drop into an interactive shell as pgrx
exec gosu pgrx "${@:-bash}"
