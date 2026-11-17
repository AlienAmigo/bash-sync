# ===========================================================================
# PATHS AND DIRECTORIES
# ============================================================================

# Base directories
# Windows путь к рабочей папке, переопределить в .bashrc_local если нужно

# These are functions, not variables, to always get current PROJECTS_ROOT.
# Defined only if missing: main.sh re-sources this file after .bashrc_local,
# and a local override of any *_root / *_path function must survive that.
if ! type work_root >/dev/null 2>&1; then
    work_root() { echo "${PROJECTS_ROOT:-$HOME/Projects}"; }
fi
if ! type personal_root >/dev/null 2>&1; then
    personal_root() { echo "${PROJECTS_ROOT:-$HOME/Projects}"; }
fi
if ! type exercises_root >/dev/null 2>&1; then
    exercises_root() { echo "${PROJECTS_ROOT:-$HOME/Projects}/_EX"; }
fi
if ! type learning_root >/dev/null 2>&1; then
    learning_root() { exercises_root; }
fi

# Functions for specific paths
if ! type marketplace_path >/dev/null 2>&1; then
    marketplace_path() { echo "$(work_root)/stroybase"; }
fi
if ! type osmohub_path >/dev/null 2>&1; then
    osmohub_path() { echo "$(marketplace_path)/apps/osmohub"; }
fi
if ! type tsus_mobile_path >/dev/null 2>&1; then
    tsus_mobile_path() { echo "$(work_root)/mptsus"; }
fi

# Backward compatibility (export as variables)
WORK_ROOT="$(work_root)"
PERSONAL_ROOT="$(personal_root)"
EXERCISES_ROOT="$(exercises_root)"
LEARNING_ROOT="$(learning_root)"
export WORK_ROOT PERSONAL_ROOT EXERCISES_ROOT LEARNING_ROOT

# Specific project paths (adjust per machine in .bashrc_local)
MARKETPLACE_PATH="$(marketplace_path)"
OSMOHUB_PATH="$(osmohub_path)"
TSUS_MOBILE_PATH="$(tsus_mobile_path)"
export MARKETPLACE_PATH OSMOHUB_PATH TSUS_MOBILE_PATH
