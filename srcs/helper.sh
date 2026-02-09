# ansi misc
BOLD=$'\033[1m'

# colours
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
RESET=$'\e[0m'
BLUE=$'\e[0;34m'
CYAN=$'\e[0;35m'

# prompt colours
PROMPT_RESET='\[\e[0m\]'
PROMPT_BLUE='\[\033[01;34m\]'
PROMPT_GREEN='\[\033[01;32m\]'
PROMPT_MAGENTA='\[\033[01;91m\]'
PROMPT_YELLOW='\[\033[01;33m\]'
PROMPT_RED='\[\033[01;91m\]'
PROMPT_LIGHT_BLUE='\[\033[01;94m\]'

junest_installed() {
  if [ -d "$JUNEST_REPOSITORY" ]; then
    return 0
  fi
  return 1
}

in_arch() {
  if [ -f /etc/arch-release ] && command -v pacman >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

sudo_pacman_available() {
  if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$branch"
  fi
}

export_in_bashrc() {
  [ -n "$1" ] && [ -n "$2" ] || return 1

  printf -v VAR '%q' "$2"
  if ! grep -qE "^export ${1}=" "$SCRIPT_DIRECTORY/config/.bashrc"; then
    sed -i "/^# variables$/a export ${1}=${VAR}" "$SCRIPT_DIRECTORY/config/.bashrc"
  fi
}

log_info() {
  printf '%b|INFO%b %s\n' "$YELLOW" "$RESET" "$1";
}

log_error()  {
  printf '%b|ERROR%b %s\n' "$RED" "$RESET" "$1" >&2;
}

usage() {
  cat <<'EOF'
Usage: main.sh [OPTION]

Options:
  -s    Set up JuNest (if needed) and install/update packages
  -u    Uninstall downloaded packages
  -r    Remove JuNest and its packages
  -h    Show this help and exit

Examples:
  main.sh -s
  main.sh -u
  main.sh -r
EOF
}
