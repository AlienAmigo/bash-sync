#!/bin/bash
# Linux-specific configuration

# System commands
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'

# System info
alias disks='df -h'
alias meminfo='free -m -l -t'

# Service management
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias status='sudo systemctl status'

# Package management
alias search='apt search'
alias show='apt show'

# Permissions
alias fixperm='sudo chmod -R 755'
alias fixowner='sudo chown -R $USER:$USER'

# Detect Ubuntu
if [ -f /etc/lsb-release ]; then
    source /etc/lsb-release
    if [[ "$DISTRIB_ID" == "Ubuntu" ]]; then
        export IS_UBUNTU=true
        # Ubuntu-specific settings
        alias ubuntu-update='sudo apt update && sudo apt dist-upgrade -y'
    fi
fi
