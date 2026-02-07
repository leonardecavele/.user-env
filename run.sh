#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOST_HOME="${HOST_HOME:-$HOME}"

have_sudo_pacman() {
  /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1
}

ensure_bashrc_autojunest() {
  local rc="$HOST_HOME/.bashrc"
  local marker="# auto-enter junest when host lacks sudo/pacman"

  if ! grep -qF "$marker" "$rc" 2>/dev/null; then
    echo "[setup] adding junest auto-enter hook to $rc"
    cat >> "$rc" <<'EOF'

# auto-enter junest when host lacks sudo/pacman
if [ -z "${IN_JUNEST:-}" ]; then
  if ! (/usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1); then
    if command -v junest >/dev/null 2>&1; then
      export IN_JUNEST=1
      exec junest -n "bash -l"
    fi
  fi
fi
EOF
  fi
}

if have_sudo_pacman; then
  echo "sudo + pacman available -> installing on host"
  bash "$ROOT_DIR/scripts/install_env.sh"
else
  echo "sudo and/or pacman not available -> installing junest, then env"
  bash "$ROOT_DIR/scripts/junest.sh"
  bash "$ROOT_DIR/scripts/config.sh"
  ensure_bashrc_autojunest
  echo "[info] open a new terminal (or: source ~/.bashrc) to auto-enter junest"
fi

echo ""
echo "[info] reloading shell"
exec bash -l
