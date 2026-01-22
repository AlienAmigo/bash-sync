#!/bin/bash
# Git configuration

# Git user (override in .bashrc_local)
export GIT_USER_NAME="${GIT_USER_NAME:-Your Name}"
export GIT_USER_EMAIL="${GIT_USER_EMAIL:-your.email@example.com}"

# Git core settings
export GIT_PAGER="less -FRX"
export GIT_EDITOR="${EDITOR:-nano}"

# Git completion
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
elif [ -f /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
fi

# Git prompt function (for PS1)
if ! command -v __git_ps1 &>/dev/null; then
    __git_ps1() {
        local branch
        branch=$(git branch 2>/dev/null | grep '^\*' | cut -d' ' -f2-)
        if [ -n "$branch" ]; then
            echo " ($branch)"
        fi
    }
fi

# Добавить после GIT_EDITOR:
export EDITOR="${EDITOR:-nano}"  # Make EDITOR available globally
