#! /usr/bin/env bash

# make sure the script is fail safe
set -euo pipefail

# ---- globals ----
readonly ROOT_UID=0
readonly THEME_NAME="wuwa"

if [[ -z "${UTILS_SH_URL:-}" ]]; then
  readonly UTILS_SH_URL="http://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/utils.sh"
fi

readonly RESOLUTION_OPTIONS=("fhd" "qhd" "uhd")

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

BACKGROUND_PATH="$PROJECT_ROOT/backgrounds"

# ---- arguments handling ----
OPTS=$(getopt \
  -o b,r,v,o:,h \
  -l boot,remote,backgrounds-path:,output,verbose,help \
  -n "install-theme" -- "$@")
eval set -- "$OPTS"

BOOT=0
VERBOSE=0
REMOTE=0
CUSTOM_BACKGROUND=0
OUTPUT=

while true; do
  case "$1" in
  -b | --boot)
    BOOT=1
    shift
    ;;
  -r | --remote)
    REMOTE=1
    shift
    ;;
  --backgrounds-path)
    BACKGROUND_PATH="${2/#\~/$HOME}" # simple tilde expansion
    CUSTOM_BACKGROUND=1
    shift 2
    ;;
  -o | --output)
    OUTPUT="${2/#\~/$HOME}"
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
  -o, --output        Output directory. Instead of installing theme to GRUB, it compiles it to other directory. Cannot be used with --boot.
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

# set custom background flag
if [[ -n "$BACKGROUND_PATH" ]]; then
  # Set THEME as base name of a BACKGROUND_PATH, if its a PNG file.
  if [[ "$BACKGROUND_PATH" == *".png" ]]; then
    _themename="$(basename "$BACKGROUND_PATH")"
    THEME="${_themename%.png}"
  fi
fi

# ---- source scripts ----
# utils.sh
if ((REMOTE == 0)); then
  source "$SCRIPT_DIR/utils.sh"
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
  source "$SCRIPT_DIR/load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"
else
  # temporarily download a script, because passing arguments is kinda tideous.
  mktempdir

  download_remote_content "$(get_remote_content_url "scripts/load-themes.sh")" "$TEMP_DIR/.load-themes.sh"
  source "$TEMP_DIR/.load-themes.sh" "${LOAD_THEMES_PARAMS[@]}"

  rmtempdir

  REMOTE=1 # workaround for REMOTE being changed by .load-themes.sh
fi

# ---- functions ----
download_theme() {
  if ((REMOTE == 0)); then
    return
  fi

  # Remote, make temporary directory and download inside of it
  mktempdir "fonts" "assets-icons" "assets-other"

  local content_url

  # download fonts
  content_url="$(get_remote_content_url "fonts/index.txt")"
  info_msg "Fetching fonts index from: $content_url"
  mapfile -t font_files < <(curl_remote_content "$content_url")
  for font_f in "${font_files[@]}"; do
    if [[ -n "$font_f" ]]; then
      content_url=$(get_remote_content_url "fonts/$font_f")
      verbose_info_msg "Downloading '$font_f' from: $content_url"
      download_remote_content "$content_url" "$TEMP_DIR/fonts/$font_f"
    fi
  done
  success_msg "Successfully downloaded fonts!"

  # download a config
  content_url="$(get_remote_content_url "config/theme-$RESOLUTION.txt")"
  info_msg "Downloading '$RESOLUTION' config from: $content_url"
  download_remote_content "$content_url" "$TEMP_DIR/theme-$RESOLUTION.txt"
  success_msg "Successfully downloaded a config!"

  # download a background
  if ((CUSTOM_BACKGROUND == 0)); then
    content_url="$(get_remote_content_url "backgrounds/$THEME.png")"
    info_msg "Downloading '$THEME' theme from: $content_url"
    download_remote_content "$content_url" "$TEMP_DIR/$THEME.png"
    success_msg "Successfully downloaded a background!"
  else
    info_msg "Custom background $THEME is set. Skip downloading background..."
  fi

  # donwload assets
  content_url="$(get_remote_content_url "assets/assets-icons/index.txt")"
  info_msg "Fetching icon assets index from: $content_url"
  mapfile -t assets_icons_files < <(curl_remote_content "$content_url")
  info_msg "Downloading ${#assets_icons_files[@]} assets..."
  for icon_f in "${assets_icons_files[@]}"; do
    if [[ -n "$font_f" ]]; then
      content_url=$(get_remote_content_url "assets/assets-icons/icons-$RESOLUTION/$icon_f")
      verbose_info_msg "Downloading '$icon_f' from: $content_url"
      download_remote_content "$content_url" "$TEMP_DIR/assets-icons/$icon_f"
    fi
  done
  success_msg "Successfully downloaded icon assets!"

  content_url="$(get_remote_content_url "assets/assets-other/index.txt")"
  info_msg "Fetching other assets index from: $content_url"
  mapfile -t assets_other_files < <(curl_remote_content "$content_url")
  info_msg "Downloading ${#assets_other_files[@]} assets..."
  for other_f in "${assets_other_files[@]}"; do
    content_url=$(get_remote_content_url "assets/assets-other/other-$RESOLUTION/$other_f")
    verbose_info_msg "Downloading '$other_f' from: $content_url"
    download_remote_content "$content_url" "$TEMP_DIR/assets-other/$other_f"
  done
  success_msg "Successfully downloaded other assets!"
}

compile_theme() {
  info_msg "Compiling $THEME_NAME-$THEME $RESOLUTION ..."

  local output_dir="$1"
  if [[ "$output_dir" != *"/$THEME_NAME-$THEME" ]]; then
    output_dir+="/$THEME_NAME-$THEME"
  fi

  # Make a themes directory if it doesn't exist
  info_msg "Checking themes directory $output_dir ..."

  [[ -d "$output_dir" ]] && rm -rf "$output_dir"
  mkdir -p "$output_dir"

  if ((REMOTE == 0)); then
    local theme_fonts_dir="$PROJECT_ROOT/fonts"
    local theme_config="$PROJECT_ROOT/config/theme-$RESOLUTION.txt"
    local theme_background
    theme_background="$(get_theme_path "$THEME")"
    local theme_assets_icons_dir="$PROJECT_ROOT/assets/assets-icons/icons-$RESOLUTION"
    local theme_assets_other_dir="$PROJECT_ROOT/assets/assets-other/other-$RESOLUTION"
  else
    download_theme

    local theme_fonts_dir="$TEMP_DIR/fonts"
    local theme_config="$TEMP_DIR/theme-$RESOLUTION.txt"
    local theme_background="$TEMP_DIR/$THEME.png"
    local theme_assets_icons_dir="$TEMP_DIR/assets-icons"
    local theme_assets_other_dir="$TEMP_DIR/assets-other"

    if ((CUSTOM_BACKGROUND == 1)); then
      theme_background="$(get_theme_path "$THEME")"
    fi
  fi

  # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
  cp -a --no-preserve=ownership "$theme_fonts_dir"/*.pf2 "$output_dir"
  cp -a --no-preserve=ownership "$theme_config" "$output_dir/theme.txt"
  cp -a --no-preserve=ownership "$theme_background" "$output_dir/background.png"
  cp -a --no-preserve=ownership "$theme_assets_icons_dir" "$output_dir/icons"
  cp -a --no-preserve=ownership "$theme_assets_other_dir"/*.png "$output_dir"

  # delete temporary directory if it exists
  rmtempdir

  success_msg "Successfully compiled a theme $THEME."
}

# install a theme
grub_install_theme() {
  # requires root permission
  if [[ "$UID" -ne "$ROOT_UID" ]]; then
    error_msg "Requires root permission to install! Try again with sudo."
    exit 1
  fi

  info_msg "Start installing $THEME in ${RESOLUTION^^}."

  local grub_theme_dir
  grub_theme_dir="$(grub_get_theme_dir "$BOOT")"/"$THEME_NAME-$THEME"

  # Compile theme
  compile_theme "$grub_theme_dir"

  # Fedora workaround to fix the missing unicode.pf2 file (tested on fedora 34): https://bugzilla.redhat.com/show_bug.cgi?id=1739762
  # This occurs when we add a theme on grub2 with Fedora.
  if has_command dnf; then
    info_msg "Fedora system detected. Working on a missing font..."
    if [[ -f "/boot/grub2/fonts/unicode.pf2" ]]; then
      verbose_info_msg "Font is found at: '/boot/grub2/fonts/unicode.pf2'. Writing GRUB_FONT to grub config..."
      if grep "GRUB_FONT=" /etc/default/grub >/dev/null 2>&1; then
        #Replace GRUB_FONT
        sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/grub2/fonts/unicode.pf2|" /etc/default/grub
      else
        #Append GRUB_FONT
        echo "GRUB_FONT=/boot/grub2/fonts/unicode.pf2" >>/etc/default/grub
      fi
    elif [[ -f "/boot/efi/EFI/fedora/fonts/unicode.pf2" ]]; then
      verbose_info_msg "Font is found at: '/boot/efi/EFI/fedora/fonts/unicode.pf2'. Writing GRUB_FONT to grub config..."
      if grep "GRUB_FONT=" /etc/default/grub >/dev/null 2>&1; then
        #Replace GRUB_FONT
        sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2|" /etc/default/grub
      else
        #Append GRUB_FONT
        echo "GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2" >>/etc/default/grub
      fi
    fi
  fi

  verbose_info_msg "Writing a GRUB_THEME to grub config..."
  if grep "GRUB_THEME=" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_THEME
    sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"$grub_theme_dir/theme.txt\"|" /etc/default/grub
  else
    #Append GRUB_THEME
    echo "GRUB_THEME=\"$grub_theme_dir/theme.txt\"" >>/etc/default/grub
  fi

  verbose_info_msg "Writing a GRUB_BACKGROUND to grub config..."
  if grep "GRUB_BACKGROUND=" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_BACKGROUND
    sed -i "s|.*GRUB_BACKGROUND=.*|GRUB_BACKGROUND=\"$grub_theme_dir/background.png\"|" /etc/default/grub
  else
    #Append GRUB_BACKGROUND
    echo "GRUB_BACKGROUND=\"$grub_theme_dir/background.png\"" >>/etc/default/grub
  fi

  # Make sure the right resolution for grub is set
  if [[ $RESOLUTION == "fhd" ]]; then
    gfxmode="GRUB_GFXMODE=1920x1080,auto"
  elif [[ $RESOLUTION == "qhd" ]]; then
    gfxmode="GRUB_GFXMODE=2560x1440,auto"
  elif [[ $RESOLUTION == "uhd" ]]; then
    gfxmode="GRUB_GFXMODE=3840x2160,auto"
  fi

  verbose_info_msg "Writing a GRUB_GFXMODE to grub config... ($gfxmode)"
  if grep "GRUB_GFXMODE=" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_GFXMODE
    sed -i "s|.*GRUB_GFXMODE=.*|$gfxmode|" /etc/default/grub
  else
    #Append GRUB_GFXMODE
    echo "$gfxmode" >>/etc/default/grub
  fi

  verbose_info_msg "Writing GRUB_TERMINAL to grub config..."
  if grep "GRUB_TERMINAL=console" /etc/default/grub >/dev/null 2>&1 ||
    grep "GRUB_TERMINAL=\"console\"" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_TERMINAL
    sed -i "s|.*GRUB_TERMINAL=.*|#GRUB_TERMINAL=console|" /etc/default/grub
  fi

  verbose_info_msg "Writing GRUB_TERMINAL_OUTPUT to grub config..."
  if grep "GRUB_TERMINAL_OUTPUT=console" /etc/default/grub >/dev/null 2>&1 ||
    grep "GRUB_TERMINAL_OUTPUT=\"console\"" /etc/default/grub >/dev/null 2>&1; then
    #Replace GRUB_TERMINAL_OUTPUT
    sed -i "s|.*GRUB_TERMINAL_OUTPUT=.*|#GRUB_TERMINAL_OUTPUT=console|" /etc/default/grub
  fi

  # For Kali linux
  if [[ -f "/etc/default/grub.d/kali-themes.cfg" &&
    ! -f "/etc/default/grub.d/kali-themes.cfg.bak" ]]; then
    verbose_info_msg "Kali Linux system detected. Patching Kali specific grub config..."
    cp -an /etc/default/grub.d/kali-themes.cfg /etc/default/grub.d/kali-themes.cfg.bak
    sed -i "s|.*GRUB_GFXMODE=.*|$gfxmode|" /etc/default/grub.d/kali-themes.cfg
    sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"$grub_theme_dir/theme.txt\"|" /etc/default/grub.d/kali-themes.cfg
  fi

  # Update grub config
  info_msg "Updating grub config..."
  grub_update
  warning_msg "At the next restart of your computer you will see your new Grub theme: '$THEME_NAME-$THEME' "
  success_msg "Successfully installed a theme $THEME!"
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

# boot & output confict check
if ((BOOT == 1)) && [[ -n "$OUTPUT" ]]; then
  error_msg "--boot and --output cannot be used together!"
  exit 1
fi

# verbose logging
if ((VERBOSE == 1)); then
  verbose_info_msg "Theme: $THEME"
  verbose_info_msg "Resolution: $RESOLUTION"
  verbose_info_msg "Boot flag: $BOOT"
  verbose_info_msg "Remote flag: $REMOTE"
  verbose_info_msg "Background path: $BACKGROUND_PATH"
  verbose_info_msg "Custom background flag: $CUSTOM_BACKGROUND"
  verbose_info_msg "Output: $OUTPUT"
fi

if [[ -z "$OUTPUT" ]]; then
  grub_install_theme
else
  compile_theme "$OUTPUT"
fi
