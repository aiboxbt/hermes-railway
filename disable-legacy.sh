#!/bin/bash
# No-op replacement for the s6 `legacy-services` slot. The original run
# script tried to exec /opt/hermes/railway-start.sh — which is in the
# read-only image layer and never exists — bringing the whole s6 tree
# down. Replacing it with a script that just exits 0 lets the supervisor
# mark the slot succeeded and keep main-hermes + dashboard running.
exit 0