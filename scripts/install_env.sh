#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
HOST_HOME="${HOST_HOME:-$HOME}"

JUNEST_REPO_DIR="${JUNEST_REPO_DIR:-$HOST_HOME/.local/share/junest}"
JUNEST_BIN="$JUNEST_REPO_DIR/bin/junest"

# package list
pkgs=(
  kitty
  neovim
  macchina
  which
  tree
  openssh
  nodejs
  npm
  curl
  git
)

# detect mode + set runner
if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
  echo "mode: host"
  RUN=()
else
  echo "mode: junest"
  if [ ! -x "$JUNEST_BIN" ]; then
    echo "error: junest not found at: $JUNEST_BIN"
    echo "hint: run scripts/install_junest.sh first"
    exit 1
  fi
  RUN=("$JUNEST_BIN" -n)
fi

# update + install pkgs
"${RUN[@]}" sudo pacman -Syu --noconfirm
"${RUN[@]}" sudo pacman -S --noconfirm --needed "${pkgs[@]}"

# pyright (install only if missing)
if ! "${RUN[@]}" npm -g ls pyright >/dev/null 2>&1; then
  "${RUN[@]}" sudo npm i -g --no-fund --no-audit pyright
fi

# link config into HOST home (toujours le host home)
mkdir -p "$HOST_HOME/.config"
ln -svf "$ROOT_DIR/kitty" "$HOST_HOME/.config/" || true
ln -svf "$ROOT_DIR/nvim" "$HOST_HOME/.config/" || true
ln -svf "$ROOT_DIR/macchina" "$HOST_HOME/.config/" || true
ln -svf "$ROOT_DIR/.bashrc" "$HOST_HOME/.bashrc" || true

# vim-plug into HOST home
data_home="${XDG_DATA_HOME:-$HOST_HOME/.local/share}"
plug_path="$data_home/nvim/site/autoload/plug.vim"
if [ ! -f "$plug_path" ]; then
  curl -sfLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
fi

echo ""
echo "[info] open nvim and run :PlugInstall"
