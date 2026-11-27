#!/bin/bash
# install.sh - установка конфигурации bash

set -e

# REPO_ROOT (parent of scripts/)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Bash Configuration Installer ===${NC}"
echo "Setting up modular bash configuration..."

CONFIG_DIR="$HOME/config"
BACKUP_DIR=""

# Backup existing .bashrc
if [ -f ~/.bashrc ]; then
    BACKUP_DIR="$HOME/.bash_backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp ~/.bashrc "$BACKUP_DIR/.bashrc.backup"
    echo -e "${BLUE}Backup created: $BACKUP_DIR/.bashrc.backup${NC}"
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

# Copy .bashrc from repo (replace existing)
if [ -f "$REPO_DIR/.bashrc" ]; then
    cp "$REPO_DIR/.bashrc" ~/.bashrc
    echo -e "${GREEN}✓ .bashrc replaced with repo version${NC}"
else
    echo -e "${YELLOW}⚠ .bashrc not found in repo, keeping existing${NC}"
fi

echo -e "${GREEN}✓ Configuration files copied to $CONFIG_DIR${NC}"

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
chmod +x "$REPO_DIR/scripts/"*.sh 2>/dev/null || true

echo -e "\n${GREEN}=== Installation Complete! ===${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit ~/.bashrc_local to set your machine-specific paths"
echo "2. Reload configuration: source ~/.bashrc"
echo "3. Test with: paths"
echo -e "\n${BLUE}Config directory: $CONFIG_DIR${NC}"
[ -n "$BACKUP_DIR" ] && echo -e "${BLUE}Bashrc backup: $BACKUP_DIR${NC}"
