FROM nousresearch/hermes-agent:v2026.8.3

COPY start.sh /opt/hermes/railway-start.sh
RUN chmod +x /opt/hermes/railway-start.sh

CMD ["/opt/hermes/railway-start.sh"]
