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

# arguments
BOOT=0
THEME=""

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

if [[ -f "$SCRIPT_DIR/load-themes.sh" ]]; then
  LOAD_THEMES_PARAMS+=("$BACKGROUND_PATH")
  LOAD_THEMES_SCRIPT_PATH="$SCRIPT_DIR/load-themes.sh"
  source "$LOAD_THEMES_SCRIPT_PATH" "${LOAD_THEMES_PARAMS[@]}"
else
  # temporarily download a script, because passing arguments is kinda tideous.
  mktempdir

  download_remote_content "$(get_remote_content_url "scripts/load-themes.sh")" "$TEMP_DIR/.load-themes.sh"
  LOAD_THEMES_PARAMS+=("-r")
  LOAD_THEMES_SCRIPT_PATH="$TEMP_DIR/.load-themes.sh"
  source "$LOAD_THEMES_SCRIPT_PATH" "${LOAD_THEMES_PARAMS[@]}"

  rmtempdir
fi

# ---- functions ----
itg_main() {
  while true; do
    local theme_combo_str
    theme_combo_str="$(printf "|%s" "${THEME_LIST[@]}")"
    theme_combo_str="${theme_combo_str:1}"

    # TODO: Resolution options
    set +e # to yoink zenity exit code
    local ans
    ans=$(
      zenity --title="GRUB Wuthering Waves Theme Setup" --width=320 --ok-label="Install" --cancel-label="Cancel" \
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
      IFS='|' read -ra opt <<<"$ans"

      THEME="${opt[1]}"

      if [[ "${opt[0]}" == "boot" ]]; then
        BOOT=1
      else
        BOOT=0
      fi

      return 0
      ;;
    1)
      if [[ "$ans" == "Load Default Themes" ]]; then
        source "$LOAD_THEMES_SCRIPT_PATH" "${LOAD_THEMES_PARAMS[@]}"

        continue
      elif [[ "$ans" == "Load Custom Themes" ]]; then
        set +e # not to exit when file selection canceled
        local themes_dir
        themes_dir=$(zenity --title="Select a directory of themes" --file-selection --directory)
        set -e

        source "$LOAD_THEMES_SCRIPT_PATH" "$themes_dir"

        continue
      else
        return 1
      fi
      ;;
    esac
  done
}

itg_confirm() {
  local confirm_text="<big>You're installing:</big>\n\n"
  confirm_text+="<b><span foreground=\"orange\">$THEME</span></b> theme, "
  confirm_text+="under "

  if ((BOOT == 1)); then
    confirm_text+="<b><span foreground=\"cyan\">boot</span></b> directory<i> (/boot/grub/themes)</i>"
  else
    confirm_text+="<b><span foreground=\"cyan\">system</span></b> directory<i> (/usr/share/grub/themes)</i>"
  fi

  set +e # to yoink zenity exit code
  zenity --title="Confirm your installation" --width=320 --ok-label="Yes" --cancel-label="No" \
    --question --text="$confirm_text"
  local ecode=$?
  set -e

  case $ecode in
  0)
    return 0
    ;;
  1)
    return 1
    ;;
  esac
}

# ---- main executions ----
mktempdir

# write sudo gui prompt
echo "#! /usr/bin/env bash
exec zenity --title=\"[sudo]\" --width=320 \
--password --text=\"password for $USER:\"" \
  >"$TEMP_DIR/sudo_prompt.sh"
chmod +x "$TEMP_DIR/sudo_prompt.sh"

while itg_main; do
  if itg_confirm; then
    SUDO_ASKPASS="$TEMP_DIR/sudo_prompt.sh" sudo -A true

    break
  fi
done

rmtempdir
