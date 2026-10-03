#!/bin/bash
# Build a template with the specified options, start the dev container and run
# the template tests inside it.
#
# Usage: test/smoke-test.sh <template-id> [option=value ...]
#
# Options which are not specified use the default value from the
# devcontainer-template.json file. The container engine can be changed via the
# CONTAINER_ENGINE environment variable (default: podman). Requires the
# devcontainer CLI (npm install -g @devcontainers/cli) and jq.

set -euo pipefail

TEMPLATE_ID="${1:?Missing template ID}"
shift
CONTAINER_ENGINE="${CONTAINER_ENGINE:-podman}"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$(mktemp -d "${TMPDIR:-/tmp}/${TEMPLATE_ID}.XXXXXX")"
ID_LABEL="test-container=${TEMPLATE_ID}-$$"

cleanup() {
  local id volume
  for id in $("$CONTAINER_ENGINE" container ls -a -q -f "label=${ID_LABEL}"); do
    volume=$("$CONTAINER_ENGINE" container inspect -f \
      '{{range .Mounts}}{{if eq .Destination "/home/vscode"}}{{.Name}}{{end}}{{end}}' "$id")
    "$CONTAINER_ENGINE" rm -f -v "$id" >/dev/null
    # remove the persistent home volume
    [ -z "$volume" ] || "$CONTAINER_ENGINE" volume rm -f "$volume" >/dev/null
  done
  rm -rf "$SRC_DIR"
}
trap cleanup EXIT

cp -R "${REPO_DIR}/src/${TEMPLATE_ID}/." "$SRC_DIR"
TEMPLATE_JSON="${SRC_DIR}/devcontainer-template.json"

# collect the option values, start with the defaults and apply the overrides
declare -A OPTIONS=()
while IFS=$'\t' read -r key value; do
  OPTIONS[$key]="$value"
done < <(jq -r '.options // {} | to_entries[] | [.key, (.value.default | tostring)] | @tsv' "$TEMPLATE_JSON")

for arg in "$@"; do
  key="${arg%%=*}"
  if [ -z "${OPTIONS[$key]+set}" ]; then
    echo "Unknown option '$key' for template '$TEMPLATE_ID'" >&2
    exit 1
  fi
  OPTIONS[$key]="${arg#*=}"
done

# apply the template options the same way as "devcontainer templates apply"
REMOTE_ENV=()
for key in "${!OPTIONS[@]}"; do
  value="${OPTIONS[$key]}"
  echo "(*) Option ${key}=${value}"
  escaped=$(sed -e 's/[]\/$*.^[&]/\\&/g' <<<"$value")
  find "$SRC_DIR" -type f -print0 | xargs -0 sed -i "s/\${templateOption:${key}}/${escaped}/g"
  REMOTE_ENV+=(--remote-env "templateOption_${key}=${value}")
done

# shellcheck disable=SC2016
if grep -r -q -F '${templateOption:' "$SRC_DIR"; then
  echo "Unresolved template options:" >&2
  grep -r -n -F '${templateOption:' "$SRC_DIR" >&2
  exit 1
fi

# copy the tests to the workspace
TEST_DIR="${SRC_DIR}/test-project"
mkdir -p "$TEST_DIR"
cp -R "${REPO_DIR}/test/${TEMPLATE_ID}/." "$TEST_DIR"
cp "${REPO_DIR}/test/test-utils/test-utils.sh" "$TEST_DIR"

echo "(*) Building the dev container"
devcontainer up --docker-path "$CONTAINER_ENGINE" --id-label "$ID_LABEL" \
  --workspace-folder "$SRC_DIR"

# save the merged configuration (including the features) for the tests
devcontainer read-configuration --docker-path "$CONTAINER_ENGINE" --id-label "$ID_LABEL" \
  --workspace-folder "$SRC_DIR" --include-merged-configuration \
  >"${TEST_DIR}/merged-configuration.json"

echo "(*) Running the tests"
devcontainer exec --docker-path "$CONTAINER_ENGINE" --id-label "$ID_LABEL" \
  --workspace-folder "$SRC_DIR" "${REMOTE_ENV[@]}" \
  bash "/workspaces/$(basename "$SRC_DIR")/test-project/test.sh"
