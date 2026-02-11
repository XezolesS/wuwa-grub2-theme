#! /usr/bin/env bash

# Exit Immediately if a command fails
set -o errexit

readonly Project_Name="GRUB2::THEMES"
readonly MAX_DELAY=20 # max delay for user to enter root password

THEME_NAME=wuwa
REO_DIR="$(cd $(dirname $0) && pwd)"
BG_DIR="$REO_DIR/backgrounds"

SCREEN_VARIANTS=('1080p' '2k' '4k')
THEME_VARIANTS=('none') # index 0 will be the placeholder to make an index starts from 1

# Load themes from ./backgrounds
for file in "$BG_DIR"/*; do
  if [[ -f "$file" ]] && [[ $file == *.png ]]; then
    filename=$(basename $file)
    THEME_VARIANTS+=(${filename%.png})
  fi
done

screens=()
themes=()

#################################
#   :::::: C O L O R S ::::::   #
#################################

CDEF=" \033[0m"      # default color
CCIN=" \033[0;36m"   # info color
CGSC=" \033[0;32m"   # success color
CRER=" \033[0;31m"   # error color
CWAR=" \033[0;33m"   # waring color
b_CDEF=" \033[1;37m" # bold default color
b_CCIN=" \033[1;36m" # bold info color
b_CGSC=" \033[1;32m" # bold success color
b_CRER=" \033[1;31m" # bold error color
b_CWAR=" \033[1;33m" # bold warning color

#######################################
#   :::::: F U N C T I O N S ::::::   #
#######################################

# echo like ... with flag type and display message colors
prompt() {
  case ${1} in
    "-s" | "--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}"
      ;; # print success message
    "-e" | "--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}"
      ;; # print error message
    "-w" | "--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}"
      ;; # print warning message
    "-i" | "--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}"
      ;; # print info message
    *)
      echo -e "$@"
      ;;
  esac
}

# Check command availability
function has_command() {
  command -v $1 &>/dev/null #with "&>", all output will be redirected.
}

usage() {
  default_theme="${THEME_VARIANTS[1]}"

  if (("${#THEME_VARIANTS[@]}" == 1)); then
    theme_options="no option available"
  else
    theme_options=""
    for theme in "${THEME_VARIANTS[@]:1}"; do
      theme_options+="$theme|"
    done
    theme_options="${theme_options::-1}"
  fi

  cat <<EOF

Usage: $0 [OPTION]...

OPTIONS:
  -t, --theme     Background theme variant(s) [$theme_options] (default is $default_theme)
  -s, --screen    Screen display variant(s)   [1080p|2k|4k] (default is 1080p)
  -r, --remove    Remove/Uninstall theme      [$theme_options] (must add theme name option, default is $default_theme)
  -b, --boot      Install theme into '/boot/grub' or '/boot/grub2'
  -h, --help      Show this help

EOF
}

verify_themes() {
  # Exit if no background is found
  if (("${#THEME_VARIANTS[@]}" == 1)); then
    prompt -e No theme is found!
    exit 1
  fi
}

get_theme_index() {
  local input=$1

  for index in "${!THEME_VARIANTS[@]}"; do
    if [[ "$input" == "${THEME_VARIANTS[index]}" ]]; then
      echo "$index"
      return 0
    fi
  done

  return 1
}

generate() {
  verify_themes

  local dest="${1}"
  local theme="${2}"
  local screen="${3}"

  local THEME_DIR="${1}/${THEME_NAME}-${2}"

  # Make a themes directory if it doesn't exist
  prompt -i "\n Checking themes directory ${THEME_DIR} ..."

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"
  mkdir -p "${THEME_DIR}"

  # Copy theme
  prompt -i "\n Installing Wuthering-${theme} ${screen} theme ..."

  # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
  cp -a --no-preserve=ownership "${REO_DIR}/common/"*.pf2 "${THEME_DIR}"
  cp -a --no-preserve=ownership "${REO_DIR}/config/theme-${screen}.txt" "${THEME_DIR}/theme.txt"
  cp -a --no-preserve=ownership "${REO_DIR}/backgrounds/${theme}.png" "${THEME_DIR}/background.png"
  cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-icons/icons-${screen}" "${THEME_DIR}/icons"
  cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-other/other-${screen}/"*.png "${THEME_DIR}"

  # Use custom background.png as grub background image
  if [[ -f "${REO_DIR}/background.png" ]]; then
    prompt -w "\n Using custom background.png as grub background image..."
    cp -a --no-preserve=ownership "${REO_DIR}/background.png" "${THEME_DIR}/background.png"
    convert -auto-orient "${THEME_DIR}/background.png" "${THEME_DIR}/background.png"
  fi

  prompt -s "\n Finished ..."
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d | --dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo -e "\nDestination directory does not exist. Let's make a new one..."
        mkdir -p ${dest}
      fi
      shift 2
      ;;
    -t | --theme)
      shift
      for theme in "${@}"; do
        if [[ "${theme}" == -* ]]; then
          break
        fi

        selected_theme=$(get_theme_index "$theme")
        if [[ $selected_theme != 255 ]]; then
          themes+=("${THEME_VARIANTS[selected_theme]}")
          shift
        else
          prompt -e "ERROR: Unrecognized theme variant '$1'."
          prompt -i "Try '$0 --help' for more information."
          exit 1
        fi
      done
      ;;
    -s | --screen)
      shift
      for screen in "${@}"; do
        case "${screen}" in
          1080p)
            screens+=("${SCREEN_VARIANTS[0]}")
            shift
            ;;
          2k)
            screens+=("${SCREEN_VARIANTS[1]}")
            shift
            ;;
          4k)
            screens+=("${SCREEN_VARIANTS[2]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized screen variant '$1'."
            prompt -i "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      prompt -e "ERROR: Unrecognized installation option '$1'."
      prompt -i "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#screens[@]}" -eq 0 ]]; then
  screens=("${SCREEN_VARIANTS[1]}")
fi

if [[ "${#themes[@]}" -eq 0 ]]; then
  themes=("${THEME_VARIANTS[1]}")
fi

for theme in "${themes[@]}"; do
  for screen in "${screens[@]}"; do
    generate "${dest:-$REO_DIR}" "${theme}" "${screen}"
  done
done

exit 0
