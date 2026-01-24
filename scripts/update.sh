#!/bin/bash
# update.sh - обновление конфигурации

set -e

# REPO_ROOT (parent of scripts/)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/config"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Updating Bash Configuration ===${NC}"

# Check if git repository and pull
if [ -d "$REPO_DIR/.git" ]; then
    echo -e "${BLUE}Pulling latest changes from git...${NC}"
    (cd "$REPO_DIR" && git pull origin main) || {
        echo -e "${YELLOW}Warning: Could not pull from git${NC}"
    }
fi

# Backup current config
BACKUP_DIR="$HOME/.bash_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup .bashrc
if [ -f ~/.bashrc ]; then
    cp ~/.bashrc "$BACKUP_DIR/.bashrc.backup"
fi

# Backup config directory
if [ -d "$CONFIG_DIR" ]; then
    cp -r "$CONFIG_DIR" "$BACKUP_DIR/config" 2>/dev/null || true
fi

echo -e "${BLUE}Backup created: $BACKUP_DIR${NC}"

# Update config files
echo -e "\n${BLUE}Updating configuration files...${NC}"
if [ -d "$REPO_DIR/config" ]; then
    cp -r "$REPO_DIR/config/." "$CONFIG_DIR/" 2>/dev/null || {
        echo -e "${YELLOW}Warning: Could not update all config files${NC}"
    }
else
    echo -e "${RED}Error: config directory not found in repo${NC}"
    exit 1
fi

# Update .bashrc if exists in repo
if [ -f "$REPO_DIR/.bashrc" ]; then
    cp "$REPO_DIR/.bashrc" ~/.bashrc
    echo -e "${GREEN}✓ .bashrc updated with repo version${NC}"
else
    echo -e "${YELLOW}⚠ .bashrc not found in repo, keeping existing${NC}"
fi

# Make sure main.sh is executable
chmod +x "$CONFIG_DIR/main.sh" 2>/dev/null || true

echo -e "\n${GREEN}✓ Update complete!${NC}"
echo -e "${YELLOW}Don't forget to reload: source ~/.bashrc${NC}"
echo -e "${BLUE}Backup saved to: $BACKUP_DIR${NC}"
