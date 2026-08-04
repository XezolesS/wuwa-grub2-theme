#! /usr/bin/env bash

# make sure the script is fail safe
set -euo errexit

# ---- globals ----
readonly ROOT_UID=0
readonly THEME_NAME="wuwa"

readonly UTILS_SH_URL="http://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/script-v2/scripts/utils.sh"

readonly RESOLUTION_OPTIONS=("fhd" "qhd" "uhd")

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BACKGROUND_PATH="${PROJECT_ROOT}/backgrounds"

TEMP_DL_DIR=".wuwa-grub2-theme-dl"

# ---- arguments handling ----
OPTS=$(getopt \
  -o R,b,v,h \
  -l boot,remote,backgrounds-path:,verbose,help \
  -n "install-theme" -- "$@")
eval set -- "$OPTS"

BOOT=0
VERBOSE=0
REMOTE=0
CUSTOM_BACKGROUND=0

while true; do
  case "$1" in
  -b | --boot)
    BOOT=1
    shift
    ;;
  -R | --remote)
    REMOTE=1
    shift
    ;;
  --backgrounds-path)
    BACKGROUND_PATH="$2"
    shift 2
    ;;
  -v | --verbose)
    VERBOSE=1
    shift
    ;;
  -h | --help)
    cat <<EOF

Usage: $0 [OPTION] THEME [RESOLUTION]

THEME:
  Name of the theme to install.
  If '--background-path' is a file, this will be ignored, but required.

[RESOLUTION]: [fhd | qhd | uhd]
  Resolution of a monitor. Defaults to 'fhd'.

[OPTIONS]:
  -b, --boot          Install theme to boot directory. (/boot/grub/theme)
  -r, --remote        Fetch the theme list from a remote repository. [background-path] will be ignored.
  --backgrounds-path  Custom background path. Can be either file or directory.
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
if [[ -z "${1-}" ]]; then
  echo -e "\033[1;31mERROR: \033[0mYou need to specify a theme to install!"
  exit 1
fi

THEME="$1"

# RESOLUTION
if [[ -z "${2-}" ]]; then
  RESOLUTION="fhd"
else
  RESOLUTION="$2"
fi

# Set THEME as base name of a BACKGROUND_PATH, if its a PNG file.
if [[ -n "$BACKGROUND_PATH" ]] && [[ "$BACKGROUND_PATH" == *".png" ]]; then
  _themename="$(basename "$BACKGROUND_PATH")"
  THEME="${_themename%.png}"
  CUSTOM_BACKGROUND=1
fi

# ---- source scripts ----
# utils.sh

if ((REMOTE == 0)); then
  source "${SCRIPT_DIR}/utils.sh"
else
  source <(curl -fsSL "$UTILS_SH_URL")
fi

# load-themes.sh
LOAD_THEMES_PARAMS=()
if ((REMOTE == 1)) && ((CUSTOM_BACKGROUND == 0)); then
  LOAD_THEMES_PARAMS+=("-r")
fi

if [[ -n "$BACKGROUND_PATH" ]]; then
  LOAD_THEMES_PARAMS+=("$BACKGROUND_PATH")
fi

if ((REMOTE == 0)); then
  source "${SCRIPT_DIR}/load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"
else
  # temporarily download a script, because passing arguments is kinda tideous.
  download_remote_content "$(get_remote_content_url "scripts/load-themes.sh")" ".load-themes.sh"
  source ".load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"
  rm .load-themes.sh

  REMOTE=1 # workaround for REMOTE being changed by .load-themes.sh
fi

# ---- functions ----
download_theme() {
  if ((REMOTE == 0)); then
    return
  fi

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
    verbose_info_msg "$VERBOSE" "Downloading '${font_f}' from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/fonts/$font_f"
  done

  # download a config
  _url="$(get_remote_content_url "config/theme-${RESOLUTION}.txt")"
  info_msg "Downloading '${RESOLUTION}' config from: $_url"
  download_remote_content "$_url" "$TEMP_DL_DIR/theme-${RESOLUTION}.txt"

  # download a background
  if ((CUSTOM_BACKGROUND == 0)); then
    _url="$(get_remote_content_url "backgrounds/${THEME}.png")"
    info_msg "Downloading '${THEME}' theme from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/${THEME}.png"
  else
    info_msg "Custom background $THEME is set. Skip downloading background..."
  fi

  # donwload assets
  _url="$(get_remote_content_url "assets/assets-icons/index.txt")"
  info_msg "Fetching icon assets index from: $_url"
  mapfile -t assets_icons_files < <(curl_remote_content "$_url")
  info_msg "Downloading ${#assets_icons_files[@]} assets..."
  for icon_f in "${assets_icons_files[@]}"; do
    _url=$(get_remote_content_url "assets/assets-icons/icons-${RESOLUTION}/${icon_f}")
    verbose_info_msg "$VERBOSE" "Downloading '${icon_f}' from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/assets-icons/$icon_f"
  done

  _url="$(get_remote_content_url "assets/assets-other/index.txt")"
  info_msg "Fetching other assets index from: $_url"
  mapfile -t assets_other_files < <(curl_remote_content "$_url")
  info_msg "Downloading ${#assets_other_files[@]} assets..."
  for other_f in "${assets_other_files[@]}"; do
    _url=$(get_remote_content_url "assets/assets-other/other-${RESOLUTION}/${other_f}")
    verbose_info_msg "$VERBOSE" "Downloading '${other_f}' from: $_url"
    download_remote_content "$_url" "$TEMP_DL_DIR/assets-other/$other_f"
  done
}

# install a theme
grub_install_theme() {
  # requires root permission
  if [[ "$UID" -ne "$ROOT_UID" ]]; then
    error_msg "Requires root permission to install! Try again with sudo."
    exit 1
  fi

  info_msg "Start installing $THEME in ${RESOLUTION^^}."

  local GRUB_THEME_DIR=
  GRUB_THEME_DIR="$(grub_get_theme_dir "$BOOT")"

  # Make a themes directory if it doesn't exist
  info_msg "Checking themes directory ${GRUB_THEME_DIR} ..."

  [[ -d "${GRUB_THEME_DIR}" ]] && rm -rf "${GRUB_THEME_DIR}"
  mkdir -p "${GRUB_THEME_DIR}"

  # Copy theme
  info_msg "Installing ${THEME_NAME}-${THEME} ${RESOLUTION} ..."

  if ((REMOTE == 0)); then
    local THEME_FONTS_DIR="${PROJECT_ROOT}/fonts"
    local THEME_CONFIG="${PROJECT_ROOT}/config/theme-${RESOLUTION}.txt"
    local THEME_BACKGROUNDS="${PROJECT_ROOT}/backgrounds/${THEME}.png"
    local THEME_ASSETS_ICONS_DIR="${PROJECT_ROOT}/assets/assets-icons/icons-${RESOLUTION}"
    local THEME_ASSETS_OTHER_DIR="${PROJECT_ROOT}/assets/assets-other/other-${RESOLUTION}"
  else
    download_theme
    local THEME_FONTS_DIR="${TEMP_DL_DIR}/fonts"
    local THEME_CONFIG="${TEMP_DL_DIR}/theme-${RESOLUTION}.txt"
    local THEME_BACKGROUNDS="${TEMP_DL_DIR}/${THEME}.png"
    local THEME_ASSETS_ICONS_DIR="${TEMP_DL_DIR}/assets-icons"
    local THEME_ASSETS_OTHER_DIR="${TEMP_DL_DIR}/assets-other"
  fi

  # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
  cp -a --no-preserve=ownership "$THEME_FONTS_DIR"/*.pf2 "${GRUB_THEME_DIR}"
  cp -a --no-preserve=ownership "$THEME_CONFIG" "${GRUB_THEME_DIR}/theme.txt"
  cp -a --no-preserve=ownership "$THEME_BACKGROUNDS" "${GRUB_THEME_DIR}/background.png"
  cp -a --no-preserve=ownership "$THEME_ASSETS_ICONS_DIR" "${GRUB_THEME_DIR}/icons"
  cp -a --no-preserve=ownership "$THEME_ASSETS_OTHER_DIR"/*.png "${GRUB_THEME_DIR}"

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
  grub_update
  warning_msg "* At the next restart of your computer you will see your new Grub theme: '${THEME_NAME}-${THEME}' "
}

# ---- main executions ----

# verify theme
if ! printf '%s\0' "${THEME_LIST[@]}" | grep -Fxqz -- "$THEME"; then
  error_msg "Unknown theme '$THEME'! List of themes:"
  printf '%s, \0' "${THEME_LIST[@]}" && echo ""
  exit 1
fi

# verify resolution
if ! printf '%s\0' "${RESOLUTION_OPTIONS[@]}" | grep -Fxqz -- "$RESOLUTION"; then
  error_msg "Unsupported resolution '$RESOLUTION'! Supported resolutions:"
  printf '%s, \0' "${RESOLUTION_OPTIONS[@]}" && echo ""
  exit 1
fi

# verbose logging
if ((VERBOSE == 1)); then
  info_msg "Theme: ${THEME}"
  info_msg "Resolution: ${RESOLUTION}"
  info_msg "Boot flag: ${BOOT}"
  info_msg "Remote flag: ${REMOTE}"
  info_msg "Background path: ${BACKGROUND_PATH}"
  info_msg "Custom background flag: ${CUSTOM_BACKGROUND}"
fi

grub_install_theme
