FROM nousresearch/hermes-agent:v2026.8.3

# Place the start script at the location the image's s6 legacy-services
# slot expects. /opt/hermes is read-only, so write to a side directory and
# bind-mount the script there at container start via a small init wrapper.
COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

# Init wrapper: materialize the script at the expected path before s6 starts.
COPY init.sh /usr/local/bin/00-prepare.sh
RUN chmod +x /usr/local/bin/00-prepare.sh

CMD ["/usr/local/bin/00-prepare.sh"]
