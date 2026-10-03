#!/bin/sh
set -e

# the Google Cloud CLI is installed in the Dockerfile, the feature layers are
# not cached

# The home directory is a persistent volume, the file is copied there by the
# postCreateCommand only if it does not exist yet
install -D -m 644 "$(dirname "$0")/settings.json" /usr/local/share/devcontainer-claude/settings.json

# helper script for logging into Google Cloud
install -D -m 755 "$(dirname "$0")/gcloud-login.sh" /usr/local/bin/gcloud-login.sh
