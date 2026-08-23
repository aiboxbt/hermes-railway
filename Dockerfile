FROM nousresearch/hermes-agent:v2026.8.3

# The published image has an s6 `legacy-services` slot whose run script
# tries to exec /opt/hermes/railway-start.sh. That path is in the
# read-only image layer, so the script never exists and the failed
# service brings the whole s6 tree down (including main-hermes and
# dashboard). Patch the slot to be a no-op before s6 starts.
#
# Strategy: replace the slot's run script with a no-op in-place. The
# image's stage2-hook.sh runs after stage2 (which mkdir /opt/data and
# sync skills), but BEFORE s6-rc services start. So patching the slot
# in the COPY below means the patched version is the one s6-rc runs.
COPY disable-legacy.sh /etc/s6-overlay/s6-rc.d/legacy-services/run
RUN chmod +x /etc/s6-overlay/s6-rc.d/legacy-services/run

CMD ["/opt/hermes/docker/entrypoint-dispatch.sh", "sleep", "infinity"]
