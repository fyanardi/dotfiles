#!/bin/sh

# ===============================================
# SSH Tunnel Script via Jump Server (lab)
# Usage: ./tunnel.sh <port>
# Example: ./tunnel.sh 8080
#
# NOTE:
# This script assumes you have SSH hosts configured
# in ~/.ssh/config, for example:
#
#   Host lab
#     HostName lab.tenteram.io
#     User fyanardi
#
#   Host internal
#     HostName internal
#     User fyanardi
#     ProxyJump lab
# ===============================================

if [ -z "$1" ]; then
  echo "Usage: $0 <port>"
  exit 1
fi

PORT="$1"

echo "Starting SSH tunnel to internal:${PORT} ..."
ssh -N -L "${PORT}:localhost:${PORT}" internal
