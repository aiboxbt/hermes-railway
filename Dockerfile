FROM nousresearch/hermes-agent:v2026.8.3

# The published image has an s6 `legacy-services` slot whose run script
# tries to exec /opt/hermes/railway-start.sh. That path is in the
# read-only image layer, so the script never exists and the failed
# service brings the whole s6 tree down (including main-hermes and
# dashboard). Patch the slot to be a no-op before s6 starts.
#
# Strategy: add our own cont-init script that runs FIRST (sorted before
# 01-hermes-setup) and replaces legacy-services/run with a benign
# command. Then exec the normal entrypoint so s6 supervision works as
# designed.
COPY disable-legacy.sh /etc/cont-init.d/00-disable-legacy
RUN chmod +x /etc/cont-init.d/00-disable-legacy

# We don't need the start.sh + bind-mount workaround anymore — leaving
# the original Shinyduo start.sh present for completeness in case a
# user wants to reference it, but the CMD now just exec's the standard
# entrypoint with `sleep infinity` so s6 owns the lifecycle.
COPY start.sh /opt/hermes/railway-start.sh.disabled
RUN chmod +x /opt/hermes/railway-start.sh.disabled || true

CMD ["/opt/hermes/docker/entrypoint-dispatch.sh", "sleep", "infinity"]