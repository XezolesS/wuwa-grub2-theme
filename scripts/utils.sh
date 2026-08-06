#! /usr/bin/env bash

# make sure the script is fail safe
set -euo pipefail

# ---- colors ----
COLOR_DEF="\033[0m"         # default color
COLOR_INF="\033[0;36m"      # info color
COLOR_SUC="\033[0;32m"      # success color
COLOR_ERR="\033[0;31m"      # error color
COLOR_WAR="\033[0;33m"      # waring color
COLOR_BOLD_DEF="\033[1;37m" # bold default color
COLOR_BOLD_INF="\033[1;36m" # bold info color
COLOR_BOLD_SUC="\033[1;32m" # bold success color
COLOR_BOLD_ERR="\033[1;31m" # bold error color
COLOR_BOLD_WAR="\033[1;33m" # bold warning color

# ---- remote configurations ----
# TODO: switch branch to master before it being merged.
readonly GITHUB_USERNAME="XezolesS"
readonly GITHUB_REPOS="wuwa-grub2-theme"
readonly GITHUB_BRANCH="master"

# ---- functions ----
print_msg() {
  printf "${COLOR_DEF}%s\n" "$1"
}

info_msg() {
  printf "${COLOR_BOLD_INF}INFO: ${COLOR_DEF}%s\n" "$1"
}

verbose_info_msg() {
  if (("$VERBOSE" == 1)); then
    info_msg "$1"
  fi
}

success_msg() {
  printf "${COLOR_BOLD_SUC}SUCCESS: ${COLOR_DEF}%s\n" "$1"
}

warning_msg() {
  printf "${COLOR_BOLD_WAR}WARNING: ${COLOR_DEF}%s\n" "$1"
}

error_msg() {
  printf "${COLOR_BOLD_ERR}ERROR: ${COLOR_DEF}%s\n" "$1"
}

has_command() {
  command -v "$1" &>/dev/null
}

get_remote_content_url() {
  echo "https://raw.githubusercontent.com/$GITHUB_USERNAME/$GITHUB_REPOS/$GITHUB_BRANCH/$1"
}

curl_remote_content() {
  curl -fsSL "$1"
}

download_remote_content() {
  curl -fsSL "$1" -o "$2"
}

grub_update() {
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  # Check for OpenSuse (regular or microOS)
  elif has_command zypper || has_command transactional-update; then
    grub2-mkconfig -o /boot/grub2/grub.cfg
  # Check for Fedora (regular or Atomic)
  elif has_command dnf || has_command rpm-ostree; then
    # Check for UEFI
    if [[ -f "/boot/efi/EFI/fedora/grub.cfg" ]]; then
      info_msg "Find config file on /boot/efi/EFI/fedora/grub.cfg ...\n"
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    # Check for BIOS
    elif [[ -f "/boot/grub2/grub.cfg" ]]; then
      info_msg "Find config file on /boot/grub2/grub.cfg ...\n"
      grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
  fi

  # Success message
  success_msg "GRUB config updated!"
}

grub_get_theme_dir() {
  if [[ "$1" == "0" ]]; then
    echo "/usr/share/grub/themes"
  else
    if [[ -d "/boot/grub" ]]; then
      echo "/boot/grub/themes"
    elif [[ -d "/boot/grub2" ]]; then
      echo "/boot/grub2/themes"
    fi
  fi
}

# only list themes starts with a certain string.
grub_ls_themes() {
  prefix="$1"
  themes=()

  for th in "/usr/share/grub/themes/$prefix"*; do
    if [[ -d "$th" ]] && [[ -f "$th"/theme.txt ]]; then
      themes+=("$th")
    fi
  done

  for th in "/boot/grub/themes/$prefix"*; do
    if [[ -d "$th" ]] && [[ -f "$th"/theme.txt ]]; then
      themes+=("$th")
    fi
  done

  for th in "/boot/grub2/themes/$prefix"*; do
    if [[ -d "$th" ]] && [[ -f "$th"/theme.txt ]]; then
      themes+=("$th")
    fi
  done

  printf '%s\n' "${themes[@]}"
}
