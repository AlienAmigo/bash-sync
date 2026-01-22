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
cd_safe() {
    if dir_exists "$1"; then
        cd "$1" || return 1
        if [ "${CFG_IS_LOG_ON:=false}" == true ]; then
            echo -e "$MSG_SUCCESS: Changed to $(pwd)"
        fi
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

# Function to show current paths
paths() {
    echo -e "${CL_BLUE}=== Current Paths ===${CL_RESET}"
    echo -e "Projects Root: ${CL_GREEN}${PROJECTS_ROOT}${CL_RESET}"
    echo -e "Work:          ${CL_YELLOW}${WORK_ROOT}${CL_RESET}"
    echo -e "Learning:      ${CL_CYAN}${LEARNING_ROOT}${CL_RESET}"
    echo -e "Exercises:     ${CL_PURPLE}${EXERCISES_ROOT}${CL_RESET}"

    # Existence check
    echo -e "\n${CL_BLUE}=== Existence Check ===${CL_RESET}"
    [ -d "$PROJECTS_ROOT" ] && echo -e "✓ Projects Root" || echo -e "✗ Projects Root"
    [ -d "$WORK_ROOT" ] && echo -e "✓ Work" || echo -e "✗ Work"
    [ -d "$LEARNING_ROOT" ] && echo -e "✓ Learning" || echo -e "✗ Learning"
}

# Function to reload bash config
reload() {
    echo -e "${CL_CYAN}Reloading bash configuration...${CL_RESET}"
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
        echo -e "${CL_GREEN}Configuration reloaded${CL_RESET}"
    else
        echo -e "${CL_RED}Error: ~/.bashrc not found${CL_RESET}"
        return 1
    fi
}

# Function to edit configuration
edit-config() {
    local editor="${EDITOR:-nano}"
    if [ -f ~/.bashrc_local ]; then
        $editor ~/.bashrc_local
    elif [ -f ~/config/main.sh ]; then
        $editor ~/config/main.sh
    else
        $editor ~/.bashrc
    fi
}

# Test bash settings
bash-test () {
    echo "BASH_CONFIG_LOADED: $BASH_CONFIG_LOADED"
    echo "PROJECTS_ROOT: $PROJECTS_ROOT"
    type pro
    type gs
    paths
}
