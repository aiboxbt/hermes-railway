FROM nousresearch/hermes-agent:v2026.8.3

# The published image on Docker Hub has a stray s6 `legacy-services`
# slot whose run script exec's /opt/hermes/railway-start.sh — a path
# that lives in the read-only image layer and never exists. When that
# slot fails, s6 cascades and brings main-hermes + dashboard down too.
#
# Rather than chase the slot through s6-rc internals, we bypass s6
# entirely: we exec the gateway directly as PID 1 and let `sleep
# infinity` keep the container alive. This trades away s6's
# auto-restart supervision, but matches what the original Railway
# template intended: a single foreground process the platform can
# monitor. The dashboard HTTP service is NOT started by this entrypoint
# because the gateway's messaging stack is the primary concern;
# operators who need the WebUI should run it as a separate Railway
# service on a sibling container, or build a custom image that
# addresses the upstream slot properly.

COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

CMD ["/usr/local/bin/railway-start.sh"]