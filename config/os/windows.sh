#!/bin/bash
# Windows-specific configuration

# Detect if we're in Git Bash
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows paths
    export SYSTEM_DRIVE="/c"
    export USER_PROFILE="$SYSTEM_DRIVE/Users/$USERNAME"

    # Git Bash specific
    export PATH="$PATH:/c/Program Files/Git/usr/bin"

    # Aliases for Windows executables
    alias explorer="explorer.exe"
    alias notepad="notepad.exe"
    alias code="code.exe"

    # Convert paths
    winpath() {
        cygpath -w "$1"
    }

    # WSL integration if available
    if command -v wsl.exe &>/dev/null; then
        alias wsl="wsl.exe"
    fi
fi

# Cmder detection
if [[ -n "$CMDER_ROOT" ]]; then
    export IS_CMDER=true
    # Cmder-specific settings
    alias cmder="cd '$CMDER_ROOT'"
fi
