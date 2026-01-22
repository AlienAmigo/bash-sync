# ============================================================================
# HELPERS FUNCTIONS
# ============================================================================

# Function to check if directory exists
dir_exists() {
    if [ -d "$1" ]; then
        return 0
    else
        echo -e "$MSG_NO_SUCH_FOLDER: $1" >&2
        return 1
    fi
}

# Function to validate and cd to directory
safe_cd() {
    if dir_exists "$1"; then
        cd "$1" || return 1
        echo -e "$MSG_SUCCESS: Changed to $(pwd)"
        return 0
    fi
    return 1
}

# Function to load OS-specific config
load_os_config() {
    local os="$1"
    local config_file="$HOME/.bash_config_$os"

    if [ -f "$config_file" ]; then
        source "$config_file"
        echo -e "$MSG_LOADED: OS-specific config for $os"
    fi
}
