#!/bin/bash
# tests/smoke.sh — smoke test: the config loads without errors and the
# core mechanics (OS detection, aliases, path overrides) work.
#
# Fully isolated: everything runs with a fake HOME in a temp directory,
# the real home directory is never touched.
#
# Usage: bash tests/smoke.sh   (exit code 0 = all checks passed)

set -u

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAIN="$REPO_DIR/config/main.sh"

TMP_HOME="$(mktemp -d "${TMPDIR:-/tmp}/bash-sync-smoke.XXXXXX")"
trap 'rm -rf "$TMP_HOME"' EXIT

pass=0
fail=0

report_ok() {
    echo "ok   - $1"
    pass=$((pass + 1))
}

report_fail() {
    echo "FAIL - $1"
    fail=$((fail + 1))
}

# check <description> <expected stdout> <script>
# Runs the script in a clean bash with the fake HOME, compares stdout.
check() {
    local desc="$1" expected="$2" script="$3"
    local out
    out="$(HOME="$TMP_HOME" bash -c "$script" 2>/dev/null)"
    if [ "$out" = "$expected" ]; then
        report_ok "$desc"
    else
        report_fail "$desc"
        echo "       expected: [$expected]"
        echo "       got:      [$out]"
    fi
}

# check_no_stderr <description> <script>
# Fails if the script writes anything to stderr.
check_no_stderr() {
    local desc="$1" script="$2"
    local err
    err="$(HOME="$TMP_HOME" bash -c "$script" 2>&1 >/dev/null)"
    if [ -z "$err" ]; then
        report_ok "$desc"
    else
        report_fail "$desc"
        echo "       stderr: $err"
    fi
}

echo "=== bash-sync smoke test ==="
echo "repo: $REPO_DIR"
echo "fake HOME: $TMP_HOME"
echo

# --- Load ---

check "config loads and sets BASH_CONFIG_LOADED" "true" \
    "source '$MAIN'; echo \$BASH_CONFIG_LOADED"

check_no_stderr "load produces no errors on stderr" \
    "source '$MAIN'"

# --- OS detection ---

case "$OSTYPE" in
    linux-gnu*)        want_os="linux" ;;
    darwin*)           want_os="macos" ;;
    msys|cygwin|win32) want_os="windows" ;;
    *)                 want_os="unknown" ;;
esac
check "OS auto-detection ($OSTYPE)" "$want_os" \
    "source '$MAIN'; echo \$BASH_CONFIG_OS"

check "preset BASH_CONFIG_OS is respected" "macos" \
    "export BASH_CONFIG_OS=macos; source '$MAIN'; echo \$BASH_CONFIG_OS"

# --- Modules ---

check "aliases defined (pro, gs)" "ok" \
    "source '$MAIN'; alias pro >/dev/null && alias gs >/dev/null && echo ok"

check "helper functions defined (cd_safe, paths)" "ok" \
    "source '$MAIN'; type cd_safe >/dev/null && type paths >/dev/null && echo ok"

check "git prompt function available (__git_ps1)" "ok" \
    "source '$MAIN'; type __git_ps1 >/dev/null && echo ok"

# --- Paths ---

check "default PROJECTS_ROOT falls back to ~/Projects" "$TMP_HOME/Projects" \
    "source '$MAIN'; echo \$PROJECTS_ROOT"

printf 'export PROJECTS_ROOT="/custom/projects"\n' > "$TMP_HOME/.bashrc_local"
check "local PROJECTS_ROOT override applies" "/custom/projects" \
    "source '$MAIN'; echo \$PROJECTS_ROOT"
check "derived paths recompute from local override" "/custom/projects/_EX" \
    "source '$MAIN'; echo \$EXERCISES_ROOT"
check "project paths recompute too" "/custom/projects/stroybase/apps/osmohub" \
    "source '$MAIN'; echo \$OSMOHUB_PATH"

printf 'marketplace_path() { echo "/special/place"; }\n' > "$TMP_HOME/.bashrc_local"
check "path function override in .bashrc_local" "/special/place" \
    "source '$MAIN'; echo \$MARKETPLACE_PATH"

rm -f "$TMP_HOME/.bashrc_local"

# --- Robustness ---

check "double load (reload) stays healthy" "true" \
    "source '$MAIN'; source '$MAIN'; echo \$BASH_CONFIG_LOADED"

mkdir -p "$TMP_HOME/somedir"
check "cd_safe enters existing dir" "$TMP_HOME/somedir" \
    "source '$MAIN'; cd_safe '$TMP_HOME/somedir' >/dev/null && pwd"
check "cd_safe refuses missing dir" "fail" \
    "source '$MAIN'; cd_safe '/nonexistent-bash-sync-smoke' >/dev/null 2>&1 || echo fail"

# --- Summary ---

echo
echo "=== passed: $pass, failed: $fail ==="
[ "$fail" -eq 0 ]
