#!/bin/bash
# Tests running inside the "agama" dev container, the template options are
# passed in the "templateOption_<name>" environment variables.

cd "$(dirname "$0")" || exit 1
# shellcheck source=test/test-utils/test-utils.sh
source test-utils.sh

checkBaseSystem
# the AI assistant features are always installed
checkAIAssistants true true

# all components are always installed
check "msgfmt" command -v msgfmt

# the mDNS feature is always installed
check "nss-mdns" rpm -q nss-mdns
check "Avahi mount" grep -q " /run/avahi-daemon " /proc/self/mounts

for cmd in node npm; do
  check "$cmd" command -v "$cmd"
done
check "ESLint extension" hasExtension dbaeumer.vscode-eslint

for cmd in cargo rustc cargo-audit jsonnet; do
  check "$cmd" command -v "$cmd"
done
check "rust-analyzer extension" hasExtension rust-lang.rust-analyzer

check "ruby-lsp" command -v ruby-lsp
check "Ruby LSP extension" hasExtension Shopify.ruby-lsp

for cmd in kiwi-ng bats; do
  check "$cmd" command -v "$cmd"
done
check "Kiwi schema" test -f /usr/local/share/kiwi/kiwi.rnc
check "XML extension" hasExtension redhat.vscode-xml

reportResults
