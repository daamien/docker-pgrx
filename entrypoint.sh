#!/bin/bash
set -e

VOLUME_UID=$(stat -c "%u" /pgrx)
VOLUME_GID=$(stat -c "%g" /pgrx)

# If needed, remap pgrx user to match the volume owner
[ "$(id -u pgrx)" != "$VOLUME_UID" ] && usermod  -u "$VOLUME_UID" pgrx  > /dev/null 2>&1
[ "$(id -g pgrx)" != "$VOLUME_GID" ] && groupmod -g "$VOLUME_GID" pgrx > /dev/null 2>&1

# Fix ownership of pgrx home dirs (cargo, rustup caches, etc.)
chown -R pgrx:pgrx /usr/local/cargo /home/pgrx 2>/dev/null || true

# Drop into an interactive shell as pgrx
exec gosu pgrx "${@:-bash}"
