#!/bin/bash
# Main configuration loader for bash settings
# This file sources all other config files in correct order

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${TMPDIR:-/tmp}/bash_config_$(whoami).log"

# ============================================================================
# SECTION 1: LOGGING FUNCTIONS (опционально, но полезно)
# ============================================================================

_log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # В файл (для дебага)
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE" 2>/dev/null

    # В консоль только если это ошибка или включен debug
    if [[ "$level" == "ERROR" && "${BASH_CONFIG_DEBUG:=false}" == "true" ]]; then
        echo "[$level] $message" >&2
    fi
  }

# ============================================================================
# SECTION 2: SAFE SOURCE FUNCTION
# ============================================================================

_safe_source() {
    local file="$1"
  	local module="$2"

    if [[ -f "$file" && -r "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
        _log "LOADED" "$module"
        return 0
    else
        _log "ERROR" "Failed to load $module: $file not found or not readable"
        return 1
    fi
}

# ============================================================================
# SECTION 3: LOAD CONFIGURATION MODULES
# ============================================================================

_log "INFO" "=== Starting bash config load ==="

# Phase 1: Core foundation
_safe_source "$CONFIG_DIR/config.sh" "config"
_safe_source "$CONFIG_DIR/colors.sh" "colors"
_safe_source "$CONFIG_DIR/messages.sh" "messages"
_safe_source "$CONFIG_DIR/helpers.sh" "helpers"

# Phase 2: Paths and environment
_safe_source "$CONFIG_DIR/paths.sh" "paths"

# Phase 3: OS detection and specific config
# Сначала определяем ОС
if [[ -z "$BASH_CONFIG_OS" ]]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        export BASH_CONFIG_OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        export BASH_CONFIG_OS="macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        export BASH_CONFIG_OS="windows"
    else
        export BASH_CONFIG_OS="unknown"
    fi
fi

# Загружаем OS-specific конфиг
if [[ "$BASH_CONFIG_OS" == "windows" ]]; then
    _safe_source "$CONFIG_DIR/os/windows.sh" "windows-config"
elif [[ "$BASH_CONFIG_OS" == "macos" ]]; then
    _safe_source "$CONFIG_DIR/os/macos.sh" "macos-config"
else
    _safe_source "$CONFIG_DIR/os/linux.sh" "linux-config"
fi

# Phase 4: Git configuration
_safe_source "$CONFIG_DIR/git.sh" "git-config"

# Phase 5: Functions and utilities
_safe_source "$CONFIG_DIR/functions.sh" "functions"

# Phase 6: Aliases (loaded last so they can use all previous configs)
_safe_source "$CONFIG_DIR/aliases.sh" "aliases"

# ============================================================================
# SECTION 4: LOAD LOCAL OVERRIDES
# ============================================================================

# Local machine overrides (always last, overrides everything)
if [[ -f "$HOME/.bashrc_local" && -r "$HOME/.bashrc_local" ]]; then
    _log "INFO" "Loading local overrides"
    # shellcheck source=/dev/null
    source "$HOME/.bashrc_local"
    _log "LOADED" "bashrc_local"
fi

# ============================================================================
# SECTION 5: POST-LOAD VALIDATION
# ============================================================================

# Проверяем обязательные переменные
_post_load_validation() {
    local errors=0

    # Проверка PROJECTS_ROOT
    if [[ -z "${PROJECTS_ROOT:-}" ]]; then
        _log "WARN" "PROJECTS_ROOT is not set, using default: $HOME/Projects"
        export PROJECTS_ROOT="$HOME/Projects"
    fi

    # Проверка Git конфигурации
    if [[ -z "${GIT_USER_EMAIL:-}" ]]; then
        _log "WARN" "GIT_USER_EMAIL is not set"
    fi

    # Создаем базовые директории если их нет
    if [[ ! -d "$PROJECTS_ROOT" ]]; then
        _log "INFO" "Creating projects directory: $PROJECTS_ROOT"
        mkdir -p "$PROJECTS_ROOT"
    fi

    return $errors
}

_post_load_validation

# ============================================================================
# SECTION 6: FINALIZATION
# ============================================================================

_log "INFO" "=== Bash config load complete ==="

# Очищаем вспомогательные функции чтобы не засорять пространство имен
unset -f _log
unset -f _safe_source
unset -f _post_load_validation

# Экспортируем переменную что конфиг загружен
export BASH_CONFIG_LOADED="true"
export BASH_CONFIG_LOAD_TIME=$(date +%s)

# Небольшое приветствие если в интерактивной сессии
if [[ $- == *i* ]]; then
    echo -e "\033[0;32m✓ Bash config loaded from: $CONFIG_DIR\033[0m"
    echo -e "  OS: $BASH_CONFIG_OS, Projects: $PROJECTS_ROOT"
fi
