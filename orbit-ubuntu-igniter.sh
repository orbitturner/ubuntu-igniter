#!/bin/bash

# Variables
LOG_FILE="/var/log/ubuntu_igniter.log"
HISTORY_FILE="/var/log/package_history.log"
PACKAGE_LIST=("apt-transport-https" "ca-certificates" "software-properties-common" "curl" "unzip" "micro" "git" "ufw" "figlet" "bpytop" "mc" "fail2ban" "nvm" "net-tools" "exa" "bat")
INSTALLED_PACKAGES=()
FAILED_PACKAGES=()

# Fonction pour gérer le logging avec emojis
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $1" | tee -a $LOG_FILE
}

# Fonction de nettoyage en cas d'interruption (CTRL+C)
cleanup() {
    log_message "❌ Installation interrompue par l'utilisateur. ❌"
    exit 1
}

# Capture les interruptions (CTRL+C)
trap cleanup SIGINT

# Update et upgrade du système
log_message "🔄 Mise à jour et mise à niveau du système... 🔄"
sudo apt update -y && sudo apt upgrade -y || log_message "⚠️ Mise à jour échouée. ⚠️"

# Installation des packages sans bloquer le script en cas d'erreur
log_message "📦 Installation des packages... 📦"
for package in "${PACKAGE_LIST[@]}"; do
    if dpkg -l | grep -q $package; then
        log_message "✅ $package est déjà installé."
    else
        log_message "⏳ Installation de $package... ⏳"
        if sudo apt install -y $package; then
            log_message "✅ $package a été installé avec succès !"
            INSTALLED_PACKAGES+=($package)
            echo $package >> $HISTORY_FILE
        else
            log_message "⚠️ Échec de l'installation de $package. ⚠️"
            FAILED_PACKAGES+=($package)
        fi
    fi
done

# Configuration des aliases et outils de commande
log_message "⚙️ Configuration des aliases et outils... ⚙️"
if command -v exa &> /dev/null; then
    echo "alias ls='exa -lah -T --git --hyperlink --header'" >> ~/.bash_aliases
    log_message "✅ Alias 'ls' configuré avec exa."
fi

if command -v batcat &> /dev/null; then
    echo "alias cat='batcat'" >> ~/.bash_aliases
    log_message "✅ Alias 'cat' configuré avec bat."
fi

source ~/.bashrc

# Configuration d'UFW (Firewall)
log_message "🛡️ Configuration du firewall avec UFW... 🛡️"
sudo ufw allow ssh || log_message "⚠️ Échec lors de la configuration d'OpenSSH."
sudo ufw allow OpenSSH || log_message "⚠️ Échec lors de l'autorisation OpenSSH."
sudo ufw default deny incoming || log_message "⚠️ Échec lors de la configuration par défaut d'UFW."
sudo ufw default allow outgoing || log_message "⚠️ Échec lors de l'autorisation des connexions sortantes."
sudo ufw --force enable || log_message "⚠️ Échec lors de l'activation d'UFW."

# Configuration de Fail2Ban
log_message "🚨 Configuration de Fail2Ban... 🚨"
sudo systemctl enable fail2ban || log_message "⚠️ Échec lors de l'activation de Fail2Ban."
sudo systemctl start fail2ban || log_message "⚠️ Échec lors du démarrage de Fail2Ban."

# Historiser la configuration dans un fichier
log_message "📄 Génération du fichier de configuration des packages installés... 📄"
dpkg --get-selections | grep -v deinstall > $HISTORY_FILE

# Ajouter une notification dans le bashrc
log_message "🔔 Ajout d'une notification dans le bashrc... 🔔"
if ! grep -q "Ubuntu Igniter" ~/.bashrc; then
    echo -e "\n# Message Ubuntu Igniter\n$(figlet -f slant 'Welcome to $HOSTNAME!')" >> ~/.bashrc
    echo "echo -e '\033[1;32mDefault packages installed: micro, git, curl, ufw, figlet, bpytop, mc, fail2ban, nvm, net-tools.\033[0m'" >> ~/.bashrc
    echo "echo -e '\033[1;34mFirewall rules:\033[0m'" >> ~/.bashrc
    echo "echo -e '\033[1;33m- Allow SSH (OpenSSH)\n- Deny all incoming connections\n- Allow all outgoing connections\033[0m'" >> ~/.bashrc
    echo "echo -e '\033[1;34mUFW Current Status:\033[0m'" >> ~/.bashrc
    echo "ufw status" >> ~/.bashrc
fi


# Récapitulatif de l'installation
log_message "📊 Récapitulatif de l'installation :"
log_message "✅ Packages installés avec succès : ${INSTALLED_PACKAGES[*]}"
log_message "⚠️ Packages ayant échoué : ${FAILED_PACKAGES[*]}"

# Fin du script
log_message "🎉 Installation et configuration terminées avec succès ! 🎉"
exit 0
