#!/bin/bash
# uninstall.sh - удаление конфигурации

set -e

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}=== Uninstalling Bash Configuration ===${NC}"
echo -e "${YELLOW}This will remove config files but keep backups${NC}"

read -p "Are you sure? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

CONFIG_DIR="$HOME/config"
BACKUP_DIR="$HOME/.bash_backup/latest"

# Create backup
echo -e "\n${BLUE}Creating final backup...${NC}"
mkdir -p "$BACKUP_DIR"
if [ -d "$CONFIG_DIR" ]; then
    cp -r "$CONFIG_DIR" "$BACKUP_DIR/" 2>/dev/null || true
fi
if [ -f ~/.bashrc_local ]; then
    cp ~/.bashrc_local "$BACKUP_DIR/" 2>/dev/null || true
fi

# Remove config directory
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo -e "✓ Removed $CONFIG_DIR"
fi

# Remove config loader from .bashrc
if [ -f ~/.bashrc ]; then
    sed -i '/config\/main.sh/d' ~/.bashrc
    sed -i '/MODULAR CONFIGURATION LOADER/d' ~/.bashrc
    echo -e "✓ Removed config loader from .bashrc"
fi

echo -e "\n${RED}✓ Uninstallation complete!${NC}"
echo "Backups saved to: $BACKUP_DIR"
echo "Local files (~/.bashrc_local) preserved"
