#!/bin/bash
set -e

# The Docker Hub image's s6 legacy-services slot tries to exec
# /opt/hermes/railway-start.sh. That path lives under the read-only image
# layer, so we materialize it before s6 starts by writing to a writable
# overlay directory.
mkdir -p /opt/hermes-writable
cp /usr/local/bin/railway-start.sh /opt/hermes-writable/railway-start.sh
chmod +x /opt/hermes-writable/railway-start.sh
# Try bind-mounting it over /opt/hermes/railway-start.sh. If the mount
# fails (e.g. /opt/hermes is itself read-only and overlay-writable), we
# just log a warning — main-hermes and dashboard s6 services don't depend
# on legacy-services, so the container stays up.
if mount --bind /opt/hermes-writable/railway-start.sh /opt/hermes/railway-start.sh 2>/dev/null; then
    echo "[00-prepare] bind-mounted railway-start.sh into /opt/hermes"
else
    echo "[00-prepare] WARNING: bind-mount failed; /opt/hermes is likely read-only. legacy-services will log errors but main-hermes + dashboard remain up."
fi

# Now exec the actual start script.
exec /opt/hermes/docker/entrypoint-dispatch.sh sleep infinity