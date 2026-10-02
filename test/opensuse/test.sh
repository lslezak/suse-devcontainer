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
for cmd in git curl jq yq rg shellcheck shfmt make python3 pip3; do
  check "$cmd" command -v "$cmd"
done

# the VS Code extensions from the merged configuration (including features)
EXTENSIONS=$(jq -r '.mergedConfiguration.customizations.vscode[]?.extensions[]?' merged-configuration.json)
# shellcheck disable=SC2317 # called indirectly via check
hasExtension() {
  grep -q -x -F "$1" <<<"$EXTENSIONS"
}
# shellcheck disable=SC2317 # called indirectly via check
fails() {
  ! "$@"
}
# check_option <option value> <label> <command> [args...]
# expects success if the option is enabled, failure otherwise
check_option() {
  local enabled=$1 label=$2
  shift 2
  if [ "$enabled" = "true" ]; then
    check "$label" "$@"
  else
    check "no $label" fails "$@"
  fi
}

GEMINI="${templateOption_googleGemini:-}"
check_option "$GEMINI" "Gemini extension" hasExtension google.geminicodeassist
check_option "$GEMINI" "Gemini trusted folders" test -f "$HOME/.gemini/trustedFolders.json"
check_option "$GEMINI" "Gemini allowed root" test "${CODER_AGENT_ALLOWED_ROOT:-}" = /workspaces

CLAUDE="${templateOption_anthropicClaude:-}"
check_option "$CLAUDE" "Claude extension" hasExtension Anthropic.claude-code
check_option "$CLAUDE" "Claude settings" test -f "$HOME/.claude/settings.json"
check_option "$CLAUDE" "gcloud-login.sh" command -v gcloud-login.sh
check_option "$CLAUDE" "Claude login prompt disabled" jq -e \
  'any(.mergedConfiguration.customizations.vscode[]?; .settings["claudeCode.disableLoginPrompt"] == true)' \
  merged-configuration.json
check_option "$CLAUDE" "gcloud" command -v gcloud

reportResults
