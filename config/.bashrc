# only for interactive shells
case "$-" in
  *i*) ;;
  *) return ;;
esac

HOST_HOME="$HOME"
JUNEST_BIN_DIR="$HOST_HOME/.local/share/junest/bin"
JUNEST_WRAPPERS="$HOST_HOME/.junest/usr/bin_wrappers"

# make junest discoverable early (without changing priority too much)
if [ -d "$JUNEST_BIN_DIR" ]; then
  export PATH="$PATH:$JUNEST_BIN_DIR"
fi

# detect if we're already inside junest (reliable)
IN_JUNEST_SHELL=0
PACMAN_PATH="$(command -v pacman 2>/dev/null || true)"

if [ -n "${JUNEST_HOME:-}" ] || [ -n "${JUNEST_ROOT:-}" ]; then
  IN_JUNEST_SHELL=1
elif [ -n "$PACMAN_PATH" ] && [ -n "$JUNEST_WRAPPERS" ]; then
  case "$PACMAN_PATH" in
    "$JUNEST_WRAPPERS"/*) IN_JUNEST_SHELL=1 ;;
  esac
fi

# if in junest, put wrappers first (so nvim inherits correct PATH)
if [ "$IN_JUNEST_SHELL" -eq 1 ]; then
  export PATH="$JUNEST_WRAPPERS:$JUNEST_BIN_DIR:$PATH"
  hash -r
fi

# auto-enter junest when host lacks sudo/pacman
# do it only if NOT already inside junest
if [ "$IN_JUNEST_SHELL" -eq 0 ] && [ -z "${IN_JUNEST:-}" ]; then
  if ! (/usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1); then
    if command -v junest >/dev/null 2>&1; then
      if [ -x "$HOME/.junest/usr/bin/bash" ] || [ -d "$HOME/.junest/usr/bin" ]; then
        # IMPORTANT: set IN_JUNEST inside the exec'ed bash too (junest may sanitize env)
        if [ -x /usr/bin/bash ]; then
          exec junest -n env IN_JUNEST=1 /usr/bin/bash -i
        elif [ -x /bin/bash ]; then
          exec junest -n env IN_JUNEST=1 /bin/bash -i
        else
          exec junest -n env IN_JUNEST=1 sh -i
        fi
      else
        echo "[junest] image not installed: run 'junest setup' once"
      fi
    fi
  fi
fi

# colors
RESET="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\033[01;32m\]"
MAGENTA="\[\033[01;91m\]"

# func
git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$branch"
  fi
}

# alias
alias ra='rm a.out'
alias c='cc -Wall -Wextra -Werror'
alias n='norminette -R CheckForbiddenSourceHeader'
alias ll='ls -la'
alias vim='nvim'
alias py='python3'
alias p='python3'

# prompt
shopt -s checkwinsize
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

PROMPT_COMMAND='rc=$?; printf "[%d] " "$rc"'
PS1="${GREEN}\u@\h ${BLUE}\W${MAGENTA} \$(git_branch)\n${RESET}\$ "

unset color_prompt force_color_prompt
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias func='grep -rE "[a-z_]+\([a-z_0-9,\* ]*\)"'

# NVM https://github.com/nvm-sh/nvm.git
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# CARGO
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if [[ -z "${MACHINE_ALREADY_SHOWN:-}" ]]; then
  export MACHINE_ALREADY_SHOWN=1
  macchina --config ~/.config/macchina/macchina.toml
fi

cd ~/
