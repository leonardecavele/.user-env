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

if [ ! -d "$DEST_DIR" ]; then
  log_info "$0" "fonts dest dir does not exist: $DEST_DIR (nothing to uninstall)"
  return
fi

log_info "$0" "uninstalling fonts from: $DEST_DIR"
removed=0
missing=0

delete_font() {
  local f="$1"
  local base
  base="$(basename -- "$f")"

  if [ -f "$DEST_DIR/$base" ]; then
    rm -f -- "$DEST_DIR/$base"
    removed=$((removed + 1))
  else
    missing=$((missing + 1))
  fi
}

for f in "${ttf_files[@]}"; do delete_font "$f"; done
for f in "${otf_files[@]}"; do delete_font "$f"; done

log_info "$0" "$removed fonts removed ($missing not found in dest)"

if command -v fc-cache >/dev/null 2>&1; then
  log_info "$0" "updating font cache..."
  fc-cache -f >/dev/null 2>&1 || fc-cache -f
  log_info "$0" "font cache updated"
else
  log_error "$0" "fc-cache not found; install fontconfig to refresh cache"
fi

log_info "$0" "fonts uninstalled"
