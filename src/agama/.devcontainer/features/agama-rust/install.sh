#!/bin/sh
set -e

zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
  gettext-tools \
  cargo \
  cargo-audit \
  clang-devel \
  gcc \
  gcc-c++ \
  jsonnet \
  libpwquality-tools \
  libsuseconnect \
  libzypp-devel \
  lshw \
  NetworkManager \
  openssl-devel \
  pam-devel \
  python-langtable-data \
  rust \
  rust-bindgen \
  timezone \
  xkeyboard-config-lang
if [ "$REPO_CLEANUP" = "true" ]; then
  zypper clean -a
fi
