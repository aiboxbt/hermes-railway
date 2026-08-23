#!/bin/bash
# Disable the s6 `legacy-services` slot whose `run` script points at
# /opt/hermes/railway-start.sh — that path is in the read-only image
# layer so the script doesn't exist. Without this, the failed service
# brings the whole s6 tree down (including main-hermes + dashboard).
#
# We replace the slot's run script with a no-op so it succeeds instantly.
set -e

SLOT="/etc/s6-overlay/s6-rc.d/legacy-services"
if [ -d "$SLOT" ]; then
    if [ -f "$SLOT/run" ]; then
        printf '#!/command/execlineb -P\nfalse\n' > "$SLOT/run"
        chmod +x "$SLOT/run"
        echo "[01-disable-legacy] patched $SLOT/run → false"
    fi
    if [ -d "$SLOT/contents.d" ] && [ ! -f "$SLOT/contents.d/.ignore" ]; then
        # Tell s6-rc to no longer treat this as a producer/essential
        echo "[01-disable-legacy] removing $SLOT/type"
        rm -f "$SLOT/type" 2>/dev/null || true
    fi
else
    echo "[01-disable-legacy] $SLOT not present; nothing to do"
fi
exit 0