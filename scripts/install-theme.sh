#! /usr/bin/env bash

# make sure the script is fail safe
set -euo pipefail

# ---- globals ----
readonly ROOT_UID=0
readonly THEME_NAME="wuwa"

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BACKGROUND_DIR="${PROJECT_ROOT}/backgrounds"

# remote configurations
# TODO: switch branch to master before it being merged.
readonly GITHUB_USERNAME="XezolesS"
readonly GITHUB_REPOS="wuwa-grub2-theme"
readonly GITHUB_BRANCH="script-v2"

# ---- arguments handling ----
OPTS=$(getopt \
  -o t:,r:,b,R,h \
  -l theme:,resolution:,boot,remote,backgrounds-dir:,help \
  -n "install-theme" -- "$@")
eval set -- "$OPTS"

THEME=
RESOLUTION="fhd"
BOOT=0
REMOTE=0

while true; do
  case "$1" in
  -t | --theme)
    THEME="$2"
    shift 2
    ;;
  -r | --resolution)
    RESOLUTION="${2,,}"
    shift 2
    ;;
  -b | --boot)
    BOOT=1
    shift
    ;;
  -R | --remote)
    REMOTE=1
    shift
    ;;
  --backgrounds-dir)
    BACKGROUND_DIR="$2"
    shift 2
    ;;
  -h | --help)
    cat <<EOF

Usage: $0 [OPTION]

[OPTIONS]:
  -t, --theme THEME   
  -s, --screen-resoltuion (fhd|qhd|uhd) 
  -r, --remote    Fetch the theme list from a remote repository. [background_path] will be ignored.
  -h, --help      Show this help
EOF
    exit 0
    ;;
  --)
    shift
    break
    ;;
  esac
done

# ---- source scripts ----
# utils.sh
source "${SCRIPT_DIR}/utils.sh"

# load-themes.sh
LOAD_THEMES_PARAMS=()
if ((REMOTE == 1)); then
  LOAD_THEMES_PARAMS+=("-r")
fi

if [[ -n "$BACKGROUND_DIR" ]]; then
  # if $THEME is a file, $BACKGROUND_DIR is ignored.
  if [[ "$THEME" == *".png" ]]; then
    LOAD_THEMES_PARAMS+=("$THEME")
  else
    LOAD_THEMES_PARAMS+=("$BACKGROUND_DIR")
  fi
fi

source "${SCRIPT_DIR}/load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"

# ---- functions ----
# install a theme
install_theme() {
  # requires root permission
  if [[ "$UID" -eq "$ROOT_UID" ]]; then
    return
  fi

  local GRUB_THEME_DIR <<<"$(grub_get_theme_dir "$BOOT")"

  # Make a themes directory if it doesn't exist
  info_msg "Checking themes directory ${GRUB_THEME_DIR} ..."

  [[ -d "${GRUB_THEME_DIR}" ]] && rm -rf "${GRUB_THEME_DIR}"
  mkdir -p "${GRUB_THEME_DIR}"

  # Copy theme
  info_msg "Installing ${THEME_NAME}-${THEME} ${RESOLUTION} ..."

  # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
  cp -a --no-preserve=ownership "${REO_DIR}/common/"*.pf2 "${GRUB_THEME_DIR}"
  cp -a --no-preserve=ownership "${REO_DIR}/config/theme-${RESOLUTION}.txt" "${GRUB_THEME_DIR}/theme.txt"
  cp -a --no-preserve=ownership "${REO_DIR}/backgrounds/${THEME}.png" "${GRUB_THEME_DIR}/background.png"
  cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-icons/icons-${RESOLUTION}" "${GRUB_THEME_DIR}/icons"
  cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-other/other-${RESOLUTION}/"*.png "${GRUB_THEME_DIR}"

  # Fedora workaround to fix the missing unicode.pf2 file (tested on fedora 34): https://bugzilla.redhat.com/show_bug.cgi?id=1739762
  # This occurs when we add a theme on grub2 with Fedora.
  if has_command dnf; then
    if [[ -f "/boot/grub2/fonts/unicode.pf2" ]]; then
      if grep "GRUB_FONT=" /etc/default/grub >/dev/null 2>&1; then
        #Replace GRUB_FONT
        sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/grub2/fonts/unicode.pf2|" /etc/default/grub
      else
        #Append GRUB_FONT
        echo "GRUB_FONT=/boot/grub2/fonts/unicode.pf2" >>/etc/default/grub
      fi
    elif [[ -f "/boot/efi/EFI/fedora/fonts/unicode.pf2" ]]; then
      if grep "GRUB_FONT=" /etc/default/grub >/dev/null 2>&1; then
        #Replace GRUB_FONT
        sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2|" /etc/default/grub
      else
        #Append GRUB_FONT
        echo "GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2" >>/etc/default/grub
      fi
    fi
  fi

  if grep "GRUB_THEME=" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_THEME
    sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${GRUB_THEME_DIR}/theme.txt\"|" /etc/default/grub
  else
    #Append GRUB_THEME
    echo "GRUB_THEME=\"${GRUB_THEME_DIR}/theme.txt\"" >>/etc/default/grub
  fi

  if grep "GRUB_BACKGROUND=" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_BACKGROUND
    sed -i "s|.*GRUB_BACKGROUND=.*|GRUB_BACKGROUND=\"${GRUB_THEME_DIR}/background.png\"|" /etc/default/grub
  else
    #Append GRUB_BACKGROUND
    echo "GRUB_BACKGROUND=\"${GRUB_THEME_DIR}/background.png\"" >>/etc/default/grub
  fi

  # Make sure the right resolution for grub is set
  if [[ ${RESOLUTION} == "fhd" ]]; then
    gfxmode="GRUB_GFXMODE=1920x1080,auto"
  elif [[ ${RESOLUTION} == "qhd" ]]; then
    gfxmode="GRUB_GFXMODE=2560x1440,auto"
  elif [[ ${RESOLUTION} == "uhd" ]]; then
    gfxmode="GRUB_GFXMODE=3840x2160,auto"
  fi

  if grep "GRUB_GFXMODE=" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_GFXMODE
    sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub
  else
    #Append GRUB_GFXMODE
    echo "${gfxmode}" >>/etc/default/grub
  fi

  if grep "GRUB_TERMINAL=console" /etc/default/grub >/dev/null 2>&1 ||
    grep "GRUB_TERMINAL=\"console\"" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_TERMINAL
    sed -i "s|.*GRUB_TERMINAL=.*|#GRUB_TERMINAL=console|" /etc/default/grub
  fi

  if grep "GRUB_TERMINAL_OUTPUT=console" /etc/default/grub >/dev/null 2>&1 ||
    grep "GRUB_TERMINAL_OUTPUT=\"console\"" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_TERMINAL_OUTPUT
    sed -i "s|.*GRUB_TERMINAL_OUTPUT=.*|#GRUB_TERMINAL_OUTPUT=console|" /etc/default/grub
  fi

  # For Kali linux
  if [[ -f "/etc/default/grub.d/kali-themes.cfg" &&
    ! -f "/etc/default/grub.d/kali-themes.cfg.bak" ]]; then
    cp -an /etc/default/grub.d/kali-themes.cfg /etc/default/grub.d/kali-themes.cfg.bak
    sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub.d/kali-themes.cfg
    sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${GRUB_THEME_DIR}/theme.txt\"|" /etc/default/grub.d/kali-themes.cfg
  fi

  # Update grub config
  info_msg "Updating grub config..."
  updating_grub
  warning_msg "* At the next restart of your computer you will see your new Grub theme: '${THEME_NAME}-${THEME}' "
}

# ---- main executions ----
sudo bash -c "$(install_theme)"
