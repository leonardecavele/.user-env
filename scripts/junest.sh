#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# get library
source "$SCRIPT_DIRECTORY/scripts/lib.sh"

# clone junest repository
if [ ! -d "$JUNEST_REPOSITORY" ]; then
  git clone https://github.com/fsquillace/junest.git "$JUNEST_REPOSITORY"
else
  log_info "junest repository already exists: ${JUNEST_REPOSITORY}"
  exit 0
fi

# setup junest
log_info "installing junest"
"$JUNEST" setup
"$JUNEST" -f -- sudo pacman --noconfirm -Syy
"$JUNEST" -f -- sudo pacman --noconfirm -Sy archlinux-keyring
log_info "done installing junest"
