#!/bin/bash

# Variables
LOG_FILE="/var/log/ubuntu_igniter.log"
HISTORY_FILE="/var/log/package_history.log"
PACKAGE_LIST=("apt-transport-https" "ca-certificates" "software-properties-common" "curl" "unzip" "micro" "git" "ufw" "figlet" "bpytop" "mc" "fail2ban" "net-tools" "bat")
INSTALLED_PACKAGES=()
FAILED_PACKAGES=()

# Function to log messages with emojis
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $1" | tee -a $LOG_FILE
}

# Function to handle interruptions (CTRL+C)
cleanup() {
    log_message "❌ Installation interrupted by the user. ❌"
    exit 1
}

# Capture interruptions (CTRL+C)
trap cleanup SIGINT

# Update and upgrade the system
log_message "🔄 Updating and upgrading the system... 🔄"
sudo apt update -y && sudo apt upgrade -y || log_message "⚠️ Update failed. ⚠️"

# Install packages without blocking the script on errors
log_message "📦 Installing packages... 📦"
for package in "${PACKAGE_LIST[@]}"; do
    if dpkg -l | grep -q $package; then
        log_message "✅ $package is already installed."
    else
        log_message "⏳ Installing $package... ⏳"
        if sudo apt install -y $package; then
            log_message "✅ $package successfully installed!"
            INSTALLED_PACKAGES+=($package)
            echo $package >> $HISTORY_FILE
        else
            log_message "⚠️ Failed to install $package. ⚠️"
            FAILED_PACKAGES+=($package)
        fi
    fi
done

# Install and configure eza (modern ls)
log_message "📦 Installing eza (modern ls)... 📦"
if ! command -v eza &> /dev/null; then
    sudo apt install -y gpg || log_message "⚠️ Failed to install gpg for eza setup."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza || log_message "⚠️ Failed to install eza."
    log_message "✅ eza successfully installed!"
else
    log_message "✅ eza is already installed."
fi

# Function to add aliases and configuration to bashrc
modify_user_config() {
    local bashrc_file=$1
    local bash_aliases_file=$2

    # Add aliases if not already present
    if ! grep -q "alias ls=" "$bash_aliases_file"; then
        echo "alias ls='eza -lah -T --git --hyperlink --header'" >> "$bash_aliases_file"
        log_message "✅ Alias 'ls' added to $bash_aliases_file."
    fi

    if ! grep -q "alias cat=" "$bash_aliases_file"; then
        echo "alias cat='batcat'" >> "$bash_aliases_file"
        log_message "✅ Alias 'cat' added to $bash_aliases_file."
    fi

    # Add welcome message to bashrc
    if ! grep -q "Ubuntu Igniter" "$bashrc_file"; then
        echo -e "\n# Ubuntu Igniter Welcome Message\nfiglet -f slant 'Welcome to $HOSTNAME!'" >> "$bashrc_file"
        echo "echo -e '\033[1;32mDefault packages installed: micro, git, curl, ufw, figlet, bpytop, mc, fail2ban, nvm, net-tools.\033[0m'" >> "$bashrc_file"
        echo "echo -e '\033[1;34mFirewall rules:\033[0m'" >> "$bashrc_file"
        echo "echo -e '\033[1;33m- Allow SSH (OpenSSH)\n- Deny all incoming connections\n- Allow all outgoing connections\033[0m'" >> "$bashrc_file"
        echo "echo -e '\033[1;34mUFW Current Status:\033[0m'" >> "$bashrc_file"
        echo "ufw status" >> "$bashrc_file"
        log_message "✅ Welcome message added to $bashrc_file."
    fi
}

# Apply configuration to all users and root
log_message "🔧 Applying configurations for all users and root... 🔧"
for user_dir in /home/*; do
    if [ -d "$user_dir" ]; then
        modify_user_config "$user_dir/.bashrc" "$user_dir/.bash_aliases"
    fi
done

# Modify bashrc and bash_aliases for root
modify_user_config "/root/.bashrc" "/root/.bash_aliases"

# Configure UFW (Firewall)
log_message "🛡️ Configuring UFW (Firewall)... 🛡️"
sudo ufw allow ssh || log_message "⚠️ Failed to configure OpenSSH."
sudo ufw allow OpenSSH || log_message "⚠️ Failed to allow OpenSSH."
sudo ufw default deny incoming || log_message "⚠️ Failed to set default deny incoming."
sudo ufw default allow outgoing || log_message "⚠️ Failed to set default allow outgoing."
sudo ufw --force enable || log_message "⚠️ Failed to enable UFW."

# Configure Fail2Ban
log_message "🚨 Configuring Fail2Ban... 🚨"
sudo systemctl enable fail2ban || log_message "⚠️ Failed to enable Fail2Ban."
sudo systemctl start fail2ban || log_message "⚠️ Failed to start Fail2Ban."

# Save installed package list to a file
log_message "📄 Saving installed package list... 📄"
dpkg --get-selections | grep -v deinstall > $HISTORY_FILE

log_message "🔁 Reloading Bashrc... ♻️"
source ~/.bashrc

# Installation summary
log_message "📊 Installation summary:"
log_message "✅ Successfully installed packages: ${INSTALLED_PACKAGES[*]}"
log_message "⚠️ Failed to install packages: ${FAILED_PACKAGES[*]}"

# Script completion
log_message "🎉 Installation and configuration completed successfully! 🎉"
exit 0
