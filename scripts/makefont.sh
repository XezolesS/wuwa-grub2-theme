#! /usr/bin/env bash

# make sure the script is fail safe
set -euo pipefail

# ---- globals ----
# project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

FONTS_DIR="$PROJECT_ROOT/fonts"

# ---- source scripts ----
# if print_msg is not defined, source utils.sh
if ! declare -f print_msg >/dev/null; then
  source "$SCRIPT_DIR/utils.sh"
fi

# ---- functions ----
make_fonts() {
  cd "$FONTS_DIR" || return
  if has_command grub-mkfont; then
    grub-mkfont -o unifont-16.pf2 -s 16 unifont.otf
    grub-mkfont -o unifont-24.pf2 -s 24 unifont.otf
    grub-mkfont -o unifont-32.pf2 -s 32 unifont.otf
  elif has_command grub2-mkfont; then
    grub2-mkfont -o unifont-16.pf2 -s 16 unifont.otf
    grub2-mkfont -o unifont-24.pf2 -s 24 unifont.otf
    grub2-mkfont -o unifont-32.pf2 -s 32 unifont.otf
  fi
}

index_fonts() {
  if [[ -f "$FONTS_DIR/index.txt" ]]; then
    rm "$FONTS_DIR/index.txt"
  fi

  for file in "$FONTS_DIR"/*; do
    if [[ -f "$file" ]] && [[ "$file" == *".pf2" ]]; then
      filename=$(basename "$file")
      echo "$filename" >>"$FONTS_DIR/index.txt"
    fi
  done
}

# ---- main executions ----
make_fonts
index_fonts
