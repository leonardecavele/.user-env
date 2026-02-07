#!/usr/bin/env bash

RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
RESET=$'\e[0m'

log_info() { printf '[INFO] %b%s%b\n' "$YELLOW" "$1" "$RESET"; }
log_error()  { printf '[ERROR] %b%s%b\n' "$RED" "$1" "$RESET" >&2; }
