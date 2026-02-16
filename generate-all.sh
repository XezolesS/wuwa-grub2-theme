#! /usr/bin/env bash

REO_DIR="$(cd $(dirname $0) && pwd)"
BG_DIR="$REO_DIR/backgrounds"

SCREEN_VARIANTS=('1080p' '2k' '4k')
THEME_VARIANTS=()

# Load themes from ./backgrounds
for file in "$BG_DIR"/*; do
  if [[ -f "$file" ]] && [[ $file == *.png ]]; then
    filename=$(basename $file)
    THEME_VARIANTS+=(${filename%.png})
  fi
done

echo $THEME_VARIANTS

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d | --dest)
      dest="${2}"
      shift 2
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
  screens=("${SCREEN_VARIANTS[0]}")
fi

for theme in "${THEME_VARIANTS[@]}"; do
  for screen in "${screens[@]}"; do
    echo "./generate.sh -t $theme -s $screen -d $dest"
    ./generate.sh -t "${theme}" -s "${screen}" -d "${dest}"
  done
done