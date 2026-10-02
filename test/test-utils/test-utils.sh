#!/bin/bash
# Helper functions for the tests running inside the dev container

FAILED=()

echoStderr() {
  echo "$@" 1>&2
}

# check <label> <command> [args...]
check() {
  LABEL=$1
  shift
  echo -e "\n🧪 Testing $LABEL"
  if "$@"; then
    echo "✅  Passed!"
    return 0
  else
    echoStderr "❌ $LABEL check failed."
    FAILED+=("$LABEL")
    return 1
  fi
}

reportResults() {
  if [ ${#FAILED[@]} -ne 0 ]; then
    echoStderr -e "\n💥  Failed tests: ${FAILED[*]}"
    exit 1
  else
    echo -e "\n💯  All passed!"
    exit 0
  fi
}

# shellcheck disable=SC2317 # called indirectly via check
fails() {
  ! "$@"
}

# checkOption <option value> <label> <command> [args...]
# expects success if the option is enabled, failure otherwise
checkOption() {
  local enabled=$1 label=$2
  shift 2
  if [ "$enabled" = "true" ]; then
    check "$label" "$@"
  else
    check "no $label" fails "$@"
  fi
}

# the VS Code extensions from the merged configuration (including features),
# the file is created by the smoke-test.sh script
EXTENSIONS=$(jq -r '.mergedConfiguration.customizations.vscode[]?.extensions[]?' merged-configuration.json)

# shellcheck disable=SC2317 # called indirectly via check
hasExtension() {
  grep -q -x -F "$1" <<<"$EXTENSIONS"
}

# check the base system, the user and the common tools
checkBaseSystem() {
  local expected_id expected_version
  case "${templateOption_imageVariant:-}" in
    leap:*) expected_id="opensuse-leap" expected_version="${templateOption_imageVariant#leap:}" ;;
    tumbleweed) expected_id="opensuse-tumbleweed" expected_version="" ;;
    *) expected_id="unknown" expected_version="" ;;
  esac

  # shellcheck source=/dev/null
  . /etc/os-release
  echo "Running in $PRETTY_NAME"
  check "base system" test "$ID" = "$expected_id"
  if [ -n "$expected_version" ]; then
    check "base system version" test "$VERSION_ID" = "$expected_version"
  fi
  check "non-root user" test "$(id -un)" = "vscode"
  check "passwordless sudo" sudo -n true
  check "writable home" touch "$HOME/.devcontainer-test"
  for cmd in git curl jq yq rg shellcheck shfmt make python3 pip3; do
    check "$cmd" command -v "$cmd"
  done
}

# check the optional AI code assistants
checkAIAssistants() {
  local gemini="${templateOption_googleGemini:-}"
  checkOption "$gemini" "Gemini extension" hasExtension google.geminicodeassist
  checkOption "$gemini" "Gemini trusted folders" test -f "$HOME/.gemini/trustedFolders.json"
  checkOption "$gemini" "Gemini allowed root" test "${CODER_AGENT_ALLOWED_ROOT:-}" = /workspaces

  local claude="${templateOption_anthropicClaude:-}"
  checkOption "$claude" "Claude extension" hasExtension Anthropic.claude-code
  checkOption "$claude" "Claude settings" test -f "$HOME/.claude/settings.json"
  checkOption "$claude" "gcloud-login.sh" command -v gcloud-login.sh
  checkOption "$claude" "Claude login prompt disabled" jq -e \
    'any(.mergedConfiguration.customizations.vscode[]?; .settings["claudeCode.disableLoginPrompt"] == true)' \
    merged-configuration.json
  checkOption "$claude" "gcloud" command -v gcloud
}
