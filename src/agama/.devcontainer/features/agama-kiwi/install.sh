#!/bin/sh
set -e

zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
  bats \
  python3-kiwi
if [ "$REPO_CLEANUP" = "true" ]; then
  zypper clean -a
fi

# create a stable path for the Kiwi schema, the real location contains the
# Python version which differs between Leap and Tumbleweed
SCHEMA=$(python3 -c 'import os, kiwi; print(os.path.join(os.path.dirname(kiwi.__file__), "schema", "kiwi.rnc"))')
mkdir -p /usr/local/share/kiwi
ln -sf "$SCHEMA" /usr/local/share/kiwi/kiwi.rnc
