FROM nousresearch/hermes-agent:v2026.8.3

# The published image has an s6 `legacy-services` slot that tries to
# exec /opt/hermes/railway-start.sh (a path baked into the read-only
# image layer that never exists). When that service fails, s6 brings
# the entire tree down — including main-hermes and dashboard.
#
# Strategy: replace the slot's run script with a no-op AND remove its
# type marker so s6-rc treats it as a successful up-for-grabs service
# rather than a failed one. We also stub the contents.d dependencies
# so it has no upstreams to wait on.
COPY disable-legacy.sh /etc/s6-overlay/s6-rc.d/legacy-services/run
RUN chmod +x /etc/s6-overlay/s6-rc.d/legacy-services/run && \
    rm -f /etc/s6-overlay/s6-rc.d/legacy-services/type && \
    rm -f /etc/s6-overlay/s6-rc.d/legacy-services/contents.d/* && \
    # Recreate type as oneshot so it runs once and exits cleanly
    printf 'oneshot\n' > /etc/s6-overlay/s6-rc.d/legacy-services/type

CMD ["/opt/hermes/docker/entrypoint-dispatch.sh", "sleep", "infinity"]
