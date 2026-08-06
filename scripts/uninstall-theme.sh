#! /usr/bin/env bash

# make sure the script is fail safe
set -euo errexit

# ---- globals ----
readonly ROOT_UID=0
readonly THEME_NAME="wuwa"

readonly UTILS_SH_URL="http://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/utils.sh"

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# ---- arguments handling ----
OPTS=$(getopt \
  -o v,h \
  -l verbose,help \
  -n "uninstall-theme" -- "$@")
eval set -- "$OPTS"

VERBOSE=0

while true; do
  case "$1" in
  -v | --verbose)
    VERBOSE=1
    shift
    ;;
  -h | --help)
    cat <<EOF
Usage: $0 [OPTION] [THEMES ...]

THEMES:
  Themes to uninstall.
  If it's empty, uninstall all themes that are intalled by this project.

  [OPTIONS]:
  -v, --verbose       Verbose messages.
  -h, --help          Show this help.
EOF
    exit 0
    ;;
  --)
    shift
    break
    ;;
  esac
done

# positional arguments
# THEMES
THEMES=()
if (("$#" > 0)); then
  read -ra THEMES <<<"$@"
fi

# ---- source scripts ----
# utils.sh
# I don't want a --remote options for this scripts,
# so workaround by checking existence of utils.sh and
# curl it when it cannot be found.
if [[ -f "${SCRIPT_DIR}/utils.sh" ]]; then
  source "${SCRIPT_DIR}/utils.sh"
else
  source <(curl -fsSL "$UTILS_SH_URL")
fi

# ---- functions ----
get_current_theme() {
  # check what theme is activated
  local grub_config_location

  if [[ -f "/etc/default/grub" ]]; then
    grub_config_location="/etc/default/grub"
  elif [[ -f "/etc/default/grub.d/kali-themes.cfg" ]]; then
    grub_config_location="/etc/default/grub.d/kali-themes.cfg"
  else
    exit 1
  fi

  local current_theme
  current_theme="$(grep 'GRUB_THEME=' $grub_config_location | grep -v \#)"
  current_theme="${current_theme#"GRUB_THEME=\""}" # remove GRUB_THEME=" at the start
  current_theme="${current_theme%"\""}"            # remove " at the end
  current_theme="$(dirname "$current_theme")"      # parent of theme.txt
  current_theme="$(basename "$current_theme")"     # get theme name
  current_theme="${current_theme#"$THEME_NAME-"}"  # remove a prefix

  echo "$current_theme"
}

deactivate_theme() {
  local grub_config_location

  if [[ -f "/etc/default/grub" ]]; then
    grub_config_location="/etc/default/grub"
  elif [[ -f "/etc/default/grub.d/kali-themes.cfg" ]]; then
    grub_config_location="/etc/default/grub.d/kali-themes.cfg"
  else
    exit 1
  fi

  local grub_theme_line
  grub_theme_line="$(grep 'GRUB_THEME=' $grub_config_location | grep -v \#)"

  # Backup with --in-place option to grub.bak within the same directory; then remove the current theme.
  sed --in-place='.bak' -e "s|$grub_theme_line|#GRUB_THEME=|" "$grub_config_location"

  if [[ -f "$grub_config_location".bak ]]; then
    rm -rf "$grub_config_location".bak
  fi

  # Update grub config
  info_msg "Resetting grub theme..."
  grub_update
}

prompt_uninstall_theme() {
  local theme="$1"
  local theme_dir="$2"
  local current_theme="$3"

  while true; do
    read -r -p "Uninstall theme '$theme'? [Y|n]" yn_prompt

    if [[ "${yn_prompt,,}" == "y"* ]]; then
      # Yes, remove a theme
      if [[ "$current_theme" == "$theme" ]]; then
        info_msg "Uninstalling currently activated theme. Try to deactivate it..."
        deactivate_theme
      fi

      rm -rf "$theme_dir"
      success_msg "$theme is uninstall successfully."
      break
    elif [[ "${yn_prompt,,}" == "n"* ]]; then
      # No, skip it
      info_msg "User skipped to uninstall '$theme'"
      break
    fi
  done
}

grub_uninstall_theme() {
  # requires root permission
  if [[ "$UID" -ne "$ROOT_UID" ]]; then
    error_msg "Requires root permission to install! Try again with sudo."
    exit 1
  fi

  # get intalled themes
  local prefix="$THEME_NAME-"
  mapfile -t lsth < <(grub_ls_themes "$prefix")

  local installed_themes=()
  local installed_theme_dirs=()
  for th in "${lsth[@]}"; do
    if [[ -n "$th" ]]; then
      local theme_name
      theme_name="$(basename "$th")"
      theme_name="${theme_name#"$prefix"}"

      installed_themes+=("$theme_name")
      installed_theme_dirs+=("$th")
    fi
  done

  info_msg "Found ${#installed_themes[@]} themes installed."
  if ((VERBOSE == 1)); then
    for index in "${!installed_themes[@]}"; do
      verbose_info_msg "Found ${installed_themes[$index]} at ${installed_theme_dirs[$index]}"
    done
  fi

  # get currently activated theme
  local current_theme
  current_theme=$(get_current_theme)
  verbose_info_msg "Currently activated theme is: $current_theme"

  # remove installed themes
  if ((${#THEMES[@]} == 0)); then
    for index in "${!installed_themes[@]}"; do
      prompt_uninstall_theme \
        "${installed_themes[$index]}" \
        "${installed_theme_dirs[$index]}" \
        "${current_theme}"
    done
  else
    local theme_index
    for th in "${THEMES[@]}"; do
      theme_index=-1
      for index in "${!installed_themes[@]}"; do
        if [[ "$th" == "${installed_themes[$index]}" ]]; then
          theme_index=$index
          verbose_info_msg "Index of a theme '$th' is $theme_index"
        fi
      done

      if ((theme_index > 0)); then
        prompt_uninstall_theme \
          "${installed_themes[$theme_index]}" \
          "${installed_theme_dirs[$theme_index]}" \
          "${current_theme}"
      else
        warning_msg "Cannot find theme '$th'. Skipped."
      fi
    done
  fi
}

# ---- main executions ----
grub_uninstall_theme
