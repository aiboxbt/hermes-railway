FROM nousresearch/hermes-agent:v2026.8.3

# The published image has an s6 `legacy-services` slot that tries to
# exec /opt/hermes/railway-start.sh (a path baked into the read-only
# image layer that never exists). When that service fails, s6 brings
# the entire tree down — including main-hermes and dashboard.
#
# Strategy: register our own cont-init script that runs BEFORE
# 01-hermes-setup, and deletes the legacy-services slot directory
# before s6-rc scans it. The slot never enters the compiled state,
# so s6-rc has nothing to fail on.

# Use a prefix the s6-overlay legacy-cont-init service recognizes and
# that sorts before 01-. s6-overlay's legacy-cont-init scans for
# `0?-*` patterns; we use `01b-` to slip in between 01-hermes-setup
# and 015-supervise-perms — but we want to run FIRST, so we rely on
# the alphabetical sort: `00a-` < `01-`.
COPY disable-legacy.sh /etc/cont-init.d/00a-remove-legacy-slot.sh
RUN chmod +x /etc/cont-init.d/00a-remove-legacy-slot.sh

CMD ["/opt/hermes/docker/entrypoint-dispatch.sh", "sleep", "infinity"]