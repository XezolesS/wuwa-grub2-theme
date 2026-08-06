#! /usr/bin/env bash

# make sure the script is fail safe
set -euo errexit

# ---- globals ----
readonly ROOT_UID=0
readonly THEME_NAME="wuwa"

readonly UTILS_SH_URL="http://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/script-v2/scripts/utils.sh"

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
    error_msg "Cannot find grub config file in default locations!"
    warning_msg "Please inform the developers by opening an issue on github."
    info_msg "Exiting..."
    exit 1
  fi
  verbose_info_msg "Found grub config at: $grub_config_location"

  local current_theme
  current_theme="$(grep 'GRUB_THEME=' $grub_config_location | grep -v \#)"
  verbose_info_msg "Current theme is: $current_theme"

  echo "$current_theme"
}

deactivate_theme() {
  local current_theme="$1"

  # Backup with --in-place option to grub.bak within the same directory; then remove the current theme.
  sed --in-place='.bak' "s|$current_theme|#GRUB_THEME=|" "$grub_config_location"

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

  while true; do
    info_msg "Uninstall theme '$theme'? [Y|n]"
    read -r yn_prompt

    if [[ "${yn_prompt,,}" == "y" ]]; then
      # Yes, remove a theme
      if [[ "$current_theme" == "$theme" ]]; then
        info_msg "Uninstalling currently activated theme. Try to deactivate it..."
        deactivate_theme "$current_theme"
      fi

      rm -rf "$theme_dir"
      success_msg "$theme is uninstall successfully."
      break
    elif [[ "${yn_prompt,,}" == "n" ]]; then
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
  mapfile -t lsth < <(grub_ls_themes "$THEME_NAME")

  local installed_themes=()
  local installed_theme_dirs=()
  for th in "${lsth[@]}"; do
    if [[ -n "$th" ]]; then
      installed_themes+=("$(basename "$th")")
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

  # remove installed themes
  if ((${#THEMES[@]} == 0)); then
    for index in "${!installed_themes[@]}"; do
      prompt_uninstall_theme \
        "${installed_themes[$index]}" \
        "${installed_theme_dirs[$index]}"
    done
  else
    local theme_index
    for th in "${THEMES[@]}"; do
      theme_index=-1
      for index in "${!installed_themes[@]}"; do
        if [[ th == "${installed_themes[$index]}" ]]; then
          theme_index=$index
          verbose_info_msg "Index of a theme '$th' is $theme_index"
        fi
      done

      if ((theme_index > 0)); then
        prompt_uninstall_theme \
          "${installed_themes[$theme_index]}" \
          "${installed_theme_dirs[$theme_index]}"
      else
        warning_msg "Cannot find theme '$th'. Skipped."
      fi
    done
  fi
}

# ---- main executions ----
grub_uninstall_theme
