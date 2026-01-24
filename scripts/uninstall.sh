#!/bin/bash
# uninstall.sh - удаление конфигурации

set -e

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
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
BACKUP_DIR="$HOME/.bash_backup"

# Find latest backup
LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)

# Restore .bashrc from latest backup if available
if [ -n "$LATEST_BACKUP" ] && [ -f "$LATEST_BACKUP/.bashrc.backup" ]; then
    cp "$LATEST_BACKUP/.bashrc.backup" ~/.bashrc
    echo -e "${GREEN}✓ Restored .bashrc from backup: $LATEST_BACKUP/.bashrc.backup${NC}"
else
    # Remove config loader from .bashrc (portable sed: macOS vs GNU)
    if [ -f ~/.bashrc ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' '/config\/main.sh/d' ~/.bashrc
            sed -i '' '/MODULAR CONFIGURATION LOADER/d' ~/.bashrc
        else
            sed -i '/config\/main.sh/d' ~/.bashrc
            sed -i '/MODULAR CONFIGURATION LOADER/d' ~/.bashrc
        fi
        echo -e "${YELLOW}✓ Removed config loader from .bashrc${NC}"
    fi
fi

# Create final backup before removal
FINAL_BACKUP="$BACKUP_DIR/uninstall_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$FINAL_BACKUP"
if [ -d "$CONFIG_DIR" ]; then
    cp -r "$CONFIG_DIR" "$FINAL_BACKUP/" 2>/dev/null || true
fi
if [ -f ~/.bashrc_local ]; then
    cp ~/.bashrc_local "$FINAL_BACKUP/" 2>/dev/null || true
fi

# Remove config directory
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo -e "✓ Removed $CONFIG_DIR"
fi

echo -e "\n${RED}✓ Uninstallation complete!${NC}"
echo -e "${BLUE}Final backup saved to: $FINAL_BACKUP${NC}"
if [ -n "$LATEST_BACKUP" ]; then
    echo -e "${BLUE}Previous backups available in: $BACKUP_DIR${NC}"
fi
echo -e "${YELLOW}Local files (~/.bashrc_local) preserved${NC}"
