#!/bin/bash
# Tests running inside the "agama" dev container, the template options are
# passed in the "templateOption_<name>" environment variables.

cd "$(dirname "$0")" || exit 1
# shellcheck source=test/test-utils/test-utils.sh
source test-utils.sh

checkBaseSystem
checkAIAssistants

VARIANT="${templateOption_agamaVariant:-}"
echo -e "\nAgama variant: $VARIANT"

# the expected components for each variant
case "$VARIANT" in
  all-in-one) COMPONENTS="gettext web rust ruby kiwi" ;;
  base) COMPONENTS="gettext" ;;
  kiwi) COMPONENTS="kiwi" ;;
  ruby) COMPONENTS="gettext ruby" ;;
  rust) COMPONENTS="gettext rust" ;;
  web) COMPONENTS="gettext web" ;;
  *) COMPONENTS="" ;;
esac
check "known variant" test -n "$COMPONENTS"

# shellcheck disable=SC2317 # called indirectly via check
hasComponent() {
  [[ " $COMPONENTS " == *" $1 "* ]] && echo true || echo false
}

checkOption "$(hasComponent gettext)" "msgfmt" command -v msgfmt

MDNS="${templateOption_mdns:-}"
checkOption "$MDNS" "nss-mdns" rpm -q nss-mdns
checkOption "$MDNS" "Avahi mount" grep -q " /run/avahi-daemon " /proc/self/mounts

WEB=$(hasComponent web)
for cmd in node npm; do
  checkOption "$WEB" "$cmd" command -v "$cmd"
done
checkOption "$WEB" "ESLint extension" hasExtension dbaeumer.vscode-eslint

RUST=$(hasComponent rust)
for cmd in cargo rustc cargo-audit jsonnet; do
  checkOption "$RUST" "$cmd" command -v "$cmd"
done
checkOption "$RUST" "rust-analyzer extension" hasExtension rust-lang.rust-analyzer

RUBY=$(hasComponent ruby)
checkOption "$RUBY" "ruby-lsp" command -v ruby-lsp
checkOption "$RUBY" "Ruby LSP extension" hasExtension Shopify.ruby-lsp

KIWI=$(hasComponent kiwi)
for cmd in kiwi-ng bats; do
  checkOption "$KIWI" "$cmd" command -v "$cmd"
done
checkOption "$KIWI" "Kiwi schema" test -f /usr/local/share/kiwi/kiwi.rnc
checkOption "$KIWI" "XML extension" hasExtension redhat.vscode-xml

reportResults
