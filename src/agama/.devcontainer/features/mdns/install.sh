#!/bin/sh
set -e

zypper --non-interactive install --no-recommends nss-mdns
if [ "$REPO_CLEANUP" = "true" ]; then
  zypper clean -a
fi
