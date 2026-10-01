#!/bin/bash
# Tests running inside the "opensuse" dev container, the template options are
# passed in the "templateOption_<name>" environment variables.

cd "$(dirname "$0")" || exit 1
# shellcheck source=test/test-utils/test-utils.sh
source test-utils.sh

# shellcheck source=/dev/null
. /etc/os-release

case "${templateOption_imageVariant:-}" in
  leap:*) EXPECTED_ID="opensuse-leap" EXPECTED_VERSION="${templateOption_imageVariant#leap:}" ;;
  tumbleweed) EXPECTED_ID="opensuse-tumbleweed" EXPECTED_VERSION="" ;;
  *) EXPECTED_ID="" EXPECTED_VERSION="" ;;
esac

echo "Running in $PRETTY_NAME"
check "base system" [ -n "$EXPECTED_ID" ] && [ "$ID" = "$EXPECTED_ID" ]
if [ -n "$EXPECTED_VERSION" ]; then
  check "base system version" [ "$VERSION_ID" = "$EXPECTED_VERSION" ]
fi
check "non-root user" [ "$(id -un)" = "vscode" ]
check "passwordless sudo" sudo -n true
check "writable home" touch "$HOME/.devcontainer-test"
for cmd in git curl jq yq rg shellcheck shfmt make python3 pip3 gcloud; do
  check "$cmd" command -v "$cmd"
done

reportResults
