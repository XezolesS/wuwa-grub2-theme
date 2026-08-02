#!/usr/bin/env bash

# Load themes from given parameters.
# Also provides utility functions for it if the script is excuted with source.
# If it's executed on its own, it just echos list of themes.

# ---- source check ----
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# if print_msg is not defined, source utils.sh
if ! declare -f print_msg >/dev/null; then
  source "${SCRIPT_DIR}/utils.sh"
fi

# ---- globals ----
THEME_LIST=('none')
THEME_PATH_LIST=('none')

# ---- functions ----
# only declare functions if the script is sourced by another.
if [[ -n "${BASH_SOURCE[0]}" ]] && [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  # check if THEME_VARIANTS is empty.
  is_theme_empty() {
    if (("${#THEME_LIST[@]}" == 1)); then
      return 1
    else
      return 0
    fi
  }

  # echo theme index from given string
  get_theme_index() {
    local input=$1

    for index in "${!THEME_LIST[@]}"; do
      if [[ "$input" == "${THEME_LIST[index]}" ]]; then
        echo "$index"
        return 0
      fi
    done

    return 1
  }
fi

# ---- arguments handling ----
OPTS=$(getopt -o r -l remote -n "" -- "$@")
eval set -- "$OPTS"

REMOTE=0

while true; do
  case "$1" in
  -r | --remote)
    REMOTE=1
    shift
    ;;
  -h | --help)
    cat <<EOF

Usage: $0 [OPTION] [background_path]

OPTIONS:
  -r, --remote    Fetch the theme list from the GitHub repo. [background_path] will be ignored.
  -h, --help      Show this help

background_path:
  If given as a directory, it would find all the PNG files in the given directory.
  If given as a file path, it loads given file if it's a PNG file.
  If it is not given, it would find PNG files from './backgrounds'.

EOF
    shift
    ;;
  --)
    shift
    break
    ;;
  esac
done

BACKGROUND_PATH="${1:-./backgrounds}"

# ---- main executions ----
# loads themes, only png files are allowed.
if [[ -n "$BACKGROUND_PATH" ]] && [[ -d "$BACKGROUND_PATH" ]]; then
  for file in "$BACKGROUND_PATH"/*; do
    if [[ -f "$file" ]] && [[ "$file" == *".png" ]]; then
      filename=$(basename "$file")
      THEME_LIST+=("${filename%.png}")
      THEME_PATH_LIST+=("$(realpath "$file")")
    fi
  done
elif [[ -n "$BACKGROUND_PATH" ]] && [[ -f "$BACKGROUND_PATH" ]]; then
  if [[ "$BACKGROUND_PATH" != *".png" ]]; then
    error_msg "file type must be PNG."
    exit 1
  fi

  filename="$(basename "$BACKGROUND_PATH")"
  THEME_LIST+=("${filename%.png}")
  THEME_PATH_LIST+=("$BACKGROUND_PATH")
else
  error_msg "invalid directory or file."
  exit 1
fi

# echos list of themes if it is executed by itself.
if [[ -n "${BASH_SOURCE[0]}" ]] && [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  for ((i = 1; i < "${#THEME_LIST[@]}"; i++)); do
    echo "${THEME_LIST[$i]}"
  done
fi
