#!/bin/sh
set -e

# The home directory is a persistent volume, the file is copied there by the
# postCreateCommand only if it does not exist yet
install -D -m 644 "$(dirname "$0")/trustedFolders.json" /usr/local/share/devcontainer-gemini/trustedFolders.json
