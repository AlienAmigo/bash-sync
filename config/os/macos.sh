#!/bin/bash
# macOS-specific configuration

# macOS specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# Brew if available
if command -v brew &>/dev/null; then
    export HOMEBREW_NO_AUTO_UPDATE=1
    alias brewup='brew update && brew upgrade && brew cleanup'
fi

# macOS specific paths
export PATH="/usr/local/bin:$PATH"
