#! /usr/bin/env bash

# ---- project paths ----
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

THEME_DIR="${PROJECT_ROOT}/backgrounds"

# ---- main executions ----
"${SCRIPT_DIR}/load-themes.sh" >"${THEME_DIR}/themelist.txt"
