#! /usr/bin/env bash

# make sure the script is fail safej
set -euo pipefail

# project pathsj
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

THEME_DIR="${PROJECT_ROOT}/backgrounds"

# load utils functions
source "${SCRIPT_DIR}/utils.sh"

# test script to get a theme list
source "${SCRIPT_DIR}/load-themes.sh" "$THEME_DIR"

for theme in "${THEME_VARIANTS[@]}"; do
  print_msg "$theme"
done
