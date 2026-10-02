#!/bin/bash
# Tests running inside the "opensuse" dev container, the template options are
# passed in the "templateOption_<name>" environment variables.

cd "$(dirname "$0")" || exit 1
# shellcheck source=test/test-utils/test-utils.sh
source test-utils.sh

checkBaseSystem
checkAIAssistants

reportResults
