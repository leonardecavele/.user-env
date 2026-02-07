#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# get logger
source "$SCRIPT_DIRECTORY/scripts/log.sh"

# clone junest repository
if [ ! -d "$JUNEST_REPOSITORY" ]; then
  git clone https://github.com/leonardecavele/junest.git "$JUNEST_REPOSITORY"
else
  log_info "junest repository already exists: ${JUNEST_REPOSITORY}"
  exit 0
fi

# setup junest
log_info "installing junest"
"$JUNEST" setup
"$JUNEST" -f -- sudo pacman --noconfirm -Syy
"$JUNEST" -f -- sudo pacman --noconfirm -Sy archlinux-keyring
uid="$(id -u)"
grep -qE "^[^:]+:x:${uid}:" "$HOME/etc/passwd" || \
echo "${user}:x:${uid}:${uid}:${user}:/home/${user}:/bin/bash" >> "$HOME/etc/passwd"
log_info "done installing junest"
