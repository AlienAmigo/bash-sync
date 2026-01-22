# ~/.bashrc: executed by bash(1) for non-login shells.
# ============================================================================
# SECTION 1: BASIC SHELL SETTINGS
# ============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration
HISTCONTROL=ignoreboth           # Don't save duplicate lines or lines starting with space
shopt -s histappend              # Append to history file instead of overwriting
HISTSIZE=1000                    # Number of commands in memory
HISTFILESIZE=2000                # Number of commands in history file

# Shell behavior
shopt -s checkwinsize            # Update LINES/COLUMNS after each command
# shopt -s globstar              # Enable ** pattern matching (uncomment if needed)

# Lesspipe for non-text files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ============================================================================
# SECTION 2: TERMINAL AND PROMPT SETTINGS
# ============================================================================

# Debian chroot indicator
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Color prompt detection
color_prompt=
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Force color prompt if requested
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Default prompt (fallback if modular config fails)
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Terminal window title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ============================================================================
# SECTION 3: SYSTEM TOOLS AND EXTERNAL DEPENDENCIES
# ============================================================================

# nvm (Node Version Manager) - must load before any Node.js commands
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm completions

# SSH agent management
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
fi
ssh-add -l &>/dev/null || ssh-add

# JetBrains IDE VM options
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then
    . "${___MY_VMOPTIONS_SHELL_FILE}"
fi

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ============================================================================
# SECTION 4: PATH CONFIGURATION
# ============================================================================

# Global npm packages
export PATH="${PATH}:${HOME}/.npm-packages"

# Android Studio SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# ============================================================================
# SECTION 5: MODULAR CONFIGURATION LOADER
# ============================================================================

# Check if we're in development mode (config in project folder)
DEV_CONFIG_DIR="/d/Project/bash_settings/config"
if [ -f "$DEV_CONFIG_DIR/main.sh" ] && [ "$PWD" = "/d/Project/bash_settings" ]; then
    # Development mode: load from project directory
    export BASH_CONFIG_DEBUG=true
    export CONFIG_DIR="$DEV_CONFIG_DIR"
    source "$DEV_CONFIG_DIR/main.sh"
    echo -e "\033[0;33m[DEV] Loaded config from: $DEV_CONFIG_DIR\033[0m"

elif [ -f ~/config/main.sh ]; then
    # Production mode: load from home directory
    CONFIG_DIR="$HOME/config"
    if [ -L "$CONFIG_DIR" ]; then
        # If it's a symlink, follow it
        CONFIG_DIR="$(readlink -f "$CONFIG_DIR")"
    fi
    source "$CONFIG_DIR/main.sh"

elif [ -f ~/.bash_config ]; then
    # Legacy configuration (backward compatibility)
    source ~/.bash_config
    echo -e "\033[0;33m[LEGACY] Using old .bash_config format\033[0m"
fi

# ============================================================================
# SECTION 6: FINAL PROMPT SETUP (AFTER CONFIG LOAD)
# ============================================================================

# Build PS1 after config is loaded to use color variables
# This ensures $CL_* variables are available if colors.sh was loaded
if [ -n "${BASH_CONFIG_LOADED:-}" ] && [ "$BASH_CONFIG_LOADED" = "true" ]; then
    # Only setup fancy PS1 if config was loaded successfully
    SYMBOL_ARROW='▶'

    # Check if color variables are available
    if [ -n "${CL_RESET:-}" ] && [ -n "${CL_GREEN_BOLD_BRIGHT:-}" ]; then
        # Build PS1 with colors from config
        SYMBOL_ARROW='▶'

        PS1_2STRINGS="$CL_GREEN_BOLD_BRIGHT"'\u'"$CL_GREEN_BRIGHT"'@\h '"$CL_WHITE"'\w'"$CL_CYAN_BOLD_BRIGHT"'$(__git_ps1)'
        PS1_2STRINGS+=$'\n'
        PS1_2STRINGS+="$CL_GREEN"'└─ $ '"$SYMBOL_ARROW""$CL_WHITE_BRIGHT"' '

        # show branch
        # с переносом строки
        PS1=$PS1_2STRINGS
    fi
fi

# ============================================================================
# SECTION 7: FALLBACK SETTINGS (if config fails to load)
# ============================================================================

# If config didn't load, set minimal essential aliases
if [ -z "${BASH_CONFIG_LOADED:-}" ] || [ "$BASH_CONFIG_LOADED" != "true" ]; then
    # Essential aliases only
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # Basic path for dircolors
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi
fi

# ============================================================================
# SECTION 8: SSH-AGENT
# ============================================================================
eval $(ssh-agent -s)
# pro
# if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval "$(ssh-agent -s)"
# fi

# ssh-add -l &>/dev/null || ssh-add

for key in ~/.ssh/*.pub; do
    private_key="${key%.*}"
    if [[ ! -f "$private_key" ]]; then
        continue
    fi
    ssh-add "$private_key"
done

# ============================================================================
# END OF .bashrc
# ============================================================================
