#!/bin/sh
set -e

# The AI agents usually run Bash or Python code snippets. Install the packages
# only when they are missing to avoid a slow repository refresh.
if ! rpm -q python3 python3-pip > /dev/null 2>&1; then
  zypper --non-interactive --gpg-auto-import-keys install --no-recommends python3 python3-pip
  if [ "$REPO_CLEANUP" = "true" ]; then
    zypper clean -a
  fi
fi

# The home directory is a persistent volume, the file is copied there by the
# postCreateCommand only if it does not exist yet
install -D -m 644 "$(dirname "$0")/trustedFolders.json" /usr/local/share/devcontainer-gemini/trustedFolders.json
