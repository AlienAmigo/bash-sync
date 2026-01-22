#!/bin/bash
# install.sh - установка конфигурации bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Bash Configuration Installer ===${NC}"
echo "Setting up modular bash configuration..."

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
    CONFIG_DIR="$HOME/config"
else
    OS="linux"
    CONFIG_DIR="$HOME/config"
fi

# Create config directory
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/os"

echo -e "\n${BLUE}Copying configuration files...${NC}"

# Copy all config files
cp -r "$REPO_DIR/config/." "$CONFIG_DIR/" 2>/dev/null || {
    echo -e "${RED}Error: Cannot copy config files${NC}"
    exit 1
}

echo -e "${GREEN}✓ Configuration files copied to $CONFIG_DIR${NC}"

# Update .bashrc if needed
echo -e "\n${BLUE}Updating .bashrc...${NC}"

if grep -q "config/main.sh" ~/.bashrc; then
    echo -e "${YELLOW}✓ .bashrc already has config loader${NC}"
else
    cat >> ~/.bashrc << 'EOF'

# ============================================================================
# MODULAR CONFIGURATION LOADER
# ============================================================================
if [ -f ~/config/main.sh ]; then
    source ~/config/main.sh
fi
EOF
    echo -e "${GREEN}✓ Added config loader to .bashrc${NC}"
fi

# Create .bashrc_local template if doesn't exist
if [ ! -f ~/.bashrc_local ]; then
    cat > ~/.bashrc_local << 'EOF'
# ~/.bashrc_local
# Machine-specific configuration (NOT synced via git)

# Uncomment and adjust for this machine:
# export PROJECTS_ROOT="$HOME/Projects"  # Linux/Mac
# export PROJECTS_ROOT="/c/Users/$USERNAME/Projects"  # Windows Git Bash
# export PROJECTS_ROOT="/d/Project"  # Windows with D: drive

# Git configuration
# export GIT_USER_NAME="Your Name"
# export GIT_USER_EMAIL="your.email@example.com"

# Local aliases
# alias mymachine='echo "This is my personal machine"'

echo -e "\033[0;33mLocal configuration loaded\033[0m"
EOF
    echo -e "${GREEN}✓ Created ~/.bashrc_local template${NC}"
fi

# Make scripts executable
chmod +x "$CONFIG_DIR/main.sh" 2>/dev/null || true
chmod +x "$REPO_DIR/install.sh" 2>/dev/null || true

echo -e "\n${GREEN}=== Installation Complete! ===${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit ~/.bashrc_local to set your machine-specific paths"
echo "2. Reload configuration: source ~/.bashrc"
echo "3. Test with: paths"
echo -e "\n${BLUE}Current project root: $CONFIG_DIR${NC}"
