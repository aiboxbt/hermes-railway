FROM nousresearch/hermes-agent:v2026.8.3

# /opt/hermes is baked read-only by the upstream image (go-w), so copy the
# entrypoint script to a writable system location instead.
COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

CMD ["/usr/local/bin/railway-start.sh"]
