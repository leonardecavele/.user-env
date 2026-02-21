FONTS_DIR="$SCRIPT_DIRECTORY/fonts"
DEST_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

shopt -s nullglob
ttf_files=("$FONTS_DIR"/*.ttf)
otf_files=("$FONTS_DIR"/*.otf)
shopt -u nullglob

if [ ${#ttf_files[@]} -eq 0 ] && [ ${#otf_files[@]} -eq 0 ]; then
  log_error "$0" "no .ttf or .otf fonts found in $FONTS_DIR"
  return
fi

mkdir -p "$DEST_DIR"

log_info "$0" "installing fonts to: $DEST_DIR"
count=0

copy_font() {
  local f="$1"
  local base
  base="$(basename -- "$f")"

  if [ -f "$DEST_DIR/$base" ] && cmp -s -- "$f" "$DEST_DIR/$base"; then
    return 0
  fi

  install -m 0644 -- "$f" "$DEST_DIR/$base"
  count=$((count + 1))
}

for f in "${ttf_files[@]}"; do copy_font "$f"; done
for f in "${otf_files[@]}"; do copy_font "$f"; done

log_info "$0" "$count fonts copied/updated"

if command -v fc-cache >/dev/null 2>&1; then
  log_info "$0" "updating font cache..."
  fc-cache -f >/dev/null 2>&1 || fc-cache -f
  log_info "$0" "font cache updated"
else
  log_error "$0" "fc-cache not found; install fontconfig to refresh cache"
fi

log_info "$0" "fonts installed"
