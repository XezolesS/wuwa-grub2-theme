#!/usr/bin/env bash

# Load themes from given directory.
# Also provides utility functions for it.
# Usage: source ./load-theme.sh <directory>
#
# params:
# $1: directory to search for
#
# returns:
# $THEME_VARIANTS

THEME_VARIANTS=('none')

# loads themes, only png files are allowed.
for file in "$1"/*; do
  if [[ -f "$file" ]] && [[ $file == *".png" ]]; then
    filename=$(basename "$file")
    THEME_VARIANTS+=("${filename%.png}")
  fi
done

# ---- functions ----

# check if THEME_VARIANTS is empty.
#
# return:
# 0: false, not empty, 1: true, empty
is_theme_empty() {
  if (("${#THEME_VARIANTS[@]}" == 1)); then
    return 1
  else
    return 0
  fi
}

# echo theme index from given string
#
# params:
# $1: theme name to search for
#
# return:
# 0: success, 1: failed, not found
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
