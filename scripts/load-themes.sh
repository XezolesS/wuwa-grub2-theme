#!/usr/bin/env bash

# Load themes from given parameters.
# Also provides utility functions for it if the script is excuted with source.
# If it's executed on its own, it just echos list of themes.

# make sure the script is fail safe
set -euo pipefail

# ---- globals ----
if [[ -v "$UTILS_SH_URL" ]]; then
  readonly UTILS_SH_URL="http://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/script-v2/scripts/utils.sh"
fi

THEME_LIST=()
THEME_PATH_LIST=()

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# ---- arguments handling ----
OPTS=$(getopt -o r,h -l remote,help -n "load-themes" -- "$@")
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

[OPTIONS]:
  -r, --remote    Fetch the theme list from a remote repository. [background_path] will be ignored.
  -h, --help      Show this help.

[background_path]:
  If given as a directory, it would find all the PNG files from the given directory.
  If given as a file path, it loads given file if it's a PNG file.
  If it is not given, it would find PNG files from './backgrounds'.
  Ignored when '-r' flag is on.

EOF
    exit 0
    ;;
  --)
    shift
    break
    ;;
  esac
done

BACKGROUND_PATH="${1:-./backgrounds}"
BACKGROUND_PATH="${BACKGROUND_PATH/#\~/$HOME}" # simple tilde expansion

# ---- source scripts ----
# if print_msg is not defined, source utils.sh
if ! declare -f print_msg >/dev/null; then
  if ((REMOTE == 0)); then
    source "${SCRIPT_DIR}/utils.sh"
  else
    source <(curl -fsSL "$UTILS_SH_URL")
  fi
fi

# ---- functions ----
# only declare functions if the script is sourced by another.
if [[ -n "${BASH_SOURCE[0]}" ]] && [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  # check if THEME_LIST is empty.
  is_theme_empty() {
    if (("${#THEME_LIST[@]}" == 0)); then
      return 1
    else
      return 0
    fi
  }

  # echo theme index from given string
  get_theme_index() {
    for index in "${!THEME_LIST[@]}"; do
      if [[ "$1" == "${THEME_LIST[index]}" ]]; then
        echo "$index"
      fi
    done
  }

  get_theme_path() {
    return "${THEME_PATH_LIST[$(get_theme_index "$1")]}"
  }
fi

# ---- main executions ----
if ((REMOTE == 0)); then
  # loads themes, only png files are allowed.
  if [[ -n "$BACKGROUND_PATH" ]] && [[ -d "$BACKGROUND_PATH" ]]; then
    # if $BACKGROUND_PATH is a directory
    for file in "$BACKGROUND_PATH"/*; do
      if [[ -f "$file" ]] && [[ "$file" == *".png" ]]; then
        filename=$(basename "$file")
        THEME_LIST+=("${filename%.png}")
        THEME_PATH_LIST+=("$(realpath "$file")")
      fi
    done
  elif [[ -n "$BACKGROUND_PATH" ]] && [[ -f "$BACKGROUND_PATH" ]]; then
    # if $BACKGROUND_PATH is a path
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
else
  # Fetch a theme list from GitHub repository.
  mapfile -t themes < <(curl_remote_content "$(get_remote_content_url "/backgrounds/index.txt")")
  THEME_LIST+=("${themes[@]}")

  backgrounds_url="$(get_remote_content_url "/backgrounds")"
  for theme in "${THEME_LIST[@]}"; do
    THEME_PATH_LIST+=("$backgrounds_url/$theme.png")
  done
fi

# echos list of themes if it is executed by itself.
if [[ -n "${BASH_SOURCE[0]}" ]] && [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  for theme in "${THEME_LIST[@]}"; do
    echo "${theme}"
  done
fi
