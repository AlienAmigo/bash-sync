#!/bin/bash
# update.sh - обновление конфигурации

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Updating Bash Configuration ===${NC}"

# Check if git repository
if [ -d .git ]; then
    echo -e "${BLUE}Pulling latest changes from git...${NC}"
    git pull origin main || {
        echo -e "${YELLOW}Warning: Could not pull from git${NC}"
    }
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/config"

# Backup current config
BACKUP_DIR="$HOME/.bash_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r "$CONFIG_DIR" "$BACKUP_DIR/" 2>/dev/null || true
echo -e "${BLUE}Backup created: $BACKUP_DIR${NC}"

# Update config files
echo -e "\n${BLUE}Updating configuration files...${NC}"
cp -r "$REPO_DIR/config/." "$CONFIG_DIR/" 2>/dev/null || {
    echo -e "${YELLOW}Warning: Could not update all files${NC}"
}

# Make sure main.sh is executable
chmod +x "$CONFIG_DIR/main.sh" 2>/dev/null || true

echo -e "\n${GREEN}✓ Update complete!${NC}"
echo -e "${YELLOW}Don't forget to reload: source ~/.bashrc${NC}"
