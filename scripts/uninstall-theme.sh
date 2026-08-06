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
Usage: $0 [OPTION] [THEME]

THEME:
  Name of the theme to uninstall.
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
# THEME
THEME="${1-}"

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
deactivate_theme() {
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

  local current_theme
  current_theme="$(grep 'GRUB_THEME=' $grub_config_location | grep -v \#)"

  if [[ -n "$current_theme" ]]; then
    # Backup with --in-place option to grub.bak within the same directory; then remove the current theme.
    sed --in-place='.bak' "s|$current_theme|#GRUB_THEME=|" "$grub_config_location"

    if [[ -f "$grub_config_location".bak ]]; then
      rm -rf "$grub_config_location".bak
    fi

    # Update grub config
    info_msg "Resetting grub theme..."
    grub_update
  else
    error_msg "\n No active theme found."
    info_msg "\n Exiting..."
    exit 1
  fi
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
    for th in "${installed_themes[@]}"; do
      verbose_info_msg "Found at $th"
    done
  fi
}

# ---- main executions ----
grub_uninstall_theme
