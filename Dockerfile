FROM nousresearch/hermes-agent:v2026.8.3

# The published image on Docker Hub has an s6 `legacy-services` slot
# that exec's /opt/hermes/railway-start.sh. That path lives in the
# read-only image layer, so the file never exists and the slot's
# failure cascades through s6, killing main-hermes + dashboard.
#
# Layered "fix": the source layer is read-only, but our COPY below
# adds a new layer ON TOP of it that creates /opt/hermes/railway-start.sh
# in the writable container layer (Docker unionfs). The slot then finds
# the file and succeeds.
#
# Note: /opt/hermes is `go-w` for non-root but COPY runs as root and
# creates the file owned by root. The hermes user can then read+execute
# it (the path retains `a+rX` from the source chmod).

COPY start.sh /opt/hermes/railway-start.sh
RUN chmod +x /opt/hermes/railway-start.sh

CMD ["/opt/hermes/railway-start.sh"]