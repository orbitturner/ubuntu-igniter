#!/bin/bash

# Variables
LOG_FILE="/var/log/ubuntu_igniter.log"
HISTORY_FILE="/var/log/package_history.log"
PACKAGE_LIST=("ufw" "fail2ban" "mc" "tufw" "python3" "nvm" "curl" "git" "net-tools")
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
log_message "🔄 Mise à jour du système... 🔄"
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

# Configuration d'UFW (Firewall)
log_message "🛡️ Configuration du firewall avec UFW... 🛡️"
sudo ufw allow ssh || log_message "⚠️ Échec lors de la configuration d'OpenSSH."
sudo ufw allow OpenSSH || log_message "⚠️ Échec lors de l'autorisation OpenSSH."
sudo ufw allow 443 || log_message "⚠️ Échec lors de l'autorisation du port 443."
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

# Récapitulatif de l'installation
log_message "📊 Récapitulatif de l'installation :"
log_message "✅ Packages installés avec succès : ${INSTALLED_PACKAGES[*]}"
log_message "⚠️ Packages ayant échoué : ${FAILED_PACKAGES[*]}"

# Fin du script
log_message "🎉 Installation et configuration terminées avec succès ! 🎉"
exit 0
