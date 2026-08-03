#! /usr/bin/env bash

# ---- globals ----
# binaries
INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

ASSETS_DIR="${PROJECT_ROOT}/assets"

# assets
VARIANTS=("icons" "other")
RESOLUTIONS=("fhd" "qhd" "uhd")

ICON_ALIASES=(
  "archlinux arch"
  "gnu-linux linux"
  "gnu-linux unknown"
  "gnu-linux lfs"
  "manjaro Manjaro.i686"
  "manjaro Manjaro.x86_64"
  "manjaro manjarolinux"
  "pop-os pop"
  "driver memtest"
)

# ---- source scripts ----
# if print_msg is not defined, source utils.sh
if ! declare -f print_msg >/dev/null; then
  source "${SCRIPT_DIR}/utils.sh"
fi

# ---- functions ----
render_assets() {
  if [[ "$1" == "other" ]]; then
    local EXPORT_TYPE="other"
    local INDEX="$ASSETS_DIR/other.txt"
    local SRC_FILE="$ASSETS_DIR/other.svg"
  else
    local EXPORT_TYPE="icons"
    local INDEX="$ASSETS_DIR/icons.txt"
    local SRC_FILE="$ASSETS_DIR/icons.svg"
  fi

  if [[ "${2,,}" == "fhd" ]]; then
    local EXPORT_DIR="$ASSETS_DIR/assets-$EXPORT_TYPE/$EXPORT_TYPE-fhd"
    local EXPORT_DPI="96"
  elif [[ "${2,,}" == "qhd" ]]; then
    local EXPORT_DIR="$ASSETS_DIR/assets-$EXPORT_TYPE/$EXPORT_TYPE-qhd"
    local EXPORT_DPI="144"
  elif [[ "${2,,}" == "uhd" ]]; then
    local EXPORT_DIR="$ASSETS_DIR/assets-$EXPORT_TYPE/$EXPORT_TYPE-uhd"
    local EXPORT_DPI="192"
  else
    error_msg "Please use either 'fhd', 'qhd' or 'uhd'"
    exit 1
  fi

  install -d "$EXPORT_DIR"

  while read -r i; do
    if [[ -f "$EXPORT_DIR/$i.png" ]]; then
      warning_msg "$EXPORT_DIR/$i.png exists"
    elif [[ "$i" == "" ]]; then
      continue
    else
      info_msg "Rendering $EXPORT_DIR/$i.png"
      $INKSCAPE "--export-id=$i" \
        "--export-dpi=$EXPORT_DPI" \
        "--export-id-only" \
        "--export-filename=$EXPORT_DIR/$i.png" "$SRC_FILE" &>/dev/null
      $OPTIPNG -quiet -strip all -nc "$EXPORT_DIR/$i.png"
    fi
  done <"$INDEX"

  if [[ "$EXPORT_TYPE" == "icons" ]]; then
    cd "$EXPORT_DIR" || exit 1
    for al in "${ICON_ALIASES[@]}"; do
      read -ra icon <<<"$al"
      cp -a "${icon[0]}.png" "${icon[1]}.png"
    done
  fi
}

# make index file for remote access.
index_assets() {
  local buf=()
  if [[ "$1" == "other" ]]; then
    local INDEX="$ASSETS_DIR/other.txt"
    local INDEX_FILE="$ASSETS_DIR/assets-other/index.txt"
  else
    local INDEX="$ASSETS_DIR/icons.txt"
    local INDEX_FILE="$ASSETS_DIR/assets-icons/index.txt"
    for al in "${ICON_ALIASES[@]}"; do
      read -ra icon <<<"$al"
      buf+=("${icon[1]}")
    done
  fi

  while read -r i; do
    if [[ -n "$i" ]]; then
      buf+=("$i")
    fi
  done <"$INDEX"

  if [[ -f "$INDEX_FILE" ]]; then
    rm "$INDEX_FILE"
  fi

  printf '%s.png\n' "${buf[@]}" | sort >>"$INDEX_FILE"
}

# ---- main executions ----
for variant in "${VARIANTS[@]}"; do
  for resolution in "${RESOLUTIONS[@]}"; do
    info_msg "Start rendering assets-$variant-$resolution..."
    render_assets "$variant" "$resolution"
  done

  info_msg "Indexing $variant assets"
  index_assets "$variant"
done
