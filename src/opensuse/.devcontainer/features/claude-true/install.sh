#!/bin/sh
set -e

# disable the standard repositories to have faster refresh
zypper modifyrepo --all --disable

# Google Cloud CLI repository (provides x86_64 and aarch64 packages)
zypper ar -f "https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-$(uname -m)" google-cloud-rhel10
zypper --non-interactive --gpg-auto-import-keys install --no-recommends google-cloud-cli
zypper clean -a

# enable back
zypper modifyrepo --all --enable

# The home directory is a persistent volume, the file is copied there by the
# postCreateCommand only if it does not exist yet
install -D -m 644 "$(dirname "$0")/settings.json" /usr/local/share/devcontainer-claude/settings.json

# helper script for logging into Google Cloud
install -D -m 755 "$(dirname "$0")/gcloud-login.sh" /usr/local/bin/gcloud-login.sh
