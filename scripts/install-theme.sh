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
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BACKGROUND_DIR="${PROJECT_ROOT}/backgrounds"

TEMP_DL_DIR=".wuwa-grub2-theme-dl"

# ---- arguments handling ----
OPTS=$(getopt \
  -o t:,r:,R,b,h \
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

if ((REMOTE == 0)); then
  source "${SCRIPT_DIR}/utils.sh"
else
  source <(curl -fsSL "$UTILS_SH_URL")
fi

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

if ((REMOTE == 0)); then
  source "${SCRIPT_DIR}/load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"
else
  download_remote_content "$(get_remote_content_url "scripts/load-themes.sh")" ".load-themes.sh"
  source ".load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"
fi

# ---- functions ----
download_theme() {
  # Remote, make temporary directory and download inside of it
  if [[ -d "$TEMP_DL_DIR" ]]; then
    rm -r "$TEMP_DL_DIR"
  fi

  mkdir "$TEMP_DL_DIR" \
    "$TEMP_DL_DIR/fonts" \
    "$TEMP_DL_DIR/assets-icons" \
    "$TEMP_DL_DIR/assets-other"

  local _url=""

  # download fonts
  _url="$(get_remote_content_url "fonts/index.txt")"
  info_msg "Fetching fonts index from: $_url"
  mapfile -t font_files < <(curl_remote_content "$_url")
  for font_f in "${font_files[@]}"; do
    _url=$(get_remote_content_url "fonts/${font_f}")
    info_msg "Downloading '${font_f}' from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/fonts/$font_f"
  done

  # download a config
  _url="$(get_remote_content_url "config/theme-${RESOLUTION}.txt")"
  info_msg "Downloading '${RESOLUTION}' config from: $_url"
  download_remote_content "$_url" "$TEMP_DL_DIR/theme-${RESOLUTION}.txt"

  # download a background
  _url="$(get_remote_content_url "backgrounds/${THEME}.png")"
  info_msg "Downloading '${THEME}' theme from: $_url"
  download_remote_content "$_url" "$TEMP_DL_DIR/${THEME}.png"

  # donwload assets
  _url="$(get_remote_content_url "assets/assets-icons/index.txt")"
  info_msg "Fetching icon assets index from: $_url"
  mapfile -t assets_icons_files < <(curl_remote_content "$_url")
  for icon_f in "${assets_icons_files[@]}"; do
    _url=$(get_remote_content_url "assets/assets-icons/icons-${RESOLUTION}/${icon_f}")
    info_msg "Downloading '${icon_f}' from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/assets-icons/$icon_f"
  done

  _url="$(get_remote_content_url "assets/assets-other/index.txt")"
  info_msg "Fetching other assets index from: $_url"
  mapfile -t assets_other_files < <(curl_remote_content "$_url")
  for other_f in "${assets_other_files[@]}"; do
    _url=$(get_remote_content_url "assets/assets-other/other-${RESOLUTION}/${other_f}")
    info_msg "Downloading '${other_f}' from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/assets-other/$other_f"
  done

}

# install a theme
install_theme() {
  # requires root permission
  if [[ "$UID" -eq "$ROOT_UID" ]]; then
    return
  fi

  local GRUB_THEME_DIR=
  $GRUB_THEME_DIR <<<"$(grub_get_theme_dir "$BOOT")"

  # Make a themes directory if it doesn't exist
  info_msg "Checking themes directory ${GRUB_THEME_DIR} ..."

  [[ -d "${GRUB_THEME_DIR}" ]] && rm -rf "${GRUB_THEME_DIR}"
  mkdir -p "${GRUB_THEME_DIR}"

  # Copy theme
  info_msg "Installing ${THEME_NAME}-${THEME} ${RESOLUTION} ..."

  if ((REMOTE == 0)); then
    local THEME_FONTS="${PROJECT_ROOT}/fonts/*.pf2"
    local THEME_CONFIG="${PROJECT_ROOT}/config/theme-${RESOLUTION}.txt"
    local THEME_BACKGROUNDS="${PROJECT_ROOT}/backgrounds/${THEME}.png"
    local THEME_ASSETS_ICONS="${PROJECT_ROOT}/assets/assets-icons/icons-${RESOLUTION}"
    local THEME_ASSETS_OTHER="${PROJECT_ROOT}/assets/assets-other/other-${RESOLUTION}/*.png"
  else
    local THEME_FONTS="${TEMP_DL_DIR}/fonts/*.pf2"
    local THEME_CONFIG="${TEMP_DL_DIR}/theme-${RESOLUTION}.txt"
    local THEME_BACKGROUNDS="${TEMP_DL_DIR}/${THEME}.png"
    local THEME_ASSETS_ICONS="${TEMP_DL_DIR}/assets-icons"
    local THEME_ASSETS_OTHER="${TEMP_DL_DIR}/assets-other/*.png"
  fi

  # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
  cp -a --no-preserve=ownership "$THEME_FONTS" "${GRUB_THEME_DIR}"
  cp -a --no-preserve=ownership "$THEME_CONFIG" "${GRUB_THEME_DIR}/theme.txt"
  cp -a --no-preserve=ownership "$THEME_BACKGROUNDS" "${GRUB_THEME_DIR}/background.png"
  cp -a --no-preserve=ownership "$THEME_ASSETS_ICONS" "${GRUB_THEME_DIR}/icons"
  cp -a --no-preserve=ownership "$THEME_ASSETS_OTHER" "${GRUB_THEME_DIR}"

  # delete temporary directory if it exists
  if [[ -d "$TEMP_DL_DIR" ]]; then
    rm -r "$TEMP_DL_DIR"
  fi

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
