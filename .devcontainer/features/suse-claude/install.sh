#!/bin/bash
set -e

# The AI agents usually run Bash or Python code snippets. Install the packages
# only when they are missing to avoid a slow repository refresh.
if ! rpm -q python3 python3-pip > /dev/null 2>&1; then
  zypper --non-interactive --gpg-auto-import-keys install --no-recommends python3 python3-pip
fi

. /etc/os-release

# temporarily disable the OSS repo to have faster refresh
if [ "$ID" = "opensuse-tumbleweed" ]; then
  REPOS=(repo-oss repo-update)
else
  REPOS=(openSUSE:repo-oss)
fi
zypper modifyrepo --disable "${REPOS[@]}"

# install Google Cloud CLI, needed for logging into the VertexAI service
zypper ar -f "https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-$(uname -m)" google-cloud-rhel10
zypper --non-interactive --gpg-auto-import-keys install --no-recommends google-cloud-cli
if [ "$REPO_CLEANUP" = "true" ]; then
  zypper clean -a
fi
zypper modifyrepo --enable "${REPOS[@]}"
# disable the repo, very likely it won't be needed later
zypper modifyrepo --disable google-cloud-rhel10

# The home directory is a persistent volume, the file is copied there by the
# postCreateCommand only if it does not exist yet
install -D -m 644 "$(dirname "$0")/settings.json" /usr/local/share/devcontainer-claude/settings.json

# helper script for logging into Google Cloud
install -D -m 755 "$(dirname "$0")/gcloud-login.sh" /usr/local/bin/gcloud-login.sh
