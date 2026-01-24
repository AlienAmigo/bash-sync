# ===========================================================================
# PATHS AND DIRECTORIES
# ============================================================================

# Base directories
# Windows путь к рабочей папке, переопределить в .bashrc_local если нужно

# These are functions, not variables, to always get current PROJECTS_ROOT
work_root() { echo "${PROJECTS_ROOT:-$HOME/Projects}"; }
personal_root() { echo "${PROJECTS_ROOT:-$HOME/Projects}"; }
exercises_root() { echo "${PROJECTS_ROOT:-$HOME/Projects}/_EX"; }
learning_root() { echo "$(exercises_root)"; }

# Functions for specific paths
marketplace_path() { echo "$(work_root)/stroybase"; }
osmohub_path() { echo "$(marketplace_path)/apps/osmohub"; }
tsus_mobile_path() { echo "$(work_root)/mptsus"; }

# Backward compatibility (export as variables)
export WORK_ROOT="$(work_root)"
export PERSONAL_ROOT="$(personal_root)"
export EXERCISES_ROOT="$(exercises_root)"
export LEARNING_ROOT="$(learning_root)"

# Specific project paths (adjust per machine in .bashrc_local)
export MARKETPLACE_PATH="$(marketplace_path)"
export OSMOHUB_PATH="$(osmohub_path)"
export TSUS_MOBILE_PATH="$(tsus_mobile_path)"
