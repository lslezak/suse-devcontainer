#!/bin/sh
set -e

zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
  gettext-tools \
  nodejs \
  npm
if [ "$REPO_CLEANUP" = "true" ]; then
  zypper clean -a
fi
