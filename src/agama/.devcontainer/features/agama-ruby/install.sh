#!/bin/sh
set -e

zypper --non-interactive --gpg-auto-import-keys install --no-recommends --allow-downgrade \
  gettext-tools \
  augeas-devel \
  ruby-devel
if [ "$REPO_CLEANUP" = "true" ]; then
  zypper clean -a
fi

# Ruby language server
gem install --no-format-exec ruby-lsp
