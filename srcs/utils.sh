is_junest() {
  command -v junest >/dev/null 2>&1 \
  && junest --version >/dev/null 2>&1
}

is_pacman() {
  command -v pacman >/dev/null 2>&1
}

is_dnf() {
  command -v dnf >/dev/null 2>&1
}

is_apt() {
  command -v apt >/dev/null 2>&1
}

is_sudo() {
  /usr/bin/sudo -n true >/dev/null 2>&1
}

is_npm() {
  command -v npm >/dev/null 2>&1
}

is_cargo() {
  command -v cargo >/dev/null 2>&1
}

has_junest_repository() {
  [ -d "$JUNEST_REPOSITORY" ]
}

export_in_bashrc() {
  [ -n "${1-}" ] && [ -n "${2-}" ] || return 1

  printf -v VAR '%q' "${2-}"
  if ! grep -qE "^export ${1-}=" "$SCRIPT_DIRECTORY/config/.bashrc"; then
    sed -i "/^# exports$/a export ${1-}=${VAR}" "$SCRIPT_DIRECTORY/config/.bashrc"
  fi
}

clean_bashrc_exports() {
  perl -0777 -i -pe 's/^# exports[ \t]*\R.*?(?=^#)/# exports\n\n/sm'
}

log_info() {
  printf '%b[%s]: (info)%b %s\n' "$YELLOW" "${1-}" "$RESET" "${2-}";
}

log_error()  {
  printf '%b[%s]: (error)%b %s\n' "$RED" "${1-}" "$RESET" "${2-}";
}

usage() {
  cat <<'EOF'
Usage: install_config.sh [OPTION]

Options:
  -i    Install packages and JuNest if needed
  -u    Update download packages
  -d    Delete packages and JuNest if installed
  -h    Show this help
EOF
}

git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$branch"
  fi
}

in_tmux() {
  [ -n "${TMUX:-}" ] || [ "${TERM:-}" = "screen" ] || [ "${TERM:-}" = "screen-256color" ] \
    || [ "${TERM:-}" = "tmux" ] || [ "${TERM:-}" = "tmux-256color" ]
}
