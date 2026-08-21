#! /usr/bin/env bash

# make sure the script is fail safe
set -euo pipefail

# ---- globals ----
readonly ROOT_UID=0
readonly THEME_NAME="wuwa"

readonly UTILS_SH_URL="http://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/utils.sh"

readonly RESOLUTION_OPTIONS=("fhd" "qhd" "uhd")

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BACKGROUND_PATH="$PROJECT_ROOT/backgrounds"

TEMP_DL_DIR=".wuwa-grub2-theme-dl"

# ---- source scripts ----
# utils.sh
if [[ -f "$SCRIPT_DIR/utils.sh" ]]; then
  source "$SCRIPT_DIR/utils.sh"
else
  source <(curl -fsSL "$UTILS_SH_URL")
fi

# load-themes.sh
LOAD_THEMES_PARAMS=()
LOAD_THEMES_SCRIPT_PATH=""

if [[ -n "$BACKGROUND_PATH" ]]; then
  LOAD_THEMES_PARAMS+=("$BACKGROUND_PATH")
else
  LOAD_THEMES_PARAMS+=("-r")
fi

if [[ -f "$SCRIPT_DIR/load-themes.sh" ]]; then
  LOAD_THEMES_SCRIPT_PATH="$SCRIPT_DIR/load-themes.sh"
  source "$LOAD_THEMES_SCRIPT_PATH" "${LOAD_THEMES_PARAMS[@]}"
else
  # temporarily download a script, because passing arguments is kinda tideous.
  download_remote_content "$(get_remote_content_url "scripts/load-themes.sh")" "$TEMP_DL_DIR/.load-themes.sh"
  LOAD_THEMES_SCRIPT_PATH="$TEMP_DL_DIR/.load-themes.sh"
  source "$LOAD_THEMES_SCRIPT_PATH" "${LOAD_THEMES_PARAMS[@]}"
  rm "$LOAD_THEMES_SCRIPT_PATH"
fi

# ---- functions ----
itg_main() {
  local theme_combo_str
  theme_combo_str="$(printf "|%s" "${THEME_LIST[@]}")"
  theme_combo_str="${theme_combo_str:1}"

  set +e
  local ans
  ans=$(
    zenity --title="GRUB Wuthering Waves Theme Setup" --modal --ok-label="Install" --cancel-label="Cancel" \
      --forms --text="Installation details" \
      --add-combo="Install at:" --combo-values="system|boot" \
      --add-combo="Selected theme:" --combo-values="$theme_combo_str" \
      --extra-button="Load Custom Themes" \
      --extra-button="Load Default Themes"
  )
  local ecode=$?
  set -e

  case $ecode in
  0)
    ;;
  1)
    if [[ "$ans" == "Load Default Themes" ]]; then
      source "$LOAD_THEMES_SCRIPT_PATH" "${LOAD_THEMES_PARAMS[@]}"
      itg_main
    elif [[ "$ans" == "Load Custom Themes" ]]; then
      itg_load_custom_themes
      itg_main
    else
      exit 1
    fi
    ;;
  esac
}

itg_load_custom_themes() {
  local ans
  ans=$(zenity --title="Select a directory of themes" --file-selection --directory)

  source "$LOAD_THEMES_SCRIPT_PATH" "$ans"
}

# ---- main executions ----
itg_main
