#!/bin/bash
# Disable the s6 `legacy-services` slot whose run script points at
# /opt/hermes/railway-start.sh — that path is in the read-only image
# layer so the script doesn't exist. Without this, the failed service
# brings the whole s6 tree down (including main-hermes + dashboard).
#
# We replace the slot's run script with a no-op so it succeeds instantly.
set -e

echo "[00-disable-legacy-services] running"

SLOT="/etc/s6-overlay/s6-rc.d/legacy-services"
if [ -d "$SLOT" ]; then
    echo "[00-disable-legacy-services] found $SLOT"
    if [ -f "$SLOT/run" ]; then
        # No-op run script
        printf '#!/command/execlineb -P\nexit 0\n' > "$SLOT/run"
        chmod +x "$SLOT/run"
        echo "[00-disable-legacy-services] patched $SLOT/run"
    fi
    # Also materialise the legacy script so s6 doesn't log errors
    if [ ! -f /opt/hermes/railway-start.sh ]; then
        # /opt/hermes is read-only — try, but don't fail if it errors
        cp /opt/hermes/railway-start.sh.disabled /opt/hermes/railway-start.sh 2>/dev/null || \
          echo "[00-disable-legacy-services] could not write to /opt/hermes (read-only)"
    fi
else
    echo "[00-disable-legacy-services] $SLOT not present; nothing to do"
fi

# Also check the user-s6 directory in case Railway placed it there
for alt in /etc/s6-overlay/s6-rc.d/user/legacy-services /etc/s6-rc.d/legacy-services; do
    if [ -d "$alt" ] && [ -f "$alt/run" ]; then
        printf '#!/command/execlineb -P\nexit 0\n' > "$alt/run"
        chmod +x "$alt/run"
        echo "[00-disable-legacy-services] patched $alt/run"
    fi
done

exit 0