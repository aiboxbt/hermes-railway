#!/bin/bash
# Patch the s6 `legacy-services` slot by removing it from the s6-rc
# database so s6 never tries to bring it up. This is a more reliable
# approach than replacing `run` — s6-rc compiles the slot definition
# at scan time, and a later `rm -rf` of the slot directory won't be
# picked up until the next compile-and-reload.
#
# Instead, we manipulate the compiled state at /run/s6-rc to drop the
# service. This is what `s6-rc-bundle` reads.
set -e

# Try to remove the slot before s6-rc scans it. If we miss the window,
# the slot still exists and the failure cascades — but stage2-hook
# runs BEFORE s6-rc starts the user services.
SVC="/etc/s6-overlay/s6-rc.d/legacy-services"
if [ -d "$SVC" ]; then
    rm -rf "$SVC"
    echo "[01-remove-legacy] removed $SVC"
fi

# Also try to remove from /run/service if s6 already scanned (won't be,
# but defensive)
if [ -d "/run/service/legacy-services" ]; then
    rm -rf "/run/service/legacy-services"
fi

exit 0